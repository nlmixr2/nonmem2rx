## Control stream generation and NONMEM execution.

.kitEst <- function(est) {
  switch(est,
         full=paste("$EST METHOD=1 INTER MAXEVAL=9999 PRINT=5 NOABORT",
                    "$COV PRINT=E UNCONDITIONAL", sep="\n"),
         posthoc="$EST METHOD=1 INTER MAXEVAL=0 POSTHOC NOABORT",
         stop("unknown estimation mode: ", est, call.=FALSE))
}

.kitTable <- function() {
  paste("$TABLE ID TIME EVID ROWID IPRED IWRES ONEHEADER NOPRINT FILE=run.tab",
        "$TABLE ID ETAS(1:LAST) FIRSTONLY ONEHEADER NOPRINT NOAPPEND FILE=run.eta",
        sep="\n")
}

kitWriteCtl <- function(case, input, file, est="full", nSim=NA_integer_) {
  .est <- if (identical(case$est, "default")) .kitEst(est) else case$est
  .ctl <- case$ctl
  .sub <- c(PROBLEM=gsub("$", "", paste(case$name, "-", case$covers), fixed=TRUE),
            INPUT=input, DATA="data.csv", EST=.est, TABLE=.kitTable(),
            NSIM=as.character(nSim))
  for (.n in names(.sub)) {
    .ctl <- gsub(paste0("{{", .n, "}}"), .sub[[.n]], .ctl, fixed=TRUE)
  }
  if (grepl("{{", .ctl, fixed=TRUE)) {
    stop("unexpanded placeholder in control stream for ", case$name,
         call.=FALSE)
  }
  writeLines(.ctl, file)
  invisible(file)
}

## Run NONMEM in `dir`.  `cmd` is a template; {ctl} and {lst} are
## replaced by the control stream and listing file names.  Examples:
##   "nmfe75 {ctl} {lst}"
##   "/opt/nm760/run/nmfe76 {ctl} {lst} -maxlim=2"
##   "execute {ctl} -directory=psn -clean=1"  (PsN; copy back yourself)
kitRunNonmem <- function(dir, cmd, ctl="run.ctl", lst="run.lst",
                         timeout=3600) {
  .cmd <- gsub("{ctl}", ctl, gsub("{lst}", lst, cmd, fixed=TRUE),
               fixed=TRUE)
  .old <- setwd(dir)
  on.exit(setwd(.old))
  .t0 <- Sys.time()
  unlink(lst)
  if (.Platform$OS.type == "windows") {
    ## nmfe7*.bat needs cmd.exe; Windows' own timeout.exe is not a limit
    .status <- suppressWarnings(shell(paste(.cmd, "> nonmem.log 2>&1"),
                                      wait=TRUE))
  } else {
    ## coreutils timeout kills NONMEM itself, not just the shell wrapper
    .to <- Sys.which("timeout")
    if (nzchar(.to)) .cmd <- paste(.to, "--kill-after=30", timeout, "sh -c", shQuote(.cmd))
    .status <- suppressWarnings(system(paste(.cmd, "> nonmem.log 2>&1"),
                                       timeout=if (nzchar(.to)) 0 else timeout))
  }
  ## NONMEM writes "Stop Time" as the very last thing it does
  .ok <- file.exists(lst) && any(grepl("Stop Time", readLines(lst, warn=FALSE)))
  .kitCleanNonmem()
  list(status=.status, ok=.ok, seconds=as.numeric(Sys.time() - .t0,
                                                  units="secs"))
}

## Remove NONMEM's build and scratch files (executable, compiled
## sources, temp_dir, data copies) from the current directory so the
## returned zip holds only the control stream, data and NONMEM output.
.kitCleanNonmem <- function() {
  unlink(c("temp_dir", "worker*"), recursive=TRUE)
  .f <- list.files(".", all.files=TRUE, no..=TRUE)
  .scratch <- grepl(paste0("^(nonmem|nonmem[.]exe|FDATA|FCON|FREPORT|FSIZES|FSTREAM|",
                           "FSUBS.*|FMSG|INTER|LINK[.]LNK|GFCOMPILE[.]BAT|trash.*|",
                           "fort[.].*|linkc[.]lnk|compile[.]lnk|nmprd4p[.]mod|",
                           "prsizes[.]f90|nmpathlist[.]txt|background[.]set|",
                           "locfile.*|.*[.](o|obj|f90|mod|exe|lib))$"), .f, ignore.case=TRUE)
  unlink(.f[.scratch])
  invisible()
}
## Why NONMEM stopped: NM-TRAN's error (message and the characters in
## error) or else the last line of nonmem.log
.kitNonmemError <- function(dir) {
  .read <- function(f) {
    f <- file.path(dir, f)
    if (file.exists(f)) readLines(f, warn=FALSE) else character(0)
  }
  .l <- c(.read("run.lst"), .read("nonmem.log"))
  .e <- grep("AN ERROR WAS FOUND", .l)
  if (length(.e) > 0L) {
    .tail <- .l[.e[1]:min(length(.l), .e[1] + 8L)]
    .chars <- trimws(sub(".*CHARACTERS IN ERROR ARE:", "",
                         grep("CHARACTERS IN ERROR ARE", .tail, value=TRUE)[1]))
    .msg <- trimws(grep("^ *[0-9]+ +[A-Z]", .tail, value=TRUE)[1])
    return(paste0("NM-TRAN ", if (is.na(.msg)) "error" else .msg,
                  if (!is.na(.chars)) paste0(" at '", .chars, "'")))
  }
  .l <- trimws(.read("nonmem.log"))
  .l <- .l[nzchar(.l)]
  if (length(.l) == 0L) return("no output (see nonmem.log)")
  substr(.l[length(.l)], 1, 160)
}
