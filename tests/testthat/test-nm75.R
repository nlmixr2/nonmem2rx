test_that("nm75 read", {

  expect_error(nonmem2rx(system.file("mods/dollar_abbr_explicit/CONTROL5_dolabbr.lst", package="nonmem2rx"), strictLst = TRUE), NA)
  expect_error(nonmem2rx(system.file("mods/dollar_abbr_implicit/CONTROL5_implicitabbr.lst", package="nonmem2rx"), strictLst = TRUE), NA)

})
