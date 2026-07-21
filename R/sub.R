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
       c(0L, 1L, 4L), #11 , 6L not supported
       c(0L, 1L, 4L), #12, , 6L not supported
       c(0L, 1L), #13
       c(0L, 1L), #14
       c(0L, 1L), #15
       c(0L, 1L), #16 RADAR5 delay differential equation (DDE) solver
       integer(0), #17 RADAR5 delay differential algebraic equation solver (unsupported)
       c(0L, 1L)) #18 DDE_SOLVER delay differential equation (DDE) solver

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
  ## if (.nonmem2rx$advan %in% c(5L, 7L)) {
  ##   stop("General Linear model translation not supported (ADVAN5 or ADVAN7)",
  ##        call.=FALSE)
  ## }
  if (.nonmem2rx$advan %in% c(9L, 15L)) {
    stop("Differential Algebra Equations are not supported in translation (ADVAN9 or ADVAN15)",
         call.=FALSE)
  }

  if (.nonmem2rx$advan == 10L) {
    stop("Michelis Menton model translation not supported (ADVAN10)",
         call.=FALSE)
  }
  if (.nonmem2rx$advan == 17L) {
    stop("Delay Differential Algebraic Equations are not supported in translation (ADVAN17)",
         call.=FALSE)
  }
  if (.nonmem2rx$advan %in% c(16L, 18L)) {
    .minfo(sprintf("NONMEM delay differential equation solver ADVAN%d detected; delayed states (AD_x_y) and past histories (AP_x_y) are translated to rxode2 delay()/past()",
                   .nonmem2rx$advan))
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
  if (!.nonmem2rx$ssAtolSet) {
    .nonmem2rx$ssAtol <- .nonmem2rx$atol
  }
  if (!.nonmem2rx$ssRtolSet) {
    .nonmem2rx$ssRtol <- .nonmem2rx$rtol
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
  .nonmem2rx$ssRtolSet <- TRUE
  .nonmem2rx$ssRtol <-10^(-tol)
}

.setSsAtol <- function(tol) {
  .nonmem2rx$ssAtolSet <- TRUE
  .nonmem2rx$ssAtol <- 10^(-tol)
}
