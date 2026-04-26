# Reading rounding from NONMEM

One of the things that can be helpful is reading NONMEM with rounding
errors.

For this example we will take some of the test examples from
`babelmixr2` to translate to show examples of rounding errors that can
be read in to help diagnose what could be happening with the model.

``` r
library(nonmem2rx)
library(babelmixr2)
```

## Step 1: Have a NONMEM model with rounding errors (and `.phi` or other information about the `etas`)

The first step is to load a model with rounding errors using
[`nonmem2rx()`](../reference/nonmem2rx.md):

``` r
# Unzip example with rounding error
# included, but can be accessed with nlmixr2
#
# unzip(system.file("tests/testthat/pk.turnover.emax3-nonmem.zip", package="babelmixr2"))
# Load the model with `nonmem2rx`:
mod <- nonmem2rx("pk.turnover.emax3-nonmem/pk.turnover.emax3.nmctl")
#> ℹ getting information from  'pk.turnover.emax3-nonmem/pk.turnover.emax3.nmctl'
#> ℹ reading in xml file
#> ℹ done
#> ℹ reading in ext file
#> ℹ done
#> ℹ reading in phi file
#> ℹ done
#> ℹ reading in lst file
#> ℹ abbreviated list parsing
#> ℹ done
#> ℹ reading in grd file
#> ℹ done
#> ℹ splitting control stream by records
#> ℹ done
#> ℹ Processing record $INPUT
#> ℹ Processing record $MODEL
#> ℹ Processing record $gTHETA
#> ℹ Processing record $OMEGA
#> ℹ Processing record $SIGMA
#> ℹ Processing record $PROBLEM
#> ℹ Processing record $DATA
#> ℹ Processing record $SUBROUTINES
#> ℹ Processing record $PK
#> ℹ Processing record $DES
#> ℹ Processing record $ERROR
#> ℹ Processing record $ESTIMATION
#> ℹ Ignore record $ESTIMATION
#> ℹ Processing record $COVARIANCE
#> ℹ Ignore record $COVARIANCE
#> ℹ Processing record $TABLE
#> ℹ change initial estimate of `theta1` to `6.24053043162953e-07`
#> ℹ change initial estimate of `theta2` to `-3.00642760553675e-06`
#> ℹ change initial estimate of `theta3` to `-2.00405074386117`
#> ℹ change initial estimate of `theta4` to `2.05188410700476`
#> ℹ change initial estimate of `theta5` to `0.0985804613565218`
#> ℹ change initial estimate of `theta6` to `0.511625249037084`
#> ℹ change initial estimate of `theta7` to `6.4184983102259`
#> ℹ change initial estimate of `theta8` to `0.140763261319656`
#> ℹ change initial estimate of `theta9` to `-2.9534704318737`
#> ℹ change initial estimate of `theta10` to `4.57045413136592`
#> ℹ change initial estimate of `theta11` to `3.71714384851537`
#> ℹ change initial estimate of `eta1` to `0.558129815059436`
#> ℹ change initial estimate of `eta2` to `0.558402321309217`
#> ℹ change initial estimate of `eta3` to `0.0785849119252598`
#> ℹ change initial estimate of `eta4` to `0.0508226905750953`
#> ℹ change initial estimate of `eta5` to `5e-05`
#> ℹ change initial estimate of `eta6` to `0.18426809257979`
#> ℹ change initial estimate of `eta7` to `0.0083631531443303`
#> ℹ change initial estimate of `eta8` to `0.00274561514766752`
#> ℹ read in nonmem input data (for model validation): /home/runner/work/nonmem2rx/nonmem2rx/vignettes/articles/pk.turnover.emax3-nonmem/pk.turnover.emax3.csv
#> ℹ ignoring lines that begin with a letter (IGNORE=@)'
#> ℹ applying names specified by $INPUT
#> ℹ renaming 'ytype' to 'nmytype'
#> ℹ renaming 'dvid' to 'nmdvid'
#> ℹ done
#> ℹ read in nonmem IPRED data (for model validation): /home/runner/work/nonmem2rx/nonmem2rx/vignettes/articles/pk.turnover.emax3-nonmem/pk.turnover.emax3.pred
#> ℹ done
#> ℹ changing most variables to lower case
#> ℹ done
#> ℹ replace theta names
#> ℹ done
#> ℹ replace eta names
#> ℹ done
#> ℹ renaming compartments
#> ℹ done
#> ℹ solving ipred problem
#> ℹ done
#> ℹ solving pred problem
#> ℹ done
mod
```

