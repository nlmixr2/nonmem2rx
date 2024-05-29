.replaceNmDimNames <- function(dn) {
  .dn <- gsub("THETA", "theta", dn)
  .dn <- gsub("OMEGA[(]([1-9][0-9]*),\\1[)]", "eta\\1", .dn)
  .dn <- gsub("SIGMA[(]([1-9][0-9]*),\\1[)]", "eps\\1", .dn)
  .dn <- gsub("OMEGA[(]([1-9][0-9]*),([1-9][0-9]*)[)]", "omega.\\1.\\2", .dn)
  .dn <- gsub("SIGMA[(]([1-9][0-9]*),([1-9][0-9]*)[)]", "sigma.\\1.\\2", .dn)
  .dn
}

.nmxmlGetCov <- function(xml, prefix="nm:") {
  .cov <- paste0("//", prefix, "covariance")
  .rowcol <- paste0(prefix, "row/", prefix, "col")
  .row <- paste0(prefix, "row")
  .cov <- xml2::xml_double(xml2::xml_find_all(xml2::xml_find_first(xml,.cov),
                                              .rowcol))
  if (length(.cov) > 0) {
    .names <- xml2::xml_attrs(xml2::xml_find_all(xml, .row))
    .inputNames <- setNames(unlist(.names), NULL)
    .finalNames <-  .replaceNmDimNames(.inputNames)
    .cov <- parse(text=paste0("lotri({", paste(.finalNames, collapse = " + "),
                                   "~", deparse1(.cov),
                                   "})"))
    .cov <- try(eval(.cov), silent=TRUE)
    if (inherits(.cov, "try-error")) {
      .minfo("try to get covariance a different method (slower)")
      .env <- new.env(parent=emptyenv())
      .env$matrix <- matrix(rep(NA_real_, length(.finalNames)^2), length(.finalNames), length(.finalNames),
                            dimnames=list(.finalNames, .finalNames))
      .tmp <- try(lapply(seq_along(.finalNames),
             function(i) {
               lapply(seq(i, length(.finalNames)),
                      function(j) {
                        .val <- xml2::xml_double(xml2::xml_find_first(xml2::xml_find_first(xml, paste0("//", prefix, "row[@", prefix, "rname='", .inputNames[i], "']")),
                                                                      paste0("//", prefix, "col[@", prefix, "cname='", .inputNames[j], "']")))
                        .env$matrix[.finalNames[i], .finalNames[j]] <-
                          .env$matrix[.finalNames[j], .finalNames[i]] <- .val

                      })
             }), silent=TRUE)
      if (inherits(.tmp, "try-error")) {
        .cov <- NULL
      } else {
        .cov <- .env$matrix
      }
    }
  } else {
    .cov <- NULL
  }
  .cov
}

