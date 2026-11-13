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
#>         "IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (3.99e-06, 0.000497); atol=6.04e-05", 
#>         "PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=6.17e-06", 
#>         "PRED absolute difference compared to Nonmem PRED: 95% percentile: (3.79e-07,0.00318) atol=6.17e-06")
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
#>         "IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (3.99e-06, 0.000497); atol=6.04e-05", 
#>         "PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=6.17e-06", 
#>         "PRED absolute difference compared to Nonmem PRED: 95% percentile: (3.79e-07,0.00318) atol=6.17e-06")
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
#> elapsed 0.1081572       0.024 0.039    0.001 320.27      0.794
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
#>         "IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (3.99e-06, 0.000497); atol=6.04e-05", 
#>         "PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=6.17e-06", 
#>         "PRED absolute difference compared to Nonmem PRED: 95% percentile: (3.79e-07,0.00318) atol=6.17e-06")
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
#> [====|====|====|====|====|====|====|====|====|====] 0:00:30 
#> done
#> → Calculating residuals/tables
#> ✔ done

fit2
#> ── nlmixr² FOCEi (outer: bobyqa) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 1423.101 2340.796 2403.496      -1155.398         1386239        29190.88
#> 
#> ── Time (sec fit2$time): ──
#> 
#>           setup optimize covariance preprocess postprocess table compress
#> elapsed 1.92593 3.122661   15.18611      0.026       0.042 0.063    0.001
#>              other
#> elapsed 0.07329863
#> 
#> ── Population Parameters (fit2$parFixed or fit2$parFixedDf): ──
#> 
#>                Parameter   Est.     SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tktr            1 - tktr 0.0544  0.139   256      1.06 (0.804, 1.39)         
#> tka              2 - tka 0.0474  0.132   280      1.05 (0.809, 1.36)         
#> tcl              3 - tcl  -2.00 0.0530  2.66    0.136 (0.122, 0.151)     28.0
#> tv                4 - tv   2.06 0.0444  2.16       7.81 (7.16, 8.52)     23.3
#> prop.err    5 - prop.err  0.161 0.0322  20.0   0.161 (0.0977, 0.224)         
#> pkadd.err  6 - pkadd.err  0.581 0.0822  14.1    0.581 (0.420, 0.742)         
#> temax          7 - temax   7.84  0.493  6.28      1.00 (0.999, 1.00)         
#> tec50          8 - tec50  0.128 0.0924  72.4      1.14 (0.948, 1.36)     42.4
#> tkout          9 - tkout  -2.96 0.0237 0.799 0.0517 (0.0493, 0.0541)         
#> te0             10 - te0   4.57 0.0119 0.259       96.7 (94.5, 99.0)     5.19
#> pdadd.err 11 - pdadd.err   3.82  0.330  8.65       3.82 (3.17, 4.46)         
#>           Shrink(SD)%
#> tktr                 
#> tka                  
#> tcl             3.30 
#> tv              9.05 
#> prop.err             
#> pkadd.err            
#> temax                
#> tec50           7.03 
#> tkout                
#> te0             18.5 
#> pdadd.err            
#>  
#>   Covariance Type (fit2$covMethod): |r|,|s| (full)
#>     other calculated covs (setCov()): r; s; r,s; r (full); s (full)
#>   Some strong fixed parameter correlations exist (fit2$cor) :
#>                  cor:tka,tktr              cor:tcl,tktr               cor:tv,tktr 
#>                    0.997                    -0.175                   -0.00798   
#>         cor:prop.err,tktr        cor:pkadd.err,tktr            cor:temax,tktr 
#>                   -0.322                    0.0278                      0.308  
#>            cor:tec50,tktr            cor:tkout,tktr              cor:te0,tktr 
#>                   0.0375                     -0.111                      0.186   
#>        cor:pdadd.err,tktr        cor:om.eta.cl,tktr         cor:om.eta.v,tktr 
#>                  -0.0918                     -0.129                     -0.346  
#>      cor:om.eta.ec50,tktr        cor:om.eta.e0,tktr               cor:tcl,tka 
#>                  -0.0708                    -0.0666                     -0.180   
#>                cor:tv,tka          cor:prop.err,tka         cor:pkadd.err,tka 
#>                   0.0163                     -0.333                    0.0238   
#>             cor:temax,tka             cor:tec50,tka             cor:tkout,tka 
#>                    0.301                  -0.00212                     -0.143   
#>               cor:te0,tka         cor:pdadd.err,tka         cor:om.eta.cl,tka 
#>                    0.191                     -0.129                     -0.173   
#>          cor:om.eta.v,tka       cor:om.eta.ec50,tka         cor:om.eta.e0,tka 
#>                   -0.377                   -0.0503                    -0.0863   
#>                cor:tv,tcl          cor:prop.err,tcl         cor:pkadd.err,tcl 
#>                    0.399                     0.205                     0.0827   
#>             cor:temax,tcl             cor:tec50,tcl             cor:tkout,tcl 
#>                   -0.150                     -0.332                    0.0388   
#>               cor:te0,tcl         cor:pdadd.err,tcl         cor:om.eta.cl,tcl 
#>                  -0.0307                    -0.0539                      0.398  
#>          cor:om.eta.v,tcl       cor:om.eta.ec50,tcl         cor:om.eta.e0,tcl 
#>                    0.191                    -0.0422                      0.137   
#>           cor:prop.err,tv          cor:pkadd.err,tv              cor:temax,tv 
#>                   0.0367                     -0.531                    -0.308  
#>              cor:tec50,tv              cor:tkout,tv                cor:te0,tv 
#>                   -0.207                     0.0121                      0.121   
#>          cor:pdadd.err,tv          cor:om.eta.cl,tv           cor:om.eta.v,tv 
#>                   0.0478                     -0.194                     -0.130   
#>        cor:om.eta.ec50,tv          cor:om.eta.e0,tv    cor:pkadd.err,prop.err 
#>                    0.312                    -0.261                     -0.223   
#>        cor:temax,prop.err        cor:tec50,prop.err        cor:tkout,prop.err 
#>                    0.137                     -0.266                     0.0401   
#>          cor:te0,prop.err    cor:pdadd.err,prop.err    cor:om.eta.cl,prop.err 
#>                   -0.509                    -0.141                     -0.184   
#>     cor:om.eta.v,prop.err  cor:om.eta.ec50,prop.err    cor:om.eta.e0,prop.err 
#>                   -0.144                      0.139                      0.596  
#>       cor:temax,pkadd.err       cor:tec50,pkadd.err       cor:tkout,pkadd.err 
#>                    0.282                     0.0593                     0.0487   
#>         cor:te0,pkadd.err   cor:pdadd.err,pkadd.err   cor:om.eta.cl,pkadd.err 
#>                  -0.0638                     0.0356                      0.194   
#>    cor:om.eta.v,pkadd.err cor:om.eta.ec50,pkadd.err   cor:om.eta.e0,pkadd.err 
#>                    0.148                     -0.451                    0.0541   
#>           cor:tec50,temax           cor:tkout,temax             cor:te0,temax 
#>                    0.177                     -0.240                     -0.249   
#>       cor:pdadd.err,temax       cor:om.eta.cl,temax        cor:om.eta.v,temax 
#>                  -0.0293                    0.00644                     -0.261   
#>     cor:om.eta.ec50,temax       cor:om.eta.e0,temax           cor:tkout,tec50 
#>                   -0.401                     0.333                     0.538  
#>             cor:te0,tec50       cor:pdadd.err,tec50       cor:om.eta.cl,tec50 
#>                   0.0335                      0.639                    0.0494   
#>        cor:om.eta.v,tec50     cor:om.eta.ec50,tec50       cor:om.eta.e0,tec50 
#>                  -0.0702                     -0.294                     -0.131   
#>             cor:te0,tkout       cor:pdadd.err,tkout       cor:om.eta.cl,tkout 
#>                    0.112                      0.435                   -0.0280   
#>        cor:om.eta.v,tkout     cor:om.eta.ec50,tkout       cor:om.eta.e0,tkout 
#>                   0.0263                     0.0272                     -0.107   
#>         cor:pdadd.err,te0         cor:om.eta.cl,te0          cor:om.eta.v,te0 
#>                   0.0290                    0.00966                     -0.103   
#>       cor:om.eta.ec50,te0         cor:om.eta.e0,te0   cor:om.eta.cl,pdadd.err 
#>                    0.106                     -0.764                     0.168   
#>    cor:om.eta.v,pdadd.err cor:om.eta.ec50,pdadd.err   cor:om.eta.e0,pdadd.err 
#>                   -0.136                   -0.00383                     -0.251   
#>    cor:om.eta.v,om.eta.cl cor:om.eta.ec50,om.eta.cl   cor:om.eta.e0,om.eta.cl 
#>                    0.509                    -0.209                      0.124   
#>  cor:om.eta.ec50,om.eta.v    cor:om.eta.e0,om.eta.v cor:om.eta.e0,om.eta.ec50 
#>                  -0.0354                      0.205                     -0.119   
#>  
#> 
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance (fit2$omega) or correlation (fit2$omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in fit2$shrink 
#>   Information about run found (fit2$runInfo):
#>    • sandwich matrix corrected; compare it to $covR or $covS 
#>    • S matrix non-positive definite but corrected by S = sqrtm(S%*%S) 
#>    • R matrix non-positive definite but corrected by R = sqrtm(R%*%R) 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>   Censoring (fit2$censInformation): No censoring
#>   Minimization message (fit2$message):  
#>     Normal exit from bobyqa 
#> 
#> ── Fit Data (object fit2 is a modified tibble): ──
#> # A tibble: 483 × 33
#>   ID     TIME CMT      DV  PRED   RES  WRES IPRED   IRES IWRES CPRED  CRES CWRES
#>   <fct> <dbl> <fct> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 1       0.5 dcp     0    1.25 -1.25 -1.85 0.994 -0.994 -1.65  1.23 -1.23 -1.90
#> 2 1       1   dcp     1.9  3.61 -1.71 -1.47 2.85  -0.952 -1.29  3.52 -1.62 -1.65
#> 3 1       2   dcp     3.3  7.83 -4.53 -2.01 6.16  -2.86  -2.49  7.66 -4.36 -2.42
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
#> [====|====|====|====|====|====|====|====|====|====] 0:02:01
#> Warning: "r,s" not usable (S not PD); installed "r"
#> Warning: "r,s (full)" needs a positive-definite R; using "s (full)"
#> Updated original fit object fit
#>                      tktr           tka           tcl            tv
#> tktr         1.661327e+07 -1.661385e+07 -4.602139e+01 -2.416231e+02
#> tka         -1.661385e+07  1.661443e+07  4.599925e+01  2.416449e+02
#> tcl         -4.602139e+01  4.599925e+01  1.521005e-02 -1.499640e-02
#> tv          -2.416231e+02  2.416449e+02 -1.499640e-02  3.046547e-02
#> prop.err    -1.959983e+01  1.959890e+01 -1.040456e-03  3.167581e-03
#> pkadd.err   -2.340459e+02  2.340356e+02 -1.120394e-03  7.514071e-03
#> temax        5.855251e+03 -5.858850e+03 -1.833905e-01  4.641077e-01
#> tec50       -2.011988e+02  2.011929e+02 -6.800176e-03  2.161409e-02
#> tkout       -1.865482e+00  1.873706e+00 -1.136806e-03  1.759469e-03
#> te0         -7.947815e+00  7.950106e+00 -2.261003e-03  4.067810e-03
#> pdadd.err    2.246176e+02 -2.245944e+02  1.631689e-02 -3.881741e-02
#> om.eta.ktr   1.455094e+07 -1.455137e+07 -2.301892e+02  4.330720e+01
#> om.eta.ka   -1.456171e+07  1.456214e+07  2.303196e+02 -4.331860e+01
#> om.eta.cl   -3.936193e+01  3.936934e+01 -4.007056e-03  5.986105e-03
#> om.eta.v     8.676951e+01 -8.677476e+01  7.469665e-04 -3.144645e-03
#> om.eta.emax -1.443297e+04  1.443251e+04  2.904660e-02  5.274080e-01
#> om.eta.ec50 -4.535156e+01  4.535524e+01 -4.157254e-04  2.445818e-03
#> om.eta.kout  5.954054e+00 -5.954337e+00  6.212312e-05 -2.923561e-04
#> om.eta.e0    6.167947e+00 -6.167555e+00 -1.535312e-04  7.692036e-05
#>                  prop.err     pkadd.err         temax         tec50
#> tktr        -1.959983e+01 -2.340459e+02  5.855251e+03 -2.011988e+02
#> tka          1.959890e+01  2.340356e+02 -5.858850e+03  2.011929e+02
#> tcl         -1.040456e-03 -1.120394e-03 -1.833905e-01 -6.800176e-03
#> tv           3.167581e-03  7.514071e-03  4.641077e-01  2.161409e-02
#> prop.err     5.086600e-04  6.922582e-04  9.087845e-02  2.707232e-03
#> pkadd.err    6.922582e-04  8.312879e-03  4.539921e-01  7.481802e-03
#> temax        9.087845e-02  4.539921e-01  4.293574e+02  2.344647e+00
#> tec50        2.707232e-03  7.481802e-03  2.344647e+00  4.176385e-02
#> tkout        1.745926e-04 -1.131422e-03 -8.751566e-01 -4.200667e-03
#> te0          4.761171e-04  7.624206e-04 -5.339422e-03  2.141361e-03
#> pdadd.err   -4.419164e-03 -1.434610e-02 -2.467847e+00 -5.077772e-02
#> om.eta.ktr  -2.189627e+00 -1.427597e+02  8.423966e+03  2.475426e+01
#> om.eta.ka    2.189101e+00  1.428747e+02 -8.430061e+03 -2.476697e+01
#> om.eta.cl    5.796080e-04  1.458723e-03  1.492795e-01  4.293285e-03
#> om.eta.v    -3.579114e-04 -1.274241e-03  2.304716e-01 -1.564601e-03
#> om.eta.emax  7.676431e-02  3.503229e-01 -5.808656e+00  4.149264e-01
#> om.eta.ec50  3.118747e-04  1.503501e-03 -2.982997e-01  4.274825e-03
#> om.eta.kout -5.508487e-05 -9.313158e-06  6.173227e-03 -4.472683e-04
#> om.eta.e0    3.666983e-06 -1.459036e-04 -1.672302e-02 -6.997117e-05
#>                     tkout           te0     pdadd.err    om.eta.ktr
#> tktr        -1.865482e+00 -7.947815e+00  2.246176e+02  1.455094e+07
#> tka          1.873706e+00  7.950106e+00 -2.245944e+02 -1.455137e+07
#> tcl         -1.136806e-03 -2.261003e-03  1.631689e-02 -2.301892e+02
#> tv           1.759469e-03  4.067810e-03 -3.881741e-02  4.330720e+01
#> prop.err     1.745926e-04  4.761171e-04 -4.419164e-03 -2.189627e+00
#> pkadd.err   -1.131422e-03  7.624206e-04 -1.434610e-02 -1.427597e+02
#> temax       -8.751566e-01 -5.339422e-03 -2.467847e+00  8.423966e+03
#> tec50       -4.200667e-03  2.141361e-03 -5.077772e-02  2.475426e+01
#> tkout        3.267315e-03  3.842482e-04  5.414153e-04  9.609012e+00
#> te0          3.842482e-04  9.997654e-04 -4.078415e-03  3.134696e+01
#> pdadd.err    5.414153e-04 -4.078415e-03  1.118747e-01 -2.437510e+02
#> om.eta.ktr   9.609012e+00  3.134696e+01 -2.437510e+02  1.857440e+07
#> om.eta.ka   -9.627642e+00 -3.136385e+01  2.439678e+02 -1.858748e+07
#> om.eta.cl    1.802109e-04  7.051425e-04 -8.515962e-03  1.249565e+01
#> om.eta.v    -8.840081e-04 -3.423800e-04  4.452734e-03  6.884289e+01
#> om.eta.emax  7.154708e-02  6.905975e-02 -9.164255e-01 -9.774308e+03
#> om.eta.ec50  1.152077e-04  4.622594e-04 -7.488896e-03 -2.881658e+01
#> om.eta.kout -7.064924e-05 -4.301190e-05  2.869921e-04  5.709203e+00
#> om.eta.e0    5.502721e-05  4.553558e-05  4.964628e-05  6.616894e+00
#>                 om.eta.ka     om.eta.cl      om.eta.v   om.eta.emax
#> tktr        -1.456171e+07 -3.936193e+01  8.676951e+01 -1.443297e+04
#> tka          1.456214e+07  3.936934e+01 -8.677476e+01  1.443251e+04
#> tcl          2.303196e+02 -4.007056e-03  7.469665e-04  2.904660e-02
#> tv          -4.331860e+01  5.986105e-03 -3.144645e-03  5.274080e-01
#> prop.err     2.189101e+00  5.796080e-04 -3.579114e-04  7.676431e-02
#> pkadd.err    1.428747e+02  1.458723e-03 -1.274241e-03  3.503229e-01
#> temax       -8.430061e+03  1.492795e-01  2.304716e-01 -5.808656e+00
#> tec50       -2.476697e+01  4.293285e-03 -1.564601e-03  4.149264e-01
#> tkout       -9.627642e+00  1.802109e-04 -8.840081e-04  7.154708e-02
#> te0         -3.136385e+01  7.051425e-04 -3.423800e-04  6.905975e-02
#> pdadd.err    2.439678e+02 -8.515962e-03  4.452734e-03 -9.164255e-01
#> om.eta.ktr  -1.858748e+07  1.249565e+01  6.884289e+01 -9.774308e+03
#> om.eta.ka    1.860056e+07 -1.249250e+01 -6.888400e+01  9.779992e+03
#> om.eta.cl   -1.249250e+01  2.124630e-03 -7.028033e-04  5.348082e-02
#> om.eta.v    -6.888400e+01 -7.028033e-04  1.437032e-03 -1.337037e-01
#> om.eta.emax  9.779992e+03  5.348082e-02 -1.337037e-01  3.194234e+01
#> om.eta.ec50  2.883870e+01  1.027818e-03 -1.227427e-03  1.120483e-01
#> om.eta.kout -5.712353e+00 -4.135350e-05  9.669617e-05 -8.482385e-03
#> om.eta.e0   -6.621907e+00 -7.059320e-07 -3.330372e-06 -5.863393e-03
#>               om.eta.ec50   om.eta.kout     om.eta.e0
#> tktr        -4.535156e+01  5.954054e+00  6.167947e+00
#> tka          4.535524e+01 -5.954337e+00 -6.167555e+00
#> tcl         -4.157254e-04  6.212312e-05 -1.535312e-04
#> tv           2.445818e-03 -2.923561e-04  7.692036e-05
#> prop.err     3.118747e-04 -5.508487e-05  3.666983e-06
#> pkadd.err    1.503501e-03 -9.313158e-06 -1.459036e-04
#> temax       -2.982997e-01  6.173227e-03 -1.672302e-02
#> tec50        4.274825e-03 -4.472683e-04 -6.997117e-05
#> tkout        1.152077e-04 -7.064924e-05  5.502721e-05
#> te0          4.622594e-04 -4.301190e-05  4.553558e-05
#> pdadd.err   -7.488896e-03  2.869921e-04  4.964628e-05
#> om.eta.ktr  -2.881658e+01  5.709203e+00  6.616894e+00
#> om.eta.ka    2.883870e+01 -5.712353e+00 -6.621907e+00
#> om.eta.cl    1.027818e-03 -4.135350e-05 -7.059320e-07
#> om.eta.v    -1.227427e-03  9.669617e-05 -3.330372e-06
#> om.eta.emax  1.120483e-01 -8.482385e-03 -5.863393e-03
#> om.eta.ec50  8.640407e-03 -1.733480e-04  2.959452e-05
#> om.eta.kout -1.733480e-04  5.191728e-05 -4.572991e-06
#> om.eta.e0    2.959452e-05 -4.572991e-06  1.074596e-05
fit
#> ── nlmixr² nonmem2rx reading NONMEM ver 7.4.3 ──
#> 
#>              OBJF      AIC      BIC Log-likelihood Condition#(Cov)
#> nonmem2rx 1326.91 2252.605 2332.025      -1107.302    4.223493e+13
#>           Condition#(Cor)
#> nonmem2rx     10947926759
#> 
#> ── Time (sec fit$time): ──
#> 
#>             setup postprocess table compress NONMEM as.nlmixr2 covariance
#> elapsed 0.1081572       0.024 0.039    0.001 320.27      0.794    123.474
#> 
#> ── Population Parameters (fit$parFixed or fit$parFixedDf): ──
#> 
#>                Parameter     Est.     SE    %RSE Back-transformed(95%CI)
#> tktr            1 - tktr  6.24e-7   4080 6.53e11           1.00 (0, Inf)
#> tka              2 - tka -3.01e-6   4080 1.36e11           1.00 (0, Inf)
#> tcl              3 - tcl    -2.00  0.123    6.15    0.135 (0.106, 0.172)
#> tv                4 - tv     2.05  0.175    8.51       7.78 (5.53, 11.0)
#> prop.err    5 - prop.err   0.0986 0.0226    22.9  0.0986 (0.0544, 0.143)
#> pkadd.err  6 - pkadd.err    0.512 0.0912    17.8    0.512 (0.333, 0.690)
#> temax          7 - temax     6.42   20.7     323  0.998 (1.41e-15, 1.00)
#> tec50          8 - tec50    0.141  0.204     145      1.15 (0.771, 1.72)
#> tkout          9 - tkout    -2.95 0.0572    1.94 0.0522 (0.0466, 0.0583)
#> te0             10 - te0     4.57 0.0316   0.692        96.6 (90.8, 103)
#> pdadd.err 11 - pdadd.err     3.72  0.334    9.00       3.72 (3.06, 4.37)
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
#>                      -1.00                     -0.0916   
#>                 cor:tv,tktr           cor:prop.err,tktr 
#>                     -0.340                      -0.213   
#>          cor:pkadd.err,tktr              cor:temax,tktr 
#>                     -0.630                      0.0693   
#>              cor:tec50,tktr              cor:tkout,tktr 
#>                     -0.242                     -0.00801   
#>                cor:te0,tktr          cor:pdadd.err,tktr 
#>                    -0.0617                        0.165   
#>         cor:om.eta.ktr,tktr          cor:om.eta.ka,tktr 
#>                      0.828                      -0.828  
#>          cor:om.eta.cl,tktr           cor:om.eta.v,tktr 
#>                     -0.210                        0.562  
#>        cor:om.eta.emax,tktr        cor:om.eta.ec50,tktr 
#>                     -0.627                      -0.120   
#>        cor:om.eta.kout,tktr          cor:om.eta.e0,tktr 
#>                      0.203                        0.462  
#>                 cor:tcl,tka                  cor:tv,tka 
#>                     0.0915                        0.340  
#>            cor:prop.err,tka           cor:pkadd.err,tka 
#>                      0.213                        0.630  
#>               cor:temax,tka               cor:tec50,tka 
#>                    -0.0694                        0.242   
#>               cor:tkout,tka                 cor:te0,tka 
#>                    0.00804                       0.0617   
#>           cor:pdadd.err,tka          cor:om.eta.ktr,tka 
#>                     -0.165                       -0.828  
#>           cor:om.eta.ka,tka           cor:om.eta.cl,tka 
#>                      0.828                       0.210   
#>            cor:om.eta.v,tka         cor:om.eta.emax,tka 
#>                     -0.562                       0.626  
#>         cor:om.eta.ec50,tka         cor:om.eta.kout,tka 
#>                      0.120                       -0.203   
#>           cor:om.eta.e0,tka                  cor:tv,tcl 
#>                     -0.462                      -0.697  
#>            cor:prop.err,tcl           cor:pkadd.err,tcl 
#>                     -0.374                     -0.0996   
#>               cor:temax,tcl               cor:tec50,tcl 
#>                    -0.0718                       -0.270   
#>               cor:tkout,tcl                 cor:te0,tcl 
#>                     -0.161                       -0.580  
#>           cor:pdadd.err,tcl          cor:om.eta.ktr,tcl 
#>                      0.396                      -0.433  
#>           cor:om.eta.ka,tcl           cor:om.eta.cl,tcl 
#>                      0.433                      -0.705  
#>            cor:om.eta.v,tcl         cor:om.eta.emax,tcl 
#>                      0.160                       0.0417   
#>         cor:om.eta.ec50,tcl         cor:om.eta.kout,tcl 
#>                    -0.0363                       0.0699   
#>           cor:om.eta.e0,tcl             cor:prop.err,tv 
#>                     -0.380                       0.805  
#>            cor:pkadd.err,tv                cor:temax,tv 
#>                      0.472                       0.128   
#>                cor:tec50,tv                cor:tkout,tv 
#>                      0.606                       0.176   
#>                  cor:te0,tv            cor:pdadd.err,tv 
#>                      0.737                      -0.665  
#>           cor:om.eta.ktr,tv            cor:om.eta.ka,tv 
#>                     0.0576                      -0.0575   
#>            cor:om.eta.cl,tv             cor:om.eta.v,tv 
#>                      0.744                      -0.475  
#>          cor:om.eta.emax,tv          cor:om.eta.ec50,tv 
#>                      0.535                       0.151   
#>          cor:om.eta.kout,tv            cor:om.eta.e0,tv 
#>                     -0.232                        0.134   
#>      cor:pkadd.err,prop.err          cor:temax,prop.err 
#>                      0.337                       0.194   
#>          cor:tec50,prop.err          cor:tkout,prop.err 
#>                      0.587                       0.135   
#>            cor:te0,prop.err      cor:pdadd.err,prop.err 
#>                      0.668                      -0.586  
#>     cor:om.eta.ktr,prop.err      cor:om.eta.ka,prop.err 
#>                    -0.0225                       0.0225   
#>      cor:om.eta.cl,prop.err       cor:om.eta.v,prop.err 
#>                      0.558                      -0.419  
#>    cor:om.eta.emax,prop.err    cor:om.eta.ec50,prop.err 
#>                      0.602                       0.149   
#>    cor:om.eta.kout,prop.err      cor:om.eta.e0,prop.err 
#>                     -0.339                      0.0496   
#>         cor:temax,pkadd.err         cor:tec50,pkadd.err 
#>                      0.240                        0.402  
#>         cor:tkout,pkadd.err           cor:te0,pkadd.err 
#>                     -0.217                        0.264   
#>     cor:pdadd.err,pkadd.err    cor:om.eta.ktr,pkadd.err 
#>                     -0.470                      -0.363  
#>     cor:om.eta.ka,pkadd.err     cor:om.eta.cl,pkadd.err 
#>                      0.363                       0.347  
#>      cor:om.eta.v,pkadd.err   cor:om.eta.emax,pkadd.err 
#>                     -0.369                       0.680  
#>   cor:om.eta.ec50,pkadd.err   cor:om.eta.kout,pkadd.err 
#>                      0.177                      -0.0142   
#>     cor:om.eta.e0,pkadd.err             cor:tec50,temax 
#>                     -0.488                       0.554  
#>             cor:tkout,temax               cor:te0,temax 
#>                     -0.739                    -0.00815   
#>         cor:pdadd.err,temax        cor:om.eta.ktr,temax 
#>                     -0.356                      0.0943   
#>         cor:om.eta.ka,temax         cor:om.eta.cl,temax 
#>                    -0.0943                        0.156   
#>          cor:om.eta.v,temax       cor:om.eta.emax,temax 
#>                      0.293                      -0.0496   
#>       cor:om.eta.ec50,temax       cor:om.eta.kout,temax 
#>                     -0.155                       0.0413   
#>         cor:om.eta.e0,temax             cor:tkout,tec50 
#>                     -0.246                       -0.360  
#>               cor:te0,tec50         cor:pdadd.err,tec50 
#>                      0.331                      -0.743  
#>        cor:om.eta.ktr,tec50         cor:om.eta.ka,tec50 
#>                     0.0281                      -0.0281   
#>         cor:om.eta.cl,tec50          cor:om.eta.v,tec50 
#>                      0.456                      -0.202   
#>       cor:om.eta.emax,tec50       cor:om.eta.ec50,tec50 
#>                      0.359                       0.225   
#>       cor:om.eta.kout,tec50         cor:om.eta.e0,tec50 
#>                     -0.304                      -0.104   
#>               cor:te0,tkout         cor:pdadd.err,tkout 
#>                      0.213                       0.0283   
#>        cor:om.eta.ktr,tkout         cor:om.eta.ka,tkout 
#>                     0.0390                      -0.0391   
#>         cor:om.eta.cl,tkout          cor:om.eta.v,tkout 
#>                     0.0684                       -0.408  
#>       cor:om.eta.emax,tkout       cor:om.eta.ec50,tkout 
#>                      0.221                       0.0217   
#>       cor:om.eta.kout,tkout         cor:om.eta.e0,tkout 
#>                     -0.172                        0.294   
#>           cor:pdadd.err,te0          cor:om.eta.ktr,te0 
#>                     -0.386                       0.230   
#>           cor:om.eta.ka,te0           cor:om.eta.cl,te0 
#>                     -0.230                        0.484  
#>            cor:om.eta.v,te0         cor:om.eta.emax,te0 
#>                     -0.286                        0.386  
#>         cor:om.eta.ec50,te0         cor:om.eta.kout,te0 
#>                      0.157                       -0.189   
#>           cor:om.eta.e0,te0    cor:om.eta.ktr,pdadd.err 
#>                      0.439                      -0.169   
#>     cor:om.eta.ka,pdadd.err     cor:om.eta.cl,pdadd.err 
#>                      0.169                       -0.552  
#>      cor:om.eta.v,pdadd.err   cor:om.eta.emax,pdadd.err 
#>                      0.351                      -0.485  
#>   cor:om.eta.ec50,pdadd.err   cor:om.eta.kout,pdadd.err 
#>                     -0.241                        0.119   
#>     cor:om.eta.e0,pdadd.err    cor:om.eta.ka,om.eta.ktr 
#>                     0.0453                        -1.00  
#>    cor:om.eta.cl,om.eta.ktr     cor:om.eta.v,om.eta.ktr 
#>                     0.0629                        0.421  
#>  cor:om.eta.emax,om.eta.ktr  cor:om.eta.ec50,om.eta.ktr 
#>                     -0.401                     -0.0719   
#>  cor:om.eta.kout,om.eta.ktr    cor:om.eta.e0,om.eta.ktr 
#>                      0.184                        0.468  
#>     cor:om.eta.cl,om.eta.ka      cor:om.eta.v,om.eta.ka 
#>                    -0.0628                       -0.421  
#>   cor:om.eta.emax,om.eta.ka   cor:om.eta.ec50,om.eta.ka 
#>                      0.401                      0.0719   
#>   cor:om.eta.kout,om.eta.ka     cor:om.eta.e0,om.eta.ka 
#>                     -0.184                       -0.468  
#>      cor:om.eta.v,om.eta.cl   cor:om.eta.emax,om.eta.cl 
#>                     -0.402                       0.205   
#>   cor:om.eta.ec50,om.eta.cl   cor:om.eta.kout,om.eta.cl 
#>                      0.240                       -0.125   
#>     cor:om.eta.e0,om.eta.cl    cor:om.eta.emax,om.eta.v 
#>                   -0.00467                       -0.624  
#>    cor:om.eta.ec50,om.eta.v    cor:om.eta.kout,om.eta.v 
#>                     -0.348                       0.354  
#>      cor:om.eta.e0,om.eta.v cor:om.eta.ec50,om.eta.emax 
#>                    -0.0268                        0.213   
#> cor:om.eta.kout,om.eta.emax   cor:om.eta.e0,om.eta.emax 
#>                     -0.208                       -0.316  
#> cor:om.eta.kout,om.eta.ec50   cor:om.eta.e0,om.eta.ec50 
#>                     -0.259                       0.0971   
#>   cor:om.eta.e0,om.eta.kout 
#>                     -0.194   
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