$$\begin{aligned}
{cmt(DEPOT)} & \\
{cmt(GUT)} & \\
{cmt(CENTER)} & \\
{cmt(EFFECT)} & \\
{mu\_ 1} & {= {tktr}} \\
{mu\_ 2} & {= {tka}} \\
{mu\_ 3} & {= {tcl}} \\
{mu\_ 4} & {= {tv}} \\
{mu\_ 5} & {= {temax}} \\
{mu\_ 6} & {= {tec50}} \\
{mu\_ 7} & {= {tkout}} \\
{mu\_ 8} & {= {te0}} \\
{ktr} & {= \exp\left( {mu\_ 1} + {eta.ktr} \right)} \\
{ka} & {= \exp\left( {mu\_ 2} + {eta.ka} \right)} \\
{cl} & {= \exp\left( {mu\_ 3} + {eta.cl} \right)} \\
v & {= \exp\left( {mu\_ 4} + {eta.v} \right)} \\
{emax} & {= \left( (1) - (0) \right) \times \left( \frac{1}{\left( 1 + \exp\left( - \left( {mu\_ 5} + {eta.emax} \right) \right) \right)} \right) + (0)} \\
{ec50} & {= \exp\left( {mu\_ 6} + {eta.ec50} \right)} \\
{kout} & {= \exp\left( {mu\_ 7} + {eta.kout} \right)} \\
{e0} & {= \exp\left( {mu\_ 8} + {eta.e0} \right)} \\
{rxini.rxddta4.} & {= {e0}} \\
{EFFECT(0)} & {= {rxini.rxddta4.}} \\
{dcp} & {= \frac{CENTER}{v}} \\
{rxdz001} & {= \left( {ec50} + {dcp} \right)} \\
{if} & {\left( {rxdz001} \geq 0 \land {rxdz001} \leq {1 \times 10^{- 6}} \right)\{} \\
 & {{rxdz001} = {1 \times 10^{- 6}}} \\
\} & \\
{if} & {\left( {rxdz001} \geq - {1 \times 10^{- 6}} \land {rxdz001} < 0 \right)\{} \\
 & {{rxdz001} = - {1 \times 10^{- 6}}} \\
\} & \\
{pd} & {= 1 - \frac{{emax} \times {dcp}}{rxdz001}} \\
{kin} & {= {e0} \times {kout}} \\
\frac{d\ DEPOT}{dt} & {= - {ktr} \times {DEPOT}} \\
\frac{d\ GUT}{dt} & {= {ktr} \times {DEPOT} - {ka} \times {GUT}} \\
\frac{d\ CENTER}{dt} & {= {ka} \times {GUT} - \frac{cl}{v} \times {CENTER}} \\
\frac{d\ EFFECT}{dt} & {= {kin} \times {pd} - {kout} \times {EFFECT}} \\
{cp} & {= \frac{CENTER}{v}} \\
f & {= {DEPOT}} \\
{rxe\_ dcp} & {= \frac{CENTER}{v}} \\
{rxdze001} & {= \left( {ec50} + {rxe\_ dcp} \right)} \\
{if} & {\left( {rxdze001} \geq 0 \land {rxdze001} \leq {1 \times 10^{- 6}} \right)\{} \\
 & {{rxdze001} = {1 \times 10^{- 6}}} \\
\} & \\
{if} & {\left( {rxdze001} \geq - {1 \times 10^{- 6}} \land {rxdze001} < 0 \right)\{} \\
 & {{rxdze001} = - {1 \times 10^{- 6}}} \\
\} & \\
{rxe\_ pd} & {= 1 - \frac{{emax} \times {rxe\_ dcp}}{rxdze001}} \\
{rxe\_ kin} & {= {e0} \times {kout}} \\
{rxe\_ cp} & {= \frac{CENTER}{v}} \\
{rx\_ pf1} & {= {rxe\_ cp}} \\
{rx\_ pf2} & {= {EFFECT}} \\
{rx\_ ip1} & {= {rx\_ pf1}} \\
{rx\_ p1} & {= {rx\_ ip1}} \\
{w1} & {= sqrt\left( (pkadd.err)^{2} + (rx\_ pf1)^{2} \times (prop.err)^{2} \right)} \\
{if} & {\left( {w1} \equiv 0 \right){w1} = 1} \\
{rx\_ ip2} & {= {rx\_ pf2}} \\
{rx\_ p2} & {= {rx\_ ip2}} \\
{w2} & {= sqrt\left( (pdadd.err)^{2} \right)} \\
{if} & {\left( {w2} \equiv 0 \right){w2} = 1} \\
{ipred} & {= {rx\_ ip1}} \\
w & {= {w1}} \\
{if} & {\left( {nmdvid} \equiv 2 \right)\{} \\
 & {{ipred} = {rx\_ ip2}} \\
 & {w = {w2}} \\
\} & \\
y & {= {ipred} + w \times {eps1}}
\end{aligned}$$

