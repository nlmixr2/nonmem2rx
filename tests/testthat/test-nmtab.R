test_that("nmtab renames ETA(n)/THETA(n)/ERR(n)/EPS(n) columns to ETAn etc.", {
  .f <- system.file("mods/cpt/runODE032paren.csv", package = "nonmem2rx")
  .ret <- nmtab(.f)
  expect_true("ETA1" %in% names(.ret))
  expect_true("ETA2" %in% names(.ret))
  expect_false(any(grepl("[(]", names(.ret))))
})
