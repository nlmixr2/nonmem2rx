test_that("test abbrev", {

  .a <- function(abbrev, eq="no", abbrevLin=0L, extended=0L) {
    .clearNonmem2rx()
    .Call(`_nonmem2rx_setRecord`, "$PRED")
    .Call(`_nonmem2rx_trans_abbrev`, abbrev, '$PRED', abbrevLin, extended)
    expect_equal(.nonmem2rx$model, eq)
  }

  .a("MTIME(1)=1.5\nMTIME(2)=2.5\nR1=   400*EXP(ETA(1))*(1-MPAST(1))\nR1=R1+300*EXP(ETA(2))*(MPAST(1)-MPAST(2))\nR1=R1+200*EXP(ETA(3))*MPAST(2)",
     c("mtime(rx.mtime.1.) <- 1.5",
       "rx.mpast.1. <- ifelse(time >= rx.mtime.1., 1, 0)",
       "MNOW <- ifelse(time == rx.mtime.1., 1, 0)",
       "mtime(rx.mtime.2.) <- 2.5",
       "rx.mpast.2. <- ifelse(time >= rx.mtime.2., 1, 0)",
       "MNOW <- ifelse(MNOW == 0 && time == rx.mtime.2., 2, MNOW)",
       "rxrate.rxddta1. <- 400 * exp(eta1) * (1 - rx.mpast.1.)",
       "rate(rxddta1) <- rxrate.rxddta1.",
       "rxrate.rxddta1. <- rxrate.rxddta1. + 300 * exp(eta2) * (rx.mpast.1. - rx.mpast.2.)",
       "rate(rxddta1) <- rxrate.rxddta1.",
       "rxrate.rxddta1. <- rxrate.rxddta1. + 200 * exp(eta3) * rx.mpast.2.",
       "rate(rxddta1) <- rxrate.rxddta1."))

  .a("MTIME(1) = THETA(3)+ETA(1)\nMTIME(2) = THETA(4)+ETA(5)",
     c("mtime(rx.mtime.1.) <- theta3 + eta1",
       "rx.mpast.1. <- ifelse(time >= rx.mtime.1., 1, 0)",
       "MNOW <- ifelse(time == rx.mtime.1., 1, 0)",
       "mtime(rx.mtime.2.) <- theta4 + eta5",
       "rx.mpast.2. <- ifelse(time >= rx.mtime.2., 1, 0)",
       "MNOW <- ifelse(MNOW == 0 && time == rx.mtime.2., 2, MNOW)"))

  .a("IF (TIME > MTIME(1)) KA=THETA(2)", "if (t > rx.mtime.1.) KA <- theta2")

  .a("TVCL  = A_0(1) + 3", "TVCL <- rxini.rxddta1. + 3")

  .a("TVCL    = matt", "TVCL <- MATT")
  .a("TVCL    = matt+3",
     "TVCL <- MATT + 3")
  .a("TVCL    = THETA(1)",
     "TVCL <- theta1")
  .a("TVCL    = THETA(1)*(1+THETA(7)*(CLCR-65))",
     "TVCL <- theta1 * (1 + theta7 * (CLCR - 65))")
  .a(" CL      = TVCL*DEXP(ETA(1))",
     "CL <- TVCL * exp(eta1)")

  .a(" CL      = TVCL*EXP(ETA(1))",
     "CL <- TVCL * exp(eta1)")

  .a(" CL      = LOG(C)","CL <- log(C)")
  .a(" CL      = LOG(B)", "CL <- log(B)")
  .a(" CL      = LOG10(C)", "CL <- log10(C)")
  .a(" CL      = SQRT(C)", "CL <- sqrt(C)")
  .a(" CL      = SIN(C)", "CL <- sin(C)")
  .a(" CL      = COS(C)", "CL <- cos(C)")
  .a(" CL      = DABS(C)", "CL <- abs(C)")
  .a(" CL      = TAN(C)", "CL <- tan(C)")
  .a(" CL      = ACOS(C)", "CL <- acos(C)")
  .a(" CL      = PHI(C)", "CL <- phi(C)")
  .a(" CL      = GAMLN(C)", "CL <- lgamma(C)")

  # note that  mod parser doesn't check for the number of arguments (none of the parsing does)
  expect_error(.a(" CL      = MOD(C)"), "'MOD'")
  expect_error(.a(" CL      = INT(C)"), "'INT'")
  expect_error(.a("CL = A12345"), "'A#'")
  expect_error(.a("CL = C12345"), "'C#'")
  .a("A = MIXNUM", "A <- MIXNUM")
  .a("A = MIXEST", "A <- MIXNUM")
  expect_warning(.a("A = ICALL", "A <- icall"), "icall")
  expect_error(.a("A = COMACT"), "'COMACT'")
  expect_error(.a("A = COMSAV"), "'COMSAV'")
  .a("B = MNOW", "B <- MNOW")
  expect_warning(.a("MTDIFF=1", "MTDIFF <- 1"), "'MTDIFF'")

  .a(" Y      = 1 + ERR(1)*W",
     "Y <- 1 + eps1 * W")
  .a(" Y      = 1 + EPS(1)*W",
     "Y <- 1 + eps1 * W")


  .a("IF (CL .GE. 4) THEN", "if (CL >= 4) {")
  .a("ELSEIF (CL .LE. 2) THEN", "} else if (CL <= 2) {")
  .a("ELSE", "} else {")
  .a("ENDIF", "}")
  .a("DO WHILE (CL .NE. 4)", "while (CL != 4) {")
  .a("ENDDO", "}")
  .a("IF (CL .GE. 4) CL = 4", "if (CL >= 4) CL <- 4")
  # Case-insensitive if statements
  .a("if (CL.GE.4) THEN", "if (CL >= 4) {")
  .a("if (CL.GE.4) then", "if (CL >= 4) {")
  .a("else", "} else {")
  .a("elseif (CL .LE. 2) THEN", "} else if (CL <= 2) {")
  .a("endif", "}")

  # Unsupported lines
  expect_warning(.a("\"FIRST", NULL), "verbatim")

  .a("EXIT 1 2", "ierprdu <- 1*100000+2")

  .a("IF (B .LT. 0) EXIT 1 2", "if (B < 0) ierprdu <- 100000 * 1 + 2")
  expect_warning(.a("COMRES = -1", NULL), "'COMRES = -1' ignored")
  expect_warning(.a("CALLFL = -1", NULL), "'CALLFL = ' ignored")
  expect_error(.a("CALL PASS(MODE)"), "'CALL PASS")
  expect_error(.a("CALL SUPP(0 , 1)"), "'CALL SUPP")
  .a("CALL RANDOM(1, R)", "R <- rxunif()")
  expect_error(.a("C=DT(3)"), "DT\\(#\\)")
  .a("C=MTIME(3)", "C <- rx.mtime.3.")
  expect_error(.a("C=MNEXT(3)"), "MNEXT\\(#\\)")
  .a("C=MPAST(3)", "C <- rx.mpast.3.")
  expect_error(.a("C=COM(3)"), "COM\\(#\\)")
  expect_error(.a("C=PCMT(3)"), "PCMT\\(#\\)")

  .a("C=MIXP(3)", "C <- rxp.3.")
  .a("C=MIXP(MIXNUM)", "C <- cur.mixp")
  .a("C=MIXP(MIXEST)", "C <- cur.mixp")
  .a("C=MIXP", "C <- cur.mixp")

  #d/dt() related lines

  .a("DADT(1) = -KEL*A(1)",
     # could look better but functional
     "d/dt(rxddta1) <-  - KEL * rxddta1")

  .a("DADT(2) = -KEL*A(1)+DADT(1)",
     "d/dt(rxddta2) <-  - KEL * rxddta1 + d/dt(rxddta1)")
  expect_error(.a("DA(1, 2) = -KEL*A(1)"), "DA[(]#, #[)]")
  expect_error(.a("DP(1, 2) = -KEL*A(1)"), "DP[(]#, #[)]")

  # cmt properties
  .a("A_0(1) = 1",c("rxini.rxddta1. <- 1", "rxddta1(0) <- rxini.rxddta1."))
  .a("F1 = 1",c("rxf.rxddta1. <- 1", "f(rxddta1) <- rxf.rxddta1."))
  .a("R1 = 1",c("rxrate.rxddta1. <- 1", "rate(rxddta1) <- rxrate.rxddta1."))
  .a("D1 = 1",c("rxdur.rxddta1. <- 1", "dur(rxddta1) <- rxdur.rxddta1."))
  .a("ALAG1 = 1", c("rxalag.rxddta1. <- 1", "alag(rxddta1) <- rxalag.rxddta1."))
  .a("S1 = 1","scale1 <- 1")
  .a(" CL      = LOG(A)", "CL <- log(A)")
  .a(" CL      = MIN(C, D)", "CL <- min(C, D)")
  .a(" CL      = MAX(C, D)", "CL <- max(C, D)")
  expect_error(.a(" TSCALE      = 4"), "'TSCALE'")
  expect_error(.a(" XSCALE      = 4"), "'XSCALE'")
  .a("CALL SIMETA(ETA)", "simeta()")
  .a("CALL SIMEPS(EPS)", "simeps()")
  expect_error(.a("CALL GETETA(ETA)"), "'CALL GETETA")
  expect_error(.a(","), "[$]PRED")

  .a("x=time", "X <- t")
  .a("x=t", "X <- t")

  # in the presence of linCmt()
  .a("f1=1", c("rxf.central. <- 1", "f(central) <- rxf.central."), abbrevLin=1L)
  .a("A_0(1) = 1",c("rxini.central. <- 1", "central(0) <- rxini.central."), abbrevLin=1L)
  .a("R1 = 1",c("rxrate.central. <- 1", "rate(central) <- rxrate.central."), abbrevLin=1L)
  .a("D1 = 1",c("rxdur.central. <- 1", "dur(central) <- rxdur.central."), abbrevLin=1L)
  .a("SC = 1","scale1 <- 1", abbrevLin=1L)
  expect_error(.a("f3=1", c("rxf.depot. <- 1", "f(depot) <- rxf.depot."), abbrevLin=1L), "central")
  .a("f1=1", c("rxf.depot. <- 1", "f(depot) <- rxf.depot."), abbrevLin=2L)
  .a("A_0(1) = 1",c("rxini.depot. <- 1", "depot(0) <- rxini.depot."), abbrevLin=2L)
  .a("R1 = 1", c("rxrate.depot. <- 1", "rate(depot) <- rxrate.depot."), abbrevLin=2L)
  .a("D1 = 1",c("rxdur.depot. <- 1", "dur(depot) <- rxdur.depot."), abbrevLin=2L)
  .a("SC = 1","scale2 <- 1", abbrevLin=2L)
  .a("f2=1", c("rxf.central. <- 1", "f(central) <- rxf.central."), abbrevLin=2L)
  .a("A_0(2) = 1",c("rxini.central. <- 1", "central(0) <- rxini.central."), abbrevLin=2L)
  .a("R2 = 1",c("rxrate.central. <- 1", "rate(central) <- rxrate.central."), abbrevLin=2L)
  .a("D2 = 1",c("rxdur.central. <- 1", "dur(central) <- rxdur.central."), abbrevLin=2L)
  expect_error(.a("f3=1", "f(central) <- 1", abbrevLin=2L), "central")
  expect_warning(.a("S1 = 1\nSC=1", c("scale1 <- 1", "scale1 <- 1"), abbrevLin=1L), "last defined")
  suppressWarnings(.a("S1 = 1\nS2=1", c("scale1 <- 1", "scale2 <- 1"), abbrevLin = 1L))
  .a("S1 = 1\nS2=1", c("scale1 <- 1", "scale2 <- 1"), abbrevLin = 2L)
  suppressWarnings(.a("S1 = 1\nS2=1\nS3=1", c("scale1 <- 1", "scale2 <- 1", "scale3 <- 1"), abbrevLin = 2L))
  .a("S0=1", "scale0 <- 1")
  .a("A1=A(1)", "A1 <- rxddta1")
  .a("A1=A(1)", "A1 <- central", abbrevLin = 1L)
  .a("A1=A(1)", "A1 <- depot", abbrevLin = 2L)
  .a("A1=A(1)", "A1 <- rxddta1", abbrevLin = 3L)
  .a("S1=1\nA1=A(1)", c("scale1 <- 1", "A1 <- rxddta1/scale1"), abbrevLin = 3L)
  .a("S2=1\nA1=A(1)", c("scale2 <- 1", "A1 <- rxddta1"), abbrevLin = 3L)
  .a("A1=A(1)", "A1 <- rxLinCmt1", abbrevLin = 4L)
  .a("S1=V\nA1=A(1)", c("scale1 <- V", "A1 <- rxLinCmt1/scale1"), abbrevLin = 4L)
  .a("A1=A(1)", "A1 <- dose(depot)*exp(-KA*tad(depot))", abbrevLin = 5L)
  .a("S1=V\nA1=A(1)", c("scale1 <- V", "A1 <- dose(depot)*exp(-KA*tad(depot))/scale1"), abbrevLin = 5L)
  .a("A2=A(2)", "A2 <- rxLinCmt1", abbrevLin = 5L)
  .a("S2=V\nA2=A(2)", c("scale2 <- V","A2 <- rxLinCmt1/scale2"), abbrevLin = 5L)

  expect_warning(.a("a=SIGMA(1, 1)", "A <- sigma.1.1"), "SIGMA")
  expect_warning(.a("a=OMEGA(1, 1)", "A <- omega.1.1"), "OMEGA")

  expect_warning(.a("a=SIGMA(1)", "A <- sigma.1."), "SIGMA")
  expect_warning(.a("a=OMEGA(1)", "A <- omega.1."), "OMEGA")

  expect_warning(.a("a=evid+3", "A <- nmevid + 3"), "evid")
  expect_warning(.a("a=sim+3", "A <- nmsim + 3"), "sim")
  expect_warning(.a("a=ipredSim+3", "A <- nmipredsim + 3"), "ipredSim")
  .a("a=D1", "A <- rxdur.rxddta1.")
  .a("a=F1", "A <- rxf.rxddta1.")
  .a("a=ALAG1", "A <- rxalag.rxddta1.")
  .a("a=R1", "A <- rxrate.rxddta1.")
  .a("a=SC", "A <- scalec")
  .a("a=SC", "A <- scale1", abbrevLin=1L)
  .a("a=SC", "A <- scale2", abbrevLin=2L)
  expect_warning(.a("SC=a","scalec <- A"), "'SC'")
  .a("a=S0", "A <- scale0")
  .a("a=SO", "A <- scale0")
  .a("S0=a", "scale0 <- A")
  .a("SO=asin(a)", "scale0 <- asin(A)")

  .a("IF (cmt .lt. 1 .or. cmt .eq. 10)  m=atan(2)",
     "if (CMT < 1 || CMT == 10) M <- atan(2)")

  .a("IF (MODE ==  4) ALAG1 = 1",
     c("if (MODE == 4) {",
       "rxalag.rxddta1. <- 1",
       "alag(rxddta1) <- rxalag.rxddta1.",
       "}"))

  expect_error(.a("F0=3"), "F0/FO")

  expect_warning(.a("SID=IREP", "SID <- irep"), "sim.id")


  .am <- function(abbrev, eq="no", abbrevLin=0L, extended=0L) {
    .clearNonmem2rx()
    # spoof parsed $model record
    .nonmem2rx$cmtName <- c("GUT", "CENTRAL", "PERI")
    .Call(`_nonmem2rx_trans_abbrev`, abbrev, '$PRED', abbrevLin, extended)
    expect_equal(.nonmem2rx$model, eq)
  }

  .am("DADT(GUT)=-KA*A(GUT)",
      "d/dt(rxddta1) <-  - KA * rxddta1")

  .am("DADT(CENTRAL)=KA*A(GUT)-(KCP+KC0)*A(CENTRAL)+KPC*A(PERI)",
      "d/dt(rxddta2) <- KA * rxddta1 - (KCP + KC0) * rxddta2 + KPC * rxddta3")

  .am("DADT(PERI)=KCP*A(CENTRAL)-KPC*A(PERI)",
      "d/dt(rxddta3) <- KCP * rxddta2 - KPC * rxddta3")

  .am("A_0(PERI)=3",
      c("rxini.rxddta3. <- 3",  "rxddta3(0) <- rxini.rxddta3."))

  .at <- function(abbrev, eq="no", abbrevLin=0L, extended=0L) {
    .clearNonmem2rx()
    # spoof parsed $theta record
    .nonmem2rx$thetaNonmemLabel <- c("CL", "V", "KA")
    .Call(`_nonmem2rx_trans_abbrev`, abbrev, '$PRED', abbrevLin, extended=extended)
    expect_equal(.nonmem2rx$model, eq)
  }
  .at("test = THETA(CL) + THETA(V) + THETA(KA)",
      "TEST <- theta1 + theta2 + theta3")
  expect_error(.at("test = THETA(FUN)"),
               "FUN")

  .ae <- function(abbrev, eq="no", abbrevLin=0L, extended=0L) {
    .clearNonmem2rx()
    # spoof parsed $theta record
    .nonmem2rx$etaNonmemLabel <- c("ECL", "EV", "EKA")
    .Call(`_nonmem2rx_trans_abbrev`, abbrev, '$PRED', abbrevLin, extended=extended)
    expect_equal(.nonmem2rx$model, eq)
  }

  .ae("test = ETA(ECL) + ETA(EV) + ETA(EKA)",
      "TEST <- eta1 + eta2 + eta3")
  expect_error(.ae("test = ETA(FUN)"),
               "FUN")

  .ar <- function(abbrev, eq="no", abbrevLin=0L, extended=0L) {
    .clearNonmem2rx()
    # spoof parsed $theta record
    .nonmem2rx$epsNonmemLabel <- c("PROP", "ADD")
    .Call(`_nonmem2rx_trans_abbrev`, abbrev, '$PRED', abbrevLin, extended)
    expect_equal(.nonmem2rx$model, eq)
  }

  .ar("test = ERR(ADD) + EPS(PROP)",
      "TEST <- eps2 + eps1")

  expect_error(.ar("test = ERR(EASY) + EPS(PROP)",
                   "TEST <- eps2 + eps1"), "EASY")

  # now testing extended control stream
  .ae <- function(abbrev, eq="no", lhs, abbrevLin=0L, extended=1L,
                  lhsDef=NULL) {
    .clearNonmem2rx()
    # spoof parsed $theta record
    .nonmem2rx$theta <- c("popE0", "popEMAX", "popEC50")
    .nonmem2rx$etaLabel <- c("etaE0", "etaEMAX", "etaEC50")
    .nonmem2rx$epsLabel <- "errSD"
    .nonmem2rx$lhsDef <- lhsDef
    .Call(`_nonmem2rx_trans_abbrev`, abbrev, '$PRED', abbrevLin, extended)
    expect_equal(.nonmem2rx$lhsDef, lhs)
    expect_equal(.nonmem2rx$model, eq)
  }
  .ae("E0=pope0*EXP(etae0)", "E0 <- theta1 * exp(eta1)", "E0")
  .ae("EMAX=popemax*EXP(etaemax)", "EMAX <- theta2 * exp(eta2)", "EMAX")
  .ae("EC50=popec50*EXP(etaec50)", "EC50 <- theta3 * exp(eta3)", "EC50")
  .ae("Y = E0 + EMAX*THEO/(THEO+EC50) + errsd", "Y <- E0 + EMAX * THEO / (THEO + EC50) + eps1",
      c("E0", "EMAX", "EC50", "Y"), lhsDef = c("E0", "EMAX", "EC50"))
  .ae("pope0=pope0*EXP(etae0)", "POPE0 <- theta1 * exp(eta1)", "pope0")
  # test if1
  .ae("IF (EMAX>0) pope0=pope0*EXP(etae0)", "if (EMAX > 0) POPE0 <- theta1 * exp(eta1)", "pope0")
  withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE),{
    .ext <- nonmem2rx(system.file("TheopdExt.ctl", package="nonmem2rx"), extended=TRUE, save=FALSE)
    .nonExt <- nonmem2rx(system.file("Theopd.ctl", package="nonmem2rx"), save=FALSE)
    .ext1 <- sub("extended", "compare", deparse(as.function(.ext)))
    .ext2 <- sub("standard", "compare",deparse(as.function(.nonExt)))
    expect_equal(.ext1, .ext2)
  })

  # now test dups
  .ae <- function(abbrev, eq="no", lhs, abbrevLin=0L, extended=1L,
                  lhsDef=NULL) {
    .clearNonmem2rx()
    # spoof parsed $theta record
    .nonmem2rx$theta <- c("popE0", "popE0", "popEC50")
    .nonmem2rx$etaLabel <- c("etaE0", "etaE0", "etaEC50")
    .nonmem2rx$epsLabel <- "errSD"
    .nonmem2rx$lhsDef <- lhsDef
    .Call(`_nonmem2rx_trans_abbrev`, abbrev, '$PRED', abbrevLin, extended)
    expect_equal(.nonmem2rx$lhsDef, lhs)
    expect_equal(.nonmem2rx$model, eq)
  }

  .ae("E0=pope0*EXP(etae0)", "E0 <- POPE0 * exp(ETAE0)", "E0")


  .ifelse <- paste(c(" IF (PMAW.LT.40) THEN",
                     "   K=0.33",
                     " ELSE",
                     "   IF (AGE.LT.1) THEN",
                     "     K=0.45",
                     "   ELSE",
                     "     IF (M1F0.EQ.1.AND.AGE.GE.13) THEN",
                     "       K=0.7",
                     "     ELSE",
                     "       K=0.55",
                     "      ENDIF",
                     "   ENDIF",
                     " ENDIF"), collapse="\n")

  .a <- function(abbrev, eq="no", abbrevLin=0L, extended=0L) {
    .clearNonmem2rx()
    .Call(`_nonmem2rx_setRecord`, "$PRED")
    .Call(`_nonmem2rx_trans_abbrev`, abbrev, '$PRED', abbrevLin, extended)
    expect_equal(.nonmem2rx$model, eq)
  }

  .a(.ifelse,
     c("if (PMAW < 40) {",
       "K <- 0.33",
       "} else {",
       "if (AGE < 1) {",
       "K <- 0.45",
       "} else {",
       "if (M1F0 == 1 && AGE >= 13) {",
       "K <- 0.7",
       "} else {",
       "K <- 0.55",
       "}",
       "}",
       "}"))

})