## Step 2: Convert `rxode2` model to model with endpoints/residuals specified like `nlmixr2`

This example has rounding errors and isn’t a fully qualified `nlmixr2`
model (even though it was generated from `nlmixr2`).

We can use the model and create an equivalent model with
[`as.nonmem2rx()`](../reference/as.nonmem2rx.md)

``` r
mod2 <- function() {
  ini({
    tktr <- 6.24053043162953e-07
    label("1 - tktr")
    tka <- -3.00642760553675e-06
    label("2 - tka")
    tcl <- -2.00405074386117
    label("3 - tcl")
    tv <- 2.05188410700476
    label("4 - tv")
    prop.err <- c(0, 0.0985804613565218)
    label("5 - prop.err")
    pkadd.err <- c(0, 0.511625249037084)
    label("6 - pkadd.err")
    temax <- 6.4184983102259
    label("7 - temax")
    tec50 <- 0.140763261319656
    label("8 - tec50")
    tkout <- -2.9534704318737
    label("9 - tkout")
    te0 <- 4.57045413136592
    label("10 - te0")
    pdadd.err <- c(0, 3.71714384851537)
    label("11 - pdadd.err")
    eta.ktr ~ 0.558129815059436
    eta.ka ~ 0.558402321309217
    eta.cl ~ 0.0785849119252598
    eta.v ~ 0.0508226905750953
    eta.emax ~ 5e-05
    eta.ec50 ~ 0.18426809257979
    eta.kout ~ 0.0083631531443303
    eta.e0 ~ 0.00274561514766752
  })
  model({
    cmt(DEPOT)
    cmt(GUT)
    cmt(CENTER)
    cmt(EFFECT)
    ktr <- exp(tktr + eta.ktr)
    ka <- exp(tka   + eta.ka)
    cl <- exp(tcl   + eta.cl)
    v <- exp(tv     + eta.v)
    emax <- expit(temax + eta.emax) 
    ec50 <- exp(tec50 + eta.ec50)
    kout <- exp(tkout + eta.kout)
    e0 <- exp(te0 + eta.e0)
    EFFECT(0) <- e0
    dcp <- CENTER/v
    pd <- 1 - emax * dcp/(ec50 + dcp)
    kin <- e0 * kout
    d/dt(DEPOT) <- -ktr * DEPOT
    d/dt(GUT) <- ktr * DEPOT - ka * GUT
    d/dt(CENTER) <- ka * GUT - cl/v * CENTER
    d/dt(EFFECT) <- kin * pd - kout * EFFECT
    eff <- EFFECT
    dcp ~ add(pkadd.err)+prop(prop.err)
    eff ~ add(pdadd.err)
  })
}
```

In the model above, the following modifications were made:

- The code for protecting for rounding errors was removed

- Endpoints/residual specifications were added

- Duplicate code in NONMEM’s `$ERROR` block was removed from imported
  model

- All the `rx` and `nlmixr` prefixed items were removed from the model.
  It is possible that not removing these variables can cause`nlmixr2`
  conversion to fail. It is best practice to remove them completely.

Also, it is good practice to make sure the model parses correctly before
trying to validate/convert the model. If you find that your model
doesn’t parse correctly it definitely won’t validate (and the error may
not be as easy to track-down).

The first step is to validate if the translation is correct. This is
done below:

