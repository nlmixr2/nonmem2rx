test_that("test nonmem->rxode2 id", {

  expect_equal(fromNonmemToRxId(as.integer(c(1,1,1, 2,2,2, 1, 1, 1))),
               structure(c(1L, 1L, 1L, 2L, 2L, 2L, 3L, 3L, 3L), levels = c("NM:'1'", "NM:'2'", "NM:'1'#2"), class = "factor"))

  expect_equal(fromNonmemToRxId(as.integer(c(1,1,1, 2,2,2, 3))),
               structure(c(1L, 1L, 1L, 2L, 2L, 2L, 3L), levels = c("NM:'1'", "NM:'2'", "NM:'3'"), class = "factor"))

  expect_equal(fromNonmemToRxId(as.integer(c(1,1,1, 10,10,10, 40))),
               structure(c(1L, 1L, 1L, 2L, 2L, 2L, 3L), levels = c("NM:'1'", "NM:'10'", "NM:'40'"), class = "factor"))

  expect_equal(fromNonmemToRxId(as.integer(c(1,1,1, 40,40,40, 10))),
               structure(c(1L, 1L, 1L, 2L, 2L, 2L, 3L), levels = c("NM:'1'", "NM:'40'", "NM:'10'"), class = "factor"))

  expect_equal(fromNonmemToRxId(as.integer(c(NA, 0, 0, 0, 0, 0)),
                                c(NA, 1, 2, 0, 0, 2))

})
