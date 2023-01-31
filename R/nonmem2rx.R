.nonmem2rx <- new.env(parent=emptyenv())
#' Clear the .nonmem2rx environment
#'  
#' @return Nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.clearNonmem2rx <- function() {
  .ls <- ls(all.names=TRUE, envir=.nonmem2rx)
  if (length(.ls) > 0L) rm(list=.ls,envir=.nonmem2rx)
  .nonmem2rx$ini <- NULL
  .nonmem2rx$model <- NULL
  .nonmem2rx$abbrevLin <- 0L # ode; 1 = linCmt() no ka; 2= linCmt() ka
  .nonmem2rx$scale <- NULL
  .nonmem2rx$advan <- 0L
  .nonmem2rx$trans <- 0L
  .nonmem2rx$addPar <- NA_character_
}
#' Is this ipred or f?  
#'  
#' @param x expression  
#' @return TRUE if this is ipred/f
#' @noRd
#' @author Matthew L. Fidler
.isIpredOrF <- function(x) {
  if (length(x) != 1L) return(FALSE)
  .c <- tolower(as.character(x))
  .nonmem2rx$curF <- .c
  return(.c %in% c("ipred", "f"))
}
#' Is this w*eps1 ?
#'
#' @param x expression
#' @return TRUE if this is w*eps1
#' @noRd
#' @author Matthew L. Fidler
.isWtimesEps <- function(x) {
  if (length(x) != 3L) return(FALSE)
  if (!identical(x[[1]], quote(`*`))) return(FALSE)
  if (length(x[[2]]) !=1L) return(FALSE)
  if (length(x[[3]]) !=1L) return(FALSE)
  all(sort(tolower(c(as.character(x[[2]]), as.character(x[[3]])))) == c("eps1", "w"))
}
#' Determines if expression line is the fixed theta with w approach
#'
#' @param x expression 
#' @return logical determining if this is the w fixed parameter approach
#' @noRd
#' @author Matthew L. Fidler
#' @noRd
.isParamWeps <- function(x) {
  if (length(x) != 3L) return(FALSE)
  if (identical(x[[1]], quote(`<-`)) || identical(x[[1]], quote(`=`))) return(.isParamWeps(x[[3]]))
  if (!identical(x[[1]], quote(`+`))) return(FALSE)
  .isIpredOrF(x[[2]]) && .isWtimesEps(x[[3]]) ||
    .isIpredOrF(x[[3]]) && .isWtimesEps(x[[2]])
}
#' Is this an additive W expression?
#'
#'  
#' @param x expression 
#' @return lodical saying if this is an additive error model
#' @noRd
#' @author Matthew L. Fidler
.isAddW <- function(x) {
  if (length(x) == 3L && (identical(x[[1]], quote(`<-`)) || identical(x[[1]], quote(`=`)))) {
    return(.isAddW(x[[3]]))
  }  
  if (length(x) != 1L) return(FALSE)
  .theta <- as.character(x)
  if (regexpr("theta[0-9]+", .theta) != -1) {
    .nonmem2rx$addPar <- .theta
    return(TRUE)
  }
  FALSE
}

