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
[`nonmem2rx()`](../reference/nonmem2rx.md):

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
#>     validation <- c("IPRED relative difference compared to Nonmem IPRED: 0%; 95% percentile: (0%,0%); rtol=6.14e-06", 
#>         "IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (3.99e-06, 0.000496); atol=6.04e-05", 
#>         "PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=6.15e-06", 
#>         "PRED absolute difference compared to Nonmem PRED: 95% percentile: (3.79e-07,0.00318) atol=6.15e-06")
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
#>     validation <- c("IPRED relative difference compared to Nonmem IPRED: 0%; 95% percentile: (0%,0%); rtol=6.14e-06", 
#>         "IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (3.99e-06, 0.000496); atol=6.04e-05", 
#>         "PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=6.15e-06", 
#>         "PRED absolute difference compared to Nonmem PRED: 95% percentile: (3.79e-07,0.00318) atol=6.15e-06")
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
#> rxode2 5.1.8.9000 using 2 threads (see ?getRxThreads)
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
#>              OBJF      AIC      BIC Log-likelihood
#> nonmem2rx 1326.91 2252.605 2332.025      -1107.302
#> 
#> ── Time (sec $time): ──
#> 
#>             setup postprocess table compress NONMEM as.nlmixr2
#> elapsed 0.1394053       0.033 0.058    0.001 320.27      1.064
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
#>     IPRED relative difference compared to Nonmem IPRED: 0%; 95% percentile: (0%,0%); rtol=5.04e-06
#>     PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=5.37e-06
#>     IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (2.68e-06, 0.000454); atol=3.03e-05
#>     PRED absolute difference compared to Nonmem PRED: 95% percentile: (4.72e-07,0.00361); atol=5.37e-06
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
#>     validation <- c("IPRED relative difference compared to Nonmem IPRED: 0%; 95% percentile: (0%,0%); rtol=6.14e-06", 
#>         "IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (3.99e-06, 0.000496); atol=6.04e-05", 
#>         "PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=6.15e-06", 
#>         "PRED absolute difference compared to Nonmem PRED: 95% percentile: (3.79e-07,0.00318) atol=6.15e-06")
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
#> [IDID=-3, illegal input detected (see printed message).]: 1 warning(s) for subject(s): 25
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:40 
#> done
#> → Calculating residuals/tables
#> ✔ done

