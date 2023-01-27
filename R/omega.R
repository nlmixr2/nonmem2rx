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

#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.sig <- function(x) {
  .x <- x
  class(.x) <- NULL
  print(.x)
  .ini <- .nonmem2rx$ini
  .nonmem2rx$ini <- NULL
  .Call(`_nonmem2rx_omeganum_reset`)
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_omega`, .cur, "eps")
  }
  .nonmem2rx$sigma <- .nonmem2rx$ini
  .nonmem2rx$ini <- .ini
}
