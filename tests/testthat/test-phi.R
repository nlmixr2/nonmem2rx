test_that("read in .phi file", {
  info <- nminfo(system.file("mods/err/run001.res", package="nonmem2rx"), lst=".res")
  expect_false(is.null(info$eta))
})
