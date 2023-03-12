.replaceNmDimNames <- function(dn) {
  .dn <- gsub("THETA", "theta", dn)
  .dn <- gsub("OMEGA[(]([1-9][0-9]*),\\1[)]", "eta\\1", .dn)
  .dn <- gsub("SIGMA[(]([1-9][0-9]*),\\1[)]", "eps\\1", .dn)
  .dn <- gsub("OMEGA[(]([1-9][0-9]*),([1-9][0-9]*)[)]", "omega.\\1.\\2", .dn)
  .dn <- gsub("SIGMA[(]([1-9][0-9]*),([1-9][0-9]*)[)]", "sigma.\\1.\\2", .dn)
  .dn
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



  .cov <- xml2::xml_double(xml2::xml_find_all(xml2::xml_find_first(.xml,"//nm:covariance"),"nm:row/nm:col"))
  if (length(.cov) > 0) {
    .names <-  .replaceNmDimNames(setNames(unlist(xml2::xml_attrs(xml2::xml_find_all(xml2::xml_find_first(.xml,"//nm:covariance"), "nm:row"))), NULL))
    .cov <- eval(parse(text=paste0("lotri({", paste(.names, collapse = " + "),
                                   "~", deparse1(.cov),
                                   "})")))    
  } else {
    .cov <- NULL
  }
  
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
