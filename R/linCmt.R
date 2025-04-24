
# comes from rxDerived regexp
.linCmtParReg <- "^(?:(?:(?:V|Q|VP|VT|CLD)[[:digit:]])|KA|VP|VT|CLD|V|VC|CL|VSS|K|KE|KEL|Q|VT|(?:K[[:digit:]][[:digit:]])|AOB|ALPHA|BETA|GAMMA|A|B|C).*$"

# translations to rxode2

.linCmtAdvan <- new.env(parent=emptyenv())

.linCmtAdvan$`1` <- new.env(parent=emptyenv())
.linCmtAdvan$`1`$`1` <- c("K"="k", "#"="v")
.linCmtAdvan$`1`$`2` <- c("CL"="cl", "#"="v")

.linCmtAdvan$`2` <- new.env(parent=emptyenv())
.linCmtAdvan$`2`$`1` <- c("KA"="ka", "K"="k", "#"="v")
.linCmtAdvan$`2`$`2` <- c("KA"="ka", "CL"="cl", "#"="v")

.linCmtAdvan$`3` <- new.env(parent=emptyenv())
# #1 = volume associated with cmt1
.linCmtAdvan$`3`$`1` <- c("K"="k", "K12"="k12", "K21"="k21", "#"="vc")
.linCmtAdvan$`3`$`3` <- c("CL"="cl", "V"="v", "Q"="q", "VSS"="vss")
.linCmtAdvan$`3`$`4` <- c("CL"="cl", "V1"="v1", "Q"="q", "V2"="v2")
.linCmtAdvan$`3`$`5` <- c("AOB"="aob", "ALPHA"="alpha", "BETA"="beta","#"="vc")
.linCmtAdvan$`3`$`6` <- c("ALPHA"="alpha", "BETA"="beta", "K21"="k21", "#"="vc")

.linCmtAdvan$`4` <- new.env(parent=emptyenv())
# #2 = volume associated with cmt2
.linCmtAdvan$`4`$`1` <- c("KA"="ka", "K"="k", "K23"="k23", "K32"="k32", "#"="vc")
.linCmtAdvan$`4`$`3` <- c("CL"="cl", "V"="v", "Q"="q", "VSS"="vss", "KA"="ka")
.linCmtAdvan$`4`$`4` <- c("CL"="cl", "V2"="v2", "Q"="q", "V3"="v3", "KA"="ka")
.linCmtAdvan$`4`$`5` <- c("AOB"="aob", "ALPHA"="alpha", "BETA"="beta", "KA"="ka", "#"="vc")

.linCmtAdvan$`11` <- new.env(parent=emptyenv())
.linCmtAdvan$`11`$`1` <- c("K"="k", "K12"="k12", "K21"="k21", "K13"="k13","K31"="k31", "#"="vc")
.linCmtAdvan$`11`$`4` <- c(	"CL"="cl", "V1"="v1", "Q2"="q2", "V2"="v2", "Q3"="q3", "V3"="v3")

