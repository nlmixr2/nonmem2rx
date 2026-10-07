# nonmem2rx 0.1.12

* `MPAST(i)` now translates to `time > MTIME(i)` instead of `time >=
  MTIME(i)`.  NONMEM evaluates the interval that ends at `MTIME(i)` with
  `MPAST(i) = 0`; it becomes 1 only for later intervals.  With rxode2's
  continuous time both forms give the same solution, but with
  `rxSolve(nonmem = TRUE)` the old form moved the change point one interval
  early (#267).

* When rxode2 supports `rxSolve(nonmem = TRUE)` (nlmixr2/rxode2#1429),
  `rxSolve()` on a `nonmem2rx` model and the validation of an import solve
  with `nonmem = TRUE` and `addlKeepsCov = FALSE`.  Statements that do not
  depend on a state (`$PK`) then read `time` as the time of the data record
  that ends the interval, the way NONMEM calls `$PK` at its records.  With
  `covsInterpolation = "nocb"` this matches NONMEM for `TIME` in `$PK`,
  `MTIME` change points and covariates changing between `ADDL` doses.  With
  older rxode2 versions the solve keeps `addlKeepsCov = TRUE` as before.
  Models with `delay()` (the `ADVAN16`/`ADVAN18` translations) keep the
  continuous time, since rxode2 evaluates a `delay()` assigned outside of
  `d/dt()` at the record time with `nonmem = TRUE`.  The stress kit uses the
  same options, so its `time-in-pk` case is no longer a known issue with a
  newer rxode2.  Its `mtime-change-point` case is no longer a known issue:
  the ~1% difference between `linCmt()` and the ODE came from the kit's own
  simulation switching at `t >= MTIME` (#267).

* Added a NONMEM stress kit in `inst/stress` (like babelmixr2's).  It
  simulates edge-case datasets with rxode2, runs NONMEM, imports the runs
  with `nonmem2rx()` and checks the import; without NONMEM it checks the
  translations only.  Load it with
  `source(system.file("stress", "stress.R", package = "nonmem2rx"))` and
  run `stressCheck()` and `stressKit()`; see `inst/stress/README.md`.

* Runs with several `$EST` records (for example ITS followed by FOCE) now
  import the final estimates.  NONMEM writes one table per estimation step
  to the `.ext`, `.phi`, `.cov`, `.cor`, `.coi` and `.grd` files and one
  block per step to the `.xml` and `.lst` files, and `nmext()`, `nmcov()`,
  `nmgrd()`, `nmxml()`, `nmlst()` and `nminfo()` read the first step.  The
  model was then validated with the first step's estimates against tables
  from the last step.  They now use the last estimation step of the first
  problem.

* First-order (`METHOD=0`) runs now validate with the POSTHOC etas from the
  output tables.  NONMEM leaves every `.phi` eta at zero for FO, and the
  `.phi` etas were preferred.

* `nmxml()` now reads `$SIGMA` (its XPath was malformed, so it was never
  found), and returns `NULL` instead of an empty vector when `$OMEGA` is
  missing.

* `ADVAN12 TRANS4` (`CL V2 Q3 V3 Q4 V4 KA`) models now translate to a working
  `linCmt()` model.  The parameter map was registered under `TRANS2`, so the
  model kept an unresolved `linCmtFun` parameter and could not be solved.  A
  closed-form `ADVAN`/`TRANS` combination without a `linCmt()` translation is
  now an error instead.

* `ADVAN4 TRANS6` (`ALPHA BETA K32 KA`) models now translate to `linCmt()`.

* A `$MODEL` that mixes named and bare `COMP` records (for example
  `COMP=(CENTRAL,DEFDOSE,DEFOBS) COMP`) now renames the named compartments.
  Previously the rename failed silently, and `ADVAN5`/`ADVAN7` models then
  stopped with an rxode2 syntax error because the matrix-exponential code
  used the names the rename should have applied.

* Abbreviated code now accepts the Fortran `.NOT.` operator and the `/=`
  and `.NEN.` not-equal operators (previously a syntax error).

* Model validation now matches the rxode2 solve to the NONMEM records by row,
  so it is no longer skipped when the lengths differ: models with `MTIME`
  (rxode2 adds output at the model event times) and data with
  compartment-off (`CMT<0`) records now validate.

* PRED validation now treats a reused, non-contiguous NONMEM `ID` as a new
  individual (as IPRED validation already did).  IPRED validation also keeps
  ETAs aligned for reused IDs instead of skipping the check.

* Validation no longer stops with "object '.iwres' not found" when the IPRED
  solve fails.

* `$OMEGA`/`$SIGMA` `BLOCK(n)` records using the `SD`, `CORRELATION` or
  `CHOLESKY` options now import the whole block.  Previously only the first
  row was kept (for example `BLOCK(2) SD CORRELATION 0.3 0.5 0.2` became
  `eta1 ~ 0.09` and `eta2` was lost).  `CHOLESKY` values are now read as the
  lower-triangular factor, and `FIX` is kept through the conversion.
* Models that refer to `DV` (for example `IRES = DV - IPRED` in `$ERROR`)
  no longer simulate wrong amounts when doses have modeled lag times and
  durations in more than one compartment (#263).  The `DV` reference makes
  `DV` a time-varying covariate, which exposed a bug in `rxode2`; this
  needs `rxode2` 5.1.8 or later.

* `$TABLE` records now accept the `VARCALC=` and `FIXEDETAS=` options
  instead of stopping with a syntax error (#262).  They only change how
  NONMEM computes extra table metrics, so they are parsed and ignored.
  Unrecognised `KEY=VALUE` `$TABLE` options now also accept numeric and
  quoted values, and their value (for example `FOO=ETA1`) is no longer
  mistaken for a table column.

* A `$TABLE` `PARAFILE=` value no longer replaces the table's `FILE=` name.

* Fixed a heap-use-after-free reported by CRAN's ASAN/valgrind checks.  The
  record name used in syntax-error messages was stored in the parser's
  duplicated-string pool, which is freed after every parse, so a later syntax
  error (for example in a `.lst` file) printed freed memory.  The record name
  now has its own buffer.

* An `$OMEGA` label left over from a translation that stopped with an error
  (for example a `NAMES()` count mismatch) is now cleared before the next
  `$OMEGA` record, instead of being read from freed memory.

* Syntax errors in a `.lst` file are now labelled as coming from the NONMEM
  output rather than from the last control-stream record parsed (or from a
  `NULL` record name).

* The `PRED` validation no longer needs the `tibble` package.  It asked
  `rxSolve()` for a tibble while the `IPRED` validation beside it asked for a
  `data.frame`, so where `tibble` was unavailable the solve failed quietly and
  only the `IPRED` half of `$meta$validation` was reported.  The tibble also
  failed, whatever was installed, for models that output a variable twice
  (such as `ADVAN5`/`ADVAN7` `matExp()` models).

# nonmem2rx 0.1.11

* A `THETA(#)` or `ETA(#)` used in the model beyond what `$THETA` or
  `$OMEGA` defines is now an error.  Previously it was silently translated
  into a data covariate (like `eta11`), giving a model that could not be
  used with the intended data.

* An empty `;` comment line no longer swallows the line after it.  In
  `$THETA`/`$OMEGA` this silently dropped an estimate and renumbered every
  one after it (and likewise in the other record parsers).

* Reading a NONMEM `.lst` covariance block is no longer slow.  `lst.g` let a
  run of numbers be cut into `constant_line`s in exponentially many ways, and
  dparser resolves that ambiguity by greediness, which re-walks the whole
  accumulated parse tree at every split point -- so the cost grew with the cube
  of the block size (40 rows took 26 seconds).  A statement is now a single
  item rather than a line of them, which the tree walk never distinguished
  anyway: `inst/run-153.lst` imports in 0.17s instead of 2.24s,
  `DDMODEL00000301/run3.lst` in 0.15s instead of 1.57s, and 400 rows -- which
  did not finish in any usable time before -- parse in 0.3s.  A `+` still has
  to lead an item, so a stray one is still a syntax error (#250).

* `$THETA` and `$OMEGA`/`$SIGMA` records parse about 2.5x faster.  Both
  grammars had the ambiguity found in `rxode2`'s `tran.g`: a nullable
  `statement` under `(statement)+`, which lets an empty statement be inserted
  at every position, and which dparser resolves by greediness.  `omega.g` also
  derived the empty string three different ways through `block_type`.  The
  emptiness moved to the list, so an empty record and `$OMEGA BLOCK(n) SAME`
  (which carries no statements) still parse.  A 400-theta `$THETA` record goes
  from 7.3s to 2.8s (#250).

  Both grammars now report no ambiguity at all under dparser's
  `ambiguity_fn`.  What is left of their super-linear cost is not ambiguity but
  GLR branching from the optional `')'` and `','` in `theta.g`'s `theta1`..
  `theta8` and in `omega.g`'s `omega0`..`omega4`, which is a separate matter.

  The remaining `inst/*.g` grammars (`abbrev.g`, `abbrec.g`, `data.g`,
  `input.g`, `model.g`, `sub.g`, `tab.g`) were measured and are flat in the
  record size.

* Validation plots now separate multiple endpoints (#171).  When the
  observations come from more than one `DVID` (or, without a `DVID`, more
  than one `CMT`), the `predCompare`, `ipredCompare` and `iwresCompare`
  datasets gain a final `ENDPOINT` column (like `"DVID=2"`).  `plot()` and
  `autoplot()` then facet the NONMEM vs rxode2 overview by type and
  endpoint, and the per-subject pages draw one panel for each subject and
  endpoint with its own y scale, so endpoints on different scales are no
  longer drawn on the same axis.  Single-endpoint output is unchanged.

* `$DATA` now accepts every option in the NONMEM `$DATA` usage, and the ones
  that change the data are applied when the input data is imported (#181):
  - `TRANSLATE=(TIME/F[/D], II/F[/D])` divides TIME/II by `F` and rounds to
    `D` digits (for example `TIME/24` for hours to days, `II/0.01/6`).  The
    item may be named by its `$INPUT` synonym.
  - Before `TRANSLATE`, NM-TRAN's day-time translation is done: `hh:mm` or
    `hh:mm:ss` clock times and `DATE`/`DAT1`/`DAT2`/`DAT3` dates (with
    `LAST20=` for two digit years) become times relative to each
    individual's first record, and `hh:mm` II values become hours.
  - `RECORDS=n` (also `NRECORDS`, `RECS`, `NRECS`) is now applied before
    `IGNORE`/`ACCEPT`, as NM-TRAN does, and `RECORDS=label` (`ID`, `IR`,
    `INDREC`, ...) is supported.
  - `NULL=c` replaces null data items and `MISDAT=r` values are read as 0.
  - `DROP`/`SKIP` items are kept until after `IGNORE`/`ACCEPT`, so they can
    be used in filter conditions.
  - The format specification, `*`, `CHECKDATA`, `NOOPEN`, `BLANKOK`, `REPL`,
    `(NO)FDATACSV`, `PRED_IGNORE_DATA`, the `/=` operator, unquoted
    character values (`GEN.EQ.M` compares with the string `M`, not a
    column) and lower/mixed case options are now parsed.
  - An `IGNORE`/`ACCEPT` condition on a missing value is not met, so `ACCEPT`
    drops such records; an `IGNORE`/`ACCEPT` list that cannot be parsed is
    now a syntax error instead of being silently skipped.

* Importing a dataset with many reused NONMEM `ID`s is no longer slow.  The
  next free alias was found by walking every alias already given out and
  scanning the whole level list for each, so the cost grew with the cube of
  the number of reused blocks: 4000 blocks took about 10 seconds.  Only the
  next free suffix per id is remembered now, and the same 4000 blocks are
  below timer resolution.

* Importing a dataset where a NONMEM `ID` starts over more than twice no
  longer hangs.  A repeated `ID` is aliased `<id>#2`, `<id>#3`, and so on, but
  the alias counter never advanced, so the third block of an id searched for
  `#2`, found it, and searched for `#2` again without end.  Two blocks were
  fine, which is why this went unnoticed; three or more -- an id reused after
  a time reset, as in crossover and multiple-occasion data -- never returned.


* `nonmem2rx` now requires `rxode2` 5.1.5 or later.  That release fixes an
  `rxode2` model-piping bug where a model piped from an import (which keeps a
  persistent `meta` environment) shared the original's cached simulation
  model, so states appended by piping (like a running `AUC`) were silently
  dropped from the solve (#246).

* NONMEM delay differential equation (DDE) models are now translated to
  rxode2's native `delay()`/`past()` syntax.  The DDE solvers `ADVAN16`
  (RADAR5) and `ADVAN18` (DDE_SOLVER) are accepted (in addition to the
  `ADVAN13` DDE extension), a delayed state `AD_x_y` (state `A(x)` delayed by
  `TAUy`) becomes `delay(rxddta<x>, TAU<y>)`, and a past history
  `AP_x_y = expr` becomes `past(rxddta<x>, TAU<y>) <- expr` (NONMEM `T` maps to
  rxode2 `t`).  A constant past that equals the compartment's initial condition
  is dropped, since rxode2 uses the initial condition as the default delay
  history.  The translated models solve in rxode2 (dense auto-switch) and can
  be estimated in nlmixr2.  `ADVAN17` (delay differential *algebraic*
  equations) is not supported.

* Regenerate the `rxSolve.nonmem2rx()` method so it no longer passes the
  `order` solver argument, which was removed from `rxode2::rxSolve()`.
  Passing it caused solving a translated model to fail with
  `unused argument: 'order'` against the current CRAN `rxode2`.

* `nonmem2rx()`'s `inputData` argument now also accepts a `data.frame`
  of the already read-in NONMEM input dataset (in addition to a file
  path).  This is useful when importing a model from a different
  system where you have the data to validate against but the file
  paths in the control stream do not match (#186).  The columns are
  assumed to be in `$INPUT` order and the usual `$INPUT` names,
  `DROP`, `IGNORE`/`ACCEPT` filters and record subsetting are applied.
* `ADVAN5`/`ADVAN7` general linear models (which NONMEM itself solves with
  matrix exponentials) are now translated to rxode2's native
  matrix-exponential `matExp()` model (`cmt()` declarations plus
  `k_<from>_<to>` rate constants) by default, instead of explicit `d/dt()`
  ODEs.  The previous ODE translation is retained and can be selected with
  the new `matexp=FALSE` argument (or `options(nonmem2rx.matexp=FALSE)`).
  Other model types are unaffected, and if the installed rxode2 does not
  support `matExp()` the ODE translation is used with a warning.

* NONMEM mixture models (`$MIX`) now translate to the native rxode2/nlmixr2
  mixture support (`mix()`), replacing the previous `rxord()` simulation of
  the sub-population.  When the mixture probabilities are simple parameters
  (e.g. `P(1)=THETA(5)`), the imperative `MIXNUM`/`MIXEST` branching in
  `$PK`/`$PRED` is collapsed into readable `mix()` calls (e.g.
  `V <- mix(VCM, p1, VCF)`), the probabilities are registered on the model
  (`ui$mixProbs`) so the model estimates natively under `focei` and `saem`,
  and `MIXEST`/`MIXNUM` map to the reserved `mixest` component.  Models whose
  probabilities are not simple parameters fall back to the previous `rxord()`
  translation.  Simulation-based validation remains gated for mixtures because
  NONMEM's per-subject sub-population assignment is not recoverable for a
  faithful prediction comparison.

* Support the NONMEM `$DATA` numeric-comparison operators `.EQN.` and
  `.NEN.` in `IGNORE=`/`ACCEPT=` filters (#195).  These request that the
  data item be converted to numeric before being compared, so they now
  translate to `as.numeric(.data$COL) == value` / `!= value`.  `.NEN.`
  was previously unparseable (silently dropping the filter), and `.EQN.`
  was treated as a plain `==` without the numeric coercion.
* Support assignment to the NONMEM `COM(#)` communication array (declared
  with `$ABBREVIATED COMRES=#`).  Previously only reading `COM(#)` was
  translated, so control streams that assigned `COM(#)` (e.g.
  `IF(NEWIND.LE.1) COM(1)=-1`) failed to parse (#228).  A `COM(#)`
  assignment now translates to the rxode2 sticky variable `rxCOM_#_`,
  which retains its value from record to record like the NONMEM COM
  array (see the rxode2 sticky variable vignette).

* Add optional LLM-assisted residual error detection to `as.nonmem2rx()`
  (via the `ellmer` package) for models imported without a residual
  error specification (`$predDf`).  When no `chat` engine is supplied,
  the default engine is now chosen dynamically: `getOption(
  "nonmem2rx.llmProvider")` is honored first (accepting any exported
  `ellmer::chat_*` engine by name), otherwise the first provider with a
  configured API key is auto-detected (e.g. `ANTHROPIC_API_KEY`,
  `OPENAI_API_KEY`, `GEMINI_API_KEY`), instead of always requiring
  Claude.  Any `ellmer` chat object may also be passed directly through
  the new `chat` argument.

* Add integer overflow guards in the C-level string buffer
  (`src/sbuf.c`).  `sAppendN`, `sAppend`, and `addLine` previously
  computed the new allocation size as `sbb->o + 2 + n + SBUF_MXBUF`
  (or analogous expression).  When the user-controlled `n` was large
  enough this expression overflowed `int` to a negative value, which
  `R_Realloc` then converted to a huge unsigned size and crashed.  The
  guard converts this into a clean R error.

* Document known `(int)strlen(gBuf)` cast in all 10 NONMEM-record parser
  entry-points (`src/abbrec.c`, `src/abbrev.c`, `src/data.c`,
  `src/input.c`, `src/lst.c`, `src/model.c`, `src/omega.c`, `src/sub.c`,
  `src/tab.c`, `src/theta.c`).  Inputs at or above `INT_MAX` bytes cause
  silent length truncation passed to `dparse()`.  A long-term fix will
  switch each call site to `udparse()` once dparser-R ships that symbol
  to CRAN.

* Fix implicit `ptrdiff_t` to `int` truncation in `rc_dup_str`
  (`src/records.c`).  When the parser passes a string segment longer
  than `INT_MAX` bytes (or a NUL-terminated string of that length),
  the pointer difference / `strlen` result was silently cast to `int`,
  truncating the length to a wrong (often negative) value.  The new
  guard rejects such inputs with an informative R error.



# nonmem2rx 0.1.10

* Bug fix for covariance matrices that span multiple FORTRAN output pages

* Bug fix for multiple errors are imported using `nonmem2rx()`

* Change NONMEM import for mixture models to prepend NM to MIXNUM and
  related import items so they will not interact with rxode2/nlmixr2's
  handling of mixture models.

# nonmem2rx 0.1.9

* Try to make sure all the values that can be numeric are numeric #208

* Use qs2 since qs is being archived

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
