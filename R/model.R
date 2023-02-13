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
#' Get the model number
#'  
#' @param n name of compartment
#' @return compartment number as a string
#' @noRd
#' @author Matthew L. Fidler
.getModelNum <- function(n) {
  if (!exists("cmtName", envir=.nonmem2rx)) {
    stop("requesting compartment named '", n, "' when compartment names are not defined in $MODEL",
         call.=FALSE)
  }
  .w <- which(tolower(n) == tolower(.nonmem2rx$cmtName))
  if (length(.w) == 1) return(paste(.w))
  stop("requesting compartment named '", n, "' which is not defined in $MODEL",
       call.=FALSE)
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
