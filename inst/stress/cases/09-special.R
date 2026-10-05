## Special model classes: delay differential equations and mixtures

kitCase(
  name="dde-advan16-delay",
  covers="ADVAN16 delay differential equation: delayed drug effect via AD_1_1 with TAU1 and constant past AP_1_1",
  tags=c("special", "dde", "advan16", "a0"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tkin <- 10; tkout <- 0.5; ttau <- 4; tic50 <- 1
      eta.cl ~ 0.09; eta.kin ~ 0.04
      prop.sd <- 0.1; add.sd <- 0.5
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv
      kin <- tkin * exp(eta.kin); kout <- tkout; tau <- ttau
      d/dt(central) <- -cl / v * central
      d/dt(resp) <- kin * (1 - delay(central, tau) / v / (tic50 + delay(central, tau) / v)) - kout * resp
      resp(0) <- kin / kout
      past(central, tau) <- 0
      cp <- central / v
      cp ~ prop(prop.sd) | central
      resp ~ add(add.sd) | resp
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1),
           nmObs(.id, c(0.5, 2, 6, 12, 24), cmt=1),
           nmObs(.id, c(1, 3, 5, 8, 10, 14, 20, 30, 48), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN16 TOL=9 ATOL=12
$MODEL COMP=(CENTRAL,DEFDOSE,DEFOBS) COMP=(RESP)
$PK
  CL   = THETA(1)*EXP(ETA(1))
  V    = THETA(2)
  KIN  = THETA(3)*EXP(ETA(2))
  KOUT = THETA(4)
  TAU1 = THETA(5)
  IC50 = THETA(6)
  A_0(2) = KIN/KOUT
$DES
  AP_1_1 = 0
  CDEL = AD_1_1/V
  DADT(1) = -CL/V*A(1)
  DADT(2) = KIN*(1 - CDEL/(IC50 + CDEL)) - KOUT*A(2)
$ERROR
  IF (CMT .EQ. 2) THEN
    IPRED = A(2)
    W = THETA(8)
  ELSE
    IPRED = A(1)/V
    W = THETA(7)*IPRED
  ENDIF
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 10) (0, 0.5) (0, 4) (0, 1) (0, 0.1) (0, 0.5)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="mix-two-clearance",
  covers="$MIX with two sub-populations (fast/slow clearance), P(1)=THETA, MIXNUM and MIXEST in $PK",
  tags=c("special", "mixture"),
  tol=list(validate=FALSE),  # nonmem2rx skips simulation validation for $MIX by design
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2; tratio <- 0.3
      eta.cl ~ 0.09; eta.v ~ 0.04
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl)
      if (POP == 2) cl <- tcl * tratio * exp(eta.cl)
      v <- tv * exp(eta.v); ka <- tka
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    nmBind(nmDose(seq_len(nSub), 0, amt=100, cmt=1),
           nmObs(seq_len(nSub), pkTimes(48), cmt=2),
           cov=nmCov(nSub, POP=function(n) 1 + (runif(n) > 0.7)))
  },
  ## the true sub-population is hidden from NONMEM
  write=function(d) {
    d$POP <- NULL
    d
  },
  ## NONMEM's PRED for a mixture depends on MIXNUM; compare in full mode
  dryPred=FALSE,
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$MIX
  NSPOP = 2
  P(1) = THETA(5)
  P(2) = 1 - THETA(5)
$PK
  CL = THETA(1)*EXP(ETA(1))
  IF (MIXNUM .EQ. 2) CL = THETA(1)*THETA(4)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)
  S2 = V
  EST = MIXEST
$ERROR
  IPRED = F
  W = THETA(6)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 1.2) (0, 0.3, 1) (0, 0.7, 1) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")
