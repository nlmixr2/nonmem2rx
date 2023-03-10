test_that("test thetas", {

  .t <- function(theta, eq="no", len=-1, unintFixed=TRUE) {
    .Call(`_nonmem2rx_setRecord`, "$THETA")
    .clearNonmem2rx()
    .Call(`_nonmem2rx_thetanum_reset`)
    lapply(theta, function(x) {
      .Call(`_nonmem2rx_trans_theta`, x, as.integer(unintFixed))
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
  .t("(20,  FIX)", "theta1 <- fix(20)", 1)
  .t("(20,  , FIX)", "theta1 <- fix(20)", 1)
  .t("(20,  , ) FIX", "theta1 <- fix(20)", 1)

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

  .t("(1 UNINT)", "theta1 <- fix(1)", 1)
  .t("(1) UNINT", "theta1 <- fix(1)", 1)
  .t("(0, 1) UNINT", "theta1 <- fix(0, 1)", 1)
  .t("(0, 1 UNINT) ", "theta1 <- fix(0, 1)", 1)
  .t("(0, 1, 2) UNINT", "theta1 <- fix(0, 1, 2)", 1)
  .t("(0, 1, 2 UNINT)", "theta1 <- fix(0, 1, 2)", 1)

  .t("(1 UNINT)", "theta1 <- 1", 1, unintFixed=FALSE)
  .t("(1) UNINT", "theta1 <- 1", 1, unintFixed=FALSE)
  .t("(0, 1) UNINT", "theta1 <- c(0, 1)", 1, unintFixed=FALSE)
  .t("(0, 1 UNINT) ", "theta1 <- c(0, 1)", 1, unintFixed=FALSE)
  .t("(0, 1, 2) UNINT", "theta1 <- c(0, 1, 2)", 1, unintFixed=FALSE)
  .t("(0, 1, 2 UNINT)", "theta1 <- c(0, 1, 2)", 1, unintFixed=FALSE)


  .t("NAMES(V1,CL,Q,V2) (0.0,7.0) (0.0,7.0) (0.0,7.0) 7",
     c("theta1 <- c(0.0, 7.0)",
       "theta2 <- c(0.0, 7.0)",
       "theta3 <- c(0.0, 7.0)",
       "theta4 <- 7"), 4)

  expect_equal(.nonmem2rx$thetaNonmemLabel,
               c("V1", "CL", "Q", "V2"))

  expect_warning(
    .t("NAMES(V1,CL,Q,V2) V20=(0.0,7.0) (0.0,7.0) (0.0,7.0) 7",
       c("theta1 <- c(0.0, 7.0)",
         "theta2 <- c(0.0, 7.0)",
         "theta3 <- c(0.0, 7.0)",
         "theta4 <- 7"), 4), "V20")


  .t("NAMES(V1,CL,Q,V2) (0.0,7.0) (0.0,7.0) (0.0,7.0) 7 V30=8",
       c("theta1 <- c(0.0, 7.0)",
         "theta2 <- c(0.0, 7.0)",
         "theta3 <- c(0.0, 7.0)",
         "theta4 <- 7",
         "theta5 <- 8"), 5)

    expect_equal(.nonmem2rx$thetaNonmemLabel,
                 c("V1", "CL", "Q", "V2", "V30"))

    .t("NAMES(V1,CL,Q,V2) (0.0,7.0) (0.0,7.0) (0.0,7.0) 7 8",
       c("theta1 <- c(0.0, 7.0)",
         "theta2 <- c(0.0, 7.0)",
         "theta3 <- c(0.0, 7.0)",
         "theta4 <- 7",
         "theta5 <- 8"), 5)

        expect_equal(.nonmem2rx$thetaNonmemLabel,
                     c("V1", "CL", "Q", "V2", ""))

        expect_error(.t("NAMES(V1,CL,Q,V2) (0.0,7.0) (0.0,7.0) (0.0,7.0)",
                        c("theta1 <- c(0.0, 7.0)",
                          "theta2 <- c(0.0, 7.0)",
                          "theta3 <- c(0.0, 7.0)"), 3))

  expect_error(.t("garbage"))

})
