test_that("print", {

  
  mod <- nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res", save=FALSE,
                   determineError = FALSE)

  expect_error(print(mod), NA)
  
})