#' Read a nonmem xml and create output similar to the `nmlst()`
#'
#' @param xml xml file
#' @return list of nonmem information
#' @export
#' @author Matthew L. Fidler
#' @examples
#' nmxml(system.file("mods/cpt/runODE032.xml", package="nonmem2rx"))
nmxml <- function(xml) {
  .xml <-try(xml2::read_xml(xml), silent=TRUE)
  if (inherits(.xml, "try-error")) return(NULL)
  .prefix <- "nm:"
  .ctl <- suppressWarnings(xml2::xml_find_first(.xml, paste0(.prefix, "control_stream")))
  if (is.na(.ctl)) {
    .prefix <- ""
    .ctl <- suppressWarnings(xml2::xml_find_first(.xml, paste0(.prefix, "control_stream")))
    if (is.na(.ctl)) {
      warning("could not find nm:control_stream or control_stream in xml",
              call.=FALSE)
      return(NULL)
    }
  }
  .ctl <- paste0(.prefix, "control_stream")
  .ctl <- strsplit(xml2::xml_text(xml2::xml_find_first(.xml, .ctl)), "\n")[[1]]
  .nmtran <- paste0(.prefix, "nmtran")
  .nmtran <- xml2::xml_text(xml2::xml_find_first(.xml,.nmtran))
  .obj <- paste0("//", .prefix, "final_objective_function")
  .obj <- xml2::xml_double(xml2::xml_find_first(.xml,.obj))
  .termInfo <- paste0("//", .prefix, "termination_information")
  .termInfo <- xml2::xml_text(xml2::xml_find_first(.xml, .termInfo))
  .nonmem <- paste0("//", .prefix, "nonmem")
  .nonmem <- xml2::xml_attr(xml2::xml_find_first(.xml, .nonmem), "version")
  .time1 <- paste0("//", .prefix, "estimation_elapsed_time")
  .time2 <- paste0("//", .prefix, "covariance_elapsed_time")
  .time3 <- paste0("//", .prefix, "post_elapsed_time")
  .time4 <- paste0("//", .prefix, "finaloutput_elapsed_time")
  .time <- sum(c(xml2::xml_double(xml2::xml_find_first(.xml,.time1)),
    xml2::xml_double(xml2::xml_find_first(.xml,.time2)),
    xml2::xml_double(xml2::xml_find_first(.xml,.time3)),
    xml2::xml_double(xml2::xml_find_first(.xml,.time4))), na.rm=TRUE)

  # use list parsing for this
  .resetLst(strictLst=FALSE)
  .lst <- paste0("//", .prefix, "problem_information")
  .lst <- strsplit(xml2::xml_text(xml2::xml_find_first(.xml,.lst)),"\n")[[1]]

  .nmlst$section <- .nmlst.nobs
  lapply(.lst, .nmlst.fun)

  .theta <-  paste0("//", .prefix, "theta")
  .val <- paste0("//", .prefix, "val")
  .node <- xml2::xml_find_first(.xml,.theta)
  .children <- xml2::xml_children(.node)
  .theta <- vapply(seq_along(.children),
                   function(i) {
                     xml2::xml_double(.children[i])
                   }, numeric(1), USE.NAMES = FALSE)
  if (length(.theta) > 0) {
    names(.theta) <- paste0("theta", seq_along(.theta))
  } else {
    .theta <- NULL
  }

  .omega <- paste0("//", .prefix, "omega")
  .rowcol <- paste0(.prefix, "row/", .prefix, "col")
  .omega <- xml2::xml_double(xml2::xml_find_all(xml2::xml_find_first(.xml,.omega),
                                                .rowcol))
  if (length(.omega) > 0) {
    .maxElt <- sqrt(1 + length(.omega) * 8)/2 - 1/2
    .omega <- eval(parse(text=paste0("lotri::lotri({",
                                     paste(paste0("eta", seq_len(.maxElt)), collapse="+"),
                                     "~", deparse1(.omega), "})")))
  } else {
    .omgea <- NULL
  }

  .sigma <- paste0("//", .rowcol, "sigma")
  .sigma <- xml2::xml_double(xml2::xml_find_all(xml2::xml_find_first(.xml, .sigma),.rowcol))
  if (length(.sigma) > 0) {
    .maxElt <- sqrt(1 + length(.sigma) * 8)/2 - 1/2
    .sigma <- eval(parse(text=paste0("lotri::lotri({",
                                     paste(paste0("eps", seq_len(.maxElt)), collapse="+"),
                                     "~", deparse1(.sigma), "})")))
  } else {
    .sigma <- NULL
  }

  .cov <- paste0("//", .prefix, "covariance")
  .cov <- .nmxmlGetCov(xml2::xml_find_first(.xml, .cov),
                       prefix=.prefix)
  list(theta=.theta,
       omega=.omega,
       sigma=.sigma,
       cov=.cov,
       objf=.obj,
       nobs=.nmlst$nobs,
       nsub=.nmlst$nsub,
       nmtran=.nmtran,
       nonmem=.nonmem,
       termInfo=.termInfo,
       time=.time,
       control=.ctl)
}

#' Get the xml for debugging (without including data etc)
#'
#' @param xml Original xml file
#' @param xmlout xml output (only includes xml)
#' @return nothing, called for side effects
#' @export
#' @author Matthew L. Fidler
#' @keywords internal
nmxmlCov <- function(xml, xmlout, tag="//nm:covariance") {
  .xml <- try(xml2::read_xml(xml), silent=TRUE)
  if (inherits(.xml, "try-error")) return(NULL)
  .covXml <- xml2::xml_find_first(.xml,"//nm:covariance")
  xml2::write_xml(.covXml, xmlout)
  .lines <- c('<?xml version="1.0" encoding="ASCII"?>',
              '<!DOCTYPE nm:output SYSTEM "output.dtd">',
              "<nm:output",
              'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"',
              'xsi:schemaLocation="http://namespaces.oreilly.com/xmlnut/address output.xsd"',
              'xmlns:nm="http://namespaces.oreilly.com/xmlnut/address"',
              '>',
              readLines(xmlout, encoding="latin1"),
              "</nm:output>")
  writeLines(.lines, xmlout)
  message("written to xml output '", xmlout, "'")
  invisible()
}
#' @rdname nmxmlCov
#' @export
nmxmlOmega <- function(xml, xmlout, tag="//nm:omega") {
  nmxmlCov(xml, xmlout, tag=tag)
}

#' @rdname nmxmlCov
#' @export
nmxmlSigma <- function(xml, xmlout, tag="//nm:sigma") {
  nmxmlCov(xml, xmlout, tag=tag)
}
#' @rdname nmxmlCov
#' @export
nmxmlTheta <- function(xml, xmlout, tag="//nm:theta") {
  nmxmlCov(xml, xmlout, tag=tag)
}
