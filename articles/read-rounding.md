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
#> ℹ ignoring lines that begin with a letter (IGNORE=@)
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
#>  ── Model (Normalized Syntax): ── 
#> function() {
#>     description <- c("translated from babelmixr2", "; comments show mu referenced model in ui$getSplitMuModel")
#>     dfObs <- 483
#>     dfSub <- 32
#>     sigma <- lotri({
#>         eps1 ~ 1
#>     })
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
#>         mu_1 <- tktr
#>         mu_2 <- tka
#>         mu_3 <- tcl
#>         mu_4 <- tv
#>         mu_5 <- temax
#>         mu_6 <- tec50
#>         mu_7 <- tkout
#>         mu_8 <- te0
#>         ktr <- exp(mu_1 + eta.ktr)
#>         ka <- exp(mu_2 + eta.ka)
#>         cl <- exp(mu_3 + eta.cl)
#>         v <- exp(mu_4 + eta.v)
#>         emax <- ((1) - (0)) * (1/(1 + exp(-(mu_5 + eta.emax)))) + 
#>             (0)
#>         ec50 <- exp(mu_6 + eta.ec50)
#>         kout <- exp(mu_7 + eta.kout)
#>         e0 <- exp(mu_8 + eta.e0)
#>         rxini.rxddta4. <- e0
#>         EFFECT(0) <- rxini.rxddta4.
#>         dcp <- CENTER/v
#>         rxdz001 <- (ec50 + dcp)
#>         if (rxdz001 >= 0 && rxdz001 <= 1e-06) {
#>             rxdz001 <- 1e-06
#>         }
#>         if (rxdz001 >= -1e-06 && rxdz001 < 0) {
#>             rxdz001 <- -1e-06
#>         }
#>         pd <- 1 - emax * dcp/rxdz001
#>         kin <- e0 * kout
#>         d/dt(DEPOT) <- -ktr * DEPOT
#>         d/dt(GUT) <- ktr * DEPOT - ka * GUT
#>         d/dt(CENTER) <- ka * GUT - cl/v * CENTER
#>         d/dt(EFFECT) <- kin * pd - kout * EFFECT
#>         cp <- CENTER/v
#>         f <- DEPOT
#>         rxe_dcp <- CENTER/v
#>         rxdze001 <- (ec50 + rxe_dcp)
#>         if (rxdze001 >= 0 && rxdze001 <= 1e-06) {
#>             rxdze001 <- 1e-06
#>         }
#>         if (rxdze001 >= -1e-06 && rxdze001 < 0) {
#>             rxdze001 <- -1e-06
#>         }
#>         rxe_pd <- 1 - emax * rxe_dcp/rxdze001
#>         rxe_kin <- e0 * kout
#>         rxe_cp <- CENTER/v
#>         rx_pf1 <- rxe_cp
#>         rx_pf2 <- EFFECT
#>         rx_ip1 <- rx_pf1
#>         rx_p1 <- rx_ip1
#>         w1 <- sqrt((pkadd.err)^2 + (rx_pf1)^2 * (prop.err)^2)
#>         if (w1 == 0) 
#>             w1 <- 1
#>         rx_ip2 <- rx_pf2
#>         rx_p2 <- rx_ip2
#>         w2 <- sqrt((pdadd.err)^2)
#>         if (w2 == 0) 
#>             w2 <- 1
#>         ipred <- rx_ip1
#>         w <- w1
#>         if (nmdvid == 2) {
#>             ipred <- rx_ip2
#>             w <- w2
#>         }
#>         rx.IPRED.add ~ sqrt((pkadd.err)^2 + (rx_pf1)^2 * (prop.err)^2)
#>         ipred ~ add(rx.IPRED.add)
#>     })
#> }
#>  ── nonmem2rx translation notes ($notes): ──  
#>    • some etas defaulted to non-mu referenced, possible parsing error: eta.emax as a work-around try putting the mu-referenced expression on a simple line 
#>    • some etas defaulted to non-mu referenced, possible parsing error: eta5 as a work-around try putting the mu-referenced expression on a simple line 
#>    • some NONMEM input has tied times; they are offset by a small offset 
#>    • 'dvid' variable has special meaning in rxode2, renamed to 'nmdvid', rename/copy in your data too 
#>    • $MODEL NCOMPARTMENTS/NEQUILIBRIUM/NPARAMETERS statement(s) ignored 
#>  ── nonmem2rx extra properties: ──  
#> other properties include: $nonmemData, $etaData
#> captured NONMEM table outputs: $predData, $ipredData
#> NONMEM/rxode2 comparison data: $iwresCompare, $predCompare, $ipredCompare
#> NONMEM/rxode2 composite comparison: $predAtol, $predRtol, $ipredAtol, $ipredRtol, $iwresAtol, $iwresRtol
```

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
#> → compiling EBE model...
#> ✔ done
#> rxode2 5.1.8 using 2 threads (see ?getRxThreads)
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
#>             setup postprocess table compress NONMEM as.nlmixr2
#> elapsed 0.7185081       0.027 0.061    0.001 320.27      1.314
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>                Parameter     Est. SE %RSE Back-transformed(95%CI)
#> tktr            1 - tktr  6.24e-7                            1.00
#> tka              2 - tka -3.01e-6                            1.00
#> tcl              3 - tcl    -2.00                           0.135
#> tv                4 - tv     2.05                            7.78
#> prop.err    5 - prop.err   0.0986                          0.0986
#> pkadd.err  6 - pkadd.err    0.512                           0.512
#> temax          7 - temax     6.42                           0.998
#> tec50          8 - tec50    0.141                            1.15
#> tkout          9 - tkout    -2.95                          0.0522
#> te0             10 - te0     4.57                            96.6
#> pdadd.err 11 - pdadd.err     3.72                            3.72
#>           BSV(CV% or SD) Shrink(SD)%
#> tktr                86.5       59.8 
#> tka                 86.5       59.8 
#> tcl                 28.6       1.34 
#> tv                  22.8       6.44 
#> prop.err                            
#> pkadd.err                           
#> temax            0.00707        100 
#> tec50               45.0       6.06 
#> tkout               9.16       32.4 
#> te0                 5.24       18.1 
#> pdadd.err                           
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
#>              eta.cl      eta.v  eta.ec50      eta.e0
#> eta.cl   0.07858491 0.00000000 0.0000000 0.000000000
#> eta.v    0.00000000 0.05082269 0.0000000 0.000000000
#> eta.ec50 0.00000000 0.00000000 0.1842681 0.000000000
#> eta.e0   0.00000000 0.00000000 0.0000000 0.002745615
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
#> 1   tcl   eta.cl    id
#> 2    tv    eta.v    id
#> 3 tec50 eta.ec50    id
#> 4   te0   eta.e0    id
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
#>         eta.cl ~ 0.0785849119252598
#>         eta.v ~ 0.0508226905750953
#>         eta.ec50 ~ 0.18426809257979
#>         eta.e0 ~ 0.00274561514766752
#>     })
#>     model({
#>         cmt(DEPOT)
#>         cmt(GUT)
#>         cmt(CENTER)
#>         cmt(EFFECT)
#>         ktr <- exp(tktr)
#>         ka <- exp(tka)
#>         cl <- exp(tcl + eta.cl)
#>         v <- exp(tv + eta.v)
#>         emax <- expit(temax, 0, 1)
#>         ec50 <- exp(tec50 + eta.ec50)
#>         kout <- exp(tkout)
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
```

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
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → calculate sensitivities
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → calculate ∂(f)/∂(η)
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → calculate ∂(R²)/∂(η)
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → finding duplicate expressions in inner model...
#> → finding duplicate expressions in EBE model...
#> → compiling inner model...
#> ✔ done
#> → finding duplicate expressions in FD model...
#> → compiling EBE model...
#> ✔ done
#> → compiling events FD model...
#> ✔ done
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:45 
#> done
#> → Calculating residuals/tables
#> ✔ done

