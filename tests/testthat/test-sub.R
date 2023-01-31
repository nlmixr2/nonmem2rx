test_that("test sub", {

  .s <- function(sub, eq="no") {
    .clearNonmem2rx()
    nonmem2rxRec.sub(sub)
    expect_equal(c(advan=.nonmem2rx$advan, trans=.nonmem2rx$trans, abbrevLin=.nonmem2rx$abbrevLin), eq)
  }

  .s("ADVAN1 TRANS1", c(advan=1L, trans=1L, abbrevLin=1L))
  .s("ADVAN1 TRANS2", c(advan=1L, trans=2L, abbrevLin=1L))
  .s("ADVAN=ADVAN1 TRANS=TRANS2", c(advan=1L, trans=2L, abbrevLin=1L))
  .s("ADVAN=ADVAN2 TRANS=TRANS2", c(advan=2L, trans=2L, abbrevLin=2L))
  expect_error(.s("ADVAN1 TRANS3"), "ADVAN1 does not support TRANS3")
  expect_error(.s("ADVAN20"), "Unsupported ADVAN20")
  expect_error(.s("ADVAN7"), "General Linear model translation not supported")
  expect_error(.s("ADVAN9"), "Differential Algebra Equations")
  expect_error(.s("ADVAN15"), "Differential Algebra Equations")
  expect_error(.s("INFN=matt.f"), "SUBROUTINES 'INFN'")
  expect_error(.s("TOL=matt.f"), "SUBROUTINES 'TOL'")
  expect_warning(.s("ADVAN13 TOL=10", c(advan=13L, trans=0L, abbrevLin=0L)),
                 "SUBROUTINES TOL=")  
})
