## runKit(): the lower-level runner behind stressKit() (see stress.R and README.md)

#' Run the nonmem2rx round-trip kit
#'
#' @param mode "dry" (no NONMEM), "full" (run NONMEM) or "import"
#'   (re-import NONMEM output already in `out`)
#' @param cases character vector of case names (NULL = all)
#' @param tags character vector of tags; cases with any of them are run
#' @param nmfe NONMEM command template with `{ctl}` and `{lst}`, e.g.
#'   "nmfe75 {ctl} {lst}"; defaults to the NMKIT_NMFE environment variable
#' @param est default estimation records: "full" (FOCE-I + $COV) or
#'   "posthoc" (MAXEVAL=0 POSTHOC at the true values)
#' @param nSub subjects per case
#' @param seed base seed (each case derives a stable seed from its name)
#' @param jobs cases run in parallel (forked; 1 on Windows)
#' @param out output directory
#' @param timeout NONMEM timeout per case (seconds)
#' @return data.frame with one row per case (invisibly); summary.md and
#'   summary.csv are written to `out`
runKit <- function(mode=c("dry", "full", "import"), cases=NULL, tags=NULL,
                   nmfe=Sys.getenv("NMKIT_NMFE", ""), est=c("full", "posthoc"),
                   nSub=20L, seed=42L, jobs=1L, out="kit-runs", timeout=3600) {
  mode <- match.arg(mode)
  est <- match.arg(est)
  if (is.null(nmfe) || !nzchar(nmfe)) nmfe <- NULL
  if (mode == "full" && is.null(nmfe)) {
    stop("mode=\"full\" needs nmfe=\"nmfe75 {ctl} {lst}\" (or NMKIT_NMFE)",
         call.=FALSE)
  }
  .cases <- kitCases(names=cases, tags=tags)
  if (length(.cases) == 0L) stop("no kit cases selected", call.=FALSE)
  out <- normalizePath(out, mustWork=FALSE)
  ## the solves are single threaded; restore the session's settings
  .rxThreads <- rxode2::getRxThreads()
  .dtThreads <- data.table::getDTthreads()
  on.exit({
    rxode2::setRxThreads(.rxThreads)
    data.table::setDTthreads(.dtThreads)
  }, add=TRUE)
  rxode2::setRxThreads(1L)
  data.table::setDTthreads(1L)
  message(sprintf("nonmem2rx kit: %d case(s), mode=%s, out=%s",
                  length(.cases), mode, out))
  .res <- kitRun(.cases, out, mode=mode, nSub=as.integer(nSub),
                 seed=as.integer(seed), est=est, nmfe=nmfe,
                 jobs=as.integer(jobs), timeout=as.numeric(timeout))
  .counts <- kitReport(.res, out)
  message(paste(paste0(names(.counts), ": ", .counts), collapse=" | "))
  message("summary: ", file.path(out, "summary.md"))
  attr(.res, "counts") <- .counts
  invisible(.res)
}
