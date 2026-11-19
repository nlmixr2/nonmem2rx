test_that("THETA(#)/ETA(#) beyond $THETA/$OMEGA is an error, not a covariate", {
  .ctl <- function(pk) {
    paste0("$PROBLEM undefined
$INPUT ID TIME DV AMT WT
$DATA data.csv IGNORE=@
$SUBROUTINES ADVAN1 TRANS2
$PK
", pk, "
$ERROR
IPRED = F
Y = IPRED + EPS(1)
$THETA (0,1) (0,10) (-2,1)
$OMEGA 0.1
$SIGMA 0.1
")
  }
  .run <- function(pk) {
    .tmp <- tempfile(fileext = ".ctl")
    writeLines(.ctl(pk), .tmp)
    on.exit(unlink(.tmp))
    suppressMessages(nonmem2rx(.tmp))
  }
  .ok <- .run("CL = THETA(1)*(WT/70)**THETA(3)*EXP(ETA(1))\nV = THETA(2)")
  expect_true(inherits(.ok, "nonmem2rx"))
  expect_error(.run("CL = THETA(1)*(WT/70)**ETA(3)*EXP(ETA(1))\nV = THETA(2)"),
               "ETA\\(3\\) used but only 1 defined in \\$OMEGA")
  expect_error(.run("CL = THETA(1)*(WT/70)**THETA(4)*EXP(ETA(1))\nV = THETA(2)"),
               "THETA\\(4\\) used but only 3 defined in \\$THETA")
})
