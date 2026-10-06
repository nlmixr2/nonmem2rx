test_that("referencing DV does not change modeled lag/duration doses (#263)", {
  skip_on_cran()
  # The DV reference makes DV a time-varying covariate; rxode2 before 5.1.8
  # then sent the second modeled-duration infusion to the wrong compartment
  skip_if_not(utils::packageVersion("rxode2") >= "5.1.8",
              "needs the rxode2 time-varying covariate/modeled duration fix")
  .ctl <- function(err) {
    c("$PROBLEM modeled lag and duration in two compartments",
      "$INPUT ID TIME AMT RATE CMT DV EVID",
      "$DATA data.csv IGNORE=@",
      "$SUBROUTINES ADVAN13 TOL=6",
      "$MODEL COMP=(DEPOT DEFDOSE) COMP=(CENTRAL)",
      "$PK",
      "  KA = THETA(1)",
      "  K = THETA(2)*EXP(ETA(1))",
      "  ALAG1 = 0.4",
      "  D1 = 0.4",
      "  F1 = 0.7",
      "  ALAG2 = 22",
      "  D2 = 6",
      "  F2 = 0.3",
      "$DES",
      "  DADT(1) = -KA*A(1)",
      "  DADT(2) = KA*A(1) - K*A(2)",
      "$ERROR",
      "  IPRED = A(2)",
      err,
      "  Y = IPRED + EPS(1)",
      "$THETA 0.8 0.02",
      "$OMEGA 0.1",
      "$SIGMA 1")
  }
  withr::with_tempdir({
    writeLines(c("ID,TIME,AMT,RATE,CMT,DV,EVID",
                 "1,0,60,-2,1,0,1",
                 "1,0,60,-2,2,0,1",
                 "1,1,0,0,2,1,0"), "data.csv")
    writeLines(.ctl("  IRES = DV - IPRED"), "dv.ctl")
    writeLines(.ctl("  IRES = 0"), "nodv.ctl")
    .opts <- list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE,
                  nonmem2rx.overwrite=FALSE)
    withr::with_options(.opts, {
      .dv <- suppressMessages(suppressWarnings(
        nonmem2rx("dv.ctl", validate=FALSE, save=FALSE, load=FALSE)))
      .nodv <- suppressMessages(suppressWarnings(
        nonmem2rx("nodv.ctl", validate=FALSE, save=FALSE, load=FALSE)))
    })
  })
  expect_true("DV" %in% .dv$allCovs)
  .ev <- rxode2::et(amt=60, cmt="DEPOT", ii=24, addl=4, rate=-2) |>
    rxode2::et(amt=60, cmt="CENTRAL", ii=24, addl=4, rate=-2) |>
    rxode2::et(seq(0, 168, by=0.5))
  .solve <- function(m) {
    suppressMessages(rxode2::rxSolve(rxode2::zeroRe(m, "omega"), .ev,
                                     returnType="data.frame"))
  }
  .sdv <- .solve(.dv)
  .snodv <- .solve(.nodv)
  expect_true(min(.sdv$CENTRAL) >= 0)
  expect_equal(.sdv$CENTRAL, .snodv$CENTRAL)
  expect_equal(.sdv$DEPOT, .snodv$DEPOT)
})
