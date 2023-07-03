.nonmem2rx <- function(..., save=FALSE) {
  suppressWarnings(suppressMessages(nonmem2rx(..., save=FALSE)))
}

test_that("eta order", {
  f <- .nonmem2rx(system.file("run-153.lst", package="nonmem2rx"))
  expect_equal(dimnames(f$omega)[[1]],
               c("BSV.KTR", "BSV.Vp", "BSV.BIO", "BSV.Q", "BSV.CLint", "BSV.Vc"))
  expect_false(abs(f$omega["BSV.Vc", "BSV.CLint"]) < 1e-5)
})
