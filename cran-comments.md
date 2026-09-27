# nonmem2rx 0.1.12

This release fixes the heap-use-after-free reported for 0.1.11 by the CRAN
clang-ASAN, gcc-ASAN, M1-SAN and valgrind additional checks, where
`nonmem2rx_printErrorInfo` (`src/parseSyntaxErrors.h`) read memory freed by
`nonmem2rx_full_parseFree` (`src/mem.c`).

- The record name used in syntax-error messages was kept in a string pool
  that is freed after every translation; it now has its own buffer.
- An `$OMEGA` label could survive a translation that stopped with an error
  and point into the same freed pool; it is now cleared before each
  `$OMEGA` record.

Running the full test suite under valgrind (`R -d valgrind`) gives 10 invalid
reads with 0.1.11 (the same stack as the CRAN report) and 0 with this
version.

## Test environments

- local Ubuntu, R release (also the full test suite under valgrind)
- GitHub Actions: ubuntu-latest (release, devel), macos-latest (release),
  windows-latest (release)

## R CMD check results

0 errors | 0 warnings | 2 notes

    * checking CRAN incoming feasibility ... NOTE
    Days since last update: 4

This is an early update to fix the memory-access error reported by the CRAN
additional checks for 0.1.11.

    * checking compilation flags used ... NOTE
    Compilation used the following non-portable flag(s):
      '-mno-omit-leaf-frame-pointer'

This comes from the Debian/Ubuntu build of R on the local machine
(`/usr/lib/R/etc/Makeconf`), not from the package; the package sets no
compilation flags of its own.

## revdepcheck results

We checked 4 reverse dependencies (amp.sim, babelmixr2, nlmixr2, ruminate)
for 0.1.11, comparing R CMD check results across CRAN and dev versions of
this package.

 * We saw 0 new problems
 * We failed to check 0 packages

The changes in 0.1.12 are limited to memory handling in the parser and the
wording of syntax-error messages for `.lst` files.
