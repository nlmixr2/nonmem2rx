#' Converts to NONMEM id based on ID and time
#'
#' @param id identifier
#' @param time time
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
fromNonmemToRxId <- function(id, time=NULL) {
  if (is.null(time)) {
    time <- as.double(seq_along(id))
  }
  .Call(`_nonmem2rx_fromNonmemToRxId_`, as.integer(id), as.double(time))
}
