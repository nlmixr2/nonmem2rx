.nonmem2rx <- function(...) {
  suppressWarnings(suppressMessages(nonmem2rx(...)))
}

withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE),{
  test_that("renaming makes sense", {
    skip_on_cran()

    f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"),
                    lst=".res", determineError=FALSE)

    f2 <- f %>% rxRename(err1=eps1)
    expect_equal(dimnames(f2$sigma)[[1]], "err1")
    expect_equal(dimnames(f$sigma)[[1]], "eps1")
    expect_true(any(dimnames(f2$thetaMat)[[1]] == "err1"))
    expect_false(any(dimnames(f2$thetaMat)[[1]] == "eps1"))
    expect_false(any(dimnames(f$thetaMat)[[1]] == "err1"))
    expect_true(any(dimnames(f$thetaMat)[[1]] == "eps1"))

    f3 <- f %>% rxRename(Vp=theta4)
    expect_true(any(dimnames(f3$thetaMat)[[1]] == "Vp"))
    expect_false(any(dimnames(f3$thetaMat)[[1]] == "theta4"))
    expect_false(any(dimnames(f$thetaMat)[[1]] == "Vp"))
    expect_true(any(dimnames(f$thetaMat)[[1]] == "theta4"))    
  })
})
