## Closed-form (linCmt) ADVAN/TRANS combinations.
##
## THETAs are written in natural units (not logs) so the control
## stream initial estimates equal the simulation's true values exactly.

kitCase(
  name="advan1-trans2-bolus",
  covers="ADVAN1 TRANS2 IV bolus; add+prop error via THETA W and SIGMA 1 FIX",
  tags=c("linear", "advan1", "baseline", "error-theta"),
  sim=function() {
    ini({
      tcl <- 2; tv <- 20
      eta.cl ~ 0.09; eta.v ~ 0.04
      add.sd <- 0.05; prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v)
      d/dt(central) <- -cl / v * central
      ipred <- central / v
      ipred ~ add(add.sd) + prop(prop.sd)
    })
  },
  data=function(nSub) {
    nmBind(nmDose(seq_len(nSub), 0, amt=100, cmt=1),
           nmObs(seq_len(nSub), pkTimes(24), cmt=1))
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
  W = SQRT(THETA(3)**2 + (THETA(4)*IPRED)**2)
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 2)    ; CL
$THETA (0, 20)   ; V
$THETA (0, 0.05) ; add.sd
$THETA (0, 0.1)  ; prop.sd
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="advan2-trans2-lag-f",
  covers="ADVAN2 TRANS2 oral with ALAG1 and logit F1 (ETA on both); ADDL/II multiple dosing",
  tags=c("linear", "advan2", "alag", "bioav", "addl"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2; tlag <- 0.5; tlf <- 0.8
      eta.cl ~ 0.09; eta.v ~ 0.04; eta.lag ~ 0.04; eta.f ~ 0.25
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v); ka <- tka
      lagt <- tlag * exp(eta.lag)
      lf <- log(tlf / (1 - tlf)) + eta.f
      fd <- exp(lf) / (1 + exp(lf))
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      alag(depot) <- lagt
      f(depot) <- fd
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1, addl=3, ii=12),
           nmObs(.id, c(pkTimes(12), 36.5, 37, 38, 40, 44, 48, 60), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)
  ALAG1 = THETA(4)*EXP(ETA(3))
  LF = LOG(THETA(5)/(1-THETA(5))) + ETA(4)
  F1 = EXP(LF)/(1+EXP(LF))
  S2 = V
$ERROR
  IPRED = F
  W = THETA(6)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 1.2) (0, 0.5) (0, 0.8, 1) (0, 0.1)
