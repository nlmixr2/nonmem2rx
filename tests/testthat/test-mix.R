test_that(".nonmemMixCall interleaves components and probabilities", {
  expect_equal(nonmem2rx:::.nonmemMixCall(c("a", "b"), "p1"),
               "mix(a, p1, b)")
  expect_equal(nonmem2rx:::.nonmemMixCall(c("a", "b", "c"), c("p1", "p2")),
               "mix(a, p1, b, p2, c)")
})

test_that(".nonmemMixCollapse rewrites per-component `if` groups into mix()", {
  .collapse <- nonmem2rx:::.nonmemMixCollapse

  # Pattern: default sentinel + one `if` per component (the cur.mixp idiom)
  .lines <- c("cur.mixp <- -1",
              "if (NMMIXNUM == 1) cur.mixp <- rxp.1.",
              "if (NMMIXNUM == 2) cur.mixp <- rxp.2.")
  .r <- .collapse(.lines, 2L, "p1")
  expect_true(.r$emittedMix)
  expect_equal(.r$lines, "cur.mixp <- mix(rxp.1., p1, rxp.2.)")

  # Pattern: default value + single override (the Q idiom)
  .r2 <- .collapse(c("Q <- 1", "if (NMMIXNUM == 2) Q <- 0"), 2L, "p1")
  expect_true(.r2$emittedMix)
  expect_equal(.r2$lines, "Q <- mix(1, p1, 0)")

  # Pattern: only per-component `if`s, no default
  .r3 <- .collapse(c("if (NMMIXNUM == 1) TVCL <- theta1",
                     "if (NMMIXNUM == 2) TVCL <- theta2"), 2L, "p1")
  expect_true(.r3$emittedMix)
  expect_equal(.r3$lines, "TVCL <- mix(theta1, p1, theta2)")

  # Three sub-populations
  .r4 <- .collapse(c("if (NMMIXNUM == 1) V <- v1",
                     "if (NMMIXNUM == 2) V <- v2",
                     "if (NMMIXNUM == 3) V <- v3"), 3L, c("p1", "p2"))
  expect_equal(.r4$lines, "V <- mix(v1, p1, v2, p2, v3)")

  # newline-joined `if` block (as emitted by the mixture handler) is split first
  .r5 <- .collapse(c("cur.mixp <- -1",
                     "if (NMMIXNUM == 1) cur.mixp <- rxp.1.\nif (NMMIXNUM == 2) cur.mixp <- rxp.2."),
                   2L, "p1")
  expect_equal(.r5$lines, "cur.mixp <- mix(rxp.1., p1, rxp.2.)")
})

test_that(".nonmemMixCollapse leaves non-collapsible code untouched", {
  .collapse <- nonmem2rx:::.nonmemMixCollapse

  # a plain assignment with no following mixture `if` is not a mixture group
  .r <- .collapse(c("Q <- 1", "V <- Q * VCM"), 2L, "p1")
  expect_false(.r$emittedMix)
  expect_equal(.r$lines, c("Q <- 1", "V <- Q * VCM"))

  # incomplete coverage (missing a component) is not collapsed
  .r2 <- .collapse(c("if (NMMIXNUM == 1) V <- v1"), 2L, "p1")
  expect_false(.r2$emittedMix)
  expect_equal(.r2$lines, "if (NMMIXNUM == 1) V <- v1")

  # references to NMMIXNUM that are not a component assignment are preserved
  .r3 <- .collapse(c("BESTSUB <- NMMIXNUM"), 2L, "p1")
  expect_false(.r3$emittedMix)
  expect_equal(.r3$lines, "BESTSUB <- NMMIXNUM")
})

test_that("NONMEM $MIX translates to a native rxode2/nlmixr2 mix() model", {
  skip_on_cran()

  .f <- system.file("mods/bauer_2019_cptpsp_tutorial_2/supp7/pmixture_foce.ctl",
                    package = "nonmem2rx")
  skip_if(.f == "", "bauer supp7 pmixture fixture not installed")

  .m <- suppressWarnings(nonmem2rx(.f, validate = FALSE, save = FALSE))
  .model <- paste(deparse(.m$modelFun), collapse = "\n")

  # nlmixr2est mixtures are driven by ui$mixProbs; a native translation registers it
  expect_true(length(.m$mixProbs) > 0)
  expect_equal(.m$mixProbs, "Initial")

  # the imperative MIXNUM/MIXEST code collapses to readable mix() calls
  expect_match(.model, "mix\\(", perl = TRUE)
  # no leftover simulation scaffolding once real mix() calls carry the probabilities
  expect_no_match(.model, "rxord\\(", perl = TRUE)
  expect_no_match(.model, "mixdummy", perl = TRUE, ignore.case = TRUE)
  expect_no_match(.model, "nmmixnum", perl = TRUE, ignore.case = TRUE)

  # BESTSUB = MIXEST becomes the assigned component (the reserved mixest)
  expect_match(.model, "mixest", perl = TRUE)
})

test_that("native mixture emission generalizes across the bauer mixture fixtures", {
  skip_on_cran()

  .files <- c("mods/bauer_2019_cptpsp_tutorial_2/supp7/pmixture_foce.ctl",
              "mods/bauer_2019_cptpsp_tutorial_2/supp7/pmixture_saem.ctl",
              "mods/bauer_2019_cptpsp_tutorial_2/supp7/pmixture_bayes.ctl")

  for (.rel in .files) {
    .f <- system.file(.rel, package = "nonmem2rx")
    if (.f == "") next
    .m <- suppressWarnings(nonmem2rx(.f, validate = FALSE, save = FALSE))
    .model <- paste(deparse(.m$modelFun), collapse = "\n")
    expect_true(length(.m$mixProbs) > 0, info = .rel)
    expect_match(.model, "mix\\(", perl = TRUE, info = .rel)
    expect_no_match(.model, "rxord\\(", perl = TRUE, info = .rel)
  }
})
