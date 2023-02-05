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
  .lhs <- tolower(.mv$lhs)
  .rhs <- .mv$lhs
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
                               label="theta", prefix="t.", df=NULL) {
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
    if (tolower(v) %in% tolower(c(.mv$lhs, .mv$params))) {
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
  if (prefix == "t.") {
    .t <- rxui$iniDf$name[!is.na(rxui$iniDf$ntheta)]
  } else {
    .t <- rxui$iniDf$name[which(is.na(rxui$iniDf$ntheta) & rxui$iniDf$neta1 == rxui$iniDf$neta2)]
  }
  .w <- which(.n == "")
  if (length(.w) > 0) {
    .n <- .n[-.w]
    .t <- .t[-.w]
  }
  if (length(.n) == 0)  {
    .minfo("done (no labels)")
    return(rxui)
  }
  .ret <-eval(parse(text=paste0("rxode2::rxRename(rxui, ", paste(paste(.n,"=", .t, sep=""), collapse=", "), ")")))
  if (!is.null(df)) {
      .nonmem2rx$etas <-eval(parse(text=paste0("dplyr::rename(df, ", paste(paste(.n,"=", .t, sep=""), collapse=", "), ")")))
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
#' @param cmtName compartment names to replace
#' @return List with new ui and sigma
#' @noRd
#' @author Matthew L. Fidler
.updateRxWithFinalParameters <- function(rxui, file, sigma,lst, ext) {
  .lstFile <- paste0(tools::file_path_sans_ext(file), lst)
  .extFile <- paste0(tools::file_path_sans_ext(file), ext)
  if (file.exists(.extFile)) {
    .fin <- try(nmext(.extFile), silent=TRUE)
    if (inherits(.fin, "try-error") && file.exists(.lstFile)) {
      .fin <- try(nmlst(.lstFile), silent=TRUE)
    }
  } else if (file.exists(.lstFile)) {
    .fin <- try(nmlst(.lstFile), silent=TRUE)
  } else {
    return(list(rx=rxui, sigma=NULL))
  }
  .rx <- rxui
  if (inherits(.fin, "try-error")) {
    warning("error reading estimates from output", call.=FALSE)
    .fin <- list(theta=NULL, eta=NULL, eps=NULL)
  }
  if (!is.null(.fin$theta)) {
    .theta <- .fin$theta
    .theta <- .theta[!is.na(.theta)]
    .rx <- rxode2::ini(.rx, .theta)
  }
  if (!is.null(.fin$eta)) {
    .eta <- .fin$eta
    .rx <- rxode2::ini(.rx, .eta)
  }
  .sigma <- sigma
  if (!is.null(.fin$eps)) {
    .sigma <- .fin$eps
  }
  list(rx=.rx, sigma=.sigma)
}

#' Convert a NONMEM source file to a rxode model (nlmixr2-syle)
#' 
#' @param file NONMEM run file
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
#' @param lst the NONMEM output extension, defaults to `.lst`
#' @param ext the NONMEM ext file extension, defaults to `.ext`
#' @return rxode2 function
#' @eval .nonmem2rxBuildGram()
#' @export
#' @useDynLib nonmem2rx, .registration=TRUE
#' @importFrom Rcpp sourceCpp
#' @importFrom stats setNames
#' @importFrom lotri lotri
#' @importFrom dparser mkdparse
#' @importFrom utils read.csv
#' @examples
#' 
#' nonmem2rx(system.file("run001.mod", package="nonmem2rx"))
#'
#' nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res")
#' 
nonmem2rx <- function(file, tolowerLhs=TRUE, thetaNames=TRUE, etaNames=TRUE,
                      cmtNames=TRUE,
                      updateFinal=TRUE,
                      determineError=TRUE,
                      validate=TRUE,
                      lst=".lst",
                      ext=".ext") {
  checkmate::assertFileExists(file)
  checkmate::assertLogical(tolowerLhs, len=1, any.missing = FALSE)
  checkmate::assertLogical(updateFinal, len=1, any.missing= FALSE)
  checkmate::assertCharacter(lst, len=1, any.missing= FALSE)
  .clearNonmem2rx()
  .lines <- paste(suppressWarnings(readLines(file)), collapse = "\n")
  .parseRec(.lines)
  if (inherits(thetaNames, "logical")) {
    checkmate::assertLogical(thetaNames, len=1, any.missing = FALSE)
    if (thetaNames) {
      thetaNames <- .nonmem2rx$theta
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
  }
  .fun <- eval(parse(text=paste0("function() {\n",
                         "rxode2::ini({\n",
                         paste(.nonmem2rx$ini, collapse="\n"),
                         "\n})\n",
                         "rxode2::model({\n",
                         ifelse(.nonmem2rx$abbrevLin == 0L && .nonmem2rx$maxa != 0L,
                                paste0(paste(paste0("cmt(rxddta", seq_len(.nonmem2rx$maxa), ")"),
                                             collapse="\n"), "\n"),
                                ""),
                         paste(.nonmem2rx$model, collapse="\n"),
                         "\n})",
                         "}")))
  .rx <- .fun()
  if (updateFinal) {
    .tmp <- .updateRxWithFinalParameters(.rx, file, .sigma, lst, ext)
    .rx <- .tmp$rx
    if (!is.null(.tmp$sigma)) .sigma <- .tmp$sigma
  }
  .cov <- .getFileNameIgnoreCase(paste0(tools::file_path_sans_ext(file), ".cov"))
  if (file.exists(.cov)) {
    .cov <- pmxTools::read_nmcov(.cov)
    ## print(.cov)
  } else {
    .cov <- NULL
  }
  if (determineError) {
    .rx <- .determineError(.rx)
  }
  .ipredData <- .predData <- .etaData <- NULL
  if (validate)  {
    .nonmemData <- .readInDataFromNonmem(file)
    .predData <- .ipredData <- .readInIpredFromTables(file)
    if (!is.null(.ipredData)) {
      .etaData <- .readInEtasFromTables(file)
    }
    if (is.null(.predData)) {
      .predData  <- .readInPredFromTables(file)
    } else if (!any(names(.ipredData) == "PRED")) {
      .predData  <- .readInPredFromTables(file)
    }
  }
  if (tolowerLhs) {
    .rx <- .toLowerLhs(.rx)
  }
  .rx <- .replaceThetaNames(.rx, thetaNames)
  if (inherits(etaNames, "logical")) {
    checkmate::assertLogical(etaNames, len=1, any.missing=FALSE)
    etaNames <- character(0)
    if (exists("etaLabel", .nonmem2rx)) {
      etaNames <- .nonmem2rx$etaLabel
    }
  } else {
    checkmate::assertCharacter(etaNames, any.missing = FALSE)    
  }
  .rx <-.replaceThetaNames(.rx, etaNames,
                           label="eta", prefix="e.",
                           df=.etaData)
  if (is.null(.etaData)) {
    .etaData <- .nonmem2rx$etas
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
    .model <- .rx$simulationModel
    .theta <- .rx$theta
    .ci0 <- .ci <- 0.95
    .sigdig <- 3
    .ci <- (1 - .ci) / 2
    .q <- c(0, .ci, 0.5, 1 - .ci, 1)

    .msg <- NULL
    if (!is.null(.etaData)) {
      .params <- .etaData
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
      .ipredSolve <- try(rxSolve(.model, .params, .nonmemData, returnType = "data.frame",
                             covsInterpolation="nocb",
                             addDosing = TRUE))
      if (!inherits(.ipredSolve, "try-error")) {
        if (is.null(.rx$predDf)) {
          .w <- which(tolower(names(.ipredSolve)) == "y")
          .y <- names(.ipredSolve)[.w]
        } else {
          .y <- "sim"
        }
        if (length(.ipredData$IPRED) == length(.ipredSolve[[.y]])) {
          .cmp <- data.frame(nonmemIPRED=.ipredData$IPRED,
                             IPRED=.ipredSolve[[.y]])
          .qi <- stats::quantile(with(.cmp, 100*abs((IPRED-nonmemIPRED)/nonmemIPRED)), .q, na.rm=TRUE)
          #.qp <- stats::quantile(with(.ret, 100*abs((PRED-nonmemPRED)/nonmemPRED)), .q, na.rm=TRUE)
          .qai <- stats::quantile(with(.cmp, abs(IPRED-nonmemIPRED)), .q, na.rm=TRUE)
          #.qap <- stats::quantile(with(.ret, abs((PRED-nonmemPRED)/nonmemPRED)), .q, na.rm=TRUE)
          .msg <- c(paste0("IPRED relative difference compared to Nonmem IPRED: ", round(.qi[3], 2),
                           "%; ", .ci0 * 100,"% percentile: (",
                           round(.qi[2], 2), "%,", round(.qi[4], 2), "%); rtol=",
                           signif(.qi[3] / 100, digits=.sigdig)),
                    paste0("IPRED absolute difference compared to Nonmem IPRED: atol=",
                           signif(.qai[3], .sigdig),
                           "; ", .ci0 * 100,"% percentile: (",
                           signif(.qai[2], .sigdig), ", ", signif(.qai[4], .sigdig), ")"))
        } else {
          .minfo(sprintf("the length of the ipred solve (%d) is not the same as the ipreds in the nonmem output (%d); input length: %d",
                         length(.ipredSolve[[.y]]), length(.ipredData$IPRED),
                         length(.nonmemData[,1])))
        }
      }
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
    .predSolve <- try(rxSolve(.model, .params, .nonmemData, returnType = "tibble",
                          covsInterpolation="nocb",
                          addDosing = TRUE))
    if (!inherits(.predSolve, "try-error")) {
      if (is.null(.rx$predDf)) {
        .w <- which(tolower(names(.predSolve)) == "y")
        .y <- names(.predSolve)[.w]
      } else {
        .y <- "sim"
      }
      if (length(.predData$PRED) == length(.predSolve[[.y]])) {
        .cmp <- data.frame(nonmemPRED=.predData$PRED,
                           PRED=.predSolve[[.y]])
        .qp <- stats::quantile(with(.cmp, 100*abs((PRED-nonmemPRED)/nonmemPRED)), .q, na.rm=TRUE)
        .qap <- stats::quantile(with(.cmp, abs((PRED-nonmemPRED)/nonmemPRED)), .q, na.rm=TRUE)
        .msg <- c(.msg, 
                  paste0("PRED relative difference compared to Nonmem PRED: ", round(.qp[3], 2),
                         "%; ", .ci0 * 100,"% percentile: (",
                         round(.qp[2], 2), "%,", round(.qp[4], 2), "%); rtol=",
                         signif(.qp[3] / 100,
                                digits=.sigdig)),
                  paste0("PRED absolute difference compared to Nonmem PRED: atol=",
                         signif(.qap[3], .sigdig),
                         "; ", .ci0 * 100,"% percentile: (",
                         signif(.qap[2], .sigdig), ",", signif(.qp[4], .sigdig), ")"))
      } else {
        .minfo(sprintf("The length of the pred solve (%d) is not the same as the preds in the nonmem output (%d); input length: %d",
                       length(.predSolve[[.y]]),
                       length(.predData$PRED),
                       length(.nonmemData[,1])))
      }
    }
    if (!is.null(.msg)) {
      .rx$meta$validation <- .msg
    }
  }
  if (length(.nonmem2rx$modelDesc) > 0) {
    .rx$meta$description <- .nonmem2rx$modelDesc
  }
  if (!is.null(.sigma)) {
    .rx$meta$sigma <- .sigma
  }
  rxode2::rxUiCompress(.rx)
}

