## nocov start
### Parser build
.nonmem2rxBuildOmega <- function() {
  message("Update Parser c for omega block")
  dparser::mkdparse(devtools::package_file("inst/omega.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxOmega")
  file.rename(devtools::package_file("src/omega.g.d_parser.c"),
              devtools::package_file("src/omega.g.d_parser.h"))
}



.nonmem2rxBuildTheta <- function() {
  message("Update Parser c for theta block")
  dparser::mkdparse(devtools::package_file("inst/theta.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxTheta")
  file.rename(devtools::package_file("src/theta.g.d_parser.c"),
              devtools::package_file("src/theta.g.d_parser.h"))
}

.nonmem2rxBuildModel <- function() {
  message("Update Parser c for model block")
  dparser::mkdparse(devtools::package_file("inst/model.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxModel")
  file.rename(devtools::package_file("src/model.g.d_parser.c"),
              devtools::package_file("src/model.g.d_parser.h"))
}

.nonmem2rxBuildInput <- function() {
  message("Update Parser c for input block")
  dparser::mkdparse(devtools::package_file("inst/input.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxInput")
  file.rename(devtools::package_file("src/input.g.d_parser.c"),
              devtools::package_file("src/input.g.d_parser.h"))
}

.nonmem2rxBuildAbbrev <- function() {
  message("Update Parser c for abbreviated code")
  dparser::mkdparse(devtools::package_file("inst/abbrev.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxAbbrev")
  file.rename(devtools::package_file("src/abbrev.g.d_parser.c"),
              devtools::package_file("src/abbrev.g.d_parser.h"))
}

.nonmem2rxBuildAbbrevRec <- function() {
  message("Update Parser c for abbreviated record")
  dparser::mkdparse(devtools::package_file("inst/abbrec.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxAbbrevRec")
  file.rename(devtools::package_file("src/abbrec.g.d_parser.c"),
              devtools::package_file("src/abbrec.g.d_parser.h"))
}


.nonmem2rxBuildSub <- function() {
  message("Update Parser c for sub block")
  dparser::mkdparse(devtools::package_file("inst/sub.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxSub")
  file.rename(devtools::package_file("src/sub.g.d_parser.c"),
              devtools::package_file("src/sub.g.d_parser.h"))
}

.nonmem2rxBuildLst <- function() {
  message("Update Parser c for lst final estimate parsing")
  dparser::mkdparse(devtools::package_file("inst/lst.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxLst")
  file.rename(devtools::package_file("src/lst.g.d_parser.c"),
              devtools::package_file("src/lst.g.d_parser.h"))
}

.nonmem2rxBuildData <- function() {
  message("Update Parser c for data block")
  dparser::mkdparse(devtools::package_file("inst/data.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxData")
  file.rename(devtools::package_file("src/data.g.d_parser.c"),
              devtools::package_file("src/data.g.d_parser.h"))
}

.nonmem2rxBuildTab <- function() {
  message("Update Parser c for tab block")
  dparser::mkdparse(devtools::package_file("inst/tab.g"),
                    devtools::package_file("src/"),
                    grammar_ident="nonmem2rxTab")
  file.rename(devtools::package_file("src/tab.g.d_parser.c"),
              devtools::package_file("src/tab.g.d_parser.h"))
}

.nonmem2rxBuildRxSolve <- function() {
  message("build options for rxSolve to match NONMEM")
  .args <- deparse(eval(str2lang(paste0("args(rxode2::rxSolve)"))))
  .args[1] <- paste0("rxSolve.nonmem2rx <-", .args[1])
  .args <- .args[-length(.args)]
  .extra <- quote({
    if (missing(cores)) {
      cores <- 0L
    }
    if (missing(covsInterpolation)) {
      covsInterpolation <- "nocb"
      .minfo("using nocb interpolation like NONMEM, specify directly to change")
    }
    if (missing(addlKeepsCov)) {
      .minfo("using addlKeepsCov=TRUE like NONMEM, specify directly to change")
      addlKeepsCov <- TRUE
    }
    if (missing(addlDropSs)) {
      .minfo("using addlDropSs=TRUE like NONMEM, specify directly to change")
      addlDropSs <- TRUE
    }
    if (missing(ssAtDoseTime)) {
      .minfo("using ssAtDoseTime=TRUE like NONMEM, specify directly to change")
      ssAtDoseTime <- TRUE
    }
    if (missing(safeZero)) {
      .minfo("using safeZero=FALSE since NONMEM does not use protection by default")
      safeZero <- TRUE
    }
    if (missing(ss2cancelAllPending)) {
      .minfo("using ss2cancelAllPending=FALSE since NONMEM does not cancel pending doses with SS=2")
      ss2cancelAllPending <- FALSE
    }
    if (!missing(nStud)) {
      if (missing(dfSub)) {
        if (!is.null(object$meta$dfSub)){
          dfSub <- object$meta$dfSub
          .minfo(paste0("using dfSub=", dfSub, " from NONMEM"))
        } else if (!is.null(object$dfSub)) {
          dfSub <- object$dfSub
          .minfo(paste0("using dfSub=", dfSub, " from NONMEM"))
        }
      }
      if (missing(dfObs)) {
        if (!is.null(object$meta$dfObs)) {
          dfObs <- object$meta$dfObs
          .minfo(paste0("using dfObs=", dfObs, " from NONMEM"))
        } else if (!is.null(object$dfObs)) {
          dfObs <- object$dfObs
          dfObs <- object$meta$dfObs
          .minfo(paste0("using dfObs=", dfObs, " from NONMEM"))
        }
      }
      if (missing(thetaMat)) {
        if (!is.null(object$meta$thetaMat)) {
          thetaMat <- object$meta$thetaMat
          .minfo(paste0("using thetaMat from NONMEM"))
        } else if (!is.null(object$thetaMat)) {
          thetaMat <- object$meta$thetaMat
          .minfo(paste0("using thetaMat from NONMEM"))
        }
      }
    }
    # The theta/omega comes from the ui
    if (missing(sigma)) {
      if (is.null(object$predDf)) {
        # if a true nlmixr2 model, this is not needed
        if (!is.null(object$meta$sigma)){
          sigma <- object$meta$sigma
          .minfo(paste0("using sigma from NONMEM"))
        } else if (!is.null(object$sigma)) {
          sigma <- object$meta$sigma
          .minfo(paste0("using sigma from NONMEM"))
        }
      }
    }
    if ((missing(events) && missing(params))) {
      if (!is.null(object$nonmemData)) {
        events <- object$nonmemData
        .minfo(paste0("using NONMEM's data for solving"))
      }
    }
    if (missing(atol)) {
      if (!is.null(object$meta$atol)) {
        atol <- object$meta$atol
        .minfo(paste0("using NONMEM specified atol=", atol))
      } else if (!is.null(object$atol)) {
        atol <- object$atol
        .minfo(paste0("using NONMEM specified atol=", atol))
      }
    }
    if (missing(rtol)) {
      if (!is.null(object$meta$atol)) {
        rtol <- object$meta$rtol
        .minfo(paste0("using NONMEM specified rtol=", rtol))
      } else if (!is.null(object$atol)) {
        rtol <- object$rtol
        .minfo(paste0("using NONMEM specified rtol=", rtol))
      }
    }
    if (missing(ssRtol)) {
      if (!is.null(object$meta$ssRtol)) {
        ssRtol <- object$meta$ssRtol
        .minfo(paste0("using NONMEM specified ssRtol=", ssRtol))
      } else if (!is.null(object$meta$ssRtol)) {
        ssRtol <- object$meta$ssRtol
        .minfo(paste0("using NONMEM specified ssRtol=", ssRtol))
      }
    }
    if (missing(ssAtol)) {
      if (!is.null(object$meta$ssAtol)) {
        ssAtol <- object$meta$ssAtol
        .minfo(paste0("using NONMEM specified ssAtol=", ssAtol))
      } else if (!is.null(object$ssAtol)) {
        ssAtol <- object$ssAtol
        .minfo(paste0("using NONMEM specified ssAtol=", ssAtol))
      }
    }
    .cls <- class(object)
    class(object) <- .cls[-which(.cls == "nonmem2rx")]
  })
  .extra <- vapply(.extra,
                   function(l) {
                     if (identical(l, quote(`{`))) {
                       return("")
                     }
                     return(paste(deparse(l), collapse="\n"))
                   }, character(1), USE.NAMES=FALSE)[-1]
  .args <- c(.args, "{", .extra)
  .formalArgs <- as.character(eval(str2lang(paste0("formalArgs(rxode2::rxSolve)"))))
  .w <- which(.formalArgs == "...")
  .formalArgs <- paste0(.formalArgs, "=", .formalArgs)
  .has3 <- FALSE
  if (length(.w) > 0) {
    .formalArgs[.w] <- "..."
    .has3 <- TRUE
  }
  .formalArgs <- paste(.formalArgs, collapse=", ")
  .formalArgs <- paste0("rxode2::rxSolve(", .formalArgs, ")")
  .args <- c(.args, .formalArgs, "}")
  .args <- paste(.args, collapse="\n")
  .args <- c("# This is built from buildParser.R, edit there",
             "#'@export", deparse(str2lang(.args)))
  writeLines(.args, devtools::package_file("R/rxSolve.R"))
  message("done")
}

.nonmem2rxRxUiGetMethods <- function() {
  message("build rxUiGet options to allow str() and dollar completion")
  .meth <- c("nonmemData"="NONMEM input data from nonmem2rx",
             "etaData"="NONMEM etas input from nonmem2rx",
             "ipredAtol"="50th percentile of the IPRED atol comparison between rxode2 and model import",
             "ipredRtol"="50th percentile of the IPRED rtol comparison between rxode2 and model import",
             "ipredCompare"="Dataset comparing ID, TIME and the IPREDs between rxode2 and model import",
             "predAtol"="50th percentile of the PRED atol comparison between rxode2 and model import",
             "predRtol"="50th percentile of the PRED rtol comparison between rxode2 and model import",
             "predCompare"="Dataset comparing ID, TIME and the PREDs between rxode2 and model import",
             "sigma"="sigma matrix from model import",
             "thetaMat"="covariance matrix",
             "dfSub"="Number of subjects",
             "dfObs"="Number of observations",
             "atol"="atol imported from translation",
             "rtol"="rtol imported from translation",
             "ssRtol"="ssRtol imported from translation",
             "ssAtol"="ssRtol imported from translation")
  .ret <- paste(c("## nocov start",
                  "# This is built from buildParser.R, edit there",
                  vapply(seq_along(.meth), function(i) {
                    .name <- names(.meth)[i]
                    .desc <- setNames(.meth[i], NULL)
                    .ret <- c("",
                              sprintf("rxUiGet.%s <- function(x, ...) {", .name),
                              sprintf("  if (!exists(\"%s\", envir=x[[1]])) return(NULL)", .name),
                              sprintf("  get(\"%s\", envir=x[[1]])", .name),
                              "}",
                              sprintf("attr(rxUiGet.%s, \"desc=\") <- %s", .name, deparse1(.desc)))
                    .ret <- paste(.ret, collapse="\n")
                  }, character(1), USE.NAMES=TRUE),
                  ".rxUiGetRegister <- function() {",
                  vapply(seq_along(.meth), function(i) {
                    .name <- names(.meth)[i]
                    sprintf("  rxode2::.s3register(\"rxode2::rxUiGet\", \"%s\")", .name)
                  }, character(1), USE.NAMES=TRUE),
                  "}",
                  "## nocov end"), collapse="\n")
  writeLines(.ret, devtools::package_file("R/rxUiGetGen.R"))
  message("done")
}



.nonmem2rxBuildGram <- function() {
  .nonmem2rxBuildTheta()
  .nonmem2rxBuildOmega()
  .nonmem2rxBuildModel()
  .nonmem2rxBuildInput()
  .nonmem2rxBuildAbbrev()
  .nonmem2rxBuildSub()
  .nonmem2rxBuildLst()
  .nonmem2rxBuildData()
  .nonmem2rxBuildTab()
  .nonmem2rxBuildAbbrevRec()
  .nonmem2rxBuildRxSolve()
  .nonmem2rxRxUiGetMethods()
  invisible("")
}
## nocov end
