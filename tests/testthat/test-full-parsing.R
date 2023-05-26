.nonmem2rx <- function(..., save=FALSE) {
  suppressMessages(nonmem2rx(..., save=FALSE))
}

withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE,
                         nonmem2rx.extended=FALSE, nlmixr2.collectWarnings=FALSE), {
                           test_that("full parsing", {
                             skip_on_cran()
                             expect_warning(.nonmem2rx(system.file("run001.mod",
                                                                   package="nonmem2rx")))
                           })
                         })