fit2
#> ── nlmixr² FOCEi (outer: bobyqa) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 1423.321 2341.016 2403.716      -1155.508      3430015107        15328411
#> 
#> ── Time (sec fit2$time): ──
#> 
#>            setup optimize covariance preprocess postprocess table compress
#> elapsed 2.900984   3.1442   22.89893      0.046       0.041 0.091    0.002
#>             other
#> elapsed 0.1158866
#> 
#> ── Population Parameters (fit2$parFixed or fit2$parFixedDf): ──
#> 
#>                Parameter   Est.     SE  %RSE  Back-transformed(95%CI) BSV(CV%)
#> tktr            1 - tktr 0.0551   47.2 85600 1.06 (7.27e-41, 1.54e40)         
#> tka              2 - tka 0.0618   47.3 76600 1.06 (5.62e-41, 2.01e40)         
#> tcl              3 - tcl  -2.00  0.112  5.61     0.136 (0.109, 0.169)     27.6
#> tv                4 - tv   2.05  0.113  5.49        7.78 (6.24, 9.71)     23.1
#> prop.err    5 - prop.err  0.157 0.0105  6.71     0.157 (0.137, 0.178)         
#> pkadd.err  6 - pkadd.err  0.591  0.115  19.5     0.591 (0.366, 0.817)         
#> temax          7 - temax   6.04   15.0   248   0.998 (7.43e-11, 1.00)         
#> tec50          8 - tec50  0.109  0.163   150       1.12 (0.810, 1.54)     41.9
#> tkout          9 - tkout  -2.96 0.0488  1.65  0.0517 (0.0470, 0.0569)         
#> te0             10 - te0   4.57 0.0267 0.584         96.7 (91.8, 102)     5.17
#> pdadd.err 11 - pdadd.err   3.82  0.258  6.76        3.82 (3.31, 4.33)         
#>           Shrink(SD)%
#> tktr                 
#> tka                  
#> tcl             2.17 
#> tv              8.69 
#> prop.err             
#> pkadd.err            
#> temax                
#> tec50           5.82 
#> tkout                
#> te0             18.5 
#> pdadd.err            
#>  
#>   Covariance Type (fit2$covMethod): s (full)
#>     other calculated covs (setCov()): r; s; r,s
#>   Some strong fixed parameter correlations exist (fit2$cor) :
#>                  cor:tka,tktr              cor:tcl,tktr               cor:tv,tktr 
#>                    -1.00                    -0.686                     0.639  
#>         cor:prop.err,tktr        cor:pkadd.err,tktr            cor:temax,tktr 
#>                    0.341                    0.0247                    0.00719   
#>            cor:tec50,tktr            cor:tkout,tktr              cor:te0,tktr 
#>                   0.0424                      0.280                      0.670  
#>        cor:pdadd.err,tktr        cor:om.eta.cl,tktr         cor:om.eta.v,tktr 
#>                    0.135                      0.562                   -0.0544   
#>      cor:om.eta.ec50,tktr        cor:om.eta.e0,tktr               cor:tcl,tka 
#>                   -0.137                      0.224                      0.686  
#>                cor:tv,tka          cor:prop.err,tka         cor:pkadd.err,tka 
#>                   -0.638                    -0.341                   -0.0242   
#>             cor:temax,tka             cor:tec50,tka             cor:tkout,tka 
#>                 -0.00756                    -0.0426                     -0.279   
#>               cor:te0,tka         cor:pdadd.err,tka         cor:om.eta.cl,tka 
#>                   -0.670                    -0.135                     -0.561  
#>          cor:om.eta.v,tka       cor:om.eta.ec50,tka         cor:om.eta.e0,tka 
#>                   0.0544                      0.137                     -0.224   
#>                cor:tv,tcl          cor:prop.err,tcl         cor:pkadd.err,tcl 
#>                   -0.807                    -0.129                     -0.233   
#>             cor:temax,tcl             cor:tec50,tcl             cor:tkout,tcl 
#>                   0.0515                     0.0625                     -0.396  
#>               cor:te0,tcl         cor:pdadd.err,tcl         cor:om.eta.cl,tcl 
#>                   -0.591                   -0.0468                     -0.711  
#>          cor:om.eta.v,tcl       cor:om.eta.ec50,tcl         cor:om.eta.e0,tcl 
#>                   0.0742                      0.204                     -0.288   
#>           cor:prop.err,tv          cor:pkadd.err,tv              cor:temax,tv 
#>                   0.0222                      0.393                  0.000459   
#>              cor:tec50,tv              cor:tkout,tv                cor:te0,tv 
#>                    0.123                      0.326                     0.575  
#>          cor:pdadd.err,tv          cor:om.eta.cl,tv           cor:om.eta.v,tv 
#>                  -0.0794                      0.627                   0.00698   
#>        cor:om.eta.ec50,tv          cor:om.eta.e0,tv    cor:pkadd.err,prop.err 
#>                   -0.187                      0.335                    -0.605  
#>        cor:temax,prop.err        cor:tec50,prop.err        cor:tkout,prop.err 
#>                   0.0948                      0.157                    0.00231   
#>          cor:te0,prop.err    cor:pdadd.err,prop.err    cor:om.eta.cl,prop.err 
#>                    0.145                      0.289                      0.138   
#>     cor:om.eta.v,prop.err  cor:om.eta.ec50,prop.err    cor:om.eta.e0,prop.err 
#>                    0.336                    -0.294                     -0.413  
#>       cor:temax,pkadd.err       cor:tec50,pkadd.err       cor:tkout,pkadd.err 
#>                   -0.341                   -0.0903                      0.255   
#>         cor:te0,pkadd.err   cor:pdadd.err,pkadd.err   cor:om.eta.cl,pkadd.err 
#>                    0.132                     -0.336                     0.230   
#>    cor:om.eta.v,pkadd.err cor:om.eta.ec50,pkadd.err   cor:om.eta.e0,pkadd.err 
#>                   -0.146                      0.327                     0.208   
#>           cor:tec50,temax           cor:tkout,temax             cor:te0,temax 
#>                    0.697                    -0.848                   -0.0335   
#>       cor:pdadd.err,temax       cor:om.eta.cl,temax        cor:om.eta.v,temax 
#>                   -0.193                     -0.119                      0.236   
#>     cor:om.eta.ec50,temax       cor:om.eta.e0,temax           cor:tkout,tec50 
#>                   -0.309                    -0.127                     -0.662  
#>             cor:te0,tec50       cor:pdadd.err,tec50       cor:om.eta.cl,tec50 
#>                  -0.0963                     -0.529                    0.0222   
#>        cor:om.eta.v,tec50     cor:om.eta.ec50,tec50       cor:om.eta.e0,tec50 
#>                    0.236                    -0.0364                     -0.208   
#>             cor:te0,tkout       cor:pdadd.err,tkout       cor:om.eta.cl,tkout 
#>                    0.292                      0.214                      0.346  
#>        cor:om.eta.v,tkout     cor:om.eta.ec50,tkout       cor:om.eta.e0,tkout 
#>                   -0.240                     0.0669                      0.252   
#>         cor:pdadd.err,te0         cor:om.eta.cl,te0          cor:om.eta.v,te0 
#>                    0.170                      0.308                   -0.0454   
#>       cor:om.eta.ec50,te0         cor:om.eta.e0,te0   cor:om.eta.cl,pdadd.err 
#>                   -0.194                      0.627                    -0.174   
#>    cor:om.eta.v,pdadd.err cor:om.eta.ec50,pdadd.err   cor:om.eta.e0,pdadd.err 
#>                    0.144                     -0.275                    0.00445   
#>    cor:om.eta.v,om.eta.cl cor:om.eta.ec50,om.eta.cl   cor:om.eta.e0,om.eta.cl 
#>                   -0.315                    0.0886                     0.0481   
#>  cor:om.eta.ec50,om.eta.v    cor:om.eta.e0,om.eta.v cor:om.eta.e0,om.eta.ec50 
#>                   -0.199                     -0.325                  -0.00804   
#>  
#> 
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance (fit2$omega) or correlation (fit2$omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in fit2$shrink 
#>   Information about run found (fit2$runInfo):
#>    • full R matrix non-positive definite; using s (full) 
#>    • since sandwich matrix is corrected, you may compare to $covR or $covS if you wish 
#>    • S matrix non-positive definite but corrected by S = sqrtm(S%*%S) 
#>    • R matrix non-positive definite but corrected by R = sqrtm(R%*%R) 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>   Censoring (fit2$censInformation): No censoring
#>   Minimization message (fit2$message):  
#>     Normal exit from bobyqa 
#> 
#> ── Fit Data (object fit2 is a modified tibble): ──
#> # A tibble: 483 × 33
#>   ID     TIME CMT      DV  PRED   RES  WRES IPRED   IRES IWRES CPRED  CRES CWRES
#>   <fct> <dbl> <fct> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 1       0.5 dcp     0    1.27 -1.27 -1.85  1.01 -1.01  -1.65  1.24 -1.24 -1.90
#> 2 1       1   dcp     1.9  3.65 -1.75 -1.50  2.88 -0.983 -1.32  3.57 -1.67 -1.69
#> 3 1       2   dcp     3.3  7.91 -4.61 -2.05  6.21 -2.91  -2.55  7.73 -4.43 -2.47
#> # ℹ 480 more rows
#> # ℹ 20 more variables: eta.cl <dbl>, eta.v <dbl>, eta.ec50 <dbl>, eta.e0 <dbl>,
#> #   DEPOT <dbl>, GUT <dbl>, CENTER <dbl>, EFFECT <dbl>, ktr <dbl>, ka <dbl>,
#> #   cl <dbl>, v <dbl>, emax <dbl>, ec50 <dbl>, kout <dbl>, e0 <dbl>, pd <dbl>,
#> #   kin <dbl>, tad <dbl>, dosenum <dbl>
```

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
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → calculate sensitivities
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → calculate ∂(f)/∂(η)
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → finding duplicate expressions in inner model...
#> → finding duplicate expressions in EBE model...
#> → compiling inner model...
#> ✔ done
#> → finding duplicate expressions in FD model...
#> → compiling EBE model...
#> ✔ done
#> → compiling events FD model...
#> ✔ done
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:04:29
#> Warning: "r,s" not usable (S not PD); installed "r"
#> Warning: full R matrix non-positive definite; using s (full)
#> Updated original fit object fit
#>                      tktr           tka           tcl            tv
#> tktr         4.237688e+07 -4.237684e+07 -3.592416e+02  2.881724e+02
#> tka         -4.237684e+07  4.237679e+07  3.592188e+02 -2.881371e+02
#> tcl         -3.592416e+02  3.592188e+02  1.920611e-02 -1.836972e-02
#> tv           2.881724e+02 -2.881371e+02 -1.836972e-02  2.399309e-02
#> prop.err     7.171332e+01 -7.171208e+01 -1.728141e-03  2.420798e-03
#> pkadd.err   -2.580474e+02  2.580366e+02  2.468228e-04  1.387628e-04
#> temax        4.470897e+04 -4.471111e+04 -5.543493e-01  9.445306e-01
#> tec50        8.990420e+01 -8.989451e+01 -7.376176e-03  1.505953e-02
#> tkout        8.615441e+01 -8.614630e+01 -2.052957e-03  1.145811e-03
#> te0          1.385639e+02 -1.385583e+02 -3.525814e-03  3.921529e-03
#> pdadd.err   -5.838454e+02  5.838617e+02  2.356165e-02 -2.743998e-02
#> om.eta.ktr   3.726771e+07 -3.726780e+07 -5.225871e+02  4.422686e+02
#> om.eta.ka   -3.728455e+07  3.728464e+07  5.228441e+02 -4.424489e+02
#> om.eta.cl    2.019821e+02 -2.019681e+02 -6.144871e-03  7.111130e-03
#> om.eta.v    -1.825088e+01  1.824249e+01  1.214755e-03 -1.369398e-03
#> om.eta.emax -2.036266e+05  2.036241e+05  2.173873e+00 -1.960449e+00
#> om.eta.ec50 -4.170388e+01  4.171318e+01  6.055963e-04 -1.676334e-04
#> om.eta.kout -8.509373e+00  8.508749e+00  1.748440e-04 -2.610171e-04
#> om.eta.e0    6.945025e+00 -6.944747e+00 -1.956377e-04  1.986085e-04
#>                  prop.err     pkadd.err         temax         tec50
#> tktr         7.171332e+01 -2.580474e+02  4.470897e+04  8.990420e+01
#> tka         -7.171208e+01  2.580366e+02 -4.471111e+04 -8.989451e+01
#> tcl         -1.728141e-03  2.468228e-04 -5.543493e-01 -7.376176e-03
#> tv           2.420798e-03  1.387628e-04  9.445306e-01  1.505953e-02
#> prop.err     4.258887e-04 -4.609554e-04  1.747571e-01  1.862559e-03
#> pkadd.err   -4.609554e-04  5.542134e-03  2.823312e-01  2.277215e-03
#> temax        1.747571e-01  2.823312e-01  4.868383e+02  2.631617e+00
#> tec50        1.862559e-03  2.277215e-03  2.631617e+00  3.633437e-02
#> tkout        1.153532e-04 -2.195589e-03 -8.143154e-01 -5.152211e-03
#> te0          5.159430e-04 -6.335109e-04  1.521928e-01  1.496311e-03
#> pdadd.err   -3.053192e-03 -2.489723e-03 -3.022858e+00 -3.747555e-02
#> om.eta.ktr   7.080328e+01 -1.843402e+02  3.988373e+04  1.885619e+02
#> om.eta.ka   -7.083547e+01  1.844363e+02 -3.989693e+04 -1.886093e+02
#> om.eta.cl    8.237024e-04 -3.360332e-04  4.494603e-01  4.642784e-03
#> om.eta.v    -1.067835e-04  4.513661e-04  1.456558e-01 -2.368210e-04
#> om.eta.emax -3.582582e-01  1.126574e+00 -2.407523e+02 -9.302551e-01
#> om.eta.ec50 -6.752321e-05  4.405014e-04 -2.945433e-01  2.664383e-03
#> om.eta.kout -5.268398e-05  1.430385e-04 -8.849049e-03 -4.116288e-04
#> om.eta.e0    2.473771e-05 -9.982221e-05 -1.452344e-02 -1.353496e-05
#>                     tkout           te0     pdadd.err    om.eta.ktr
#> tktr         8.615441e+01  1.385639e+02 -5.838454e+02  3.726771e+07
#> tka         -8.614630e+01 -1.385583e+02  5.838617e+02 -3.726780e+07
#> tcl         -2.052957e-03 -3.525814e-03  2.356165e-02 -5.225871e+02
#> tv           1.145811e-03  3.921529e-03 -2.743998e-02  4.422686e+02
#> prop.err     1.153532e-04  5.159430e-04 -3.053192e-03  7.080328e+01
#> pkadd.err   -2.195589e-03 -6.335109e-04 -2.489723e-03 -1.843402e+02
#> temax       -8.143154e-01  1.521928e-01 -3.022858e+00  3.988373e+04
#> tec50       -5.152211e-03  1.496311e-03 -3.747555e-02  1.885619e+02
#> tkout        3.307455e-03  4.548793e-04  1.043972e-03  9.099526e+01
#> te0          4.548793e-04  1.259530e-03 -3.684612e-03  1.506686e+02
#> pdadd.err    1.043972e-03 -3.684612e-03  9.669861e-02 -9.260252e+02
#> om.eta.ktr   9.099526e+01  1.506686e+02 -9.260252e+02  3.901635e+07
#> om.eta.ka   -9.106064e+01 -1.507318e+02  9.266173e+02 -3.903613e+07
#> om.eta.cl    3.657073e-04  1.354178e-03 -9.652497e-03  2.121746e+02
#> om.eta.v    -6.117563e-04 -2.048988e-04  1.099236e-03 -1.045704e+01
#> om.eta.emax -3.737366e-01 -7.406940e-01  3.330178e+00 -1.868616e+05
#> om.eta.ec50 -3.834022e-04 -1.808212e-05 -1.649707e-03 -6.630319e+01
#> om.eta.kout -6.537753e-05 -6.309583e-05  1.978891e-04 -6.498957e+00
#> om.eta.e0    8.138559e-05  7.102719e-05 -1.909995e-04  7.976385e+00
#>                 om.eta.ka     om.eta.cl      om.eta.v   om.eta.emax
#> tktr        -3.728455e+07  2.019821e+02 -1.825088e+01 -2.036266e+05
#> tka          3.728464e+07 -2.019681e+02  1.824249e+01  2.036241e+05
#> tcl          5.228441e+02 -6.144871e-03  1.214755e-03  2.173873e+00
#> tv          -4.424489e+02  7.111130e-03 -1.369398e-03 -1.960449e+00
#> prop.err    -7.083547e+01  8.237024e-04 -1.067835e-04 -3.582582e-01
#> pkadd.err    1.844363e+02 -3.360332e-04  4.513661e-04  1.126574e+00
#> temax       -3.989693e+04  4.494603e-01  1.456558e-01 -2.407523e+02
#> tec50       -1.886093e+02  4.642784e-03 -2.368210e-04 -9.302551e-01
#> tkout       -9.106064e+01  3.657073e-04 -6.117563e-04 -3.737366e-01
#> te0         -1.507318e+02  1.354178e-03 -2.048988e-04 -7.406940e-01
#> pdadd.err    9.266173e+02 -9.652497e-03  1.099236e-03  3.330178e+00
#> om.eta.ktr  -3.903613e+07  2.121746e+02 -1.045704e+01 -1.868616e+05
#> om.eta.ka    3.905593e+07 -2.122390e+02  1.045254e+01  1.869390e+05
#> om.eta.cl   -2.122390e+02  3.456017e-03 -7.235366e-04 -1.184774e+00
#> om.eta.v     1.045254e+01 -7.235366e-04  8.929173e-04  1.379677e-01
#> om.eta.emax  1.869390e+05 -1.184774e+00  1.379677e-01  1.033265e+03
#> om.eta.ec50  6.636189e+01  6.958978e-04 -8.513237e-04  1.810058e-01
#> om.eta.kout  6.500964e+00 -8.899416e-05  6.719748e-05  4.545303e-02
#> om.eta.e0   -7.981871e+00  3.202080e-05 -3.363796e-05 -3.170393e-02
#>               om.eta.ec50   om.eta.kout     om.eta.e0
#> tktr        -4.170388e+01 -8.509373e+00  6.945025e+00
#> tka          4.171318e+01  8.508749e+00 -6.944747e+00
#> tcl          6.055963e-04  1.748440e-04 -1.956377e-04
#> tv          -1.676334e-04 -2.610171e-04  1.986085e-04
#> prop.err    -6.752321e-05 -5.268398e-05  2.473771e-05
#> pkadd.err    4.405014e-04  1.430385e-04 -9.982221e-05
#> temax       -2.945433e-01 -8.849049e-03 -1.452344e-02
#> tec50        2.664383e-03 -4.116288e-04 -1.353496e-05
#> tkout       -3.834022e-04 -6.537753e-05  8.138559e-05
#> te0         -1.808212e-05 -6.309583e-05  7.102719e-05
#> pdadd.err   -1.649707e-03  1.978891e-04 -1.909995e-04
#> om.eta.ktr  -6.630319e+01 -6.498957e+00  7.976385e+00
#> om.eta.ka    6.636189e+01  6.500964e+00 -7.981871e+00
#> om.eta.cl    6.958978e-04 -8.899416e-05  3.202080e-05
#> om.eta.v    -8.513237e-04  6.719748e-05 -3.363796e-05
#> om.eta.emax  1.810058e-01  4.545303e-02 -3.170393e-02
#> om.eta.ec50  8.495378e-03 -1.481402e-04  2.757483e-05
#> om.eta.kout -1.481402e-04  5.163916e-05 -7.688739e-06
#> om.eta.e0    2.757483e-05 -7.688739e-06  1.019480e-05
fit
#> ── nlmixr² nonmem2rx reading NONMEM ver 7.4.3 ──
#> 
#>               OBJF     AIC      BIC Log-likelihood Condition#(Cov)
#> nonmem2rx 439.2156 1364.91 1444.331      -663.4551    1.023921e+14
#>           Condition#(Cor)
#> nonmem2rx     36618735833
#> 
#> ── Time (sec fit$time): ──
#> 
#>             setup postprocess table compress NONMEM as.nlmixr2 covariance
#> elapsed 0.7185081       0.027 0.061    0.001 320.27      1.314    271.994
#> 
#> ── Population Parameters (fit$parFixed or fit$parFixedDf): ──
#> 
#>                Parameter     Est.     SE    %RSE Back-transformed(95%CI)
#> tktr            1 - tktr  6.24e-7   6510 1.04e12           1.00 (0, Inf)
#> tka              2 - tka -3.01e-6   6510 2.17e11           1.00 (0, Inf)
#> tcl              3 - tcl    -2.00  0.139    6.92    0.135 (0.103, 0.177)
#> tv                4 - tv     2.05  0.155    7.55       7.78 (5.74, 10.5)
#> prop.err    5 - prop.err   0.0986 0.0206    20.9  0.0986 (0.0581, 0.139)
#> pkadd.err  6 - pkadd.err    0.512 0.0744    14.6    0.512 (0.366, 0.658)
#> temax          7 - temax     6.42   22.1     344  0.998 (1.01e-16, 1.00)
#> tec50          8 - tec50    0.141  0.191     135      1.15 (0.792, 1.67)
#> tkout          9 - tkout    -2.95 0.0575    1.95 0.0522 (0.0466, 0.0584)
#> te0             10 - te0     4.57 0.0355   0.777        96.6 (90.1, 104)
#> pdadd.err 11 - pdadd.err     3.72  0.311    8.37       3.72 (3.11, 4.33)
#>           BSV(CV% or SD) Shrink(SD)%
#> tktr                86.5       59.8 
#> tka                 86.5       59.8 
#> tcl                 28.6       1.34 
#> tv                  22.8       6.44 
#> prop.err                            
#> pkadd.err                           
#> temax            0.00707        100 
#> tec50               45.0       6.06 
#> tkout               9.16       32.4 
#> te0                 5.24       18.1 
#> pdadd.err                           
#>  
#>   Covariance Type (fit$covMethod): s (full)
#>   Some strong fixed parameter correlations exist (fit$cor) :
#>                    cor:tka,tktr                cor:tcl,tktr 
#>                      -1.00                      -0.398  
#>                 cor:tv,tktr           cor:prop.err,tktr 
#>                      0.286                        0.534  
#>          cor:pkadd.err,tktr              cor:temax,tktr 
#>                     -0.532                       0.311  
#>              cor:tec50,tktr              cor:tkout,tktr 
#>                     0.0725                        0.230   
#>                cor:te0,tktr          cor:pdadd.err,tktr 
#>                      0.600                      -0.288   
#>         cor:om.eta.ktr,tktr          cor:om.eta.ka,tktr 
#>                      0.917                      -0.916  
#>          cor:om.eta.cl,tktr           cor:om.eta.v,tktr 
#>                      0.528                     -0.0938   
#>        cor:om.eta.emax,tktr        cor:om.eta.ec50,tktr 
#>                     -0.973                     -0.0695   
#>        cor:om.eta.kout,tktr          cor:om.eta.e0,tktr 
#>                     -0.182                        0.334  
#>                 cor:tcl,tka                  cor:tv,tka 
#>                      0.398                      -0.286   
#>            cor:prop.err,tka           cor:pkadd.err,tka 
#>                     -0.534                       0.532  
#>               cor:temax,tka               cor:tec50,tka 
#>                     -0.311                     -0.0724   
#>               cor:tkout,tka                 cor:te0,tka 
#>                     -0.230                       -0.600  
#>           cor:pdadd.err,tka          cor:om.eta.ktr,tka 
#>                      0.288                       -0.917  
#>           cor:om.eta.ka,tka           cor:om.eta.cl,tka 
#>                      0.916                      -0.528  
#>            cor:om.eta.v,tka         cor:om.eta.emax,tka 
#>                     0.0938                        0.973  
#>         cor:om.eta.ec50,tka         cor:om.eta.kout,tka 
#>                     0.0695                        0.182   
#>           cor:om.eta.e0,tka                  cor:tv,tcl 
#>                     -0.334                      -0.856  
#>            cor:prop.err,tcl           cor:pkadd.err,tcl 
#>                     -0.604                      0.0239   
#>               cor:temax,tcl               cor:tec50,tcl 
#>                     -0.181                       -0.279   
#>               cor:tkout,tcl                 cor:te0,tcl 
#>                     -0.258                       -0.717  
#>           cor:pdadd.err,tcl          cor:om.eta.ktr,tcl 
#>                      0.547                      -0.604  
#>           cor:om.eta.ka,tcl           cor:om.eta.cl,tcl 
#>                      0.604                      -0.754  
#>            cor:om.eta.v,tcl         cor:om.eta.emax,tcl 
#>                      0.293                        0.488  
#>         cor:om.eta.ec50,tcl         cor:om.eta.kout,tcl 
#>                     0.0474                        0.176   
#>           cor:om.eta.e0,tcl             cor:prop.err,tv 
#>                     -0.442                       0.757  
#>            cor:pkadd.err,tv                cor:temax,tv 
#>                     0.0120                        0.276   
#>                cor:tec50,tv                cor:tkout,tv 
#>                      0.510                       0.129   
#>                  cor:te0,tv            cor:pdadd.err,tv 
#>                      0.713                      -0.570  
#>           cor:om.eta.ktr,tv            cor:om.eta.ka,tv 
#>                      0.457                      -0.457  
#>            cor:om.eta.cl,tv             cor:om.eta.v,tv 
#>                      0.781                      -0.296   
#>          cor:om.eta.emax,tv          cor:om.eta.ec50,tv 
#>                     -0.394                     -0.0117   
#>          cor:om.eta.kout,tv            cor:om.eta.e0,tv 
#>                     -0.234                        0.402  
#>      cor:pkadd.err,prop.err          cor:temax,prop.err 
#>                     -0.300                       0.384  
#>          cor:tec50,prop.err          cor:tkout,prop.err 
#>                      0.473                      0.0972   
#>            cor:te0,prop.err      cor:pdadd.err,prop.err 
#>                      0.704                      -0.476  
#>     cor:om.eta.ktr,prop.err      cor:om.eta.ka,prop.err 
#>                      0.549                      -0.549  
#>      cor:om.eta.cl,prop.err       cor:om.eta.v,prop.err 
#>                      0.679                      -0.173   
#>    cor:om.eta.emax,prop.err    cor:om.eta.ec50,prop.err 
#>                     -0.540                     -0.0355   
#>    cor:om.eta.kout,prop.err      cor:om.eta.e0,prop.err 
#>                     -0.355                       0.375  
#>         cor:temax,pkadd.err         cor:tec50,pkadd.err 
#>                      0.172                        0.160   
#>         cor:tkout,pkadd.err           cor:te0,pkadd.err 
#>                     -0.513                      -0.240   
#>     cor:pdadd.err,pkadd.err    cor:om.eta.ktr,pkadd.err 
#>                     -0.108                       -0.396  
#>     cor:om.eta.ka,pkadd.err     cor:om.eta.cl,pkadd.err 
#>                      0.396                     -0.0768   
#>      cor:om.eta.v,pkadd.err   cor:om.eta.emax,pkadd.err 
#>                      0.203                        0.471  
#>   cor:om.eta.ec50,pkadd.err   cor:om.eta.kout,pkadd.err 
#>                     0.0642                        0.267   
#>     cor:om.eta.e0,pkadd.err             cor:tec50,temax 
#>                     -0.420                       0.626  
#>             cor:tkout,temax               cor:te0,temax 
#>                     -0.642                       0.194   
#>         cor:pdadd.err,temax        cor:om.eta.ktr,temax 
#>                     -0.441                       0.289   
#>         cor:om.eta.ka,temax         cor:om.eta.cl,temax 
#>                     -0.289                        0.347  
#>          cor:om.eta.v,temax       cor:om.eta.emax,temax 
#>                      0.221                       -0.339  
#>       cor:om.eta.ec50,temax       cor:om.eta.kout,temax 
#>                     -0.145                      -0.0558   
#>         cor:om.eta.e0,temax             cor:tkout,tec50 
#>                     -0.206                       -0.470  
#>               cor:te0,tec50         cor:pdadd.err,tec50 
#>                      0.221                       -0.632  
#>        cor:om.eta.ktr,tec50         cor:om.eta.ka,tec50 
#>                      0.158                       -0.158   
#>         cor:om.eta.cl,tec50          cor:om.eta.v,tec50 
#>                      0.414                     -0.0416   
#>       cor:om.eta.emax,tec50       cor:om.eta.ec50,tec50 
#>                     -0.152                        0.152   
#>       cor:om.eta.kout,tec50         cor:om.eta.e0,tec50 
#>                     -0.301                     -0.0222   
#>               cor:te0,tkout         cor:pdadd.err,tkout 
#>                      0.223                       0.0584   
#>        cor:om.eta.ktr,tkout         cor:om.eta.ka,tkout 
#>                      0.253                       -0.253   
#>         cor:om.eta.cl,tkout          cor:om.eta.v,tkout 
#>                      0.108                       -0.356  
#>       cor:om.eta.emax,tkout       cor:om.eta.ec50,tkout 
#>                     -0.202                      -0.0723   
#>       cor:om.eta.kout,tkout         cor:om.eta.e0,tkout 
#>                     -0.158                        0.443  
#>           cor:pdadd.err,te0          cor:om.eta.ktr,te0 
#>                     -0.334                       0.680  
#>           cor:om.eta.ka,te0           cor:om.eta.cl,te0 
#>                     -0.680                       0.649  
#>            cor:om.eta.v,te0         cor:om.eta.emax,te0 
#>                     -0.193                       -0.649  
#>         cor:om.eta.ec50,te0         cor:om.eta.kout,te0 
#>                   -0.00553                       -0.247   
#>           cor:om.eta.e0,te0    cor:om.eta.ktr,pdadd.err 
#>                      0.627                      -0.477  
#>     cor:om.eta.ka,pdadd.err     cor:om.eta.cl,pdadd.err 
#>                      0.477                      -0.528  
#>      cor:om.eta.v,pdadd.err   cor:om.eta.emax,pdadd.err 
#>                      0.118                        0.333  
#>   cor:om.eta.ec50,pdadd.err   cor:om.eta.kout,pdadd.err 
#>                    -0.0576                       0.0886   
#>     cor:om.eta.e0,pdadd.err    cor:om.eta.ka,om.eta.ktr 
#>                     -0.192                        -1.00  
#>    cor:om.eta.cl,om.eta.ktr     cor:om.eta.v,om.eta.ktr 
#>                      0.578                     -0.0560   
#>  cor:om.eta.emax,om.eta.ktr  cor:om.eta.ec50,om.eta.ktr 
#>                     -0.931                      -0.115   
#>  cor:om.eta.kout,om.eta.ktr    cor:om.eta.e0,om.eta.ktr 
#>                     -0.145                        0.400  
#>     cor:om.eta.cl,om.eta.ka      cor:om.eta.v,om.eta.ka 
#>                     -0.578                      0.0560   
#>   cor:om.eta.emax,om.eta.ka   cor:om.eta.ec50,om.eta.ka 
#>                      0.931                       0.115   
#>   cor:om.eta.kout,om.eta.ka     cor:om.eta.e0,om.eta.ka 
#>                      0.145                       -0.400  
#>      cor:om.eta.v,om.eta.cl   cor:om.eta.emax,om.eta.cl 
#>                     -0.412                      -0.627  
#>   cor:om.eta.ec50,om.eta.cl   cor:om.eta.kout,om.eta.cl 
#>                      0.128                       -0.211   
#>     cor:om.eta.e0,om.eta.cl    cor:om.eta.emax,om.eta.v 
#>                      0.171                        0.144   
#>    cor:om.eta.ec50,om.eta.v    cor:om.eta.kout,om.eta.v 
#>                     -0.309                       0.313  
#>      cor:om.eta.e0,om.eta.v cor:om.eta.ec50,om.eta.emax 
#>                     -0.353                      0.0611   
#> cor:om.eta.kout,om.eta.emax   cor:om.eta.e0,om.eta.emax 
#>                      0.197                       -0.309  
#> cor:om.eta.kout,om.eta.ec50   cor:om.eta.e0,om.eta.ec50 
#>                     -0.224                       0.0937   
#>   cor:om.eta.e0,om.eta.kout 
#>                     -0.335  
#>  
#> 
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance (fit$omega) or correlation (fit$omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in fit$shrink 
#>   Censoring (fit$censInformation): No censoring
#>   Minimization message (fit$message):  
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
#> ── Fit Data (object fit is a modified tibble): ──
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

Note this covariance step is not 100% successful since it is not `r, s`.
However, it can give some insights on which parameters are estimated
well. In this case you can see that the `emax` parameter is more poorly
estimated than other parameters, which means fixing the parameter or
reducing other parameters may help your estimate progress in `NONMEM`.
