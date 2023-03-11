.minfo <- function (text, ..., .envir = parent.frame())
{
    cli::cli_alert_info(gettext(text), ..., .envir = .envir)
}

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
  .nonmem2rx$dataFile <- NA_character_
  .nonmem2rx$dataCond <- character(0)
  .nonmem2rx$dataIgnore1 <- NULL
  .nonmem2rx$dataRecords <- NA_integer_
  .nonmem2rx$needNmevid <- FALSE
  .nonmem2rx$tables <- list()
  .nonmem2rx$scaleVol <- list()
  .nonmem2rx$modelDesc <- NULL
  .nonmem2rx$defdose <- 0L
  .nonmem2rx$defobs <- 0L
  .nonmem2rx$omegaEst <- data.frame(x=integer(0), y=integer(0))
  .nonmem2rx$sigmaEst <- data.frame(x=integer(0), y=integer(0))
  .nonmem2rx$dadt <- integer(0)
  .nonmem2rx$thetaObs <- integer(0)
  .nonmem2rx$etaObs <- integer(0)
  .nonmem2rx$etaMax <- 0L
  .nonmem2rx$thetaMax <- 0L
  .nonmem2rx$epsMax <- 0L
  .nonmem2rx$epsLabel <- NULL
  .nonmem2rx$epsComment <- NULL
  .nonmem2rx$epsNonmemLabel <- NULL
  .nonmem2rx$etaLabel <- NULL
  .nonmem2rx$etaComment <- NULL
  .nonmem2rx$etaNonmemLabel <- NULL
  .nonmem2rx$thetaNonmemLabel <- NULL
  .nonmem2rx$replace <- list()
  .nonmem2rx$replaceSeq <- NULL
  .nonmem2rx$replaceLabel <- NULL
  .nonmem2rx$replaceDataParItem <- NULL
  .nonmem2rx$hasVol <- FALSE
  .nonmem2rx$needYtype <- FALSE
  .nonmem2rx$needExit <- FALSE
  .nonmem2rx$atol <- 1e-12
  .nonmem2rx$rtol <- 1e-12
  .nonmem2rx$ssAtolSet <- FALSE
  .nonmem2rx$ssAtol <- 1e-12
  .nonmem2rx$ssRtolSet <- FALSE
  .nonmem2rx$ssRtol <- 1e-12
  .nonmem2rx$allVol <- NULL
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
  .minfo("changing most variables to lower case")
  .mv <- rxode2::rxModelVars(rxui)
  .rhs <- .mv$lhs
  .w <- which(.rhs %in% .mv$params)
  if (length(.w) > 0)  {
    .rhs <- .rhs[-.w]
  }
  .lhs <- tolower(.rhs)
  .w <- which(.lhs %in% .mv$params)
  if (length(.w) > 0)  {
    .rhs <- .rhs[-.w]
    .lhs <- .lhs[-.w]
  }
  .w <- which(.lhs == .rhs)
  if (length(.w) > 0) {
    .lhs <- .lhs[-.w]
    .rhs <- .rhs[-.w]
  }
  .ret <- eval(parse(text=paste0("rxode2::rxRename(rxui, ", paste(paste(.lhs,"=",.rhs, sep=""), collapse=", "), ")")))
  .minfo("done")
  .ret
}

