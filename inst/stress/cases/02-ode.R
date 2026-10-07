## General linear (ADVAN5/7) and ODE (ADVAN6/13/14) models

kitCase(
  name="advan5-transit",
  covers="ADVAN5 general linear model with named $MODEL COMP (DEFDOSE/DEFOBS), transit chain and peripheral (matExp translation)",
  tags=c("general-linear", "advan5", "model-comp"),
  sim=function() {
    ini({
      tktr <- 2; tcl <- 3; tv <- 20; tq <- 1.5; tvp <- 40
      eta.ktr ~ 0.09; eta.cl ~ 0.09
      prop.sd <- 0.1
    })
    model({
      ktr <- tktr * exp(eta.ktr); cl <- tcl * exp(eta.cl); v <- tv
      q <- tq; vp <- tvp
      d/dt(depot) <- -ktr * depot
      d/dt(transit) <- ktr * depot - ktr * transit
      d/dt(central) <- ktr * transit - (cl + q) / v * central + q / vp * periph
      d/dt(periph) <- q / v * central - q / vp * periph
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(72), cmt=3))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN5
$MODEL COMP=(DEPOT,DEFDOSE) COMP=(TRANSIT) COMP=(CENTRAL,DEFOBS) COMP=(PERIPH)
$PK
  KTR = THETA(1)*EXP(ETA(1))
  CL  = THETA(2)*EXP(ETA(2))
  V   = THETA(3)
  Q   = THETA(4)
  VP  = THETA(5)
  K12 = KTR
  K23 = KTR
  K30 = CL/V
  K34 = Q/V
  K43 = Q/VP
  S3 = V
$ERROR
  IPRED = F
  W = THETA(6)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 2) (0, 3) (0, 20) (0, 1.5) (0, 40) (0, 0.1)
$OMEGA 0.09 0.09
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="advan7-t-notation",
  covers="ADVAN7 with K1T0/K1T2/K2T1 'T' rate-constant notation",
  tags=c("general-linear", "advan7", "k-t-notation"),
  sim=function() {
    ini({
      tk10 <- 0.2; tk12 <- 0.5; tk21 <- 0.25; tv <- 15
      eta.k10 ~ 0.09; eta.v ~ 0.04
      add.sd <- 0.05
    })
    model({
      k10 <- tk10 * exp(eta.k10); k12 <- tk12; k21 <- tk21; v <- tv * exp(eta.v)
      d/dt(central) <- -(k10 + k12) * central + k21 * periph
      d/dt(periph) <- k12 * central - k21 * periph
      ipred <- central / v
      ipred ~ add(add.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(48), cmt=1))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN7
$MODEL COMP=(CENTRAL,DEFDOSE,DEFOBS) COMP=(PERIPH)
$PK
  K1T0 = THETA(1)*EXP(ETA(1))
  K1T2 = THETA(2)
  K2T1 = THETA(3)
  V    = THETA(4)*EXP(ETA(2))
  S1 = V
$ERROR
  IPRED = F
  IWRES = (DV - IPRED)/THETA(5)
  Y = IPRED + THETA(5)*EPS(1)
$THETA (0, 0.2) (0, 0.5) (0, 0.25) (0, 15) (0, 0.05)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitVariant("advan7-t-notation", "advan7-unnamed-comp",
           "ADVAN7 where $MODEL names the first compartment but leaves the second as a bare COMP",
           tags=c("general-linear", "advan7", "model-comp"),
           ctl=sub("COMP=(PERIPH)", "COMP", .kitEnv$cases[["advan7-t-notation"]]$ctl, fixed=TRUE))

kitCase(
  name="advan6-michaelis-menten",
  covers="ADVAN6 nonlinear (Michaelis-Menten) elimination with TOL; IV bolus at two dose levels",
  tags=c("ode", "advan6", "nonlinear", "tol"),
  sim=function() {
    ini({
      tvm <- 10; tkm <- 2; tv <- 20
      eta.vm ~ 0.09; eta.v ~ 0.04
      prop.sd <- 0.1
    })
    model({
      vm <- tvm * exp(eta.vm); km <- tkm; v <- tv * exp(eta.v)
      d/dt(central) <- -vm * (central / v) / (km + central / v)
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=ifelse(.id %% 2 == 0, 50, 500), cmt=1),
           nmObs(.id, pkTimes(48), cmt=1))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN6 TOL=10
$MODEL COMP=(CENTRAL,DEFDOSE,DEFOBS)
$PK
  VM = THETA(1)*EXP(ETA(1))
  KM = THETA(2)
  V  = THETA(3)*EXP(ETA(2))
  S1 = V
$DES
  C = A(1)/V
  DADT(1) = -VM*C/(KM + C)
$ERROR
  IPRED = F
  W = THETA(4)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 10) (0, 2) (0, 20) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="advan13-pkpd-turnover",
  covers="ADVAN13 PK + indirect response with A_0 baseline, two endpoints switched on CMT in $ERROR, ATOL/TOL/SSTOL",
  tags=c("ode", "advan13", "a0", "multiple-endpoints", "pkpd", "tol"),
  sim=function() {
    ini({
      tcl <- 2; tv <- 10; tka <- 1; tkin <- 10; tkout <- 0.5; timax <- 0.8; tic50 <- 2
      eta.cl ~ 0.09; eta.kin ~ 0.04
      prop.sd <- 0.1; add.sd <- 0.5
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv; ka <- tka
      kin <- tkin * exp(eta.kin); kout <- tkout
      cp <- central / v
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      d/dt(eff) <- kin * (1 - timax * cp / (tic50 + cp)) - kout * eff
      eff(0) <- kin / kout
      cp ~ prop(prop.sd) | central
      eff ~ add(add.sd) | eff
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1),
           nmObs(.id, pkTimes(24), cmt=2),
           nmObs(.id, c(0, 2, 4, 8, 12, 24, 36, 48), cmt=3))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN13 TOL=10 ATOL=12 SSTOL=10 SSATOL=12
$MODEL COMP=(DEPOT,DEFDOSE) COMP=(CENTRAL,DEFOBS) COMP=(EFF)
$PK
  CL   = THETA(1)*EXP(ETA(1))
  V    = THETA(2)
  KA   = THETA(3)
  KIN  = THETA(4)*EXP(ETA(2))
  KOUT = THETA(5)
  IMAX = THETA(6)
  IC50 = THETA(7)
  A_0(3) = KIN/KOUT
$DES
  CP = A(2)/V
  DADT(1) = -KA*A(1)
  DADT(2) = KA*A(1) - CL/V*A(2)
  DADT(3) = KIN*(1 - IMAX*CP/(IC50 + CP)) - KOUT*A(3)
$ERROR
  IF (CMT .EQ. 3) THEN
    IPRED = A(3)
    W = THETA(9)
  ELSE
    IPRED = A(2)/V
    W = THETA(8)*IPRED
  ENDIF
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 2) (0, 10) (0, 1) (0, 10) (0, 0.5) (0, 0.8, 1) (0, 2) (0, 0.1) (0, 0.5)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="advan13-time-in-des-no-doses",
  covers="ADVAN13 endogenous circadian turnover using T inside $DES; dataset has no dose records; A_0 from THETA",
  tags=c("ode", "advan13", "des-t", "no-dose", "a0"),
  sim=function() {
    ini({
      tkin <- 5; tkout <- 0.5; tamp <- 0.3; tphase <- 8
      eta.kin ~ 0.04; eta.phase ~ 0.1
      add.sd <- 0.3
    })
    model({
      kin <- tkin * exp(eta.kin); kout <- tkout; amp <- tamp
      phase <- tphase + eta.phase
      d/dt(resp) <- kin * (1 + amp * cos(2 * 3.14159265358979 * (t - phase) / 24)) - kout * resp
      resp(0) <- kin / kout
      ipred <- resp
      ipred ~ add(add.sd)
    })
  },
  data=function(nSub) {
    nmObs(seq_len(nSub), seq(0, 48, by=3), cmt=1)
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN13 TOL=10 ATOL=12
$MODEL COMP=(RESP,DEFDOSE,DEFOBS)
$PK
  KIN   = THETA(1)*EXP(ETA(1))
  KOUT  = THETA(2)
  AMP   = THETA(3)
  PHASE = THETA(4) + ETA(2)
  A_0(1) = KIN/KOUT
$DES
  DADT(1) = KIN*(1 + AMP*COS(2*3.14159265358979*(T - PHASE)/24)) - KOUT*A(1)
$ERROR
  IPRED = A(1)
  IWRES = (DV - IPRED)/THETA(5)
  Y = IPRED + THETA(5)*EPS(1)
$THETA (0, 5) (0, 0.5) (0, 0.3, 1) 8 (0, 0.3)
$OMEGA 0.04 0.1
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="advan14-ode",
  covers="ADVAN14 (CVODES) two-compartment ODE oral model",
  tags=c("ode", "advan14"),
  sim=function() {
    ini({
      tcl <- 3; tv2 <- 15; tq <- 2; tv3 <- 40; tka <- 1
      eta.cl ~ 0.09; eta.v2 ~ 0.04
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl); v2 <- tv2 * exp(eta.v2); q <- tq; v3 <- tv3; ka <- tka
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - (cl + q) / v2 * central + q / v3 * periph
      d/dt(periph) <- q / v2 * central - q / v3 * periph
      ipred <- central / v2
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(48), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN14 TOL=10 ATOL=12
$MODEL NCOMP=3 COMP=(DEPOT,DEFDOSE) COMP=(CENTRAL,DEFOBS) COMP=(PERIPH)
$PK
  CL = THETA(1)*EXP(ETA(1))
  V2 = THETA(2)*EXP(ETA(2))
  Q  = THETA(3)
  V3 = THETA(4)
  KA = THETA(5)
  S2 = V2
$DES
  DADT(1) = -KA*A(1)
  DADT(2) = KA*A(1) - (CL+Q)/V2*A(2) + Q/V3*A(3)
  DADT(3) = Q/V2*A(2) - Q/V3*A(3)
$ERROR
  IPRED = F
  W = THETA(6)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 15) (0, 2) (0, 40) (0, 1) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="advan13-abbr-replace-names",
  covers="$ABBR REPLACE of THETA/ETA/DADT/A by name with named compartments",
  tags=c("ode", "advan13", "abbr-replace"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 25; tka <- 1.1
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
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(36), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN13 TOL=10 ATOL=12
$MODEL COMP=(DEPOT,DEFDOSE) COMP=(CENTRAL,DEFOBS)
$ABBR REPLACE THETA(CL,V,KA)=THETA(1,2,3)
$ABBR REPLACE ETA(CL)=ETA(1)
$ABBR REPLACE ETA(V)=ETA(2)
$ABBR REPLACE DADT(DEPOT)=DADT(1)
$ABBR REPLACE DADT(CENTRAL)=DADT(2)
$ABBR REPLACE A(DEPOT)=A(1)
$ABBR REPLACE A(CENTRAL)=A(2)
$PK
  CL = THETA(CL)*EXP(ETA(CL))
  V  = THETA(V)*EXP(ETA(V))
  KA = THETA(KA)
$DES
  DADT(DEPOT) = -KA*A(DEPOT)
  DADT(CENTRAL) = KA*A(DEPOT) - CL/V*A(CENTRAL)
$ERROR
  IPRED = A(CENTRAL)/V
  W = THETA(4)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 25) (0, 1.1) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")
