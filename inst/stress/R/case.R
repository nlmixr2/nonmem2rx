## Case registry for the nonmem2rx round-trip kit.
##
## A case is one "simulate -> NONMEM -> nonmem2rx" round trip.  Each case
## supplies:
##
## - `sim`: an rxode2 ui function used to simulate the observations.
##   Its `ini()` values are the "true" values; the control stream should
##   use the same values as initial estimates so the dry-run check (no
##   NONMEM) can compare population predictions exactly.
##
## - `data`: function(nSub) returning a NONMEM-style data.frame (use the
##   builders in data.R).  Rows are simulated in order; a `ROWID` column
##   is added automatically and used to match rows after filtering.
##
## - `ctl`: the control stream text.  Placeholders:
##     {{PROBLEM}} case name/description
##     {{INPUT}}   $INPUT column list (from the written data)
##     {{DATA}}    data file name (data.csv)
##     {{EST}}     estimation records (see .kitEst())
##     {{TABLE}}   standard validation tables (see .kitTable())
##     {{NSIM}}    number of simulated data records (e.g. for RECORDS=)
##
## Optional hooks:
##
## - `write`: function(d) -> data.frame or character lines to write as
##   the NONMEM data file.  Use this for things rxode2 cannot simulate
##   directly (clock times, comment rows to IGNORE, character columns,
##   aliased column names ...).  By default `d` is written as csv.
## - `input`: explicit $INPUT string (otherwise column names written).
## - `pred`: c(sim=) the simulation-model column compared with the
##   translated model's prediction (`sim`, or `y` when nonmem2rx found
##   no error model) in the dry run; defaults to the endpoint
##   prediction c(sim="sim") evaluated with all random effects zero.
## - `postSim`: function(d, s) -> d where `s` is the rxode2 solve
##   (obs rows, keyed by ROWID) for custom DV handling.
## - `tol`: list of thresholds overriding the defaults: dry, ipred, pred,
##   ipredQ95, predQ95 (percent), iwres (absolute), validate (logical);
##   see .kitTolDefault in import.R.
## - `known`: character; marks a known/expected failure (reported XFAIL).
## - `knownFull`: like `known` but only for full/import mode (problems in
##   nonmem2rx's validation against NONMEM output).
## - `est`: "default" uses the run-wide estimation records; any other
##   string is used verbatim as the estimation records.
## - `sigma`: expected imported $SIGMA matrix (checked in the dry run);
##   the imported $OMEGA is always checked against the simulation's
##   omega, so etas must be declared in ETA() order in `sim`.
## - `nmfeArgs`: extra arguments for the NONMEM command, added after the
##   control stream and listing (e.g. "-dde" for ADVAN16/18 delay models).
## - `dryRows`: function(simData) -> logical; observation rows used in
##   the dry PRED comparison (e.g. exclude censored M3 rows).
## - `dryPred`: FALSE to skip the NONMEM-free PRED comparison (e.g. when
##   the NONMEM model is not expressible exactly in the sim model).

.kitEnv <- new.env(parent=emptyenv())
.kitEnv$cases <- list()

kitCase <- function(name, covers, tags=character(0), sim, data, ctl,
                    write=NULL, input=NULL, pred=c(sim="sim"),
                    postSim=NULL, tol=list(), known=NULL,
                    est="default", dryPred=TRUE, nSub=NULL, sigma=NULL,
                    dryOmega=TRUE, dryRows=NULL, knownFull=NULL,
                    nmfeArgs=NULL) {
  stopifnot(is.character(name), length(name) == 1L,
            !grepl("[^A-Za-z0-9_-]", name))
  if (!is.null(.kitEnv$cases[[name]])) {
    stop("duplicate kit case name: ", name, call.=FALSE)
  }
  .kitEnv$cases[[name]] <- list(name=name, covers=covers, tags=tags,
                                sim=sim, data=data, ctl=ctl, write=write,
                                input=input, pred=pred,
                                postSim=postSim, tol=tol, known=known,
                                est=est, dryPred=dryPred, nSub=nSub,
                                sigma=sigma, dryOmega=dryOmega,
                                dryRows=dryRows, knownFull=knownFull,
                                nmfeArgs=nmfeArgs,
                                file=.kitEnv$curFile)
  invisible(name)
}

kitLoadCases <- function(dir) {
  .kitEnv$cases <- list()
  for (.f in sort(list.files(dir, pattern="[.][Rr]$", full.names=TRUE))) {
    .kitEnv$curFile <- basename(.f)
    sys.source(.f, envir=environment(kitCase))
  }
  .kitEnv$curFile <- NULL
  invisible(names(.kitEnv$cases))
}

kitCases <- function(names=NULL, tags=NULL) {
  .c <- .kitEnv$cases
  if (!is.null(names)) {
    .bad <- setdiff(names, base::names(.c))
    if (length(.bad) > 0) stop("unknown kit case(s): ",
                               paste(.bad, collapse=", "), call.=FALSE)
    .c <- .c[names]
  }
  if (!is.null(tags)) {
    .c <- .c[vapply(.c, function(x) any(tags %in% x$tags), logical(1))]
  }
  .c
}

kitList <- function() {
  .c <- .kitEnv$cases
  data.frame(name=base::names(.c),
             tags=vapply(.c, function(x) paste(x$tags, collapse=","), ""),
             known=vapply(.c, function(x) !is.null(x$known), NA),
             covers=vapply(.c, function(x) x$covers, ""),
             row.names=NULL)
}

## Register a variant of an existing case, overriding some fields
## (e.g. the same simulation with a different control stream).
kitVariant <- function(base, name, covers, ..., known=NULL, knownFull=NULL) {
  .c <- .kitEnv$cases[[base]]
  if (is.null(.c)) stop("unknown base case: ", base, call.=FALSE)
  .c$name <- name
  .c$covers <- covers
  .c$known <- known
  .c$knownFull <- knownFull
  .over <- list(...)
  .c[names(.over)] <- .over
  .c$file <- NULL
  do.call(kitCase, .c)
}
