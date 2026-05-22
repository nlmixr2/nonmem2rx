test_that("applyNmInputAliasesToTable adds alias column alongside original", {
  .clearNonmem2rx()
  .Call(`_nonmem2rx_setRecord`, "$INPUT")
  .Call(`_nonmem2rx_trans_input`, "ID TAFD=TIME DV AMT EVID")

  .tab <- data.frame(ID=1:3, TAFD=c(0, 1, 2), IPRED=c(1, 2, 3))
  .result <- nonmem2rx:::.applyNmInputAliasesToTable(.tab)

  # both original and alias should be present
  expect_true("TIME" %in% names(.result))
  expect_true("TAFD" %in% names(.result))
  expect_equal(.result$TIME, c(0, 1, 2))
  expect_equal(.result$TAFD, c(0, 1, 2))
})

test_that("applyNmInputAliasesToTable does not duplicate when alias already present", {
  .clearNonmem2rx()
  .Call(`_nonmem2rx_setRecord`, "$INPUT")
  .Call(`_nonmem2rx_trans_input`, "ID TAFD=TIME DV AMT EVID")

  # sdtab already has TIME — no duplication
  .tab <- data.frame(ID=1:3, TIME=c(0, 1, 2), IPRED=c(1, 2, 3))
  .result <- nonmem2rx:::.applyNmInputAliasesToTable(.tab)

  expect_true("TIME" %in% names(.result))
  expect_equal(.result$TIME, c(0, 1, 2))
})

test_that("readInIpredFromTables errors informatively when required column is absent", {
  skip_on_cran()
  withr::with_tempdir({
    .clearNonmem2rx()
    .Call(`_nonmem2rx_setRecord`, "$INPUT")
    .Call(`_nonmem2rx_trans_input`, "ID DV AMT EVID")  # no TIME, no alias for it

    writeLines(c(
      "TABLE NO.     1",
      " ID          IPRED       PRED",
      "  1.0000E+00  1.2300E+00  1.2300E+00"
    ), "sdtab001")

    nonmem2rx:::.pushTableInfo("sdtab001", hasPred=TRUE, fullData=TRUE,
                               hasIpred=TRUE, hasEta=FALSE, fortranFormat="")

    expect_error(
      nonmem2rx:::.readInIpredFromTables("model.ctl", nonmemOutputDir=getwd()),
      regexp="TIME"
    )
  })
})
