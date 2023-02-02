#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.ome <- function(x) {
  .x <- x
  class(.x) <- NULL
  .Call(`_nonmem2rx_omeganum_reset`)
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_omega`, .cur, "eta")
  }
}

#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.sig <- function(x) {
  .x <- x
  class(.x) <- NULL
  .ini <- .nonmem2rx$ini
  .nonmem2rx$ini <- NULL
  .Call(`_nonmem2rx_omeganum_reset`)
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_omega`, .cur, "eps")
  }
  .nonmem2rx$sigma <- .nonmem2rx$ini
  .nonmem2rx$ini <- .ini
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
#'  
#' @param comment comment for the Omega parameter
#' @param prefix Prefix of parameter names (currently eta or eps)
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addOmegaComment <- function(comment, prefix) {
  .prefixComment <- paste0(prefix,"Comment")
  .prefixLabel <- paste0(prefix,"Label")
  if (!exists(.prefixComment, envir=.nonmem2rx)) assign(.prefixComment, NULL, envir=.nonmem2rx)
  assign(.prefixComment, c(get(.prefixComment, envir=.nonmem2rx),
                           comment),
         envir = .nonmem2rx)
  if (!exists(.prefixLabel, envir=.nonmem2rx)) assign(.prefixLabel, NULL, envir=.nonmem2rx)
  assign(.prefixLabel, c(get(.prefixLabel, envir=.nonmem2rx),
                         .getOmegaLabel(comment)),
         envir = .nonmem2rx)
  invisible()
}
