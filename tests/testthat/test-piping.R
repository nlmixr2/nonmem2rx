.nonmem2rx <- function(..., save=FALSE) {
  suppressWarnings(suppressMessages(nonmem2rx(..., save=FALSE)))
}

withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE),{
  test_that("piping works", {
    skip_on_cran()

    f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res",
                    keep=NULL)

    expect_true(inherits(f, "nonmem2rx"))
    expect_false(is.null(f$nonmemData))
    expect_true(!is.null(f$dfSub))

    f2 <- f %>% ini(eta1 ~ 0.1)
    expect_true(inherits(f2, "nonmem2rx"))
    expect_false(is.null(f2$nonmemData))
    expect_true(is.null(f2$dfSub))

    f2 <- f %>% model(cl <- exp(theta1))
    expect_true(inherits(f2, "nonmem2rx"))
    expect_false(is.null(f2$nonmemData))
    expect_true(is.null(f2$dfSub))

    f2 <- f %>% ini(eta1=fixed)
    expect_false(is.null(f2$nonmemData))
    expect_true(!is.null(f2$dfSub))
    expect_true(inherits(f2, "nonmem2rx"))

    f2 <- f %>% rxRename(eta.v=eta2)
    expect_false(is.null(f2$nonmemData))
    expect_true(!is.null(f2$dfSub))
    expect_true(inherits(f2, "nonmem2rx"))

    f2 <- f %>% dplyr::rename(eta.v=eta2)
    expect_false(is.null(f2$nonmemData))
    expect_true(!is.null(f2$dfSub))
    expect_true(inherits(f2, "nonmem2rx"))



  })

  test_that("a state appended by piping is kept when solving (#246)", {
    skip_on_cran()

    f <- .nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res",
                    keep=NULL)

    # nonmem2rx marks the NONMEM metadata sticky, so the `meta` environment (which
    # caches the simulation model in `.simModelBase`) survives piping.  Realize the
    # simulation model first so the cache is primed before the model changes; the
    # piped model must not pick up the pre-append cached model
    # (nlmixr2/rxode2#1149).
    expect_false(is.null(f$simulationModel))

    fAuc <- f %>% model(d/dt(AUC) <- f, append=TRUE)

    expect_true("AUC" %in% rxode2::rxState(fAuc))
    expect_true("AUC" %in% rxode2::rxModelVars(fAuc$simulationModel)$state)

    ev <- rxode2::et(amt=120000, ii=12, until=24) %>%
      rxode2::et(c(0, 4, 8, 11.999, 12, 24))

    s <- rxode2::rxSolve(fAuc, ev, returnType="data.frame")
    expect_true("AUC" %in% names(s))
    expect_true(any(s$AUC > 0))
  })
})
