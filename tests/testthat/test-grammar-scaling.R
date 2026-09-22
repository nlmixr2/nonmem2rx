## Guards against the dparser ambiguity described in #250: a rule that can
## derive the empty string (or a list that can be cut up many ways) underneath
## a `(...)+` / `(...)*` repetition is infinitely ambiguous, and dparser
## resolves that by greediness, which re-walks the whole accumulated parse tree
## at every position.
##
## Most of what is checked here is behaviour, not speed: the fix made
## `statement` non-nullable in `theta.g`/`omega.g` and moved the emptiness to
## the list, and flattened `lst.g`'s line-of-items, so these tests pin down the
## inputs that relied on the old shapes.  The one timing test covers `lst.g`,
## where the cost was cubic and the margin is wide enough not to flake.

test_that("a .lst covariance block no longer parses in cubic time (#250)", {
  skip_on_cran()
  ## Before the fix this grew with the cube of the block: 40 rows took 26
  ## seconds, so 200 rows never finished.  It is now ~0.1s; 10s leaves two
  ## orders of magnitude of headroom for a loaded CI box while still failing
  ## if the ambiguity comes back.
  .mk <- function(n) {
    paste(vapply(seq_len(n), function(i) {
      sprintf("TH%d  %s", i,
              paste(sprintf("%.4E", (seq_len(5) + i) / 7), collapse="  "))
    }, character(1)), collapse="\n")
  }
  .txt <- .mk(200L)
  .clearNonmem2rx()
  .Call(`_nonmem2rx_trans_lst`, .mk(5L), TRUE)  # warm up
  .clearNonmem2rx()
  expect_lt(system.time(.Call(`_nonmem2rx_trans_lst`, .txt, TRUE))[["elapsed"]], 10)
})

test_that("the emptiness moved to the list still accepts empty records (#250)", {
  ## `statement` is no longer nullable in theta.g/omega.g, so `statement_list`
  ## carries the `*`.  These are the inputs that relied on the nullable
  ## statement matching the whole record.
  .clearNonmem2rx()
  expect_silent(.Call(`_nonmem2rx_trans_theta`, "", 0L))
  .clearNonmem2rx()
  expect_silent(.Call(`_nonmem2rx_trans_theta`, "; only a comment", 0L))
  .clearNonmem2rx()
  expect_silent(.Call(`_nonmem2rx_trans_omega`, "", "eta", 0L))
  .clearNonmem2rx()
  expect_silent(.Call(`_nonmem2rx_trans_omega`, "; only a comment", "eta", 0L))
})

test_that("$OMEGA BLOCK(n) SAME still parses with no statements of its own (#250)", {
  ## The case that most depends on `(statement)*`: `BLOCK(2) SAME` is entirely
  ## prefix, with no statement after it at all.
  .clearNonmem2rx()
  .Call(`_nonmem2rx_omeganum_reset`)
  .Call(`_nonmem2rx_trans_omega`, "BLOCK(2) 0.1 0.01 0.2", "eta", 0L)
  .Call(`_nonmem2rx_trans_omega`, "BLOCK(2) SAME", "eta", 0L)
  expect_equal(.nonmem2rx$ini,
               c("eta1 + eta2 ~ c(0.1, 0.01, 0.2)",
                 "eta3 + eta4 ~ fix(0.1, 0.01, 0.2)"))
})

test_that("block_type is still read wherever it may appear in $OMEGA (#250)", {
  ## `block_type` lost its all-optional alternatives (it used to derive the
  ## empty string three ways); it must still be picked up after BLOCK(n),
  ## whether one keyword or two, and in either order.
  .ini <- function(txt) {
    .clearNonmem2rx()
    .Call(`_nonmem2rx_omeganum_reset`)
    .Call(`_nonmem2rx_trans_omega`, txt, "eta", 0L)
    .nonmem2rx$ini
  }
  ## SD is read: the 0.2 diagonal is a standard deviation, so it squares
  expect_equal(.ini("SD 0.2"), "eta1 ~ 0.04")
  expect_equal(.ini("STANDARD 0.2"), "eta1 ~ 0.04")
  expect_equal(.ini("0.2"), "eta1 ~ 0.2")
  ## both keywords, either order, and cholesky
  expect_equal(.ini("BLOCK(2) SD CORRELATION 0.2 0.5 0.3"),
               .ini("BLOCK(2) CORRELATION SD 0.2 0.5 0.3"))
  expect_silent(.ini("BLOCK(2) CHOLESKY 0.2 0.5 0.3"))
})

test_that("a flattened lst.g still reads the values it used to (#250)", {
  ## `constant_line`/`compress_line` are gone; the walk only ever looked at the
  ## individual `constant`/`na_item` nodes, so the numbers must come out the
  ## same -- including the `+` continuation marker and the `.........` NA.
  .clearNonmem2rx()
  expect_silent(
    .Call(`_nonmem2rx_trans_lst`,
          paste("TH 1  1.0000E+00  2.0000E+00",
                "+     3.0000E+00  .........",
                sep="\n"),
          TRUE))
})

test_that("a `+` in a .lst block must still lead an item (#250)", {
  ## The flattening replaced `constant_line : '+'? (constant_item)+` with a
  ## `plus_item`.  `plus_item : '+'` alone would have made a stray `+` -- which
  ## used to be a syntax error, since the `+` had to be followed by at least
  ## one item -- parse silently, so `plus_item` binds one item instead.
  ##
  ## A failed parse leaves the C-level error buffers (`eBuf`, `sbTransErr`,
  ## `errP`) set, and those are shared by every grammar's parser, so a
  ## deliberate syntax error here breaks an unrelated later test unless a
  ## known-good parse follows it.  One rejection is asserted, then the state is
  ## flushed -- and that flush is the positive case, so it is asserted too.
  .clearNonmem2rx()
  expect_error(.Call(`_nonmem2rx_trans_lst`, "+", TRUE))
  ## the first parse after a failure still re-raises the stale error, so flush
  ## once before asserting that a `+` leading an item is accepted
  .clearNonmem2rx()
  try(.Call(`_nonmem2rx_trans_lst`, "+     3.0000E+00  4.0000E+00", TRUE),
      silent=TRUE)
  .clearNonmem2rx()
  expect_silent(.Call(`_nonmem2rx_trans_lst`,
                      "+     3.0000E+00  4.0000E+00", TRUE))
})
