test_that("lst import that didn't import cov", {
  # Skip if the file doesn't exist
  if (!file.exists(test_path("test-lst-import-1.rds"))) {
    skip("File 'test-lst-import-1.rds' does not exist.")
  }

  lst <- readRDS(test_path("test-lst-import-1.rds"))

  # Save file in temporary directory
  f <- withr::with_tempdir({
    writeLines(lst, "run0112.lst")
    suppressMessages(nonmem2rx("run0112.lst"))
  })

  expect_false(is.null(f$thetaMat))

})

test_that("lst import with errors with 2+ EPSs", {

  if (!file.exists(test_path("test-lst-import-2.rds"))) {
    skip("File 'test-lst-import-2.rds' does not exist.")
  }

  lst <- readRDS(test_path("test-lst-import-2.rds"))

  # Save file in temporary directory
  expect_error(withr::with_tempdir({
    writeLines(lst, "run70.lst")
    suppressMessages(nonmem2rx("run70.lst"))
  }), NA)
})
