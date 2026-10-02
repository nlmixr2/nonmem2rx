## $INPUT / $DATA edge cases.  The model is a plain one-compartment
## oral model; what varies is how the data file is written and read.
## Junk rows that must be filtered out carry doses that would change
## the predictions (and ROWIDs that are not simulated), so the dry run
## catches any filtering mistake.

.simOral1 <- function() {
  ini({
    tcl <- 3; tv <- 30; tka <- 1.2
    eta.cl ~ 0.09; eta.v ~ 0.04
    prop.sd <- 0.1
  })
  model({
    cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v); ka <- tka
    d/dt(depot) <- -ka * depot
    d/dt(central) <- ka * depot - cl / v * central
    ipred <- central / v
    ipred ~ prop(prop.sd)
  })
}

.dataOral1 <- function(nSub) {
  .id <- seq_len(nSub)
  nmBind(nmDose(.id, 0, amt=100, cmt=1, addl=1, ii=24),
         nmObs(.id, c(0.5, 1, 2, 4, 8, 12, 23.5, 26, 30, 36, 48), cmt=2))
}

.oral1Ctl <- function(data="IGNORE=@", time="TIME", dv="DV", extra="") {
  paste0("$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} ", data, "
$SUBROUTINES ADVAN2 TRANS2
$PK
  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)
  S2 = V", extra, "
$ERROR
  IPRED = F
  W = THETA(4)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (", dv, " - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 1.2) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")
}

## data.frame -> csv lines (no quoting, "." for NA)
.csvLines <- function(d, header=TRUE, prefix="") {
  .f <- vapply(d, function(x) {
    if (is.numeric(x)) {
      .r <- format(signif(x, 8), scientific=FALSE, trim=TRUE, drop0trailing=TRUE)
      .r[is.na(x)] <- "."
      .r
    } else as.character(x)
  }, character(nrow(d)))
  if (!is.matrix(.f)) .f <- matrix(.f, nrow=nrow(d))
  c(if (header) paste0(prefix, paste(names(d), collapse=",")),
    apply(.f, 1, paste, collapse=","))
}

## Junk dose rows (one per subject) placed before the first observation
.junkDoses <- function(d, ...) {
  .j <- nmDose(unique(d$ID), 0.75, amt=5000, cmt=2)
  .j$ROWID <- 1e6 + seq_len(nrow(.j))
  for (.n in setdiff(names(d), names(.j))) .j[[.n]] <- 0
  .j <- .extra(.j, list(...))
  .j[, names(d)]
}

.insertSorted <- function(d, j) {
  .all <- rbind(d, j)
  .all[order(.all$ID, .all$TIME, .all$ROWID > 1e6), ]
}

kitCase(
  name="input-alias-drop-skip",
  covers="$INPUT synonyms on both sides (TAFD=TIME, CONC=DV) used in code, DROP/SKIP of character columns, '.' DV on dose rows",
  tags=c("data", "input", "alias", "drop"),
  sim=.simOral1, data=.dataOral1,
  write=function(d) {
    d$DV[d$EVID != 0] <- NA
    d$STUDY <- sprintf("ST-%02d", (d$ID %% 3) + 1)
    d$NOTE <- ifelse(d$EVID == 1, "dose_record", "sample")
    names(d)[names(d) == "DV"] <- "CONC"
    names(d)[names(d) == "TIME"] <- "TAFD"
    d
  },
  input="ID TAFD=TIME AMT RATE EVID CMT SS II ADDL CONC=DV MDV ROWID STUDY=DROP NOTE=SKIP",
  ctl=.oral1Ctl(dv="CONC", extra="\n  IF (TAFD .LT. 0) EXIT 1 1"))

kitCase(
  name="ignore-hash-and-list",
  covers="IGNORE=# header/comment lines together with IGNORE=(FLAG.EQ.1) and IGNORE=(AMT.GT.1000) filters",
  tags=c("data", "ignore"),
  sim=.simOral1, data=.dataOral1,
  write=function(d) {
    d$FLAG <- 0
    .j <- .junkDoses(d, FLAG=1)
    .j$AMT[seq(2, nrow(.j), by=2)] <- 2000
    .j$FLAG[seq(2, nrow(.j), by=2)] <- 0
    .l <- .csvLines(.insertSorted(d, .j), prefix="#")
    c(.l[1], "# this comment line must be skipped", .l[-1])
  },
  ctl=.oral1Ctl(data="IGNORE=# IGNORE=(FLAG.EQ.1,AMT.GT.1000)"))

