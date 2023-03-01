test_that("test sub", {

  .s <- function(sub, eq="no", tol=10, atol=12, ssTol=12, ssAtol=12) {
    .Call(`_nonmem2rx_setRecord`, "$SUB")
    .clearNonmem2rx()
    nonmem2rxRec.sub(sub)
    expect_equal(c(advan=.nonmem2rx$advan, trans=.nonmem2rx$trans, abbrevLin=.nonmem2rx$abbrevLin), eq)
    expect_equal(.nonmem2rx$rtol, 10^(-tol))
    expect_equal(.nonmem2rx$atol, 10^(-atol))
    expect_equal(.nonmem2rx$ssRtol, 10^(-ssTol))
    expect_equal(.nonmem2rx$ssAtol, 10^(-ssAtol))
  }

  expect_error(.s("tranvan1"))

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
  expect_error(.s("ATOL=matt.f"), "SUBROUTINES 'ATOL'")
  expect_error(.s("SSATOL=matt.f"), "SUBROUTINES 'SSATOL'")

  #expect_error(.s("SSTOL=matt.f"), "SUBROUTINES 'SSTOL'")

  .s("ADVAN13 TOL=10", c(advan=13L, trans=0L, abbrevLin=0L),
     tol=10, ssTol=10)

  .s("ADVAN13 TOL=10 SSTOL=12", c(advan=13L, trans=0L, abbrevLin=0L),
     tol=10, ssTol=12)

  .s("ADVAN13 ATOL=10", c(advan=13L, trans=0L, abbrevLin=0L),
     tol=10, ssAtol=10)

  .s("ADVAN13 TOL=10 SSATOL=12", c(advan=13L, trans=0L, abbrevLin=0L),
     tol=10, ssAtol=12)

})