#' Determine type of residual error for common models
.determineError <- function(rxui, sigma) {
  # Additive: f+eps(1)
  # proportional: f*(1+eps(1))
  # Additive + Proportional: f*(1+eps(1)) + eps(2)
  # lognormal: log(f) + eps(1)
  # with W
  # Additive + Proportional comb2: sqrt(theta1^2+theta2^2*ipred^2)
  # proportional: theta1*ipred
  # additive: theta1
  # Additive + Proportional comb1: theta1 + theta2*ipred
  .wy <- which(vapply(rxui$lstExpr, function(e) {
    if (identical(e[[1]], quote(`<-`)) || identical(e[[2]], quote(`=`))) {
      if (length(e[[2]]) == 1L && tolower(as.character(e[[2]])) == "y") return(TRUE)
    }
    FALSE
  }, logical(1), USE.NAMES = FALSE))
  if (length(.wy) != 1) return(rxui)
  .y <- rxui$lstExpr[[.wy]]
  if (.isParamWeps(.y)) {
    .ww <- which(vapply(rxui$lstExpr, function(e) {
      if (identical(e[[1]], quote(`<-`)) || identical(e[[2]], quote(`=`))) {
        if (length(e[[2]]) == 1L && tolower(as.character(e[[2]])) == "w") return(TRUE)
      }
      FALSE
    }, logical(1), USE.NAMES = FALSE))
    if (length(.ww) != 1) return(rxui)
    .wp <- rxui$lstExpr[.ww]
  }
}
#' Add theta name to .nonmem2rx info
#'
#' @param theta string representing variable name
#' @return Nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addThetaName <- function(theta) {
  assign("theta", c(.nonmem2rx$theta, theta), envir=.nonmem2rx)
}
#' Add to initialization block
#'
#' @param text Line to add to the initialization block
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addIni <- function(text) {
  assign("ini", c(.nonmem2rx$ini, text), envir=.nonmem2rx)
}
#' Add to model block
#'
#' @param text line to add to the model block
#' @return nothing, called for side effects
#' @noRd
#' @author Matthew L. Fidler
.addModel <- function(text) {
  assign("model", c(.nonmem2rx$model, text), envir=.nonmem2rx)
}
#' Use lower case for the lhs defined parts of the model
#'
#' @param rxui rxui object
#' @return lower cased rxui object
#' @noRd
#' @author Matthew L. Fidler
.toLowerLhs <- function(rxui) {
  .mv <- rxode2::rxModelVars(rxui)
  .lhs <- tolower(.mv$lhs)
  .rhs <- .mv$lhs
  eval(parse(text=paste0("rxode2::rxRename(rxui, ", paste(paste(.lhs,"=",.rhs, sep=""), collapse=", "), ")")))    
}
#' Replace theta names
#'  
#' @param rxui rxode2 ui
#' @param thetaNames theta names that will be replaced in the model
#' @return New ui with theta replaced
#' @noRd
#' @author Matthew L. Fidler
.replaceThetaNames <- function(rxui, thetaNames) {
  if (length(thetaNames) == 0) return(rxui)
  .mv <- rxode2::rxModelVars(rxui)
  .dups <- unique(thetaNames[duplicated(thetaNames)])
  if (length(.dups) > 0) {
    thetaNames[(thetaNames %in% .dups)] <- ""
    warning("there are duplicate theta names, not renaming duplicate parameters",
            call.=FALSE)
  }
  .n <- vapply(thetaNames, function(v) {
    if (v == "") return("")
    if (v %in% .mv$lhs) {
      return(paste0("t.", v))
    }
    v
  }, character(1), USE.NAMES = FALSE)
  .t <- rxui$iniDf$name[!is.na(rxui$iniDf$ntheta)]
  .w <- which(.n == "")
  if (length(.w) > 0) {
    .n <- .n[-.w]
    .t <- .t[-.w]
  }
  eval(parse(text=paste0("rxode2::rxRename(rxui, ", paste(paste(.n,"=", .t, sep=""), collapse=", "), ")")))          
}

