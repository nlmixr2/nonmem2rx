.isEmptyExpr <- function(x) {
  .x <- unlist(strsplit(x, "\n"))
  all(regexpr("^([ \t]*|[ \t]*;.*)$", .x) != -1)
}

#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.pk <- function(x) {
  .x <- x
  class(.x) <- NULL
  for (.cur in .x) {
    if (.isEmptyExpr(.cur)) stop("the $PK record is empty", call.=FALSE)
    .Call(`_nonmem2rx_trans_abbrev`, .cur, "$PK", .nonmem2rx$abbrevLin, as.integer(.nonmem2rx$extendedCtl))
  }
}
#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.pre <- function(x) {
  .x <- x
  class(.x) <- NULL
  for (.cur in .x) {
    if (.isEmptyExpr(.cur)) stop("the $PRED record is empty", call.=FALSE)
    .Call(`_nonmem2rx_trans_abbrev`, .cur, "$PRED", .nonmem2rx$abbrevLin, as.integer(.nonmem2rx$extendedCtl))
  }
}

#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.des <- function(x) {
  .x <- x
  class(.x) <- NULL
  for (.cur in .x) {
    if (.isEmptyExpr(.cur)) stop("the $DES record is empty", call.=FALSE)
    .Call(`_nonmem2rx_trans_abbrev`, .cur, "$DES", .nonmem2rx$abbrevLin, as.integer(.nonmem2rx$extendedCtl))
  }
}

#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.mix <- function(x) {
  .x <- x
  class(.x) <- NULL
  for (.cur in .x) {
    if (.isEmptyExpr(.cur)) stop("the $MIX record is empty", call.=FALSE)
    message(.cur)
    .Call(`_nonmem2rx_trans_abbrev`, .cur, "$MIX", .nonmem2rx$abbrevLin, as.integer(.nonmem2rx$extendedCtl))
  }
  .nonmem2rx$mixp <- sort(unique(.nonmem2rx$mixp))
  if (length(.nonmem2rx$mixp) != .nonmem2rx$nspop) {
    stop(paste0("specified ", .nonmem2rx$nspop,
                " mixture probabilities but only provided probability for ",
                length(.nonmem2rx$mixp), " populations"),
         call.=FALSE)
  }
  if (!all(diff(.nonmem2rx$mixp) == 1L)) {
    stop("probabilities in mixture models must specify all sequential values, ie, P(1), P(2)",
         call.=FALSE)
  }
  # define the simulated mixnum
  .addModel(paste0("MIXNUM <- rxord(",
                   paste(paste0("rxp.", .nonmem2rx$mixp[-length(.nonmem2rx$mixp)],"."),
                         collapse=", "),
                   ")"))
  .addModel("cur.mixp <- -1")
  # define cur.mixp which nonmem translates from MIXP and MIXP(MIXNUM)
  .addModel(paste(paste0("if (MIXNUM == ", .nonmem2rx$mixp, ") cur.mixp <- rxp.", .nonmem2rx$mixp, "."),
                  collapse="\n"))
  # MIXP(#) is translated in the grammar
}

