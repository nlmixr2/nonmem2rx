# advan=supported trans
.supportedTrans <-
  list(c(0L, 1L, 2L), #1
       c(0L, 1L, 2L), #2
       c(0L, 1L, 3L, 4L, 5L, 6L), #3
       c(0L, 1L, 3L, 4L, 5L, 6L), #4
       c(0L, 1L), #5
       c(0L, 1L), #6
       c(0L, 1L), #7
       c(0L, 1L), #8
       c(0L, 1L), #9
       c(0L, 1L), #10
       c(0L, 1L, 4L, 6L), #11
       c(0L, 1L, 4L, 6L), #12
       c(0L, 1L), #13
       c(0L, 1L), #14
       c(0L, 1L)) #15

#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.sub <- function(x) {
  # this is to set options for $ERROR processing
  .x <- x
  class(.x) <- NULL
  .nonmem2rx$abbrevLin <- 0L
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_sub`, .cur)
  }
  if (.nonmem2rx$advan %in% c(5L, 7L)) {
    stop("General Linear model translation not supported (ADVAN5 or ADVAN7)",
         call.=FALSE)
  }
  if (.nonmem2rx$advan %in% c(9L, 15L)) {
    stop("Differential Algebra Equations are not supported in translation (ADVAN9 or ADVAN15)",
         call.=FALSE)
  }

  if (.nonmem2rx$advan == 10L) {
    stop("Michelis Menton model translation not supported (ADVAN10)",
         call.=FALSE)
  }
  if (.nonmem2rx$advan %in% c(1L, 3L, 11L)) {
    .nonmem2rx$abbrevLin <- 1L # one compartment without ka
  } else if (.nonmem2rx$advan %in% c(2L, 4L, 12L)) {
    .nonmem2rx$abbrevLin <- 2L # one compartment with ka
  }
  if (.nonmem2rx$advan > 0) {
    if (.nonmem2rx$advan > length(.supportedTrans)) {
      stop(sprintf("Unsupported ADVAN%d", .nonmem2rx$advan),
           call.=FALSE)
    }
    .goodTrans <- .supportedTrans[[.nonmem2rx$advan]]
    if (!(.nonmem2rx$trans %in% .goodTrans)) {
      stop(sprintf("ADVAN%d does not support TRANS%d",
                   .nonmem2rx$advan, .nonmem2rx$trans))
    }
  }

}
#' Set the advan number for model
#'  
#' @param advan integer representing advan number
#' @return Nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
.setAdvan <- function(advan) {
  .nonmem2rx$advan <- advan
  invisible()
}
#'  Set trans number for model
#'  
#' @param trans integer representing
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.setTrans <- function(trans) {
  .nonmem2rx$trans <- trans
  invisible()
}

.setAtol <- function(tol) {
  .nonmem2rx$atol <- 10^(-tol)
}

.setRtol <- function(tol) {
  .nonmem2rx$rtol <- 10^(-tol)
}

.setSsRtol <- function(tol) {
  .nonmem2rx$ssRtol <-10^(-tol)
}

.setSsAtol <- function(tol) {
  .nonmem2rx$ssAtol <- 10^(-tol)
}