#' Convert a NONMEM source file to a rxode control
#'
#' @param file NONMEM control file location
#'
#' @return rxode2 function
#' @eval .nonmem2rxBuildGram()
#' @export
#'
#' @useDynLib nonmem2rx, .registration=TRUE
#' @importFrom Rcpp sourceCpp
#' @importFrom stats setNames
#' @importFrom lotri lotri
#' @importFrom dparser mkdparse
#' @examples
#' nonmem2rx(system.file("run001.mod", package="nonmem2rx"))
nonmem2rx <- function(file, tolowerLhs=TRUE, thetaNames=TRUE) {
  loadNamespace("dparser")
  checkmate::assertLogical(tolowerLhs, len=1, any.missing = FALSE)
  .clearNonmem2rx()
  if (file.exists(file)) {
    .lines <- paste(readLines(file), collapse = "\n")
  } else {
    .lines <- file
  }
  .parseRec(.lines)
  if (inherits(thetaNames, "logical")) {
    if (thetaNames) {
      thetaNames <- .nonmem2rx$theta
    } else {
      thetaNames <- character(0)
    }
  }
  if (length(.nonmem2rx$sigma) > 0L) {
    .sigma <- eval(parse(text=paste0("lotri::lotri({\n",
                                paste(.nonmem2rx$sigma, collapse="\n"),
                                "\n})")))
  }
  .fun <- eval(parse(text=paste0("function() {\n",
                         "rxode2::ini({\n",
                         paste(.nonmem2rx$ini, collapse="\n"),
                         "\n})\n",
                         "rxode2::model({\n",
                         paste(.nonmem2rx$model, collapse="\n"),
                         "\n})",
                         "}")))
  .rx <- .fun()
  if (tolowerLhs) {
    .rx <- .toLowerLhs(.rx)
  }
  .rx <- .replaceThetaNames(.rx, thetaNames)
  .rx
}

## nocov start
### Parser build
.nonmem2rxBuildRecord <- function() {
  cat("Update Parser c for record locator\n");
  dparser::mkdparse(devtools::package_file("inst/records.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxRecords")
  file.rename(devtools::package_file("src/records.g.d_parser.c"),
              devtools::package_file("src/records.g.d_parser.h"))
}

.nonmem2rxBuildOmega <- function() {
  cat("Update Parser c for omega block\n");
  dparser::mkdparse(devtools::package_file("inst/omega.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxOmega")
  file.rename(devtools::package_file("src/omega.g.d_parser.c"),
              devtools::package_file("src/omega.g.d_parser.h"))
}



.nonmem2rxBuildTheta <- function() {
  cat("Update Parser c for theta block\n");
  dparser::mkdparse(devtools::package_file("inst/theta.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxTheta")
  file.rename(devtools::package_file("src/theta.g.d_parser.c"),
              devtools::package_file("src/theta.g.d_parser.h"))
}

.nonmem2rxBuildModel <- function() {
  cat("Update Parser c for model block\n");
  dparser::mkdparse(devtools::package_file("inst/model.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxModel")
  file.rename(devtools::package_file("src/model.g.d_parser.c"),
              devtools::package_file("src/model.g.d_parser.h"))
}

.nonmem2rxBuildInput <- function() {
  cat("Update Parser c for input block\n");
  dparser::mkdparse(devtools::package_file("inst/input.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxInput")
  file.rename(devtools::package_file("src/input.g.d_parser.c"),
              devtools::package_file("src/input.g.d_parser.h"))
}

.nonmem2rxBuildAbbrev <- function() {
  cat("Update Parser c for abbrev block\n");
  dparser::mkdparse(devtools::package_file("inst/abbrev.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxAbbrev")
  file.rename(devtools::package_file("src/abbrev.g.d_parser.c"),
              devtools::package_file("src/abbrev.g.d_parser.h"))
}

.nonmem2rxBuildSub <- function() {
  cat("Update Parser c for sub block\n");
  dparser::mkdparse(devtools::package_file("inst/sub.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxSub")
  file.rename(devtools::package_file("src/sub.g.d_parser.c"),
              devtools::package_file("src/sub.g.d_parser.h"))
}




.nonmem2rxBuildGram <- function() {
  .nonmem2rxBuildRecord()
  .nonmem2rxBuildTheta()
  .nonmem2rxBuildOmega()
  .nonmem2rxBuildModel()
  .nonmem2rxBuildInput()
  .nonmem2rxBuildAbbrev()
  .nonmem2rxBuildSub()
  invisible("")
  
}
## nocov end
