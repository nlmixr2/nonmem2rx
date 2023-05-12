#' This function gets relevant ETAs for the validation
#'
#' @param etaData nonmem eta data (derived from `.readInDataFromNonmem()`)
#' @param inputData nonmem input data (derived from `.readInPredFromTables()`)
#' @param model rxode2 model
#' @return eta data
#' @details
#'
#' NONMEM uses all data even if it does not contain any observations
#' (doses only).  `rxode2` and `nlmixr2` drop data without any observations.
#'
#' This routine tries to figure out the subjects who have data
#' remaining and keeps only those ETAs
#'
#' @noRd
#' @author Matthew L. Fidler
.getValidationEtas <- function(etaData, inputData, model) {
  if (is.null(inputData)) return(NULL)
  .eid <- unique(etaData$ID)
  .m <- rxode2::etTrans(inputData, model)
  .id <- as.numeric(levels(.m$ID))
  .ret <- etaData
  .d <- setdiff(.eid, .id)
  if (length(.d) > 0) {
    .minfo(paste0("observation only ETAs are ignored: ", paste(.d, collapse=", ")))
    return(.ret[.ret$ID %in% .id,])
  }
  return(etaData)
}

#' Fix NONMEM ties
#'
#' @param inputData  nonmem input dataset
#' @param delta shift for times
#' @return input dataset offset for tied times
#' @noRd
#' @author Matthew L. Fidler
.fixNonmemTies <- function(inputData, delta=1e-4) {
  if (is.null(inputData)) return(NULL)
  .wid <- which(tolower(names(inputData)) == "id")
  .wtime <- which(tolower(names(inputData)) == "time")
  if (length(.wid) != 1L) return(NULL)
  if (length(.wtime) != 1L) return(NULL)
  .id <- as.integer(inputData[,.wid])
  .time <- as.double(inputData[,.wtime])
  .new <- .Call(`_nonmem2rx_fixNonmemTies`, .id, .time, delta)
  .inputData <- inputData
  .inputData[,.wid] <- .id
  .inputData[,.wtime] <- .new
  .inputData
}
#' Get the nonmem observation data indexes
#'
#' @param inputData nonmem input data
#' @return nonmem observation data
#' @noRd
#' @author Matthew L. Fidler
.nonmemObsIndex <- function(inputData) {
  .wevid <- which(tolower(names(inputData)) == "evid")
  if (length(.wevid) == 1L) {
    .evid <- inputData[,.wevid]
    return(which(.evid == 0 | .evid == 2))
  }
  .wmdv <- which(tolower(names(inputData)) == "mdv")
  if (length(.wmdv) == 1L) {
    .mdv <- inputData[,.wmdv]
    return(which(.mdv == 0))
  }
  .wdv <- which(tolower(names(inputData)) == "dv")
  if (length(.wdv) == 1L) {
    .dv <- inputData[,.wdv]
    return(which(!is.na(.dv)))
  }
  seq_along(inputData[,1])
}

