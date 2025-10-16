# nonmem2rx (development version)

* Try to make sure all the values that can be numeric are numeric #208

# nonmem2rx 0.1.8

* Better handling of `ytype`

* Added work-around for new Rstudio completion

# nonmem2rx 0.1.7

* Added `$ERROR (ONLY OBS)` support
* `if` statements can be upper or lower case #196

# nonmem2rx 0.1.6

* Add more flexible replacement of ETA and other values #188

* Add ability to use `nonmem2rx` with a NONMEM control stream text input

# nonmem2rx 0.1.5

* Be more forgiving in the validation and remove IDs without
  observations when solving the `IPRED` problem.

* Binary linkage to dparser changed to structure only, meaning
  `nonmem2rx` may not have to be updated if `dparser` is updated.

# nonmem2rx 0.1.4

* When reading NONMEM results from xml will try `nm:` prefixed tags
  and non-`nm:` prefixed tags.

* Omega and Sigma prior estimates are currently ignored (theta priors
  were already ignored)

* Improve reading in `theta` values from the `xml`

* Read all NONMEM files using latin1 encoding to allow single byte
  parser to work

* When lines in the NONMEM input dataset start with `#` they are now
  ignored.

* When all IDs are zero, NONMEM assumes restarting
  time gives different IDs; this is now reflected in NONMEM
  translation of IDs.

* With `linCmt()` parsing, expand the scope of conflicting parameters
  that will be renamed with an import.

* Added better parsing for `ELSE` where there is another `IF` on the
  next line.

* Prefixed conflicting `VP` with `rxm.` when `linCmt()` models to be
  more accommodating when importing linear compartment models.

# nonmem2rx 0.1.3

* Added explicit requirement for rxode2 2.0.13

* Added support of `DADT(#)` statements on the right side of the
  equation, i.e. `DADT(3) = DADT(1) + DADT(2)` (#164)

* Added support of `ADVAN#, TRANS#` (#161)

* Added more NONMEM-specific solving options

* Fixed security related format issues as requested by CRAN #167

* Now `omega`, `thetaMat`, `dfObs` and `dfSub` are incorporated into
  model function (by default).  You can change this with the
  `nonmem2rx` `keep` argument

* Using the `rxode2` 2.0.13 makes sure that the solves for models
  where the endpoint is not determined in the typical `nlmixr2` style
  will validate more often (due to a bug in solving in `rxode2`).

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