``` r
new <- as.nonmem2rx(mod, mod2)
#> ℹ parameter labels from comments are typically ignored in non-interactive mode
#> ℹ Need to run with the source intact to parse comments
#> ℹ copy 'dfSub' to nonmem2rx model
#> ℹ copy 'dfObs' to nonmem2rx model
#> ℹ merging 'dvid' with nlmixr2 'cmt' definition
#> ℹ solving ipred problem
#> ℹ done
#> ℹ solving pred problem
#> ℹ done
print(new)
#>  ── rxode2-based free-form 4-cmt ODE model ────────────────────────────────────── 
#>  ── Initalization: ──  
#> Fixed Effects ($theta): 
#>          tktr           tka           tcl            tv      prop.err 
#>  6.240530e-07 -3.006428e-06 -2.004051e+00  2.051884e+00  9.858046e-02 
#>     pkadd.err         temax         tec50         tkout           te0 
#>  5.116252e-01  6.418498e+00  1.407633e-01 -2.953470e+00  4.570454e+00 
#>     pdadd.err 
#>  3.717144e+00 
#> 
#> Omega ($omega): 
#>            eta.ktr    eta.ka     eta.cl      eta.v eta.emax  eta.ec50
#> eta.ktr  0.5581298 0.0000000 0.00000000 0.00000000    0e+00 0.0000000
#> eta.ka   0.0000000 0.5584023 0.00000000 0.00000000    0e+00 0.0000000
#> eta.cl   0.0000000 0.0000000 0.07858491 0.00000000    0e+00 0.0000000
#> eta.v    0.0000000 0.0000000 0.00000000 0.05082269    0e+00 0.0000000
#> eta.emax 0.0000000 0.0000000 0.00000000 0.00000000    5e-05 0.0000000
#> eta.ec50 0.0000000 0.0000000 0.00000000 0.00000000    0e+00 0.1842681
#> eta.kout 0.0000000 0.0000000 0.00000000 0.00000000    0e+00 0.0000000
#> eta.e0   0.0000000 0.0000000 0.00000000 0.00000000    0e+00 0.0000000
#>             eta.kout      eta.e0
#> eta.ktr  0.000000000 0.000000000
#> eta.ka   0.000000000 0.000000000
#> eta.cl   0.000000000 0.000000000
#> eta.v    0.000000000 0.000000000
#> eta.emax 0.000000000 0.000000000
#> eta.ec50 0.000000000 0.000000000
#> eta.kout 0.008363153 0.000000000
#> eta.e0   0.000000000 0.002745615
#> 
#> States ($state or $stateDf): 
#>   Compartment Number Compartment Name
#> 1                  1            DEPOT
#> 2                  2              GUT
#> 3                  3           CENTER
#> 4                  4           EFFECT
#>  ── Multiple Endpoint Model ($multipleEndpoint): ──  
#>   variable                cmt                dvid*
#> 1  dcp ~ … cmt='dcp' or cmt=5 dvid='dcp' or dvid=1
#> 2  eff ~ … cmt='eff' or cmt=6 dvid='eff' or dvid=2
#>   * If dvids are outside this range, all dvids are re-numered sequentially, ie 1,7, 10 becomes 1,2,3 etc
#> 
#>  ── μ-referencing ($muRefTable): ──  
#>   theta      eta level
#> 1  tktr  eta.ktr    id
#> 2   tka   eta.ka    id
#> 3   tcl   eta.cl    id
#> 4    tv    eta.v    id
#> 5 temax eta.emax    id
#> 6 tec50 eta.ec50    id
#> 7 tkout eta.kout    id
#> 8   te0   eta.e0    id
#> 
#>  ── Model (Normalized Syntax): ── 
#> function() {
#>     description <- c("translated from babelmixr2", "; comments show mu referenced model in ui$getSplitMuModel")
#>     dfObs <- 483
#>     dfSub <- 32
#>     validation <- c("IPRED relative difference compared to Nonmem IPRED: 0%; 95% percentile: (0%,0%); rtol=6.13e-06", 
#>         "IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (3.12e-06, 0.000497); atol=6.17e-05", 
#>         "PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=6.18e-06", 
#>         "PRED absolute difference compared to Nonmem PRED: 95% percentile: (3.79e-07,0.00313) atol=6.18e-06")
#>     ini({
#>         tktr <- 6.24053043162953e-07
#>         label("1 - tktr")
#>         tka <- -3.00642760553675e-06
#>         label("2 - tka")
#>         tcl <- -2.00405074386117
#>         label("3 - tcl")
#>         tv <- 2.05188410700476
#>         label("4 - tv")
#>         prop.err <- c(0, 0.0985804613565218)
#>         label("5 - prop.err")
#>         pkadd.err <- c(0, 0.511625249037084)
#>         label("6 - pkadd.err")
#>         temax <- 6.4184983102259
#>         label("7 - temax")
#>         tec50 <- 0.140763261319656
#>         label("8 - tec50")
#>         tkout <- -2.9534704318737
#>         label("9 - tkout")
#>         te0 <- 4.57045413136592
#>         label("10 - te0")
#>         pdadd.err <- c(0, 3.71714384851537)
#>         label("11 - pdadd.err")
#>         eta.ktr ~ 0.558129815059436
#>         eta.ka ~ 0.558402321309217
#>         eta.cl ~ 0.0785849119252598
#>         eta.v ~ 0.0508226905750953
#>         eta.emax ~ 5e-05
#>         eta.ec50 ~ 0.18426809257979
#>         eta.kout ~ 0.0083631531443303
#>         eta.e0 ~ 0.00274561514766752
#>     })
#>     model({
#>         cmt(DEPOT)
#>         cmt(GUT)
#>         cmt(CENTER)
#>         cmt(EFFECT)
#>         ktr <- exp(tktr + eta.ktr)
#>         ka <- exp(tka + eta.ka)
#>         cl <- exp(tcl + eta.cl)
#>         v <- exp(tv + eta.v)
#>         emax <- expit(temax + eta.emax, 0, 1)
#>         ec50 <- exp(tec50 + eta.ec50)
#>         kout <- exp(tkout + eta.kout)
#>         e0 <- exp(te0 + eta.e0)
#>         EFFECT(0) <- e0
#>         dcp <- CENTER/v
#>         pd <- 1 - emax * dcp/(ec50 + dcp)
#>         kin <- e0 * kout
#>         d/dt(DEPOT) <- -ktr * DEPOT
#>         d/dt(GUT) <- ktr * DEPOT - ka * GUT
#>         d/dt(CENTER) <- ka * GUT - cl/v * CENTER
#>         d/dt(EFFECT) <- kin * pd - kout * EFFECT
#>         eff <- EFFECT
#>         dcp ~ add(pkadd.err) + prop(prop.err)
#>         eff ~ add(pdadd.err)
#>     })
#> }
#>  ── nonmem2rx extra properties: ──  
#> other properties include: $nonmemData, $etaData, $thetaMat
#> captured NONMEM table outputs: $predData, $ipredData
#> NONMEM/rxode2 comparison data: $iwresCompare, $predCompare, $ipredCompare
#> NONMEM/rxode2 composite comparison: $predAtol, $predRtol, $ipredAtol, $ipredRtol, $iwresAtol, $iwresRtol
```

