test_that("test input", {
  
  .i <- function(input, eq="no") {
    .clearNonmem2rx()
    .Call(`_nonmem2rx_trans_input`, input)
    expect_equal(.nonmem2rx$input, eq)
  }

  expect_error(.i(","))

  .i("date=drop", c(date="DROP"))
  .i("date=skip", c(date="DROP"))
  .i("date=Drop", c(date="DROP"))
  .i("date=Skip", c(date="DROP"))
  .i("date=DROP", c(date="DROP"))
  .i("date=SKIP", c(date="DROP"))
  .i("drop=date", c(date="DROP"))
  .i("skip=date", c(date="DROP"))
  .i("Drop=date", c(date="DROP"))
  .i("Skip=date", c(date="DROP"))
  .i("DROP=date", c(date="DROP"))
  .i("SKIP=date", c(date="DROP"))
  .i("drop", c(DROP="DROP"))
  .i("skip", c(DROP="DROP"))
  .i("Drop", c(DROP="DROP"))
  .i("Skip", c(DROP="DROP"))
  .i("DROP", c(DROP="DROP"))
  .i("SKIP", c(DROP="DROP"))
  .i("a", c(a="a"))
  .i("a=b", c(a="b"))
  .i("b=ba", c(b="ba"))
  .i("a=b c=d", c(a="b", c="d"))
  .i("a=b c=d;comment\ne=f drop matt", c(a="b", c="d", e="f", DROP="DROP", matt="matt"))
  
})
