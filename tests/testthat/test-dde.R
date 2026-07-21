test_that(".pruneConstPast drops constant histories equal to the init", {

  .prune <- function(lines) {
    .clearNonmem2rx()
    assign("model", lines, envir=.nonmem2rx)
    suppressMessages(.pruneConstPast())
    .nonmem2rx$model
  }

  # constant history equal to an explicit parameter init is dropped (Appendix 3)
  expect_equal(
    .prune(c("rxini.rxddta1. <- Y0",
             "rxddta1(0) <- rxini.rxddta1.",
             "past(rxddta1, TAU1) <- Y0",
             "d/dt(rxddta1) <-  - K * delay(rxddta1, TAU1)")),
    c("rxini.rxddta1. <- Y0",
      "rxddta1(0) <- rxini.rxddta1.",
      "d/dt(rxddta1) <-  - K * delay(rxddta1, TAU1)"))

  # zero history equal to the default (0) init is dropped; zero history that
  # differs from an explicit init (W0) is kept (Appendix 6)
  expect_equal(
    .prune(c("rxini.rxddta3. <- W0",
             "rxddta3(0) <- rxini.rxddta3.",
             "past(rxddta2, TAU1) <- 0",
             "past(rxddta3, TAU1) <- 0")),
    c("rxini.rxddta3. <- W0",
      "rxddta3(0) <- rxini.rxddta3.",
      "past(rxddta3, TAU1) <- 0"))

  # non-constant (time-dependent) history is always kept (Appendix 7)
  expect_equal(
    .prune("past(rxddta1, TAU1) <- AA * exp(BB * t)"),
    "past(rxddta1, TAU1) <- AA * exp(BB * t)")

  # parameter-valued constant history equal to the init is dropped (Appendix 11)
  expect_equal(
    .prune(c("rxini.rxddta2. <- K0/K1",
             "past(rxddta2, TAU1) <- K0/K1")),
    "rxini.rxddta2. <- K0/K1")

  # redundant parentheses do not block pruning of an equivalent constant history
  expect_equal(
    .prune(c("rxini.rxddta1. <- Y0",
             "past(rxddta1, TAU1) <- (Y0)")),
    "rxini.rxddta1. <- Y0")
  expect_equal(
    .prune(c("rxini.rxddta2. <- (K0/K1)",
             "past(rxddta2, TAU1) <- K0/K1")),
    "rxini.rxddta2. <- (K0/K1)")

})

test_that(".exprEqual ignores redundant parentheses", {
  expect_true(.exprEqual("Y0", "(Y0)"))
  expect_true(.exprEqual("K0/K1", "(K0/K1)"))
  expect_true(.exprEqual("a * exp(b * t)", "(a * exp(b * t))"))
  expect_true(.exprEqual("0", "(0)"))
  expect_false(.exprEqual("Y0", "Y1"))
  expect_false(.exprEqual("K0/K1", "K0/K2"))
})

