## Import a case with nonmem2rx and score it.

## percent thresholds: ipred/pred on the median, ipredQ95/predQ95 on the
## 95th percentile (so a wrong subset of records is not hidden by the
## median); iwres is an absolute median IWRES difference (off by
## default); `validate=FALSE` accepts an import that nonmem2rx did not
## (or cannot) validate, e.g. $MIX models
.kitTolDefault <- list(ipred=1, pred=1, ipredQ95=5, predQ95=5, iwres=NA,
                       dry=0.01, validate=TRUE)

.kitTol <- function(case) {
  .t <- .kitTolDefault
  .t[names(case$tol)] <- case$tol
  .t
}

## Run `expr`, collecting messages/warnings to `logFile`; returns a
## list(value=, error=, warnings=).
.kitCapture <- function(expr, logFile) {
  .log <- character(0)
  .warn <- character(0)
  .out <- utils::capture.output(.val <- tryCatch(
    withCallingHandlers(expr,
      message=function(m) {
        .log <<- c(.log, sub("\n$", "", conditionMessage(m)))
        invokeRestart("muffleMessage")
      },
      warning=function(w) {
        .warn <<- c(.warn, conditionMessage(w))
        .log <<- c(.log, paste("WARNING:", conditionMessage(w)))
        invokeRestart("muffleWarning")
      }),
    error=function(e) {
      .log <<- c(.log, paste("ERROR:", conditionMessage(e)))
      structure(conditionMessage(e), class="kitError")
    }))
  writeLines(c(.log, if (length(.out)) c("---- stdout ----", .out)), logFile)
  if (inherits(.val, "kitError")) {
    ## parser/rxode2 syntax errors are printed, not in the condition
    .err <- c(unclass(.val), grep(":ERR:|syntax error", .out, value=TRUE))
    return(list(value=NULL, error=paste(unique(.err), collapse=" "),
                warnings=.warn))
  }
  list(value=.val, error=NA_character_, warnings=.warn)
}

kitImport <- function(dir, validate=TRUE) {
  .ctl <- file.path(dir, "run.ctl")
  .capture <- .kitCapture(
    withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE,
                             nonmem2rx.overwrite=FALSE), {
      nonmem2rx::nonmem2rx(.ctl, lst=".lst", validate=validate,
                           nonmemData=TRUE, compress=FALSE)
    }),
    file.path(dir, if (validate) "import.log" else "import-dry.log"))
  .capture
}

.kitNum <- function(x) if (is.null(x) || length(x) != 1L) NA_real_ else as.numeric(x)

## Validation metrics computed by nonmem2rx itself (NONMEM vs rxode2).
## nonmem2rx stores the rtol values as fractions; the kit reports percent.
kitImportMetrics <- function(m) {
  ## percent differences; rows where NONMEM has a value but rxode2 does
  ## not count as Inf, rows with a zero NONMEM value are scored by an
  ## absolute difference floor
  .rel <- function(cmp, a, b) {
    if (is.null(cmp) || !all(c(a, b) %in% names(cmp))) return(NULL)
    .d <- abs(cmp[[a]] - cmp[[b]])
    .r <- ifelse(abs(cmp[[b]]) > 1e-8, 100 * .d / abs(cmp[[b]]),
                 ifelse(.d <= 1e-6, 0, Inf))
    .r[is.finite(cmp[[b]]) & !is.finite(.r)] <- Inf
    .r[is.finite(cmp[[b]])]
  }
  .q <- function(r, p) if (length(r) == 0) NA_real_ else
    unname(stats::quantile(r, p, type=1))
  .ri <- .rel(m$ipredCompare, "IPRED", "nonmemIPRED")
  .rp <- .rel(m$predCompare, "PRED", "nonmemPRED")
  list(ipredRtol=100 * .kitNum(m$ipredRtol), ipredQ95=.q(.ri, 0.95), ipredMax=.q(.ri, 1),
       predRtol=100 * .kitNum(m$predRtol), predQ95=.q(.rp, 0.95), predMax=.q(.rp, 1),
       iwresAtol=.kitNum(m$iwresAtol), iwresRtol=100 * .kitNum(m$iwresRtol),
       dfSub=.kitNum(m$dfSub), dfObs=.kitNum(m$dfObs),
       nTheta=length(m$theta), nEta=NROW(m$omega))
}

