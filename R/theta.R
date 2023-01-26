#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.the <- function(x) {
  .x <- x
  class(.x) <- NULL
  .Call(`_nonmem2rx_thetanum_reset`)
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_theta`, .cur)
  }
}
