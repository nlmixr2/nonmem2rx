#' Reads the NONMEM list file for information
#'
#'  
#' @param file File where the list is located
#' @return 
#' @export 
#' @author Matthew L. Fidler
#' @examples
#' nmlst(system.file("mods/DDMODEL00000322/HCQ1CMT.lst", package="nonmem2rx"))
nmlst <- function(file) {
  # run time
  # nmtran message

  .lst <- readLines(file)
  
  .w <- which(regexpr("FINAL +PARAMETER +ESTIMATE", .lst) != -1)
  if (length(.w) == 0) stop("could not find final parameter estimate in lst file", call.=FALSE)
  .w <- .w[1]
  .est <- .lst[seq(.w, length(.lst))]
  
  .w <- which(regexpr("^THETA +- +VECTOR", .est) != -1)
  if (length(.w) == 0) stop("could not find final parameter estimate in lst file", call.=FALSE)
  .w <- .w[1]
  .est <- .est[seq(.w, length(.est))]
  
  .w <- which(regexpr("^[*][*][*]+", .est) != -1)
  if (length(.w) == 0) stop("could not find final parameter estimate in lst file", call.=FALSE)
  .w <- .w[1]
  .est <- .est[seq(1, .w - 1)]
  
  
}
