## The kit for a NONMEM machine, matching babelmixr2's inst/stress kit:
## stressCheck(), stressList(), stressKit() and, back home, stressReplay().

#' Find the command that runs NONMEM
#'
#' @return the command (like "nmfe75" or its full path), or "" when
#'   NONMEM is not found
stressFindNonmem <- function() {
  for (.opt in c("nonmem2rx.nonmem", "babelmixr2.nonmem")) {
    .o <- getOption(.opt, "")
    if (is.character(.o) && nzchar(.o)) return(.o)
  }
  .w <- Sys.which(paste0("nmfe7", 9:0))
  .w <- .w[.w != ""]
  if (length(.w) > 0L) return(unname(.w[1]))
  .globs <- c("/opt/NONMEM/*/run/nmfe7*", "/opt/nm*/run/nmfe7*",
              "/usr/local/NONMEM/*/run/nmfe7*", "/usr/local/nm*/run/nmfe7*",
              "~/nm*/run/nmfe7*", "~/NONMEM/*/run/nmfe7*",
              "C:/nm*/run/nmfe7*.bat", "C:/NONMEM/*/run/nmfe7*.bat")
  .f <- Sys.glob(path.expand(.globs))
  .f <- .f[!grepl("\\.(f90|o|obj)$", .f) & file.exists(.f)]
  if (length(.f) == 0L) return("")
  sort(.f, decreasing=TRUE)[1] # newest NONMEM first
}

#' The kit's NONMEM command template from a NONMEM command
#'
#' @param nonmem "nmfe75", a full path, or a template with {ctl}/{lst}
#' @return template with {ctl} and {lst}
.stressNmfe <- function(nonmem) {
  if (grepl("{ctl}", nonmem, fixed=TRUE)) return(nonmem)
  if (grepl(" ", nonmem) && file.exists(nonmem)) nonmem <- shQuote(nonmem)
  paste(nonmem, "{ctl} {lst}")
}

#' Package versions for the report
#'
#' @return markdown list lines
stressVersions <- function() {
  .p <- c("nonmem2rx", "rxode2", "lotri", "dparser", "data.table")
  .v <- vapply(.p, function(p) {
    if (requireNamespace(p, quietly=TRUE)) as.character(utils::packageVersion(p)) else "-"
  }, character(1))
  ## which nonmem2rx: the git commit of a source tree, or RemoteSha
  .how <- ""
  .dir <- Sys.getenv("NMKIT_PKGDIR", "")
  if (nzchar(.dir)) {
    .sha <- suppressWarnings(tryCatch(
      system2("git", c("-C", shQuote(.dir), "rev-parse", "--short", "HEAD"),
              stdout=TRUE, stderr=FALSE), error=function(e) character(0)))
    .br <- suppressWarnings(tryCatch(
      system2("git", c("-C", shQuote(.dir), "rev-parse", "--abbrev-ref", "HEAD"),
              stdout=TRUE, stderr=FALSE), error=function(e) character(0)))
    .how <- paste0(" (source ", .dir,
                   if (length(.sha) == 1L) paste0("; ", .br, " ", .sha), ")")
  } else {
    .sha <- utils::packageDescription("nonmem2rx")$RemoteSha
    if (!is.null(.sha)) .how <- paste0(" (", substr(.sha, 1, 7), ")")
  }
  c(paste0("- ", .p, " ", .v, ifelse(.p == "nonmem2rx", .how, "")),
    paste0("- R ", getRversion(), " on ", R.version$platform))
}

#' Report the versions and whether NONMEM is found
#'
#' @param nonmem command that runs NONMEM (like "nmfe75" or its full
#'   path); NULL looks for it (see stressFindNonmem())
#' @return the NONMEM command ("" when not found), invisibly
stressCheck <- function(nonmem=NULL) {
  .nm <- if (is.null(nonmem)) stressFindNonmem() else nonmem
  message(paste(stressVersions(), collapse="\n"))
  message("- NONMEM: ", if (nzchar(.nm)) .nm else "not found (give it with nonmem=)")
  message("- cases: ", length(.kitEnv$cases))
  invisible(.nm)
}

#' Select cases by a regular expression of their names and/or tags
#'
#' @param cases regular expression of case names (NULL is all)
#' @param tags character vector of tags (cases with any of them)
#' @return list of cases
.stressSelect <- function(cases=NULL, tags=NULL) {
  .c <- kitCases(tags=tags)
  if (!is.null(cases)) .c <- .c[grepl(cases, names(.c))]
  .c
}

#' List the stress cases
#'
#' @inheritParams .stressSelect
#' @return data frame of the cases, invisibly
stressList <- function(cases=NULL, tags=NULL) {
  .c <- .stressSelect(cases, tags)
  .ret <- data.frame(
    case=names(.c),
    tags=vapply(.c, function(x) paste(x$tags, collapse=","), ""),
    known=vapply(.c, function(x) {
      if (!is.null(x$known)) "always" else if (!is.null(x$knownFull)) "run" else ""
    }, ""),
    description=vapply(.c, function(x) x$covers, ""),
    row.names=NULL, stringsAsFactors=FALSE)
  print(.ret, right=FALSE)
  invisible(.ret)
}

#' Zip the output directory to send back
#'
#' @param out output directory
#' @return the zip file, invisibly (NULL when zipping failed)
stressBundle <- function(out) {
  .zip <- paste0(out, ".zip")
  .ok <- withr::with_dir(dirname(out), {
    try(utils::zip(.zip, basename(out), flags="-r9Xq"), silent=TRUE)
  })
  if (inherits(.ok, "try-error") || !file.exists(.zip)) {
    message("could not zip the output; send the directory ", out, " instead")
    return(invisible(NULL))
  }
  message("send this file back: ", .zip)
  invisible(.zip)
}

