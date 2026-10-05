## Abbreviated-code ($PK/$PRED/$ERROR/$DES) edge cases

kitCase(
  name="if-else-logic",
  covers="IF/ELSE IF/ELSE/ENDIF, nested IF, one-line IF, .AND./.OR. precedence without parentheses, ==, >=, .NE. and $ERROR (ONLY OBSERVATIONS)",
  tags=c("code", "if", "covariate", "only-obs"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2; tsex <- 0.8; trace2 <- 1.3; trace3 <- 0.7; told <- 0.9
      eta.cl ~ 0.09; eta.v ~ 0.04
      prop.sd <- 0.1
    })
    model({
      if (RACE == 2) {
        frace <- trace2
      } else if (RACE == 3) {
        frace <- trace3
      } else {
        frace <- 1
      }
      fsex <- 1
      if (SEX == 1 && AGE >= 65) fsex <- tsex * told
      if (SEX == 1 && AGE < 65) fsex <- tsex
      if (SEX != 1 && (AGE >= 65 || RACE == 3)) fsex <- told
      cl <- tcl * frace * fsex * exp(eta.cl); v <- tv * exp(eta.v); ka <- tka
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(36), cmt=2),
           cov=nmCov(nSub, SEX=function(n) rep_len(c(0, 1), n),
                     RACE=function(n) rep_len(c(1, 2, 3), n),
                     AGE=function(n) rep_len(c(30, 70, 50, 80, 64, 65), n)))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  IF (RACE .EQ. 2) THEN
    FRACE = THETA(5)
  ELSE IF (RACE == 3) THEN
    FRACE = THETA(6)
  ELSE
    FRACE = 1
  ENDIF
  FSEX = 1
  IF (SEX .EQ. 1) THEN
    IF (AGE .GE. 65) THEN
      FSEX = THETA(4)*THETA(7)
    ELSE
      FSEX = THETA(4)
    ENDIF
  ENDIF
  IF (SEX .NE. 1 .AND. AGE >= 65 .OR. SEX .NE. 1 .AND. RACE .EQ. 3) FSEX = THETA(7)
  CL = THETA(1)*FRACE*FSEX*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)
  S2 = V
$ERROR (ONLY OBSERVATIONS)
  IPRED = F
  W = THETA(8)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 1.2) (0, 0.8) (0, 1.3) (0, 0.7) (0, 0.9) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitVariant("if-else-logic", "logical-not-and-slash-ne",
           "Fortran .NOT. and the /= operator in IF conditions",
           tags=c("code", "if", "grammar"),
           ctl=sub("  IF (SEX .NE. 1 .AND. AGE >= 65 .OR. SEX .NE. 1 .AND. RACE .EQ. 3) FSEX = THETA(7)\n",
                   "  IF (.NOT. SEX .EQ. 1 .AND. AGE >= 65 .OR. .NOT. SEX .EQ. 1 .AND. RACE .EQ. 3) FSEX = THETA(7)\n  IF (SEX /= 1 .AND. SEX /= 0) FSEX = -1\n",
                   .kitEnv$cases[["if-else-logic"]]$ctl, fixed=TRUE))

kitCase(
  name="math-functions",
  covers="DEXP/DLOG/LOG10/DSQRT/DABS/** powers, MIN/MAX, and a probit bioavailability using PHI()",
  tags=c("code", "functions", "bioav"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2; tprobit <- 0.5; tage <- -0.3
      eta.cl ~ 0.09; eta.v ~ 0.04; eta.f ~ 0.25
      prop.sd <- 0.1
    })
    model({
      wtc <- max(min(WT, 120), 40)
      cl <- tcl * exp(0.75 * log(wtc / 70)) * (1 + tage * log10(AGE / 40)) * exp(eta.cl)
      v <- tv * sqrt(wtc / 70)^2 * exp(eta.v)
      ka <- tka * exp(abs(eta.v) * 0)
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      f(depot) <- phi(tprobit + eta.f)
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(36), cmt=2),
           cov=nmCov(nSub, WT=function(n) round(runif(n, 30, 140)),
                     AGE=function(n) round(runif(n, 20, 80))))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  WTC = MAX(MIN(WT, 120.0), 40.0)
  CL = THETA(1)*DEXP(0.75*DLOG(WTC/70))*(1 + THETA(5)*LOG10(AGE/40))*EXP(ETA(1))
  V  = THETA(2)*DSQRT(WTC/70)**2*EXP(ETA(2))
  KA = THETA(3)*EXP(DABS(ETA(2))*0)
  F1 = PHI(THETA(4) + ETA(3))
  S2 = V
$ERROR
  IPRED = F
  W = THETA(6)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 1.2) 0.5 -0.3 (0, 0.1)
$OMEGA 0.09 0.04 0.25
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="do-while-loop",
  covers="DO WHILE / ENDDO loop computing an allometric factor",
  tags=c("code", "do-while"),
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2
      eta.cl ~ 0.09; eta.v ~ 0.04
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * ((WT / 70)^3)^0.25 * exp(eta.cl); v <- tv * exp(eta.v); ka <- tka
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1), nmObs(.id, pkTimes(36), cmt=2),
           cov=nmCov(nSub, WT=function(n) round(runif(n, 40, 120))))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$ABBR DECLARE DOWHILE N