#' @export
#' @rdname nonmem2rxRec
nonmem2rxRec.err <- function(x) {
  .x <- x
  class(.x) <- NULL
  # Add F for linear models
  if (.nonmem2rx$abbrevLin != 0L) {
    .vcOne <- FALSE
    if (!.nonmem2rx$hasVol) {
      if (.nonmem2rx$abbrevLin == 1L && is.null(.nonmem2rx$scaleVol[["scale1"]])) {
        .minfo("Assuming a central volume of 1")
        .addModel("VC <- 1")
        .vcOne <- TRUE
      }
      if (.nonmem2rx$abbrevLin == 2L && is.null(.nonmem2rx$scaleVol[["scale2"]])) {
        .minfo("Assuming a central volume of 1")
        .addModel("VC <- 1")
        .vcOne <- TRUE
      }
    }
    .addModel("rxLinCmt1 <- linCmtFun")
    .nonmem2rx$vcOne <- .vcOne
    if (.vcOne || length(.nonmem2rx$allVol) == 0L) {
      .addModel(paste0("centralLin <- rxLinCmt1"))
    } else {
      # can be v or v1/v2 depending on the advan/trans combo
      .w <- which(tolower(.nonmem2rx$allVol) == "v")
      if (length(.w) == 1L) {
        .addModel(paste0("centralLin <- rxLinCmt1*", .nonmem2rx$allVol[.w]))
      } else {
        # v1/v2 determined by abbrevLin
        .w <- which(tolower(.nonmem2rx$allVol) == paste0("v", .nonmem2rx$abbrevLin))
        if (length(.w) == 1L) {
          .addModel(paste0("centralLin <- rxLinCmt1*", .nonmem2rx$allVol[.w]))
        } else {
          .minfo("cannot determine volume assuming central=linear compartment model")
          .addModel(paste0("centralLin <- rxLinCmt1"))
        }
      }
    }
  }
  # in rxode2 scale is automatically calculated for linear models based on volume
  # volume needs to be divided out
  if (.nonmem2rx$abbrevLin == 1L) {
    if (!is.null(.nonmem2rx$scaleVol[["scale1"]])) {
      .addModel(paste0("scale1 <- scale1/", .nonmem2rx$scaleVol[["scale1"]]))
    }
    .Call(`_nonmem2rx_trans_abbrev`, "F = A(1)", "$ERROR", .nonmem2rx$abbrevLin+3L, as.integer(.nonmem2rx$extendedCtl))
  } else if (.nonmem2rx$abbrevLin == 2L) {
    if (!is.null(.nonmem2rx$scaleVol[["scale2"]])) {
      .addModel(paste0("scale2 <- scale2/", .nonmem2rx$scaleVol[["scale2"]]))
    }
    .Call(`_nonmem2rx_trans_abbrev`, "F = A(2)", "$ERROR", .nonmem2rx$abbrevLin+3L, as.integer(.nonmem2rx$extendedCtl))
  } else {
    .cmt <- .nonmem2rx$defobs
    .Call(`_nonmem2rx_trans_abbrev`, sprintf("F = A(%d)%s",.cmt, .getScale(.cmt, des=TRUE)), "$ERROR", .nonmem2rx$abbrevLin, as.integer(.nonmem2rx$extendedCtl))
  }
  for (.cur in .x) {
    if (.isEmptyExpr(.cur)) stop("the $ERROR record is empty", call.=FALSE)
    .Call(`_nonmem2rx_trans_abbrev`, .cur, "$ERROR", .nonmem2rx$abbrevLin, as.integer(.nonmem2rx$extendedCtl))
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
#' If called, sets the flag that we need nmid in the dataset
#'
#' @return none, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.needNmid <- function() {
  .nonmem2rx$needNmid <- TRUE
}
#' Sets the flag that we need ytype renamed to rxytype
#'
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.needYtype <- function() {
  .nonmem2rx$needYtype <- TRUE
}
#' Tells the parser that a volume is in the model
#'
#' @param vol volume
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.hasVolume <- function(vol) {
  .nonmem2rx$allVol <- unique(c(.nonmem2rx$allVol, vol))
  .nonmem2rx$hasVol <- TRUE
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
  .nonmem2rx$etaMax <- max(.nonmem2rx$etaMax, i-1L)
}

#' Push the maximum observed THETA
#'
#' @param i theta number
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.pushObservedMaxTheta  <- function(i) {
  .nonmem2rx$thetaMax <- max(.nonmem2rx$thetaMax, i-1L)
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
  if (length(.ret) > 0) {
    warning("some thetas/etas are missing in the model. Added to dummy rxMissingVars#",
            call.=FALSE)
    .ret <- paste(paste0("rxMissingVars", seq_along(.ret), " <- ", .ret), collapse="\n")
    return(paste0(.ret, "\n"))
  }
  ""
}
#' Needs variable for exit statement
#'
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.needExit <- function() {
  .nonmem2rx$needExit <- TRUE
}
#' Track that NONMEM defined a variable
#'
#' @param lhs variable being defined
#' @return nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addLhsVar <- function(lhs) {
  .nonmem2rx$lhsDef <- c(.nonmem2rx$lhsDef, lhs)
}
.normalizeEsnLabel <- function(theta) {
  .theta <- tolower(theta)
  .dups <- unique(.theta[duplicated(.theta)])
  if (length(.dups) > 0) {
    .nonmem2rx$esnDups <- c(.nonmem2rx$esnDups, .dups)
    .theta[.theta %in% .dups] <- NA_character_
  }
  .theta
}
#'  Calulate the final covariates or nonmem input data items
#'
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.calcFinalInputNames <- function() {
  .inp <- .nonmem2rx$input
  if (is.null(.inp)) {
    .nonmem2rx$finalInput <- character(0)
  } else {
    .w <- which(.inp == "DROP")
    .inp <- .inp[-.w]
    .inp <- unique(c(names(.inp), setNames(.inp, NULL)))
    .nonmem2rx$finalInput <- tolower(.inp)
  }
  .theta <- tolower(.nonmem2rx$theta)
  .dups <- unique(.theta[duplicated(.theta)])
  .theta[.theta %in% .dups] <- NA_character_
  .nonmem2rx$thetaLow <- .normalizeEsnLabel(.nonmem2rx$theta)
  .nonmem2rx$etaLabelLow <- .normalizeEsnLabel(.nonmem2rx$etaLabel)
  .nonmem2rx$epsLabelLow <- .normalizeEsnLabel(.nonmem2rx$epsLabel)
  .nonmem2rx$needExtCalc <- FALSE
}
#' Get the variable name considering extended control streams
#'
#' @param var Variable to consider
#' @return variable (if nothing changed) or theta/eta/eps
#' @noRd
#' @author Matthew L. Fidler
.getExtendedVar <- function(var) {
  if (!.nonmem2rx$extendedCtl) return(var)
  .v <- tolower(var)
  .lhs <- tolower(.nonmem2rx$lhsDef)
  if (length(.lhs) > 1) {
    .lhs <- .lhs[-length(.lhs)]
    if (.v %in% .lhs) return(var)
  }
  if (.nonmem2rx$needExtCalc) {
    .calcFinalInputNames()
  }
  if (.v %in% .nonmem2rx$finalInput) return(var)
  .w <- which(.v == .nonmem2rx$thetaLow)
  if (length(.w) == 1L) {
    .pushObservedThetaObs(.w)
    .ret <- paste0("theta", .w)
    return(.ret)
  }
  .w <- which(.v == .nonmem2rx$etaLabelLow)
  if (length(.w) == 1L) {
    .pushObservedEtaObs(.w)
    .ret <- paste0("eta", .w)
    return(.ret)
  }
  .w <- which(.v == .nonmem2rx$epsLabelLow)
  if (length(.w) == 1L) {
    .ret <- paste0("eps", .w)
    return(.ret)
  }
  var
}
#' Add a mixture probability to the rxode2 translation
#'
#' @param mixp Mixture probability number
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addMixP <- function(mixp) {
  .nonmem2rx$mixp <- c(.nonmem2rx$mixp, mixp)
}
#' Add nspop info to the rxode2 translation
#'
#' @param nspop number of mixture populations
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.setNspop <- function(nspop) {
  .nonmem2rx$nspop <- nspop
}
