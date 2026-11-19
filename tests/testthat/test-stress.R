## The stress kit's translate mode (no NONMEM): simulate each case with
## rxode2, write the control stream and data, import with nonmem2rx and
## compare with the truth.  A sample by default; every case with
## NONMEM2RX_STRESS_ALL=true.  See inst/stress/README.md.
test_that("stress kit translate mode", {
  skip_on_cran()
  .stress <- system.file("stress", "stress.R", package="nonmem2rx")
  skip_if(.stress == "", "stress kit not installed")
  skip_if_not_installed("withr")
  suppressMessages(source(.stress, local=TRUE))
  withr::defer(detach("nonmem2rx-stress", character.only=TRUE))
  .all <- identical(Sys.getenv("NONMEM2RX_STRESS_ALL"), "true")
  .cases <- if (.all) NULL else
    "^(advan1-trans2-bolus|advan4-trans6-macro|advan7-unnamed-comp|rate-minus2-modeled-dur|ss2-asymmetric-bid|evid4-reset-dose|ignore-hash-and-list|clock-time-date|omega-sd-correlation|logical-not-and-slash-ne)$"
  .res <- suppressMessages(stressKit(modes="translate", cases=.cases,
                                     bundle=FALSE, out=withr::local_tempdir()))
  .bad <- .res[.res$status %in% c("FAIL", "ERROR", "XPASS"), , drop=FALSE]
  expect_equal(nrow(.bad), 0L,
               info=paste(.bad$case, .bad$status, .bad$note, collapse="\n"))
  if (!.all) expect_equal(nrow(.res), 10L)
})
