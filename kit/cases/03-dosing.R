## Dosing and event-record edge cases.  Most of these have no explicit
## test in tests/testthat, so they are the main targets of the kit.

## One-compartment ADVAN1 control stream with a pluggable $PK body.
.advan1Ctl <- function(pk, theta, omega="0.09 0.04", sub="ADVAN1 TRANS2") {
  paste0("$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ", sub, "
$PK
", pk, "
$ERROR
  IPRED = F
  W = THETA(3)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 2) (0, 20) (0, 0.1) ", theta, "
$OMEGA ", omega, "
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")
}

kitCase(
  name="rate-minus1-modeled-rate",
  covers="RATE=-1 with modeled zero-order rate R1 (ETA on R1)",
  tags=c("dosing", "infusion", "modeled-rate"),
  sim=function() {
    ini({
      tcl <- 2; tv <- 20; prop.sd <- 0.1; tr1 <- 50
      eta.cl ~ 0.09; eta.v ~ 0.04; eta.r1 ~ 0.09
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v)
      d/dt(central) <- -cl / v * central
      rate(central) <- tr1 * exp(eta.r1)
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, c(0, 24), amt=200, cmt=1, rate=-1),
           nmObs(.id, c(0.5, 1, 2, 3, 3.9, 4.1, 6, 8, 12, 23.9, 25, 27, 30, 36, 48), cmt=1))
  },
  ctl=.advan1Ctl("  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  R1 = THETA(4)*EXP(ETA(3))
  S1 = V", theta="(0, 50)", omega="0.09 0.04 0.09"))

kitCase(
  name="rate-minus2-modeled-dur",
  covers="RATE=-2 with modeled duration D1 (ETA on D1)",
  tags=c("dosing", "infusion", "modeled-dur"),
  sim=function() {
    ini({
      tcl <- 2; tv <- 20; prop.sd <- 0.1; td1 <- 3
      eta.cl ~ 0.09; eta.v ~ 0.04; eta.d1 ~ 0.09
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v)
      d/dt(central) <- -cl / v * central
      dur(central) <- td1 * exp(eta.d1)
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, c(0, 24), amt=200, cmt=1, rate=-2),
           nmObs(.id, c(0.5, 1, 2, 2.9, 3.1, 4, 6, 8, 12, 23.9, 25, 27, 30, 36, 48), cmt=1))
  },
  ctl=.advan1Ctl("  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  D1 = THETA(4)*EXP(ETA(3))
  S1 = V", theta="(0, 3)", omega="0.09 0.04 0.09"))

kitCase(
  name="dur-with-lag",
  covers="RATE=-2 modeled duration combined with ALAG1 on the same compartment",
  tags=c("dosing", "infusion", "modeled-dur", "alag"),
  sim=function() {
    ini({
      tcl <- 2; tv <- 20; prop.sd <- 0.1; td1 <- 2; tlag <- 0.75
      eta.cl ~ 0.09; eta.v ~ 0.04
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v)
      d/dt(central) <- -cl / v * central
      dur(central) <- td1
      alag(central) <- tlag
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=200, cmt=1, rate=-2, addl=2, ii=12),
           nmObs(.id, c(0.5, 0.8, 1, 2, 2.7, 3, 4, 6, 12.5, 13, 14, 15, 24.5, 26, 30, 48), cmt=1))
  },
  ctl=.advan1Ctl("  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  D1 = THETA(4)
  ALAG1 = THETA(5)
  S1 = V", theta="(0, 2) (0, 0.75)"))

kitCase(
  name="infusion-bioav-fixed-rate",
  covers="F1 < 1 applied to a fixed-RATE infusion (NONMEM shortens the duration, rate unchanged)",
  tags=c("dosing", "infusion", "bioav"),
  sim=function() {
    ini({
      tcl <- 2; tv <- 20; prop.sd <- 0.1; tf <- 0.6
      eta.cl ~ 0.09; eta.v ~ 0.04
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v)
      d/dt(central) <- -cl / v * central
      f(central) <- tf
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=200, cmt=1, rate=50),
           nmObs(.id, c(0.5, 1, 2, 2.3, 2.5, 3, 3.9, 4.1, 6, 8, 12, 24), cmt=1))
  },
  ctl=.advan1Ctl("  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  F1 = THETA(4)
  S1 = V", theta="(0, 0.6, 1)"))

kitCase(
  name="infusion-with-lag",
  covers="ALAG1 applied to a fixed-RATE infusion",
  tags=c("dosing", "infusion", "alag"),
  sim=function() {
    ini({
      tcl <- 2; tv <- 20; prop.sd <- 0.1; tlag <- 1.5
      eta.cl ~ 0.09; eta.v ~ 0.04
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v)
      d/dt(central) <- -cl / v * central
      alag(central) <- tlag
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=200, cmt=1, rate=100),
           nmObs(.id, c(0.5, 1.4, 1.6, 2, 3, 3.4, 3.6, 4, 6, 8, 12, 24), cmt=1))
  },
  ctl=.advan1Ctl("  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  ALAG1 = THETA(4)
  S1 = V", theta="(0, 1.5)"))

kitCase(
  name="dual-absorption",
  covers="Same dose split into first-order depot (F1) and zero-order central input (RATE=-2, D2, F2=1-F1)",
  tags=c("dosing", "bioav", "modeled-dur", "advan2", "ties"),
  known="by design: rxode2 sorts records tied in TIME, so nonmem2rx offsets the second dose by delta=1e-4 (.fixNonmemTies); expect small differences",
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 0.8; tfr <- 0.4; td2 <- 4
      eta.cl ~ 0.09; eta.v ~ 0.04
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v); ka <- tka
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      f(depot) <- tfr
      f(central) <- 1 - tfr
      dur(central) <- td2
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1),
           nmDose(.id, 0, amt=100, cmt=2, rate=-2),
           nmObs(.id, c(pkTimes(48), 3.9, 4.1), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)
  F1 = THETA(4)
  F2 = 1 - THETA(4)
  D2 = THETA(5)
  S2 = V
$ERROR
  IPRED = F
  W = THETA(6)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 0.8) (0, 0.4, 1) (0, 4) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="ss2-asymmetric-bid",
  covers="Asymmetric BID at steady state: SS=1 morning dose then SS=2 evening dose (superposition), both II=24",
  tags=c("dosing", "ss", "ss2", "advan2"),
  sim=function() {
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
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1, ss=1, ii=24),
           nmDose(.id, 8, amt=50, cmt=1, ss=2, ii=24),
           nmObs(.id, c(1, 2, 4, 7.9, 9, 10, 12, 16, 23.9, 30, 48), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)
  S2 = V
$ERROR
  IPRED = F
  W = THETA(4)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 1.2) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="ss-constant-infusion",
  covers="Steady-state constant infusion (SS=1, AMT=0, RATE>0, II=0) with a bolus on top later",
  tags=c("dosing", "ss", "infusion"),
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
    nmBind(nmDose(.id, 0, amt=0, cmt=1, rate=10, ss=1, ii=0),
           nmDose(.id, 12, amt=100, cmt=1),
           nmObs(.id, c(1, 6, 11.9, 12.5, 13, 16, 24, 36), cmt=1))
  },
  ctl=.advan1Ctl("  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  S1 = V", theta=""))

