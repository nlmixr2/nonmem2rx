.nonmem2rx <- function(...) {
  suppressWarnings(suppressMessages(nonmem2rx(...)))
}

test_that("piping works", {
  skip_on_cran()
  f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res")
  expect_true(inherits(f, "nonmem2rx"))
  expect_false(is.null(f$nonmemData))
  f2 <- f %>% ini(eta1 ~ 0.1)
  expect_true(inherits(f2, "nonmem2rx"))
  expect_false(is.null(f2$nonmemData))

  f2 <- f %>% model(cl <- exp(theta1))
  expect_true(inherits(f2, "nonmem2rx"))
  expect_false(is.null(f2$nonmemData))
  
})
