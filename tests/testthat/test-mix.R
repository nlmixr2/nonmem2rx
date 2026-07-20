test_that("NONMEM $MIX translates to a native rxode2/nlmixr2 mix() model", {
  skip_on_cran()

  .f <- system.file("mods/bauer_2019_cptpsp_tutorial_2/supp7/pmixture_foce.ctl",
                    package = "nonmem2rx")
  skip_if(.f == "", "bauer supp7 pmixture fixture not installed")

  .m <- suppressWarnings(nonmem2rx(.f, validate = FALSE, save = FALSE))
  .model <- paste(deparse(.m$modelFun), collapse = "\n")

  # The mixture machinery in nlmixr2est is driven by ui$mixProbs; a native
  # translation must register it (here from P(1)=THETA(5), named "Initial").
  expect_true(length(.m$mixProbs) > 0)
  expect_equal(.m$mixProbs, "Initial")

  # A real mix() call is emitted so the UI populates mixProbs on parse.
  expect_match(.model, "mix\\(", perl = TRUE)

  # MIXNUM/MIXEST branching is driven by the reserved `mixest`, not the old
  # rxord() simulation.
  expect_match(.model, "mixest", perl = TRUE)
  expect_no_match(.model, "rxord\\(", perl = TRUE)

  # BESTSUB = MIXEST becomes the assigned component (mixest via the alias).
  expect_match(.model, "rxm.bestsub", perl = TRUE)
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
