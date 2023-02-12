test_that("test omega", {
  
  .o <- function(omega, eq="no", reset=TRUE) {
    .clearNonmem2rx()
    if (reset) .Call(`_nonmem2rx_omeganum_reset`)
    .Call(`_nonmem2rx_trans_omega`, omega, "eta")
    expect_equal(.nonmem2rx$ini, eq)
  }

  .o("1", "eta1 ~ 1")
  .o("(1 fix)", "eta1 ~ fix(1)")
  .o("(fix 1)", "eta1 ~ fix(1)")
  .o("BLOCK(3) 6. .005 .3 .0002 .006 .4 fix",
     "eta1 + eta2 + eta3 ~ fix(6., .005, .3, .0002, .006, .4)")
  .o("BLOCK(3) 6. .005 .3 .0002 .006 .4",
     "eta4 + eta5 + eta6 ~ c(6., .005, .3, .0002, .006, .4)", reset=FALSE)
  .o("BLOCK SAME",
     "eta7 + eta8 + eta9 ~ fix(6., .005, .3, .0002, .006, .4)", reset=FALSE)
  .o("BLOCK(2) 6. .005 .3",
     "eta10 + eta11 ~ c(6., .005, .3)", reset=FALSE)
  .o("BLOCK SAME",
     "eta12 + eta13 ~ fix(6., .005, .3)", reset=FALSE)
  .o("BLOCK(2) SAME",
     "eta14 + eta15 ~ fix(6., .005, .3)", reset=FALSE)
  expect_error(.o("BLOCK(3) SAME", reset=FALSE), "BLOCK")
  expect_error(.o("BLOCK SAME"))
  expect_error(.o("BLOCK(3) 6. .005 .3 .0002 .006 (.4)"))
  expect_error(.o("BLOCK(3) 6. .005 .3 .0002 .006"))
  expect_error(.o("BLOCK(3) 6. .005 .3 .0002 .006 .4 .4"))
  expect_error(.o("BLOCK(3) 6. .005 .3 .0002 .006 (fix .4)"))
  expect_warning(.o("DIAGONAL(1) 1", "eta1 ~ 1"))

  .o(" BLOCK(6)\n 0.1\n0.01 0.1\n(0.01)x2 0.1\n(0.01)x3 0.1\n(0.01)x4 0.1\n(0.01)x5 0.1",
     "eta1 + eta2 + eta3 + eta4 + eta5 + eta6 ~ c(0.1, 0.01, 0.1, 0.01, 0.1, 0.1, 0.01, 0.1, 0.1, 0.1, 0.01, 0.1, 0.1, 0.1, 0.1, 0.01, 0.1, 0.1, 0.1, 0.1, 0.1)")

  .o("(0.01)x3 0.1",c("eta1 ~ 0.01", "eta2 ~ 0.01", "eta3 ~ 0.01", "eta4 ~ 0.1"))

  .o("(0.01 FIX)x3 0.1",c("eta1 ~ fix(0.01)", "eta2 ~ fix(0.01)", "eta3 ~ fix(0.01)", "eta4 ~ 0.1"))

  .o("(FIX 0.01)x3 0.1",c("eta1 ~ fix(0.01)", "eta2 ~ fix(0.01)", "eta3 ~ fix(0.01)", "eta4 ~ 0.1"))


  .o("BLOCK(2) 6. .005 .3",
     "eta1 + eta2 ~ c(6., .005, .3)", reset=TRUE)

  .o("BLOCK SAME(2)",
     c("eta3 + eta4 ~ fix(6., .005, .3)",
       "eta5 + eta6 ~ fix(6., .005, .3)"), reset=FALSE)

    .o("BLOCK(2) SAME(3)",
     c("eta7 + eta8 ~ fix(6., .005, .3)",
       "eta9 + eta10 ~ fix(6., .005, .3)",
       "eta11 + eta12 ~ fix(6., .005, .3)"), reset=FALSE)

  expect_error(.o("garbage"))

  

})
