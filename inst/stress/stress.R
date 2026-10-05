## Load the nonmem2rx round-trip kit into an R session:
##
##   source("kit/kit.R")
##   kitList()                                   # the cases
##   res <- runKit(mode="dry", jobs=8)           # no NONMEM needed
##   res <- runKit(mode="full", nmfe="nmfe75 {ctl} {lst}", tags="dosing")
##
## The kit's functions live in an attached "nmkit" environment, so they do
## not clutter the global environment; re-sourcing replaces it.
##
## nonmem2rx: if it is already loaded (library() or devtools::load_all())
## that version is used.  Otherwise the kit loads the source tree it sits
## in with devtools::load_all(), or the installed package when the kit is
## not inside a nonmem2rx source tree.

local({
  .kitDir <- tryCatch(dirname(normalizePath(sys.frame(1)$ofile)),
                      error=function(e) NULL)
  if (is.null(.kitDir)) {
    .kitDir <- if (dir.exists("kit/cases")) normalizePath("kit") else
      stop("source kit/kit.R with source(); could not find the kit directory",
           call.=FALSE)
  }
  .pkgDir <- dirname(.kitDir)
  .desc <- file.path(.pkgDir, "DESCRIPTION")
  .inSource <- file.exists(.desc) &&
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
  ## kit/mock/fake-nonmem.R loads the same nonmem2rx in its own process
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

  if ("nmkit" %in% search()) detach("nmkit", character.only=TRUE)
  .env <- new.env()
  for (.f in list.files(file.path(.kitDir, "R"), pattern="[.][Rr]$",
                        full.names=TRUE)) {
    sys.source(.f, envir=.env)
  }
  .env$.kitDir <- .kitDir
  .env$kitLoadCases(file.path(.kitDir, "cases"))
  attach(.env, name="nmkit", warn.conflicts=FALSE)
  message(sprintf("nonmem2rx kit: %d cases loaded; see runKit() and kitList()",
                  length(.env$.kitEnv$cases)))
})
