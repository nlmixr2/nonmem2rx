#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.dat <- function(x) {
  .x <- x
  class(.x) <- NULL
  .x <- paste(.x, collapse="\n")
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
#' Number of digits NONMEM writes for a `$DATA TRANSLATE` item
#'
#' If `D` is given it is truncated to an integer (0 means 2, max 12);
#' otherwise a real `F` keeps as many decimal places as it was written with
#' and an integer `F` gives 2 digits.
#'
#' @param factor character representation of `F`
#' @param digits character representation of `D` (`""` when omitted)
#' @return integer number of digits after the decimal point
#' @noRd
#' @author Matthew L. Fidler
.dataTranslateDigits <- function(factor, digits) {
  if (digits != "") {
    .d <- trunc(as.numeric(digits))
  } else if (grepl(".", factor, fixed=TRUE)) {
    .d <- nchar(sub("[eE].*$", "", sub("^[^.]*[.]", "", factor)))
  } else {
    .d <- 2L
  }
  if (.d <= 0) .d <- 2L
  as.integer(min(.d, 12L))
}

#' Push a $DATA option parsed by the data grammar
#'
#' @param opt option name
#' @param v1 first value of the option
#' @param v2 second value of the option
#' @param v3 third value of the option
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.pushDataOption <- function(opt, v1, v2, v3) {
  switch(opt,
         null=.nonmem2rx$dataNull <- v1,
         recordsLabel=.nonmem2rx$dataRecordsLabel <- v1,
         last20=.nonmem2rx$dataLast20 <- as.integer(v1),
         misdat=.nonmem2rx$dataMisdat <- c(.nonmem2rx$dataMisdat, as.numeric(v1)),
         repl=.nonmem2rx$dataRepl <- as.integer(v1),
         translate={
           .nonmem2rx$dataTranslate[[toupper(v1)]] <-
             list(factor=as.numeric(v2),
                  digits=.dataTranslateDigits(v2, v3))
         },
         format=.minfo(paste0("$DATA format ", v1,
                              " ignored; data read as delimited")),
         noopen=.minfo("$DATA NOOPEN: data file is not opened by NM-TRAN"),
         predIgnoreData=.minfo("$DATA PRED_IGNORE_DATA is not applied when reading input data"))
  invisible()
}
