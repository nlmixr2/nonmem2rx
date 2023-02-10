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
  # Add F for linear models
  if (.nonmem2rx$abbrevLin != 0L) {
    .addModel("rxLinCmt1 <- linCmt()")
  }
  # in rxode2 scale is automatically calculated for linear models based on volume
  # volume needs to be divided out
  if (.nonmem2rx$abbrevLin == 1L) {
    if (!is.null(.nonmem2rx$scaleVol[["scale1"]])) {
      .addModel(paste0("scale1 <- scale1/", .nonmem2rx$scaleVol[["scale1"]]))
    }
    .Call(`_nonmem2rx_trans_abbrev`, "F = A(1)", "$ERROR", .nonmem2rx$abbrevLin+3L)
  } else if (.nonmem2rx$abbrevLin == 2L) {
    if (!is.null(.nonmem2rx$scaleVol[["scale2"]])) {
      .addModel(paste0("scale2 <- scale2/", .nonmem2rx$scaleVol[["scale2"]]))
    }
    .Call(`_nonmem2rx_trans_abbrev`, "F = A(2)", "$ERROR", .nonmem2rx$abbrevLin+3L)
  } else {
    .cmt <- .nonmem2rx$defobs
    .Call(`_nonmem2rx_trans_abbrev`, sprintf("F = A(%d)%s",.cmt, .getScale(.cmt, des=TRUE)), "$ERROR", .nonmem2rx$abbrevLin)
  }
  for (.cur in .x) {
    .Call(`_nonmem2rx_trans_abbrev`, .cur, "$ERROR", .nonmem2rx$abbrevLin)
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
#' @param des is this an ODE system
#' @return string "/scale#" if present  an empty string "" if not present
#' @noRd
#' @author Matthew L. Fidler
.getScale <- function(scale, des=FALSE) {
  if (scale %in% .nonmem2rx$scale) return(sprintf("/%s%d", ifelse(des, "S", "scale"), scale))
  ""
}

#' Set maximum number of compartments
#'
#' @param maxa maximum 
#' @return nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
.setMaxA <- function(maxa) {
  .nonmem2rx$maxa <- max(maxa, .nonmem2rx$maxa)
  invisible()
}
#' If called, sets the flag that we need nmevid in the dataset
#'
#' @return none, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.needNmevid <- function() {
  .nonmem2rx$needNmevid <- TRUE
}
#' Push defined volume information in the scaling
#'  
#' @param scale Scale integer representing 
#' @param volume volume defined while defining scale
#' @return none, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.pushScaleVolume <- function(scale, volume) {
  if (scale == -2L) {
    .scale <- "scalec"
  } else {
    .scale <- sprintf("scale%d", scale)
  }
  .scaleVol <- .nonmem2rx$scaleVol
  .scaleVol <- c(.scaleVol, setNames(list(volume), .scale))
  .nonmem2rx$scaleVol <- .scaleVol
}
#' Push observed sigma(#, #) into translation queue
#'
#' @param x integer of the row of the sigma matrix
#' @param y integer of the column of the sigma matrix
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.pushSigmaEst <- function(x, y) {
  .w <- which(.nonmem2rx$sigmaEst$x == x && .nonmem2rx$sigmaEst$y == y)
  if (length(.w) != 0L) return(invisible())
  .nonmem2rx$sigmaEst <- rbind(.nonmem2rx$sigmaEst, data.frame(x=x, y=y))
}

#' Push observed omega(#, #) into translation queue  
#'  
#' @param x integer of the row of the omega matrix
#' @param y integer of the column of the omega matrix
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.pushOmegaEst <- function(x, y) {
  .w <- which(.nonmem2rx$omegaEst$x == x && .nonmem2rx$omegaEst$y == y)
  if (length(.w) != 0L) return(invisible()) 
  .nonmem2rx$omegaEst <- rbind(.nonmem2rx$omegaEst, data.frame(x=x, y=y))
}

#' Push observed theta(#) in NONMEM
#'
#' @param i compartment number that was observed
#'
#' @return nothing, called for side effects
#'
#' @noRd
#' @author Matthew L. Fidler
.pushObservedThetaObs <- function(i) {
  .nonmem2rx$thetaObs <- unique(c(.nonmem2rx$thetaObs, i))
}

#' Push observed eta(#) in NONMEM
#'
#' @param i compartment number that was observed
#'
#' @return nothing, called for side effects
#'
#' @noRd
#' @author Matthew L. Fidler
.pushObservedEtaObs <- function(i) {
  .nonmem2rx$etaObs <- unique(c(.nonmem2rx$etaObs, i))
}
#' Push the maximum observed ETA
#'  
#' @param i eta number
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.pushObservedMaxEta <- function(i) {
  .nonmem2rx$etaMax <- max(.nonmem2rx$etaMax, i)
}

#' Push the maximum observed THETA
#'  
#' @param i theta number
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.pushObservedMaxTheta  <- function(i) {
  .nonmem2rx$thetaMax <- max(.nonmem2rx$thetaMax, i)
}

#' Push observed dadt(#) in NONMEM
#'
#' @param i compartment number that was observed
#'
#' @return nothing, called for side effects
#'
#' @noRd
#' @author Matthew L. Fidler
.pushObservedDadt <- function(i) {
  .nonmem2rx$dadt <- unique(c(.nonmem2rx$dadt, i))
}
#' Give the des prefix for the model
#'
#' This will include the cmt order specification as well as add
#' missing dadt definitions
#'
#' @return String representing the cmt definition
#' @noRd
#' @author Matthew L. Fidler
.desPrefix <- function() {
  if (.nonmem2rx$abbrevLin != 0L) return("")
  if (.nonmem2rx$maxa == 0L) return("")
  .sl <- seq_len(.nonmem2rx$maxa)
  .df <- setdiff(.sl, .nonmem2rx$dadt)
  .ret <- paste0(paste(paste0("cmt(rxddta", .sl, ")"),
                       collapse="\n"), "\n")
  if (length(.df) > 0) {
    warning("not all the compartments had DADT(#) defined!",
            call.=FALSE)
    .ret <- paste0(.ret, paste(paste0("d/dt(rxddta", .df, ") <- 0"), collapse="\n"),
                   "\n")
  }
  .ret
}
#' Puts in any missing parameter definitions
#'  
#' @return missing parameters
#' @noRd
#' @author Matthew L. Fidler
.missingPrefix <- function() {
  .maxTheta <- .nonmem2rx$thetaMax
  .sl <- seq_len(.maxTheta)
  .ret <- character(0)
  .sl <- seq_len(.maxTheta)
  .df <- setdiff(.sl, .nonmem2rx$thetaObs)
  if (length(.df) > 0) {
    .ret <- c(.ret, paste0("theta", .df))
  }
  .maxEta <- .nonmem2rx$etaMax
  .sl <- seq_len(.maxEta)
  .df <- setdiff(.sl, .nonmem2rx$etaObs)
  if (length(.df) > 0) {
    .ret <- c(.ret, paste0("eta", .df))
  }
  if (length(.df)) {
    warning("some thetas/etas are missing in the model. Added to dummy rxMissingVars#",
            call.=FALSE)
    .ret <- paste(paste0("rxMissingVars", seq_along(.ret), " <- ", .ret), collapse="\n")
    return(paste0(.ret, "\n"))
  }
  ""
}