kitCase(
  name="ignore-c-column",
  covers="Leading C column with IGNORE=C (Bauer-style commented records) including the header",
  tags=c("data", "ignore"),
  sim=.simOral1, data=.dataOral1,
  write=function(d) {
    .j <- .junkDoses(d)
    .all <- .insertSorted(d, .j)
    .all <- cbind(C=ifelse(.all$ROWID > 1e6, "C", "."), .all)
    .csvLines(.all)
  },
  input="C ID TIME AMT RATE EVID CMT SS II ADDL DV MDV ROWID",
  ctl=.oral1Ctl(data="IGNORE=C"))

kitCase(
  name="accept-filter",
  covers="ACCEPT=(STUDY.EQ.1) keeping only one study's records (with IGNORE=@ header)",
  tags=c("data", "accept"),
  sim=.simOral1, data=.dataOral1,
  write=function(d) {
    d$STUDY <- 1
    .insertSorted(d, .junkDoses(d, STUDY=2))
  },
  ctl=.oral1Ctl(data="IGNORE=@ ACCEPT=(STUDY.EQ.1)"))

kitCase(
  name="records-limit",
  covers="RECORDS=n reading only the first n data records; trailing records belong to a junk subject",
  tags=c("data", "records"),
  sim=.simOral1, data=.dataOral1,
  write=function(d) {
    .j <- nmBind(nmDose(999, 0, amt=1e4, cmt=1), nmObs(999, c(1, 2), cmt=2))
    .j$ROWID <- 1e6 + seq_len(nrow(.j))
    rbind(d, .j[, names(d)])
  },
  ctl=.oral1Ctl(data="IGNORE=@ RECORDS={{NSIM}}"))

## Clock times and calendar dates: simulate on a numeric hour scale and
## write DATE + HH:MM so NM-TRAN (and nonmem2rx) reconstruct TIME.
.clockWrite <- function(dateLabel, fmt) {
  function(d) {
    .start <- as.POSIXct("2024-02-27 08:00", tz="UTC") +
      (d$ID %% 4) * 86400 + (d$ID %% 7) * 420
    .t <- .start + round(d$TIME * 3600)
    .out <- d
    .out$TIME <- format(.t, "%H:%M")
    .out[[dateLabel]] <- format(.t, fmt)
    .out[, c("ID", dateLabel, setdiff(names(d), "ID"))]
  }
}

kitCase(
  name="clock-time-date",
  covers="Clock times (HH:MM) with DATE=DROP (MM/DD/YYYY), crossing midnight and Feb 29",
  tags=c("data", "clock-time", "date"),
  sim=.simOral1, data=.dataOral1,
  write=.clockWrite("DATE", "%m/%d/%Y"),
  input="ID DATE=DROP TIME AMT RATE EVID CMT SS II ADDL DV MDV ROWID",
  ctl=.oral1Ctl())

kitCase(
  name="clock-time-dat1",
  covers="Clock times with DAT1 (DD/MM/YYYY) day-first dates",
  tags=c("data", "clock-time", "date"),
  sim=.simOral1, data=.dataOral1,
  write=.clockWrite("DAT1", "%d/%m/%Y"),
  input="ID DAT1=DROP TIME AMT RATE EVID CMT SS II ADDL DV MDV ROWID",
  ctl=.oral1Ctl())

kitCase(
  name="translate-time-days",
  covers="$DATA TRANSLATE=(TIME/24/4 II/24/4): file in hours, model in days (NONMEM 7.5+)",
  tags=c("data", "translate", "nm75"),
  sim=function() {
    ini({
      tcl <- 72; tv <- 30; tka <- 28.8
      eta.cl ~ 0.09; eta.v ~ 0.04
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v); ka <- tka
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1, addl=1, ii=1),
           nmObs(.id, c(0.0125, 0.025, 0.05, 0.1, 0.25, 0.5, 0.9, 1.1, 1.5, 2), cmt=2))
  },
  write=function(d) {
    d$TIME <- d$TIME * 24
    d$II <- d$II * 24
    d
  },
  ctl=sub("THETA (0, 3) (0, 30) (0, 1.2)", "THETA (0, 72) (0, 30) (0, 28.8)",
          .oral1Ctl(data="IGNORE=@ TRANSLATE=(TIME/24/4 II/24/4)"), fixed=TRUE))

