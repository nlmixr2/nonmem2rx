test_that("model loading", {
  
  expect_error(nonmem2rx(system.file("mods/DDMODEL00000301/run3.mod", package="nonmem2rx")), NA)
  
})
