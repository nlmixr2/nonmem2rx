#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.inp <- function(x) {
  .x <- x
  class(.x) <- NULL
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_input`, .cur)
  }
}
#' Add input item to .nonmem2  
#'  
#' @param item1 input name 1
#' @param item2 input name 2
#' @return Nothing called for side effets
#' @noRd
#' @author Matthew L. Fidler
.addInputItem <- function(item1, item2) {
  if (!exists("input", envir=.nonmem2rx)) .nonmem2rx$input <- NULL
  .ret <- item2
  names(.ret) <- item1
  .nonmem2rx$input <- c(.nonmem2rx$input, .ret)
  invisible()
}
