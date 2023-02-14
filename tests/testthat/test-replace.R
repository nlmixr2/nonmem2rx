test_that("test replacement", {

  .r <- function(abbrev, code, eq="no") {
    .clearNonmem2rx()
    .nonmem2rx$input <- c(OCC="OCC",SID="SID")
    if (length(code) != 1) code <-paste(code, collapse="\n")
    if (length(eq) != 1) eq <-paste(eq, collapse="\n")
    lapply(abbrev, function(a) {
      .Call(`_nonmem2rx_trans_abbrec`, a)
    })
    .ret <- .replaceAbbrevCode(code)
    message(.ret)
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
  
})
