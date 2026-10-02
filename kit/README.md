# nonmem2rx round-trip kit

A NONMEM-in-the-loop test kit for `nonmem2rx`. Each case:

1. **simulates** a NONMEM-style dataset with an rxode2 model (the
   "truth"), using the same NONMEM-faithful solving options that
   `nonmem2rx` validates with (`covsInterpolation="nocb"`,
   `addlKeepsCov`, `ssAtDoseTime`, ...);
2. writes the **data file and control stream**, whose initial estimates
   equal the true values;
3. **runs NONMEM** (full mode); and
4. **imports** the run with `nonmem2rx()` and scores the validation
   (NONMEM IPRED/PRED/IWRES vs rxode2).

The cases concentrate on edge cases in the `tests/testthat` model types:
dosing records, `$INPUT`/`$DATA` handling, `$OMEGA`/`$SIGMA` forms,
abbreviated-code constructs, error models, estimation/table outputs,
DDEs and mixtures. Many of the dosing and data cases have no unit test
in the package.

The kit lives in `kit/` and is excluded from the package build
(`.Rbuildignore`).

## Quick start

Run from the package root. When the kit sits inside the `nonmem2rx`
source tree, it loads that tree with `devtools::load_all()`; pass
`--installed` to use the installed package instead.

```sh
# list cases (name, tags, covers)
Rscript kit/run-kit.R --list

# NONMEM-free check of every case (about 1 minute with --jobs 8)
Rscript kit/run-kit.R --mode dry --jobs 8

# the real thing: simulate, run NONMEM, import, validate
Rscript kit/run-kit.R --mode full --nmfe "nmfe75 {ctl} {lst}" --jobs 4

# a subset, by tag or by name
Rscript kit/run-kit.R --mode full --tags dosing,ss --nmfe "nmfe75 {ctl} {lst}"
Rscript kit/run-kit.R --mode full --cases ss2-asymmetric-bid,evid4-reset-dose --nmfe "..."
```

Results go to `kit-runs/` (change with `--out`): one directory per case
plus `summary.md` and `summary.csv`. The exit status is non-zero when any
case is `FAIL` or `ERROR`.

### Modes

| mode | what it does | needs NONMEM |
|---|---|---|
| `dry` | simulate, write `data.csv` + `run.ctl`, translate with `nonmem2rx(validate=FALSE)`. Then solve the translated model at the initial estimates with all random effects zero, and compare its PRED with the rxode2 truth. Also checks that the imported `$OMEGA` (and `$SIGMA` where the case gives one) equals the truth, and that `IGNORE`/`ACCEPT`/`RECORDS` kept exactly the simulated rows. | no |
| `full` | `dry`, then run NONMEM in each case directory and import with full validation | yes |
| `import` | re-import NONMEM output already in `--out` (e.g. after running NONMEM yourself on a cluster: run `dry`, run every `*/run.ctl`, then `import`) | no (uses existing output) |

The dry PRED comparison doesn't depend on NONMEM. It catches translation,
data-reading and event-handling errors (the truth is solved independently
by rxode2), so it is worth running in CI without a license.

### Options

| option | default | meaning |
|---|---|---|
| `--nmfe "cmd"` | `$NMKIT_NMFE` | NONMEM command template; `{ctl}` and `{lst}` are replaced, e.g. `nmfe75 {ctl} {lst}`, `/opt/nm760/run/nmfe76 {ctl} {lst} -maxlim=2`. PsN's `execute {ctl}` also works, because it copies the output back. |
| `--est full\|posthoc` | `full` | default estimation records: `full` = FOCE-I `MAXEVAL=9999` + `$COV`; `posthoc` = `MAXEVAL=0 POSTHOC` at the true values (fast, still exercises tables/.ext/.phi). Cases that test estimation methods keep their own records. |
| `--nsub N` | 20 | subjects per case (some cases fix their own) |
| `--seed N` | 42 | base seed; each case derives a stable seed from its name |
| `--jobs N` | 1 | cases run in parallel (forked) |
| `--timeout S` | 3600 | NONMEM timeout per case |
| `--cases`, `--tags` | all | select cases |

## Reading the results

Status per case:

- `PASS`: every check passed.
- `FAIL`: a check failed. Look in `kit-runs/<case>/` for `import*.log`,
  `dry-compare.csv`, `nonmem.log` and the NONMEM output.
- `ERROR`: the kit itself failed for this case.
- `XFAIL`: a **known issue** (the case's `known` / `knownFull` text is
  shown as the note). An `XPASS` means the issue looks fixed, so
  remove the `known` mark.

Columns in `summary.md`:

- `dryMaxRel`: max % difference, translated PRED vs rxode2 truth.
  Passes at ≤ 0.01 % by default.
