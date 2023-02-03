#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.mod <- function(x) {
  .x <- x
  class(.x) <- NULL
  if (length(.x) != 1) {
    stop("only one $model record is read in the 'rxode2' conversion",
         call.=FALSE)
  }
  .Call(`_nonmem2rx_trans_model`, .x)
}
#' Add compartment name to the nonmem2rx translation
#'
#' @param x compartment name
#' @return None, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addModelName <- function(x) {
  if (!exists("cmtName", envir=.nonmem2rx)) .nonmem2rx$cmtName <- NULL
  .nonmem2rx$cmtName <- c(.nonmem2rx$cmtName, x)
  invisible()
}

#' Push the default dose and observation
#'
#' @param defdose default dose index
#' @param defobs default observation
#' @return None, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.pushCmtInfo <- function(defdose, defobs) {
  .nonmem2rx$defdose <- defdose
  .nonmem2rx$defobs <- defobs
  invisible()
}
