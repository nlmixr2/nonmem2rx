#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.ome <- function(x) {
  .x <- x
  class(.x) <- NULL
  .Call(`_nonmem2rx_omeganum_reset`)
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_omega`, .cur, "eta")
  }
}

