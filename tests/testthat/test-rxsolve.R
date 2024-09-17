.nonmem2rx <- function(..., save=FALSE) {
  suppressWarnings(suppressMessages(nonmem2rx(..., save=FALSE)))
}

.rxSolve <-  function(...) {
  suppressMessages(suppressWarnings(rxSolve(...)))
}

withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE),{
  test_that("solving makes sense", {
    skip_on_cran()

    f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res")
    s <- .rxSolve(f)
    expect_true(inherits(s, "rxSolve"))
    expect_equal(s$env$.args$covsInterpolation, 2L)
    s <- rxSolve(f, nStud=1)
    expect_equal(s$env$.args$dfObs, 2280)
    expect_equal(s$env$.args$dfSub, 120)
    ## expect_equal(s$env$.args$thetaMat, f$thetaMat) # dropped items
    expect_true(inherits(s$env$.args$thetaMat, "matrix"))
    expect_equal(s$env$.args$omega, f$omega)
    for (v in names(f$theta)) {
      expect_true(all(s$params[[v]] == f$theta[v]))
    }
    # now test model that does not translate the error
    # force rik's model
    f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res", determineError=FALSE)

    s <- .rxSolve(f)
    expect_true(inherits(s, "rxSolve"))
    expect_equal(s$env$.args$covsInterpolation, 2L)
    s <- rxSolve(f, nStud=1)
    expect_equal(s$env$.args$dfObs, 2280)
    expect_equal(s$env$.args$dfSub, 120)
    ## expect_equal(s$env$.args$thetaMat, f$thetaMat) # drops vars not in model and zero diag
    expect_true(inherits(s$env$.args$thetaMat, "matrix"))
    expect_equal(s$env$.args$omega, f$omega)
    expect_equal(s$env$.args$sigma, f$sigma)
  })
})