fit2
#> ── nlmixr² FOCEi (outer: bobyqa) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 1423.173 2340.868 2403.568      -1155.434         2804048        389.6313
#> 
#> ── Time (sec fit2$time): ──
#> 
#>            setup optimize covariance preprocess postprocess table compress
#> elapsed 2.586529 4.054886   20.25374      0.032        0.05 0.052    0.001
#>             other
#> elapsed 0.1088467
#> 
#> ── Population Parameters (fit2$parFixed or fit2$parFixedDf): ──
#> 
#>                Parameter   Est.     SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tktr            1 - tktr 0.0654 0.0614  93.9      1.07 (0.946, 1.20)         
#> tka              2 - tka 0.0347  0.222   640      1.04 (0.670, 1.60)         
#> tcl              3 - tcl  -2.00 0.0530  2.66    0.136 (0.122, 0.151)     27.9
#> tv                4 - tv   2.05 0.0448  2.18       7.81 (7.15, 8.52)     23.4
#> prop.err    5 - prop.err  0.159 0.0321  20.1   0.159 (0.0966, 0.222)         
#> pkadd.err  6 - pkadd.err  0.595 0.0851  14.3    0.595 (0.428, 0.761)         
#> temax          7 - temax   7.54  0.544  7.21     0.999 (0.998, 1.00)         
#> tec50          8 - tec50  0.126 0.0927  73.4      1.13 (0.946, 1.36)     42.7
#> tkout          9 - tkout  -2.96 0.0237 0.800 0.0516 (0.0493, 0.0541)         
#> te0             10 - te0   4.57 0.0119 0.259       96.7 (94.5, 99.0)     4.99
#> pdadd.err 11 - pdadd.err   3.83  0.332  8.68       3.83 (3.18, 4.48)         
#>           Shrink(SD)%
#> tktr                 
#> tka                  
#> tcl             3.16 
#> tv              9.32 
#> prop.err             
#> pkadd.err            
#> temax                
#> tec50           7.53 
#> tkout                
#> te0             17.9 
#> pdadd.err            
#>  
#>   Covariance Type (fit2$covMethod): |r|,|s| (full)
#>     other calculated covs (setCov()): r; s; r,s; r (full); s (full)
#>   Some strong fixed parameter correlations exist (fit2$cor) :
#>                  cor:tka,tktr              cor:tcl,tktr               cor:tv,tktr 
#>                    0.917                    -0.204                    -0.0806   
#>         cor:prop.err,tktr        cor:pkadd.err,tktr            cor:temax,tktr 
#>                   -0.149                     0.0502                      0.592  
#>            cor:tec50,tktr            cor:tkout,tktr              cor:te0,tktr 
#>                    0.109                    -0.0130                      0.113   
#>        cor:pdadd.err,tktr        cor:om.eta.cl,tktr         cor:om.eta.v,tktr 
#>                  -0.0375                     -0.104                     -0.339  
#>      cor:om.eta.ec50,tktr        cor:om.eta.e0,tktr               cor:tcl,tka 
#>                   -0.130                     0.0448                     -0.165   
#>                cor:tv,tka          cor:prop.err,tka         cor:pkadd.err,tka 
#>                   0.0185                     -0.366                   -0.0236   
#>             cor:temax,tka             cor:tec50,tka             cor:tkout,tka 
#>                    0.503                   -0.0191                     -0.166   
#>               cor:te0,tka         cor:pdadd.err,tka         cor:om.eta.cl,tka 
#>                    0.207                     -0.127                     -0.155   
#>          cor:om.eta.v,tka       cor:om.eta.ec50,tka         cor:om.eta.e0,tka 
#>                   -0.347                   -0.0845                     -0.134   
#>                cor:tv,tcl          cor:prop.err,tcl         cor:pkadd.err,tcl 
#>                    0.399                     0.206                     0.0793   
#>             cor:temax,tcl             cor:tec50,tcl             cor:tkout,tcl 
#>                   -0.145                     -0.331                    0.0400   
#>               cor:te0,tcl         cor:pdadd.err,tcl         cor:om.eta.cl,tcl 
#>                  -0.0311                    -0.0530                      0.395  
#>          cor:om.eta.v,tcl       cor:om.eta.ec50,tcl         cor:om.eta.e0,tcl 
#>                    0.190                    -0.0469                      0.139   
#>           cor:prop.err,tv          cor:pkadd.err,tv              cor:temax,tv 
#>                   0.0474                     -0.534                    -0.261   
#>              cor:tec50,tv              cor:tkout,tv                cor:te0,tv 
#>                   -0.209                     0.0157                      0.120   
#>          cor:pdadd.err,tv          cor:om.eta.cl,tv           cor:om.eta.v,tv 
#>                   0.0517                     -0.195                     -0.128   
#>        cor:om.eta.ec50,tv          cor:om.eta.e0,tv    cor:pkadd.err,prop.err 
#>                    0.305                    -0.263                     -0.199   
#>        cor:temax,prop.err        cor:tec50,prop.err        cor:tkout,prop.err 
#>                   0.0791                     -0.262                     0.0411   
#>          cor:te0,prop.err    cor:pdadd.err,prop.err    cor:om.eta.cl,prop.err 
#>                   -0.506                    -0.140                     -0.186   
#>     cor:om.eta.v,prop.err  cor:om.eta.ec50,prop.err    cor:om.eta.e0,prop.err 
#>                   -0.146                      0.147                      0.598  
#>       cor:temax,pkadd.err       cor:tec50,pkadd.err       cor:tkout,pkadd.err 
#>                    0.230                     0.0446                     0.0422   
#>         cor:te0,pkadd.err   cor:pdadd.err,pkadd.err   cor:om.eta.cl,pkadd.err 
#>                  -0.0871                     0.0263                      0.187   
#>    cor:om.eta.v,pkadd.err cor:om.eta.ec50,pkadd.err   cor:om.eta.e0,pkadd.err 
#>                    0.151                     -0.435                    0.0747   
#>           cor:tec50,temax           cor:tkout,temax             cor:te0,temax 
#>                   0.0951                     -0.281                     -0.182   
#>       cor:pdadd.err,temax       cor:om.eta.cl,temax        cor:om.eta.v,temax 
#>                   -0.138                    -0.0646                     -0.315  
#>     cor:om.eta.ec50,temax       cor:om.eta.e0,temax           cor:tkout,tec50 
#>                   -0.385                     0.304                     0.537  
#>             cor:te0,tec50       cor:pdadd.err,tec50       cor:om.eta.cl,tec50 
#>                   0.0320                      0.638                    0.0492   
#>        cor:om.eta.v,tec50     cor:om.eta.ec50,tec50       cor:om.eta.e0,tec50 
#>                  -0.0689                     -0.289                     -0.141   
#>             cor:te0,tkout       cor:pdadd.err,tkout       cor:om.eta.cl,tkout 
#>                    0.113                      0.436                   -0.0275   
#>        cor:om.eta.v,tkout     cor:om.eta.ec50,tkout       cor:om.eta.e0,tkout 
#>                   0.0291                     0.0334                     -0.115   
#>         cor:pdadd.err,te0         cor:om.eta.cl,te0          cor:om.eta.v,te0 
#>                   0.0284                    0.00968                     -0.106   
#>       cor:om.eta.ec50,te0         cor:om.eta.e0,te0   cor:om.eta.cl,pdadd.err 
#>                    0.106                     -0.763                     0.164   
#>    cor:om.eta.v,pdadd.err cor:om.eta.ec50,pdadd.err   cor:om.eta.e0,pdadd.err 
#>                   -0.138                   0.000880                     -0.267   
#>    cor:om.eta.v,om.eta.cl cor:om.eta.ec50,om.eta.cl   cor:om.eta.e0,om.eta.cl 
#>                    0.509                    -0.209                      0.127   
#>  cor:om.eta.ec50,om.eta.v    cor:om.eta.e0,om.eta.v cor:om.eta.e0,om.eta.ec50 
#>                  -0.0251                      0.223                     -0.123   
#>  
#> 
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance (fit2$omega) or correlation (fit2$omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in fit2$shrink 
#>   Information about run found (fit2$runInfo):
#>    • tolerances (atol/rtol) were temporarily increased for some difficult ODE solving during the optimization. consider increasing sigdig/atol/rtol changing initial estimates or changing the structural model 
#>    • sandwich matrix corrected; compare it to $covR or $covS 
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
#> 1 1       0.5 dcp     0    1.25 -1.25 -1.81 0.994 -0.994 -1.61  1.22 -1.22 -1.86
#> 2 1       1   dcp     1.9  3.60 -1.70 -1.46 2.85  -0.951 -1.27  3.52 -1.62 -1.63
#> 3 1       2   dcp     3.3  7.83 -4.53 -2.01 6.16  -2.86  -2.49  7.65 -4.35 -2.41
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
#> DLSODA-  ITASK = 4 or 5 and TCRIT (=R1) behind TCUR (=R2)   
#> DLSODA-  ITASK = 4 or 5 and TCRIT (=R1) behind TCUR (=R2)   
#> DLSODA-  ITASK = 4 or 5 and TCRIT (=R1) behind TCUR (=R2)   
#> DLSODA-  ITASK = 4 or 5 and TCRIT (=R1) behind TCUR (=R2)   
#> DLSODA-  ITASK = 4 or 5 and TCRIT (=R1) behind TCUR (=R2)   
#> DLSODA-  ITASK = 4 or 5 and TCRIT (=R1) behind TCUR (=R2)   
#> [====|====|====|====|====|====|====|====|====|====] 0:02:51
#> Warning: "r,s" not usable (sandwich doubtful); installed "r"
#> Warning in foceiFitCpp_(.ret): covariance step: atol/rtol increased for some
#> difficult ODE solves
#> Updated original fit object fit
#>                      tktr           tka           tcl            tv
#> tktr         1.140591e-01  1.138461e-01  7.007645e-03 -1.408488e-02
#> tka          1.138461e-01  1.136613e-01  7.055070e-03 -1.397682e-02
#> tcl          7.007645e-03  7.055070e-03  3.406212e-03 -1.795442e-04
#> tv          -1.408488e-02 -1.397682e-02 -1.795442e-04  3.405346e-03
#> prop.err     7.400414e-03  7.376981e-03  7.189718e-04 -1.016780e-03
#> pkadd.err   -6.505803e-02 -6.483332e-02 -4.391877e-03  7.109323e-03
#> temax        4.940355e-02  4.865458e-02 -1.862574e-03 -8.768541e-03
#> tec50       -2.542942e-03 -2.927188e-03 -1.628719e-03 -6.715464e-04
#> tkout       -2.918336e-03 -2.975936e-03 -1.931079e-04  2.197070e-04
#> te0         -5.903317e-04 -5.703014e-04 -8.214019e-05  1.316140e-04
#> pdadd.err    1.162875e-02  1.088021e-02  3.319550e-04 -3.178515e-04
#> om.eta.ktr  -4.157766e-02 -4.202508e-02 -1.758556e-03  4.976363e-03
#> om.eta.ka   -4.269761e-02 -4.298067e-02 -1.558508e-03  5.625784e-03
#> om.eta.cl    3.551959e-04  3.439442e-04  4.490036e-04 -1.824567e-04
#> om.eta.v    -7.592111e-04 -7.492439e-04 -5.644815e-05  1.327443e-04
#> om.eta.emax  2.632371e-05  3.084821e-05 -2.003953e-05  1.480894e-05
#> om.eta.ec50  3.648286e-03  3.669105e-03  3.344674e-04 -1.181044e-05
#> om.eta.kout  1.062448e-04  9.306102e-05 -6.563130e-06 -3.394467e-05
#> om.eta.e0    2.337761e-05  2.156990e-05  1.046537e-05 -1.849528e-05
#>                  prop.err     pkadd.err         temax         tec50
#> tktr         7.400414e-03 -6.505803e-02  4.940355e-02 -2.542942e-03
#> tka          7.376981e-03 -6.483332e-02  4.865458e-02 -2.927188e-03
#> tcl          7.189718e-04 -4.391877e-03 -1.862574e-03 -1.628719e-03
#> tv          -1.016780e-03  7.109323e-03 -8.768541e-03 -6.715464e-04
#> prop.err     6.585778e-04 -4.873711e-03  9.802189e-04 -2.876764e-04
#> pkadd.err   -4.873711e-03  5.370251e-02 -1.781964e-02  8.699220e-04
#> temax        9.802189e-04 -1.781964e-02  2.052638e-01  9.231467e-03
#> tec50       -2.876764e-04  8.699220e-04  9.231467e-03  7.121728e-03
#> tkout       -1.467083e-04  1.390164e-03 -2.431084e-03  1.108677e-03
#> te0         -7.797480e-05 -1.273902e-04 -4.522219e-04 -4.928058e-05
#> pdadd.err    7.822674e-04 -1.460426e-02 -5.080482e-03  1.607412e-02
#> om.eta.ktr  -2.070981e-03  1.198132e-02 -7.125829e-04  3.200710e-03
#> om.eta.ka   -2.223348e-03  1.327631e-02 -4.948831e-03  1.150815e-03
#> om.eta.cl   -1.465777e-06 -6.349640e-04 -2.508338e-04  1.871118e-04
#> om.eta.v    -7.649035e-05  8.471558e-04 -1.459566e-03  8.640758e-06
#> om.eta.emax -1.002332e-05  6.496118e-05  3.857855e-06  6.751053e-06
#> om.eta.ec50  3.472112e-04 -4.223454e-03 -6.100290e-03 -9.864016e-04
#> om.eta.kout  1.965515e-05 -2.078177e-04  1.317845e-04  1.299996e-04
#> om.eta.e0    4.441319e-06  2.221061e-05  8.254258e-05 -3.848393e-07
#>                     tkout           te0     pdadd.err    om.eta.ktr
#> tktr        -2.918336e-03 -5.903317e-04  1.162875e-02 -4.157766e-02
#> tka         -2.975936e-03 -5.703014e-04  1.088021e-02 -4.202508e-02
#> tcl         -1.931079e-04 -8.214019e-05  3.319550e-04 -1.758556e-03
#> tv           2.197070e-04  1.316140e-04 -3.178515e-04  4.976363e-03
#> prop.err    -1.467083e-04 -7.797480e-05  7.822674e-04 -2.070981e-03
#> pkadd.err    1.390164e-03 -1.273902e-04 -1.460426e-02  1.198132e-02
#> temax       -2.431084e-03 -4.522219e-04 -5.080482e-03 -7.125829e-04
#> tec50        1.108677e-03 -4.928058e-05  1.607412e-02  3.200710e-03
#> tkout        6.841476e-04  3.512728e-05  2.830870e-03  2.064114e-03
#> te0          3.512728e-05  1.414515e-04 -2.270218e-04 -5.383982e-04
#> pdadd.err    2.830870e-03 -2.270218e-04  1.341167e-01 -8.169752e-03
#> om.eta.ktr   2.064114e-03 -5.383982e-04 -8.169752e-03  7.725439e-02
#> om.eta.ka    1.762117e-03 -3.864950e-04 -1.185973e-02  7.372101e-02
#> om.eta.cl   -3.688508e-05 -3.662880e-05  2.171464e-03 -2.945070e-04
#> om.eta.v     3.492491e-05 -2.856369e-05 -3.977974e-04 -5.690840e-04
#> om.eta.emax -3.616320e-06  1.227463e-05  1.159868e-04 -3.990711e-04
#> om.eta.ec50  9.154259e-05  6.039426e-05  1.193993e-03 -7.493699e-04
#> om.eta.kout  4.363165e-05 -3.426139e-07 -1.851747e-06  1.324938e-04
#> om.eta.e0   -1.476726e-06 -8.791068e-06 -7.854140e-05  5.922845e-05
#>                 om.eta.ka     om.eta.cl      om.eta.v   om.eta.emax
#> tktr        -4.269761e-02  3.551959e-04 -7.592111e-04  2.632371e-05
#> tka         -4.298067e-02  3.439442e-04 -7.492439e-04  3.084821e-05
#> tcl         -1.558508e-03  4.490036e-04 -5.644815e-05 -2.003953e-05
#> tv           5.625784e-03 -1.824567e-04  1.327443e-04  1.480894e-05
#> prop.err    -2.223348e-03 -1.465777e-06 -7.649035e-05 -1.002332e-05
#> pkadd.err    1.327631e-02 -6.349640e-04  8.471558e-04  6.496118e-05
#> temax       -4.948831e-03 -2.508338e-04 -1.459566e-03  3.857855e-06
#> tec50        1.150815e-03  1.871118e-04  8.640758e-06  6.751053e-06
#> tkout        1.762117e-03 -3.688508e-05  3.492491e-05 -3.616320e-06
#> te0         -3.864950e-04 -3.662880e-05 -2.856369e-05  1.227463e-05
#> pdadd.err   -1.185973e-02  2.171464e-03 -3.977974e-04  1.159868e-04
#> om.eta.ktr   7.372101e-02 -2.945070e-04 -5.690840e-04 -3.990711e-04
#> om.eta.ka    7.117491e-02 -3.804724e-04 -5.082758e-04 -3.628549e-04
#> om.eta.cl   -3.804724e-04  5.166745e-04  8.596138e-05 -6.939494e-06
#> om.eta.v    -5.082758e-04  8.596138e-05  1.656244e-04  4.032988e-06
#> om.eta.emax -3.628549e-04 -6.939494e-06  4.032988e-06  4.263255e-06
#> om.eta.ec50 -6.437682e-04 -1.360712e-04 -3.623046e-05 -1.988061e-05
#> om.eta.kout  6.083110e-05 -6.868340e-06 -9.453365e-06 -2.892653e-06
#> om.eta.e0    4.481018e-05  6.363185e-06  3.482417e-06 -1.389610e-06
#>               om.eta.ec50   om.eta.kout     om.eta.e0
#> tktr         3.648286e-03  1.062448e-04  2.337761e-05
#> tka          3.669105e-03  9.306102e-05  2.156990e-05
#> tcl          3.344674e-04 -6.563130e-06  1.046537e-05
#> tv          -1.181044e-05 -3.394467e-05 -1.849528e-05
#> prop.err     3.472112e-04  1.965515e-05  4.441319e-06
#> pkadd.err   -4.223454e-03 -2.078177e-04  2.221061e-05
#> temax       -6.100290e-03  1.317845e-04  8.254258e-05
#> tec50       -9.864016e-04  1.299996e-04 -3.848393e-07
#> tkout        9.154259e-05  4.363165e-05 -1.476726e-06
#> te0          6.039426e-05 -3.426139e-07 -8.791068e-06
#> pdadd.err    1.193993e-03 -1.851747e-06 -7.854140e-05
#> om.eta.ktr  -7.493699e-04  1.324938e-04  5.922845e-05
#> om.eta.ka   -6.437682e-04  6.083110e-05  4.481018e-05
#> om.eta.cl   -1.360712e-04 -6.868340e-06  6.363185e-06
#> om.eta.v    -3.623046e-05 -9.453365e-06  3.482417e-06
#> om.eta.emax -1.988061e-05 -2.892653e-06 -1.389610e-06
#> om.eta.ec50  1.870191e-03  4.824446e-05 -8.400708e-06
#> om.eta.kout  4.824446e-05  1.978160e-05  4.953321e-07
#> om.eta.e0   -8.400708e-06  4.953321e-07  9.903277e-07
fit
#> ── nlmixr² nonmem2rx reading NONMEM ver 7.4.3 ──
#> 
#>              OBJF      AIC      BIC Log-likelihood Condition#(Cov)
#> nonmem2rx 1326.91 2252.605 2332.025      -1107.302     36684660817
#>           Condition#(Cor)
#> nonmem2rx      7971337691
#> 
#> ── Time (sec fit$time): ──
#> 
#>             setup postprocess table compress NONMEM as.nlmixr2 covariance
#> elapsed 0.1394053       0.033 0.058    0.001 320.27      1.064    174.159
#> 
#> ── Population Parameters (fit$parFixed or fit$parFixedDf): ──
#> 
#>                Parameter     Est.     SE   %RSE Back-transformed(95%CI)
#> tktr            1 - tktr  6.24e-7  0.338 5.41e7      1.00 (0.516, 1.94)
#> tka              2 - tka -3.01e-6  0.337 1.12e7      1.00 (0.516, 1.94)
#> tcl              3 - tcl    -2.00 0.0584   2.91    0.135 (0.120, 0.151)
#> tv                4 - tv     2.05 0.0584   2.84       7.78 (6.94, 8.73)
#> prop.err    5 - prop.err   0.0986 0.0257   26.0  0.0986 (0.0483, 0.149)
#> pkadd.err  6 - pkadd.err    0.512  0.232   45.3   0.512 (0.0574, 0.966)
#> temax          7 - temax     6.42  0.453   7.06    0.998 (0.996, 0.999)
#> tec50          8 - tec50    0.141 0.0844   60.0      1.15 (0.976, 1.36)
#> tkout          9 - tkout    -2.95 0.0262  0.886 0.0522 (0.0496, 0.0549)
#> te0             10 - te0     4.57 0.0119  0.260       96.6 (94.4, 98.9)
#> pdadd.err 11 - pdadd.err     3.72  0.366   9.85       3.72 (3.00, 4.43)
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
#>   Covariance Type (fit$covMethod): r,s (full)
#>   Some strong fixed parameter correlations exist (fit$cor) :
#>                    cor:tka,tktr                cor:tcl,tktr 
#>                       1.00                       0.356  
#>                 cor:tv,tktr           cor:prop.err,tktr 
#>                     -0.715                       0.854  
#>          cor:pkadd.err,tktr              cor:temax,tktr 
#>                     -0.831                       0.323  
#>              cor:tec50,tktr              cor:tkout,tktr 
#>                    -0.0892                       -0.330  
#>                cor:te0,tktr          cor:pdadd.err,tktr 
#>                     -0.147                       0.0940   
#>         cor:om.eta.ktr,tktr          cor:om.eta.ka,tktr 
#>                     -0.443                      -0.474  
#>          cor:om.eta.cl,tktr           cor:om.eta.v,tktr 
#>                     0.0463                       -0.175   
#>        cor:om.eta.emax,tktr        cor:om.eta.ec50,tktr 
#>                     0.0377                        0.250   
#>        cor:om.eta.kout,tktr          cor:om.eta.e0,tktr 
#>                     0.0707                       0.0696   
#>                 cor:tcl,tka                  cor:tv,tka 
#>                      0.359                      -0.710  
#>            cor:prop.err,tka           cor:pkadd.err,tka 
#>                      0.853                      -0.830  
#>               cor:temax,tka               cor:tec50,tka 
#>                      0.319                      -0.103   
#>               cor:tkout,tka                 cor:te0,tka 
#>                     -0.337                      -0.142   
#>           cor:pdadd.err,tka          cor:om.eta.ktr,tka 
#>                     0.0881                       -0.448  
#>           cor:om.eta.ka,tka           cor:om.eta.cl,tka 
#>                     -0.478                      0.0449   
#>            cor:om.eta.v,tka         cor:om.eta.emax,tka 
#>                     -0.173                       0.0443   
#>         cor:om.eta.ec50,tka         cor:om.eta.kout,tka 
#>                      0.252                       0.0621   
#>           cor:om.eta.e0,tka                  cor:tv,tcl 
#>                     0.0643                      -0.0527   
#>            cor:prop.err,tcl           cor:pkadd.err,tcl 
#>                      0.480                      -0.325  
#>               cor:temax,tcl               cor:tec50,tcl 
#>                    -0.0704                       -0.331  
#>               cor:tkout,tcl                 cor:te0,tcl 
#>                     -0.126                       -0.118   
#>           cor:pdadd.err,tcl          cor:om.eta.ktr,tcl 
#>                     0.0155                       -0.108   
#>           cor:om.eta.ka,tcl           cor:om.eta.cl,tcl 
#>                     -0.100                        0.338  
#>            cor:om.eta.v,tcl         cor:om.eta.emax,tcl 
#>                    -0.0752                       -0.166   
#>         cor:om.eta.ec50,tcl         cor:om.eta.kout,tcl 
#>                      0.133                      -0.0253   
#>           cor:om.eta.e0,tcl             cor:prop.err,tv 
#>                      0.180                       -0.679  
#>            cor:pkadd.err,tv                cor:temax,tv 
#>                      0.526                      -0.332  
#>                cor:tec50,tv                cor:tkout,tv 
#>                     -0.136                        0.144   
#>                  cor:te0,tv            cor:pdadd.err,tv 
#>                      0.190                      -0.0149   
#>           cor:om.eta.ktr,tv            cor:om.eta.ka,tv 
#>                      0.307                       0.361  
#>            cor:om.eta.cl,tv             cor:om.eta.v,tv 
#>                     -0.138                        0.177   
#>          cor:om.eta.emax,tv          cor:om.eta.ec50,tv 
#>                      0.123                     -0.00468   
#>          cor:om.eta.kout,tv            cor:om.eta.e0,tv 
#>                     -0.131                       -0.318  
#>      cor:pkadd.err,prop.err          cor:temax,prop.err 
#>                     -0.820                      0.0843   
#>          cor:tec50,prop.err          cor:tkout,prop.err 
#>                     -0.133                       -0.219   
#>            cor:te0,prop.err      cor:pdadd.err,prop.err 
#>                     -0.255                       0.0832   
#>     cor:om.eta.ktr,prop.err      cor:om.eta.ka,prop.err 
#>                     -0.290                       -0.325  
#>      cor:om.eta.cl,prop.err       cor:om.eta.v,prop.err 
#>                   -0.00251                       -0.232   
#>    cor:om.eta.emax,prop.err    cor:om.eta.ec50,prop.err 
#>                     -0.189                        0.313  
#>    cor:om.eta.kout,prop.err      cor:om.eta.e0,prop.err 
#>                      0.172                        0.174   
#>         cor:temax,pkadd.err         cor:tec50,pkadd.err 
#>                     -0.170                       0.0445   
#>         cor:tkout,pkadd.err           cor:te0,pkadd.err 
#>                      0.229                      -0.0462   
#>     cor:pdadd.err,pkadd.err    cor:om.eta.ktr,pkadd.err 
#>                     -0.172                        0.186   
#>     cor:om.eta.ka,pkadd.err     cor:om.eta.cl,pkadd.err 
#>                      0.215                       -0.121   
#>      cor:om.eta.v,pkadd.err   cor:om.eta.emax,pkadd.err 
#>                      0.284                        0.136   
#>   cor:om.eta.ec50,pkadd.err   cor:om.eta.kout,pkadd.err 
#>                     -0.421                      -0.202   
#>     cor:om.eta.e0,pkadd.err             cor:tec50,temax 
#>                     0.0963                        0.241   
#>             cor:tkout,temax               cor:te0,temax 
#>                     -0.205                      -0.0839   
#>         cor:pdadd.err,temax        cor:om.eta.ktr,temax 
#>                    -0.0306                     -0.00566   
#>         cor:om.eta.ka,temax         cor:om.eta.cl,temax 
#>                    -0.0409                      -0.0244   
#>          cor:om.eta.v,temax       cor:om.eta.emax,temax 
#>                     -0.250                      0.00412   
#>       cor:om.eta.ec50,temax       cor:om.eta.kout,temax 
#>                     -0.311                      0.0654   
#>         cor:om.eta.e0,temax             cor:tkout,tec50 
#>                      0.183                        0.502  
#>               cor:te0,tec50         cor:pdadd.err,tec50 
#>                    -0.0491                        0.520  
#>        cor:om.eta.ktr,tec50         cor:om.eta.ka,tec50 
#>                      0.136                       0.0511   
#>         cor:om.eta.cl,tec50          cor:om.eta.v,tec50 
#>                     0.0975                      0.00796   
#>       cor:om.eta.emax,tec50       cor:om.eta.ec50,tec50 
#>                     0.0387                       -0.270   
#>       cor:om.eta.kout,tec50         cor:om.eta.e0,tec50 
#>                      0.346                    -0.00458   
#>               cor:te0,tkout         cor:pdadd.err,tkout 
#>                      0.113                        0.296   
#>        cor:om.eta.ktr,tkout         cor:om.eta.ka,tkout 
#>                      0.284                        0.253   
#>         cor:om.eta.cl,tkout          cor:om.eta.v,tkout 
#>                    -0.0620                        0.104   
#>       cor:om.eta.emax,tkout       cor:om.eta.ec50,tkout 
#>                    -0.0670                       0.0809   
#>       cor:om.eta.kout,tkout         cor:om.eta.e0,tkout 
#>                      0.375                     -0.0567   
#>           cor:pdadd.err,te0          cor:om.eta.ktr,te0 
#>                    -0.0521                       -0.163   
#>           cor:om.eta.ka,te0           cor:om.eta.cl,te0 
#>                     -0.122                       -0.135   
#>            cor:om.eta.v,te0         cor:om.eta.emax,te0 
#>                     -0.187                        0.500  
#>         cor:om.eta.ec50,te0         cor:om.eta.kout,te0 
#>                      0.117                     -0.00648   
#>           cor:om.eta.e0,te0    cor:om.eta.ktr,pdadd.err 
#>                     -0.743                     -0.0803   
#>     cor:om.eta.ka,pdadd.err     cor:om.eta.cl,pdadd.err 
#>                     -0.121                        0.261   
#>      cor:om.eta.v,pdadd.err   cor:om.eta.emax,pdadd.err 
#>                    -0.0844                        0.153   
#>   cor:om.eta.ec50,pdadd.err   cor:om.eta.kout,pdadd.err 
#>                     0.0754                     -0.00114   
#>     cor:om.eta.e0,pdadd.err    cor:om.eta.ka,om.eta.ktr 
#>                     -0.216                        0.994  
#>    cor:om.eta.cl,om.eta.ktr     cor:om.eta.v,om.eta.ktr 
#>                    -0.0466                       -0.159   
#>  cor:om.eta.emax,om.eta.ktr  cor:om.eta.ec50,om.eta.ktr 
#>                     -0.695                     -0.0623   
#>  cor:om.eta.kout,om.eta.ktr    cor:om.eta.e0,om.eta.ktr 
#>                      0.107                        0.214   
#>     cor:om.eta.cl,om.eta.ka      cor:om.eta.v,om.eta.ka 
#>                    -0.0627                       -0.148   
#>   cor:om.eta.emax,om.eta.ka   cor:om.eta.ec50,om.eta.ka 
#>                     -0.659                     -0.0558   
#>   cor:om.eta.kout,om.eta.ka     cor:om.eta.e0,om.eta.ka 
#>                     0.0513                        0.169   
#>      cor:om.eta.v,om.eta.cl   cor:om.eta.emax,om.eta.cl 
#>                      0.294                       -0.148   
#>   cor:om.eta.ec50,om.eta.cl   cor:om.eta.kout,om.eta.cl 
#>                     -0.138                      -0.0679   
#>     cor:om.eta.e0,om.eta.cl    cor:om.eta.emax,om.eta.v 
#>                      0.281                        0.152   
#>    cor:om.eta.ec50,om.eta.v    cor:om.eta.kout,om.eta.v 
#>                    -0.0651                       -0.165   
#>      cor:om.eta.e0,om.eta.v cor:om.eta.ec50,om.eta.emax 
#>                      0.272                       -0.223   
#> cor:om.eta.kout,om.eta.emax   cor:om.eta.e0,om.eta.emax 
#>                     -0.315                      -0.676  
#> cor:om.eta.kout,om.eta.ec50   cor:om.eta.e0,om.eta.ec50 
#>                      0.251                       -0.195   
#>   cor:om.eta.e0,om.eta.kout 
#>                      0.112   
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
#>     IPRED relative difference compared to Nonmem IPRED: 0%; 95% percentile: (0%,0%); rtol=5.04e-06
#>     PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=5.37e-06
#>     IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (2.68e-06, 0.000454); atol=3.03e-05
#>     PRED absolute difference compared to Nonmem PRED: 95% percentile: (4.72e-07,0.00361); atol=5.37e-06
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