#' Replace theta names
#'
#' @param rxui rxode2 ui
#' @param thetaNames theta names that will be replaced in the model
#' @return New ui with theta replaced
#' @noRd
#' @author Matthew L. Fidler
.replaceThetaNames <- function(rxui, thetaNames,
                               label="theta", prefix="t.", df=NULL,
                               dn=NULL) {
  if (length(thetaNames) == 0) return(rxui)
  .minfo(sprintf("replace %s names", label))
  .mv <- rxode2::rxModelVars(rxui)
  .dups <- unique(thetaNames[duplicated(thetaNames)])
  if (length(.dups) > 0) {
    thetaNames[(thetaNames %in% .dups)] <- ""
    if (prefix == "t.") {
      warning("there are duplicate theta names, not renaming duplicate parameters",
              call.=FALSE)
    } else {
      warning("there are duplicate eta names, not renaming duplicate parameters",
              call.=FALSE)
    }
  }
  .n <- vapply(thetaNames, function(v) {
    if (v == "") return("")
    # They can't even match based on case or it can interfere with linCmt()
    if (tolower(v) %in% tolower(c(.mv$lhs, .mv$params, "time"))) {
      return(paste0(prefix, v))
    }
    if (.nonmem2rx$abbrevLin != 0L) {
      # linear compartment protection by making sure parameters won't
      # collide ie Vc and V1 in the model
      if (regexpr("^[kvcqabg]", tolower(v)) != -1) {
        return(paste0(prefix, v))
      }
    }
    v
  }, character(1), USE.NAMES = FALSE)
  # These are added by the translator don't include them
  if (prefix == "t.") {
    .t <- rxui$iniDf$name[!is.na(rxui$iniDf$ntheta)]
    .w <- which(regexpr("^(omega|sigma)[.][1-9][0-9]*[.][1-9][0-9]*$", .t) != -1)
    if (length(.w) > 0) {
      .t <- .t[-.w]
    }
  } else {
    .t <- rxui$iniDf$name[which(is.na(rxui$iniDf$ntheta) & rxui$iniDf$neta1 == rxui$iniDf$neta2)]
  }
  .t <- .t[!(.t %in% c("icall", "irep"))]
  .w <- which(.n == "")
  if (length(.w) > 0) {
    .n <- .n[-.w]
    .t <- .t[-.w]
  }
  if (length(.n) == 0)  {
    .minfo("done (no labels)")
    return(rxui)
  }
  if (length(.n) != length(.t)) {
    .minfo("done (not changed due to label mismatch)")
    return(rxui)
  }
  #print(data.frame(.n, .t))
  .ret <-eval(parse(text=paste0("rxode2::rxRename(rxui, ", paste(paste(.n,"=", .t, sep=""), collapse=", "), ")")))
  .t2 <- setNames(.n, .t)
  if (!is.null(df)) {
    names(df) <- vapply(names(df), function(n) {
      .ret <- .t2[n]
      if (is.na(.ret)) return(n)
      .ret
    }, character(1), USE.NAMES = FALSE)
    .nonmem2rx$etas <- df
  }
  if (!is.null(dn)) {
    dn <- vapply(dn, function(n) {
      .ret <- .t2[n]
      if (is.na(.ret)) return(n)
      .ret
    }, character(1), USE.NAMES = FALSE)
    .nonmem2rx$dn <- dn
  }
  .minfo("done")
  .ret
}
#' Replace compartment names
#'
#' @param rxui ui
#' @param cmtName compartment names to replace
#' @return updated ui with the compartment names replaced
#' @noRd
#' @author Matthew L. Fidler
.replaceCmtNames <- function(rxui, cmtName) {
  if (length(cmtName) == 0L) return(rxui)
  .minfo("renaming compartments")
  .mv <- rxode2::rxModelVars(rxui)
  .n <- vapply(cmtName,
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
  .txt<- paste0("rxode2::rxRename(rxui, ", paste(paste(.n,"=", .c, sep=""), collapse=", "), ")")
  .tmp <- try(eval(parse(text=.txt)),silent=TRUE)
  if (inherits(.tmp, "try-error")) {
    .minfo(sprintf("cmt not renamed; err evaluating: %s", .txt))
    .ret <- rxui
  } else {
    .ret <- .tmp
    .minfo("done")
  }
  .ret
}

#'  Update the input model with final parmeter estimates
#'
#' @param rxui ui
#' @inheritParams nonmem2rx
#' @return List with new ui and sigma
#' @noRd
#' @author Matthew L. Fidler
.updateRxWithFinalParameters <- function(rxui, lstInfo) {
  .rx <- rxui
  .update.theta <- FALSE
  if (!is.null(lstInfo$theta)) {
    .theta <- lstInfo$theta
    .theta <- .theta[!is.na(.theta)]
    .rx <- rxode2::ini(.rx, .theta)
    .update.theta <- TRUE
  }
  .update.omega <- FALSE
  if (!is.null(lstInfo$omega)) {
    .omega <- lstInfo$omega
    .rx <- rxode2::ini(.rx, .omega)
    .update.omega <- TRUE
    if (length(.nonmem2rx$omegaEst$x) > 0) {
      for (i in seq_along(.nonmem2rx$omegaEst$x)) {
        .x <- .nonmem2rx$omegaEst$x[i]
        .y <- .nonmem2rx$omegaEst$y[i]
        .rx <- eval(parse(text=sprintf("rxode2::ini(.rx, { omega.%d.%d <- %f})",
                                       .x, .y, .omega[.x, .y])))
      }
    }
  }
  .update.sigma <- FALSE
  if (!is.null(lstInfo$sigma)) {
    .sigma <- lstInfo$sigma
    if (length(.nonmem2rx$sigmaEst$x) > 0) {
      for (i in seq_along(.nonmem2rx$sigmaEst$x)) {
        .x <- .nonmem2rx$sigmaEst$x[i]
        .y <- .nonmem2rx$sigmaEst$y[i]
        .rx <- eval(parse(text=sprintf("rxode2::ini(.rx, { sigma.%d.%d <- %f})",
                                       .x, .y, .sigma[.x, .y])))
      }
    }
    .update.sigma <- TRUE
  }
  list(rx=.rx, sigma=.sigma,
       update=.update.theta && .update.omega && .update.sigma)
}

#' Convert a NONMEM source file to a rxode model (nlmixr2-syle)
#'
#' @param file NONMEM run file
#'
#' @param inputData this is a path to the input dataset (or `NULL` to
#'   determine from the dataset).  Often the input dataset may be
#'   different from the place it points to in the control stream
#'   because directories can be created to run NONMEM from a script.
#'   Because of this, when this is specified the input data will be
#'   assumed to be from here instead.
#'
#' @param nonmemOutputDir This is a path the the nonmem output
#'   directory.  When not `NULL` it will assume that the diretory for
#'   the output files is located here instead of where the control
#'   stream currently exists.
#'
#' @param rename When not `NULL` this should be a named character
#'   vector that contains the parameters that should be renamed.  For
#'   example, if the model uses the variable `YTYPE` and has `CMT` it
#'   isn't compatible with `rxode2`/`nlmixr2`. You can change this for
#'   the input dataset and the model to create a new model that still
#'   reproduces the NONMEM output by specifying
#'   `rename=c(dvid="YTYPE")`
#'
#' @param tolowerLhs Boolean to change the lhs to lower case (default:
#'   `TRUE`)
#'
#' @param thetaNames this could be a boolean indicating that the theta
#'   names should be changed to the comment-labeled names (default:
#'   `TRUE`). This could also be a character vector of the theta names
#'   (in order) to be replaced.
#'
#' @param etaNames this could be a boolean indicating that the eta
#'   names should be changed to the comment-labeled names (default:
#'   `TRUE`). This could also be a character vector of the theta names
#'   (in order) to be replaced.
#'
#' @param cmtNames this could be a boolean indicating that the
#'   compartment names should be changed to the named compartments in
#'   the `$MODEL` by `COMP = (name)` (default: `TRUE`). This could
#'   also be a character vector of the compartment names (in order) to
#'   be replaced.
#'
#' @param updateFinal Update the parsed model with the model estimates
#'   from the `.lst` output file.
#'
#' @param determineError Boolean to try to determine the `nlmixr2`-style residual
#'   error model (like `ipred ~ add(add.sd)`), otherwise endpoints are
#'   not defined in the `rxode2`/`nlmixr2` model (default: `TRUE`)
#'
#' @param validate Boolean that this tool will attempt to "validate"
#'   the model by solving the derived model under pred conditions
#'   (etas are zero and eps values are zero)
#'
#' @param nonmemData Boolean that tells `nonmem2rx` to read in the
#'   nonmem data (if possible) even if the model will not be validated
#'   (like if it is a simulation run or missing final parameter
#'   estimates).  By default this is `FALSE`, nonmem data will not be
#'   integrated into the nonmem2rx ui.
#'
#' @param strictLst The list parsing needs to be correct for a
#'   successful load (default `FALSE`).
#'
#' @param unintFixed Treat uninteresting values as fixed parameters (default `FALSE`)
#'
#' @param nLinesPro The number of lines to check for the $PROBLEM
#'   statement.
#'
#' @param delta this is the offset for NONMEM times that are tied
#'
#' @param mod the NONMEM output extension, defaults to `.mod`
#'
#' @param lst the NONMEM output extension, defaults to `.lst`
#'
#' @param ext the NONMEM ext file extension, defaults to `.ext`
#'
#' @param cov the NONMEM covariance file extension, defaults to `.cov`
#'
#' @param phi the NONMEM eta/phi file extension, defaults to `.phi`
#'
#' @param xml the NONMEM xml file extension , defaults to `.xml`
#'
#' @param useXml if present, use the NONMEM xml file to import much of
#'   the NONMEM information
#'
#' @param useCov if present, use the NONMEM cov file to import the
#'   covariance, otherwise import the covariance with list file
#'
#' @param usePhi if present, use the NONMEM phi file to extract etas
#'   (default `TRUE`), otherwise defaults to etas in the tables (if
#'   present)
#'
#' @param useExt if present, use the NONMEM ext file to extract
#'   parameter estimates (default `TRUE`), otherwise defaults to
#'   parameter estimates extracted in the NONMEM output
#'
#' @param useLst if present, use the NONMEM lst file to extract NONMEM
#'   information
#'
#' @return rxode2 function
#' @eval .nonmem2rxBuildGram()
#' @export
#' @useDynLib nonmem2rx, .registration=TRUE
#' @importFrom Rcpp sourceCpp
#' @importFrom stats setNames
#' @importFrom lotri lotri
#' @importFrom dparser mkdparse
#' @importFrom utils read.csv
#' @import data.table
#' @examples
#'
#' nonmem2rx(system.file("run001.mod", package="nonmem2rx"))
#'
#' nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res")
#'
nonmem2rx <- function(file, inputData=NULL, nonmemOutputDir=NULL,
                      rename=NULL, tolowerLhs=TRUE, thetaNames=TRUE,
                      etaNames=TRUE,
                      cmtNames=TRUE,
                      updateFinal=TRUE,
                      determineError=TRUE,
                      validate=TRUE,
                      nonmemData=FALSE,
                      strictLst=FALSE,
                      unintFixed=FALSE,
                      nLinesPro=20L,
                      delta=1e-4,
                      usePhi=TRUE,
                      useExt=TRUE,
                      useCov=TRUE,
                      useXml=TRUE,
                      useLst=TRUE,
                      mod=".mod",
                      cov=".cov",
                      phi=".phi",
                      lst=".lst",
                      xml=".xml",
                      ext=".ext") {
  checkmate::assertFileExists(file)
  if (!is.null(inputData)) checkmate::assertFileExists(inputData)
  if (!is.null(nonmemOutputDir)) checkmate::assertDirectoryExists(nonmemOutputDir)
  if (!is.null(rename)) checkmate::assertCharacter(rename, any.missing=FALSE, min.len=1, names="strict")
  checkmate::assertLogical(tolowerLhs, len=1, any.missing = FALSE)
  checkmate::assertLogical(updateFinal, len=1, any.missing= FALSE)
  checkmate::assertCharacter(lst, len=1, any.missing= FALSE)
  checkmate::assertIntegerish(nLinesPro, len=1, lower=1)
  .clearNonmem2rx()
  .nonmem2rx$unintFixed <- unintFixed
  on.exit({
    .Call(`_nonmem2rx_r_parseFree`)
  })
  .minfo(sprintf("getting information from  '%s'", file))
  .lstInfo <- nminfo(file, mod=mod, xml=xml, ext=ext, cov=cov, phi=phi, lst=lst,
                     useXml = useXml, useExt = useExt, useCov=useCov, usePhi=usePhi, useLst=useLst,
                     strictLst=strictLst, verbose=TRUE)
  .minfo("done")
  if (is.null(.lstInfo$control)) {
    stop("cannot find control stream",
         call.=FALSE)
  }
  .lines <- .lstInfo$control
  .lines <- paste(.lines, collapse = "\n")
  .parseRec(.lines)
  if (.nonmem2rx$needYtype) {
    warning("'ytype' variable has special meaning in rxode2, renamed to 'nmytype', rename/copy in your data too",
            call.=FALSE)
  }
  if (inherits(thetaNames, "logical")) {
    checkmate::assertLogical(thetaNames, len=1, any.missing = FALSE)
    if (thetaNames) {
      thetaNames <- vapply(seq_along(.nonmem2rx$theta),
                           function(i) {
                             .lab <- .nonmem2rx$thetaNonmemLabel[i]
                             if (.lab == "") .lab <- .nonmem2rx$theta[i]
                             .lab
                           }, character(1), USE.NAMES=FALSE)
    } else {
      thetaNames <- character(0)
    }
  } else {
    checkmate::assertCharacter(thetaNames, any.missing = FALSE)
  }
  .sigma <- NULL
  if (length(.nonmem2rx$sigma) > 0L) {
    .sigma <- eval(parse(text=paste0("lotri::lotri({\n",
                                paste(.nonmem2rx$sigma, collapse="\n"),
                                "\n})")))
    if (length(.nonmem2rx$sigmaEst$x) > 0) {
      lapply(seq_along(.nonmem2rx$sigmaEst$x),
             function(i) {
               .x <- .nonmem2rx$sigmaEst$x[i]
               .y <- .nonmem2rx$sigmaEst$y[i]
               .addIni(sprintf("sigma.%d.%d <- %f", .x, .y, .sigma[.x, .y]))
             })
    }
  }
  .omega <- NULL
  if (length(.nonmem2rx$omega) > 0L) {
    .omega <- eval(parse(text=paste0("lotri::lotri({\n",
                                paste(.nonmem2rx$omega, collapse="\n"),
                                "\n})")))
    if (length(.nonmem2rx$omegaEst$x) > 0) {
      lapply(seq_along(.nonmem2rx$omegaEst$x),
             function(i) {
               .x <- .nonmem2rx$omegaEst$x[i]
               .y <- .nonmem2rx$omegaEst$y[i]
               .addIni(sprintf("omega.%d.%d <- %f", .x, .y, .omega[.x, .y]))
             })
    }
  }
  .fun <- eval(parse(text=paste0("function() {\n",
                         "rxode2::ini({\n",
                         paste(.nonmem2rx$ini, collapse="\n"),
                         "\n})\n",
                         "rxode2::model({\n",
                         .desPrefix(),
                         .missingPrefix(),
                         ifelse(.nonmem2rx$needExit, "ierprdu <- -1\n", ""),
                         paste(.nonmem2rx$model, collapse="\n"),
                         "\n})",
                         "}")))
  .rx <- .fun()
  .update <- FALSE
  if (updateFinal) {
    .tmp <- try(.updateRxWithFinalParameters(.rx, .lstInfo), silent=TRUE)
    if (!inherits(.tmp, "try-error")) {
      .rx <- .tmp$rx
      if (!is.null(.tmp$sigma)) .sigma <- .tmp$sigma
      .update <- .tmp$update
    }
  }
  if (!.update) {
    if (validate) {
      .minfo("final parameters not updated, will skip validation")
      .msg <- "final parameters not updated, validation skipped"
      validate <- FALSE
    }
  }
  if (!is.null(rename)) {
    .minfo("Renaming variables in model and data")
    .r <- rename
    .mv <- rxode2::rxModelVars(.rx)
    .in <-c(.mv$params, .mv$state, .mv$lhs)
    .w <- which(vapply(.r,
                       function(v) {
                         return(v %in% .in)
                       }, logical(1), USE.NAMES=FALSE))
    if (length(.w) > 0) {
      .r <- .r[.w]
      .rx <- eval(parse(text=paste0("rxode2::rxRename(.rx, ", paste(paste0(names(.r), "=", setNames(.r, NULL)), collapse=", "),")")))
    }
    .minfo("done")
  }
  .cov <- .getFileNameIgnoreCase(paste0(tools::file_path_sans_ext(file), cov))
  if (useCov && file.exists(.cov)) {
    .cov <- nmcov(.cov)
    .dn <- dimnames(.cov)[[2]]
    .dn <- .replaceNmDimNames(.dn)
  } else if (!is.null(.lstInfo$cov)) {
    .cov <- .lstInfo$cov
    .dn <- dimnames(.cov)[[2]]
  } else {
    .cov <- NULL
    .dn <- NULL
  }
  if (determineError) {
    .tmp <- try(.determineError(.rx), silent = FALSE)
    if (inherits(.tmp, "try-error")) {
      .minfo("error converting to full nlmixr2-compatible ui")
      .minfo("could be due to residual components being negative")
    } else {
      .rx <- .tmp
    }
  }
  .ipredData <- .predData <- .etaData  <- .nonmemData <- NULL
  if (validate || nonmemData) {
    .nonmemData <- .readInDataFromNonmem(file, inputData=inputData,
                                         rename=rename, delta=delta)
  }
  if (validate)  {
    .model <- .rx$simulationModel
    .predData <- .ipredData <- try(.readInIpredFromTables(file, nonmemOutputDir=nonmemOutputDir,
                                                          rename=rename))
    if (inherits(.ipredData, "try-error")) .predData <- .ipredData <- NULL
    if (!is.null(.ipredData)) {
      .digs <- 0L
      if (!is.null(.lstInfo$eta)) {
        .digs <- 5L # seems to be the default for phi files
      }
      # get ETA data if it has better digits than the phi file (or isn't present yet)
      .etaData <- try(.readInEtasFromTables(file, nonmemData=.nonmemData, rxModel=.model,
                                        nonmemOutputDir=nonmemOutputDir,rename=rename,
                                        digits=.digs))
      if (inherits(.etaData, "try-error")) .etaData <- NULL
      if (is.null(.etaData) && !is.null(.lstInfo$eta)) {
        .etaData <- .lstInfo$eta
      }
    }
    if (is.null(.predData)) {
      .predData  <- try(.readInPredFromTables(file, nonmemOutputDir=nonmemOutputDir,
                                              rename=rename))
      if (inherits(.predData, "try-error")) .predData <- NULL
    } else if (!any(names(.ipredData) == "PRED")) {
      .predData  <- try(.readInPredFromTables(file, nonmemOutputDir=nonmemOutputDir,
                                              rename=rename))
      if (inherits(.predData, "try-error")) .predData <- NULL
    }
  }
  if (tolowerLhs) {
    .rx <- .toLowerLhs(.rx)
  }
  .nonmem2rx$dn <- NULL
  .rx <- .replaceThetaNames(.rx, thetaNames, dn=.dn)
  if (!is.null(.nonmem2rx$dn)) {
    .dn <- .nonmem2rx$dn
  }
  if (inherits(etaNames, "logical")) {
    checkmate::assertLogical(etaNames, len=1, any.missing=FALSE)
    if (etaNames) {
      etaNames <- vapply(seq_len(max(length(.nonmem2rx$etaNonmemLabel),
                                     length(.nonmem2rx$etaLabel))),
                         function(i) {
                           if (i > length(.nonmem2rx$etaNonmemLabel)) {
                             return(.nonmem2rx$etaNonmemLabel[i])
                           } else if (i > length(.nonmem2rx$etaLabel)) {
                             return(.nonmem2rx$etaLabel[i])
                           }
                           .lab <- .nonmem2rx$etaNonmemLabel[i]
                           if (.lab == "") .lab <- .nonmem2rx$etaLabel[i]
                           .lab
                         }, character(1), USE.NAMES=FALSE)
    } else {
      etaNames <- character(0)
    }

  } else {
    checkmate::assertCharacter(etaNames, any.missing = FALSE)
  }
  .nonmem2rx$etas <- NULL
  .nonmem2rx$dn <- NULL
  .rx <- .replaceThetaNames(.rx, etaNames,
                           label="eta", prefix="e.",
                           df=.etaData, dn=.dn)
  if (!is.null(.nonmem2rx$etas)) {
    .etaData <- .nonmem2rx$etas
  }
  if (!is.null(.nonmem2rx$dn)) {
    .dn <- .nonmem2rx$dn
  }
  if (!is.null(.dn)) {
    dimnames(.cov) <- list(.dn, .dn)
  }
  if (inherits(cmtNames, "logical")) {
    checkmate::assertLogical(cmtNames, len=1, any.missing = FALSE)
    if (cmtNames) {
      cmtNames <- character(0)
      if (exists("cmtName", envir=.nonmem2rx)) cmtNames <- .nonmem2rx$cmtName
    } else {
      cmtNames <- character(0)
    }
  } else {
    checkmate::assertCharacter(cmtNames, any.missing = FALSE)
  }
  .rx <- .replaceCmtNames(.rx, cmtNames)
  .rx <- rxode2::rxUiDecompress(.rx)

  # now try to validate
  if (!is.null(.nonmemData)) {
    .rx$nonmemData <- .nonmemData
  }
  if (is.null(.nonmemData) && validate) {
    .msg <- "could not read in input data; validation skipped"
  }
  if (!is.null(.nonmemData) && validate) {
    .model <- .rx$simulationModel
    .theta <- .rx$theta
    .ci0 <- .ci <- 0.95
    .sigdig <- 3
    .ci <- (1 - .ci) / 2
    .q <- c(0, .ci, 0.5, 1 - .ci, 1)
    .obsIdx <- .nonmemObsIndex(.nonmemData)
    .msg <- NULL
    if (!is.null(.etaData) && !is.null(.ipredData)) {
      if (length(.ipredData[,1]) == length(.nonmemData[,1])) {
        .ipredData <- .ipredData[.obsIdx,]
      }
      .params <- .etaData
      .rx$etaData <- .etaData
      for (.i in seq_along(.theta)) {
        .params[[names(.theta)[.i]]] <- .theta[.i]
      }
      .dn <- dimnames(.sigma)[[1]]
      for (.i in .dn) {
        .params[[.i]] <- 0
      }
      if (!is.null(.rx$predDf)) {
        .params[[paste0("err.", .rx$predDf$var)]] <- 0
      }
      .wid <- which(tolower(names(.params)) == "id")
      .doIpred <- TRUE
      if (length(.wid) == 1L) {
        .widNm <- which(tolower(names(.nonmemData)) == "id")
        if (.widNm == 1L) {
          .idNm <- unique(.nonmemData[,.widNm])
          .params <- do.call("rbind",
                  lapply(.idNm, function(id) {
                    return(.params[.params[,.wid] == id,])
                  }))
          if (!all(.idNm == .params[,.wid])) {
            .minfo("id values between input and output do not match, skipping IPRED check")
            .doIpred <- FALSE
            .msg <- "id values between input and output do not match, skipping IPRED validation"
          }
        }
        .params <- .params[,-.wid]
        .nonmemData2 <- .nonmemData
        # dummy id to match the .params
        .nonmemData2[,.wid] <- as.integer(factor(paste(.nonmemData2[,.wid])))
      }
      if (.doIpred) {
        .minfo("solving ipred problem")
        .ipredSolve <- try(rxSolve(.model, .params, .nonmemData2, returnType = "data.frame",
                                   covsInterpolation="nocb",
                                   atol=.nonmem2rx$atol, rtol=.nonmem2rx$rtol,
                                   ssAtol=.nonmem2rx$ssAtol, ssRtol=.nonmem2rx$ssRtol,
                                   addDosing = FALSE))
        .minfo("done")
      }
      if (.doIpred && !inherits(.ipredSolve, "try-error")) {
        if (is.null(.rx$predDf)) {
          .w <- which(tolower(names(.ipredSolve)) == "y")
          .y <- names(.ipredSolve)[.w]
        } else {
          .y <- "sim"
        }
        if (length(.ipredData$IPRED) == length(.ipredSolve[[.y]])) {
          .wid  <- which(tolower(names(.ipredData)) == "id")
          .wtime  <- which(tolower(names(.ipredData)) == "time")
          .cmp <- data.frame(ID=.ipredData[,.wid], TIME=.ipredData[,.wtime],
                             nonmemIPRED=.ipredData$IPRED,
                             IPRED=.ipredSolve[[.y]])
          .qi <- stats::quantile(with(.cmp, 100*abs((IPRED-nonmemIPRED)/nonmemIPRED)), .q, na.rm=TRUE)
          #.qp <- stats::quantile(with(.ret, 100*abs((PRED-nonmemPRED)/nonmemPRED)), .q, na.rm=TRUE)
          .qai <- stats::quantile(with(.cmp, abs(IPRED-nonmemIPRED)), .q, na.rm=TRUE)
          #.qap <- stats::quantile(with(.ret, abs((PRED-nonmemPRED)/nonmemPRED)), .q, na.rm=TRUE)
          .msg <- c(paste0("IPRED relative difference compared to Nonmem IPRED: ", round(.qi[3], 2),
                           "%; ", .ci0 * 100,"% percentile: (",
                           round(.qi[2], 2), "%,", round(.qi[4], 2), "%); rtol=",
                           signif(.qi[3] / 100, digits=.sigdig)),
                    paste0("IPRED absolute difference compared to Nonmem IPRED: ", .ci0 * 100,"% percentile: (",
                           signif(.qai[2], .sigdig), ", ", signif(.qai[4], .sigdig), "); atol=",
                           signif(.qai[3], .sigdig)))
          .rx$ipredAtol <- .qai[3]
          .rx$ipredRtol <- .qi[3]/100
          .rx$ipredCompare <- .cmp
        } else {
          .msg <- sprintf("the length of the ipred solve (%d) is not the same as the ipreds in the nonmem output (%d); input length: %d",
                          length(.ipredSolve[[.y]]), length(.ipredData$IPRED),
                          length(.nonmemData[,1]))
          .minfo(.msg)
        }
      }
    }
    if (!is.null(.predData)) {
      if (length(.predData[,1]) == length(.nonmemData[,1])) {
        .predData <- .predData[.obsIdx,]
      }
      .params <- c(.theta,
                   vapply(dimnames(.rx$omega)[[1]],
                          function(x) {
                            return(0.0)
                          }, double(1), USE.NAMES = TRUE),
                   vapply(dimnames(.sigma)[[1]],
                          function(x) {
                            return(0.0)
                          }, double(1), USE.NAMES = TRUE))
      if (!is.null(.rx$predDf)) {
        .params <- c(.params, setNames(0, paste0("err.", .rx$predDf$var)))
      }
      .minfo("solving pred problem")
      .predSolve <- try(rxSolve(.model, .params, .nonmemData, returnType = "tibble",
                                covsInterpolation="nocb",
                                atol=.nonmem2rx$atol, rtol=.nonmem2rx$rtol,
                                ssAtol=.nonmem2rx$ssAtol, ssRtol=.nonmem2rx$ssRtol,
                                addDosing = FALSE))
      .minfo("done")
      if (!inherits(.predSolve, "try-error")) {
        if (is.null(.rx$predDf)) {
          .w <- which(tolower(names(.predSolve)) == "y")
          .y <- names(.predSolve)[.w]
        } else {
          .y <- "sim"
        }
        if (length(.predData$PRED) == length(.predSolve[[.y]])) {
          .wid  <- which(tolower(names(.predData)) == "id")
          .wtime  <- which(tolower(names(.predData)) == "time")
          .cmp <- data.frame(ID=.predData[,.wid], TIME=.predData[,.wtime],
                             nonmemPRED=.predData$PRED,
                             PRED=.predSolve[[.y]])
          .qp <- stats::quantile(with(.cmp, 100*abs((PRED-nonmemPRED)/nonmemPRED)), .q, na.rm=TRUE)
          .qap <- stats::quantile(with(.cmp, abs((PRED-nonmemPRED)/nonmemPRED)), .q, na.rm=TRUE)
          .msg <- c(.msg,
                    paste0("PRED relative difference compared to Nonmem PRED: ", round(.qp[3], 2),
                           "%; ", .ci0 * 100,"% percentile: (",
                           round(.qp[2], 2), "%,", round(.qp[4], 2), "%); rtol=",
                           signif(.qp[3] / 100,
                                  digits=.sigdig)),
                    paste0("PRED absolute difference compared to Nonmem PRED: ",
                           .ci0 * 100,"% percentile: (",
                           signif(.qap[2], .sigdig), ",", signif(.qp[4], .sigdig), ") atol=",
                           signif(.qap[3], .sigdig)))
          .rx$predAtol <- .qap[3]
          .rx$predRtol <- .qp[3]/100
          .rx$predCompare <- .cmp
        } else {
          .msg <- c(.msg,
                    sprintf("The length of the pred solve (%d) is not the same as the preds in the nonmem output (%d); input length: %d",
                            length(.predSolve[[.y]]),
                            length(.predData$PRED),
                            length(.nonmemData[,1])))
          .minfo(.msg[length(.msg)])
        }
      }
    }
    if (is.null(.ipredData) && is.null(.predData)) {
      .msg <- "NONMEM input data found but could not find output PRED/IPRED data to validate against"
      warning("NONMEM input data found but could not find output PRED/IPRED data to validate against", call.=FALSE)
    }
  }
  if (!is.null(.msg)) {
    .rx$meta$validation <- .msg
  }
  if (length(.nonmem2rx$modelDesc) > 0) {
    .rx$meta$description <- .nonmem2rx$modelDesc
  }
  if (!is.null(.sigma)) {
    .rx$sigma <- .sigma
  }
  if (!is.null(.cov)) {
    .rx$thetaMat <- .cov
  }
  if (inherits(.lstInfo$nsub, "numeric")) {
    .rx$dfSub <- .lstInfo$nsub
  }
  if (inherits(.lstInfo$nobs, "numeric")) {
    .rx$dfObs <- .lstInfo$nobs
  }
  .rx$atol <- .nonmem2rx$atol
  .rx$rtol <- .nonmem2rx$rtol
  .rx$ssAtol <- .nonmem2rx$ssAtol
  .rx$ssRtol <- .nonmem2rx$ssRtol
  .ret <- rxode2::rxUiCompress(.rx)
  class(.ret) <- c("nonmem2rx", class(.ret))
  .ret
}
