test_that("sbuf overflow guard triggers a graceful error (skipped: requires ~2.5GB RAM)", {
  skip("Requires ~2.5GB RAM to construct a 2.147 GB identifier string that triggers integer overflow in buffer size calculation")
  # --- What this test checks ---
  # `sAppendN` in src/sbuf.c computed the new allocation size as:
  #   int mx = sbb->o + 2 + n + SBUF_MXBUF;
  # When n > (INT_MAX - sbb->o - 2 - SBUF_MXBUF), this expression overflows
  # to a negative int.  R_Realloc then receives a negative size and crashes
  # (SIGSEGV), rather than throwing an R error.
  #
  # The overflow guard added by this fix checks BEFORE the calculation:
  #   if (n > INT_MAX - sbb->o - 2 - SBUF_MXBUF) Rf_error(...)
  # so the crash is replaced by a controlled R error.
  #
  # --- Why the abbrev parser, not theta ---
  # The theta parser calls sClear(&curTheta) after every value, so many small
  # values never accumulate to 2 GB.  The abbrev parser appends an entire
  # identifier in a single sAppendN call, so a single >2.147 GB identifier
  # directly triggers the check.
  #
  # --- Memory budget ---
  # strrep("x", 2147435646L) allocates one CHARSXP of 2.147 GB (no per-element
  # overhead).  Peak usage during the test is ~2.5 GB, well under 6 GB.
  # CAUTION: do NOT use paste(rep("x", N), collapse="") — that builds a
  # billion-element character vector first (~8.5 GB of pointer overhead alone).
  #
  # --- How to run manually (outside devtools::test()) ---
  # Start a fresh R session with at least 3 GB of available RAM, then:
  #
  #   library(nonmem2rx)
  #   # Minimum length to trigger the check (INT_MAX - 2 - SBUF_MXBUF + 1):
  #   big <- strrep("x", 2147435646L)   # ~2.147 GB; takes a few seconds to alloc
  #   # Before fix:  crash (SIGSEGV from R_Realloc with negative size)
  #   # After fix:   error "string buffer size overflow: input too large"
  #   .Call(nonmem2rx:::`_nonmem2rx_trans_abbrev`, big, "nlmixr2", 0L, 0L)

  big <- strrep("x", 2147435646L)  # exactly one char beyond the overflow threshold
  expect_error(
    .Call(`_nonmem2rx_trans_abbrev`, big, "nlmixr2", 0L, 0L),
    "string buffer size overflow"
  )
})

test_that("sbuf handles moderately large inputs without error", {
  # Sanity check: the overflow guard must not trigger on realistic inputs.
  # 10,000 theta values is far beyond any real NONMEM control stream.
  large_theta <- paste(rep("1\n", 1e4L), collapse = "")
  # We only verify that no buffer-overflow error is thrown.
  expect_no_error(
    tryCatch(
      .Call(`_nonmem2rx_trans_theta`, large_theta, 1L),
      error = function(e) {
        if (grepl("buffer size overflow", conditionMessage(e))) stop(e)
        # Any other parse error is acceptable for this malformed input.
        NULL
      }
    )
  )
})
