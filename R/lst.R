.nmlst <- new.env(parent=emptyenv())
#' Reads the NONMEM `.lst` file for final parameter information
#'  
#' @param file File where the list is located
#' @return return a list with `$theta`, `$eta` and `$eps`
#' @export 
#' @author Matthew L. Fidler
#' @examples
#' nmlst(system.file("mods/DDMODEL00000322/HCQ1CMT.lst", package="nonmem2rx"))
#' nmlst(system.file("mods/DDMODEL00000302/run1.lst", package="nonmem2rx"))
#' nmlst(system.file("mods/DDMODEL00000301/run3.lst", package="nonmem2rx"))
nmlst <- function(file) {
  # run time
  # nmtran message
  .lst <- readLines(file)
  
  .w <- which(regexpr("FINAL +PARAMETER +ESTIMATE", .lst) != -1)
  if (length(.w) == 0) stop("could not find final parameter estimate in lst file", call.=FALSE)
  .w <- .w[1]
  .est <- .lst[seq(.w, length(.lst))]
  
  .w <- which(regexpr("THETA +- +VECTOR", .est) != -1)
  if (length(.w) == 0) stop("could not find final parameter estimate in lst file", call.=FALSE)
  .w <- .w[1]
  .est <- .est[seq(.w, length(.est))]
  
  .w <- which(regexpr("^ *[*][*][*]+", .est) != -1)
  if (length(.w) == 0) stop("could not find final parameter estimate in lst file", call.=FALSE)
  .w <- .w[1]
  .est <- .est[seq(1, .w - 1)]

  .est <- paste(.est, collapse="\n")
  .Call(`_nonmem2rx_trans_lst`, .est)
  list(theta=.nmlst$theta,
       eta=.nmlst$eta,
       eps=.nmlst$eps)
}
#' Push final estimates
#'
#' @param type Type of element ("theta", "eta", "eps")
#' @param est R code for the estimates (need to apply names and lotri)
#' @param maxElt maximum number of the element type
#' @return nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
.pushLst <- function(type, est, maxElt) {
  if (type == "theta") {
    assign("theta", setNames(eval(parse(text=est)), paste0(type,seq(1, maxElt))), envir=.nmlst)
  } else {
    .est <- paste0("lotri::lotri(",
                   paste(paste0(type, seq(1, maxElt)), collapse="+"),
                   " ~ ", est, ")")
    .est <- eval(parse(text=.est))
    assign(type, .est, envir=.nmlst)
  }
  invisible()
}