test_that("abbrev #188", {

  m <- "$PROBLEM 1cmptIVmodelCov
  $DATA ..\\data.csv IGNORE=@
  $INPUT ID TIME AMT DV
  $SUBROUTINE ADVAN1 TRANS2
  $ABBR REPLACE ETA_CL=ETA(1)
  $ABBR REPLACE ETA_VC=ETA(2)
  $PK
  TVCL = THETA(1)
  TVV = THETA(2)
  CL = TVCL*EXP(ETA_CL)
  VC = TVV*EXP(ETA_VC)
  V = VC
  S1 = VC

  $ERROR
  Y = F + F*EPS(1)

  $THETA  (0,0.00469307) ; POP_CL
  $THETA  (0,1.00916) ; POP_VC

  $OMEGA  0.0309626 ; IIV_CL
  $OMEGA  0.031128 ; IIV_VC

  $SIGMA  0.0130865  ; SIGMA

  $ESTIMATION METHOD=1 INTERACTION MAXEVALS=99999
  $TABLE ID TIME DV CIPREDI PRED RES CWRES NOAPPEND NOPRINT ONEHEADER FILE=res.tab"

  expect_error(nonmem2rx(m), NA)

})

test_that("abbrev #190", {

  m <- "$PROBLEM 1cmptIVmodelCov
  $DATA ..\\data.csv IGNORE=@
  $INPUT ID TIME AMT DV
  $SUBROUTINE ADVAN1 TRANS2
  $ABBR REPLACE ETA_CL=ETA(1)
  $ABBR REPLACE ETA_VC=ETA(2)
  $PK
  TVCL = THETA(1)
  TVV = THETA(2)
  CL = TVCL*EXP(ETA_CL)
  VC = TVV*EXP(ETA_VC)
  V = VC
  S1 = VC
  EXPP = DEXP(THETA(3))

  F1=EXP(EXPP)/(1+EXP(EXPP))
  IF (DSCOL.EQ.2) F1 = 1
  IF (DSCOL.EQ.3) F1 = 1

  $ERROR (ONLY OBS)
  Y = F + F*EPS(1)

  $THETA  (0,0.00469307) ; POP_CL
  $THETA  (0,1.00916) ; POP_VC
  $THETA  (0,1) ; POP_EXP

  $OMEGA  0.0309626 ; IIV_CL
  $OMEGA  0.031128 ; IIV_VC

  $SIGMA  0.0130865  ; SIGMA

  $ESTIMATION METHOD=1 INTERACTION MAXEVALS=99999
  $TABLE ID TIME DV CIPREDI PRED RES CWRES NOAPPEND NOPRINT ONEHEADER FILE=res.tab"

  expect_error(nonmem2rx(m), NA)

})
