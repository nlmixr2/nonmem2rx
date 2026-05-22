test_that("DUR identifier in model is renamed to rxDur", {
  .clearNonmem2rx()
  .Call(`_nonmem2rx_setRecord`, "$PRED")
  expect_warning(
    .Call(`_nonmem2rx_trans_abbrev`, "DUR = THETA(1)", "$PRED", 0L, 0L),
    "'dur' variable has special meaning in rxode2"
  )
  expect_equal(.nonmem2rx$model, "rxDur <- theta1")
})

test_that("dur column in dataset is renamed to rxDur", {
  .clearNonmem2rx()
  .Call(`_nonmem2rx_setRecord`, "$INPUT")
  .Call(`_nonmem2rx_trans_input`, "ID TIME AMT DV EVID DUR RATE")

  # simulate a minimal csv dataset
  withr::with_tempdir({
    writeLines(c(
      "1,0,100,.,1,2,50",
      "1,1,0,5.1,0,2,50"
    ), "data.csv")
    .nonmem2rx$dataFile <- "data.csv"
    .nonmem2rx$dataIgnore1 <- NULL
    .nonmem2rx$dataCond <- character(0)
    .nonmem2rx$dataRecords <- NA_integer_
    .nonmem2rx$needNmevid <- FALSE
    .nonmem2rx$needNmid <- FALSE
    .nonmem2rx$needYtype <- FALSE
    .nonmem2rx$needDvid <- FALSE
    .nonmem2rx$needDur <- FALSE

    .dat <- nonmem2rx:::.readInDataFromNonmem(
      file.path(getwd(), "model.ctl"),
      inputData = file.path(getwd(), "data.csv")
    )
    expect_true("rxDur" %in% names(.dat))
    expect_false("DUR" %in% names(.dat))
    expect_false("dur" %in% names(.dat))
    # RATE should be unchanged
    expect_true("RATE" %in% names(.dat))
  })
})