#' Do a validation on a ui setup with nonmem information inside of it
#'
#'
#' @param ui rxode2 uncompressed ui
#' @param msg message to integrate so far
#' @param validate boolean to validate the output
#' @param ci confidence interval
#' @param sigdig significant digits
#' @return messages to integrate
#' @noRd
#' @author Matthew L. Fidler
.nonmem2rxValidate <- function(ui, msg=character(0), validate=TRUE, ci=0.95, sigdig=3) {
  .rx <- ui
  .msg <- msg
  .ipredData <- .predData <- NULL
  if (is.null(.rx$nonmemData) && validate) {
    .msg <- "could not read in input data; validation skipped"
  }
  if (!is.null(.rx$nonmemData) && validate) {
    .nonmemData <- .rx$nonmemData
    .model <- .rx$simulationModelIwres
    .theta <- .rx$theta
    .ci0 <- .ci <- ci
    .sigdig <- sigdig
    .ci <- (1 - .ci) / 2
    .q <- c(0, .ci, 0.5, 1 - .ci, 1)
    .obsIdx <- .nonmemObsIndex(.nonmemData)
    .msg <- NULL
    if (!is.null(.rx$etaData) && !is.null(.rx$ipredData)) {
      if (length(.rx$ipredData[,1]) == length(.nonmemData[,1])) {
        .ipredData <- .rx$ipredData[.obsIdx,]
      } else {
        .ipredData <- .rx$ipredData
      }
      .params <- .rx$etaData
      for (.i in seq_along(.theta)) {
        .params[[names(.theta)[.i]]] <- .theta[.i]
      }
      .dn <- .rx$sigmaNames
      for (.i in .dn) {
        .params[[.i]] <- 0
      }
      if (!is.null(.rx$predDf)) {
        for (.v in .rx$predDf$var) {
          .params[[paste0("err.", .v)]] <- 0
        }
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
                                   atol=.rx$atol, rtol=.rx$rtol,
                                   ssAtol=.rx$ssAtol, ssRtol=.rx$ssRtol,
                                   addDosing = FALSE))
        .minfo("done")
      }
      if (.doIpred && !inherits(.ipredSolve, "try-error")) {
        if (is.null(.rx$predDf)) {
          .w <- which(tolower(names(.ipredSolve)) == "y")
          .y <- names(.ipredSolve)[.w]
          .w <- which(tolower(names(.ipredSolve)) == "iwres")
          if (length(.w) == 1L) {
            .iwres <- names(.ipredSolve)[.w]
          }
        } else {
          .y <- "sim"
          .iwres <- "iwres"
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
      if (any(names(.ipredData) == "IWRES"))  {
        if (length(.ipredData$IWRES) == length(.ipredSolve[[.iwres]])) {
          .wid  <- which(tolower(names(.ipredData)) == "id")
          .wtime  <- which(tolower(names(.ipredData)) == "time")
          .cmp <- data.frame(ID=.ipredData[,.wid], TIME=.ipredData[,.wtime],
                             nonmemIWRES=.ipredData$IWRES,
                             IWRES=.ipredSolve[[.iwres]])
          .qi <- stats::quantile(with(.cmp, 100*abs((IWRES-nonmemIWRES)/nonmemIWRES)), .q, na.rm=TRUE)
          #.qp <- stats::quantile(with(.ret, 100*abs((PRED-nonmemPRED)/nonmemPRED)), .q, na.rm=TRUE)
          .qai <- stats::quantile(with(.cmp, abs(IWRES-nonmemIWRES)), .q, na.rm=TRUE)
          #.qap <- stats::quantile(with(.ret, abs((PRED-nonmemPRED)/nonmemPRED)), .q, na.rm=TRUE)
          .msg <- c(.msg, paste0("IWRES relative difference compared to Nonmem IWRES: ", round(.qi[3], 2),
                           "%; ", .ci0 * 100,"% percentile: (",
                           round(.qi[2], 2), "%,", round(.qi[4], 2), "%); rtol=",
                           signif(.qi[3] / 100, digits=.sigdig)),
                    paste0("IWRES absolute difference compared to Nonmem IWRES: ", .ci0 * 100,"% percentile: (",
                           signif(.qai[2], .sigdig), ", ", signif(.qai[4], .sigdig), "); atol=",
                           signif(.qai[3], .sigdig)))
          .rx$iwresAtol <- .qai[3]
          .rx$iwresRtol <- .qi[3]/100
          .rx$iwresCompare <- .cmp
        } else {
          .msg < c(.msg, sprintf("the length of the iwres solve (%d) is not the same as the iwres in the nonmem output (%d); input length: %d",
                          length(.ipredSolve[[.iwres]]), length(.ipredData$IWRES),
                          length(.nonmemData[,1])))
          .minfo(.msg)
        }
      }
    }
    if (!is.null(.rx$predData)) {
      if (length(.rx$predData[,1]) == length(.nonmemData[,1])) {
        .predData <- .rx$predData[.obsIdx,]
      } else {
        .predData <- .rx$predData
      }
      .params <- c(.theta,
                   vapply(dimnames(.rx$omega)[[1]],
                          function(x) {
                            return(0.0)
                          }, double(1), USE.NAMES = TRUE),
                   vapply(.rx$sigmaNames,
                          function(x) {
                            return(0.0)
                          }, double(1), USE.NAMES = TRUE))
      if (!is.null(.rx$predDf)) {
        .params <- c(.params, setNames(rep(0, length(.rx$predDf$cond)),
                                           paste0("err.", .rx$predDf$var)))
      }
      .minfo("solving pred problem")
      .predSolve <- try(rxSolve(.model, .params, .nonmemData, returnType = "tibble",
                                covsInterpolation="nocb",
                                atol=.rx$atol, rtol=.rx$rtol,
                                ssAtol=.rx$ssAtol, ssRtol=.rx$ssRtol,
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
    if (!is.null(.rx$predDf)) {
      # try a iwres validation
    }
    if (is.null(.ipredData) && is.null(.predData)) {
      .msg <- "NONMEM input data found but could not find output PRED/IPRED data to validate against"
      warning("NONMEM input data found but could not find output PRED/IPRED data to validate against", call.=FALSE)
    }
  }
  .msg
}
