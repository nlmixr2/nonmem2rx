## nonmem2rx stress kit: rxode2 simulation -> NONMEM -> nonmem2rx import.
##
## On the NONMEM machine, in a fresh R session (for example RStudio):
##
##   devtools::load_all("path/to/nonmem2rx")    # the version to test
##   source(system.file("stress", "stress.R", package = "nonmem2rx"))
##   stressCheck()                               # versions; is NONMEM found?
##   res <- stressKit()                          # or stressKit(nonmem = "nmfe75")
##
## stressKit() runs every case and zips the output
## (nonmem2rx-stress-<date>-<time>.zip) to send back.  Without NONMEM,
## stressKit(modes = "translate") checks the translations only.  Back
## home, stressReplay("<zip>") re-imports the returned NONMEM output.
## See README.md in this directory.
##
## The kit's functions live in an attached "nonmem2rx-stress" environment,
## so they do not clutter the global environment; sourcing again replaces
## it.  nonmem2rx: if it is already loaded (library() or
## devtools::load_all()) that version is used; otherwise the kit loads
## the source tree it sits in (inst/stress) or the installed package.

local({
  ## the innermost source() of this file (it may be sourced by another
  ## script, so the outermost frame is not necessarily this one)
  .kitDir <- NULL
  for (.fr in rev(sys.frames())) {
    .of <- tryCatch(get("ofile", envir=.fr, inherits=FALSE), error=function(e) NULL)
    if (is.character(.of) && basename(.of) == "stress.R") {
      .kitDir <- dirname(normalizePath(.of))
      break
    }
  }
  if (is.null(.kitDir)) {
    .kitDir <- if (dir.exists("inst/stress/cases")) normalizePath("inst/stress") else
      stop("load the kit with source(system.file(\"stress\", \"stress.R\", package=\"nonmem2rx\"))",
           call.=FALSE)
  }
  ## a source tree has the kit in <pkg>/inst/stress; an installed package
  ## has it in <lib>/nonmem2rx/stress
  .pkgDir <- dirname(dirname(.kitDir))
  .desc <- file.path(.pkgDir, "DESCRIPTION")
  .inSource <- basename(dirname(.kitDir)) == "inst" && file.exists(.desc) &&
    any(grepl("^Package: nonmem2rx$", readLines(.desc)))
  if (!"nonmem2rx" %in% loadedNamespaces()) {
    if (.inSource) {
      message("loading nonmem2rx from source: ", .pkgDir)
      suppressMessages(devtools::load_all(.pkgDir, quiet=TRUE))
    } else {
      suppressMessages(library(nonmem2rx))
    }
  }
  .ns <- asNamespace("nonmem2rx")
  .dev <- requireNamespace("pkgload", quietly=TRUE) &&
    pkgload::is_dev_package("nonmem2rx")
  ## mock/fake-nonmem.R loads the same nonmem2rx in its own process
  if (.dev) {
    Sys.setenv(NMKIT_PKGDIR=pkgload::pkg_path(getNamespaceInfo(.ns, "path")))
  } else {
    Sys.unsetenv("NMKIT_PKGDIR")
  }
  message(sprintf("nonmem2rx %s (%s); rxode2 %s",
                  getNamespaceVersion(.ns),
                  if (.dev) "source" else "installed",
                  utils::packageVersion("rxode2")))
  suppressMessages(requireNamespace("rxode2"))

  if ("nonmem2rx-stress" %in% search()) detach("nonmem2rx-stress", character.only=TRUE)
  .env <- new.env()
  for (.f in list.files(file.path(.kitDir, "R"), pattern="[.][Rr]$",
                        full.names=TRUE)) {
    sys.source(.f, envir=.env)
  }
  .env$.kitDir <- .kitDir
  .env$kitLoadCases(file.path(.kitDir, "cases"))
  attach(.env, name="nonmem2rx-stress", warn.conflicts=FALSE)
  message(sprintf("nonmem2rx stress kit: %d cases; see stressCheck(), stressList() and stressKit()",
                  length(.env$.kitEnv$cases)))
})
