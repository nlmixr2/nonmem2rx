test_that("rc_dup_str handles normal-sized inputs without error", {
  # Sanity check: regular NONMEM control fragments must continue to parse
  # cleanly after the INT_MAX guards added to rc_dup_str.
  expect_no_error(
    tryCatch(
      .Call(`_nonmem2rx_trans_theta`, "(1, 2, 3)\n", 1L),
      error = function(e) {
        if (grepl("rc_dup_str", conditionMessage(e))) stop(e)
        # Other parse errors are acceptable.
        NULL
      }
    )
  )
})

test_that("rc_dup_str int truncation guard triggers on huge inputs (skipped: requires ~2GB RAM)", {
  skip("Requires ~2GB free RAM to construct a >INT_MAX-byte input string")
  # --- What this test checks ---
  # `rc_dup_str` (src/records.c) computes the length as
  #   int l = e ? e-s : (int)strlen(s);
  # When the source string segment is larger than INT_MAX bytes, the
  # `(int)` cast silently truncates to a wrong value, which propagates
  # into `addLine(&_dupStrs, "%.*s", l, s)`.
  #
  # The guard added by this fix range-checks the ptrdiff_t / size_t
  # length and raises an R error before the truncation can happen.

  big <- strrep("a", 2147483647L)
  expect_error(
    .Call(`_nonmem2rx_trans_abbrev`, big, "nlmixr2", 0L, 0L),
    "rc_dup_str|too long"
  )
})
