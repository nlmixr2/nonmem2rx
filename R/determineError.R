#' Is this a simple theta expression?
#'
#' This will also check for aliases the model ie `var=theta1`
#'
#' @param var variable to determine if it is a simple theta
#' @param rxui rxode2 ui to search aliases (or null to skip search)
#' @return theta number if it has been found, otherwise `FALSE`
#' @noRd
#' @author Matthew L. Fidler
.isTheta <- function(var, rxui=NULL) {
  if (regexpr("theta[0-9]+", var) != -1) {
    return(var)
  }
  if (is.null(rxui)) return(FALSE)
  .env <- new.env(parent=emptyenv())
  .wt <- which(vapply(rxui$lstExpr, function(e) {
    if (identical(e[[1]], quote(`<-`)) || identical(e[[2]], quote(`=`))) {
      if (length(e[[2]]) == 1L && as.character(e[[2]]) == var) {
        .v <- deparse1(e[[3]])
        if (regexpr("theta[0-9]+", .v) != -1) {
          .env$v <- .v
          return(TRUE)
        }
      }
    }
    FALSE
  }, logical(1), USE.NAMES = FALSE))
  if (length(.wt) == 1L) return(.env$v)
  FALSE
}

#' Is this ipred or f?  
#'  
#' @param x expression
#' @param rxui the ui to help with determination of expressions
#' @return TRUE if this is ipred/f
#' @noRd
#' @author Matthew L. Fidler
.isIpredOrF <- function(x, rxui=NULL) {
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
#'  
#' @param x expression
#' @param rxui the ui to help with determination of expressions
#' @return TRUE if this is ipred/f
#' @noRd
#' @author Matthew L. Fidler
.isThetaF <- function(x, rxui) {
  if (length(x) != 3L) return(FALSE)
  if (!identical(x[[1]], quote(`*`))) return(FALSE)
  if (.isIpredOrF(x[[2]], rxui=rxui)) {
    .theta <- as.character(x[[3]])
  } else if (.isIpredOrF(x[[3]], rxui=rxui)) {
    .theta <- as.character(x[[2]])
  } else {
    return(FALSE)
  }
  .cur <- .isTheta(.theta, rxui)
  if (isFALSE(.cur)) return(FALSE)
  .nonmem2rx$propPar <- .cur
  TRUE
}
#' Is this w*eps1 ?
#'
#' @param x expression
#' @param rxui ui to help determine error structure
#' @return TRUE if this is w*eps1
#' @noRd
#' @author Matthew L. Fidler
.isWtimesEps <- function(x, rxui=NULL) {
  if (length(x) != 3L) return(FALSE)
  if (!identical(x[[1]], quote(`*`))) return(FALSE)
  if (length(x[[2]]) !=1L) return(FALSE)
  if (length(x[[3]]) !=1L) return(FALSE)
  all(sort(tolower(c(as.character(x[[2]]), as.character(x[[3]])))) == c("eps1", "w"))
}
#' Determines if expression line is the fixed theta with w approach
#'
#' @param x expression
#' @param rxui is the ui to help figure out values
#' @return logical determining if this is the w fixed parameter approach
#' @noRd
#' @author Matthew L. Fidler
#' @noRd
.isParamWeps <- function(x, rxui=NULL) {
  if (length(x) != 3L) return(FALSE)
  if (identical(x[[1]], quote(`<-`)) || identical(x[[1]], quote(`=`))) return(.isParamWeps(x[[3]]))
  if (!identical(x[[1]], quote(`+`))) return(FALSE)
  .isIpredOrF(x[[2]], rxui=rxui) && .isWtimesEps(x[[3]], rxui=rxui) ||
    .isIpredOrF(x[[3]], rxui=rxui) && .isWtimesEps(x[[2]], rxui=rxui)
}
#' Is this an additive W expression?
#'
#'  
#' @param x expression
#' @param rxui ui object
#' @return logical saying if this is an additive error model
#' @noRd
#' @author Matthew L. Fidler
.isAddW <- function(x, rxui=NULL) {
  if (length(x) == 3L &&
        (identical(x[[1]], quote(`<-`))
          || identical(x[[1]], quote(`=`)))) {
    return(.isAddW(x[[3]], rxui=rxui))
  }
  if (length(x) != 1L) return(FALSE)
  .theta <- as.character(x)
  .cur <- .isTheta(.theta, rxui)
  if (isFALSE(.cur)) return(FALSE)
  .nonmem2rx$addPar <- .cur
  TRUE
}
#' Is the w expression represent a proportional error?
#'  
#' @param x expression
#' @param rxui ui object
#' @return logical
#' @noRd
#' @author Matthew L. Fidler
.isPropW <- function(x, rxui=NULL) {
  if (length(x) == 3L && (identical(x[[1]], quote(`<-`)) ||
                            identical(x[[1]], quote(`=`)))) {
    return(.isPropW(x[[3]], rxui=rxui))
  }
  return(.isThetaF(x, rxui=rxui))
}
#' Test for add+prop combination 1
#'
#'  
#' @param x expression
#' @return logical saying if the expression is add+prop comb 1
#' @noRd
#' @author Matthew L. Fidler
.isAddPropW1 <- function(x, rxui=NULL) {
  if (length(x) != 3L) return(FALSE)
  if (identical(x[[1]], quote(`<-`)) || identical(x[[1]], quote(`=`))) {
    return(.isAddPropW1(x[[3]], rxui=rxui))
  }
  if (!identical(x[[1]], quote(`+`))) return(FALSE)
  .isThetaF(x[[2]], rxui=rxui) &&  .isAddW(x[[3]], rxui=rxui) ||
    .isThetaF(x[[3]], rxui=rxui) &&  .isAddW(x[[2]], rxui=rxui)
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
.isTheta2 <- function(x, rxui= NULL, useF=FALSE) {
  if (length(x) != 3) return(FALSE)
  if (identical(x[[1]], quote(`^`)) ||
        identical(x[[1]], quote(`**`))) {
    if (length(x[[2]]) != 1) return(FALSE)
    if (x[[3]] != 2) return(FALSE)
    if (isTRUE(useF) && .isIpredOrF(x[[2]], rxui=rxui)) return(TRUE)
    .theta <- as.character(x[[2]])
    .cur <- .isTheta(.theta, rxui)
    if (!isFALSE(.cur)) {
      if (is.na(useF)){
        .nonmem2rx$propPar <- .cur
      } else {
        .nonmem2rx$addPar <- .cur
      }
      return(TRUE)
    }
  } else if (identical(x[[1]], quote(`*`))) {
    if (length(x[[2]]) != 1) return(FALSE)
    if (isTRUE(useF)) {
      return(.isIpredOrF(x[[2]], rxui=rxui) && .isIpredOrF(x[[3]], rxui=rxui))
    }
    if (!identical(x[[2]], x[[3]])) return(FALSE)
    .theta <- as.character(x[[2]])
    .cur <- .isTheta(.theta, rxui)
    if (!isFALSE(.cur)) {
      if (is.na(useF)){
        .nonmem2rx$propPar <- .cur
      } else {
        .nonmem2rx$addPar <- .cur
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
.isTheta2F2 <- function(x, rxui = NULL) {
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
    return(.isTheta2(.mult1, rxui=rxui, useF=NA) &&
             .isTheta2(.mult2, rxui=rxui, useF=TRUE) ||
             .isTheta2(.mult1, rxui=rxui, useF=TRUE) &&
             .isTheta2(.mult2, rxui=rxui, useF=NA))
  }
  FALSE
}
#' Is it add+prop comb2() 
#'
#' @param x expression
#' @return boolean
#' @noRd
#' @author Matthew L. Fidler
.isAddPropW2 <- function(x, rxui=NULL) {
  if (length(x) == 3L && (identical(x[[1]], quote(`<-`)) || identical(x[[1]], quote(`<-`)))) {
    return(.isAddPropW2(x[[3]], rxui=rxui))
  }
  if (length(x) == 2L && identical(x[[1]], quote(`sqrt`))) {
    .x <- x[[2]]
    if (length(.x) != 3L) return(FALSE)
    if (identical(.x[[1]], quote(`+`))) {
      return(.isTheta2(.x[[2]], rxui=rxui) && .isTheta2F2(.x[[3]], rxui=rxui) ||
               .isTheta2(.x[[3]], rxui=rxui) && .isTheta2F2(.x[[2]], rxui=rxui))
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
  if (.isParamWeps(.y, rxui=rxui)) {
    .ww <- which(vapply(rxui$lstExpr, function(e) {
      if (identical(e[[1]], quote(`<-`)) || identical(e[[2]], quote(`=`))) {
        if (length(e[[2]]) == 1L && tolower(as.character(e[[2]])) == "w") return(TRUE)
      }
      FALSE
    }, logical(1), USE.NAMES = FALSE))
    if (length(.ww) != 1) return(rxui)
    .wp <- rxui$lstExpr[[.ww]]
    if (.isAddW(.wp, rxui=rxui)) {
      .y0 <- as.character(.y[[2]])
      .mod <- paste0("rxode2::model(rxode2::model(rxui, {", .nonmem2rx$curF,
                     "~ add(", .nonmem2rx$addPar, ")}, append = TRUE), -", .y0, ")")
      .ret <- try(eval(parse(text=.removeWrelated(rxui, .mod))), silent=TRUE)
      if (inherits(.ret, "try-error")) return(rxui)
      return(.ret)
    } else if (.isPropW(.wp, rxui=rxui)) {
      .y0 <- as.character(.y[[2]])
      .mod <- paste0("rxode2::model(rxode2::model(rxui, {", .nonmem2rx$curF,
                     "~ prop(", .nonmem2rx$propPar, ")}, append = TRUE), -", .y0, ")")
      .ret <- try(eval(parse(text=.removeWrelated(rxui, .mod))), silent=TRUE)
      if (inherits(.ret, "try-error")) return(rxui)
      return(.ret)
    } else if (.isAddPropW1(.wp, rxui=rxui)) {
      .y0 <- as.character(.y[[2]])
      .mod <- paste0("rxode2::model(rxode2::model(rxui, {", .nonmem2rx$curF,
                     "~ add(", .nonmem2rx$addPar, ") + prop(", .nonmem2rx$propPar,
                     ") + combined1()}, append = TRUE), -", .y0, ")")
      .ret <- try(eval(parse(text=.removeWrelated(rxui, .mod))), silent=TRUE)
      if (inherits(.ret, "try-error")) return(rxui)
      return(.ret)
    } else if (.isAddPropW2(.wp, rxui=rxui)) {
      .y0 <- as.character(.y[[2]])
      .mod <- paste0("rxode2::model(rxode2::model(rxui, {", .nonmem2rx$curF,
                     "~ add(", .nonmem2rx$addPar, ") + prop(", .nonmem2rx$propPar,
                     ") + combined2()}, append = TRUE), -", .y0, ")")
      .ret <- try((eval(parse(text=.removeWrelated(rxui, .mod)))), silent=TRUE)
      if (inherits(.ret, "try-error")) return(rxui)
      return(.ret)
    }
  }
  rxui
}
