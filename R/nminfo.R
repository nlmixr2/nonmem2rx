#' Get the most accurate information you can get from NONMEM
#'
#'
#' @param file nonmem file, like control stream, phi.  This function
#'   will remove the extension to try to get the right information.
#'   It preferentially selects the most accurate estimates from the
#'   file.
#' @param verbose this is a flag to be more verbose when reading information in, by default this is `FALSE`
#' @return list of NONMEM information
#' @inheritParams nonmem2rx
#' @export
#' @author Matthew L. Fidler
#' @examples
#' nminfo(system.file("mods/cpt/runODE032.res", package="nonmem2rx"))
nminfo <- function(file,
                   mod=".mod", xml=".xml", ext=".ext", cov=".cov", phi=".phi", lst=".lst",
                   grd=".grd",
                   useXml = TRUE, useExt = TRUE, useCov=TRUE, usePhi=TRUE, useLst=TRUE,
                   strictLst=FALSE, verbose=FALSE) {
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
               uses=NULL,
               thetaGrad=NULL)
  .xmlFile <- paste0(.base, xml)
  .hasXml <- FALSE
  if (useXml && file.exists(.xmlFile)) {
    if (verbose) .minfo("reading in xml file")
    .xml <- nmxml(.xmlFile)
    if (inherits(.xml, "list")) {
      .hasXml <- TRUE
      .ret$theta <- .xml$theta
      if (!is.null(.ret$theta)) .ret$thetaSource <- "xml"
      .ret$omega <- .xml$omega
      if (!is.null(.ret$omega)) .ret$omegaSource <- "xml"
      .ret$sigma <- .xml$sigma
      if (!is.null(.ret$sigma)) .ret$sigmaSource <- "xml"
      .ret$cov <- .xml$cov
      if (!is.null(.ret$cov)) .ret$covSource <- "xml"
      .ret$objf <- .xml$objf
      if (!is.null(.ret$objf)) .ret$objfSource <- "xml"
      .ret$nobs <- .xml$nobs
      .ret$nsub <- .xml$nsub
      .ret$nmtran <- .xml$nmtran
      .ret$termInfo <- .xml$termInfo
      .ret$nonmem <- .xml$nonmem
      .ret$time <- .xml$time
      .ret$control <- .xml$control
      .uses <- "xml"
      if (verbose) .minfo("done")
    } else {
      if (verbose) .minfo("could not read in xml file")
    }
  }
  # for theta, omega, and sigma the ext file is more accurate than the lst file
  .hasExt <- FALSE
  if (useExt && (is.null(.ret$theta) ||
                   is.null(.ret$omega) ||
                   is.null(.ret$sigma) ||
                   is.null(.ret$objf))) {
    .extFile <- paste0(.base, ext)
    if (file.exists(.extFile)) {
      if (verbose) .minfo("reading in ext file")
      .ext <- nmext(.extFile)
      if (is.null(.ret$theta)) {
        .ret$theta <- .ext$theta
        if (!is.null(.ret$theta)) .ret$thetaSource <- "ext"
      }
      if (is.null(.ret$omega)) {
        .ret$omega <- .ext$omega
        if (!is.null(.ret$omega)) .ret$omegaSource <- "ext"
      }
      if (is.null(.ret$sigma)) {
        .ret$sigma <- .ext$sigma
        if (!is.null(.ret$sigma)) .ret$sigmaSource <- "ext"
      }
      if (is.null(.ret$objf)) {
        .ret$objf <- .ext$objf
        if (!is.null(.ret$objf)) .ret$objfSource <- "ext"
      }
      .hasExt <- TRUE
      .uses <- c(.uses, "ext")
      if (verbose) .minfo("done")
    }
  }
  .hasCov <- FALSE
  if (useCov && is.null(.ret$cov)) {
    .covFile <- paste0(.base, cov)
    if (file.exists(.covFile)) {
      if (verbose) .minfo("reading in cov file")
      .cov <- nmcov(.covFile)
      .dm <- dimnames(.cov)[[1]]
      .dm <- .replaceNmDimNames(.dm)
      dimnames(.cov) <- list(.dm, .dm)
      if (is.null(.ret$cov)) {
        .ret$cov <- .cov
        if (!is.null(.ret$cov)) .ret$covSource <- "cov"
      }
      .ret$cov <- .cov
      .uses <- c(.uses, "cov")
      .hasCov <- TRUE
      if (verbose) .minfo("done")
    }
  }
  if (usePhi) {
    .phiFile <-  paste0(.base, phi)
    if (file.exists(.phiFile)) {
      if (verbose) .minfo("reading in phi file")
      .phi <- nmtab(.phiFile)
      if (!is.null(.phi)) {
        .phi <- .phi[,which(regexpr("(ID|ETA[(])", names(.phi)) != -1), drop=FALSE]
        if (length(.phi) > 1) {
          names(.phi) <- vapply(names(.phi),
                                function(n) {
                                  if (n == "ID") return("ID")
                                  paste0("eta",substr(n, 5, nchar(n)-1))
                                }, character(1), USE.NAMES=FALSE)
          .ret$eta <- .phi
          .uses <- c(.uses, "phi")
        } else {
          .minfo("phi file does not contain etas")
        }
        if (verbose) .minfo("done")
      } else if (verbose) {
        .minfo("problems reading phi file")
      }
    }
  }
  .fileLines <- NULL
  if (useLst) {
    .lstFile <- paste0(.base, lst)
    if (verbose) .minfo("reading in lst file")
    if (!file.exists(.lstFile)) {
      if (file.exists(file)) {
        if (verbose) .minfo("seeing if file argument is actually lst file")
        .fileLines <- suppressWarnings(readLines(file, encoding="latin1"))
        .w <- which(regexpr("^( *NM-TRAN +MESSAGES *| *1NONLINEAR *MIXED|License +Registered +to: +)", .fileLines)!=-1)
        if (length(.w) == 0L) {
          .wpro <- which(regexpr("^ *[$][Pp][Rr][Oo]", .fileLines) != -1)
          if (length(.wpro) != 0L) {
            .ret$control <- .fileLines
            if (verbose) .minfo("not list file, control stream")
          }
          .lstFile <- NULL
        } else {
          .lstFile <- .fileLines
          if (verbose) .minfo("file is nonmem output")
        }

      }
    }
    if (!is.null(.lstFile)) {
      if ((!is.null(.ret$theta) &&
             !is.null(.ret$omega) &&
             !is.null(.ret$sigma) &&
             !is.null(.ret$objf))) {
        # use abbreviated parsing
        if (verbose) .minfo("abbreviated list parsing")
        .resetLst(strictLst=strictLst)
        .nmlst$section <- .nmlst.tere
        .nmlst$tereOnly <- TRUE
        if (length(.lstFile) == 1L) {
          .l <- suppressWarnings(readLines(.lstFile, encoding="latin1"))
        } else {
          .l <- .lstFile
        }
        lapply(.l, .nmlst.fun)
        .ret$tere <- .nmlst$tere
        if (verbose) .minfo("done")
      } else {
        if (verbose) .minfo("getting information from lst file")
        .lst <- nmlst(.lstFile, strictLst=strictLst)
        if (is.null(.ret$theta)) {
          .ret$theta <- .lst$thet
          if (!is.null(.ret$theta)) .ret$thetaSource <- "lst"
        }
        if (is.null(.ret$omega)) {
          .ret$omega <- .lst$omega
          if (!is.null(.ret$omega)) .ret$omegaSource <- "lst"
        }
        if (is.null(.ret$sigma)) {
          .ret$sigma <- .lst$sigma
          if (!is.null(.ret$sigma)) .ret$sigmaSource <- "lst"
        }
        if (is.null(.ret$objf)) {
          .ret$objf <- .lst$objf
          if (!is.null(.ret$objf)) .ret$objfSource <- "lst"
        }
        if (is.null(.ret$cov)) {
          .ret$cov <- .lst$cov
          if (!is.null(.ret$cov)) .ret$covSource <- "lst"
        }
        .ret$nobs <- .lst$nobs
        .ret$nsub <- .lst$nsub
        .ret$nmtran <- .lst$nmtran
        .ret$termInfo <- .lst$termInfo
        .ret$nonmem <- .lst$nonmem
        .ret$time <- .lst$time
        .ret$control <- .lst$control
        if (verbose) .minfo("done")

      }
      .uses <- c(.uses, "lst")
    }
  }
  if (is.null(.ret$control)) {
    # lonely control stream?
    if (file.exists(file)) {
      if (verbose) .minfo("is file actually control stream")
      .fileLines <- suppressWarnings(readLines(file, encoding="latin1"))
      .wpro <- which(regexpr("^ *[$][Pp][Rr][Oo]", .fileLines) != -1)
      if (length(.wpro) != 0L) {
        .control <- .fileLines[seq(.wpro[1], length(.fileLines))]
        .end <- "^( *NM-TRAN +MESSAGES *$| *1NONLINEAR *MIXED|License +Registered +to: +| *[*][*][*][*][*]*)"
        .wend <- which(regexpr(.end, .control)!= -1)
        if (length(.wend) != 0L) {
          .control <- .control[seq(1, .wend[1]-1L)]
        }
        .ret$control <- .control
        .uses <- c(.uses, "mod")
        if (verbose) .minfo("yes, read in")
      }
    }
  }
  if (is.null(.ret$control)) {
    .ctl <- paste0(.base, mod)
    if (verbose) .minfo("looking for control stream")
    if (file.exists(.ctl)) {
      .fileLines <- suppressWarnings(readLines(file, encoding="latin1"))
      .wpro <- which(regexpr("^ *[$][Pp][Rr][Oo]", .fileLines) != -1)
      if (length(.wpro) != 0L) {
        .control <- .fileLines[seq(.wpro[1], length(.fileLines))]
        .end <- "^( *NM-TRAN +MESSAGES *$| *1NONLINEAR *MIXED|License +Registered +to: +| *[*][*][*][*][*]*)"
        .wend <- which(regexpr(.end, .control)!= -1)
        if (length(.wend) != 0L) {
          .control <- .control[seq(1, .wend[1]-1L)]
        }
        .ret$control <- .control
        .uses <- c(.uses, "ctl")
      }
    }
  }
  # now check for grad
  .grdFile <- paste0(.base, grd)
  if (file.exists(.grdFile)) {
    if (verbose) .minfo("reading in grd file")
    .ret$rawGrad <- nmgrd(.grdFile)
    .uses <- c(.uses, "grd")
  } else {
    .ret$rawGrad <- NULL
  }
  .ret$uses <- .uses
  .ret
}
