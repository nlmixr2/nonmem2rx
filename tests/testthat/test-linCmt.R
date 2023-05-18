test_that("linCmt read test(s)", {
  expect_error(nonmem2rx(system.file("mods/err/run000.lst", package="nonmem2rx")), NA)
})
