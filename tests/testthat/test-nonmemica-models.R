test_that("test nonmemica models", {
  skip_if_not(requireNamespace("nonmemica", quietly = TRUE))
  
  m1 <- nonmem2rx(system.file("project/model/1001/1001.ctl",package="nonmemica"))
  m2 <- nonmem2rx(system.file("project/model/2001/2001.ctl",package="nonmemica"))
  m2 <- nonmem2rx(system.file("project/model/2002/2002.ctl",package="nonmemica"))
  m2 <- nonmem2rx(system.file("project/model/2003/2003.ctl",package="nonmemica"))
  m2 <- nonmem2rx(system.file("project/model/2004/2004.ctl",package="nonmemica"))
  m2 <- nonmem2rx(system.file("project/model/2005/2005.ctl",package="nonmemica"))
  m2 <- nonmem2rx(system.file("project/model/2006/2006.ctl",package="nonmemica"))
  m2 <- nonmem2rx(system.file("project/model/2007/2007.ctl",package="nonmemica"))
})

test_that("test nonemem2R models", {
  
  skip_if_not(requireNamespace("nonmem2R", quietly = TRUE))
  
  m1 <- nonmem2rx(system.file("extdata/run001.mod",package="nonmem2R"))
  
})
