test_that("plot tests", {
  skip_on_cran()
  mod <- suppressMessages(suppressWarnings(nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res", save=FALSE)))

  expect_error(autoplot(mod), NA)
  
  withr::with_options(list(rxode2.xgxr=TRUE), {
    a <- ggplot2::autoplot(mod)
    vdiffr::expect_doppelganger("first-plot", a)
    a <- ggplot2::autoplot(mod, page=1)
    vdiffr::expect_doppelganger("second-plot", a)
    a <- ggplot2::autoplot(mod, page=1, log="xy")
    vdiffr::expect_doppelganger("second-plot-logxy", a)
  })

  withr::with_options(list(rxode2.xgxr=FALSE), {
    a <- ggplot2::autoplot(mod, page=1)
    vdiffr::expect_doppelganger("second-plot-gg", a)
    a <- ggplot2::autoplot(mod, page=1, log="xy")
    vdiffr::expect_doppelganger("second-plot-gg-logxy", a)
  })

  mod <- rxode2::rxUiDecompress(mod)
  class(mod) <- c("nonmem2rx", "rxUi")

  assign("ipredCompare", NULL, envir=mod)
  
  withr::with_options(list(rxode2.xgxr=TRUE), {
    a <- ggplot2::autoplot(mod)
    vdiffr::expect_doppelganger("first-pred-plot", a)
    a <- ggplot2::autoplot(mod, page=1)
    vdiffr::expect_doppelganger("second-pred-plot", a)
    a <- ggplot2::autoplot(mod, page=1, log="xy")
    vdiffr::expect_doppelganger("second-pred-plot-logxy", a)
  })

  withr::with_options(list(rxode2.xgxr=FALSE), {
    a <- ggplot2::autoplot(mod)
    vdiffr::expect_doppelganger("second-pred-plot-gg", a)
    a <- ggplot2::autoplot(mod, page=1, log="xy")
    vdiffr::expect_doppelganger("second-pred-plot-gg-logxy", a)
  })

  assign("predCompare", NULL, envir=mod)

  expect_warning(plot(mod))

})

test_that("multiple endpoint plots (#171)", {
  skip_on_cran()
  mod <- suppressMessages(suppressWarnings(nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res", save=FALSE)))
  mod <- rxode2::rxUiDecompress(mod)
  # the endpoint does not change the model; this only exercises the
  # endpoint tagging and plotting
  .d <- mod$nonmemData
  .d$DVID <- ifelse(.d$TIME > 24, 2, 1)
  assign("nonmemData", .d, envir=mod)
  suppressMessages(.nonmem2rxValidate(mod))
  class(mod) <- c("nonmem2rx", "rxUi")

  for (.cmp in c("predCompare", "ipredCompare", "iwresCompare")) {
    .c <- mod[[.cmp]]
    expect_equal(names(.c)[1:3], c("ID", "TIME", "ENDPOINT"))
    expect_equal(sort(unique(.c$ENDPOINT)), c("DVID=1", "DVID=2"))
    expect_equal(.c$ENDPOINT == "DVID=2", .c$TIME > 24)
  }

  withr::with_options(list(rxode2.xgxr=FALSE), {
    a <- ggplot2::autoplot(mod)
    vdiffr::expect_doppelganger("multiple-endpoint-plot", a)
    a <- ggplot2::autoplot(mod, page=1)
    vdiffr::expect_doppelganger("multiple-endpoint-page-plot", a)
  })
  # pages count id/endpoint panels
  expect_length(ggplot2::autoplot(mod, page=TRUE), 27L)

  # endpoint only on some of the comparisons
  assign("ipredCompare", mod$ipredCompare[, -3], envir=mod)
  expect_error(ggplot2::autoplot(mod), NA)
  expect_error(ggplot2::autoplot(mod, page=1), NA)
})

test_that(".nonmemEndpoint()", {
  .in <- data.frame(ID=1, TIME=1:4, EVID=c(1, 0, 0, 0), CMT=c(1, 2, 3, 2))
  .out <- data.frame(ID=1, TIME=2:4)
  .obs <- .nonmemObsIndex(.in)
  # from the input data
  expect_equal(.nonmemEndpoint(.out, .in, .obs), c("CMT=2", "CMT=3", "CMT=2"))
  # DVID takes precedence over CMT
  .in$DVID <- c(0, 1, 1, 2)
  expect_equal(.nonmemEndpoint(.out, .in, .obs), c("DVID=1", "DVID=1", "DVID=2"))
  # single DVID means one endpoint
  .in$DVID <- 1
  expect_null(.nonmemEndpoint(.out, .in, .obs))
  # output table columns are preferred
  .out$cmt <- c(4, 5, 4)
  expect_equal(.nonmemEndpoint(.out, .in, .obs), c("cmt=4", "cmt=5", "cmt=4"))
  # cannot align rows
  .out$cmt <- NULL
  .in$DVID <- NULL
  expect_null(.nonmemEndpoint(.out, .in, .obs[-1]))
  expect_null(.nonmemEndpoint(.out, NULL, .obs))
  expect_equal(.sortEndpoint(c("CMT=10", "CMT=2", "NA")), c("CMT=2", "CMT=10", "NA"))
})
