# nonmem2rx updates

This release collects the changes since 0.1.9 (0.1.10 was never submitted to
CRAN), the most user-visible of which are:

- Much faster parsing of NONMEM control streams and `.lst` files.  Ambiguity
  in the `lst.g`, `theta.g` and `omega.g` grammars made large covariance
  blocks and large `$THETA`/`$OMEGA` records super-linear in the record size.

- Importing a dataset with many reused NONMEM `ID`s is no longer slow, and a
  dataset where an `ID` starts over more than twice no longer hangs.

- NONMEM delay differential equation models (`ADVAN16`/`ADVAN18`) and mixture
  models (`$MIX`) are now translated.

- `$DATA` accepts every option in the NONMEM `$DATA` usage, and validation
  plots separate multiple endpoints.

See `NEWS.md` for the full list.

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
