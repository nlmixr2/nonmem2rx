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

test_that("a NONMEM id reused more than twice keeps getting new aliases", {

  # The alias counter used to be rebuilt from a value that never advanced, so
  # the THIRD block of an id looked for "#2", found it, and looked for "#2"
  # again -- forever.  Two blocks (covered above) were fine, which is why this
  # went unnoticed.  A regression here hangs rather than fails.
  expect_equal(
    fromNonmemToRxId(as.integer(c(1, 1, 2, 2, 1, 1, 2, 2, 1, 1))),
    factor(c(1L, 1L, 2L, 2L, 3L, 3L, 4L, 4L, 5L, 5L),
           labels = c("NM:'1'", "NM:'2'", "NM:'1'#2", "NM:'2'#2", "NM:'1'#3"))
  )

  # and it keeps counting past #3
  expect_equal(
    levels(fromNonmemToRxId(as.integer(rep(c(1, 2), times = 5)))),
    c("NM:'1'", "NM:'2'", "NM:'1'#2", "NM:'2'#2", "NM:'1'#3",
      "NM:'2'#3", "NM:'1'#4", "NM:'2'#4", "NM:'1'#5", "NM:'2'#5")
  )

  # the same id restarting in time, rather than alternating with another
  expect_equal(
    levels(fromNonmemToRxId(as.integer(rep(1, 6)), c(0, 1, 0, 1, 0, 1))),
    c("NM:'1'", "NM:'1'#2", "NM:'1'#3")
  )
})