kitCase(
  name="repeated-nonmonotone-ids",
  covers="Non-monotone ID values reused by non-contiguous individuals (10, 2, 7, 10, 2, ...)",
  tags=c("data", "id"),
  knownFull="PRED validation (R/validate.R) solves nonmemData with raw NONMEM IDs, merging reused IDs into one subject; the IPRED path converts with fromNonmemToRxId()",
  sim=.simOral1, data=.dataOral1,
  write=function(d) {
    d$ID <- c(10, 2, 7)[((d$ID - 1) %% 3) + 1]
    d
  },
  ctl=.oral1Ctl())

kitCase(
  name="lowercase-input",
  covers="Lower-case $INPUT labels (id time amt dv ...) with upper-case abbreviated code",
  tags=c("data", "input", "case"),
  sim=.simOral1, data=.dataOral1,
  write=function(d) {
    names(d) <- tolower(names(d))
    names(d)[names(d) == "rowid"] <- "ROWID"
    d
  },
  ctl=.oral1Ctl())

kitCase(
  name="reserved-columns",
  covers="Data columns that are reserved in rxode2 (DUR informational, SIM replicate, TAD) next to fixed-RATE infusions",
  tags=c("data", "reserved", "infusion"),
  sim=function() {
    ini({
      tcl <- 2; tv <- 20; prop.sd <- 0.1
      eta.cl ~ 0.09; eta.v ~ 0.04
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v)
      d/dt(central) <- -cl / v * central
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    .d <- nmBind(nmDose(.id, c(0, 12), amt=100, cmt=1, rate=50),
                 nmObs(.id, c(1, 2.5, 4, 8, 11.9, 13, 16, 24), cmt=1))
    .d$SIM <- 1
    .d$TAD <- .d$TIME %% 12
    .d
  },
  write=function(d) {
    d$DUR <- 7.5   # a planned duration that must NOT be used as dur()
    d
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN1 TRANS2
$PK
  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  S1 = V
$ERROR
  IPRED = F
  W = THETA(3)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 2) (0, 20) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="dvid-no-cmt",
  covers="Parent + metabolite endpoints selected by DVID with no CMT column (doses to DEFDOSE)",
  tags=c("data", "dvid", "multiple-endpoints", "ode"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2; tclm <- 5; tvm <- 50; tfm <- 0.6
      eta.cl ~ 0.09; eta.clm ~ 0.09
      prop.sd <- 0.1; prop.sd.m <- 0.15
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv; ka <- tka
      clm <- tclm * exp(eta.clm); vm <- tvm
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      d/dt(metab) <- tfm * cl / v * central - clm / vm * metab
      cp <- central / v
      cm <- metab / vm
      cp ~ prop(prop.sd)
      cm ~ prop(prop.sd.m)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1, DVID=0),
           nmObs(.id, pkTimes(48), cmt=2, DVID=1),
           nmObs(.id, c(1.1, 2.1, 4.1, 8.1, 12.1, 24.1, 48.1), cmt=3, DVID=2))
  },
  write=function(d) {
    d$CMT <- NULL
    d
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN13 TOL=10 ATOL=12
$MODEL COMP=(DEPOT,DEFDOSE) COMP=(CENTRAL,DEFOBS) COMP=(METAB)
$PK
  CL  = THETA(1)*EXP(ETA(1))
  V   = THETA(2)
  KA  = THETA(3)
  CLM = THETA(4)*EXP(ETA(2))
  VM  = THETA(5)
  FM  = THETA(6)
$DES
  DADT(1) = -KA*A(1)
  DADT(2) = KA*A(1) - CL/V*A(2)
  DADT(3) = FM*CL/V*A(2) - CLM/VM*A(3)
$ERROR
  IPRED = A(2)/V
  W = THETA(7)*IPRED
  IF (DVID .EQ. 2) THEN
    IPRED = A(3)/VM
    W = THETA(8)*IPRED
  ENDIF
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 1.2) (0, 5) (0, 50) (0, 0.6, 1) (0, 0.1) (0, 0.15)
$OMEGA 0.09 0.09
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")
