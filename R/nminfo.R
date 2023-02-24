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
               uses=NULL)
  .xmlFile <- paste0(.base, xml)
  .hasXml <- FALSE
  if (useXml && file.exists(.xmlFile)) {
    if (verbose) .minfo("reading in xml file")
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
      if (verbose) .minfo("done")
    } else {
      if (verbose) .minfo("could not read in xml file")
    }
  }
  # for theta, omega, and sigma the ext file is more accurate than the lst file
  .hasExt <- FALSE
  if (useExt && !.hasXml) {
    .extFile <- paste0(.base, ext)
    if (file.exists(.extFile)) {
      if (verbose) .minfo("reading in ext file")
      .ext <- nmext(.extFile)
      .ret$theta <- .ext$theta
      .ret$omega <- .ext$omega
      .ret$sigma <- .ext$sigma
      .ret$objf <- .ext$objf
      .hasExt <- TRUE
      .uses <- c(.uses, "ext")
      if (verbose) .minfo("done")
    }
  }
  .hasCov <- FALSE
  if (useCov && !.hasXml) {
    .covFile <- paste0(.base, cov)
    if (file.exists(.covFile)) {
      if (verbose) .minfo("reading in cov file")
      .cov <- nmcov(.covFile)
      .dm <- dimnames(.cov)[[1]]
      .dm <- .replaceNmDimNames(.dm)
      dimnames(.cov) <- list(.dm, .dm)
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
      .phi <- .phi[,which(regexpr("(ID|ETA[(])", names(.phi)) != -1)]
      names(.phi) <- vapply(names(.phi),
                            function(n) {
                              if (n == "ID") return("ID")
                              paste0("eta",substr(n, 5, nchar(n)-1))
                            }, character(1), USE.NAMES=FALSE)
      .ret$eta <- .phi
      .uses <- c(.uses, "phi")
      if (verbose) .minfo("done")
    }
  }
  .fileLines <- NULL
  if (useLst) {
    .lstFile <- paste0(.base, lst)
          if (verbose) .minfo("reading in lst file")
    if (!file.exists(.lstFile)) {
      if (file.exists(file)) {
        if (verbose) .minfo("seeing if file argument is actually lst file")
        .fileLines <- suppressWarnings(readLines(file))
        .w <- which(regexpr("^( *NM-TRAN +MESSAGES *$| *1NONLINEAR *MIXED|License +Registered +to: +)", .lstFile)!=-1)
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
      if (.hasXml) {
        # use abbreviated parsing
        if (verbose) .minfo("abbreviated list parsing")
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
        if (verbose) .minfo("done")

      } else {
        if (verbose) .minfo("getting information from lst file")
        .lst <- nmlst(.lstFile, strictLst=strictLst)
        if (!.hasExt) {
          .ret$theta <- .lst$theta
          .ret$omega <- .lst$omega
          .ret$sigma <- .lst$sigma
          .ret$objf <- .lst$objf
        } else {
          if (is.null(.ret$theta)) .ret$theta <- .lst$theta
          if (is.null(.ret$omega)) .ret$omega <- .lst$omega
          if (is.null(.ret$sigma)) .ret$sigma <- .lst$sigma
          if (is.null(.ret$objf)) .ret$objf <- .lst$objf

        }
        if (!.hasCov) {
          .ret$cov <- .lst$cov
        } else {
          if (is.null(.ret$cov)) .ret$cov <- .lst$cov
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
      .fileLines <- suppressWarnings(readLines(file))
      .wpro <- which(regexpr("^ *[$][Pp][Rr][Oo]", .fileLines) != -1)
      if (length(.wpro) != 0L) {
        .ret$control <- .fileLines
        .uses <- c(.uses, "mod")
        if (verbose) .minfo("yes, read in")
      }
    }
  }
  if (is.null(.ret$control)) {
    .ctl <- paste0(.base, mod)
    if (verbose) .minfo("looking for control stream")
    if (file.exists(.ctl)) {
      .fileLines <- suppressWarnings(readLines(file))
      .wpro <- which(regexpr("^ *[$][Pp][Rr][Oo]", .fileLines) != -1)
      if (length(.wpro) != 0L) {
        .ret$control <- .fileLines
        .uses <- c(.uses, "mod")
        if (verbose) .minfo("found")
      }
    }
  }
  .ret$uses <- .uses
  .ret
}
