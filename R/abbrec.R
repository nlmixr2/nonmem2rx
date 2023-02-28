#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.abb <- function(x) {
  .x <- x
  class(.x) <- NULL
  .i <- 1
  .rec <- .transRecordsDisplay[class(x)[1]]
  .ln <- length(.x)
  for (.cur in .x) {
    if (.ln > 1) .Call(`_nonmem2rx_setRecord`, paste0(.rec, " #", .i))
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
  class(.lst) <-"rep1"
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
  class(.lst) <-"rep2"
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
                                   class(.lst) <-"rep1"
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
  .dataReg <- paste0("(",paste(vapply(unique(.inp), .regexpIgnoreCase,
                                      character(1), USE.NAMES=FALSE),
                               collapse = "|"),
                     ")")
  .reg1 <-  paste0("^", .dataReg, "_([a-zA-Z][a-zA-Z0-9_]*)$")
  .reg2 <-  paste0("^([a-zA-Z][a-zA-Z0-9_]*)_", .dataReg, "$")
  if (regexpr(paste0("^", .dataReg, "$"), what) != -1) {
    .nonmem2rx$replaceDataParItem <- what
    return(1L)
  } else if (regexpr(.reg1, what) != -1) {
    .data <- sub(.reg1, "\\1", what)
    .par <- sub(.reg1, "\\2", what)
    .nonmem2rx$replaceDataParItem <- c(.data, .par)
    return(1L)
  } else if (regexpr(.reg2, what) != -1) {
    .data <- sub(.reg2, "\\2", what)
    .par <- sub(.reg2, "\\1", what)
    .nonmem2rx$replaceDataParItem <- c(.data, .par)
    return(1L)
  }
  0L
}
#' Add a data item or a data item / parameter replacement
#'
#' @param varType Variable type
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.replaceDataItem <- function(varType) {
  .dataItem <- .nonmem2rx$replaceDataParItem[1]
  if (any(duplicated(.nonmem2rx$replaceSeq))) {
    warning(paste0("the replacement for ", varType, "(", .dataItem, ") has duplicate numbers, check code"), call.=FALSE)
  }
  if (length(.nonmem2rx$replaceDataParItem) == 1L) {
    .lst <- list(varType, .dataItem, .nonmem2rx$replaceSeq)
    .nonmem2rx$replaceSeq <- NULL
    .nonmem2rx$replaceDataParItem <- NULL
    class(.lst) <- "repDI"
    .nonmem2rx$replace <- c(.nonmem2rx$replace, list(.lst))
    return(invisible())
  } else if (length(.nonmem2rx$replaceDataParItem) == 2L) {
    .varItem <- .nonmem2rx$replaceDataParItem[2]
    .lst <- list(varType, .dataItem, .varItem, .nonmem2rx$replaceSeq)
    .nonmem2rx$replaceSeq <- NULL
    .nonmem2rx$replaceDataParItem <- NULL
    class(.lst) <- "repDVI"
    .nonmem2rx$replace <- c(.nonmem2rx$replace, list(.lst))

    return(invisible())
  }
  stop(".replaceDataItem error", call.=FALSE)
}
