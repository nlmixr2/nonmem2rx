test_that("full parsing", {
  expect_warning(nonmem2rx(system.file("run001.mod", package="nonmem2rx")))
})
