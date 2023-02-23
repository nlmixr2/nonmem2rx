.nonmem2rx <- function(...) {
  suppressMessages(nonmem2rx(...))
}
test_that("full parsing", {
  expect_warning(.nonmem2rx(system.file("run001.mod", package="nonmem2rx")))
})
