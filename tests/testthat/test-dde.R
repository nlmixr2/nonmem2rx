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

})
