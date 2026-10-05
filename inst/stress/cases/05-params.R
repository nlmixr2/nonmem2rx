## $THETA / $OMEGA / $SIGMA edge cases.  The dry run checks the imported
## omega (and sigma where given) against the truth, since PRED alone
## cannot see random-effect parsing errors.

.oral1Pk <- "  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)*EXP(ETA(3))
  S2 = V"

kitCase(
  name="omega-block-labels-order",
  covers="$OMEGA BLOCK(2) between diagonal records, labels inside the block, ETAs used out of order in code",
  tags=c("params", "omega", "block", "eta-order"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2; tq <- 2; tvp <- 50
      eta.ka ~ 0.25
      eta.cl + eta.v ~ c(0.09, 0.03, 0.04)
      eta.vp ~ 0.16
      prop.sd <- 0.1
    })
    model({
      ka <- tka * exp(eta.ka); cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v)
      q <- tq; vp <- tvp * exp(eta.vp)
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - (cl + q) / v * central + q / vp * periph
      d/dt(periph) <- q / v * central - q / vp * periph
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(72), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN4 TRANS4
$PK
  V3 = THETA(5)*EXP(ETA(4))
  V2 = THETA(2)*EXP(ETA(3))
  CL = THETA(1)*EXP(ETA(2))
  KA = THETA(3)*EXP(ETA(1))
  Q  = THETA(4)
  S2 = V2
$ERROR
  IPRED = F
  W = THETA(6)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) ; CL
 (0, 30) ; V2
 (0, 1.2) ; KA
 (0, 2) ; Q
 (0, 50) ; V3
 (0, 0.1) ; prop
$OMEGA 0.25 ; IIV KA
$OMEGA BLOCK(2)
 0.09        ; IIV CL
 0.03 0.04   ; IIV V2
$OMEGA 0.16 ; IIV V3
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="omega-sd-correlation",
  covers="$OMEGA BLOCK(2) SD CORRELATION, $OMEGA VARIANCE, and $SIGMA SD with an EPS-based proportional error",
  tags=c("params", "omega", "sigma", "sd", "correlation", "error-eps"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2
      eta.cl + eta.v ~ c(0.09, 0.03, 0.04)
      eta.ka ~ 0.16
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v); ka <- tka * exp(eta.ka)
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(48), cmt=2))
  },
  sigma=matrix(0.01, dimnames=list("eps1", "eps1")),
  ctl=paste0("$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
", .oral1Pk, "
$ERROR
  IPRED = F
  IWRES = (DV - IPRED)/(IPRED*0.1)
  Y = IPRED*(1 + EPS(1))
$THETA (0, 3) (0, 30) (0, 1.2)
$OMEGA BLOCK(2) SD CORRELATION
 0.3
 0.5 0.2
$OMEGA 0.16 VARIANCE
$SIGMA 0.1 SD
{{EST}}
{{TABLE}}
"))

kitCase(
  name="omega-cholesky",
  covers="$OMEGA BLOCK(2) CHOLESKY (lower-triangular factor) values",
  tags=c("params", "omega", "cholesky"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2
      eta.cl + eta.v ~ c(0.09, 0.03, 0.05)
      eta.ka ~ 0.16
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v); ka <- tka * exp(eta.ka)
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(48), cmt=2))
  },
  ctl=paste0("$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
", .oral1Pk, "
$ERROR
  IPRED = F
  W = THETA(4)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 1.2) (0, 0.1)
$OMEGA BLOCK(2) CHOLESKY
 0.3
 0.1 0.2
$OMEGA 0.16
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
"))