#' Run the stress kit
#'
#' Simulates every case with rxode2, writes the NONMEM control stream and
#' data, checks the nonmem2rx translation, runs NONMEM, imports the run
#' with nonmem2rx and compares NONMEM's IPRED/PRED with rxode2.  Then zips
#' the output to send back.
#'
#' @param nonmem command that runs NONMEM (like "nmfe75", its full path,
#'   or a template with {ctl} and {lst}); NULL looks for it
#' @param modes "translate" (no NONMEM: the translation checks only)
#'   and/or "run" (also run NONMEM); "run" includes the translation checks
#' @param cases regular expression of the case names (NULL is all)
#' @param tags only the cases with any of these tags
#' @param out output directory
#' @param est default estimation records: "full" (FOCE-I + $COV) or
#'   "posthoc" (MAXEVAL=0 POSTHOC, much faster)
#' @param nSub subjects per case
#' @param jobs cases run in parallel (forked; 1 on Windows)
#' @param timeout NONMEM timeout per case (seconds; not on Windows)
#' @param bundle zip the output directory
#' @return data frame of the results (invisibly) with the attributes
#'   `out` (output directory) and `zip` (the zip file)
stressKit <- function(nonmem=NULL, modes=c("translate", "run"), cases=NULL,
                      tags=NULL,
                      out=paste0("nonmem2rx-stress-", format(Sys.time(), "%Y%m%d-%H%M%S")),
                      est=c("full", "posthoc"), nSub=20L, jobs=1L,
                      timeout=3600, bundle=TRUE) {
  modes <- match.arg(modes, c("translate", "run"), several.ok=TRUE)
  est <- match.arg(est)
  .nm <- if (is.null(nonmem)) stressFindNonmem() else nonmem
  .run <- "run" %in% modes
  if (.run && !nzchar(.nm)) {
    stop("NONMEM is not found; give it with nonmem= (like nonmem = \"nmfe75\"), ",
         "or use modes = \"translate\"", call.=FALSE)
  }
  .cases <- .stressSelect(cases, tags)
  if (length(.cases) == 0L) stop("no stress cases selected", call.=FALSE)
  dir.create(out, showWarnings=FALSE, recursive=TRUE)
  out <- normalizePath(out)
  writeLines(utils::capture.output(utils::sessionInfo()),
             file.path(out, "sessionInfo.txt"))
  message(paste(stressVersions(), collapse="\n"))
  if (.run) message("- NONMEM: ", .nm)
  .res <- runKit(mode=if (.run) "full" else "dry", cases=names(.cases),
                 nmfe=if (.run) .stressNmfe(.nm) else NULL, est=est,
                 nSub=nSub, jobs=jobs, out=out, timeout=timeout)
  utils::write.csv(.res, file.path(out, "results.csv"), row.names=FALSE)
  .md <- readLines(file.path(out, "summary.md"))
  .md <- append(.md, c("", "## Versions", "", stressVersions(),
                       if (.run) paste0("- NONMEM: ", .nm)), after=2L)
  writeLines(.md, file.path(out, "summary.md"))
  .bad <- .res[.res$status %in% c("FAIL", "ERROR", "XPASS"), , drop=FALSE]
  if (nrow(.bad) > 0L) {
    message("\nto look at:\n",
            paste(sprintf("  %-28s %-5s %s", .bad$case, .bad$status,
                          ifelse(is.na(.bad$note), "", substr(.bad$note, 1, 90))),
                  collapse="\n"))
  }
  attr(.res, "out") <- out
  attr(.res, "zip") <- if (bundle) stressBundle(out)
  invisible(.res)
}

#' Re-import a returned stress-kit zip (no NONMEM needed)
#'
#' Unzips the output of stressKit() and imports every case's NONMEM output
#' again with the nonmem2rx loaded in this session, for example after a
#' fix.  The control streams and data are the ones that were run, so no
#' simulation or NONMEM run happens.
#'
#' @param zip the zip file (or an unzipped output directory)
#' @param cases regular expression of the case names (NULL is all)
#' @param out directory to unzip into
#' @param jobs cases imported in parallel
#' @return data frame of the results, invisibly
stressReplay <- function(zip, cases=NULL, out=tempfile("nonmem2rx-replay-"),
                         jobs=1L) {
  if (dir.exists(zip)) {
    .dir <- normalizePath(zip)
  } else {
    dir.create(out, showWarnings=FALSE, recursive=TRUE)
    utils::unzip(zip, exdir=out)
    .top <- list.dirs(out, recursive=FALSE)
    .dir <- if (length(.top) == 1L) .top else out
  }
  .ran <- basename(list.dirs(.dir, recursive=FALSE))
  .ran <- .ran[file.exists(file.path(.dir, .ran, "run.lst"))]
  .known <- intersect(.ran, names(.kitEnv$cases))
  if (length(setdiff(.ran, .known)) > 0L) {
    message("not cases of this kit (skipped): ",
            paste(setdiff(.ran, .known), collapse=", "))
  }
  if (!is.null(cases)) .known <- .known[grepl(cases, .known)]
  if (length(.known) == 0L) stop("no NONMEM runs to replay in ", .dir, call.=FALSE)
  runKit(mode="import", cases=.known, out=.dir, jobs=jobs)
}
