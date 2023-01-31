#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.pk <- function(x) {
  .x <- x
  class(.x) <- NULL
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_abbrev`, .cur, "$PK", .nonmem2rx$abbrevLin)
  }
}
#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.pre <- function(x) {
  .x <- x
  class(.x) <- NULL
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_abbrev`, .cur, "$PRED", .nonmem2rx$abbrevLin)
  }
}

#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.des <- function(x) {
  .x <- x
  class(.x) <- NULL
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_abbrev`, .cur, "$DES", .nonmem2rx$abbrevLin)
  }
}

#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.err <- function(x) {
  .x <- x
  class(.x) <- NULL
  for (.cur in .x) {
    # eventually multiply by 3 so that in err a(central) = linCmt()/scale1 or linCmt()/scale2
    # and a(depot) = amtLast*exp(-tlast*ka)
    .Call(`_nonmem2rx_trans_abbrev`, .cur, "$ERROR", .nonmem2rx$abbrevLin)
  }
}
