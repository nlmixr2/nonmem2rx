jwithr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE),{
  test_that("reading nonmem data without estimates", {
    skip_on_cran()
    withr::with_tempdir({
      file.copy(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"),
                file.path(getwd(), "runODE032.ctl"))

      file.copy(system.file("mods/cpt/Bolus_2CPT.csv", package="nonmem2rx"),
                file.path(getwd(), "Bolus_2CPT.csv"))

      f <- nonmem2rx("runODE032.ctl", save=FALSE)
      expect_true(is.null(f$nonmemData))
      f <- nonmem2rx("runODE032.ctl", nonmemData=TRUE, save=FALSE)
      expect_true(inherits(f$nonmemData, "data.frame"))
    })
  })

  test_that("read in data without phi, lower case id", {
    skip_on_cran()
    expect_error(nonmem2rx(system.file("mods/err/run002.res", package="nonmem2rx"), lst=".res", usePhi = FALSE, save=FALSE), NA)
    tmp <- nonmem2rx(system.file("mods/err/run002.res", package="nonmem2rx"), lst=".res", usePhi = FALSE, save=FALSE)
    expect_true(inherits(tmp$iwresAtol, "numeric"))
    expect_true(length(tmp$iwresAtol) == 1L)
  })
})
