.nonmem2rx <- function(..., save=FALSE) {
  suppressWarnings(suppressMessages(nonmem2rx(..., save=FALSE)))
}

withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE),{
  test_that("model loading", {
    skip_on_cran()
    
    expect_error(.nonmem2rx(system.file("mods/DDMODEL00000301/run3.mod", package="nonmem2rx")), NA)
    ## expect_error(.nonmem2rx(system.file("mods/DDMODEL00000311/zebrafish.mod", package="nonmem2rx"))
    ##                        "SIGMA(#, #)")
    expect_error(.nonmem2rx(system.file("mods/DDMODEL00000322/HCQ1CMT.mod", package="nonmem2rx")), NA)
    #.nonmem2rx(system.file("mods/DDMODEL00000323/run1.mod", package="nonmem2rx")) # advan7
    expect_error(.nonmem2rx(system.file("mods/DDMODEL00000298/run1.mod", package="nonmem2rx")), NA)
    #.nonmem2rx(system.file("mods/DDMODEL00000310/run1.mod", package="nonmem2rx")) advan
    expect_error(.nonmem2rx(system.file("mods/DDMODEL00000302/run1.mod", package="nonmem2rx")), NA)
    expect_error(.nonmem2rx(system.file("run001.mod", package="nonmem2rx")), NA)

    expect_error(.nonmem2rx(system.file("mods/err/run000.lst", package="nonmem2rx")), NA)
    expect_error(.nonmem2rx(system.file("mods/err/run002.res", package="nonmem2rx")), NA)
    expect_error(.nonmem2rx(system.file("mods/err/run006.lst", package="nonmem2rx")), NA)
    expect_error(.nonmem2rx(system.file("mods/err/run007.lst", package="nonmem2rx")), NA)

    f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res")
    expect_equal(length(f$meta$validation), 6L)

    f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"),
                    lst=".res", usePhi=FALSE)
    expect_equal(length(f$meta$validation), 6L)

    f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"),
                    lst=".res", useCov=FALSE)
    expect_equal(length(f$meta$validation), 6L)

    f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"),
                    lst=".res", useExt=FALSE)
    expect_equal(length(f$meta$validation), 6L)

    f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res",
                    determineError=FALSE)
    expect_equal(length(f$meta$validation), 6L)

    # try explicitly setting the input info
    f <- nmlst(system.file("mods/cpt/runODE032.res", package="nonmem2rx"))
    expect_true(inherits(f$cov, "matrix"))

    f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"),
                    inputData = system.file("mods/cpt/Bolus_2CPT.csv",
                                            package="nonmem2rx"),
                    nonmemOutputDir = system.file("mods/cpt", package="nonmem2rx"),
                    lst=".res")
    expect_equal(length(f$meta$validation), 6L)

    # Now try to rename some of the data
    f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"),
                    rename=c(SSX="SSY"),
                    lst=".res")
    expect_equal(length(f$meta$validation), 6L)

    # Test a rename of variables inside the model:
    f <- .nonmem2rx(system.file("mods/DDMODEL00000301/run3.mod", package="nonmem2rx"), rename=c(GFR2="GFR"))
    expect_true(any(rxode2::rxModelVars(f)$params == "GFR2"))

    expect_error(.nonmem2rx(system.file("Theopd.ctl", package="nonmem2rx")), NA)

  })
})