.linCmtAdvan$`12` <- new.env(parent=emptyenv())
.linCmtAdvan$`12`$`1` <- c("KA"="ka", "K"="k", "K23"="k23", "K32"="k32", "K24"="k24", "K42"="k42", "#"="vc")
.linCmtAdvan$`12`$`2` <- c("CL"="cl", "V2"="Vc", "Q3"="q1", "V3"="Vp1", "Q4"="q2", "V4"="Vp2", "KA"="ka")
#' Get the translation of rxode2 to NONMEM
#'
#' @param advan advan of NONMEM
#' @param trans trans of NONMEM
#' @return Gives translations for nonmem->rxode2
#' @noRd
#' @author Matthew L. Fidler
.getLinCmt <- function(advan=1, trans=1) {
  if (!exists(paste(advan), envir=.linCmtAdvan)) return(NULL)
  .advan <- get(paste(advan), envir=.linCmtAdvan)
  if (!exists(paste(trans), envir=.advan)) return(NULL)
  get(paste(trans), envir=.advan)
}
#'  Get the linear compartment model with blessed params
#'
#' @param model rxode2 model
#' @param advan advan of NONMEM
#' @param trans trans of NONMEM
#' @return Model with blessed parameters
#' @noRd
#' @author Matthew L. Fidler
.getLinCmtModel <- function(model, advan=1, trans=1) {
  if (trans==0) trans <- 1
  .rep <- .getLinCmt(advan=advan, trans=trans)
  if (is.null(.rep)) return(model)
  .w <- which(names(.rep) == "#")
  if (length(.w) == 1L) {
    if (length(.nonmem2rx$allVol) == 1L) {
      names(.rep)[.w] <- .nonmem2rx$allVol[1]
    } else if (.nonmem2rx$vcOne) {
      names(.rep)[.w] <- "VC"
    } else {
      .w2 <- which(tolower(.nonmem2rx$allVol) == "v")
      if (length(.w2) == 1L) {
        names(.rep)[.w] <- "V"
      } else {
        .w2 <- which(tolower(.nonmem2rx$allVol) == "vc")
        if (length(.w2) == 1L) {
          names(.rep)[.w] <- "V"
        } else {
          .w2 <- which(tolower(.nonmem2rx$allVol) == paste0("v", .nonmem2rx$abbrevLin))
          if (length(.w2) == 1) {
            names(.rep)[.w] <- paste0("V", .nonmem2rx$abbrevLin)
          } else if (length(.nonmem2rx$allVol) > 0) {
            .nchar <- vapply(.nonmem2rx$allVol, function(i) {
              nchar(.nonmem2rx$allVol[i])
            }, integer(1), USE.NAMES=FALSE)
            .min <- min(.nchar)
            .w2 <- which(.nchar == .min)[1]
            names(.rep)[.w] <- .nonmem2rx$allVol[.w2]
          } else {
            stop("can't figure out volume for linCmt() model", call.=FALSE) #nocov
          }
        }
      }
    }
  }
  # in the case of the one compartment model, Vs are not always
  # specified and could be different
  .mv <- rxode2::rxModelVars(model)
  .lhs <- toupper(.mv$lhs)
  .lhsIn <- .mv$lhs
  .lhsOut <- vapply(.lhsIn, function(x) {
    .up <- toupper(x)
    if (.up %in% names(.rep)) return(.rep[.up])
    if (grepl(.linCmtParReg, x, perl=TRUE)) {
      return(paste0("rxm.", x))
    }
    x
  }, character(1), USE.NAMES=TRUE)
  .w <- which(.lhsIn != .lhsOut)
  .lhsIn <- .lhsIn[.w]
  .lhsOut <- .lhsOut[.w]

  .ret <- eval(parse(text=paste0("rxode2::rxRename(model,",paste(paste0(.lhsOut, "=", .lhsIn), collapse=", "),")")))
  .ret <- rxode2::rxUiDecompress(.ret)
  .lstExpr <- .ret$lstExpr
  .w <- which(vapply(seq_along(.lstExpr), function(y) {
    x <- .lstExpr[[y]]
    if (length(x) == 3L && identical(x[[1]], quote(`=`))) {
      if (identical(x[[2]],str2lang("d/dt(depot)")) &&
            identical(x[[3]], 0)) {
        return(TRUE)
      }
      if (identical(x[[2]],str2lang("d/dt(central)")) &&
            identical(x[[3]], 0)) {
        return(TRUE)
      }
    }
    FALSE
  }, logical(1), USE.NAMES=FALSE))
  # at this point there shouldn't be an endpoint
  if (!is.null(.ret$predDf)) stop("at this point there shouldn't be an endpoint", call.=FALSE) #nocov
  .model <- lapply(seq_along(.lstExpr)[-.w],
                   function(i) {
                     x <- .lstExpr[[i]]
                     if (length(x)== 3L && identical(x[[1]], quote(`<-`))) {
                       if (identical(x[[2]], quote(`centralLin`))) {
                         x[[2]] <- str2lang("central")
                       } else if (identical(x[[2]], quote(`rxLinCmt1`))) {
                         x[[3]] <- str2lang("linCmt()")
                       }
                     }
                     x
                   })
  if (length(.w) > 0 && packageVersion("rxode2") >= "4.0.0") {
    .w  <- which(vapply(seq_along(.model),
                        function(i) {
                          identical(.model[[i]], str2lang("central <- rxLinCmt1"))
                        }, logical(1), USE.NAMES=FALSE))
    .model <- lapply(seq_along(.model)[-.w],
                     function(i) {
                       .model[[i]]
                     })
  }
  .ini <- as.expression(lotri::as.lotri(.ret$iniDf))
  .ini[[1]] <- str2lang("ini")
  .model <- as.call(c(list(quote(`{`)), .model))
  .model <- as.call(c(list(quote(`model`)), .model))
  .fun0 <- as.call(c(list(quote(`{`)), .ini, .model))
  .fun <- function() {}
  body(.fun) <- .fun0
  .ret <- try(.fun(), silent=TRUE)
  if (inherits(.ret, "try-error")) {
    message(paste(deparse(.fun), collapse="\n"))
    stop("error parsing linCmt() translation:\n",
         attr(.ret, "condition")$message,
         "\ntranslation printed out so far",
         call.=FALSE)
  }
  .ret
}