withr::with_options(
  list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE,
       nonmem2rx.validate=FALSE, nlmixr2.collectWarnings=FALSE), {

  .ddeTrans <- function(f) {
    suppressMessages(nonmem2rx(system.file(f, package="nonmem2rx"),
                               validate=FALSE, updateFinal=FALSE, determineError=FALSE,
                               useLst=FALSE, useExt=FALSE, usePhi=FALSE, useCov=FALSE,
                               useXml=FALSE))
  }
  .modelTxt <- function(r) paste(deparse(body(r$fun)), collapse="\n")
  .allFinite <- function(r, ev, states) {
    # delay models solve on the dense dop853+ros4 composite; ros4 warns when an
    # analytic Jacobian cannot be built and falls back to dop853 (dense, which
    # is what delays require) -- a benign, expected warning here
    s <- suppressWarnings(
      rxode2::rxSolve(r, ev, returnType="data.frame", atol=1e-8, rtol=1e-8))
    all(vapply(states, function(st) all(is.finite(s[[st]])), logical(1)))
  }

  test_that("Appendix 3 stiff DDE (ADVAN16) translates and solves", {
    skip_on_cran()
    r <- .ddeTrans("dde/app3-stiff-2cmt.ctl")
    txt <- .modelTxt(r)
    # AD_1_1 -> delay() on the stiff two-compartment model
    expect_match(txt, "delay(rxddta1, tau1)", fixed=TRUE)
    # constant past AP_1_1=Y0 equals the init, so no past() line remains
    expect_false(grepl("past(", txt, fixed=TRUE))
    ev <- rxode2::et(amt=1, cmt="rxddta1", time=0.5)
    ev <- rxode2::et(ev, seq(0, 8, by=0.5))
    ev <- rxode2::et(ev, CMT=1)
    expect_true(.allFinite(r, ev, c("rxddta1", "rxddta2")))
  })

  test_that("Appendix 6 lifespan TGI (ADVAN16) translates and solves", {
    skip_on_cran()
    r <- .ddeTrans("dde/app6-tgi.ctl")
    txt <- .modelTxt(r)
    # shared delay TAU1 on two states
    expect_match(txt, "delay(rxddta2, tau1)", fixed=TRUE)
    expect_match(txt, "delay(rxddta3, tau1)", fixed=TRUE)
    # AP_2_1=0 equals default init (dropped); AP_3_1=0 differs from init W0 (kept)
    expect_false(grepl("past(rxddta2", txt, fixed=TRUE))
    expect_match(txt, "past(rxddta3, tau1) <- 0", fixed=TRUE)
    ev <- rxode2::et(amt=100, cmt="rxddta1", time=0)
    ev <- rxode2::et(ev, seq(0, 20, by=1))
    ev <- rxode2::et(ev, CMT=3)
    expect_true(.allFinite(r, ev, c("rxddta1", "rxddta2", "rxddta3", "rxddta4")))
  })

  test_that("Appendix 7 rheumatoid arthritis (ADVAN16) keeps non-constant past()", {
    skip_on_cran()
    r <- .ddeTrans("dde/app7-ra.ctl")
    txt <- .modelTxt(r)
    expect_match(txt, "delay(rxddta1, tau1)", fixed=TRUE)
    # non-constant history AP_1_1 = AA*EXP(BB*T); NONMEM T -> rxode2 t; kept
    expect_match(txt, "past(rxddta1, tau1) <- aa * exp(bb * t)", fixed=TRUE)
    ev <- rxode2::et(seq(0, 25, by=0.5))
    ev <- rxode2::et(ev, CMT=2)
    expect_true(.allFinite(r, ev, c("rxddta1", "rxddta2")))
  })

  test_that("DDE delay()/past() survive into an nlmixr2 model", {
    skip_on_cran()
    # nonmem2rx does not need nlmixr2est; only exercise it when installed, and
    # keep the (heavier) nlmixr2est path off CI
    skip_on_ci()
    skip_if_not_installed("nlmixr2est")
    # a delay model with a residual error model, function interface as used by
    # nlmixr2; confirms nlmixr2est understands delay()/past() (full FOCEi
    # estimation of delay models is verified manually -- too heavy for the suite)
    dde <- function() {
      ini({
        kg <- 0.4
        k4 <- 0.3
        tt <- 5
        aa <- 2
        bb <- -0.25
        prop.sd <- 0.1
      })
      model({
        A1(0) <- aa
        past(A1, tt) <- aa * exp(bb * t)
        d/dt(A1) <- 1 - kg * A1
        d/dt(A2) <- k4 * A1 - k4 * delay(A1, tt)
        cp <- A2
        cp ~ prop(prop.sd)
      })
    }
    ui <- nlmixr2est::nlmixr(dde)
    mt <- paste(deparse(ui$funPrint), collapse="\n")
    expect_match(mt, "delay(A1, tt)", fixed=TRUE)
    expect_match(mt, "past(A1, tt)", fixed=TRUE)
  })

  test_that("Appendix 11 PDLIDR (ADVAN13 ;DDE) translates and solves", {
    skip_on_cran()
    r <- .ddeTrans("dde/app11-pdlidr-advan13.ctl")
    txt <- .modelTxt(r)
    # parameter delay TAU1 = THETA*EXP(ETA); AD_2_1 -> delay()
    expect_match(txt, "delay(rxddta2, tau1)", fixed=TRUE)
    # parameter past AP_2_1=K0/K1 equals init A_0(2)=K0/K1 (dropped)
    expect_false(grepl("past(", txt, fixed=TRUE))
    ev <- rxode2::et(amt=0.1, cmt="rxddta1", time=0)
    ev <- rxode2::et(ev, seq(0, 28, by=1))
    ev <- rxode2::et(ev, CMT=3)
    expect_true(.allFinite(r, ev, c("rxddta1", "rxddta2", "rxddta3")))
  })

})
