withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE),{
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

  test_that("inputData can be supplied as a data.frame (#186)", {
    skip_on_cran()
    withr::with_tempdir({
      file.copy(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"),
                file.path(getwd(), "runODE032.ctl"))

      file.copy(system.file("mods/cpt/Bolus_2CPT.csv", package="nonmem2rx"),
                file.path(getwd(), "Bolus_2CPT.csv"))

      # reference: read from the file as usual
      fFile <- nonmem2rx("runODE032.ctl", nonmemData=TRUE, save=FALSE)
      expect_true(inherits(fFile$nonmemData, "data.frame"))

      # the user reads the data in themselves (possibly from a
      # different path than the control stream points to)
      d <- read.csv("Bolus_2CPT.csv")

      # move the actual file out of the way so it cannot be found; the
      # supplied data.frame must be used instead
      file.remove("Bolus_2CPT.csv")
      expect_false(file.exists("Bolus_2CPT.csv"))

      fDf <- nonmem2rx("runODE032.ctl", inputData=d, nonmemData=TRUE, save=FALSE)
      expect_true(inherits(fDf$nonmemData, "data.frame"))

      # data.frame-supplied input reproduces the file-supplied input
      expect_equal(fDf$nonmemData, fFile$nonmemData)
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