## Step 3: Convert new model to nlmixr2 fit with `as.nlmixr2()`

Once the translation is complete, and it is validated, you can convert
the fit to a full nlmixr2 fit object.

``` r
fit <- as.nlmixr2(new)
#> → loading into symengine environment...
#> → pruning branches (`if`/`else`) of full model...
#> ✔ done
#> → finding duplicate expressions in EBE model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → optimizing duplicate expressions in EBE model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → compiling EBE model...
#> ✔ done
#> rxode2 5.0.2 using 2 threads (see ?getRxThreads)
#>   no cache: create with `rxCreateCache()`
#> → Calculating residuals/tables
#> ✔ done

# Once it is loaded remove the directory (we don't need the files any
# more for this example)
#
# In this example, we don't remove, but note where it can be removed
#
# unlink("pk.turnover.emax3-nonmem", recursive = TRUE)
```

Note this object **does not** rerun an estimation, but rather imports
everything it knows about the fit to rerun the `nlmixr2` table steps to
calculate the things you need.

## Step 4: Explore the data/fit as if it came from `nlmixr2`

With this information you can see about the properties of the model:

``` r
print(fit)
#> ── nlmixr² nonmem2rx reading NONMEM ver 7.4.3 ──
#> 
#>               OBJF     AIC      BIC Log-likelihood
#> nonmem2rx 439.2156 1364.91 1444.331      -663.4551
#> 
#> ── Time (sec $time): ──
#> 
#>           setup table compress NONMEM as.nlmixr2
#> elapsed 0.01976 0.081    0.001 320.27      3.167
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>                Parameter      Est. Back-transformed BSV(CV% or SD) Shrink(SD)%
#> tktr            1 - tktr  6.24e-07                1           86.5      59.8% 
#> tka              2 - tka -3.01e-06                1           86.5      59.8% 
#> tcl              3 - tcl        -2            0.135           28.6      1.34% 
#> tv                4 - tv      2.05             7.78           22.8      6.44% 
#> prop.err    5 - prop.err    0.0986           0.0986                           
#> pkadd.err  6 - pkadd.err     0.512            0.512                           
#> temax          7 - temax      6.42            0.998        0.00707      100.% 
#> tec50          8 - tec50     0.141             1.15           45.0      6.06% 
#> tkout          9 - tkout     -2.95           0.0522           9.16      32.4% 
#> te0             10 - te0      4.57             96.6           5.24      18.1% 
#> pdadd.err 11 - pdadd.err      3.72             3.72                           
#>  
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Censoring ($censInformation): No censoring
#>   Minimization message ($message):  
#>     
#> 
#>  WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
#> 
#>  (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
#> 
#>     
#> 0MINIMIZATION TERMINATED
#>  DUE TO ROUNDING ERRORS (ERROR=134)
#>  NO. OF FUNCTION EVALUATIONS USED:     1088
#>  NO. OF SIG. DIGITS UNREPORTABLE
#> 0PARAMETER ESTIMATE IS NEAR ITS BOUNDARY
#> 
#>     IPRED relative difference compared to Nonmem IPRED: 0%; 95% percentile: (0%,0%); rtol=5.09e-06
#>     PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=5.29e-06
#>     IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (2.2e-06, 0.000454); atol=3.03e-05
#>     PRED absolute difference compared to Nonmem PRED: 95% percentile: (4.72e-07,0.00361); atol=5.29e-06
#>     there are solving errors during optimization (see '$prderr')
#>     nonmem2rx model file: 'pk.turnover.emax3-nonmem/pk.turnover.emax3.nmctl' 
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 483 × 35
#>   ID     TIME CMT      DV  PRED   RES IPRED   IRES  IWRES eta.ktr eta.ka eta.cl
#>   <fct> <dbl> <fct> <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>   <dbl>  <dbl>  <dbl>
#> 1 1       0.5 dcp     0    1.16 -1.16 0.444 -0.444 -0.864  -0.506 -0.506  0.699
#> 2 1       1   dcp     1.9  3.37 -1.47 1.45   0.446  0.840  -0.506 -0.506  0.699
#> 3 1       2   dcp     3.3  7.51 -4.21 3.96  -0.660 -1.03   -0.506 -0.506  0.699
#> # ℹ 480 more rows
#> # ℹ 23 more variables: eta.v <dbl>, eta.emax <dbl>, eta.ec50 <dbl>,
#> #   eta.kout <dbl>, eta.e0 <dbl>, dcp <dbl>, eff <dbl>, DEPOT <dbl>, GUT <dbl>,
#> #   CENTER <dbl>, EFFECT <dbl>, ktr <dbl>, ka <dbl>, cl <dbl>, v <dbl>,
#> #   emax <dbl>, ec50 <dbl>, kout <dbl>, e0 <dbl>, pd <dbl>, kin <dbl>,
#> #   tad <dbl>, dosenum <dbl>
```

