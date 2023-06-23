.replaceNmDimNames <- function(dn) {
  .dn <- gsub("THETA", "theta", dn)
  .dn <- gsub("OMEGA[(]([1-9][0-9]*),\\1[)]", "eta\\1", .dn)
  .dn <- gsub("SIGMA[(]([1-9][0-9]*),\\1[)]", "eps\\1", .dn)
  .dn <- gsub("OMEGA[(]([1-9][0-9]*),([1-9][0-9]*)[)]", "omega.\\1.\\2", .dn)
  .dn <- gsub("SIGMA[(]([1-9][0-9]*),([1-9][0-9]*)[)]", "sigma.\\1.\\2", .dn)
  .dn
}

.nmxmlGetCov <- function(xml) {
  .cov <- xml2::xml_double(xml2::xml_find_all(xml2::xml_find_first(xml,"//nm:covariance"),"nm:row/nm:col"))
  if (length(.cov) > 0) {
    .names <- xml2::xml_attrs(xml2::xml_find_all(xml, "nm:row"))
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
                        .val <- xml2::xml_double(xml2::xml_find_first(xml2::xml_find_first(xml, paste0("//nm:row[@nm:rname='", .inputNames[i], "']")), paste0("//nm:col[@nm:cname='", .inputNames[j], "']")))
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
  .ctl <- strsplit(xml2::xml_text(xml2::xml_find_first(.xml, "nm:control_stream")), "\n")[[1]]
  .nmtran <- xml2::xml_text(xml2::xml_find_first(.xml,"nm:nmtran"))
  .obj <- xml2::xml_double(xml2::xml_find_first(.xml,"//nm:final_objective_function"))
  .termInfo <- xml2::xml_text(xml2::xml_find_first(.xml, "//nm:termination_information"))
  .nonmem <- xml2::xml_attr(xml2::xml_find_first(.xml, "nm:nonmem"), "version")

  .time <- sum(c(xml2::xml_double(xml2::xml_find_first(.xml,"//nm:estimation_elapsed_time")),
    xml2::xml_double(xml2::xml_find_first(.xml,"//nm:covariance_elapsed_time")),
    xml2::xml_double(xml2::xml_find_first(.xml,"//nm:post_elapsed_time")),
    xml2::xml_double(xml2::xml_find_first(.xml,"//nm:finaloutput_elapsed_time"))), na.rm=TRUE)

  # use list parsing for this
  .resetLst(strictLst=FALSE)
  .lst <- strsplit(xml2::xml_text(xml2::xml_find_first(.xml,"//nm:problem_information")),"\n")[[1]]

  .nmlst$section <- .nmlst.nobs
  lapply(.lst, .nmlst.fun)

  .theta <- xml2::xml_double(xml2::xml_find_all(xml2::xml_find_first(.xml,"//nm:theta"), "nm:val"))
  if (length(.theta) > 0) {
    names(.theta) <- paste0("theta", seq_along(.theta))
  } else {
    .theta <- NULL
  }

  .omega <- xml2::xml_double(xml2::xml_find_all(xml2::xml_find_first(.xml,"//nm:omega"),"nm:row/nm:col"))
  if (length(.omega) > 0) {
    .maxElt <- sqrt(1 + length(.omega) * 8)/2 - 1/2
    .omega <- eval(parse(text=paste0("lotri::lotri({",
                                     paste(paste0("eta", seq_len(.maxElt)), collapse="+"),
                                     "~", deparse1(.omega), "})")))
  } else {
    .omgea <- NULL
  }

  .sigma <- xml2::xml_double(xml2::xml_find_all(xml2::xml_find_first(.xml,"//nm:sigma"),"nm:row/nm:col"))
  if (length(.sigma) > 0) {
    .maxElt <- sqrt(1 + length(.sigma) * 8)/2 - 1/2
    .sigma <- eval(parse(text=paste0("lotri::lotri({",
                                     paste(paste0("eps", seq_len(.maxElt)), collapse="+"),
                                     "~", deparse1(.sigma), "})")))
  } else {
    .sigma <- NULL
  }

  .cov <- .nmxmlGetCov(xml2::xml_find_first(.xml,"//nm:covariance"))

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
              readLines(xmlout),
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
