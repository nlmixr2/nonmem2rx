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

  .t("(2)x4 (0.001,0.1,1000)x3 (0.5 FIXED)x2",
     c("theta1 <- 2", "theta2 <- 2", "theta3 <- 2", "theta4 <- 2",
       "theta5 <- c(0.001, 0.1, 1000)", "theta6 <- c(0.001, 0.1, 1000)", "theta7 <- c(0.001, 0.1, 1000)",
       "theta8 <- fix(0.5)", "theta9 <- fix(0.5)"), 9)

  .t("CL=(0.0,7.0)", "theta1 <- c(0.0, 7.0)", 1)
  expect_equal(.nonmem2rx$thetaNonmemLabel, "CL")

  .t("CL= 0.3\nV1= 0.35\nQ=  0.54\nV2= 0.67",
     c("theta1 <- 0.3", "theta2 <- 0.35", "theta3 <- 0.54", "theta4 <- 0.67"),
     4)

  expect_equal(.nonmem2rx$thetaNonmemLabel, c("CL", "V1", "Q", "V2"))

  expect_error(.t("garbage"))

})