kitCase(
  name="ss-with-lag",
  covers="Steady state (SS=1) oral dosing with an absorption lag longer than a quarter of the interval",
  tags=c("dosing", "ss", "alag", "advan2"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.5; tlag <- 2.5
      eta.cl ~ 0.09; eta.v ~ 0.04
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v); ka <- tka
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      alag(depot) <- tlag
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1, ss=1, ii=8, addl=2),
           nmObs(.id, c(0.5, 1, 2, 2.4, 2.6, 3, 4, 6, 7.9, 10, 11, 14, 20, 30, 40), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)
  ALAG1 = THETA(4)
  S2 = V
$ERROR
  IPRED = F
  W = THETA(5)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 1.5) (0, 2.5) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="evid3-reset",
  covers="EVID=3 reset record between two dosing periods (ADDL in first period)",
  tags=c("dosing", "evid3", "reset"),
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
    nmBind(nmDose(.id, 0, amt=100, cmt=1, addl=1, ii=12),
           nmObs(.id, c(1, 6, 12.5, 18, 23), cmt=1),
           nmOther(.id, 24, cmt=1, evid=3),
           nmObs(.id, c(24.5, 30), cmt=1),
           nmDose(.id, 36, amt=50, cmt=1),
           nmObs(.id, c(37, 40, 48), cmt=1))
  },
  ctl=.advan1Ctl("  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  S1 = V", theta=""))

kitCase(
  name="evid4-reset-dose",
  covers="EVID=4 reset-and-dose record starting a second period",
  tags=c("dosing", "evid4", "reset"),
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
    nmBind(nmDose(.id, 0, amt=100, cmt=1, addl=2, ii=8),
           nmObs(.id, c(1, 6, 9, 17, 23), cmt=1),
           nmDose(.id, 24, amt=200, cmt=1, evid=4),
           nmObs(.id, c(25, 28, 36, 48), cmt=1))
  },
  ctl=.advan1Ctl("  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  S1 = V", theta=""))

