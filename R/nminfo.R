#' Get the most accurate information you can get from NONMEM  
#'
#'  
#' @param file nonmem file, like control stream, phi.  This function
#'   will remove the extension to try to get the right information.
#'   It preferentially selects the most accurate estimates from the
#'   file.
#' @return list of NONMEM information
#' @export
#' @author Matthew L. Fidler
#' @examples
#' nminfo(system.file("mods/cpt/runODE032.res", package="nonmem2rx"))
nminfo <- function(file,
                   xml=".xml", ext=".ext", cov=".cov", phi=".phi", lst=".lst",
                   useXml = TRUE, useExt = TRUE, useCov=TRUE, usePhi=TRUE, useLst=TRUE,
                   strictLst=FALSE) {
  # xml output can be buggy and not well formed for some nonmem implementations, so skip if necessary
  # for theta, omega, and sigma the xml is more accurate than ext file output
  .base <- tools::file_path_sans_ext(file)
  .uses <- NULL
  .ret <- list(theta=NULL,
               omega=NULL,
               sigma=NULL,
               cov=NULL,
               objf=NULL,
               nobs=NULL,
               nsub=NULL,
               nmtran=NULL,
               termInfo=NULL,
               nonmem=NULL,
               time=NULL,
               tere=NULL,
               control=NULL,
               eta=NULL,
               uses=NULL)
  .xmlFile <- paste0(.base, xml)
  .hasXml <- FALSE
  if (useXml && file.exists(.xmlFile)) {
    .xml <- nmxml(.xmlFile)
    if (inherits(.xml, "list")) {
      .hasXml <- TRUE
      .ret$theta <- .xml$theta
      .ret$omega <- .xml$omega
      .ret$sigma <- .xml$sigma
      .ret$cov <- .xml$cov
      .ret$objf <- .xml$objf
      .ret$nobs <- .xml$nobs
      .ret$nsub <- .xml$nsub
      .ret$nmtran <- .xml$nmtran
      .ret$termInfo <- .xml$termInfo
      .ret$nonmem <- .xml$nonmem
      .ret$time <- .xml$time
      .ret$control <- .xml$control
      .uses <- "xml"
    }
  }
  # for theta, omega, and sigma the ext file is more accurate than the lst file
  .hasExt <- FALSE
  if (useExt && !.hasXml) {
    .extFile <- paste0(.base, ext)
    if (file.exists(.extFile)) {
      .ext <- nmext(.extFile)
      .ret$theta <- .ext$theta
      .ret$omega <- .ext$omega
      .ret$sigma <- .ext$sigma
      .ret$objf <- .ext$objf
      .hasExt <- TRUE
      .uses <- c(.uses, "ext")
    }
  }
  .hasCov <- FALSE
  if (useCov && !.hasXml) {
    .covFile <- paste0(.base, cov)
    if (file.exists(.covFile)) {
      .cov <- nmcov(.covFile)
      .dm <- dimnames(.cov)[[1]]
      .dm <- .replaceNmDimNames(.dm)
      dimnames(.cov) <- list(.dm, .dm)
      .ret$cov <- .cov
      .uses <- c(.uses, "cov")
      .hasCov <- TRUE
    }
  }
  if (usePhi) {
    .phiFile <-  paste0(.base, phi)
    if (file.exists(.phiFile)) {
      .phi <- nmtab(.phiFile)
      .phi <- .phi[,which(regexpr("(ID|ETA[(])", names(.phi)) != -1)]
      names(.phi) <- vapply(names(.phi),
                            function(n) {
                              if (n == "ID") return("ID")
                              paste0("eta",substr(n, 5, nchar(n)-1))
                            }, character(1), USE.NAMES=FALSE)
      .ret$eta <- .phi
      .uses <- c(.uses, "phi")
    }
  }
  if (useLst) {
    .lstFile <- paste0(.base, lst)
    if (!file.exists(.lstFile)) {
      .lstFile <- suppressWarnings(readLines(file))
      .w <- which(regexpr("^( *NM-TRAN +MESSAGES *$| *1NONLINEAR *MIXED|License +Registered +to: +)", .lstFile)!=-1)
      if (length(.w) == 0L) .lstFile <- NULL
    }
    if (!is.null(.lstFile)) {
      if (.hasXml) {
        # use abbreviated parsing
        .resetLst(strictLst=strictLst)
        .nmlst$section <- .nmlst.tere
        .nmlst$tereOnly <- TRUE
        if (length(.lstFile) == 1L) {
          .l <- suppressWarnings(readLines(.lstFile))
        } else {
          .l <- .lstFile
        }
        lapply(.l, .nmlst.fun)
        .ret$tere <- .nmlst$tere
      } else {
        .lst <- nmlst(.lstFile, strictLst=strictLst)
        if (!.hasExt) {
          .ret$theta <- .lst$theta
          .ret$omega <- .lst$omega
          .ret$sigma <- .lst$sigma
          .ret$objf <- .lst$objf          
        }
        if (!.hasCov) {
          .ret$cov <- .lst$cov
        }
        .ret$nobs <- .xml$nobs
        .ret$nsub <- .xml$nsub
        .ret$nmtran <- .xml$nmtran
        .ret$termInfo <- .xml$termInfo
        .ret$nonmem <- .xml$nonmem
        .ret$time <- .xml$time
        .ret$control <- .xml$control
      }
      .uses <- c(.uses, "lst")
    }
  }
  .ret$uses <- .uses
  .ret
}
