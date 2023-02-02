test_that("test abbrev", {
  
  .a <- function(abbrev, eq="no", abbrevLin=0L) {
    .clearNonmem2rx()
    .Call(`_nonmem2rx_trans_abbrev`, abbrev, '$PRED', abbrevLin)
    expect_equal(.nonmem2rx$model, eq)
  }
  
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
    expect_error(.a("A = MIXNUM"), "'MIXNUM'")
    expect_error(.a("A = MIXEST"), "'MIXEST'")
    expect_warning(.a("A = ICALL", "A <- icall"), "icall")
    expect_error(.a("A = COMACT"), "'COMACT'")
    expect_error(.a("A = COMSAV"), "'COMSAV'")

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

    # Unsupported lines
    expect_warning(.a("\"FIRST", NULL), "Verbatim")
    expect_error(.a("EXIT 1 2"), "'EXIT # #'")
    expect_error(.a("IF (B .LT. 0) EXIT 1 2"), "'IF \\(\\) EXIT # #'")
    expect_warning(.a("COMRES = -1", NULL), "'COMRES = -1' ignored")
    expect_warning(.a("CALLFL = -1", NULL), "'CALLFL = ' ignored")
    expect_error(.a("CALL PASS(MODE)"), "'CALL PASS")
    expect_error(.a("CALL SUPP(0 , 1)"), "'CALL SUPP")
    .a("CALL RANDOM(1, R)", "R <- rxunif()")
    expect_error(.a("C=DT(3)"), "DT\\(#\\)")
    expect_error(.a("C=MTIME(3)"), "MTIME\\(#\\)")
    expect_error(.a("C=MNEXT(3)"), "MNEXT\\(#\\)")
    expect_error(.a("C=MPAST(3)"), "MPAST\\(#\\)")
    expect_error(.a("C=MIXP(3)"), "MIXP\\(#\\)")
    expect_error(.a("C=COM(3)"), "COM\\(#\\)")
    expect_error(.a("C=PCMT(3)"), "PCMT\\(#\\)")

    #d/dt() related lines

    .a("DADT(1) = -KEL*A(1)",
       # could look better but functional
       "d/dt(rxddta1) <-  - KEL * rxddta1")
    expect_error(.a("DA(1, 2) = -KEL*A(1)"), "DA[(]#, #[)]")
    expect_error(.a("DP(1, 2) = -KEL*A(1)"), "DP[(]#, #[)]")

    # cmt properties
    .a("A_0(1) = 1","rxddta1(0) <- 1")
    .a("F1 = 1","f(rxddta1) <- 1")
    .a("R1 = 1","rate(rxddta1) <- 1")
    .a("D1 = 1","dur(rxddta1) <- 1")
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
    .a("f1=1", "f(central) <- 1", abbrevLin=1L)
    .a("A_0(1) = 1","central(0) <- 1", abbrevLin=1L)
    .a("R1 = 1","rate(central) <- 1", abbrevLin=1L)
    .a("D1 = 1","dur(central) <- 1", abbrevLin=1L)
    .a("SC = 1","scale1 <- 1", abbrevLin=1L)
    expect_error(.a("f3=1", "f(central) <- 1", abbrevLin=1L), "central")

    .a("f1=1", "f(depot) <- 1", abbrevLin=2L)
    .a("A_0(1) = 1","depot(0) <- 1", abbrevLin=2L)
    .a("R1 = 1","rate(depot) <- 1", abbrevLin=2L)
    .a("D1 = 1","dur(depot) <- 1", abbrevLin=2L)
    .a("SC = 1","scale2 <- 1", abbrevLin=2L)
    .a("f2=1", "f(central) <- 1", abbrevLin=2L)
    .a("A_0(2) = 1","central(0) <- 1", abbrevLin=2L)
    .a("R2 = 1","rate(central) <- 1", abbrevLin=2L)
    .a("D2 = 1","dur(central) <- 1", abbrevLin=2L)
    expect_error(.a("f3=1", "f(central) <- 1", abbrevLin=2L), "central")
    expect_warning(.a("S1 = 1\nSC=1", c("scale1 <- 1", "scale1 <- 1"), abbrevLin=1L), "last defined")
    expect_warning(.a("S1 = 1\nS2=1", c("scale1 <- 1", "scale2 <- 1"), abbrevLin = 1L), "scale2 could be meaningless")
    .a("S1 = 1\nS2=1", c("scale1 <- 1", "scale2 <- 1"), abbrevLin = 2L)
    expect_warning(.a("S1 = 1\nS2=1\nS3=1", c("scale1 <- 1", "scale2 <- 1", "scale3 <- 1"), abbrevLin = 2L),
                   "scale3 could be meaningless")
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

    expect_error(.a("a=SIGMA(1, 1)"), "SIGMA[(]#, #[)]")
    expect_error(.a("a=OMEGA(1, 1)"), "OMEGA[(]#, #[)]")
    expect_warning(.a("a=evid+3", "A <- nmevid + 3"), "evid")
    
    .a("a=D1", "A <- dur(rxddta1)")
    .a("a=F1", "A <- f(rxddta1)")
    .a("a=ALAG1", "A <- alag(rxddta1)")
    .a("a=R1", "A <- rate(rxddta1)")

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

    expect_error(.a("F0=3"), "F0/FO")
    
})
