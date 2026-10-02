test_that("validation solves are matched to NONMEM records by row", {
  ## records 1 (dose), 2, 3 (obs), 4 (compartment off, not output), 5 (obs)
  .input <- data.frame(ID=1, TIME=c(0, 1, 2, 2.5, 3), EVID=c(1, 0, 0, 2, 0),
                       rxNmRow=1:5)
  .rows <- c(2L, 3L, 4L, 5L)  # EVID 0 and 2 records
  .out <- data.frame(ID=1, TIME=c(1, 2, 2.5, 3), IPRED=c(10, 20, 25, 30))
  ## the solve has an extra mtime() row (rxNmRow NA) and lacks record 4
  .solve <- data.frame(time=c(1, 1.5, 2, 3), rxNmRow=c(2L, NA, 3L, 5L),
                       ipred=c(10, 15, 20, 30))
  .al <- .alignNonmemSolve(.solve, .out, .rows, .input)
  expect_equal(.al$solve$ipred, c(10, 20, 30))
  expect_equal(.al$outData$IPRED, c(10, 20, 30))
  expect_equal(.al$inputData$TIME, c(1, 2, 3))
  ## unknown rows or a failed solve are passed through unchanged
  expect_identical(.alignNonmemSolve(.solve, .out, NULL, .input)$solve, .solve)
  .err <- structure("x", class="try-error")
  expect_identical(.alignNonmemSolve(.err, .out, .rows, .input)$solve, .err)
})

test_that("PRED validation data treats a reused ID as a new individual", {
  .d <- data.frame(ID=c(10, 10, 2, 2, 10, 10), TIME=c(0, 1, 0, 1, 0, 1))
  .id <- .nonmemToRxIdData(.d)$ID
  expect_equal(length(unique(.id)), 3L)
  expect_false(.id[1] == .id[5])
  ## no ID column: unchanged
  expect_identical(.nonmemToRxIdData(data.frame(TIME=1)), data.frame(TIME=1))
})
