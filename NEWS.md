# nonmem2rx 0.1.3

* Added explicit requirement for rxode2 2.0.12

* Added support of `DADT(#)` statements on the right side of the
  equation, i.e. `DADT(3) = DADT(1) + DADT(2)` (#164)

* Added support of `ADVAN#, TRANS#` (#161)

* Added more NONMEM-specific solving options

* Fixed security related format issues as requested by CRAN #167

# nonmem2rx 0.1.2

* Added support for `ADVAN5` and `ADVAN7` models

* Add parsing of accept/ignore characters for example `IGNORE=(C='C')`
  (See Issue #140)

* Add more robust reading of NONMEM information (and add source) in
  `nminfo()` (See issue #142)

* Since NONMEM does not protect divide by zeros by default, the
  default for `solveZero` is changed to `solveZero = TRUE` for
  `nonmem2rx` objects.

* Fixed bug for renaming `eta` and `theta` when they are renamed so
  that the `ui$iniDf` does not match the `theta#` or `eta#` (Issue
  #153)

* Turned off testing of the `as.nonmem2rx` example since it took too
  much time (according to CRAN)

# nonmem2rx 0.1.1

- Fix internal memory issue (`LTO`, `valgrind` etc)

# nonmem2rx 0.1.0

* Added a `NEWS.md` file to track changes to the package.