kitCase(
  name="omega-same-iov",
  covers="Inter-occasion variability: $OMEGA BLOCK(1) + BLOCK(1) SAME selected by an OCC column",
  tags=c("params", "omega", "same", "iov", "time-varying"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2
      eta.cl ~ 0.09; eta.v ~ 0.04
      eta.iov1 ~ 0.04; eta.iov2 ~ 0.04
      prop.sd <- 0.1
    })
    model({
      iov <- eta.iov1
      if (OCC == 2) iov <- eta.iov2
      cl <- tcl * exp(eta.cl + iov); v <- tv * exp(eta.v); ka <- tka
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    .d <- nmBind(nmDose(.id, c(0, 48), amt=100, cmt=1),
                 nmObs(.id, c(1, 2, 4, 8, 12, 24, 47, 49, 50, 52, 56, 60, 72), cmt=2))
    .d$OCC <- ifelse(.d$TIME < 48, 1, 2)
    .d
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  IOV = ETA(3)
  IF (OCC .EQ. 2) IOV = ETA(4)
  CL = THETA(1)*EXP(ETA(1) + IOV)
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
$OMEGA BLOCK(1) 0.04
$OMEGA BLOCK(1) SAME
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="theta-forms",
  covers="$THETA numeric forms (.12E+01, 3.0E1, 1E+04, 3.), FIX in several positions and empty upper bounds",
  tags=c("params", "theta", "fix"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2; tcl.wt <- fix(0.75); tv.wt <- fix(1)
      eta.cl ~ 0.09; eta.v ~ 0.04
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * (WT / 70)^tcl.wt * exp(eta.cl)
      v <- tv * (WT / 70)^tv.wt * exp(eta.v); ka <- tka
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(48), cmt=2),
           cov=nmCov(nSub, WT=function(n) round(runif(n, 45, 120))))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  CL = THETA(1)*(WT/70)**THETA(4)*EXP(ETA(1))
  V  = THETA(2)*(WT/70)**THETA(5)*EXP(ETA(2))
  KA = THETA(3)
  S2 = V
$ERROR
  IPRED = F
  W = THETA(6)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0,3.,) (0, 3.0E1, 1E+04) (0 , .12E+01)
$THETA (0.75) FIX (1 FIX)
$THETA (0, 0.1, )
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="sigma-block-two-eps",
  covers="$SIGMA BLOCK(2) with additive + proportional EPS (Y=IPRED*(1+EPS(1))+EPS(2))",
  tags=c("params", "sigma", "block", "error-eps", "combined"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2
      eta.cl ~ 0.09; eta.v ~ 0.04
      prop.sd <- 0.1; add.sd <- 0.05
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v); ka <- tka
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      ipred <- central / v
      ipred ~ prop(prop.sd) + add(add.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(48), cmt=2))
  },
  sigma=matrix(c(0.01, 0.0001, 0.0001, 0.0025), 2,
               dimnames=list(c("eps1", "eps2"), c("eps1", "eps2"))),
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
  W = SQRT(IPRED**2*SIGMA(1,1) + SIGMA(2,2))
  IWRES = (DV - IPRED)/W
  Y = IPRED*(1 + EPS(1)) + EPS(2)
$THETA (0, 3) (0, 30) (0, 1.2)
$OMEGA 0.09 0.04
$SIGMA BLOCK(2) 0.01 0.0001 0.0025
{{EST}}
{{TABLE}}
")

kitCase(
  name="labels-nm75",
  covers="NONMEM 7.5 labels: $THETA CL=(...), $OMEGA ECL=..., $SIGMA PROP=..., referenced as THETA(CL)/ETA(ECL)/EPS(PROP)",
  tags=c("params", "labels", "nm75", "error-eps"),
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
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(48), cmt=2))
  },
  sigma=matrix(0.01, dimnames=list("eps1", "eps1")),
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  CL = THETA(CL)*EXP(ETA(ECL))
  V  = THETA(V)*EXP(ETA(EV))
  KA = THETA(KA)
  S2 = V
$ERROR
  IPRED = F
  IWRES = (DV - IPRED)/(0.1*IPRED)
  Y = IPRED + IPRED*EPS(PROP)
$THETA CL=(0, 3) V=(0, 30) KA=(0, 1.2)
$OMEGA ECL=0.09 EV=0.04
$SIGMA PROP=0.01
{{EST}}
{{TABLE}}
")