- `dryOmegaDiff` / `drySigmaDiff`: max relative difference of the
  imported matrices from the truth. Passes at ≤ 1e-6.
- `ipredRtol` / `predRtol`: median % difference between NONMEM and the
  rxode2 import, from `nonmem2rx` validation (≤ 1 % by default). The 95th
  percentiles (`ipredQ95`/`predQ95` in `summary.csv`, ≤ 5 %) are also
  required, so a subset of wrong records can't hide behind the median.
  Missing rxode2 predictions count as infinite. Both IPRED and PRED must
  validate; a full-mode case fails if either was skipped.
- The dry comparison scores rows whose true value is ~0 (before a lag,
  after a reset) with an absolute floor, and uses NONMEM ID semantics (a
  reused, non-contiguous ID is a new individual).

Per-case thresholds are set with `tol=list(dry=, ipred=, pred=, ipredQ95=,
predQ95=, iwres=, validate=)`. `iwres` is an absolute median IWRES
difference and is off by default. Set a value to `NA` to skip that check.

## Self-test without NONMEM

`kit/mock/fake-nonmem.R` stands in for `nmfe` so the full/import
plumbing can be checked without a license. It writes NONMEM-format
`.lst`, `.ext` and every `$TABLE` file from the rxode2 truth:

```sh
Rscript kit/run-kit.R --mode full --jobs 8 \
  --nmfe "Rscript $PWD/kit/mock/fake-nonmem.R {ctl} {lst}" --out /tmp/kit-mock
```

This is **not** NONMEM and proves nothing about NONMEM's behaviour. Only
a real `--mode full` run does that.

## Layout

