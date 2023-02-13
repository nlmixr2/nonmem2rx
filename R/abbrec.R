#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.abb <- function(x) {
  .x <- x
  class(.x) <- NULL
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_abbrec`, .cur)
  }
}
