# nonmem2rx 0.1.12

This release fixes the heap-use-after-free reported by the CRAN
clang-ASAN, gcc-ASAN, M1-SAN and valgrind additional checks for 0.1.11
(`nonmem2rx_printErrorInfo` in `src/parseSyntaxErrors.h` reading memory freed
by `parseFree`).  The record name used in syntax-error messages was kept in a
string pool that is freed after every parse; it now has its own buffer.

## Test environments

- local Ubuntu, R release
- GitHub Actions: ubuntu-latest (release, devel), macos-latest (release),
  windows-latest (release)

## R CMD check results

0 errors | 0 warnings | 1 note

The note is

    * checking compilation flags used ... NOTE
    Compilation used the following non-portable flag(s):
      '-mno-omit-leaf-frame-pointer'

which comes from the Debian/Ubuntu build of R on the local machine
(`/usr/lib/R/etc/Makeconf`), not from the package; the package sets no
compilation flags of its own.

## revdepcheck results

We checked 4 reverse dependencies (amp.sim, babelmixr2, nlmixr2, ruminate),
comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
