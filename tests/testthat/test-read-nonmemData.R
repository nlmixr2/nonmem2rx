test_that("reading nonmem data without estimates", {
  withr::with_tempdir({
    file.copy(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"),
              file.path(getwd(), "runODE032.ctl"))

    file.copy(system.file("mods/cpt/Bolus_2CPT.csv", package="nonmem2rx"),
              file.path(getwd(), "Bolus_2CPT.csv"))

    f <- nonmem2rx("runODE032.ctl")
    expect_true(is.null(f$nonmemData))
    f <- nonmem2rx("runODE032.ctl", nonmemData=TRUE)
    expect_true(inherits(f$nonmemData, "data.frame"))
  })
})
