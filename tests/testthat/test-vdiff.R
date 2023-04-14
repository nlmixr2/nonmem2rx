test_that("plot tests", {
  
  mod <- suppressMessages(suppressWarnings(nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res", save=FALSE)))

  expect_error(autoplot(mod), NA)
  
  withr::with_options(list(rxode2.xgxr=TRUE), {
    a <- ggplot2::autoplot(mod, page=1)
    vdiffr::expect_doppelganger("first-plot", a[[1]])
    vdiffr::expect_doppelganger("second-plot", a[[1]])
    a <- ggplot2::autoplot(mod, page=1, log="xy")
    vdiffr::expect_doppelganger("second-plot-logxy", a[[1]])
  })

  withr::with_options(list(rxode2.xgxr=FALSE), {
    a <- ggplot2::autoplot(mod, page=1)
    vdiffr::expect_doppelganger("second-plot-gg", a[[1]])
    a <- ggplot2::autoplot(mod, page=1, log="xy")
    vdiffr::expect_doppelganger("second-plot-gg-logxy", a[[1]])
  })

  mod <- rxode2::rxUiDecompress(mod)
  class(mod) <- c("nonmem2rx", "rxUi")

  assign("ipredCompare", NULL, envir=mod)
  
  withr::with_options(list(rxode2.xgxr=TRUE), {
    a <- ggplot2::autoplot(mod, page=1)
    vdiffr::expect_doppelganger("first-pred-plot", a[[1]])
    vdiffr::expect_doppelganger("second-pred-plot", a[[1]])
    a <- ggplot2::autoplot(mod, page=1, log="xy")
    vdiffr::expect_doppelganger("second-pred-plot-logxy", a[[1]])
  })

  withr::with_options(list(rxode2.xgxr=FALSE), {
    a <- ggplot2::autoplot(mod, page=1)
    vdiffr::expect_doppelganger("second-pred-plot-gg", a[[1]])
    a <- ggplot2::autoplot(mod, page=1, log="xy")
    vdiffr::expect_doppelganger("second-pred-plot-gg-logxy", a[[1]])
  })

  assign("predCompare", NULL, envir=mod)

  expect_warning(plot(mod))

  
})
