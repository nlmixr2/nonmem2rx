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
    if (missing(covsInterpolation)) {
      covsInterpolation <- "nocb"
      .minfo("using nocb interpolation like NONMEM, specify directly to change")
    }
    if (!missing(nStud)) {
      if (missing(dfSub)) {
        if (!is.null(object$dfSub)){
          dfSub <- object$dfSub
          .minfo(paste0("using dfSub=", dfSub, " from NONMEM"))
        }
      }
      if (missing(dfObs)) {
        if (!is.null(object$dfObs)){
          dfObs <- object$dfObs
          .minfo(paste0("using dfObs=", dfObs, " from NONMEM"))
        }
      }
      if (missing(thetaMat)) {
        if (!is.null(object$thetaMat)){
          thetaMat <- object$thetaMat
          .minfo(paste0("using thetaMat from NONMEM"))
        }
      }
    }
    # The theta/omega comes from the ui
    if (missing(sigma)) {
      if (is.null(object$predDf)) {
        # if a true nlmixr2 model, this is not needed
        if (!is.null(object$sigma)){
          sigma <- object$sigma
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
      atol <- object$atol
      .minfo(paste0("using NONMEM specified atol=", atol))
    }
    if (missing(rtol)) {
      rtol <- object$rtol
      .minfo(paste0("using NONMEM specified rtol=", rtol))
    }
    if (missing(ssRtol)) {
      ssRtol <- object$ssRtol
      .minfo(paste0("using NONMEM specified ssRtol=", ssRtol))
    }
    if (missing(ssAtol)) {
      ssAtol <- object$ssAtol
      .minfo(paste0("using NONMEM specified ssAtol=", ssAtol))
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
  invisible("")
}
## nocov end
