.nonmem2rx <- function(...) {
  suppressWarnings(suppressMessages(nonmem2rx(...)))
}

withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE),{
  test_that("nm75 read", {
    skip_on_cran()
    expect_error(.nonmem2rx(system.file("mods/dollar_abbr_explicit/CONTROL5_dolabbr.lst", package="nonmem2rx"), strictLst = TRUE), NA)
    expect_error(.nonmem2rx(system.file("mods/dollar_abbr_implicit/CONTROL5_implicitabbr.lst", package="nonmem2rx"), strictLst = TRUE), NA)
  })
})
