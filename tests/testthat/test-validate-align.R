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

test_that("IPRED validation drops dose-only subjects when ID is not the first column (#269)", {
  skip_on_cran()
  mod <- suppressMessages(suppressWarnings(nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res", save=FALSE)))
  mod <- rxode2::rxUiDecompress(mod)
  .d <- mod$nonmemData
  ## subject 2 keeps only its dose records, so NONMEM still has its
  ## ETAs but they are dropped from the validation ETAs
  .keep <- !(.d$ID == 2 & .d$EVID == 0)
  .d <- .d[.keep, ]
  ## ID is no longer the first input column
  .d <- .d[, c(setdiff(names(.d), c("ID", "TIME")), "ID", "TIME")]
  assign("nonmemData", .d, envir=mod)
  for (.v in c("ipredData", "predData")) {
    assign(.v, get(.v, envir=mod)[.keep, ], envir=mod)
  }
  assign("etaData", mod$etaData[mod$etaData$ID != 2, ], envir=mod)
  expect_message(.msg <- .nonmem2rxValidate(mod),
                 "IDs were not included in the validation: 2")
  expect_true(any(grepl("^IPRED relative difference", .msg)))
  .c <- mod$ipredCompare
  expect_false(any(.c$ID == 2))
  expect_equal(length(.c$ID), sum(.d$EVID == 0))
  expect_equal(.c$IPRED, .c$nonmemIPRED, tolerance=1e-3)
  ## PRED does not need ETAs, so it still uses all of the input data
  expect_true(any(grepl("^PRED relative difference", .msg)))
  expect_equal(length(mod$predCompare$ID), sum(.d$EVID == 0))
})

test_that(".matchEtaRuns() skips individuals without ETAs in data order (#269)", {
  expect_equal(.matchEtaRuns(c("1", "2", "3"), c("1", "2", "3")), c(TRUE, TRUE, TRUE))
  ## dose-only subject 2 has no ETA row
  expect_equal(.matchEtaRuns(c("1", "2", "3"), c("1", "3")), c(TRUE, FALSE, TRUE))
  ## a reused ID keeps its ETA rows for both individuals
  expect_equal(.matchEtaRuns(c("1", "2", "1"), c("1", "1")), c(TRUE, FALSE, TRUE))
  ## the ETAs of a subject are dropped by ID, so ETA rows that would skip
  ## one individual of a reused ID are not in data order
  expect_null(.matchEtaRuns(c("1", "2", "1"), c("1", "2")))
  expect_null(.matchEtaRuns(c("1", "2", "1"), c("2", "1")))
  ## ETA rows not in data order
  expect_null(.matchEtaRuns(c("1", "2", "3"), c("3", "1")))
  expect_null(.matchEtaRuns(c("1", "2"), c("1", "2", "3")))
})

test_that("IPRED validation keeps a reused ID separate around a dropped subject (#269)", {
  skip_on_cran()
  mod <- suppressMessages(suppressWarnings(nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res", save=FALSE)))
  mod <- rxode2::rxUiDecompress(mod)
  .d <- mod$nonmemData
  ## subject 2 is dose-only and subject 3 reuses ID 1, so once subject 2
  ## is dropped the two individuals with ID 1 are next to each other.
  ## Subject 1 is dose-only too, but keeps its ETAs since its ID also has
  ## observations
  .keep <- !(.d$ID %in% c(1, 2) & .d$EVID == 0)
  .d <- .d[.keep, ]
  .d$ID[.d$ID == 3] <- 1
  .d <- .d[, c(setdiff(names(.d), "ID"), "ID")]
  assign("nonmemData", .d, envir=mod)
  for (.v in c("ipredData", "predData")) {
    .t <- get(.v, envir=mod)[.keep, ]
    .t$ID[.t$ID == 3] <- 1
    assign(.v, .t, envir=mod)
  }
  .eta <- mod$etaData[mod$etaData$ID != 2, ]
  .eta$ID[.eta$ID == 3] <- 1
  assign("etaData", .eta, envir=mod)
  expect_message(.msg <- .nonmem2rxValidate(mod),
                 "IDs were not included in the validation: 2")
  expect_true(any(grepl("^IPRED relative difference", .msg)))
  .c <- mod$ipredCompare
  expect_equal(length(.c$ID), sum(.d$EVID == 0))
  expect_equal(.c$IPRED, .c$nonmemIPRED, tolerance=1e-3)
})
