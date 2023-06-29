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
