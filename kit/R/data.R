## NONMEM-style dataset builders.
##
## Every builder returns a data.frame with the standard NONMEM columns
## (ID TIME AMT RATE EVID CMT SS II ADDL DV MDV) so rows can be stacked
## and simulated directly with rxode2 (which understands NONMEM event
## coding) and then written for NONMEM.

.nmCols <- c("ID", "TIME", "AMT", "RATE", "EVID", "CMT", "SS", "II",
             "ADDL", "DV", "MDV")

## Rows are subject-major (all times of the first ID, then the next).
## Value arguments may have length 1, one value per row, one per ID
## (`length(id)`), or one per time (`length(time)`); per-ID wins when
## the two lengths are equal.
.grid <- function(id, time) expand.grid(TIME=time, ID=id)[, c("ID", "TIME")]

.perRow <- function(x, g, id, time) {
  .n <- nrow(g)
  if (length(x) == 1L || length(x) == .n) return(rep_len(x, .n))
  if (length(x) == length(id)) return(x[match(g$ID, id)])
  if (length(x) == length(time)) return(x[match(g$TIME, time)])
  stop("argument length ", length(x), " matches neither rows, IDs nor times",
       call.=FALSE)
}

nmDose <- function(id, time=0, amt=100, cmt=1L, rate=0, ss=0L, ii=0,
                   addl=0L, evid=1L, ...) {
  .d <- .grid(id, time)
  .p <- function(x) .perRow(x, .d, id, time)
  .ret <- data.frame(ID=.d$ID, TIME=.d$TIME,
                     AMT=.p(amt), RATE=.p(rate), EVID=.p(evid), CMT=.p(cmt),
                     SS=.p(ss), II=.p(ii), ADDL=.p(addl), DV=0, MDV=1L)
  .extra(.ret, lapply(list(...), .p))
}

nmObs <- function(id, time, cmt=2L, mdv=0L, evid=0L, ...) {
  .d <- .grid(id, time)
  .p <- function(x) .perRow(x, .d, id, time)
  .ret <- data.frame(ID=.d$ID, TIME=.d$TIME, AMT=0, RATE=0,
                     EVID=.p(evid), CMT=.p(cmt),
                     SS=0L, II=0, ADDL=0L, DV=0, MDV=.p(mdv))
  .extra(.ret, lapply(list(...), .p))
}

## Non-dose, non-observation events (EVID=2 "other", EVID=3 reset,
## EVID=4 reset+dose is a dose so use nmDose(evid=4)).
nmOther <- function(id, time, cmt=2L, evid=2L, ...) {
  .ret <- nmObs(id, time, cmt=cmt, mdv=1L, evid=evid, ...)
  .ret
}

.extra <- function(d, extra) {
  for (.n in names(extra)) d[[.n]] <- rep_len(extra[[.n]], nrow(d))
  d
}

## Stack rows, sort by ID then TIME keeping input order for ties (so a
## dose listed before an observation at the same time stays first), and
## optionally attach per-subject covariates.
nmBind <- function(..., cov=NULL, sort=TRUE) {
  .l <- list(...)
  .all <- unique(unlist(lapply(.l, names)))
  .l <- lapply(.l, function(d) {
    for (.n in setdiff(.all, names(d))) d[[.n]] <- 0
    d[, .all]
  })
  .d <- do.call(rbind, .l)
  if (sort) .d <- .d[order(.d$ID, .d$TIME, seq_len(nrow(.d))), ]
  if (!is.null(cov)) {
    .m <- match(.d$ID, cov$ID)
    for (.n in setdiff(names(cov), "ID")) .d[[.n]] <- cov[[.n]][.m]
  }
  rownames(.d) <- NULL
  .d
}

## Per-subject covariate table: named list of functions(n) or vectors.
nmCov <- function(nSub, ...) {
  .l <- list(...)
  .ret <- data.frame(ID=seq_len(nSub))
  for (.n in names(.l)) {
    .v <- .l[[.n]]
    .ret[[.n]] <- if (is.function(.v)) .v(nSub) else rep_len(.v, nSub)
  }
  .ret
}

## Common sampling grid helpers
pkTimes <- function(tmax=24) {
  .t <- c(0.25, 0.5, 1, 1.5, 2, 3, 4, 6, 8, 12, 16, 24, 36, 48, 72)
  .t[.t <= tmax]
}
