.nonmem2rx <- function(...) {
  suppressWarnings(suppressMessages(nonmem2rx(...)))
}

.rxSolve <-  function(...) {
  suppressMessages(suppressWarnings(rxSolve(...)))
}

test_that("solving makes sense", {
  skip_on_cran()
  
  f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res")
  s <- .rxSolve(f)
  expect_true(inherits(s, "rxSolve"))
  expect_equal(s$env$.args$covsInterpolation, 2L)
  s <- rxSolve(f, nStud=1)
  expect_equal(s$env$.args$dfObs, 2280)
  expect_equal(s$env$.args$dfSub, 120)
  expect_equal(s$env$.args$thetaMat, f$thetaMat)
  expect_equal(s$env$.args$omega, f$omega)
  for (v in names(f$theta)) {
    expect_true(all(s$params[[v]] == f$theta[v]))
  }

})
