.nonmem2rx <- function(...) {
  suppressMessages(nonmem2rx(...))
}

withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE,
                         nonmem2rx.extended=FALSE),
{
  test_that("full parsing", {
    expect_warning(.nonmem2rx(system.file("run001.mod", package="nonmem2rx")))
  })
})