$PK
  N = 0
  CUMW = 1
  DO WHILE (N .LT. 3)
    CUMW = CUMW*WT/70
    N = N + 1
  ENDDO
  CL = THETA(1)*CUMW**0.25*EXP(ETA(1))
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
  name="pred-emax-reserved-names",
  covers="$PRED sigmoid Emax with variables named GAMMA, BETA, LAMBDA (rxode2 function names) and no dose records",
  tags=c("code", "pred", "reserved", "no-dose"),
  sim=function() {
    ini({
      te0 <- 10; temax <- 2; tec50 <- 5; tgam <- 1.5
      eta.e0 ~ 0.04; eta.ec50 ~ 0.09
      add.sd <- 0.5
    })
    model({
      e0 <- te0 * exp(eta.e0); ec50 <- tec50 * exp(eta.ec50)
      ipred <- e0 * (1 + temax * CONC^tgam / (ec50^tgam + CONC^tgam))
      ipred ~ add(add.sd)
    })
  },
  data=function(nSub) {
    .d <- nmObs(seq_len(nSub), 0:7, cmt=1)
    .d$CONC <- c(0, 0.5, 1, 2, 4, 8, 16, 32)[.d$TIME + 1]
    .d
  },
  write=function(d) d[, c("ID", "TIME", "CONC", "DV", "MDV", "EVID", "ROWID")],
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$PRED
  E0 = THETA(1)*EXP(ETA(1))
  EMAX = THETA(2)
  EC50 = THETA(3)*EXP(ETA(2))
  GAMMA = THETA(4)
  BETA = CONC**GAMMA
  LAMBDA = EC50**GAMMA + BETA
  IPRED = E0*(1 + EMAX*BETA/LAMBDA)
  IWRES = (DV - IPRED)/THETA(5)
  Y = IPRED + THETA(5)*EPS(1)
$THETA (0, 10) (0, 2) (0, 5) (0, 1.5) (0, 0.5)
$OMEGA 0.04 0.09
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="time-in-pk",
  covers="TIME used in $PK (time-varying CL): NONMEM evaluates $PK only at records, so CL is piecewise constant (next-record value)",
  tags=c("code", "time-in-pk", "ode", "advan13"),
  known="TIME in $PK is rxode2's continuous time, but NONMEM holds $PK values between records (NONMEM 7.4: IPRED off 0.65% median); needs nocb time for PK values in rxode2 (nlmixr2/rxode2#1429)",
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2; tind <- 1; tkind <- 0.05
      eta.cl ~ 0.09; eta.v ~ 0.04
      prop.sd <- 0.1
    })
    model({
      ## TREC is the record time; with nocb interpolation it is the time
      ## of the record ending each interval, mimicking NONMEM's $PK calls
      cl <- tcl * (1 + tind * (1 - exp(-tkind * TREC))) * exp(eta.cl)
      v <- tv * exp(eta.v); ka <- tka
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    .d <- nmBind(nmDose(.id, seq(0, 96, by=24), amt=100, cmt=1),
                 nmObs(.id, c(2, 6, 12, 26, 36, 50, 60, 74, 84, 98, 108, 120), cmt=2))
    .d$TREC <- .d$TIME
    .d
  },
  write=function(d) {
    d$TREC <- NULL
    d
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN13 TOL=10 ATOL=12
$MODEL COMP=(DEPOT,DEFDOSE) COMP=(CENTRAL,DEFOBS)
$PK
  CL = THETA(1)*(1 + THETA(4)*(1 - EXP(-THETA(5)*TIME)))*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)
$DES
  DADT(1) = -KA*A(1)
  DADT(2) = KA*A(1) - CL/V*A(2)
$ERROR
  IPRED = A(2)/V
  W = THETA(6)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 1.2) (0, 1) (0, 0.05) (0, 0.1)
$OMEGA 0.09 0.04
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")

kitCase(
  name="retained-pk-variables",
  covers="Savic transit absorption: dose amount/time kept in $PK variables across records (IF (AMT.GT.0) ...), GAMLN in $DES",
  tags=c("code", "retained-variables", "gamln", "ode", "advan13"),
  known="PODO/TDOS assigned only under IF (AMT.GT.0) are not retained between records in the translation (PRED is NaN)",
  sim=function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2; tmtt <- 2; tntr <- 4
      eta.cl ~ 0.09; eta.mtt ~ 0.09
      prop.sd <- 0.1
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv; ka <- tka
      mtt <- tmtt * exp(eta.mtt); ntr <- tntr
      ktr <- (ntr + 1) / mtt
      d/dt(depot) <- exp(log(podo(depot)) + log(ktr) + ntr * log(ktr * tad(depot)) -
                           ktr * tad(depot) - lgamma(ntr + 1)) - ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      f(depot) <- 0
      ipred <- central / v
      ipred ~ prop(prop.sd)
    })
  },
  data=function(nSub) {
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, 0, amt=100, cmt=1),
           nmObs(.id, c(0.5, 1, 1.5, 2, 3, 4, 6, 8, 12, 24), cmt=2))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN13 TOL=10 ATOL=12
$MODEL COMP=(DEPOT,DEFDOSE) COMP=(CENTRAL,DEFOBS)
$PK
  IF (AMT .GT. 0) THEN
    PODO = AMT
    TDOS = TIME
  ENDIF
  CL  = THETA(1)*EXP(ETA(1))
  V   = THETA(2)
  KA  = THETA(3)
  MTT = THETA(4)*EXP(ETA(2))
  NTR = THETA(5)
  KTR = (NTR + 1)/MTT
  F1 = 0
$DES
  TT = T - TDOS
  IF (TT .LE. 0) TT = 1E-10
  DADT(1) = EXP(LOG(PODO) + LOG(KTR) + NTR*LOG(KTR*TT) - KTR*TT - GAMLN(NTR + 1)) - KA*A(1)
  DADT(2) = KA*A(1) - CL/V*A(2)
$ERROR
  IPRED = A(2)/V
  W = THETA(6)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)
$THETA (0, 3) (0, 30) (0, 1.2) (0, 2) (0, 4) (0, 0.1)
$OMEGA 0.09 0.09
$SIGMA 1 FIX
{{EST}}
{{TABLE}}
")
