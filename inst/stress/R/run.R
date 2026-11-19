## Orchestrate simulate -> NONMEM -> nonmem2rx for each case.
##
## Modes
##   "dry"  no NONMEM: write data + control stream, translate with
##          nonmem2rx, and compare the translated population prediction
##          with the rxode2 simulation model (catches translation and
##          data-handling errors without a NONMEM license).
##   "full" also run NONMEM, then import with full validation (NONMEM
##          IPRED/PRED/IWRES vs rxode2) using the output files.
##   "import" re-import existing NONMEM output (no simulation/NONMEM).

kitRunCase <- function(case, outDir, mode="dry", nSub=20L, seed=42L,
                       est="full", nmfe=NULL, timeout=3600) {
  .dir <- file.path(outDir, case$name)
  .res <- list(case=case$name, file=case$file,
               tags=paste(case$tags, collapse=","),
               known=!is.null(case$known), mode=mode,
               sim=NA, nonmem=NA, nmSeconds=NA_real_, import=NA,
               importError=NA_character_, dryImport=NA,
               dryError=NA_character_, dryMaxRel=NA_real_,
               dryNobs=NA_integer_, dryNexpected=NA_integer_,
               dryOmegaDiff=NA_real_, drySigmaDiff=NA_real_,
               ipredRtol=NA_real_, ipredQ95=NA_real_, ipredMax=NA_real_,
               predRtol=NA_real_, predQ95=NA_real_, predMax=NA_real_, iwresAtol=NA_real_, iwresRtol=NA_real_,
               dfSub=NA_real_, dfObs=NA_real_, nTheta=NA_integer_,
               nEta=NA_integer_, nWarn=NA_integer_, status=NA_character_,
               note=NA_character_)
  .tol <- .kitTol(case)
  if (mode != "import") {
    unlink(.dir, recursive=TRUE)
    dir.create(.dir, recursive=TRUE, showWarnings=FALSE)
    .sim <- try(kitSimulate(case, nSub=nSub, seed=seed), silent=TRUE)
    if (inherits(.sim, "try-error")) {
      .res$sim <- FALSE
      .res$note <- paste("simulation failed:", trimws(.sim))
      return(.kitFinish(.res, case, .tol, .dir))
    }
    .res$sim <- TRUE
    saveRDS(.sim, file.path(.dir, "sim.rds"))
    .input <- kitWriteData(case, .sim$data, file.path(.dir, "data.csv"))
    kitWriteCtl(case, .input, file.path(.dir, "run.ctl"), est=est,
                nSim=nrow(.sim$data))
    ## NONMEM-free translation check
    .dry <- kitImport(.dir, validate=FALSE)
    .res$dryImport <- is.na(.dry$error)
    .res$dryError <- .dry$error
    if (.res$dryImport) {
      .mat <- try(kitDryMatrices(.dry$value, case), silent=TRUE)
      if (inherits(.mat, "try-error")) {
        .res$dryError <- paste("omega/sigma check:", trimws(.mat))
      } else {
        .res$dryOmegaDiff <- .mat[["omega"]]
        .res$drySigmaDiff <- .mat[["sigma"]]
      }
    }
    if (.res$dryImport && isTRUE(case$dryPred)) {
      .dp <- try(kitDryPred(.dry$value, .sim$pred, .sim$data,
                              dryRows=case$dryRows), silent=TRUE)
      if (inherits(.dp, "try-error")) {
        .res$dryError <- trimws(.dp)
      } else {
        utils::write.csv(.dp$cmp, file.path(.dir, "dry-compare.csv"),
                         row.names=FALSE)
        .res$dryMaxRel <- .dp$maxRel
        .res$dryNobs <- .dp$nObs
        .res$dryNexpected <- .dp$nExpected
        if (.dp$rowsExtra + .dp$rowsMissing > 0) {
          .res$dryError <- sprintf("imported data has %d unexpected and is missing %d simulated rows (IGNORE/ACCEPT/RECORDS handling?)",
                                   .dp$rowsExtra, .dp$rowsMissing)
        }
      }
    }
  } else {
    ## keep the translate-check results of the run being re-imported, so
    ## a case known for a translation problem stays XFAIL
    .prev <- file.path(.dir, "result.rds")
    if (file.exists(.prev)) {
      .prev <- readRDS(.prev)
      .keep <- intersect(c("sim", "dryImport", "dryError", "dryMaxRel", "dryNobs",
                           "dryNexpected", "dryOmegaDiff", "drySigmaDiff"),
                         names(.prev))
      .res[.keep] <- .prev[1, .keep]
    }
  }
  if (mode == "full") {
    if (is.null(nmfe)) stop("full mode needs a NONMEM command (--nmfe)", call.=FALSE)
    .nm <- kitRunNonmem(.dir, paste(c(nmfe, case$nmfeArgs), collapse=" "),
                        timeout=timeout)
    .res$nonmem <- .nm$ok
    .res$nmSeconds <- .nm$seconds
    if (!.nm$ok) {
      .why <- .kitNonmemError(.dir)
      .res$note <- paste("NONMEM did not finish:", .why)
      if (startsWith(.why, "licence:")) {
        ## e.g. ADVAN16/17 need the RADAR5NM licence extension
        .res$status <- "SKIP"
        .res$note <- paste("needs a NONMEM licence extension;", .why)
        return(.kitFinish(.res, case, .tol, .dir))
      }
      if ("nm75" %in% case$tags) {
        ## cases using NONMEM 7.5 features are skipped, not failed, only on
        ## a NONMEM known to be older than 7.5
        .v <- .kitEnv$nmVersion
        if (!is.null(.v) && !is.na(.v) && .v < "7.5") {
          .res$status <- "SKIP"
          .res$note <- paste0("needs NONMEM 7.5 or later (NONMEM ", .v, ": ", .why, ")")
        } else {
          .res$note <- paste0(.res$note, " [case uses NONMEM 7.5 features]")
        }
      }
      return(.kitFinish(.res, case, .tol, .dir))
    }
  }
  if (mode %in% c("full", "import")) {
    .imp <- kitImport(.dir, validate=TRUE)
    .res$import <- is.na(.imp$error)
    .res$importError <- .imp$error
    .res$nWarn <- length(.imp$warnings)
    if (.res$import) {
      .met <- kitImportMetrics(.imp$value)
      .res[names(.met)] <- .met
      saveRDS(.imp$value, file.path(.dir, "nonmem2rx.rds"))
    }
  }
  .kitFinish(.res, case, .tol, .dir)
}

