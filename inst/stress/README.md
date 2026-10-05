# nonmem2rx NONMEM stress kit

The stress kit checks how nonmem2rx imports NONMEM runs, case by case.
For each case it:

1. **simulates** a NONMEM-style dataset with an rxode2 model (the
   "truth"), using the same NONMEM-faithful solving options that
   nonmem2rx validates with;
2. writes the **data file and control stream**, whose initial estimates
   equal the true values;
3. **runs NONMEM**; and
4. **imports** the run with `nonmem2rx()` and checks it: NONMEM's own
   IPRED/PRED against rxode2's.

It has two modes:

- **translate**: steps 1, 2 and 4 without NONMEM. The translated model is
  solved at the true values with the random effects set to zero and
  compared with the rxode2 truth. The imported `$OMEGA`/`$SIGMA` and the
  records kept by `IGNORE`/`ACCEPT`/`RECORDS` are checked too. No NONMEM
  is needed.
- **run**: also runs NONMEM and validates the import against NONMEM's
  output. Use this mode on a machine that has NONMEM.

The cases concentrate on edge cases: dosing records, `$INPUT`/`$DATA`
handling, `$THETA`/`$OMEGA`/`$SIGMA` forms, abbreviated code, error
models, estimation methods and table formats, DDEs and mixtures (see
[Cases](#cases)).

## Quick start: the kit for a NONMEM machine

Everything runs from the R session that is set up for NONMEM (for
example RStudio); no `Rscript` is needed and nothing is installed.

1. In a fresh session (Session > Restart R), load the nonmem2rx version
   to test (for example a pull request branch) and the kit:

   ```r
   devtools::load_all("path/to/nonmem2rx")
   source(system.file("stress", "stress.R", package = "nonmem2rx"))
   ```

   Restart R and load again before each run, so the session cannot run
   older nonmem2rx code with a newer kit.

2. Check the versions and that NONMEM is found:

   ```r
   stressCheck()
   stressCheck(nonmem = "/opt/nm75/run/nmfe75")   # if NONMEM is not found
   ```

   NONMEM is found from `options(nonmem2rx.nonmem=)` or
   `options(babelmixr2.nonmem=)`, an `nmfe7*` on the `PATH`, or the usual
   install directories (like `/opt/NONMEM/nm75/run/nmfe75` or
   `C:/nm75/run/nmfe75.bat`); otherwise give it with `nonmem=`.

3. Run the kit:

   ```r
   res <- stressKit()                                    # NONMEM is found
   res <- stressKit(nonmem = "nmfe743-ifort")            # NONMEM not found
   res <- stressKit(cases = "advan1|ss2", nonmem = "nmfe75")   # a few cases first
   res <- stressKit(est = "posthoc")                     # MAXEVAL=0: much faster
   res[res$status %in% c("FAIL", "ERROR", "XPASS"), c("case", "status", "note")]
   ```

   `stressKit()` simulates and translates every case, runs NONMEM on
   each, imports and validates the output, and zips the output folder
   (`nonmem2rx-stress-<date>-<time>.zip` in the working directory;
   `attr(res, "zip")` has its path).

4. Send the zip file back.

The full kit is one NONMEM run per case (about 80 small FOCE-I fits plus
SAEM/IMP, ITS, FO and LAPLACE cases), so it takes a while;
`est = "posthoc"` replaces the default FOCE-I fits with `MAXEVAL=0`
evaluations and still writes every output file. `stressList()` lists the
cases.

`stressKit()` arguments: `nonmem=`, `modes=` (`"translate"` and/or
`"run"`), `cases=` (a regular expression), `tags=`, `est=` (`"full"` or
`"posthoc"`), `nSub=`, `jobs=` (cases in parallel; not on Windows),
`timeout=` (seconds per NONMEM run; not on Windows), `out=` (output
directory), `bundle=`.

Cases that use NONMEM 7.5 features (tag `nm75`: `$DATA TRANSLATE`, 7.5
`THETA(CL)` labels, `ADVAN16` delay equations) are reported as `SKIP`, not
as failures, when an older NONMEM stops on them; run them on NONMEM 7.5
with `stressKit(nonmem = "nmfe75", tags = "nm75")`.  NONMEM 7.6 is not
needed.

### Without NONMEM

```r
res <- stressKit(modes = "translate", bundle = FALSE)
```

This needs no NONMEM; it is the check to run after every change to
nonmem2rx.

### Back home: replaying a returned zip

The returned zip holds each case's control stream, data and NONMEM
output, so it can be imported again on a machine without NONMEM, for
example after a fix:

```r
devtools::load_all("path/to/nonmem2rx")
source(system.file("stress", "stress.R", package = "nonmem2rx"))
res <- stressReplay("nonmem2rx-stress-20261004-101500.zip")
res <- stressReplay("nonmem2rx-stress-20261004-101500.zip", cases = "mtime")
```

## Running it with Rscript

Where `Rscript` works with the right library paths, `run-stress.R` does
the same from a shell:

```sh
STRESS=inst/stress/run-stress.R   # in a nonmem2rx checkout
Rscript "$STRESS" --check
Rscript "$STRESS" --list
Rscript "$STRESS" --mode=translate --jobs=8
Rscript "$STRESS" --kit --nonmem=nmfe75
Rscript "$STRESS" --mode=run --nonmem=/opt/nm75/run/nmfe75 --tags=dosing,ss
Rscript "$STRESS" --replay=nonmem2rx-stress-20261004-101500.zip
```

The options match the `stressKit()` arguments (`--cases=`, `--tags=`,
`--est=`, `--nsub=`, `--jobs=`, `--timeout=`, `--out=`, `--bundle`);
`--installed` uses the installed nonmem2rx instead of the source tree.
The script exits with status 1 when any case fails, so it can be used in
a CI job.

## Output

The output directory (by default `nonmem2rx-stress-<date>-<time>`) has:

- `results.csv`: one row per case, with
  - `status`:
    - `PASS`: every check passed
    - `FAIL`: a check failed
    - `ERROR`: the kit itself failed for this case
    - `XFAIL`: a known issue (the diagnosis is in `note`)
    - `XPASS`: a known issue that now passes, so its mark can go
    - `SKIP`: needs NONMEM 7.5 and an older NONMEM stopped
  - `dryMaxRel`: the largest % difference between the translated model's
    PRED and the rxode2 truth (translate check; passes at 0.01 %)
  - `dryOmegaDiff`/`drySigmaDiff`: the largest relative difference of the
    imported omega/sigma from the truth (passes at 1e-6)
  - `ipredRtol`/`predRtol`: median % difference between NONMEM's and
    rxode2's IPRED/PRED (passes at 1 %); `ipredQ95`/`predQ95`: the 95th
    percentiles (pass at 5 %); missing rxode2 predictions count as
    infinite, and both IPRED and PRED must validate
  - `nmSeconds`: how long NONMEM took; `note`: what went wrong
- `summary.md`: the versions (including the nonmem2rx git commit) and a
  table of every case.
- `sessionInfo.txt`: the R session.
- `<case>/`: the control stream (`run.ctl`), data (`data.csv`), the
  simulation (`sim.rds`), NONMEM's output (`run.lst`, `.ext`, `.phi`,
  `.cov`, tables, `nonmem.log`) and the import logs (`import-dry.log`,
  `import.log`, `dry-compare.csv`). NONMEM's executable and scratch files
  are removed after each run.

Per-case thresholds are set with `tol=list(dry=, ipred=, pred=,
ipredQ95=, predQ95=, iwres=, validate=)` in the case.

## Lower-level runner

`stressKit()` calls `runKit()`, which can also be used directly:
`runKit(mode = "dry" | "full" | "import", nmfe = "nmfe75 {ctl} {lst}",
cases =, tags =, est =, nSub =, seed =, jobs =, out =, timeout =)`.
`mode = "import"` re-imports NONMEM output already in `out` (run `dry`,
run NONMEM on every `*/run.ctl` yourself, then `import`).

## Self-test without NONMEM

`mock/fake-nonmem.R` stands in for `nmfe` so the run/import plumbing can
be checked without a license. It writes NONMEM-format `.lst`, `.ext` and
every `$TABLE` file from the rxode2 truth:

```r
stressKit(nonmem = paste("Rscript", system.file("stress", "mock", "fake-nonmem.R",
                                                package = "nonmem2rx")),
          bundle = FALSE, out = tempfile("stress-mock"))
```

This is **not** NONMEM and proves nothing about NONMEM's behaviour.

## Layout

```
inst/stress/
  stress.R           source() this: loads nonmem2rx, the kit and its cases
  run-stress.R       the same from Rscript
  R/stress-kit.R     stressCheck(), stressList(), stressKit(), stressReplay()
  R/main.R           runKit()
  R/case.R           kitCase()/kitVariant() registry and case fields
  R/data.R           nmDose()/nmObs()/nmOther()/nmBind()/nmCov() data builders
  R/sim.R            rxode2 simulation and data writing
  R/nonmem.R         control-stream placeholders and NONMEM execution
  R/import.R         nonmem2rx import, translate-mode checks, metrics
  R/run.R            per-case pipeline and pass/fail rules
  R/report.R         summary.md / summary.csv
  cases/NN-*.R       the cases (one file per theme)
  mock/fake-nonmem.R plumbing self-test
```

## Writing a case

```r
kitCase(
  name="rate-minus2-modeled-dur",
  covers="RATE=-2 with modeled duration D1 (ETA on D1)",
  tags=c("dosing", "infusion", "modeled-dur"),
  sim=function() {                      # rxode2 truth; ETAs in ETA() order
    ini({ tcl <- 2; tv <- 20; td1 <- 3; prop.sd <- 0.1
          eta.cl ~ 0.09; eta.v ~ 0.04; eta.d1 ~ 0.09 })
    model({ cl <- tcl*exp(eta.cl); v <- tv*exp(eta.v)
            d/dt(central) <- -cl/v*central
            dur(central) <- td1*exp(eta.d1)
            ipred <- central/v
            ipred ~ prop(prop.sd) })
  },
  data=function(nSub) {                 # NONMEM-style rows
    .id <- seq_len(nSub)
    nmBind(nmDose(.id, c(0, 24), amt=200, cmt=1, rate=-2),
           nmObs(.id, c(0.5, 1, 2, 4, 8, 23.9, 26, 30), cmt=1))
  },
  ctl="$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
...
{{EST}}
{{TABLE}}
")
```

Rules of thumb:

- Write THETAs in natural units, with initial estimates **equal to** the
  `sim` values, so the dry PRED comparison is exact.
- Declare ETAs in `sim` in the same order as `ETA(n)`, so the omega
  check lines up.
- Define `IPRED` and `IWRES` in `$ERROR`/`$PRED`, and keep the `ROWID`
  column (the standard `{{TABLE}}` writes `ID TIME EVID ROWID IPRED IWRES`
  plus a `FIRSTONLY` ETA table).
- Avoid records that tie in TIME unless ties are the point of the case
  (see `dose-obs-ties`). rxode2 sorts tied records, so `nonmem2rx`
  deliberately offsets them by `delta=1e-4`, which gives small
  differences where concentrations change fast.
- Use `write=` for anything rxode2 can't simulate directly: clock times,
  comment/junk rows to be ignored, character columns, aliased names,
  reused IDs. Junk rows should carry doses that would change the
  predictions, so a filtering mistake is caught.
- `kitVariant(base, name, covers, ...)` reuses a case with some fields
  overridden. `known=` / `knownFull=` record an understood failure.

Other hooks: `input=` (explicit `$INPUT`), `postSim=` (custom DV, e.g.
BLQ), `dryRows=` (rows used in the dry comparison), `sigma=` (expected
`$SIGMA`), `est=` (case-specific estimation records), `nSub=`,
`dryPred=FALSE`, `dryOmega=FALSE`, `tol=`. Placeholders: `{{PROBLEM}}`,
`{{INPUT}}`, `{{DATA}}`, `{{EST}}`, `{{TABLE}}`, `{{NSIM}}` (number of
simulated records, for `RECORDS=`).

## Cases

| case | theme | covers | known |
|---|---|---|---|
| `advan1-trans2-bolus` | linear | ADVAN1 TRANS2 IV bolus; add+prop error via THETA W and SIGMA 1 FIX |  |
| `advan2-trans2-lag-f` | linear | ADVAN2 TRANS2 oral with ALAG1 and logit F1 (ETA on both); ADDL/II multiple dosing |  |
| `advan2-trans1-k` | linear | ADVAN2 TRANS1 (K, KA) parameterization with S2 scaling in different units (mg dose, ug/L) |  |
| `advan3-trans4-infusion` | linear | ADVAN3 TRANS4 two-compartment zero-order infusion (positive RATE) with covariate WT power model |  |
| `advan3-trans3-vss` | linear | ADVAN3 TRANS3 (CL, V, Q, VSS) parameterization |  |
| `advan4-trans4-ss` | linear | ADVAN4 TRANS4 two-compartment oral at steady state (SS=1, II) followed by washout |  |
| `advan11-trans4-3cmt` | linear | ADVAN11 TRANS4 three-compartment IV infusion at steady state (SS=1 with RATE) |  |
| `advan12-trans4-3cmt-oral` | linear | ADVAN12 TRANS4 three-compartment first-order absorption with ALAG1 |  |
| `advan12-trans1-k` | linear | ADVAN12 TRANS1 three-compartment oral with micro constants K, K23, K32, K24, K42, KA |  |
| `advan3-trans5-macro` | linear | ADVAN3 TRANS5 macro constants (ALPHA, BETA, AOB) |  |
| `advan3-trans6-macro` | linear | ADVAN3 TRANS6 macro constants (ALPHA, BETA, K21) |  |
| `advan4-trans5-macro` | linear | ADVAN4 TRANS5 macro constants (ALPHA, BETA, AOB, KA) |  |
| `advan4-trans6-macro` | linear | ADVAN4 TRANS6 macro constants (ALPHA, BETA, K32, KA) |  |
| `advan5-transit` | ode | ADVAN5 general linear model with named $MODEL COMP (DEFDOSE/DEFOBS), transit chain and peripheral (matExp translation) |  |
| `advan7-t-notation` | ode | ADVAN7 with K1T0/K1T2/K2T1 'T' rate-constant notation |  |
| `advan7-unnamed-comp` | ode | ADVAN7 where $MODEL names the first compartment but leaves the second as a bare COMP |  |
| `advan6-michaelis-menten` | ode | ADVAN6 nonlinear (Michaelis-Menten) elimination with TOL; IV bolus at two dose levels |  |
| `advan13-pkpd-turnover` | ode | ADVAN13 PK + indirect response with A_0 baseline, two endpoints switched on CMT in $ERROR, ATOL/TOL/SSTOL |  |
| `advan13-time-in-des-no-doses` | ode | ADVAN13 endogenous circadian turnover using T inside $DES; dataset has no dose records; A_0 from THETA |  |
| `advan14-ode` | ode | ADVAN14 (CVODES) two-compartment ODE oral model |  |
| `advan13-abbr-replace-names` | ode | $ABBR REPLACE of THETA/ETA/DADT/A by name with named compartments |  |
| `rate-minus1-modeled-rate` | dosing | RATE=-1 with modeled zero-order rate R1 (ETA on R1) |  |
| `rate-minus2-modeled-dur` | dosing | RATE=-2 with modeled duration D1 (ETA on D1) |  |
| `dur-with-lag` | dosing | RATE=-2 modeled duration combined with ALAG1 on the same compartment |  |
| `infusion-bioav-fixed-rate` | dosing | F1 < 1 applied to a fixed-RATE infusion (NONMEM shortens the duration, rate unchanged) |  |
| `infusion-with-lag` | dosing | ALAG1 applied to a fixed-RATE infusion |  |
| `dual-absorption` | dosing | Same dose split into first-order depot (F1) and zero-order central input (RATE=-2, D2, F2=1-F1) | always |
| `ss2-asymmetric-bid` | dosing | Asymmetric BID at steady state: SS=1 morning dose then SS=2 evening dose (superposition), both II=24 |  |
| `ss-constant-infusion` | dosing | Steady-state constant infusion (SS=1, AMT=0, RATE>0, II=0) with a bolus on top later |  |
| `ss-with-lag` | dosing | Steady state (SS=1) oral dosing with an absorption lag longer than a quarter of the interval |  |
| `evid3-reset` | dosing | EVID=3 reset record between two dosing periods (ADDL in first period) |  |
| `evid4-reset-dose` | dosing | EVID=4 reset-and-dose record starting a second period |  |
| `evid2-time-varying-cov` | dosing | Time-varying covariate changed on EVID=2 records (NONMEM next-observation-carried-backward semantics) |  |
| `cmt-off-depot` | dosing | Negative CMT on an EVID=2 record turns the depot off (e.g. emesis) mid-absorption | always |
| `infusion-into-depot` | dosing | Zero-order infusion (RATE>0) into the absorption depot of ADVAN2, overlapping a bolus |  |
| `mtime-change-point` | dosing | MTIME/MPAST model event time switching KA at an estimated time (ADVAN2) | always |
| `dose-obs-ties` | dosing | Ties: obs listed before/after a dose and after an SS dose at the same TIME, plus replicate samples at one TIME | always |
| `mtime-change-point-ode` | dosing | MTIME/MPAST switching KA in an ADVAN13 ODE model |  |
| `cmt-off-depot-ode` | dosing | Negative CMT on an EVID=2 record turns the depot off in an ADVAN13 ODE model |  |
| `input-alias-drop-skip` | data | $INPUT synonyms on both sides (TAFD=TIME, CONC=DV) used in code, DROP/SKIP of character columns, '.' DV on dose rows |  |
| `ignore-hash-and-list` | data | IGNORE=# header/comment lines together with IGNORE=(FLAG.EQ.1) and IGNORE=(AMT.GT.1000) filters |  |
| `ignore-c-column` | data | Leading C column with IGNORE=C (Bauer-style commented records) including the header |  |
| `accept-filter` | data | ACCEPT=(STUDY.EQ.1) keeping only one study's records (with IGNORE=@ header) |  |
| `records-limit` | data | RECORDS=n reading only the first n data records; trailing records belong to a junk subject |  |
| `clock-time-date` | data | Clock times (HH:MM) with DATE=DROP (MM/DD/YYYY), crossing midnight and Feb 29 |  |
| `clock-time-dat1` | data | Clock times with DAT1 (DD/MM/YYYY) day-first dates |  |
| `translate-time-days` | data | $DATA TRANSLATE=(TIME/24/4 II/24/4): file in hours, model in days (NONMEM 7.5+) |  |
| `repeated-nonmonotone-ids` | data | Non-monotone ID values reused by non-contiguous individuals (10, 2, 7, 10, 2, ...) |  |
| `lowercase-input` | data | Lower-case $INPUT labels (id time amt dv ...) with upper-case abbreviated code |  |
| `reserved-columns` | data | Data columns that are reserved in rxode2 (DUR informational, SIM replicate, TAD) next to fixed-RATE infusions |  |
| `dvid-no-cmt` | data | Parent + metabolite endpoints selected by DVID with no CMT column (doses to DEFDOSE) |  |
| `omega-block-labels-order` | params | $OMEGA BLOCK(2) between diagonal records, labels inside the block, ETAs used out of order in code |  |
| `omega-sd-correlation` | params | $OMEGA BLOCK(2) SD CORRELATION, $OMEGA VARIANCE, and $SIGMA SD with an EPS-based proportional error |  |
| `omega-cholesky` | params | $OMEGA BLOCK(2) CHOLESKY (lower-triangular factor) values |  |
| `omega-same-iov` | params | Inter-occasion variability: $OMEGA BLOCK(1) + BLOCK(1) SAME selected by an OCC column |  |
| `theta-forms` | params | $THETA numeric forms (.12E+01, 3.0E1, 1E+04, 3.), FIX in several positions and empty upper bounds |  |
| `sigma-block-two-eps` | params | $SIGMA BLOCK(2) with additive + proportional EPS (Y=IPRED*(1+EPS(1))+EPS(2)) |  |
| `labels-nm75` | params | NONMEM 7.5 labels: $THETA CL=(...), $OMEGA ECL=..., $SIGMA PROP=..., referenced as THETA(CL)/ETA(ECL)/EPS(PROP) |  |
| `if-else-logic` | code | IF/ELSE IF/ELSE/ENDIF, nested IF, one-line IF, .AND./.OR. precedence without parentheses, ==, >=, .NE. and $ERROR (ONLY OBSERVATIONS) |  |
| `logical-not-and-slash-ne` | code | Fortran .NOT. and the /= operator in IF conditions |  |
| `math-functions` | code | DEXP/DLOG/LOG10/DSQRT/DABS/** powers, MIN/MAX, and a probit bioavailability using PHI() |  |
| `do-while-loop` | code | DO WHILE / ENDDO loop computing an allometric factor |  |
| `pred-emax-reserved-names` | code | $PRED sigmoid Emax with variables named GAMMA, BETA, LAMBDA (rxode2 function names) and no dose records |  |
| `time-in-pk` | code | TIME used in $PK (time-varying CL): NONMEM evaluates $PK only at records, so CL is piecewise constant (next-record value) | always |
| `retained-pk-variables` | code | Savic transit absorption: dose amount/time kept in $PK variables across records (IF (AMT.GT.0) ...), GAMLN in $DES | always |
| `err-add-eps` | error | Additive error on EPS with an estimated $SIGMA (Y = IPRED + EPS(1)) |  |
| `err-exp-eps` | error | Exponential error Y = IPRED*EXP(EPS(1)) (log-normal on the original scale) |  |
| `err-log-dv` | error | Log-transformed DV with additive error on the log scale and a guarded LOG(F) |  |
| `err-two-eps-theta` | error | Combined error with two THETA-scaled EPS and $SIGMA 1 FIX 1 FIX |  |
| `err-combined1` | error | Combined error on the SD scale, W = THETA(a) + THETA(b)*IPRED (rxode2 combined1) |  |
| `err-power` | error | Power error model W = THETA*IPRED**THETA |  |
| `err-m3-blq` | error | M3 censoring: BLQ records use F_FLAG=1 with Y = PHI((LLOQ-IPRED)/W) (LAPLACE) | run |
| `est-saem-imp` | estimation | Two estimation steps: SAEM then IMP EONLY=1 (.ext holds two tables; final is IMP) |  |
| `est-its-foce` | estimation | ITS followed by FOCE-I (METHOD=COND INTER) with MATRIX=R covariance |  |
| `est-foce-no-inter` | estimation | FOCE without INTERACTION (METHOD=1) and no $COV step |  |
| `est-fo-posthoc` | estimation | First-order (METHOD=0) estimation with POSTHOC etas |  |
| `est-maxeval0` | estimation | MAXEVAL=0 POSTHOC evaluation only (final estimates = initial estimates) |  |
| `table-noheader-format` | estimation | NOHEADER/NOAPPEND tables with FORMAT=s1PE17.9, PRED listed explicitly, separate FIRSTONLY ETA1 ETA2 table | run |
| `table-ipre-alias` | estimation | Legacy 4-character IPRE in code and tables, an extra full table without IPRED listed first, ETAs in a full table |  |
| `table-repeated-headers` | estimation | Tables longer than 900 records without ONEHEADER (NONMEM repeats the TABLE NO. header block) |  |
| `dde-advan16-delay` | special | ADVAN16 delay differential equation: delayed drug effect via AD_1_1 with TAU1 and constant past AP_1_1 |  |
| `mix-two-clearance` | special | $MIX with two sub-populations (fast/slow clearance), P(1)=THETA, MIXNUM and MIXEST in $PK |  |

`known`: "always" cases are XFAIL in both modes (a translation problem);
"run" cases pass the translate checks, but nonmem2rx's validation against
NONMEM output has a known problem. The `known`/`knownFull` text in each
case records the diagnosis.
