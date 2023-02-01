test_that("model loading", {
  
  expect_error(nonmem2rx(system.file("mods/DDMODEL00000301/run3.mod", package="nonmem2rx")), NA)
  ## expect_error(nonmem2rx(system.file("mods/DDMODEL00000311/zebrafish.mod", package="nonmem2rx"))
  ##                        "SIGMA(#, #)")
  expect_error(nonmem2rx(system.file("mods/DDMODEL00000322/HCQ1CMT.mod", package="nonmem2rx")), NA)
  
  
})
