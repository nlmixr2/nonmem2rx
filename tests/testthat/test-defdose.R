test_that("doses without CMT go to the $MODEL DEFDOSE compartment (#281)", {
  skip_on_cran()
  .d <- withr::local_tempdir()
  .ctl <- function(model, input = "ID TIME DV EVID AMT MDV") {
    c(
      "$PROBLEM DEFDOSE",
      paste("$INPUT", input),
      "$DATA run.csv IGNORE=@",
      "$SUBROUTINE ADVAN13 TOL=9",
      model,
      "$PK",
      "  CL = THETA(1)*EXP(ETA(1))",
      "  V  = THETA(2)",
      "  KA = THETA(3)",
      "$DES",
      "  DADT(1) = KA*A(2)/V - (CL/V)*A(1)",
      "  DADT(2) = -KA*A(2)",
      "$ERROR",
      "  IPRED = A(1)",
      "  Y = IPRED + EPS(1)",
      "$THETA 0.2 10 1.5",
      "$OMEGA 0.09",
      "$SIGMA 0.01"
    )
  }
  .run <- function(model, data, input = "ID TIME DV EVID AMT MDV") {
    writeLines(data, file.path(.d, "run.csv"))
    .f <- file.path(.d, "run.ctl")
    writeLines(.ctl(model, input), .f)
    withr::with_options(
      list(
        nonmem2rx.save = FALSE,
        nonmem2rx.load = FALSE,
        nonmem2rx.overwrite = FALSE,
        nonmem2rx.useLLM = FALSE
      ),
      suppressMessages(suppressWarnings(
        nonmem2rx(.f, validate = FALSE, nonmemData = TRUE)
      ))
    )
  }
  .model <- c("$MODEL", "  COMP=(CENTRAL, DEFOBS)", "  COMP=(DEPOT, DEFDOSE)")
  .data <- c(
    "ID,TIME,DV,EVID,AMT,MDV",
    "1,0,.,1,100,1",
    "1,0.5,0,0,.,0",
    "1,2,0,0,.,0",
    "1,8,0,0,.,0"
  )
  .m <- .run(.model, .data)
  expect_equal(.m$nonmemData$CMT, c(2, 1, 1, 1))

  # NONMEM's PRED with the dose in DEPOT
  .t <- c(0.5, 2, 8)
  .k <- 0.2 / 10
  .ka <- 1.5
  .pred <- 100 * .ka / 10 / (.ka - .k) * (exp(-.k * .t) - exp(-.ka * .t))
  .s <- suppressMessages(suppressWarnings(
    rxode2::rxSolve(rxode2::zeroRe(.m), .m$nonmemData, addDosing = FALSE)
  ))
  expect_equal(.s$ipred, .pred, tolerance = 1e-4)

  # without EVID, a nonzero AMT is a dose
  .m <- .run(
    .model,
    sub(",[^,]*,([^,]*,[^,]*)$", ",\\1", .data),
    input = "ID TIME DV AMT MDV"
  )
  expect_equal(.m$nonmemData$CMT, c(2, 1, 1, 1))

  # a CMT of 0 uses DEFDOSE on a dose and DEFOBS on an observation; other
  # values and other events are kept
  .m <- .run(
    .model,
    c(
      "ID,TIME,DV,EVID,AMT,MDV,CMT",
      "1,0,.,1,100,1,0",
      "1,1,.,1,100,1,1",
      "1,2,0,0,.,0,0",
      "1,3,0,0,.,0,2",
      "1,4,.,3,.,1,0"
    ),
    input = "ID TIME DV EVID AMT MDV CMT"
  )
  expect_equal(.m$nonmemData$CMT, c(2, 1, 1, 2, 0))

  # without CMT, a reset keeps CMT 0
  .m <- .run(.model, c(.data, "1,10,.,3,.,1"))
  expect_equal(.m$nonmemData$CMT, c(2, 1, 1, 1, 0))

  # DEFDOSE on compartment 1 leaves the data alone
  .m <- .run(
    c("$MODEL", "  COMP=(CENTRAL, DEFOBS)", "  COMP=(DEPOT)"),
    .data
  )
  expect_null(.m$nonmemData$CMT)
})
