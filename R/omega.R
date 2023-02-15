#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.ome <- function(x) {
  .x <- x
  class(.x) <- NULL
  .ini <- .nonmem2rx$ini
  .nonmem2rx$ini <- NULL
  .Call(`_nonmem2rx_omeganum_reset`)
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_omega`, .cur, "eta")
  }
  .nonmem2rx$omega <- .nonmem2rx$ini
  .nonmem2rx$ini <- c(.ini, .nonmem2rx$ini)
}

#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.sig <- function(x) {
  .x <- x
  class(.x) <- NULL
  .ini <- .nonmem2rx$ini
  .etaMax <- .nonmem2rx$etaMax
  .nonmem2rx$etaMax <- 0L
  .nonmem2rx$ini <- NULL
  .Call(`_nonmem2rx_omeganum_reset`)
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_omega`, .cur, "eps")
  }
  .nonmem2rx$sigma <- .nonmem2rx$ini
  .nonmem2rx$ini <- .ini
  .nonmem2rx$etaMax <- .etaMax
}
#' Get the omega label based on the associated comment in NONMEM
#'
#' @param comment Omega comment
#' @return Label
#' @noRd
#' @author Matthew L. Fidler
.getOmegaLabel <- function(comment) {
  .prefixGobble <- " *;+ *(bsv|BSV|Bsv|iiv|Iiv|IIV|Eta|eta|ETA|Eps|eps|EPS) +"
  if (regexpr(.prefixGobble, comment) != -1) {
    comment <- sub(.prefixGobble, "; \\1.", comment)
  }
  .reg1 <- ";.*?([A-Za-z][A-Za-z0-9_.]*).*"
  if (regexpr(.reg1, comment) != -1) {
    comment <- sub(.reg1, "\\1", comment)
  } else {
    comment <- ""
  }
  comment
}
#'  Add omega parameter comment to `.nonmem2rx` environment
#'  
#' @param comment comment for the Omega parameter
#' @param prefix Prefix of parameter names (currently eta or eps)
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addOmegaComment <- function(comment, prefix) {
  .prefixComment <- paste0(prefix,"Comment")
  .prefixLabel <- paste0(prefix,"Label")
  assign(.prefixComment, c(get(.prefixComment, envir=.nonmem2rx),
                           comment),
         envir = .nonmem2rx)
  assign(.prefixLabel, c(get(.prefixLabel, envir=.nonmem2rx),
                         .getOmegaLabel(comment)),
         envir = .nonmem2rx)
  invisible()
}
#'  Add omega parameter comment to `.nonmem2rx` environment
#'
#' @param comment comment for the Omega parameter
#' @param prefix Prefix of parameter names (currently eta or eps)
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addOmegaLabel <- function(label, prefix) {
  .prefixLabel <- paste0(prefix,"NonmemLabel")
  assign(.prefixLabel, c(get(.prefixLabel, envir=.nonmem2rx),
                         label),
         envir = .nonmem2rx)
  invisible()
}
#' Get the eta number
#'
#' @param v string
#' @return the number (as a string)
#' @noRd
#' @author Matthew L. Fidler
.getEtaNum <- function(v) {
  .w <- which(tolower(v) == tolower(.nonmem2rx$etaNonmemLabel))
  if (length(.w) == 1L) return(paste(.w))
  stop(paste0("cannot uniquely determine ETA(", v, ")"), call.=FALSE)
}
#' Get the eps number
#'
#' @param v string
#' @return the number (as a string)
#' @noRd
#' @author Matthew L. Fidler
.getEpsNum <- function(v) {
  .w <- which(tolower(v) == tolower(.nonmem2rx$epsNonmemLabel))
  if (length(.w) == 1L) return(paste(.w))
  stop(paste0("cannot uniquely determine EPS(", v, ")"), call.=FALSE)
}
#' Add omega/sigma ini statement
#'
#' This will convert to the covariance matrix before adding the
#' initial estimates
#'
#' @param ini Ini statement from nonmem
#' @param sd integer representing if the diagonals are standard
#'   deviations (0L=FALSE)
#' @param cor integer representing if the off-diagonals are
#'   correlations (0L=FALSE)
#' @param chol integer representing if the omega is actually a
#'   Cholesky decomposition
#' @return Nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addOmega <- function(ini, sd, cor, chol) {
  if (sd == 0L && cor == 0L && chol == 0L) .addIni(ini)
  .ini <- eval(parse(text=paste0("lotri::lotri(",ini,")")))
  .dn <- dimnames(.ini)
  if (cor != 0L) {
    # correlation matrix
    .d <- diag(.ini)
    if (sd == 0L) {
      .d <- sqrt(.d) # change to sd
    }
    diag(.ini) <- 1
    .D <- diag(length(.d))
    diag(.D) <- .d
    .ini <- .D %*% .ini %*% .D
    dimnames(.ini) <- .dn
    class(.ini) <- c("lotriFix", class(.ini))
    .exp <-as.expression(.ini)
    .addIni(deparse1(.exp[[2]][[2]]))
    return(invisible())
  } else if (sd != 0L) {
    # covariance + sd
    # convert sd to variance
    .d <- diag(.ini)^2
    diag(.ini) <- .d
    dimnames(.ini) <- .dn
    class(.ini) <- c("lotriFix", class(.ini))
    .exp <-as.expression(.ini)
    .addIni(deparse1(.exp[[2]][[2]]))
  } else if (chol != 0L) {
    # cholesky to cov
    .ini <- .ini %*% t(.ini)
    dimnames(.ini) <- .dn
    class(.ini) <- c("lotriFix", class(.ini))
    .exp <-as.expression(.ini)
    .addIni(deparse1(.exp[[2]][[2]]))
  }
}
#' This handles NONMEM's $omega block(n) value(diaVal, odiag) statement
#'
#' @param n The dimension of the block matrix
#' @param diagVal The diagonal value
#' @param odiag The off diagonal value
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.pushOmegaBlockNvalue <- function(n, diagVal, odiag,
                                  prefix, num) {
  .dim <- paste0(prefix, seq_len(n)+num-1)
  .dim <- list(.dim, .dim)
  .ret <- matrix(rep(as.numeric(odiag), n*n), n,n)
  diag(.ret) <- rep(as.numeric(diagVal), n)
  dimnames(.ret) <- .dim
  class(.ret) <- c("lotriFix", class(.ret))
  .exp <-as.expression(.ret)
  .addIni(deparse1(.exp[[2]][[2]]))
  lapply(seq_len(n), function(...){
    .addOmegaComment("", prefix)
  })
  invisible()
}
