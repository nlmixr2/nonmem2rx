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
#' This handles the theta comments  
#'  
#' @param comment NONMEM comment for a theta
#' @return Nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
.handleThetaComment <- function(comment) {
  .reg1 <- "^;.*?([A-Za-z][A-Za-z0-9_.]*).*"
  if (regexpr(.reg1, comment, perl=TRUE) != -1) {
    .addThetaName(sub(.reg1, "\\1", comment))
  } else {
    .addThetaName("")
  }
  .reg2 <- "^;+ *(.*) +"
  if (regexpr(.reg2, comment) != -1) {
    .comment <- sub(.reg2, "\\1", comment)
    .addIni(paste0("label(", deparse1(.comment), ")"))
  }
}
#' This pushes the $theta into the ini({}) block
#'  
#' @param theta theta ini statement
#' @param comment comment for parsing
#' @param label is the nonmem defined label (NM75)
#' @param skipComment for when adding comment/label is skipped (used
#'   with `NAMES()`)
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.pushTheta <- function(theta, comment, label, skipComment) {
  if (theta != "") {
    .addIni(theta)
    if (skipComment == 0) {
      .handleThetaComment(comment)
      .nonmem2rx$thetaNonmemLabel <- c(.nonmem2rx$thetaNonmemLabel,
                                       label)
    }
  } else {
    .handleThetaComment(comment)
    .nonmem2rx$thetaNonmemLabel <- c(.nonmem2rx$thetaNonmemLabel,
                                     label)
  }
}
#' Get the theta number
#'
#' @param v string
#' @return the number (as a string)
#' @noRd
#' @author Matthew L. Fidler
.getThetaNum <- function(v) {
  .w <- which(tolower(v) == tolower(.nonmem2rx$thetaNonmemLabel))
  if (length(.w) == 1L) return(paste(.w))
  stop(paste0("cannot uniquely determine THETA(", v, ")"), call.=FALSE)
}

#' Creates the theta midpoint estimate info $theta style (low,,hi)
#'  
#' @param low Low estimate
#' @param hi Hi estimate
#' @return midpoint estimate 
#' @noRd
#' @author Matthew L. Fidler
.thetaMidpoint <- function(low, hi) {
  .low <- as.numeric(low)
  .hi <- as.numeric(hi)
  .mid <- (.low+.hi)/2.0
  warning("theta estimate (",.low," ,, ",.hi,") not supported by 'rxode2' converted to c(",
          .low, ", ", .mid, ", ", .hi, ")",
          call.=FALSE)
  as.character(.mid)
}