In this model you can see:

- High shrinkage in `temax`, `ktr`, `ka` and moderate shrinkage in
  `kout`

By removing these parameters, you could possibly get a successful NONMEM
run.

If you want, you can use model piping to remove these parameters as
follows:

``` r
mod3 <-  fit %>%
  model(ktr <- exp(tktr)) %>%
  model(ka <- exp(tka)) %>%
  model(emax <- expit(temax)) %>%
  model(kout <- exp(tkout))
#> ! remove between subject variability `eta.ktr`
#> ! remove between subject variability `eta.ka`
#> ! remove between subject variability `eta.emax`
#> ! remove between subject variability `eta.kout`

mod3
```

$$\begin{aligned}
{cmt(DEPOT)} & \\
{cmt(GUT)} & \\
{cmt(CENTER)} & \\
{cmt(EFFECT)} & \\
{ktr} & {= \exp(tktr)} \\
{ka} & {= \exp(tka)} \\
{cl} & {= \exp\left( {tcl} + {eta.cl} \right)} \\
v & {= \exp\left( {tv} + {eta.v} \right)} \\
{emax} & {= expit\left( {temax},0,1 \right)} \\
{ec50} & {= \exp\left( {tec50} + {eta.ec50} \right)} \\
{kout} & {= \exp(tkout)} \\
{e0} & {= \exp\left( {te0} + {eta.e0} \right)} \\
{EFFECT(0)} & {= {e0}} \\
{dcp} & {= \frac{CENTER}{v}} \\
{pd} & {= 1 - \frac{{emax} \times {dcp}}{\left( {ec50} + {dcp} \right)}} \\
{kin} & {= {e0} \times {kout}} \\
\frac{d\ DEPOT}{dt} & {= - {ktr} \times {DEPOT}} \\
\frac{d\ GUT}{dt} & {= {ktr} \times {DEPOT} - {ka} \times {GUT}} \\
\frac{d\ CENTER}{dt} & {= {ka} \times {GUT} - \frac{cl}{v} \times {CENTER}} \\
\frac{d\ EFFECT}{dt} & {= {kin} \times {pd} - {kout} \times {EFFECT}} \\
{eff} & {= {EFFECT}} \\
{dcp} & {\sim add(pkadd.err) + prop(prop.err)} \\
{eff} & {\sim add(pdadd.err)}
\end{aligned}$$

