test_that("test nonmemica models", {
  skip_if_not(requireNamespace("nonmemica", quietly = TRUE))

  m1 <- nonmem2rx(system.file("project/model/1001/1001.ctl",package="nonmemica"))
  
})
