.nonmem2rx <- function(..., save=FALSE) {
  suppressWarnings(suppressMessages(nonmem2rx(..., save=FALSE)))
}

test_that("numeric import works for data", {
  skip_on_cran()
  mod <- withr::with_tempdir({
    lines <- suppressWarnings(readLines(system.file("mods/err/run001.res",
                                                    package="nonmem2rx")))
    lines[22] <- "$DATA warfarin_PKS.csv IGNORE=(id='ID')"
    writeLines(lines, con="run001.res")

    file.copy(system.file("mods/err/warfarin_PKS.csv", package="nonmem2rx"),
              file.path(getwd(), "warfarin_PKS.csv"))

    file.copy(system.file("mods/err/run001.csv", package="nonmem2rx"),
              file.path(getwd(), "run001.csv"))

    .nonmem2rx("run001.res")
  })
  expect_true(grepl("PRED", mod$meta$validation[1]))
})
