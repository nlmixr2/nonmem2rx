test_that("pushSigmaEst adds entry when not yet present (#223)", {
  # Before the fix, .pushSigmaEst had `!= 1L` instead of `!= 0L`, so it only
  # added an entry when one was ALREADY there – backwards.  The entry was
  # therefore never populated on the first (and only) encounter of SIGMA(n),
  # so sigma constants were missing from the ini block.
  e <- getNamespace("nonmem2rx")
  nm2rx <- get(".nonmem2rx", envir = e)

  # Reset sigmaEst to empty
  old_sigma_est <- nm2rx$sigmaEst
  nm2rx$sigmaEst <- data.frame(x = integer(0), y = integer(0))
  on.exit(nm2rx$sigmaEst <- old_sigma_est, add = TRUE)

  pushSigmaEst <- get(".pushSigmaEst", envir = e)

  # First call: should ADD the entry
  pushSigmaEst(1L, -1L)
  expect_equal(nrow(nm2rx$sigmaEst), 1L)
  expect_equal(nm2rx$sigmaEst$x, 1L)
  expect_equal(nm2rx$sigmaEst$y, -1L)

  # Second call with same (x,y): should NOT duplicate
  pushSigmaEst(1L, -1L)
  expect_equal(nrow(nm2rx$sigmaEst), 1L)

  # Call with different (x,y): should add a second entry
  pushSigmaEst(2L, -1L)
  expect_equal(nrow(nm2rx$sigmaEst), 2L)
})

test_that("SIGMA(n) in $ERROR block is added as fixed constant to ini (#223)", {
  # Models that use SIGMA(n) directly (e.g. W = SQRT(SIGMA(1))) require those
  # values to be injected as fixed parameters in the ini block.  The bug caused
  # them to be referenced in the model body but undefined in ini, making them
  # free/covariate parameters instead of constants.
  ctl <- "
$PROBLEM sigma-in-if test
$INPUT ID TIME AMT DV EVID CMT ROUTE
$DATA data.csv IGNORE=@
$SUBROUTINE ADVAN13 TOL=6
$MODEL COMP=(DOSING) COMP=(CENTRAL,DEFOBS)
$PK
IF(ROUTE.EQ.0) THEN
  F1 = 1
  KA = 0
ELSE
  F1 = THETA(1)
  KA = THETA(2) * EXP(ETA(1))
ENDIF
A_0(1) = 0
A_0(2) = 0
$DES
DADT(1) = -KA * A(1)
DADT(2) = KA * A(1) - THETA(3) * A(2)
$ERROR
IF(CMT.EQ.2) THEN
  IPRED = A(2) / THETA(4)
  W     = SQRT(SIGMA(1))
  Y     = IPRED + W * EPS(1)
ENDIF
$THETA (0,0.5,1) (0,0.1) (0,0.1) (0,1)
$OMEGA 0.09
$SIGMA 0.04
$ESTIMATION METHOD=1
"
  tmp <- tempfile(fileext = ".ctl")
  writeLines(ctl, tmp)
  on.exit(unlink(tmp), add = TRUE)

  m <- nonmem2rx(tmp)

  ini_df <- m$iniDf
  sigma_rows <- ini_df[grepl("^sigma\\.", ini_df$name), , drop = FALSE]

  # sigma.1. must be present in the ini block as a fixed constant
  expect_true(
    nrow(sigma_rows) >= 1L,
    info = "sigma.1. should be in the ini block as a fixed constant"
  )
  expect_true(
    "sigma.1." %in% sigma_rows$name,
    info = "sigma.1. should be added as a constant to the ini block"
  )
  # Its value should match the $SIGMA block (0.04)
  sigma1_est <- sigma_rows$est[sigma_rows$name == "sigma.1."]
  expect_equal(sigma1_est, 0.04, tolerance = 1e-6)
})
