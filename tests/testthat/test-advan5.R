test_that("test advan5/advan7 translations", {
  
  .a <- function(k, clear=FALSE) {
    if (clear) .clearNonmem2rx()
    .nonmem2rx$advan <- 5L
    .advan5handleK(k)
    list(advan5=.nonmem2rx$advan5,
         advan5k=.nonmem2rx$advan5k,
         advan5max=.nonmem2rx$advan5max)
  }


  expect_equal(.a("k15", clear=TRUE),
               list(advan5 = c("-k15*rxddta1", "", "", "", "+k15*rxddta1"), advan5k = "k15", advan5max = 5))

  expect_equal(.a("k56"),
               list(advan5 = c("-k15*rxddta1", "", "", "",
                               "+k15*rxddta1-k56*rxddta5",
                               "+k56*rxddta5"),
                    advan5k = c("k15", "k56"), advan5max = 6))

  expect_equal(.a("K67"),
               list(advan5 = c("-k15*rxddta1", "", "", "",
                               "+k15*rxddta1-k56*rxddta5",
                               "+k56*rxddta5-K67*rxddta6",
                               "+K67*rxddta6"),
                    advan5k = c("k15", "k56", "K67"),
                    advan5max = 7))

  expect_equal(.a("K74"),
               list(advan5 = c("-k15*rxddta1", "", "",
                               "+K74*rxddta7", "+k15*rxddta1-k56*rxddta5",
                               "+k56*rxddta5-K67*rxddta6",
                               "+K67*rxddta6-K74*rxddta7"),
                    advan5k = c("k15", "k56", "K67", "K74"),
                    advan5max = 7))

  expect_equal(.a("K42"),
               list(advan5 = c("-k15*rxddta1", "+K42*rxddta4", "",
                               "+K74*rxddta7-K42*rxddta4", "+k15*rxddta1-k56*rxddta5",
                               "+k56*rxddta5-K67*rxddta6", "+K67*rxddta6-K74*rxddta7"),
                    advan5k = c("k15", "k56", "K67", "K74", "K42"),
                    advan5max = 7))

  expect_equal(.a("K42"),
               list(advan5 = c("-k15*rxddta1", "+K42*rxddta4", "",
                               "+K74*rxddta7-K42*rxddta4", "+k15*rxddta1-k56*rxddta5",
                               "+k56*rxddta5-K67*rxddta6", "+K67*rxddta6-K74*rxddta7"),
                    advan5k = c("k15", "k56", "K67", "K74", "K42"),
                    advan5max = 7))

  expect_equal(.a("K40"),
               list(advan5 = c("-k15*rxddta1", "+K42*rxddta4", "",
                               "+K74*rxddta7-K42*rxddta4-K40*rxddta4",
                               "+k15*rxddta1-k56*rxddta5", "+k56*rxddta5-K67*rxddta6",
                               "+K67*rxddta6-K74*rxddta7"),
                    advan5k = c("k15", "k56", "K67", "K74", "K42", "K40"), advan5max =7))

  expect_equal(.a("K24"),
               list(advan5 = c("-k15*rxddta1", "+K42*rxddta4-K24*rxddta2", "",
                               "+K74*rxddta7-K42*rxddta4-K40*rxddta4+K24*rxddta2",
                               "+k15*rxddta1-k56*rxddta5", "+k56*rxddta5-K67*rxddta6",
                               "+K67*rxddta6-K74*rxddta7"),
                    advan5k = c("k15", "k56", "K67", "K74", "K42", "K40", "K24"), advan5max = 7))

  expect_equal(.a("K24"),
               list(advan5 = c("-k15*rxddta1", "+K42*rxddta4-K24*rxddta2", "",
                               "+K74*rxddta7-K42*rxddta4-K40*rxddta4+K24*rxddta2",
                               "+k15*rxddta1-k56*rxddta5", "+k56*rxddta5-K67*rxddta6",
                               "+K67*rxddta6-K74*rxddta7"),
                    advan5k = c("k15", "k56", "K67", "K74", "K42", "K40", "K24"), advan5max = 7))

  expect_equal(.a("K23"),
               list(advan5 =
                      c("-k15*rxddta1",
                        "+K42*rxddta4-K24*rxddta2-K23*rxddta2",
                        "+K23*rxddta2", "+K74*rxddta7-K42*rxddta4-K40*rxddta4+K24*rxddta2",
                        "+k15*rxddta1-k56*rxddta5", "+k56*rxddta5-K67*rxddta6",
                        "+K67*rxddta6-K74*rxddta7"),
                    advan5k = c("k15", "k56", "K67", "K74", "K42", "K40", "K24", "K23"), advan5max = 7))

  expect_equal(.a("K32"),
               list(advan5 = c("-k15*rxddta1", "+K42*rxddta4-K24*rxddta2-K23*rxddta2+K32*rxddta3",
                               "+K23*rxddta2-K32*rxddta3", "+K74*rxddta7-K42*rxddta4-K40*rxddta4+K24*rxddta2",
                               "+k15*rxddta1-k56*rxddta5", "+k56*rxddta5-K67*rxddta6", "+K67*rxddta6-K74*rxddta7"),
                    advan5k = c("k15", "k56", "K67", "K74", "K42", "K40", "K24", "K23", "K32"), advan5max = 7))

  expect_equal(.a("K10T0"),
               list(advan5 = c("-k15*rxddta1", "+K42*rxddta4-K24*rxddta2-K23*rxddta2+K32*rxddta3",
                               "+K23*rxddta2-K32*rxddta3", "+K74*rxddta7-K42*rxddta4-K40*rxddta4+K24*rxddta2",
                               "+k15*rxddta1-k56*rxddta5", "+k56*rxddta5-K67*rxddta6", "+K67*rxddta6-K74*rxddta7",
                               "", "", "-K10T0*rxddta10"),
                    advan5k = c("k15", "k56", "K67", "K74", "K42", "K40", "K24", "K23", "K32", "K10T0"),
                    advan5max = 10))

  expect_equal(.advan5odes(),
               "\nd/dt(rxddta1) <- -k15*rxddta1\nd/dt(rxddta2) <- K42*rxddta4-K24*rxddta2-K23*rxddta2+K32*rxddta3\nd/dt(rxddta3) <- K23*rxddta2-K32*rxddta3\nd/dt(rxddta4) <- K74*rxddta7-K42*rxddta4-K40*rxddta4+K24*rxddta2\nd/dt(rxddta5) <- k15*rxddta1-k56*rxddta5\nd/dt(rxddta6) <- k56*rxddta5-K67*rxddta6\nd/dt(rxddta7) <- K67*rxddta6-K74*rxddta7\nd/dt(rxddta10) <- -K10T0*rxddta10")

})

