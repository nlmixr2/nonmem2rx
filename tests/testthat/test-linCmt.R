test_that("linCmt read test(s)", {
  skip_on_cran()
  expect_error(nonmem2rx(system.file("mods/err/run000.lst", package="nonmem2rx"), save=FALSE), NA)
})

test_that("ADVAN12 TRANS4 and TRANS1 translate to a solvable linCmt()", {
  .ctl <- function(trans, pk, theta) {
    paste0("$PROBLEM advan12
$INPUT ID TIME AMT DV EVID CMT
$DATA nodata.csv IGNORE=@
$SUBROUTINES ADVAN12 TRANS", trans, "
$PK
", pk, "
  S2 = V2
$ERROR
  IPRED = F
  Y = IPRED + EPS(1)
$THETA ", theta, "
$OMEGA 0 FIX
$SIGMA 0.01
")
  }
  .ev <- rxode2::et(amt=100, cmt=1) |> rxode2::et(c(0.5, 2, 12, 48))
  .solve <- function(ctl) {
    withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE,
                             nonmem2rx.overwrite=FALSE), {
      .m <- suppressMessages(nonmem2rx(ctl, validate=FALSE, compress=FALSE))
    })
    expect_false("linCmtFun" %in% rxode2::rxModelVars(.m)$params)
    suppressMessages(suppressWarnings(rxode2::rxSolve(rxode2::zeroRe(.m), .ev)))$ipred
  }
  ## same system both ways: K = CL/V2, K23 = Q3/V2, K32 = Q3/V3, ...
  .t4 <- .solve(.ctl(4, "  CL = THETA(1)\n  V2 = THETA(2)\n  Q3 = THETA(3)\n  V3 = THETA(4)\n  Q4 = THETA(5)\n  V4 = THETA(6)\n  KA = THETA(7)",
                     "6 8 4 20 1 60 2"))
  .t1 <- .solve(.ctl(1, "  K = THETA(1)/THETA(2)\n  V2 = THETA(2)\n  K23 = THETA(3)/THETA(2)\n  K32 = THETA(3)/THETA(4)\n  K24 = THETA(5)/THETA(2)\n  K42 = THETA(5)/THETA(6)\n  KA = THETA(7)",
                     "6 8 4 20 1 60 2"))
  expect_true(all(is.finite(.t4)) && all(.t4 > 0))
  expect_equal(.t4, .t1, tolerance=1e-6)
})

test_that("ADVAN4 TRANS6 (ALPHA, BETA, K32, KA) matches the micro-constant form", {
  .ctl <- function(trans, pk) {
    paste0("$PROBLEM advan4
$INPUT ID TIME AMT DV EVID CMT
$DATA nodata.csv IGNORE=@
$SUBROUTINES ADVAN4 TRANS", trans, "
$PK
", pk, "
  KA = 1.5
  S2 = V
$ERROR
  IPRED = F
  Y = IPRED + EPS(1)
$THETA 0.8 0.05 0.2 20
$OMEGA 0 FIX
$SIGMA 0.01
")
  }
  .ev <- rxode2::et(amt=100, cmt=1) |> rxode2::et(c(0.5, 2, 12, 48))
  .solve <- function(ctl) {
    withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE,
                             nonmem2rx.overwrite=FALSE), {
      .m <- suppressMessages(nonmem2rx(ctl, validate=FALSE, compress=FALSE))
    })
    suppressMessages(suppressWarnings(rxode2::rxSolve(rxode2::zeroRe(.m), .ev)))$ipred
  }
  .t6 <- .solve(.ctl(6, "  ALPHA = THETA(1)\n  BETA = THETA(2)\n  K32 = THETA(3)\n  V = THETA(4)"))
  ## K20 = ALPHA*BETA/K32, K23 = ALPHA + BETA - K32 - K20
  .t1 <- .solve(.ctl(1, "  K32 = THETA(3)\n  K = THETA(1)*THETA(2)/K32\n  K23 = THETA(1) + THETA(2) - K32 - K\n  V = THETA(4)"))
  expect_true(all(is.finite(.t6)) && all(.t6 > 0))
  expect_equal(.t6, .t1, tolerance=1e-6)
})
