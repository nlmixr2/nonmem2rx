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
  .nonmem2rx$maxa <- 0L
  .nonmem2rx$addPar <- NA_character_
  .nonmem2rx$propPar <- NA_character_
}
#' Is this ipred or f?  
#'  
#' @param x expression  
#' @return TRUE if this is ipred/f
#' @noRd
#' @author Matthew L. Fidler
.isIpredOrF <- function(x) {
  if (length(x) != 1L) return(FALSE)
  .c0 <-as.character(x)
  .c <- tolower(.c0)
  if (.c %in% c("ipred", "f")) {
    .nonmem2rx$curF <- .c0
    return(TRUE)
  }
  FALSE
}
#' Is this theta1*f
.isThetaF <- function(x) {
  if (length(x) != 3L) return(FALSE)
  if (!identical(x[[1]], quote(`*`))) return(FALSE)
  if (.isIpredOrF(x[[2]])) {
    .theta <- as.character(x[[3]])
  } else if (.isIpredOrF(x[[3]])) {
    .theta <- as.character(x[[2]])
  } else {
    return(FALSE)
  }
  if (regexpr("theta[0-9]+", .theta) != -1) {
    .nonmem2rx$propPar <- .theta
    return(TRUE)
  }
  FALSE
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
#' Is the w expression represent a proportional error?
#'  
#' @param x expression
#' @return logical
#' @noRd
#' @author Matthew L. Fidler
.isPropW <- function(x) {
  if (length(x) == 3L && (identical(x[[1]], quote(`<-`)) || identical(x[[1]], quote(`=`)))) {
    return(.isPropW(x[[3]]))
  }
  return(.isThetaF(x))
}
#' Test for add+prop combination 1
#'
#'  
#' @param x expression
#' @return logical saying if the expression is add+prop comb 1
#' @noRd
#' @author Matthew L. Fidler
.isAddPropW1 <- function(x) {
  if (length(x) != 3L) return(FALSE)
  if (identical(x[[1]], quote(`<-`)) || identical(x[[1]], quote(`=`))) {
    return(.isAddPropW1(x[[3]]))
  }
  if (!identical(x[[1]], quote(`+`))) return(FALSE)
  .isThetaF(x[[2]]) &&  .isAddW(x[[3]]) ||
    .isThetaF(x[[3]]) &&  .isAddW(x[[2]])
}
#' Is this expression theta^2
#'
#' It also checks theta*theta
#'  
#' @param x expression
#' @param useF boolean to check for F expressions instead of theta expressions
#' @return boolean
#' @noRd
#' @author Matthew L. Fidler
.isTheta2 <- function(x, useF=FALSE) {
  if (length(x) != 3) return(FALSE)
  if (identical(x[[1]], quote(`^`)) ||
        identical(x[[1]], quote(`**`))) {
    if (length(x[[2]]) != 1) return(FALSE)
    if (x[[3]] != 2) return(FALSE)
    if (isTRUE(useF) && .isIpredOrF(x[[2]])) return(TRUE)
    .theta <- as.character(x[[2]])
    if (regexpr("theta[0-9]+", .theta) != -1) {
      if (is.na(useF)){
        .nonmem2rx$propPar <- .theta
      } else {
        .nonmem2rx$addPar <- .theta
      }
      return(TRUE)
    }
  } else if (identical(x[[1]], quote(`*`))) {
    if (length(x[[2]]) != 1) return(FALSE)
    if (isTRUE(useF)) {
      return(.isIpredOrF(x[[2]]) && .isIpredOrF(x[[3]]))
    }
    if (!identical(x[[2]], x[[3]])) return(FALSE)
    .theta <- as.character(x[[2]])
    if (regexpr("theta[0-9]+", .theta) != -1) {
      if (is.na(useF)){
        .nonmem2rx$propPar <- .theta
      } else {
        .nonmem2rx$addPar <- .theta
      }
      return(TRUE)
    }
  }
  FALSE
}

#' Is this theta^2 * f^2
#'  
#' @param x expression
#' @return boolean
#' @noRd
#' @author Matthew L. Fidler
.isTheta2F2 <- function(x) {
  if (length(x) == 3L && identical(x[[1]], quote(`*`))) {
    .mult1 <- x[[2]]
    .mult2 <- x[[3]]
    ## in the case of f^2*theta1*theta1 length(.mult2) == 1
    if (length(.mult2) == 1L) {
      ## This works for:
      ##f^2*theta1*theta1
      ## This works for theta1*f^2*theta1
      ## theta1 * theta1 * f * f
      if (identical(.mult1[[1]], quote(`*`))) {
        if (identical(.mult2, .mult1[[3]])) {
          .mult1 <- .mult1[[2]]
          .mult2 <- as.call(list(quote(`*`), .mult2, .mult2))
        } else if (identical(.mult2, .mult1[[2]])) {
          .mult1 <- .mult1[[3]]
          .mult2 <- as.call(list(quote(`*`), .mult2, .mult2))
        } else if (identical(.mult1[[1]], quote(`*`))) {
          # theta1 * f * f * theta1
          .mult12 <- .mult1[[2]]
          .mult13 <- .mult1[[3]]
          if (identical(.mult2, .mult12[[2]])) {
            .mult1 <- as.call(list(quote(`*`), .mult12[[3]], .mult13))
            .mult2 <- as.call(list(quote(`*`), .mult2, .mult2))
          } else if (identical(.mult2, .mult12[[3]])) {
            .mult1 <- as.call(list(quote(`*`), .mult12[[2]], .mult13))
            .mult2 <- as.call(list(quote(`*`), .mult2, .mult2))
          }
        }
      }
    } 
    return(.isTheta2(.mult1, useF=NA) && .isTheta2(.mult2, useF=TRUE) ||
             .isTheta2(.mult1, useF=TRUE) && .isTheta2(.mult2, useF=NA))
  }
  FALSE
}
#' Is it add+prop comb2() 
#'
#' @param x expression
#' @return boolean
#' @noRd
#' @author Matthew L. Fidler
.isAddPropW2 <- function(x) {
  if (length(x) == 3L && (identical(x[[1]], quote(`<-`)) || identical(x[[1]], quote(`<-`)))) {
    return(.isAddPropW2(x[[3]]))
  }
  if (length(x) == 2L && identical(x[[1]], quote(`sqrt`))) {
    .x <- x[[2]]
    if (length(.x) != 3L) return(FALSE)
    if (identical(.x[[1]], quote(`+`))) {
      return(.isTheta2(.x[[2]]) && .isTheta2F2(.x[[3]]) ||
               .isTheta2(.x[[3]]) && .isTheta2F2(.x[[2]]))
    }
  }
  FALSE
}
#' Remove W related 
#'  
#' @param rxui ui object
#' @param text model piping test to modify
#' @return full model piping test to modify the nlmixr2 model
#' @noRd
#' @author Matthew L. Fidler
.removeWrelated <- function(rxui, text) {
  .iwres <- which(vapply(rxui$lstExpr, function(e) {
    if (identical(e[[1]], quote(`<-`)) || identical(e[[2]], quote(`=`))) {
      if (length(e[[2]]) == 1L && tolower(as.character(e[[2]])) == "iwres") return(TRUE)
    }
    FALSE
  }, logical(1), USE.NAMES = FALSE))
  if (length(.iwres) != 1) return(text)
  text <- paste0("rxode2::model(", text, ", -",as.character(rxui$lstExpr[[.iwres]][[2]]),")")
  .w <- which(vapply(rxui$lstExpr, function(e) {
    if (identical(e[[1]], quote(`<-`)) || identical(e[[2]], quote(`=`))) {
      if (length(e[[2]]) == 1L && tolower(as.character(e[[2]])) == "w") return(TRUE)
    }
    FALSE
  }, logical(1), USE.NAMES = FALSE))
  if (length(.w) != 1) return(text)
  text <- paste0("rxode2::model(", text, ", -",as.character(rxui$lstExpr[[.w]][[2]]),")")
  .ires <- which(vapply(rxui$lstExpr, function(e) {
    if (identical(e[[1]], quote(`<-`)) || identical(e[[2]], quote(`=`))) {
      if (length(e[[2]]) == 1L && tolower(as.character(e[[2]])) == "ires") return(TRUE)
    }
    FALSE
  }, logical(1), USE.NAMES = FALSE))
  if (length(.ires) != 1) return(text)
  paste0("rxode2::model(", text, ", -",as.character(rxui$lstExpr[[.ires]][[2]]),")")
}
#' This tries to parse the type of error and change to a fully qualified nlmixr2 object
#'  
#' @param rxui rxui object
#' @return rxui object possibly modified to be a nlmixr2 compatible function
#' @noRd
#' @author Matthew L. Fidler
.determineError <- function(rxui) {
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
    .wp <- rxui$lstExpr[[.ww]]
    if (.isAddW(.wp)) {
      .y0 <- as.character(.y[[2]])
      .mod <- paste0("rxode2::model(rxode2::model(rxui, {", .nonmem2rx$curF,
                     "~ add(", .nonmem2rx$addPar, ")}, append = TRUE), -", .y0, ")")
      return(eval(parse(text=.removeWrelated(rxui, .mod))))
    } else if (.isPropW(.wp)) {
      .y0 <- as.character(.y[[2]])
      .mod <- paste0("rxode2::model(rxode2::model(rxui, {", .nonmem2rx$curF,
                     "~ prop(", .nonmem2rx$propPar, ")}, append = TRUE), -", .y0, ")")
      return(eval(parse(text=.removeWrelated(rxui, .mod))))
    } else if (.isAddPropW1(.wp)) {
      .y0 <- as.character(.y[[2]])
      .mod <- paste0("rxode2::model(rxode2::model(rxui, {", .nonmem2rx$curF,
                     "~ add(", .nonmem2rx$addPar, ") + prop(", .nonmem2rx$propPar,
                     ") + combined1()}, append = TRUE), -", .y0, ")")
      return(eval(parse(text=.removeWrelated(rxui, .mod))))
    } else if (.isAddPropW2(.wp)) {
      .y0 <- as.character(.y[[2]])
      .mod <- paste0("rxode2::model(rxode2::model(rxui, {", .nonmem2rx$curF,
                     "~ add(", .nonmem2rx$addPar, ") + prop(", .nonmem2rx$propPar,
                     ") + combined2()}, append = TRUE), -", .y0, ")")
      return(eval(parse(text=.removeWrelated(rxui, .mod))))
    }
  }
  rxui
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
  .w <- which(.lhs == .rhs)
  if (length(.w) > 0) {
    .lhs <- .lhs[-.w]
    .rhs <- .rhs[-.w]
  }
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
    # They can't even match based on case or it can interfere with linCmt()
    if (tolower(v) %in% tolower(c(.mv$lhs, .mv$params))) {
      return(paste0("t.", v))
    }
    if (.nonmem2rx$abbrevLin != 0L) {
      # linear compartment protection by making sure parameters won't
      # collide ie Vc and V1 in the model
      if (regexpr("^[kvcqabg]", tolower(v)) != -1) {
        return(paste0("t.", v))
      }
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

.replaceCmtNames <- function(rxui) {
  if (!exists("cmtName", envir=.nonmem2rx))  return(rxui)
  .mv <- rxode2::rxModelVars(rxui)
  .n <- vapply(.nonmem2rx$cmtName,
               function(v) {
                 v <- gsub(" +", "_", v)
                 if (tolower(v) %in% tolower(c(.mv$lhs, .mv$params))) {
                   return(paste0("c.", v))
                 }
                 if (regexpr("^[0-9]", v) != -1) {
                   return(paste0("c.", v))
                 }
                 v
               }, character(1), USE.NAMES=FALSE)
  .c <- paste0("rxddta",seq_along(.n))
  eval(parse(text=paste0("rxode2::rxRename(rxui, ", paste(paste(.n,"=", .c, sep=""), collapse=", "), ")")))          
}

#' Convert a NONMEM source file to a rxode control
#,'
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
                         ifelse(.nonmem2rx$abbrevLin == 0L,
                                paste0(paste(paste0("cmt(rxddta", seq(1,.nonmem2rx$maxa), ")"), collapse="\n"), "\n"),
                                ""),
                         paste(.nonmem2rx$model, collapse="\n"),
                         "\n})",
                         "}")))
  .rx <- .fun()
  .rx <- .determineError(.rx)
  if (tolowerLhs) {
    .rx <- .toLowerLhs(.rx)
  }
  .rx <- .replaceThetaNames(.rx, thetaNames)
  .rx <- .replaceCmtNames(.rx)
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

.nonmem2rxBuildLst <- function() {
  cat("Update Parser c for lst final estimate parsing\n");
  dparser::mkdparse(devtools::package_file("inst/lst.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxLst")
  file.rename(devtools::package_file("src/lst.g.d_parser.c"),
              devtools::package_file("src/lst.g.d_parser.h"))
}

.nonmem2rxBuildGram <- function() {
  .nonmem2rxBuildRecord()
  .nonmem2rxBuildTheta()
  .nonmem2rxBuildOmega()
  .nonmem2rxBuildModel()
  .nonmem2rxBuildInput()
  .nonmem2rxBuildAbbrev()
  .nonmem2rxBuildSub()
  .nonmem2rxBuildLst()
  invisible("")
  
}
## nocov end