kitCase(
  name="evid2-time-varying-cov",
  covers="Time-varying covariate changed on EVID=2 records (NONMEM next-observation-carried-backward semantics)",
  tags=c("dosing", "evid2", "covariate", "time-varying"),
  sim=function() {
    ini({
      tcl <- 2; tv <- 20; prop.sd <- 0.1; tcl.crcl <- 0.7
      eta.cl ~ 0.09; eta.v ~ 0.04
    })
    model({
      cl <- tcl * (CRCL / 100)^tcl.crcl * exp(eta.cl); v <- tv * exp(eta.v)
      d/dt(central) <- -cl / v * central
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    .d <- nmBind(nmDose(.id, 0, amt=100, cmt=1, addl=3, ii=12),
                 nmObs(.id, c(2, 8, 14, 20, 26, 32, 38, 44), cmt=1),
                 nmOther(.id, c(6, 18, 30), cmt=1))
    ## CRCL declines stepwise; values change at the EVID=2 records
    .d$CRCL <- 120 - 15 * findInterval(.d$TIME, c(6, 18, 30))
    .d$CRCL <- .d$CRCL * (0.8 + 0.4 * (.d$ID %% 5) / 4)
    .d
  },
  ctl=.advan1Ctl("  CL = THETA(1)*(CRCL/100)**THETA(4)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  S1 = V", theta="0.7"))

kitCase(
  name="cmt-off-depot",
  covers="Negative CMT on an EVID=2 record turns the depot off (e.g. emesis) mid-absorption",
  tags=c("dosing", "cmt-off", "advan2"),
  known="rxode2 linCmt() models cannot turn a compartment off ('compartment cannot be turned off')",
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 0.3
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
    nmBind(nmDose(.id, 0, amt=100, cmt=1),
           nmObs(.id, c(0.5, 1, 2), cmt=2),
           nmOther(.id, 2.5, cmt=-1),
           nmObs(.id, c(3, 4, 6, 8, 12, 24), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)
  S2 = V
$ERROR
  IPRED = F
  W = THETA(4)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 0.3) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="infusion-into-depot",
  covers="Zero-order infusion (RATE>0) into the absorption depot of ADVAN2, overlapping a bolus",
  tags=c("dosing", "infusion", "advan2"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1
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
    nmBind(nmDose(.id, 0, amt=100, cmt=1, rate=25),
           nmDose(.id, 2, amt=50, cmt=2),
           nmObs(.id, c(0.5, 1, 2.5, 3, 3.9, 4.1, 5, 6, 8, 12, 24), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)
  S2 = V
$ERROR
  IPRED = F
  W = THETA(4)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 1) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="mtime-change-point",
  covers="MTIME/MPAST model event time switching KA at an estimated time (ADVAN2)",
  tags=c("dosing", "mtime", "advan2"),
  known="rxode2 linCmt() and the equivalent ODE disagree (~1%) when KA switches at mtime(); compare with NONMEM in full mode",
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka1 <- 2; tka2 <- 0.2; tchg <- 1.5
      eta.cl ~ 0.09; eta.v ~ 0.04
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v)
      mtime(tswitch) <- tchg
      ka <- tka1
      if (t >= tchg) ka <- tka2
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1),
           nmObs(.id, c(0.25, 0.5, 1, 1.4, 1.6, 2, 3, 4, 6, 8, 12, 24), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  MTIME(1) = THETA(5)
  KA = THETA(3)
  IF (MPAST(1) .EQ. 1) KA = THETA(4)
  S2 = V
$ERROR
  IPRED = F
  W = THETA(6)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 2) (0, 0.2) (0, 1.5) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="dose-obs-ties",
  covers="Ties: obs listed before/after a dose and after an SS dose at the same TIME, plus replicate samples at one TIME",
  tags=c("dosing", "ties", "ss", "advan2"),
  known="by design: rxode2 sorts records tied in TIME, so nonmem2rx offsets them by delta=1e-4 (.fixNonmemTies); expect small IPRED differences where concentrations change fast",
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 3
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
    ## record order matters: nmBind keeps input order for tied times
    nmBind(nmDose(.id, 0, amt=100, cmt=1, ss=1, ii=12),
           nmObs(.id, c(0, 0.5, 0.5, 1, 6), cmt=2),
           nmObs(.id, 12, cmt=2),
           nmDose(.id, 12, amt=100, cmt=1),
           nmObs(.id, c(12, 13, 18, 24), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)
  S2 = V
$ERROR
  IPRED = F
  W = THETA(4)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 3) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

## ODE versions of the two linCmt limitations above, so the full run
## shows which solver agrees with NONMEM.
.odeCtl <- function(ctl, des) {
  ctl <- sub("$SUBROUTINES ADVAN2 TRANS2",
             "$SUBROUTINES ADVAN13 TOL=10 ATOL=12\n$MODEL COMP=(DEPOT,DEFDOSE) COMP=(CENTRAL,DEFOBS)",
             ctl, fixed=TRUE)
  sub("$ERROR", paste0("$DES\n", des, "\n$ERROR"), ctl, fixed=TRUE)
}
.des1 <- "  DADT(1) = -KA*A(1)\n  DADT(2) = KA*A(1) - CL/V*A(2)"

kitVariant("mtime-change-point", "mtime-change-point-ode",
           "MTIME/MPAST switching KA in an ADVAN13 ODE model",
           tags=c("dosing", "mtime", "ode", "advan13"),
           ctl=.odeCtl(.kitEnv$cases[["mtime-change-point"]]$ctl, .des1))

kitVariant("cmt-off-depot", "cmt-off-depot-ode",
           "Negative CMT on an EVID=2 record turns the depot off in an ADVAN13 ODE model",
           tags=c("dosing", "cmt-off", "ode", "advan13"),
           ctl=.odeCtl(.kitEnv$cases[["cmt-off-depot"]]$ctl, .des1))
