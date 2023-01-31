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
    # add 3 so that in err a(central) = linCmt()/scale1 or linCmt()/scale2
    # and a(depot) = dose(depot)*exp(-tad(depot)*ka)/scale1
    .Call(`_nonmem2rx_trans_abbrev`, .cur, "$ERROR", .nonmem2rx$abbrevLin+3L)
  }
}
#' Add the parameters scaled for rode2 translation
#'
#' @param scale integer showing what scale has been defined
#' @return nothing, called for side effects
#' @author Matthew L. Fidler
#' @noRd
.addScale <- function(scale) {
  if (scale %in% .nonmem2rx$scale) {
    warning(sprintf("there are two scale%d defined, only using last defined",
                 scale),
         call.=FALSE)
  } else {
    .nonmem2rx$scale <- c(.nonmem2rx$scale, scale)
  }
  invisible()
}
#' Get scale for compartment (if defined) 
#'  
#' @param scale integer for compartment
#' @return string "/scale#" if present  an empty string "" if not present
#' @noRd
#' @author Matthew L. Fidler
.getScale <- function(scale) {
  if (scale %in% .nonmem2rx$scale) return(sprintf("/scale%d", scale))
  ""
}
