## Simulate a case's observations with rxode2.
##
## The NONMEM-faithful solving options used here are the same ones
## nonmem2rx uses when it validates an import (see R/validate.R), so
## the simulated "truth" follows NONMEM event semantics (nocb covariate
## interpolation, SS at dose time, ...).  When rxode2 has
## rxSolve(nonmem=TRUE), $PK-like statements read the record time and
## ADDL doses do not keep the covariates of their dose record; otherwise
## ADDL keeps covariates (see .kitModelOpts()).

.kitHasNonmemSolve <- utils::getFromNamespace(".nonmem2rxHasNonmemSolve", "nonmem2rx")()

.kitSolveOpts <- list(covsInterpolation="nocb",
                      addlDropSs=TRUE, ssAtDoseTime=TRUE,
                      ss2cancelAllPending=TRUE, safeZero=FALSE,
                      safePow=FALSE, safeLog=FALSE,
                      atol=1e-10, rtol=1e-10, ssAtol=1e-10, ssRtol=1e-10)

## the model-dependent options, chosen like nonmem2rx's validation does
.kitModelOpts <- function(model) {
  .use <- utils::getFromNamespace(".nonmem2rxUseNonmemSolve", "nonmem2rx")
  if (.use(model)) list(nonmem=TRUE, addlKeepsCov=FALSE) else list(addlKeepsCov=TRUE)
}

.kitSeed <- function(name, seed) {
  ## stable per-case seed so cases are reproducible independently
  seed + sum(utf8ToInt(name) * seq_along(utf8ToInt(name))) %% 100000L
}

.kitSolve <- function(ui, d, addDosing=FALSE, ...) {
  .args <- c(list(ui, d, keep="ROWID", returnType="data.frame",
                  addDosing=addDosing), .kitSolveOpts, .kitModelOpts(ui),
             list(...))
  suppressMessages(do.call(rxode2::rxSolve, .args))
}

## Returns the simulated NONMEM dataset (with ROWID) and the
## population prediction (all random effects zero) for the dry run.
kitSimulate <- function(case, nSub, seed=42L) {
  .d <- case$data(if (is.null(case$nSub)) nSub else case$nSub)
  .d$ROWID <- seq_len(nrow(.d))
  .seed <- .kitSeed(case$name, seed)
  set.seed(.seed)
  rxode2::rxSetSeed(.seed)
  .ui <- rxode2::assertRxUi(case$sim)
  .s <- .kitSolve(.ui, .d)
  if (is.function(case$postSim)) {
    .d <- case$postSim(.d, .s)
  } else {
    .m <- match(.d$ROWID, .s$ROWID)
    .obs <- .d$EVID == 0 & .d$MDV == 0 & !is.na(.m)
    .d$DV[.obs] <- signif(.s$sim[.m[.obs]], 6)
  }
  .zero <- rxode2::zeroRe(.ui)
  .p <- suppressWarnings(.kitSolve(.zero, .d))
  .pv <- case$pred[["sim"]]
  if (is.null(.pv)) .pv <- "sim"
  ## all records (doses/other events too) for writing mock NONMEM tables
  .pa <- suppressWarnings(.kitSolve(.zero, .d, addDosing=TRUE))
  .pa <- .pa[!duplicated(.pa$ROWID), ]
  list(data=.d,
       pred=data.frame(ROWID=.p$ROWID, simPred=.p[[.pv]]),
       predAll=data.frame(ROWID=.pa$ROWID, simPred=.pa[[.pv]]),
       seed=.seed)
}

## Write the NONMEM dataset; returns the $INPUT string.
kitWriteData <- function(case, d, file) {
  .w <- if (is.function(case$write)) case$write(d) else d
  if (is.character(.w)) {
    writeLines(.w, file)
    .cols <- strsplit(sub("^[#@]?", "", .w[1]), "[ ,\t]+")[[1]]
  } else {
    .w[] <- lapply(.w, function(x) {
      .r <- if (is.numeric(x)) format(signif(x, 8), scientific=FALSE, trim=TRUE,
                                      drop0trailing=TRUE)
            else as.character(x)
      .r[is.na(x)] <- "."  # NM-TRAN missing value; format() would give "NA"
      .r
    })
    utils::write.csv(.w, file, row.names=FALSE, quote=FALSE, na=".")
    .cols <- names(.w)
  }
  if (!is.null(case$input)) return(case$input)
  paste(.cols, collapse=" ")
}
