#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.abb <- function(x) {
  .x <- x
  class(.x) <- NULL
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_abbrec`, .cur)
  }
}
#' Add direct replacement type  
#'
#' @param type Type of variable to replace (theta/eta/eps/err)
#' @param var nonmem variable name 
#' @param num nonmem variable number equivalent
#' @return None, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addReplaceDirect1 <- function(type, var, num) {
  .lst <- list(type, var, num)
  class(.lst) <-"nonmem2rx.rep1"
  .nonmem2rx$replace <- c(.nonmem2rx$replace, list(.lst))
}
#' Add direct replacement type  
#'
#' @param type Type of variable to replace (theta/eta/eps/err)
#' @param var nonmem variable name 
#' @param num nonmem variable number equivalent
#' @return None, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addReplaceDirect2 <- function(what, with) {
  .lst <- list(what,with)
  class(.lst) <-"nonmem2rx.rep2"
  .nonmem2rx$replace <- c(.nonmem2rx$replace, list(.lst))
}
#' Process the sequence for the repeat statement
#'
#' @param what string with valid R code to add to the `replaceSeq`
#' @return Nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
.processSeq <- function(what) {
  .eval <- eval(parse(text=what))
  .nonmem2rx$replaceSeq <- c(.nonmem2rx$replaceSeq, .eval)
}
#' Add the label to the replacement queue
#'
#' @param label Label to add
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.replaceProcessLabel <- function(label) {
  .nonmem2rx$replaceLabel <- c(.nonmem2rx$replaceLabel, label)
}
#' Create the multiple replacement list to append to the replacement list
#'
#' @param varType Type of variable
#' @return Nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
.replaceMultiple <- function(varType) {
  if (length(.nonmem2rx$replaceLabel) != length(.nonmem2rx$replaceSeq)) {
    stop("the multiple replacement for '", varType, "' did not have the same number of labels as numbers", call.=FALSE)
  }
  .nonmem2rx$replace <- c(.nonmem2rx$replace,
                          lapply(seq_along(.nonmem2rx$replaceLabel),
                                 function(i) {
                                   .lst <- list(varType, .nonmem2rx$replaceLabel[i],
                                                .nonmem2rx$replaceSeq[i])
                                   class(.lst) <-"nonmem2rx.rep1"
                                   .lst
                                 }))
  .nonmem2rx$replaceLabel <- NULL
  .nonmem2rx$replaceSeq <- NULL
}
#' Is this a data item
#'
#' @param what variable to check if it is a data item
#' @return integer logical
#' @noRd
#' @author Matthew L. Fidler
.replaceIsDataItem <- function(what) {
  .inp <- c(setNames(.nonmem2rx$input,NULL), names(.nonmem2rx$input))
  as.integer(what %in% .inp)
}
#' Add a data item replacement
#'
#' @param varType Variable type
#' @param dataItem Data item
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.replaceDataItem <- function(varType, dataItem) {
  if (any(duplicated(.nonmem2rx$replaceSeq))) {
    stop(paste0("the replacement for ", varType, "(", dataItem, ") has duplicate numbers and cannot be processed by nonmem2rx"))
  }
  .lst <- list(varType, dataItem, .nonmem2rx$replaceSeq)
  .nonmem2rx$replaceSeq <- NULL
  class(.lst) <-"nonmem2rx.repDI"
  .nonmem2rx$replace <- c(.nonmem2rx$replace, list(.lst))
}
#' Add a data item replacement
#'
#' @param varType Variable type
#' @param dataItem Data item
#' @param varItem Variable item
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.replaceDataParItem <- function(varType, dataItem, varItem) {
  if (any(duplicated(.nonmem2rx$replaceSeq))) {
    stop(paste0("the replacement for ", varType, "(", dataItem, "_", varItem, ") has duplicate numbers and cannot be processed by nonmem2rx"))
  }
  .lst <- list(varType, dataItem, varItem, .nonmem2rx$replaceSeq)
  .nonmem2rx$replaceSeq <- NULL
  class(.lst) <-"nonmem2rx.repDVI"
  .nonmem2rx$replace <- c(.nonmem2rx$replace, list(.lst))
}
