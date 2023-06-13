test_that("test wbc loading", {
  
  .nonmem2rx <- function(..., save=FALSE) {
    suppressWarnings(suppressMessages(nonmem2rx(..., save=FALSE)))
  }
  
  m1 <- .nonmem2rx(system.file("wbc/wbc.lst", package="nonmem2rx"))
  expect_length(m1$meta$validation, 4L)

})
