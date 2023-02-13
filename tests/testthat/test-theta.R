test_that("test thetas", {
  
  .t <- function(theta, eq="no", len=-1) {
    .clearNonmem2rx()
    .Call(`_nonmem2rx_thetanum_reset`)
    lapply(theta, function(x) {
      .Call(`_nonmem2rx_trans_theta`, x) 
    })
    expect_equal(.nonmem2rx$ini, eq)
    expect_length(.nonmem2rx$thetaNonmemLabel, len)
    expect_length(.nonmem2rx$theta, len)
  }

  .t("1", "theta1 <- 1", 1)
  
  .t("1 ; clearance\n", c("theta1 <- 1", "label(\"clearance\")"), 1)
  .t("(1 fix)", "theta1 <- fix(1)", 1)
  .t("(1) FIXED", "theta1 <- fix(1)", 1)
  .t("(1, 2.0) FIXED", "theta1 <- fix(1, 2.0)", 1)
  .t("(1, 2.0 fix)", "theta1 <- fix(1, 2.0)", 1)
  .t("(1, 2.0)", "theta1 <- c(1, 2.0)", 1)
  .t("(1, 2.0, 3.0)", "theta1 <- c(1, 2.0, 3.0)", 1)
  .t("(1, 2.0, 3.0 fix)", "theta1 <- fix(1, 2.0, 3.0)", 1)
  .t("(1, 2.0, 3.0) fix", "theta1 <- fix(1, 2.0, 3.0)", 1)
  
  expect_warning(.t("(1,, 3.0)", "theta1 <- c(1, 2, 3.0)", 1))
  
  expect_warning(.t("NUMBERPOINTS = 3", NULL, 0))
  expect_warning(.t("NOABORT", NULL, 0))

  .t("(.1,3,5) (.008,.08,.5) (.004,.04,.9)",
     c("theta1 <- c(.1, 3, 5)",
       "theta2 <- c(.008, .08, .5)",
       "theta3 <- c(.004, .04, .9)"), 3)

  expect_error(.t("garbage"))

})
