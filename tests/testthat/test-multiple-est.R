## NONMEM 7.4 output from the stress kit (inst/stress): an ITS step
## followed by FOCE-I, and FO with POSTHOC.  The final estimates are in the
## last estimation step; the .ext/.phi/.cov/.xml/.lst files hold one block
## per step.
.multest <- function(case, f) {
  system.file("mods", "multest", case, f, package="nonmem2rx")
}

test_that("readers take the final estimation step (ITS then FOCE)", {
  skip_if(.multest("its-foce", "run.ext") == "")
  .foce <- c(theta1=3.20733, theta2=29.5454, theta3=1.24337, theta4=0.103202)
  expect_equal(nmext(.multest("its-foce", "run.ext"))$theta, .foce, tolerance=1e-5)
  expect_equal(nmext(.multest("its-foce", "run.ext"))$objf, -525.930050165287)
  .x <- nmxml(.multest("its-foce", "run.xml"))
  expect_equal(.x$theta, .foce, tolerance=1e-5)
  expect_equal(.x$objf, -525.930050165287, tolerance=1e-8)
  expect_false(is.null(.x$sigma))
  .l <- nmlst(.multest("its-foce", "run.lst"))
  expect_equal(.l$objf, -525.93)
  expect_equal(unname(.l$theta), unname(.foce), tolerance=1e-2)
  ## the FOCE covariance, not the ITS one
  .cov <- nmcov(.multest("its-foce", "run.cov"))
  expect_equal(dim(.cov), c(8L, 8L))
  expect_equal(.cov[1, 1], 4.74941e-02)
  ## the FOCE etas (named ETA()), not the ITS PHI() table
  .i <- withr::with_dir(dirname(.multest("its-foce", "run.ctl")),
                        nminfo("run.ctl", useXml=FALSE, useLst=FALSE))
  expect_true("phi" %in% .i$uses)
  expect_equal(nrow(.i$eta), 20L)
  expect_equal(.i$eta$eta1[1], 2.79534e-02)
})

test_that("an ITS then FOCE run validates against NONMEM", {
  skip_on_cran()
  skip_if(.multest("its-foce", "run.ctl") == "")
  withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE,
                           nonmem2rx.overwrite=FALSE), {
    .m <- suppressMessages(nonmem2rx(.multest("its-foce", "run.ctl"),
                                     lst=".lst", compress=FALSE))
  })
  expect_equal(unname(.m$theta[1:3]), c(3.20733, 29.5454, 1.24337), tolerance=1e-5)
  expect_lt(.m$ipredRtol, 1e-3)
  expect_lt(.m$predRtol, 1e-3)
})

test_that("FO + POSTHOC validates with the table etas, not the zero .phi etas", {
  skip_on_cran()
  skip_if(.multest("fo-posthoc", "run.ctl") == "")
  withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE,
                           nonmem2rx.overwrite=FALSE), {
    .m <- suppressMessages(nonmem2rx(.multest("fo-posthoc", "run.ctl"),
                                     lst=".lst", compress=FALSE))
  })
  expect_true(any(.m$etaData$eta1 != 0))
  expect_lt(.m$ipredRtol, 1e-3)
  expect_lt(.m$predRtol, 1e-3)
})