.kitPassDry <- function(res, case, tol) {
  if (!isTRUE(res$sim) || !isTRUE(res$dryImport)) return(FALSE)
  .matOk <- function(x) is.na(x) || x <= 1e-6
  if (!.matOk(res$dryOmegaDiff) || !.matOk(res$drySigmaDiff)) return(FALSE)
  if (!is.na(res$dryError)) return(FALSE)
  if (!isTRUE(case$dryPred)) return(TRUE)
  is.finite(res$dryMaxRel) && res$dryMaxRel <= tol$dry &&
    identical(as.integer(res$dryNobs), as.integer(res$dryNexpected))
}

.kitPassFull <- function(res, tol) {
  if (!isTRUE(res$import)) return(FALSE)
  if (isFALSE(tol$validate)) return(TRUE)
  .chk <- function(v, t) is.na(t) || (is.finite(v) && v <= t)
  ## validation must have actually happened
  if (!is.finite(res$ipredRtol) && !is.finite(res$predRtol)) return(FALSE)
  ## both IPRED and PRED must validate (the standard tables provide both);
  ## a case can opt out with tol=list(ipred=NA, ipredQ95=NA) etc.
  .chk(res$ipredRtol, tol$ipred) && .chk(res$predRtol, tol$pred) &&
    .chk(res$ipredQ95, tol$ipredQ95) && .chk(res$predQ95, tol$predQ95) &&
    .chk(res$iwresAtol, tol$iwres)
}

.kitFinish <- function(res, case, tol, dir) {
  ## knownFull only applies once NONMEM output is involved
  .known <- case$known
  if (res$mode %in% c("full", "import") && !is.null(case$knownFull)) {
    .known <- paste(c(.known, case$knownFull), collapse="; ")
  }
  res$known <- !is.null(.known)
  if (identical(res$status, "SKIP")) {
    .df <- as.data.frame(res, stringsAsFactors=FALSE)
    if (dir.exists(dir)) saveRDS(.df, file.path(dir, "result.rds"))
    return(.df)
  }
  .pass <- switch(res$mode,
                  dry=.kitPassDry(res, case, tol),
                  full=.kitPassDry(res, case, tol) && .kitPassFull(res, tol),
                  import=(!isTRUE(res$sim) || .kitPassDry(res, case, tol)) &&
                    .kitPassFull(res, tol))
  res$status <- if (.pass) {
    if (res$known) "XPASS" else "PASS"
  } else {
    if (res$known) "XFAIL" else "FAIL"
  }
  if (res$known) {
    res$note <- if (is.na(res$note)) .known else paste0(.known, " [", res$note, "]")
  }
  .df <- as.data.frame(res, stringsAsFactors=FALSE)
  if (dir.exists(dir)) saveRDS(.df, file.path(dir, "result.rds"))
  .df
}

kitRun <- function(cases, outDir, mode="dry", nSub=20L, seed=42L,
                   est="full", nmfe=NULL, jobs=1L, timeout=3600) {
  dir.create(outDir, recursive=TRUE, showWarnings=FALSE)
  .one <- function(case) {
    .t0 <- Sys.time()
    .r <- tryCatch(kitRunCase(case, outDir, mode=mode, nSub=nSub,
                              seed=seed, est=est, nmfe=nmfe,
                              timeout=timeout),
                   error=function(e) {
                     data.frame(case=case$name, file=case$file,
                                tags=paste(case$tags, collapse=","),
                                known=!is.null(case$known), mode=mode,
                                status="ERROR",
                                note=conditionMessage(e))
                   })
    message(sprintf("[%-5s] %-32s %6.1fs %s", .r$status, case$name,
                    as.numeric(Sys.time() - .t0, units="secs"),
                    if (!is.null(.r$note) && !is.na(.r$note)) .r$note else ""))
    .r
  }
  .l <- if (jobs > 1L && .Platform$OS.type == "unix") {
    parallel::mclapply(cases, .one, mc.cores=jobs, mc.preschedule=FALSE)
  } else {
    lapply(cases, .one)
  }
  ## a crashed fork gives NULL or a try-error instead of a result row
  .l <- lapply(seq_along(.l), function(i) {
    .x <- .l[[i]]
    if (is.data.frame(.x)) return(.x)
    data.frame(case=cases[[i]]$name, mode=mode, status="ERROR",
               note=paste("worker failed:",
                          if (is.null(.x)) "no result (crashed?)" else trimws(as.character(.x))))
  })
  .all <- unique(unlist(lapply(.l, names)))
  .l <- lapply(.l, function(d) {
    for (.n in setdiff(.all, names(d))) d[[.n]] <- NA
    d[, .all]
  })
  do.call(rbind, .l)
}
