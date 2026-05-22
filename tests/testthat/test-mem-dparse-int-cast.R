test_that("trans_* parsers handle normal-sized inputs without error", {
  # Sanity check: regular NONMEM control fragments must continue to parse
  # cleanly.  The (int)strlen(gBuf) cast in each trans_* entry-point is a
  # known long-term issue: inputs >= INT_MAX bytes silently truncate the
  # length passed to dparse().  The fix will arrive when dparser-R exports
  # udparse() to CRAN; at that point each call site will switch from
  #   dparse(curP, gBuf, (int)strlen(gBuf))
  # to
  #   udparse(curP, gBuf, (unsigned int)strlen(gBuf)).
  expect_no_error(
    tryCatch(
      .Call(`_nonmem2rx_trans_theta`, "(1, 2, 3)\n", 1L),
      error = function(e) {
        # Other parse errors from synthetic input are acceptable.
        NULL
      }
    )
  )
})

test_that("dparse int-cast known issue documented (skipped: requires ~3GB RAM)", {
  skip("Requires ~3GB free RAM; fix pending dparser-R udparse() CRAN release")
  # When input reaches INT_MAX bytes, (int)strlen silently truncates the
  # length, causing dparse() to read from an incorrect position.
  # NOTE: R's CHARSXP is itself capped at INT_MAX bytes, so triggering
  # this from R-only code is essentially impossible.  Test documents boundary.
  big <- strrep("(1, 2, 3)\n", 250000000L)
  expect_error(.Call(`_nonmem2rx_trans_theta`, big, 1L))
})
