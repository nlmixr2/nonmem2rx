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

test_that("aliasing does not slow down with the number of reused blocks", {

  # The next free alias used to be found by walking every alias already given
  # out and scanning the whole level list for each, so the cost grew with the
  # cube of the block count: 500 blocks took 0.02s and 4000 took 9.9s.  Doubling
  # the blocks must not do much more than double the work.
  .blocks <- function(nb) {
    as.integer(rep(rep(c(1L, 2L), each = 2L), length.out = nb * 2L))
  }
  .minElapsed <- function(id, reps = 3L) {
    min(vapply(seq_len(reps),
               function(i) system.time(fromNonmemToRxId(id))[["elapsed"]],
               numeric(1)))
  }

  expect_equal(nlevels(fromNonmemToRxId(.blocks(2000))), 2000L)

  .small <- .minElapsed(.blocks(1000))
  # generous: the defect was ~50x over this doubling, and the floor keeps a
  # sub-millisecond .small from making the bound meaninglessly tight
  expect_lt(.minElapsed(.blocks(2000)), max(8 * .small, 0.5))
})
