test_that("test omega", {
  
  .o <- function(omega, eq="no") {
    requireNamespace("dparser")
    .clearNonmem2rx()
    .Call(`_nonmem2rx_omeganum_reset`)
    .Call(`_nonmem2rx_trans_omega`, omega, "eta")
    expect_equal(.nonmem2rx$ini, eq)
  }

  .o("1", "eta1 ~ 1")

})
