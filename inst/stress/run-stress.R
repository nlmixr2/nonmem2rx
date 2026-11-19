#!/usr/bin/env Rscript
# nonmem2rx stress kit runner: rxode2 simulation -> NONMEM -> nonmem2rx.
#
# The same as stressCheck(), stressList() and stressKit() from an R
# session (like RStudio) after sourcing stress.R; see README.md in this
# directory.
#
# Usage:
#   Rscript run-stress.R [options]
#
# Options:
#   --kit                     everything for a NONMEM machine: run every
#                             case with the NONMEM that is found and zip
#                             the output (--bundle)
#   --check                   report the versions and whether NONMEM is
#                             found, then exit
#   --list                    list the cases and exit
#   --mode=translate|run      translate: write the control streams/data
#                             and check the translation (no NONMEM)
#                             run: also run NONMEM and import the output
#                             (default: translate; run with --kit)
#   --nonmem=COMMAND          command that runs NONMEM, like nmfe75
#                             (default: option nonmem2rx.nonmem, then
#                             babelmixr2.nonmem, then an nmfe7* found on
#                             the PATH or in the usual install directories)
#   --cases=REGEX             only the cases whose name matches REGEX
#   --tags=t1,t2              only the cases with any of these tags
#   --est=full|posthoc        default estimation records (default: full)
#   --nsub=N                  subjects per case (default: 20)
#   --jobs=N                  cases run in parallel (default: 1)
#   --timeout=SECONDS         NONMEM timeout per case (default: 3600)
#   --out=DIR                 output directory (default:
#                             nonmem2rx-stress-YYYYMMDD-HHMMSS)
#   --bundle                  zip the output directory to send back
#   --replay=ZIP              re-import a returned zip (no NONMEM)
#   --installed               use the installed nonmem2rx, not the source
#                             tree the kit is in
#
# The exit status is 1 when any case is FAIL or ERROR.

.args <- commandArgs(trailingOnly=TRUE)
.opt <- function(name, default=NULL) {
  .w <- which(grepl(paste0("^--", name, "(=|$)"), .args))
  if (length(.w) == 0L) return(default)
  .a <- .args[.w[1]]
  if (grepl("=", .a)) return(sub(paste0("^--", name, "="), "", .a))
  ## also accept "--name value"
  if (.w[1] < length(.args) && !startsWith(.args[.w[1] + 1], "--")) {
    return(.args[.w[1] + 1])
  }
  TRUE
}
.split <- function(x) if (is.null(x)) NULL else strsplit(x, ",")[[1]]

.stressDir <- local({
  .f <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value=TRUE))
  if (length(.f) == 1) dirname(normalizePath(.f)) else "inst/stress"
})

# stress.R uses an already-loaded nonmem2rx, so load the installed one
# first when asked
if (isTRUE(.opt("installed"))) suppressMessages(library(nonmem2rx))
source(file.path(.stressDir, "stress.R"))

if (isTRUE(.opt("check"))) {
  stressCheck(nonmem=.opt("nonmem"))
  quit(status=0)
}
if (isTRUE(.opt("list"))) {
  stressList(cases=.opt("cases"), tags=.split(.opt("tags")))
  quit(status=0)
}

.replay <- .opt("replay")
if (!is.null(.replay)) {
  .res <- stressReplay(.replay, cases=.opt("cases"),
                       jobs=as.integer(.opt("jobs", 1L)))
} else {
  .kit <- isTRUE(.opt("kit"))
  .mode <- .opt("mode", if (.kit) "run" else "translate")
  .args2 <- list(nonmem=.opt("nonmem"),
                 modes=if (.mode == "run") c("translate", "run") else "translate",
                 cases=.opt("cases"), tags=.split(.opt("tags")),
                 est=.opt("est", "full"), nSub=as.integer(.opt("nsub", 20L)),
                 jobs=as.integer(.opt("jobs", 1L)),
                 timeout=as.numeric(.opt("timeout", 3600)),
                 bundle=.kit || isTRUE(.opt("bundle")))
  if (!is.null(.opt("out"))) .args2$out <- .opt("out")
  .res <- do.call(stressKit, .args2)
}
.counts <- attr(.res, "counts")
quit(status=if (.counts[["FAIL"]] + .counts[["ERROR"]] > 0) 1 else 0)
