#!/usr/bin/env Rscript
## KIT SELF-TEST ONLY -- this is NOT NONMEM.
##
## Stands in for `nmfe` so the kit's full/import plumbing can be checked
## without a NONMEM license:
##   Rscript kit/run-kit.R --mode full --nmfe "Rscript /abs/path/kit/mock/fake-nonmem.R {ctl} {lst}"
##
## It writes NONMEM-format run.lst / run.ext and every $TABLE file of the
## control stream from the rxode2 truth (initial estimates, all etas 0),
## so nonmem2rx's validation should agree with the dry-run comparison.
## It says nothing about how NONMEM itself behaves.

.args <- commandArgs(trailingOnly=TRUE)
.ctl <- .args[1]
.lst <- .args[2]
.pkg <- Sys.getenv("NMKIT_PKGDIR", "")
suppressMessages({
  if (nzchar(.pkg)) devtools::load_all(.pkg, quiet=TRUE) else library(nonmem2rx)
  library(rxode2)
})

.m <- suppressMessages(withr::with_options(
  list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE),
  nonmem2rx(.ctl, lst=".none", validate=FALSE, thetaNames=FALSE,
            etaNames=FALSE, determineError=FALSE, compress=FALSE)))
.sim <- readRDS("sim.rds")

.e <- function(x) formatC(x, format="E", digits=5, width=12)

## .ext: initial estimates as the final estimates
.th <- .m$theta
.th <- .th[grepl("^theta[0-9]+$", names(.th))]  # not SIGMA(i,j) used in code
.th <- .th[order(as.integer(sub("^theta", "", names(.th))))]
.lower <- function(mat, lab) {
  if (is.null(mat)) return(NULL)
  .n <- nrow(mat)
  .v <- c(); .nm <- c()
  for (.i in seq_len(.n)) for (.j in seq_len(.i)) {
    .v <- c(.v, mat[.i, .j]); .nm <- c(.nm, sprintf("%s(%d,%d)", lab, .i, .j))
  }
  setNames(.v, .nm)
}
.sig <- .m$sigma
if (is.null(.sig)) .sig <- matrix(1, dimnames=list("eps1", "eps1"))
.vals <- c(setNames(.th, sprintf("THETA%d", seq_along(.th))),
           .lower(.sig, "SIGMA"), .lower(.m$omega, "OMEGA"))
.hdr <- paste(c(" ITERATION", formatC(names(.vals), width=-12), "OBJ"), collapse=" ")
.row <- function(it, v, obj) paste(c(formatC(it, format="d", width=13), .e(v), formatC(obj, format="f", digits=6, width=20)), collapse=" ")
writeLines(c("TABLE NO.     1: First Order Conditional Estimation with Interaction: Goal Function=MINIMUM VALUE OF OBJECTIVE FUNCTION: Problem=1 Subproblem=0 Superproblem1=0 Iteration1=0 Superproblem2=0 Iteration2=0",
             .hdr, .row(0, .vals, 100), .row(-1000000000, .vals, 100)),
           sub("[.][^.]*$", ".ext", .lst))

## tables: every record after filtering is a simulated row
.d <- .sim$data
## NONMEM writes the ID values of the data file (they differ from the
## simulation's when a case rewrites them, e.g. reused IDs)
.f <- try(utils::read.csv("data.csv", check.names=FALSE), silent=TRUE)
if (!inherits(.f, "try-error")) {
  names(.f) <- toupper(gsub("[^A-Za-z0-9]", "", names(.f)))
  if (all(c("ID", "ROWID") %in% names(.f))) {
    .rowMatch <- match(.d$ROWID, suppressWarnings(as.numeric(.f$ROWID)))
    if (!anyNA(.rowMatch)) .d$ID <- suppressWarnings(as.numeric(.f$ID[.rowMatch]))
  }
}
.p <- .sim$predAll
.pred <- .p$simPred[match(.d$ROWID, .p$ROWID)]
.pred[is.na(.pred)] <- 0
.nEta <- NROW(.m$omega)
.col <- function(name) {
  .u <- toupper(name)
  if (.u %in% names(.d)) return(.d[[.u]])
  if (.u %in% c("IPRED", "IPRE", "PRED", "CIPRED", "CIPREDI")) return(.pred)
  0
}
.ctlLines <- readLines(.ctl)
for (.t in grep("^[$]TAB", .ctlLines, value=TRUE)) {
  .tok <- strsplit(trimws(sub("^[$]TAB[A-Z]*", "", .t)), "[ ,]+")[[1]]
  .file <- sub("^FILE=", "", grep("^FILE=", .tok, value=TRUE))
  .opts <- toupper(.tok[!grepl("=", .tok)])
  .flags <- c("NOAPPEND", "NOPRINT", "PRINT", "ONEHEADER", "NOHEADER", "FIRSTONLY", "NOSUB=0")
  .cols <- .opts[!.opts %in% .flags]
  .cols <- unlist(lapply(.cols, function(c) {
    if (grepl("^ETAS\\(", c)) return(sprintf("ETA%d", seq_len(.nEta)))
    c
  }))
  if (!"NOAPPEND" %in% .opts) .cols <- c(.cols, setdiff(c("DV", "PRED", "RES", "WRES"), .cols))
  .tab <- vapply(.cols, function(c) rep_len(as.numeric(.col(c)), nrow(.d)), numeric(nrow(.d)))
  if (!is.matrix(.tab)) .tab <- matrix(.tab, nrow=nrow(.d))
  ## one row per individual (a contiguous run of the same ID)
  if ("FIRSTONLY" %in% .opts) .tab <- .tab[c(TRUE, diff(.d$ID) != 0), , drop=FALSE]
  .body <- apply(.tab, 1, function(r) paste0(" ", paste(.e(r), collapse=" ")))
  .head <- c("TABLE NO.  1", paste0(" ", paste(formatC(.cols, width=-12), collapse=" ")))
  .out <- if ("NOHEADER" %in% .opts) .body else if ("ONEHEADER" %in% .opts) c(.head, .body) else {
    ## NONMEM repeats the header block every 900 records without ONEHEADER
    unlist(lapply(split(.body, ceiling(seq_along(.body) / 900)), function(b) c(.head, b)))
  }
  writeLines(.out, .file)
}

writeLines(c(.ctlLines, "",
             " #TERM:", "0MINIMIZATION SUCCESSFUL", "",
             " #OBJT:**************                       MINIMUM VALUE OF OBJECTIVE FUNCTION                      ********************",
             " #OBJV:********************************************      100.000       **************************************************",
             "", "Stop Time:", format(Sys.time())), .lst)
