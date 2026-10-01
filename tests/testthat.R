# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/tests.html
# * https://testthat.r-lib.org/reference/test_package.html#special-files

library(testthat)
library(nonmem2rx)
library(rxode2)
setRxThreads(1L)
library(data.table)
setDTthreads(1L)

# CRAN/R-hub work-arounds, mirroring rxode2's own tests/testthat.R: keep
# OpenMP and MKL in step with the thread counts above, and on macOS stop
# rxode2 from unloading the model dlls, which the ASAN checks trip over.
if (!identical(Sys.getenv("NOT_CRAN"), "true")) {
  Sys.setenv(OMP_NUM_THREADS = "1")
  Sys.setenv(MKL_NUM_THREADS = "1")
  if (identical(Sys.info()[["sysname"]], "Darwin")) {
    rxode2::rxUnloadAll(set = FALSE)
  }
}

test_check("nonmem2rx")
