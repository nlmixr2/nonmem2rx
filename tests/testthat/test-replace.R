test_that("test replacement", {

  .r <- function(abbrev, code="", eq="no") {
    .clearNonmem2rx()
    .Call(`_nonmem2rx_setRecord`, "$ABBREV")
    .nonmem2rx$input <- c(OCC="OCC",SID="SID", DOSN="DOSN")
    if (length(code) != 1) code <-paste(code, collapse="\n")
    if (length(eq) != 1) eq <-paste(eq, collapse="\n")
    lapply(abbrev, function(a) {
      .Call(`_nonmem2rx_trans_abbrec`, a)
    })
    .ret <- .replaceAbbrevCode(code)
    expect_equal(.replaceAbbrevCode(code), eq)
  }

  .r(c("REPLACE A(DEPOT)=A(1)",
       "REPLACE DADT(DEPOT)=DADT(1)"),
     "DADT(DEPOT)=-KA*A(DEPOT)",
     "DADT(1)=-KA*A(1)")

  .r("REPLACE THETA(OCC)=THETA(4,7)",
     "TVCL=THETA(OCC)",
     c("IF (OCC.EQ.1) TVCL=THETA(4)",
       "IF (OCC.EQ.2) TVCL=THETA(7)"))

  .r(c("REPLACE THETA(SID_KA)=THETA(4,6)",
       "REPLACE THETA(SID_CL)=THETA(5,7)"),
     c("KA=THETA(SID_KA)",
       "CL=THETA(SID_CL)"),
     c("IF (SID.EQ.1) KA=THETA(4)",
       "IF (SID.EQ.2) KA=THETA(6)",
       "IF (SID.EQ.1) CL=THETA(5)",
       "IF (SID.EQ.2) CL=THETA(7)"))

  .r(c("REPLACE ETA(OCC_CL)=ETA(5,3)",
       "REPLACE ETA(OCC_V) =ETA(6,4)"),
     c("CL=TVCL*EXP(ETA(1)+ETA(OCC_CL))",
       "V =TVV *EXP(ETA(2)+ETA(OCC_V))"),
     c("IF (OCC.EQ.1) CL=TVCL*EXP(ETA(1)+ETA(5))",
       "IF (OCC.EQ.2) CL=TVCL*EXP(ETA(1)+ETA(3))",
       "IF (OCC.EQ.1) V =TVV *EXP(ETA(2)+ETA(6))",
       "IF (OCC.EQ.2) V =TVV *EXP(ETA(2)+ETA(4))"))

  .r("REPLACE THETA(CL,V1,Q,V2)=THETA(1,2,3,4)",
     "ME= THETA(CL)+THETA(V1)+THETA(Q)+THETA(V2)",
     "ME= THETA(1)+THETA(2)+THETA(3)+THETA(4)")

  .r("REPLACE ETA(DOSN)=ETA(0,2,3)",
     c("F1=1",
       "IF (DOSN>1) F1=1*EXP(ETA(DOSN))"),
     c("F1=1",
       "IF (DOSN.EQ.2) F1=1*EXP(ETA(2))",
       "IF (DOSN.EQ.3) F1=1*EXP(ETA(3))"))

  .r("REPLACE ETA(DOSN_F1)=ETA(0,2,3)",
     c("F1=1",
       "IF (DOSN>1) F1=1*EXP(ETA(DOSN_F1))"),
     c("F1=1",
       "IF (DOSN.EQ.2) F1=1*EXP(ETA(2))",
       "IF (DOSN.EQ.3) F1=1*EXP(ETA(3))"))

  .r("REPLACE ETA(F1_DOSN)=ETA(0,2,3)",
     c("F1=1",
       "IF (DOSN>1) F1=1*EXP(ETA(F1_DOSN))"),
     c("F1=1",
       "IF (DOSN.EQ.2) F1=1*EXP(ETA(2))",
       "IF (DOSN.EQ.3) F1=1*EXP(ETA(3))"))

  .r("REPLACE ETA(DOSN)=ETA(0,2,5)",
     c("F1=1",
       "IF (DOSN>2) F1=1*EXP(ETA(DOSN))"),
     c("F1=1",
       "IF (DOSN.EQ.3) F1=1*EXP(ETA(5))"))

  .r("REPLACE ETA(DOSN_F1)=ETA(0,2,5)",
     c("F1=1",
       "IF (DOSN>2) F1=1*EXP(ETA(DOSN_F1))"),
     c("F1=1",
       "IF (DOSN.EQ.3) F1=1*EXP(ETA(5))"))

  .r("REPLACE ETA(F1_DOSN)=ETA(0,2,5)",
     c("F1=1",
       "IF (DOSN>2) F1=1*EXP(ETA(F1_DOSN))"),
     c("F1=1",
       "IF (DOSN.EQ.3) F1=1*EXP(ETA(5))"))

  expect_warning(.r("REPLACE ETA(DOSN)=ETA(0,2,3)",
                    c("F1=1",
                      "IF (DOSN>2 .AND. BAD .EQ. 3) F1=1*EXP(ETA(DOSN))"),
                    c("F1=1",
                      "IF (DOSN>2 .AND. BAD .EQ. 3) F1=1*EXP(ETA(DOSN))")), "DOSN")

  expect_warning(.r("REPLACE ETA(DOSN_F1)=ETA(0,2,3)",
                    c("F1=1",
                      "IF (DOSN>2 .AND. BAD .EQ. 3) F1=1*EXP(ETA(DOSN_F1))"),
                    c("F1=1",
                      "IF (DOSN>2 .AND. BAD .EQ. 3) F1=1*EXP(ETA(DOSN_F1))")), "DOSN")

  .r("REPLACE ETA(DOSN)=ETA(0,2,3)",
     c("F1=1",
       "IF (DOSN>1 .AND. DOSN < 3) F1=1*EXP(ETA(DOSN))"),
     c("F1=1",
       "IF (DOSN.EQ.2) F1=1*EXP(ETA(2))"))

  .r("REPLACE ETA(DOSN_F1)=ETA(0,2,3)",
     c("F1=1",
       "IF (DOSN>1 .AND. DOSN < 3) F1=1*EXP(ETA(DOSN_F1))"),
     c("F1=1",
       "IF (DOSN.EQ.2) F1=1*EXP(ETA(2))"))


  .r("REPLACE ETA(DOSN_CONFOUND_F1)=ETA(0,2,3)",
     c("F1=1",
       "IF (DOSN>1 .AND. DOSN < 3) F1=1*EXP(ETA(DOSN_CONFOUND_F1))"),
     c("F1=1",
       "IF (DOSN.EQ.2) F1=1*EXP(ETA(2))"))


  .r("REPLACE ETA(DOSN_CONFOUND_F1)=ETA(0,2,3)",
     c("F1=1",
       "IF (DOSN>1 .AND. DOSN < 3) F1=1*EXP(ETA(DOSN_CONFOUND_F1))+34"),
     c("F1=1",
       "IF (DOSN.EQ.2) F1=1*EXP(ETA(2))+34"))
  expect_error(.r("REPLACE ETA(NOINP)=ETA(0,2,3)"), "NOINP")

  .r(c("REPLACE ETA(OCC_ETA_BOV_CL)=ETA(5,9)", 
       "REPLACE ETA(OCC_ETA_BOV_V)=ETA(6,10)",
       "REPLACE ETA(OCC_ETA_BOV_KA)=ETA(7,11)", 
       "REPLACE ETA(OCC_ETA_BOV_TL)=ETA(8,12)"),
     c("; Could maybe do something like this:",
       "ETA_BOV_CL = ETA(OCC_ETA_BOV_CL)",
       "ETA_BOV_V = ETA(OCC_ETA_BOV_V)",
       "ETA_BOV_KA = ETA(OCC_ETA_BOV_KA)",
       "ETA_BOV_TL = ETA(OCC_ETA_BOV_TL)"),
     c("; Could maybe do something like this:",
       "IF (OCC.EQ.1) ETA_BOV_CL = ETA(5)",
       "IF (OCC.EQ.2) ETA_BOV_CL = ETA(9)",
       "IF (OCC.EQ.1) ETA_BOV_V = ETA(6)",
       "IF (OCC.EQ.2) ETA_BOV_V = ETA(10)",
       "IF (OCC.EQ.1) ETA_BOV_KA = ETA(7)",
       "IF (OCC.EQ.2) ETA_BOV_KA = ETA(11)",
       "IF (OCC.EQ.1) ETA_BOV_TL = ETA(8)",
       "IF (OCC.EQ.2) ETA_BOV_TL = ETA(12)"))

  .r(c("REPLACE ETA(OCC_ETA_BOV_CL)=ETA(5,9)", 
       "REPLACE ETA(OCC_ETA_BOV_V)=ETA(6,10)",
       "REPLACE ETA(OCC_ETA_BOV_KA)=ETA(7,11)", 
       "REPLACE ETA(OCC_ETA_BOV_TL)=ETA(8,12)"),
     c("CL = EXP(MU_1 + ETA(1)+ ETA(OCC_ETA_BOV_CL));",
       "V = EXP(MU_2 + ETA(2)+ ETA(OCC_ETA_BOV_V));",
       "KA = EXP(MU_3 + ETA(3)+ ETA(OCC_ETA_BOV_KA));",
       "TL = EXP(MU_4 + ETA(4)+ ETA(OCC_ETA_BOV_TL));"),
     c("IF (OCC.EQ.1) CL = EXP(MU_1 + ETA(1)+ ETA(5));",
       "IF (OCC.EQ.2) CL = EXP(MU_1 + ETA(1)+ ETA(9));",
       "IF (OCC.EQ.1) V = EXP(MU_2 + ETA(2)+ ETA(6));",
       "IF (OCC.EQ.2) V = EXP(MU_2 + ETA(2)+ ETA(10));",
       "IF (OCC.EQ.1) KA = EXP(MU_3 + ETA(3)+ ETA(7));",
       "IF (OCC.EQ.2) KA = EXP(MU_3 + ETA(3)+ ETA(11));",
       "IF (OCC.EQ.1) TL = EXP(MU_4 + ETA(4)+ ETA(8));",
       "IF (OCC.EQ.2) TL = EXP(MU_4 + ETA(4)+ ETA(12));"))

})
