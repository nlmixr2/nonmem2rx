test_that("test abbrev", {
  
  .a <- function(abbrev, eq="no", reset=TRUE) {
    .clearNonmem2rx()
    .Call(`_nonmem2rx_trans_abbrev`, abbrev, '$PRED')
    expect_equal(.nonmem2rx$model, eq)
  }
  
  .a("TVCL    = matt", "TVCL <- matt")
  .a("TVCL    = matt+3",
     "TVCL <- matt + 3")
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
    expect_error(.a("A = ICALL"), "'ICALL'")
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
    expect_error(.a("\"FIRST"), "Verbatim")
    expect_error(.a("EXIT 1 2"), "'EXIT # #'")
    expect_error(.a("IF (B .LT. 0) EXIT 1 2"), "'IF \\(\\) EXIT # #'")
    expect_warning(.a("COMRES = -1", NULL), "'COMRES = -1' ignored")
    expect_warning(.a("CALLFL = -1", NULL), "'CALLFL = ' ignored")
    expect_error(.a("CALL PASS(MODE)"), "'CALL PASS")
    expect_error(.a("CALL SUPP(0 , 1)"), "'CALL SUPP")
    expect_error(.a("CALL RANDOM(1, R)"), "'CALL RANDOM")
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
       "d/dt(a1) <-  - KEL * a1")
    expect_error(.a("DA(1, 2) = -KEL*A(1)"), "DA[(]#, #[)]")
    expect_error(.a("DP(1, 2) = -KEL*A(1)"), "DP[(]#, #[)]")

    # cmt properties
    .a("A_0(1) = 1","a1(0) <- 1")
    .a("F1 = 1","f(a1) <- 1")
    .a("R1 = 1","rate(a1) <- 1")
    .a("D1 = 1","dur(a1) <- 1")
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
    .a("x=time", "x <- t")
    .a("x=t", "x <- nm_t")
})
