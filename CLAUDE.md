# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## What this package does

`nonmem2rx` converts NONMEM control streams and output into `rxode2`
models (and, for simple models, `nlmixr2` syntax). It reads the NONMEM
data and result files (`.lst`, `.ext`, `.phi`, `.cov`, `.xml`, `.grd`)
so the resulting `rxode2` model can re-simulate PRED/IPRED/IWRES and be
compared against NONMEM’s own output to validate the translation. It
also captures uncertainty information (nsub, nobs, covariance matrix)
for simulation. It is the inverse of `babelmixr2` (which goes nlmixr2
-\> NONMEM), and its objects can be promoted to full `nlmixr2` fits.

## Build, test, document

This is an R package with compiled C/C++ (Rcpp + dparser). Common
workflows use `devtools`:

``` r

devtools::load_all()      # compile src/ and load package for interactive work
devtools::document()      # regenerate NAMESPACE and man/ from roxygen
devtools::test()          # run the full test suite
devtools::check()         # R CMD check
```

Run a single test file (fast iteration):

``` r

devtools::load_all(); testthat::test_file("tests/testthat/test-omega.R")
```

Or from the shell: `R CMD INSTALL .` then
`Rscript -e 'testthat::test_dir("tests/testthat")'`.

Tests set `setRxThreads(1L)` / `setDTthreads(1L)` (see
`tests/testthat.R`). Several heavy integration tests are excluded from
the build via `.Rbuildignore` (e.g. `test-bauer-2019.R`, `test-psn.R`,
`test-ddmore.R`) and depend on large model dirs / zips under `inst/`
that are also build-ignored. Many tests wrap calls in
`withr::with_options(list(nonmem2rx.save=FALSE, nonmem2rx.load=FALSE, nonmem2rx.overwrite=FALSE), {...})`
to avoid touching the on-disk cache.

## Architecture

### Grammar-driven parsing (the core mechanism)

NONMEM control streams are parsed with **dparser** grammars, one per
NONMEM record type. The grammar sources live in `inst/*.g`
(e.g. `theta.g`, `omega.g`, `model.g`, `input.g`, `abbrev.g`, `sub.g`,
`lst.g`, `data.g`, `tab.g`, `abbrec.g`). Each grammar is compiled to a
generated C parser `src/<name>.g.d_parser.h`, hand-written reduction
actions live in `src/<name>.c`, and each is exposed to R as a
`_nonmem2rx_trans_<name>` `.Call` entry (registered in `src/init.c`).

**Editing a grammar is a two-step process:** change `inst/<name>.g`,
then regenerate the C parser. The regeneration functions are in
`R/buildParser.R` (all marked `## nocov`): `.nonmem2rxBuildTheta()`,
`.nonmem2rxBuildModel()`, etc., or `.nonmem2rxBuildGram()` to rebuild
everything. These call
[`dparser::mkdparse()`](https://nlmixr2.github.io/dparser-R/reference/mkdparse.html)
and rename the output to `*.g.d_parser.h`. Do not hand-edit the
generated `*.g.d_parser.h` files.

`R/buildParser.R` also **generates R source files** that should not be
edited directly — they carry a “built from buildParser.R, edit there”
banner: - `R/rxSolve.R` — the `rxSolve.nonmem2rx()` method (built by
mirroring
[`rxode2::rxSolve`](https://nlmixr2.github.io/rxode2/reference/rxSolve.html)’s
formals). - `R/rxUiGetGen.R` — `rxUiGet.*` accessors for `$`-completion
/ [`str()`](https://rdrr.io/r/utils/str.html).

### Record-by-record translation (S3 dispatch)

[`nonmem2rx()`](reference/nonmem2rx.md) (in `R/nonmem2rx.R`, the main
entry point) splits a control stream into records and dispatches each to
an S3 method `nonmem2rxRec.<class>` where the class is the 3-letter
record tag (`inp`, `mod`, `the`, `ome`, `sig`, `pk`, `pre`, `des`,
`err`, `dat`, `sub`, `tab`, `pro`, …). The tag mapping and dispatch live
in `R/records.R` (`.transRecords`, `.transRecordsDisplay`,
`UseMethod("nonmem2rxRec")`); the methods are spread across the
correspondingly-named files (`R/theta.R`, `R/omega.R`, `R/model.R`,
`R/input.R`, `R/abbrev.R`, `R/data.R`, `R/sub.R`, `R/tab.R`, `R/pro.R`,
…). To add support for a new record type: add the tag to `.transRecords`
and write a `nonmem2rxRec.<tag>` method.

### Shared parse state

Translation accumulates into a package-level environment `.nonmem2rx`
(created and reset by `.clearNonmem2rx()` in `R/nonmem2rx.R`). This
holds the in-progress `ini`/`model` blocks, ADVAN/ TRANS info,
theta/eta/eps counters and labels, replacement tables, tolerances, etc.
Record methods mutate this environment as they run; it is the connective
tissue between the per-record parsers.

### Result files and validation

Beyond the control stream, dedicated readers pull in NONMEM output:
`R/lst.R` (`.lst` listing), `R/ext.R` (`.ext` final estimates),
`R/omega.R`/`R/readCov.R` (covariance), `R/xml.R` (`.xml`), `R/grd.R`
(`.grd`), `R/nmtab.R`/`R/tab.R` (tables), `R/nminfo.R` (aggregate
[`nminfo()`](reference/nminfo.md)). Standalone readers are exported as
`nmlst`, `nmext`, `nmcov`, `nmxml*`, `nmtab`, `nmgrd`, `nminfo`.
`R/determineError.R` infers the residual/error model; `R/validate.R`
re-simulates and compares PRED/IPRED/IWRES to score the translation.
`R/readInNonmemInput.R` reads the `$DATA` file (honoring
`IGNORE`/`ACCEPT` filtering).

### LLM fallback (optional)

`R/llmError.R` uses `ellmer` (a Suggests dep) as a fallback to infer a
missing `predDf`/error model. The prompt template is
`inst/prompts/llmErrorPrompt.txt` (prompt text lives under `inst/`, not
inline). This path only runs when `ellmer` is available.

## Conventions

- **Style:** camelCase for R identifiers; internal helpers are dotted
  (`.minfo`, `.clearNonmem2rx`). Keep it DRY. User-facing informational
  messages go through `.minfo()` (a
  [`cli::cli_alert_info`](https://cli.r-lib.org/reference/cli_alert.html)
  wrapper).
- **Do not edit generated files:** `R/rxSolve.R`, `R/rxUiGetGen.R`,
  `R/RcppExports.R`, and any `src/*.g.d_parser.h`. Regenerate them
  (buildParser.R functions /
  [`devtools::document()`](https://devtools.r-lib.org/reference/document.html)
  /
  [`Rcpp::compileAttributes()`](https://rdrr.io/pkg/Rcpp/man/compileAttributes.html))
  instead.
- **NONMEM-faithful defaults:** the translation deliberately mirrors
  NONMEM behavior (e.g. it turns off rxode2’s
  `safeZero`/`safePow`/`safeLog` protection because NONMEM does not
  protect by default) and announces these choices via `.minfo()`.
- User-facing changes should be noted in `NEWS.md`.