test_that("advan5/7 matrix-exponential rate-constant edge capture", {
  .clearNonmem2rx()
  .nonmem2rx$advan <- 5L
  # depot(1) -> central(2), central(2) -> periph(3), periph(3) -> central(2),
  # central(2) -> elimination (0)
  .advan5handleK("K12")
  .advan5handleK("K23")
  .advan5handleK("K32")
  .advan5handleK("K20")
  expect_equal(.nonmem2rx$advan5edges,
               data.frame(from=c(1, 2, 3, 2),
                          to=c(2, 3, 2, 0),
                          k=c("K12", "K23", "K32", "K20"),
                          stringsAsFactors=FALSE))
  # a repeated K is only captured once (matches advan5k dedup)
  .advan5handleK("K12")
  expect_equal(nrow(.nonmem2rx$advan5edges), 4L)
})

test_that("nonmem2rx(matexp=TRUE) translates ADVAN5 to a matExp() model equal to the ODE model", {
  skip_on_cran()
  # matrix-exponential (matExp()/indLin) support in rxode2 is required
  skip_if_not(exists("indLin", where=asNamespace("rxode2"), inherits=FALSE),
              "installed rxode2 lacks matExp()/indLin support")
  .f <- system.file("mods/advan5/advan5.ctl", package="nonmem2rx")
  skip_if(.f == "")
  .ode <- nonmem2rx(.f, validate=FALSE, save=FALSE, load=FALSE, matexp=FALSE)
  .mex <- nonmem2rx(.f, validate=FALSE, save=FALSE, load=FALSE, matexp=TRUE)
  .no <- rxode2::rxNorm(.ode)
  .nm <- rxode2::rxNorm(.mex)
  # default (ODE) path: explicit d/dt(), no matExp()
  expect_false(grepl("matExp()", .no, fixed=TRUE))
  expect_true(grepl("d/dt(CENTRAL)", .no, fixed=TRUE))
  # matexp path: native matExp() block, no d/dt() for the linear system
  expect_true(grepl("matExp()", .nm, fixed=TRUE))
  expect_true(grepl("k_DEPOT_CENTRAL", .nm, fixed=TRUE))
  expect_true(grepl("k_CENTRAL_PERIPH", .nm, fixed=TRUE))
  expect_true(grepl("k_PERIPH_CENTRAL", .nm, fixed=TRUE))
  expect_true(grepl("k_CENTRAL_output", .nm, fixed=TRUE))
  expect_false(grepl("d/dt(", .nm, fixed=TRUE))
  # both models solve to the same values when random effects are zeroed
  .ev <- rxode2::et(amt=100, cmt="DEPOT")
  .ev <- rxode2::et(.ev, seq(0, 24, by=4))
  .so <- suppressWarnings(rxode2::rxSolve(rxode2::zeroRe(.ode), .ev, returnType="data.frame",
                                          addDosing=FALSE, atol=1e-10, rtol=1e-10))
  .sm <- suppressWarnings(rxode2::rxSolve(rxode2::zeroRe(.mex), .ev, returnType="data.frame",
                                          addDosing=FALSE, atol=1e-10, rtol=1e-10))
  expect_equal(.so$ipred, .sm$ipred, tolerance=1e-5)
})