## NONMEM-free check: solve the imported model at the control stream's
## initial estimates with zero random effects and compare to the rxode2
## simulation model's population prediction.  Since the control stream
## initial estimates equal the simulation's true values, these should
## agree to solver precision when the translation is faithful.
kitDryPred <- function(m, simPred, simData, dryRows=NULL) {
  .model <- m$simulationModelIwres
  .theta <- m$theta
  .params <- c(.theta,
               setNames(rep(0, NROW(m$omega)), dimnames(m$omega)[[1]]),
               setNames(rep(0, length(m$sigmaNames)), m$sigmaNames))
  if (!is.null(m$predDf)) {
    .params <- c(.params, setNames(rep(0, length(m$predDf$var)),
                                   paste0("rxerr.", m$predDf$var)))
  }
  .nd <- m$nonmemData
  if (is.null(.nd)) stop("nonmem2rx did not read the NONMEM data", call.=FALSE)
  if (!any(names(.nd) == "ROWID")) stop("ROWID was not kept in the imported data", call.=FALSE)
  ## a reused, non-contiguous NONMEM ID is a new individual
  .wid <- which(toupper(names(.nd)) == "ID")[1]
  .wt <- which(toupper(names(.nd)) == "TIME")[1]
  .toRxId <- utils::getFromNamespace("fromNonmemToRxId", "nonmem2rx")
  .nd[[.wid]] <- .toRxId(as.integer(.nd[[.wid]]), as.double(.nd[[.wt]]))
  .opts <- .kitSolveOpts
  .opts[c("atol", "rtol", "ssAtol", "ssRtol")] <- list(m$atol, m$rtol, m$ssAtol, m$ssRtol)
  .opts <- .opts[!vapply(.opts, is.null, logical(1))]
  .s <- suppressMessages(do.call(rxode2::rxSolve,
                                 c(list(.model, .params, .nd, keep="ROWID",
                                        returnType="data.frame", addDosing=FALSE),
                                   .opts)))
  .y <- if (is.null(m$predDf)) names(.s)[tolower(names(.s)) == "y"][1] else "sim"
  .use <- simData$EVID == 0 & simData$MDV == 0
  if (is.function(dryRows)) .use <- .use & dryRows(simData)
  .obs <- simData$ROWID[.use]
  .cmp <- merge(data.frame(ROWID=.s$ROWID, nmPred=.s[[.y]]),
                simPred[simPred$ROWID %in% .obs, ], by="ROWID")
  ## rows kept after IGNORE/ACCEPT/RECORDS must be exactly the simulated rows
  .extra <- setdiff(.nd$ROWID, simData$ROWID)
  .missing <- setdiff(simData$ROWID, .nd$ROWID)
  .d <- abs(.cmp$nmPred - .cmp$simPred)
  .d[!is.finite(.d)] <- Inf  # NaN/NA predictions are failures
  ## rows whose truth is ~0 (pre-lag, after a reset) use an absolute floor
  .r <- ifelse(abs(.cmp$simPred) > 1e-8, 100 * .d / abs(.cmp$simPred),
               ifelse(.d <= 1e-8, 0, Inf))
  list(cmp=.cmp, nObs=nrow(.cmp), nExpected=length(.obs),
       rowsExtra=length(.extra), rowsMissing=length(.missing),
       maxRel=if (nrow(.cmp)) max(.r) else NA_real_,
       maxAbs=if (nrow(.cmp)) max(.d) else NA_real_)
}

## Compare imported $OMEGA (and optionally $SIGMA) with the truth.  PRED
## does not depend on them, so this catches SD/CORRELATION/CHOLESKY/SAME
## parsing errors that the PRED comparison cannot.
.kitMatDiff <- function(a, b) {
  a <- as.matrix(a); b <- as.matrix(b)
  if (!identical(dim(a), dim(b))) return(Inf)
  max(abs(unname(a) - unname(b)) / pmax(1, abs(unname(b))))
}

kitDryMatrices <- function(m, case) {
  .ret <- c(omega=NA_real_, sigma=NA_real_)
  if (isTRUE(case$dryOmega)) {
    .simOmega <- rxode2::assertRxUi(case$sim)$omega
    .nmOmega <- m$omega
    .ret["omega"] <- if (is.null(.simOmega) && is.null(.nmOmega)) 0 else
      .kitMatDiff(.nmOmega, .simOmega)
  }
  if (!is.null(case$sigma)) {
    .s <- m$sigma
    if (is.null(.s)) .s <- m$meta$sigma
    .ret["sigma"] <- .kitMatDiff(.s, case$sigma)
  }
  .ret
}
