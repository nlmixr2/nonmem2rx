test_that("linCmt read test(s)", {
  skip_on_cran()
  expect_error(nonmem2rx(system.file("mods/err/run000.lst", package="nonmem2rx"), save=FALSE), NA)
})