Since you have `babelmixr2` you could use `babelmixr2` to run the model
for you in NONMEM (if you have it setup to run NONMEM), or even run the
model from `nlmixr2` itself. In this example we will choose to use
`nlmixr2` (since the `babelmixr2` example runs NONMEM and shows a
reduction in shrinkage)

``` r
fit2 <- nlmixr(mod3, new$nonmemData, "focei", foceiControl(print=0))
#> → loading into symengine environment...
#> → pruning branches (`if`/`else`) of full model...
#> ✔ done
#> → calculate jacobian
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → calculate sensitivities
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → calculate ∂(f)/∂(η)
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → calculate ∂(R²)/∂(η)
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → finding duplicate expressions in inner model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → optimizing duplicate expressions in inner model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → finding duplicate expressions in EBE model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → optimizing duplicate expressions in EBE model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → compiling inner model...
#> ✔ done
#> → finding duplicate expressions in FD model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → optimizing duplicate expressions in FD model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → compiling EBE model...
#> ✔ done
#> → compiling events FD model...
#> ✔ done
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:29 
#> done
#> → Calculating residuals/tables
#> ✔ done
#> Warning in FUN(X[[i]], ...): gradient problems with initial estimate and
#> covariance; see $scaleInfo
#> Warning in FUN(X[[i]], ...): since sandwich matrix is corrected, you may
#> compare to $covR or $covS if you wish
#> Warning in FUN(X[[i]], ...): S matrix non-positive definite but corrected by S
#> = sqrtm(S%*%S)
#> Warning in FUN(X[[i]], ...): R matrix non-positive definite but corrected by R
#> = sqrtm(R%*%R)
#> Warning in FUN(X[[i]], ...): ETAs were reset to zero during optimization; (Can
#> control by foceiControl(resetEtaP=.))
#> Warning in FUN(X[[i]], ...): initial ETAs were nudged; (can control by
#> foceiControl(etaNudge=., etaNudge2=))

fit2
```

$$\begin{aligned}
{cmt(DEPOT)} & \\
{cmt(GUT)} & \\
{cmt(CENTER)} & \\
{cmt(EFFECT)} & \\
{ktr} & {= \exp(tktr)} \\
{ka} & {= \exp(tka)} \\
{cl} & {= \exp\left( {tcl} + {eta.cl} \right)} \\
v & {= \exp\left( {tv} + {eta.v} \right)} \\
{emax} & {= expit\left( {temax},0,1 \right)} \\
{ec50} & {= \exp\left( {tec50} + {eta.ec50} \right)} \\
{kout} & {= \exp(tkout)} \\
{e0} & {= \exp\left( {te0} + {eta.e0} \right)} \\
{EFFECT(0)} & {= {e0}} \\
{dcp} & {= \frac{CENTER}{v}} \\
{pd} & {= 1 - \frac{{emax} \times {dcp}}{\left( {ec50} + {dcp} \right)}} \\
{kin} & {= {e0} \times {kout}} \\
\frac{d\ DEPOT}{dt} & {= - {ktr} \times {DEPOT}} \\
\frac{d\ GUT}{dt} & {= {ktr} \times {DEPOT} - {ka} \times {GUT}} \\
\frac{d\ CENTER}{dt} & {= {ka} \times {GUT} - \frac{cl}{v} \times {CENTER}} \\
\frac{d\ EFFECT}{dt} & {= {kin} \times {pd} - {kout} \times {EFFECT}} \\
{eff} & {= {EFFECT}} \\
{dcp} & {\sim add(pkadd.err) + prop(prop.err)} \\
{eff} & {\sim add(pdadd.err)}
\end{aligned}$$

With these modifications the shrinkage is also reduced (just like in the
NONMEM case)

## Step 5: Get the covariance of the model

Another thing that can be helpful when the fit has been imported into a
`nlmixr2` fit is to get the variance/covariance matrix. This can be
especially helpful to diagnose things to help simplify your model