```
kit/
  run-kit.R          command-line entry point
  R/case.R           kitCase()/kitVariant() registry and case fields
  R/data.R           nmDose()/nmObs()/nmOther()/nmBind()/nmCov() data builders
  R/sim.R            rxode2 simulation and data writing
  R/nonmem.R         control-stream placeholders and NONMEM execution
  R/import.R         nonmem2rx import, dry PRED/omega/sigma checks, metrics
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
  (see `dose-obs-ties`).
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
| `advan12-trans4-3cmt-oral` | linear | ADVAN12 TRANS4 three-compartment first-order absorption with ALAG1 | dry |
| `advan5-transit` | ode | ADVAN5 general linear model with named $MODEL COMP (DEFDOSE/DEFOBS), transit chain and peripheral (matExp translation) |  |
| `advan7-t-notation` | ode | ADVAN7 with K1T0/K1T2/K2T1 'T' rate-constant notation |  |
| `advan7-unnamed-comp` | ode | ADVAN7 where $MODEL names the first compartment but leaves the second as a bare COMP | dry |
| `advan6-michaelis-menten` | ode | ADVAN6 nonlinear (Michaelis-Menten) elimination with TOL; IV bolus at two dose levels |  |
| `advan13-pkpd-turnover` | ode | ADVAN13 PK + indirect response with A_0 baseline, two endpoints switched on CMT in $ERROR, ATOL/TOL/SSTOL |  |
| `advan13-time-in-des-no-doses` | ode | ADVAN13 endogenous circadian turnover using T inside $DES; dataset has no dose records; A_0 from THETA |  |
| `advan14-ode` | ode | ADVAN14 (CVODES) two-compartment ODE oral model |  |
| `advan13-abbr-replace-names` | ode | $ABBR REPLACE of THETA/ETA/DADT/A by name (nm7.5 style) with named compartments |  |
| `rate-minus1-modeled-rate` | dosing | RATE=-1 with modeled zero-order rate R1 (ETA on R1) |  |
| `rate-minus2-modeled-dur` | dosing | RATE=-2 with modeled duration D1 (ETA on D1) |  |
| `dur-with-lag` | dosing | RATE=-2 modeled duration combined with ALAG1 on the same compartment |  |
| `infusion-bioav-fixed-rate` | dosing | F1 < 1 applied to a fixed-RATE infusion (NONMEM shortens the duration, rate unchanged) |  |
| `infusion-with-lag` | dosing | ALAG1 applied to a fixed-RATE infusion |  |
| `dual-absorption` | dosing | Same dose split into first-order depot (F1) and zero-order central input (RATE=-2, D2, F2=1-F1) | dry |
| `ss2-asymmetric-bid` | dosing | Asymmetric BID at steady state: SS=1 morning dose then SS=2 evening dose (superposition), both II=24 |  |
| `ss-constant-infusion` | dosing | Steady-state constant infusion (SS=1, AMT=0, RATE>0, II=0) with a bolus on top later |  |
| `ss-with-lag` | dosing | Steady state (SS=1) oral dosing with an absorption lag longer than a quarter of the interval |  |
| `evid3-reset` | dosing | EVID=3 reset record between two dosing periods (ADDL in first period) |  |
| `evid4-reset-dose` | dosing | EVID=4 reset-and-dose record starting a second period |  |
| `evid2-time-varying-cov` | dosing | Time-varying covariate changed on EVID=2 records (NONMEM next-observation-carried-backward semantics) |  |
| `cmt-off-depot` | dosing | Negative CMT on an EVID=2 record turns the depot off (e.g. emesis) mid-absorption | dry |
| `infusion-into-depot` | dosing | Zero-order infusion (RATE>0) into the absorption depot of ADVAN2, overlapping a bolus |  |
| `mtime-change-point` | dosing | MTIME/MPAST model event time switching KA at an estimated time (ADVAN2) | dry |
| `dose-obs-ties` | dosing | Ties: obs listed before/after a dose and after an SS dose at the same TIME, plus replicate samples at one TIME | dry |
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
| `if-else-logic` | code | IF/ELSE IF/ELSE/ENDIF, nested IF, one-line IF, .AND./.OR., ==, >=, .NE. and $ERROR (ONLY OBSERVATIONS) |  |
| `logical-not-and-slash-ne` | code | Fortran .NOT. and the /= operator in IF conditions | dry |
| `math-functions` | code | DEXP/DLOG/LOG10/DSQRT/DABS/** powers, MIN/MAX, and a probit bioavailability using PHI() |  |
| `do-while-loop` | code | DO WHILE / ENDDO loop computing an allometric factor |  |
| `pred-emax-reserved-names` | code | $PRED sigmoid Emax with variables named GAMMA, BETA, LAMBDA (rxode2 function names) and no dose records |  |
| `time-in-pk` | code | TIME used in $PK (time-varying CL): NONMEM evaluates $PK only at records, so CL is piecewise constant (next-record value) | dry |
| `retained-pk-variables` | code | Savic transit absorption: dose amount/time kept in $PK variables across records (IF (AMT.GT.0) ...), GAMLN in $DES | dry |
| `err-add-eps` | error | Additive error on EPS with an estimated $SIGMA (Y = IPRED + EPS(1)) |  |
| `err-exp-eps` | error | Exponential error Y = IPRED*EXP(EPS(1)) (log-normal on the original scale) |  |
| `err-log-dv` | error | Log-transformed DV with additive error on the log scale and a guarded LOG(F) |  |
| `err-two-eps-theta` | error | Combined error with two THETA-scaled EPS and $SIGMA 1 FIX 1 FIX |  |
| `err-combined1` | error | Combined error on the SD scale, W = THETA(a) + THETA(b)*IPRED (rxode2 combined1) |  |
| `err-power` | error | Power error model W = THETA*IPRED**THETA |  |
| `err-m3-blq` | error | M3 censoring: BLQ records use F_FLAG=1 with Y = PHI((LLOQ-IPRED)/W) (LAPLACE) | full |
| `est-saem-imp` | estimation | Two estimation steps: SAEM then IMP EONLY=1 (.ext holds two tables; final is IMP) |  |
| `est-its-foce` | estimation | ITS followed by FOCE-I (METHOD=COND INTER) with MATRIX=R covariance |  |
| `est-foce-no-inter` | estimation | FOCE without INTERACTION (METHOD=1) and no $COV step |  |
| `est-fo-posthoc` | estimation | First-order (METHOD=0) estimation with POSTHOC etas |  |
| `est-maxeval0` | estimation | MAXEVAL=0 POSTHOC evaluation only (final estimates = initial estimates) |  |
| `table-noheader-format` | estimation | NOHEADER/NOAPPEND tables with FORMAT=s1PE17.9, PRED listed explicitly, separate FIRSTONLY ETA1 ETA2 table | full |
| `table-ipre-alias` | estimation | Legacy 4-character IPRE in code and tables, an extra full table without IPRED listed first, ETAs in a full table |  |
| `table-repeated-headers` | estimation | Tables longer than 900 records without ONEHEADER (NONMEM repeats the TABLE NO. header block) |  |
| `dde-advan16-delay` | special | ADVAN16 delay differential equation: delayed drug effect via AD_1_1 with TAU1 and constant past AP_1_1 |  |
| `mix-two-clearance` | special | $MIX with two sub-populations (fast/slow clearance), P(1)=THETA, MIXNUM and MIXEST in $PK |  |

`known` = "dry": XFAIL in every mode (a translation problem). "full": the
dry run passes, but `nonmem2rx`'s validation against NONMEM output has a
known problem. The `known`/`knownFull` text in each case records the
diagnosis.
