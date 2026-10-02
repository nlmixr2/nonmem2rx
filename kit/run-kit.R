#!/usr/bin/env Rscript
## nonmem2rx round-trip kit: simulate with rxode2 -> run NONMEM ->
## import with nonmem2rx -> validate.  See kit/README.md.
##
## Usage (from the package root):
##   Rscript kit/run-kit.R --list
##   Rscript kit/run-kit.R --mode dry                     # no NONMEM needed
##   Rscript kit/run-kit.R --mode full --nmfe "nmfe75 {ctl} {lst}" --jobs 4
##   Rscript kit/run-kit.R --mode full --tags dosing,ss --nsub 40
##   Rscript kit/run-kit.R --mode import --out kit-runs   # re-import outputs
##
## Options:
##   --mode dry|full|import   (default dry)
##   --cases a,b,c            run only these cases
##   --tags t1,t2             run cases having any of these tags
##   --nmfe "cmd"             NONMEM command template ({ctl}, {lst});
##                            default from env NMKIT_NMFE
##   --est full|posthoc       default estimation records (default full;
##                            posthoc = MAXEVAL=0 at the true values)
##   --nsub N                 subjects per case (default 20)
##   --seed N                 base seed (default 42)
##   --jobs N                 parallel cases (default 1)
##   --out DIR                output directory (default kit-runs)
##   --timeout S              NONMEM timeout per case in seconds (3600)
##   --installed              use the installed nonmem2rx (default when the
##                            kit lives in the nonmem2rx source tree is
##                            devtools::load_all() of that tree)

.args <- commandArgs(trailingOnly=TRUE)
.opt <- function(name, default=NULL) {
  .w <- which(.args == paste0("--", name))
  if (length(.w) == 0) return(default)
  if (.w == length(.args) || startsWith(.args[.w + 1], "--")) return(TRUE)
  .args[.w + 1]
}
.split <- function(x) if (is.null(x)) NULL else strsplit(x, ",")[[1]]

.kitDir <- local({
  .f <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value=TRUE))
  if (length(.f) == 1) dirname(normalizePath(.f)) else "kit"
})

.pkgDir <- dirname(.kitDir)
.inSource <- file.exists(file.path(.pkgDir, "DESCRIPTION")) &&
  any(grepl("^Package: nonmem2rx$", readLines(file.path(.pkgDir, "DESCRIPTION"))))
if (.inSource && !isTRUE(.opt("installed"))) {
  message("using nonmem2rx from source: ", .pkgDir)
  Sys.setenv(NMKIT_PKGDIR=.pkgDir)  # also used by kit/mock/fake-nonmem.R
  suppressMessages(devtools::load_all(.pkgDir, quiet=TRUE))
} else {
  suppressMessages(library(nonmem2rx))
}
suppressMessages(library(rxode2))
rxode2::setRxThreads(1L)
data.table::setDTthreads(1L)

for (.f in list.files(file.path(.kitDir, "R"), full.names=TRUE)) source(.f)
kitLoadCases(file.path(.kitDir, "cases"))

if (isTRUE(.opt("list"))) {
  .l <- kitList()
  print(.l, right=FALSE, row.names=FALSE)
  quit(status=0)
}

.mode <- .opt("mode", "dry")
.cases <- kitCases(names=.split(.opt("cases")), tags=.split(.opt("tags")))
.nmfe <- .opt("nmfe", Sys.getenv("NMKIT_NMFE", ""))
if (!nzchar(.nmfe)) .nmfe <- NULL
if (.mode == "full" && is.null(.nmfe)) {
  stop("--mode full needs --nmfe \"nmfe75 {ctl} {lst}\" or NMKIT_NMFE", call.=FALSE)
}
.out <- normalizePath(.opt("out", "kit-runs"), mustWork=FALSE)

message(sprintf("nonmem2rx kit: %d case(s), mode=%s, out=%s", length(.cases), .mode, .out))
.res <- kitRun(.cases, .out, mode=.mode,
               nSub=as.integer(.opt("nsub", 20L)),
               seed=as.integer(.opt("seed", 42L)),
               est=.opt("est", "full"), nmfe=.nmfe,
               jobs=as.integer(.opt("jobs", 1L)),
               timeout=as.numeric(.opt("timeout", 3600)))
.counts <- kitReport(.res, .out)
message(paste(paste0(names(.counts), ": ", .counts), collapse=" | "))
message("summary: ", file.path(.out, "summary.md"))
quit(status=if (.counts[["FAIL"]] + .counts[["ERROR"]] > 0) 1 else 0)