$OMEGA 0.09 0.04 0.04 0.25
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="advan2-trans1-k",
  covers="ADVAN2 TRANS1 (K, KA) parameterization with S2 scaling in different units (mg dose, ug/L)",
  tags=c("linear", "advan2", "trans1", "scale"),
  sim=function() {
    ini({
      tk <- 0.1; tv <- 25; tka <- 0.9
      eta.k ~ 0.09; eta.v ~ 0.04; eta.ka ~ 0.09
      add.sd <- 20
    })
    model({
      k <- tk * exp(eta.k); v <- tv * exp(eta.v); ka <- tka * exp(eta.ka)
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - k * central
      ipred <- central / (v / 1000)
      ipred ~ add(add.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=50, cmt=1), nmObs(.id, pkTimes(48), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS1
$PK
  K  = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)*EXP(ETA(3))
  S2 = V/1000
$ERROR
  IPRED = F
  IWRES = (DV - IPRED)/THETA(4)
  Y = IPRED + THETA(4)*EPS(1)
$THETA (0, 0.1) (0, 25) (0, 0.9) (0, 20)
$OMEGA 0.09 0.04 0.09
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="advan3-trans4-infusion",
  covers="ADVAN3 TRANS4 two-compartment zero-order infusion (positive RATE) with covariate WT power model",
  tags=c("linear", "advan3", "infusion", "covariate"),
  sim=function() {
    ini({
      tcl <- 4; tv1 <- 10; tq <- 2; tv2 <- 30; tcl.wt <- 0.75
      eta.cl ~ 0.09; eta.v1 ~ 0.04
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * (WT / 70)^tcl.wt * exp(eta.cl)
      v1 <- tv1 * exp(eta.v1); q <- tq; v2 <- tv2
      d/dt(central) <- -(cl + q) / v1 * central + q / v2 * periph
      d/dt(periph) <- q / v1 * central - q / v2 * periph
      ipred <- central / v1
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=500, cmt=1, rate=250),
           nmDose(.id, 24, amt=500, cmt=1, rate=100),
           nmObs(.id, c(0.5, 1, 2, 2.5, 3, 4, 6, 8, 12, 23.9, 25, 26, 29, 30, 36, 48), cmt=1),
           cov=nmCov(nSub, WT=function(n) round(runif(n, 50, 110), 1)))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN3 TRANS4
$PK
  CL = THETA(1)*(WT/70)**THETA(5)*EXP(ETA(1))
  V1 = THETA(2)*EXP(ETA(2))
  Q  = THETA(3)
  V2 = THETA(4)
  S1 = V1
$ERROR
  IPRED = F
  W = THETA(6)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 4) (0, 10) (0, 2) (0, 30) 0.75 (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="advan3-trans3-vss",
  covers="ADVAN3 TRANS3 (CL, V, Q, VSS) parameterization",
  tags=c("linear", "advan3", "trans3"),
  sim=function() {
    ini({
      tcl <- 4; tv1 <- 10; tq <- 2; tvss <- 40
      eta.cl ~ 0.09; eta.v1 ~ 0.04
      add.sd <- 0.05
    })
    model({
      cl <- tcl * exp(eta.cl); v1 <- tv1 * exp(eta.v1); q <- tq
      v2 <- tvss - v1
      d/dt(central) <- -(cl + q) / v1 * central + q / v2 * periph
      d/dt(periph) <- q / v1 * central - q / v2 * periph
      ipred <- central / v1
      ipred ~ add(add.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(72), cmt=1))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN3 TRANS3
$PK
  CL  = THETA(1)*EXP(ETA(1))
  V   = THETA(2)*EXP(ETA(2))
  Q   = THETA(3)
  VSS = THETA(4)
  S1 = V
$ERROR
  IPRED = F
  IWRES = (DV - IPRED)/THETA(5)
  Y = IPRED + THETA(5)*EPS(1)
$THETA (0, 4) (0, 10) (0, 2) (0, 40) (0, 0.05)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="advan4-trans4-ss",
  covers="ADVAN4 TRANS4 two-compartment oral at steady state (SS=1, II) followed by washout",
  tags=c("linear", "advan4", "ss"),
  sim=function() {
    ini({
      tcl <- 5; tv2 <- 20; tq <- 3; tv3 <- 50; tka <- 1.5
      eta.cl ~ 0.09; eta.v2 ~ 0.04; eta.ka ~ 0.16
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl); v2 <- tv2 * exp(eta.v2); q <- tq; v3 <- tv3
      ka <- tka * exp(eta.ka)
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - (cl + q) / v2 * central + q / v3 * periph
      d/dt(periph) <- q / v2 * central - q / v3 * periph
      ipred <- central / v2
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1, ss=1, ii=12),
           nmObs(.id, c(0.5, 1, 2, 4, 6, 8, 11.9, 16, 24, 36, 48), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN4 TRANS4
$PK
  CL = THETA(1)*EXP(ETA(1))
  V2 = THETA(2)*EXP(ETA(2))
  Q  = THETA(3)
  V3 = THETA(4)
  KA = THETA(5)*EXP(ETA(3))
  S2 = V2
$ERROR
  IPRED = F
  W = THETA(6)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 5) (0, 20) (0, 3) (0, 50) (0, 1.5) (0, 0.1)
$OMEGA 0.09 0.04 0.16
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="advan11-trans4-3cmt",
  covers="ADVAN11 TRANS4 three-compartment IV infusion at steady state (SS=1 with RATE)",
  tags=c("linear", "advan11", "ss", "infusion"),
  sim=function() {
    ini({
      tcl <- 6; tv1 <- 8; tq2 <- 4; tv2 <- 20; tq3 <- 1; tv3 <- 60
      eta.cl ~ 0.09; eta.v1 ~ 0.04
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl); v1 <- tv1 * exp(eta.v1)
      q2 <- tq2; v2 <- tv2; q3 <- tq3; v3 <- tv3
      d/dt(central) <- -(cl + q2 + q3) / v1 * central + q2 / v2 * p1 + q3 / v3 * p2
      d/dt(p1) <- q2 / v1 * central - q2 / v2 * p1
      d/dt(p2) <- q3 / v1 * central - q3 / v3 * p2
      ipred <- central / v1
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=1000, cmt=1, rate=2000, ss=1, ii=8),
           nmObs(.id, c(0.25, 0.5, 0.75, 1, 2, 4, 7.9, 12, 24, 48), cmt=1))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN11 TRANS4
$PK
  CL = THETA(1)*EXP(ETA(1))
  V1 = THETA(2)*EXP(ETA(2))
  Q2 = THETA(3)
  V2 = THETA(4)
  Q3 = THETA(5)
  V3 = THETA(6)
  S1 = V1
$ERROR
  IPRED = F
  W = THETA(7)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 6) (0, 8) (0, 4) (0, 20) (0, 1) (0, 60) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="advan12-trans4-3cmt-oral",
  covers="ADVAN12 TRANS4 three-compartment first-order absorption with ALAG1",
  tags=c("linear", "advan12", "alag"),
  known="ADVAN12 TRANS4 (CL V2 Q3 V3 Q4 V4 KA) translates to linCmt() with an unresolved linCmtFun parameter",
  sim=function() {
    ini({
      tcl <- 6; tv2 <- 8; tq3 <- 4; tv3 <- 20; tq4 <- 1; tv4 <- 60; tka <- 2; tlag <- 0.25
      eta.cl ~ 0.09; eta.v2 ~ 0.04; eta.ka ~ 0.09
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl); v2 <- tv2 * exp(eta.v2); ka <- tka * exp(eta.ka)
      q3 <- tq3; v3 <- tv3; q4 <- tq4; v4 <- tv4
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - (cl + q3 + q4) / v2 * central + q3 / v3 * p1 + q4 / v4 * p2
      d/dt(p1) <- q3 / v2 * central - q3 / v3 * p1
      d/dt(p2) <- q4 / v2 * central - q4 / v4 * p2
      alag(depot) <- tlag
      ipred <- central / v2
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, c(0.1, 0.2, pkTimes(72)), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN12 TRANS4
$PK
  CL = THETA(1)*EXP(ETA(1))
  V2 = THETA(2)*EXP(ETA(2))
  Q3 = THETA(3)
  V3 = THETA(4)
  Q4 = THETA(5)
  V4 = THETA(6)
  KA = THETA(7)*EXP(ETA(3))
  ALAG1 = THETA(8)
  S2 = V2
$ERROR
  IPRED = F
  W = THETA(9)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 6) (0, 8) (0, 4) (0, 20) (0, 1) (0, 60) (0, 2) (0, 0.25) (0, 0.1)
$OMEGA 0.09 0.04 0.09
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")
