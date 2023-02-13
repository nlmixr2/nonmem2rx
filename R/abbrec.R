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

