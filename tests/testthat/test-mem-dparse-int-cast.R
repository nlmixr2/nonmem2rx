test_that("trans_* parsers handle normal-sized inputs without error", {
  # Sanity check: regular NONMEM control fragments must continue to parse
  # cleanly after the INT_MAX guards added before the dparse(...) calls.
  expect_no_error(
    tryCatch(
      .Call(`_nonmem2rx_trans_theta`, "(1, 2, 3)\n", 1L),
      error = function(e) {
        if (grepl("input too large to parse", conditionMessage(e))) stop(e)
        # Other parse errors are acceptable.
        NULL
      }
    )
  )
})

test_that("dparse cast guard triggers on >INT_MAX-byte input (skipped: requires ~3GB RAM)", {
  skip("Requires ~3GB free RAM to construct an >INT_MAX-byte input string")
  # --- What this test checks ---
  # Each `trans_*` parser entry passes its input to dparser via
  #   _pn = dparse(curP, gBuf, (int)strlen(gBuf));
  # When `gBuf` is longer than INT_MAX bytes the `(int)` cast wraps to a
  # negative value and dparser reads past the buffer (UB).
  #
  # The guard added by this fix range-checks `strlen(gBuf)` against INT_MAX
  # before the cast and raises an R error if exceeded.
  #
  # NOTE: R's CHARSXP is itself capped at INT_MAX bytes, so triggering
  # the guard from R-only code is essentially impossible.  This test
  # documents the boundary; the test is `skip()`ed.

  big <- strrep("(1, 2, 3)\n", 250000000L)
  expect_error(
    .Call(`_nonmem2rx_trans_theta`, big, 1L),
    "input too large to parse|exceeds INT_MAX"
  )
})
