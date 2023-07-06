# nonmem2rx (development version)

* Added explicit requirement for rxode2 2.0.12

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
