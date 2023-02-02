#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.dat <- function(x) {
  .x <- x
  class(.x) <- NULL
  if (length(.x) != 1) {
    stop("only one $DATA record is read in the 'rxode2' conversion",
         call.=FALSE)
  }
  .nonmem2rx$dataCondType <- .Call(`_nonmem2rx_trans_data`, .x)
}

.pushDataCond <- function(cond) {
  if (nchar(cond) == 1L) {
    .nonmem2rx$dataIgnore1 <- cond
  } else {
    .nonmem2rx$dataCond <- c(.nonmem2rx$dataCond, cond)
  }
}

#' Push $data file name
#'  
#' @param file file name for nonmem input
#' @return nothing, called for side effect
#' @noRd
#' @author Matthew L. Fidler
.pushDataFile <- function(file) {
  .nonmem2rx$dataFile <- file
}
#' Push $data number of records  
#'  
#' @param rec Number of records
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.pushDataRecords <- function(rec) {
  .nonmem2rx$dataRecords <- rec
}
