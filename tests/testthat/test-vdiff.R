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
    expect_equal(names(.c)[c(1:2, 5)], c("ID", "TIME", "ENDPOINT"))
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

  # endpoint only on some of the comparisons; no endpoint split
  assign("ipredCompare", mod$ipredCompare[, -5], envir=mod)
  a <- ggplot2::autoplot(mod)
  expect_false(any(names(a$data) == "endpoint"))
  expect_length(ggplot2::autoplot(mod, page=TRUE), 14L)
})

test_that(".nonmemEndpoint()", {
  .in <- data.frame(ID=1, TIME=1:4, EVID=c(1, 0, 0, 0), CMT=c(1, 2, 3, 2))
  .out <- data.frame(ID=1, TIME=2:4)
  # from the input data
  expect_equal(.nonmemEndpoint(.out, .in), c("CMT=2", "CMT=3", "CMT=2"))
  # DVID takes precedence over CMT
  .in$DVID <- c(0, 1, 1, 2)
  expect_equal(.nonmemEndpoint(.out, .in), c("DVID=1", "DVID=1", "DVID=2"))
  # a single DVID falls back to CMT
  .in$DVID <- 1
  expect_equal(.nonmemEndpoint(.out, .in), c("CMT=2", "CMT=3", "CMT=2"))
  # one endpoint
  .in$CMT <- 2
  expect_null(.nonmemEndpoint(.out, .in))
  # output table columns are preferred
  .out$cmt <- c(4, 5, 4)
  expect_equal(.nonmemEndpoint(.out, .in), c("cmt=4", "cmt=5", "cmt=4"))
  # cannot align rows
  .out$cmt <- NULL
  .in$CMT <- c(1, 2, 3, 2)
  expect_null(.nonmemEndpoint(.out[-1, ], .in))
  expect_null(.nonmemEndpoint(.out, NULL))
  expect_equal(.sortEndpoint(c("CMT=10", "CMT=2")), c("CMT=2", "CMT=10"))
})