``` r
getVarCov(fit)
#> → loading into symengine environment...
#> → pruning branches (`if`/`else`) of full model...
#> ✔ done
#> → calculate jacobian
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → calculate sensitivities
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → calculate ∂(f)/∂(η)
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → finding duplicate expressions in inner model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → optimizing duplicate expressions in inner model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → finding duplicate expressions in EBE model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → optimizing duplicate expressions in EBE model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → compiling inner model...
#> ✔ done
#> → finding duplicate expressions in FD model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → optimizing duplicate expressions in FD model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → compiling EBE model...
#> ✔ done
#> → compiling events FD model...
#> ✔ done
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:04
#> Warning in foceiFitCpp_(.ret): using R matrix to calculate covariance, can
#> check sandwich or S matrix with $covRS and $covS
#> Warning in foceiFitCpp_(.ret): gradient problems with covariance; see
#> $scaleInfo
#> Updated original fit object fit
#>                tktr           tka           tcl           tv         temax
#> tktr   1.833921e-02 -1.528029e-02 -2.352104e-05 3.170757e-04  0.0014879140
#> tka   -1.528029e-02  1.834268e-02 -2.191127e-05 3.211423e-04  0.0011542368
#> tcl   -2.352104e-05 -2.191127e-05  2.480828e-04 1.178238e-05 -0.0008614756
#> tv     3.170757e-04  3.211423e-04  1.178238e-05 3.183932e-04  0.0011487138
#> temax  1.487914e-03  1.154237e-03 -8.614756e-04 1.148714e-03  7.5954703694
#> tec50  1.373244e-04  1.333030e-04 -3.591067e-04 1.236531e-04  0.0486313316
#> tkout  9.569355e-05  1.077798e-04 -9.762544e-05 1.190108e-04 -0.0189123057
#> te0    1.239438e-05  1.453620e-05 -9.820662e-06 1.249440e-05 -0.0004482796
#>               tec50         tkout           te0
#> tktr   0.0001373244  9.569355e-05  1.239438e-05
#> tka    0.0001333030  1.077798e-04  1.453620e-05
#> tcl   -0.0003591067 -9.762544e-05 -9.820662e-06
#> tv     0.0001236531  1.190108e-04  1.249440e-05
#> temax  0.0486313316 -1.891231e-02 -4.482796e-04
#> tec50  0.0018414013  1.543521e-04 -1.362741e-04
#> tkout  0.0001543521  6.316783e-04  5.252370e-05
#> te0   -0.0001362741  5.252370e-05  8.871375e-05
fit
```

$$\begin{aligned}
{cmt(DEPOT)} & \\
{cmt(GUT)} & \\
{cmt(CENTER)} & \\
{cmt(EFFECT)} & \\
{ktr} & {= \exp\left( {tktr} + {eta.ktr} \right)} \\
{ka} & {= \exp\left( {tka} + {eta.ka} \right)} \\
{cl} & {= \exp\left( {tcl} + {eta.cl} \right)} \\
v & {= \exp\left( {tv} + {eta.v} \right)} \\
{emax} & {= expit\left( {temax} + {eta.emax},0,1 \right)} \\
{ec50} & {= \exp\left( {tec50} + {eta.ec50} \right)} \\
{kout} & {= \exp\left( {tkout} + {eta.kout} \right)} \\
{e0} & {= \exp\left( {te0} + {eta.e0} \right)} \\
{EFFECT(0)} & {= {e0}} \\
{dcp} & {= \frac{CENTER}{v}} \\
{pd} & {= 1 - \frac{{emax} \times {dcp}}{\left( {ec50} + {dcp} \right)}} \\
{kin} & {= {e0} \times {kout}} \\
\frac{d\ DEPOT}{dt} & {= - {ktr} \times {DEPOT}} \\
\frac{d\ GUT}{dt} & {= {ktr} \times {DEPOT} - {ka} \times {GUT}} \\
\frac{d\ CENTER}{dt} & {= {ka} \times {GUT} - \frac{cl}{v} \times {CENTER}} \\
\frac{d\ EFFECT}{dt} & {= {kin} \times {pd} - {kout} \times {EFFECT}} \\
{eff} & {= {EFFECT}} \\
{dcp} & {\sim add(pkadd.err) + prop(prop.err)} \\
{eff} & {\sim add(pdadd.err)}
\end{aligned}$$

Note this covariance step is not 100% successful since it is not `r, s`.
However, it can give some insights on which parameters are estimated
well. In this case you can see that the `emax` parameter is more poorly
estimated than other parameters, which means fixing the parameter or
reducing other parameters may help your estimate progress in `NONMEM`.
