test_that("test thetas", {
  
  .t <- function(theta, eq="no") {
    requireNamespace("dparser")
    .clearNonmem2rx()
    .Call(`_nonmem2rx_thetanum_reset`)
    .Call(`_nonmem2rx_trans_theta`, theta)
    expect_equal(.nonmem2rx$ini, eq)
  }

  .t("(1 fix)", "theta1 <- fix(1)")
  .t("(1) FIXED", "theta1 <- fix(1)")
  .t("(1, 2.0) FIXED", "theta1 <- fix(1, 2.0)")
  .t("(1, 2.0 fix)", "theta1 <- fix(1, 2.0)")
  .t("(1, 2.0)", "theta1 <- c(1, 2.0)")
  .t("(1, 2.0, 3.0)", "theta1 <- c(1, 2.0, 3.0)")
  .t("(1, 2.0, 3.0 fix)", "theta1 <- fix(1, 2.0, 3.0)")
  .t("(1, 2.0, 3.0) fix", "theta1 <- fix(1, 2.0, 3.0)")
  expect_warning(.t("(1,, 3.0)", "theta1 <- c(1, 2, 3.0)"))
  expect_warning(.t("NUMBERPOINTS = 3", NULL))
  expect_warning(.t("NOABORT", NULL))
})
