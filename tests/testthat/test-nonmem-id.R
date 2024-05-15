test_that("test nonmem->rxode2 id", {

  expect_equal(fromNonmemToRxId(as.integer(c(1,1,1, 2,2,2, 1, 1, 1))),
               factor(c(1L, 1L, 1L, 2L, 2L, 2L, 3L, 3L, 3L), labels = c("NM:'1'", "NM:'2'", "NM:'1'#2")))

  expect_equal(fromNonmemToRxId(as.integer(c(1,1,1, 2,2,2, 3))),
               factor(c(1L, 1L, 1L, 2L, 2L, 2L, 3L), labels = c("NM:'1'", "NM:'2'", "NM:'3'")))

  expect_equal(fromNonmemToRxId(as.integer(c(1,1,1, 10,10,10, 40))),
               factor(c(1L, 1L, 1L, 2L, 2L, 2L, 3L), labels = c("NM:'1'", "NM:'10'", "NM:'40'")))

  expect_equal(fromNonmemToRxId(as.integer(c(1,1,1, 40,40,40, 10))),
               factor(c(1L, 1L, 1L, 2L, 2L, 2L, 3L), labels = c("NM:'1'", "NM:'40'", "NM:'10'")))

  expect_equal(fromNonmemToRxId(as.integer(c(NA, 0, 0, 0, 0, 0)),
                                c(NA, 1, 2, 0, 0, 2)),
               factor(c(1L, 1L, 1L, 2L, 2L, 2L), labels = c("NM:'0'", "NM:'0'#2")))

})
