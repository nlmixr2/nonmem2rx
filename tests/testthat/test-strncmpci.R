test_that("strncmpi",  {
  expect_equal(.Call(`_nonmem2rx_parse_strncmpci`), 1L)
})
