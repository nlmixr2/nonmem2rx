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
#> ℹ observations with CMT=0 use the $MODEL DEFOBS compartment (1)
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
#> elapsed 0.1173151       0.019 0.039    0.001 320.27      0.716
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
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:21 
#> done
#> → Calculating residuals/tables
#> ✔ done

fit2
#> ── nlmixr² FOCEi (outer: bobyqa) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 1423.072 2340.767 2403.467      -1155.383         1722197        1552.384
#> 
#> ── Time (sec fit2$time): ──
#> 
#>            setup optimize covariance preprocess postprocess table compress
#> elapsed 1.708729 2.162952   10.96781      0.021       0.037 0.045    0.001
#>             other
#> elapsed 0.0625063
#> 
#> ── Population Parameters (fit2$parFixed or fit2$parFixedDf): ──
#> 
#>                Parameter   Est.     SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tktr            1 - tktr 0.0398  0.126   317      1.04 (0.813, 1.33)         
#> tka              2 - tka 0.0647  0.145   224      1.07 (0.802, 1.42)         
#> tcl              3 - tcl  -2.00 0.0532  2.66    0.136 (0.122, 0.151)     27.8
#> tv                4 - tv   2.06 0.0445  2.16       7.81 (7.16, 8.52)     23.4
#> prop.err    5 - prop.err  0.161 0.0320  19.9   0.161 (0.0982, 0.224)         
#> pkadd.err  6 - pkadd.err  0.584 0.0815  14.0    0.584 (0.424, 0.743)         
#> temax          7 - temax   8.41  0.498  5.92      1.00 (0.999, 1.00)         
#> tec50          8 - tec50  0.129 0.0925  71.9      1.14 (0.949, 1.36)     42.6
#> tkout          9 - tkout  -2.96 0.0236 0.797 0.0516 (0.0493, 0.0541)         
#> te0             10 - te0   4.57 0.0118 0.259       96.7 (94.5, 99.0)     5.16
#> pdadd.err 11 - pdadd.err   3.81  0.330  8.64       3.81 (3.17, 4.46)         
#>           Shrink(SD)%
#> tktr                 
#> tka                  
#> tcl             2.89 
#> tv              9.23 
#> prop.err             
#> pkadd.err            
#> temax                
#> tec50           7.44 
#> tkout                
#> te0             18.4 
#> pdadd.err            
#>  
#>   Covariance Type (fit2$covMethod): |r|,|s| (full)
#>     other calculated covs (setCov()): r; s; r,s; r (full); s (full)
#>   Some strong fixed parameter correlations exist (fit2$cor) :
#>                  cor:tka,tktr              cor:tcl,tktr               cor:tv,tktr 
#>                    0.989                    -0.149                   -0.00552   
#>         cor:prop.err,tktr        cor:pkadd.err,tktr            cor:temax,tktr 
#>                   -0.268                    -0.0224                      0.437  
#>            cor:tec50,tktr            cor:tkout,tktr              cor:te0,tktr 
#>                -0.000862                     -0.136                      0.155   
#>        cor:pdadd.err,tktr        cor:om.eta.cl,tktr         cor:om.eta.v,tktr 
#>                   -0.108                     -0.135                     -0.381  
#>      cor:om.eta.ec50,tktr        cor:om.eta.e0,tktr               cor:tcl,tka 
#>                  -0.0460                    -0.0290                     -0.209   
#>                cor:tv,tka          cor:prop.err,tka         cor:pkadd.err,tka 
#>                 -0.00518                     -0.346                    0.0143   
#>             cor:temax,tka             cor:tec50,tka             cor:tkout,tka 
#>                    0.429                    0.0485                     -0.111   
#>               cor:te0,tka         cor:pdadd.err,tka         cor:om.eta.cl,tka 
#>                    0.209                     -0.102                     -0.160   
#>          cor:om.eta.v,tka       cor:om.eta.ec50,tka         cor:om.eta.e0,tka 
#>                   -0.346                   -0.0716                    -0.0798   
#>                cor:tv,tcl          cor:prop.err,tcl         cor:pkadd.err,tcl 
#>                    0.401                     0.208                     0.0871   
#>             cor:temax,tcl             cor:tec50,tcl             cor:tkout,tcl 
#>                   -0.179                     -0.336                    0.0376   
#>               cor:te0,tcl         cor:pdadd.err,tcl         cor:om.eta.cl,tcl 
#>                  -0.0326                    -0.0548                      0.397  
#>          cor:om.eta.v,tcl       cor:om.eta.ec50,tcl         cor:om.eta.e0,tcl 
#>                    0.192                    -0.0468                      0.136   
#>           cor:prop.err,tv          cor:pkadd.err,tv              cor:temax,tv 
#>                   0.0459                     -0.532                    -0.291   
#>              cor:tec50,tv              cor:tkout,tv                cor:te0,tv 
#>                   -0.212                     0.0101                      0.116   
#>          cor:pdadd.err,tv          cor:om.eta.cl,tv           cor:om.eta.v,tv 
#>                   0.0450                     -0.194                     -0.124   
#>        cor:om.eta.ec50,tv          cor:om.eta.e0,tv    cor:pkadd.err,prop.err 
#>                    0.308                    -0.260                     -0.207   
#>        cor:temax,prop.err        cor:tec50,prop.err        cor:tkout,prop.err 
#>                   0.0957                     -0.270                     0.0418   
#>          cor:te0,prop.err    cor:pdadd.err,prop.err    cor:om.eta.cl,prop.err 
#>                   -0.508                    -0.142                     -0.186   
#>     cor:om.eta.v,prop.err  cor:om.eta.ec50,prop.err    cor:om.eta.e0,prop.err 
#>                   -0.145                      0.132                      0.589  
#>       cor:temax,pkadd.err       cor:tec50,pkadd.err       cor:tkout,pkadd.err 
#>                    0.245                     0.0556                     0.0540   
#>         cor:te0,pkadd.err   cor:pdadd.err,pkadd.err   cor:om.eta.cl,pkadd.err 
#>                  -0.0753                     0.0385                      0.195   
#>    cor:om.eta.v,pkadd.err cor:om.eta.ec50,pkadd.err   cor:om.eta.e0,pkadd.err 
#>                    0.150                     -0.442                    0.0678   
#>           cor:tec50,temax           cor:tkout,temax             cor:te0,temax 
#>                    0.165                     -0.240                     -0.214   
#>       cor:pdadd.err,temax       cor:om.eta.cl,temax        cor:om.eta.v,temax 
#>                  -0.0534                    -0.0290                     -0.281   
#>     cor:om.eta.ec50,temax       cor:om.eta.e0,temax           cor:tkout,tec50 
#>                   -0.377                     0.323                     0.539  
#>             cor:te0,tec50       cor:pdadd.err,tec50       cor:om.eta.cl,tec50 
#>                   0.0352                      0.638                    0.0486   
#>        cor:om.eta.v,tec50     cor:om.eta.ec50,tec50       cor:om.eta.e0,tec50 
#>                  -0.0739                     -0.290                     -0.129   
#>             cor:te0,tkout       cor:pdadd.err,tkout       cor:om.eta.cl,tkout 
#>                    0.110                      0.434                   -0.0280   
#>        cor:om.eta.v,tkout     cor:om.eta.ec50,tkout       cor:om.eta.e0,tkout 
#>                   0.0237                     0.0230                     -0.104   
#>         cor:pdadd.err,te0         cor:om.eta.cl,te0          cor:om.eta.v,te0 
#>                   0.0279                    0.00971                     -0.103   
#>       cor:om.eta.ec50,te0         cor:om.eta.e0,te0   cor:om.eta.cl,pdadd.err 
#>                    0.109                     -0.762                     0.167   
#>    cor:om.eta.v,pdadd.err cor:om.eta.ec50,pdadd.err   cor:om.eta.e0,pdadd.err 
#>                   -0.140                   -0.00532                     -0.250   
#>    cor:om.eta.v,om.eta.cl cor:om.eta.ec50,om.eta.cl   cor:om.eta.e0,om.eta.cl 
#>                    0.506                    -0.211                      0.126   
#>  cor:om.eta.ec50,om.eta.v    cor:om.eta.e0,om.eta.v cor:om.eta.e0,om.eta.ec50 
#>                  -0.0328                      0.204                     -0.128   
#>  
#> 
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance (fit2$omega) or correlation (fit2$omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in fit2$shrink 
#>   Information about run found (fit2$runInfo):
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
#> 1 1       0.5 dcp     0    1.26 -1.26 -1.84 0.996 -0.996 -1.65  1.23 -1.23 -1.90
#> 2 1       1   dcp     1.9  3.61 -1.71 -1.47 2.86  -0.957 -1.29  3.53 -1.63 -1.65
#> 3 1       2   dcp     3.3  7.84 -4.54 -2.01 6.17  -2.87  -2.49  7.66 -4.36 -2.42
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
#> [====|====|====|====|====|====|====|====|====|====] 0:01:49
#> Warning: "r,s" not usable (sandwich doubtful); installed "r"
#> Updated original fit object fit
#>                      tktr           tka           tcl            tv
#> tktr         1.161370e-01  1.161784e-01  7.233331e-03 -1.424628e-02
#> tka          1.161784e-01  1.162258e-01  7.254061e-03 -1.424507e-02
#> tcl          7.233331e-03  7.254061e-03  3.440728e-03 -2.028407e-04
#> tv          -1.424628e-02 -1.424507e-02 -2.028407e-04  3.410010e-03
#> prop.err     7.594787e-03  7.609545e-03  7.449167e-04 -1.037730e-03
#> pkadd.err   -6.643520e-02 -6.658359e-02 -4.568194e-03  7.259669e-03
#> temax        3.826782e-02  3.810781e-02 -3.267605e-03 -8.335324e-03
#> tec50       -2.430673e-03 -2.496724e-03 -1.739074e-03 -7.519791e-04
#> tkout       -2.786143e-03 -2.779347e-03 -1.788856e-04  1.977709e-04
#> te0         -5.912558e-04 -5.895801e-04 -8.498603e-05  1.312103e-04
#> pdadd.err    1.131070e-02  1.109724e-02  2.820960e-04 -2.781988e-04
#> om.eta.ktr  -4.694672e-02 -4.672466e-02 -1.754918e-03  5.926099e-03
#> om.eta.ka   -4.697721e-02 -4.672811e-02 -1.690611e-03  5.988940e-03
#> om.eta.cl    3.748520e-04  3.594761e-04  4.473161e-04 -1.795332e-04
#> om.eta.v    -7.467170e-04 -7.621411e-04 -5.331824e-05  1.280128e-04
#> om.eta.emax -1.533020e-05 -1.507825e-05  1.443385e-06  7.004834e-06
#> om.eta.ec50  3.906360e-03  3.970848e-03  3.668623e-04 -7.506830e-06
#> om.eta.kout  2.494904e-04  2.576575e-04  8.198417e-06 -5.380877e-05
#> om.eta.e0    2.258613e-05  2.255651e-05  1.033845e-05 -1.766507e-05
#>                  prop.err     pkadd.err         temax         tec50
#> tktr         7.594787e-03 -6.643520e-02  3.826782e-02 -2.430673e-03
#> tka          7.609545e-03 -6.658359e-02  3.810781e-02 -2.496724e-03
#> tcl          7.449167e-04 -4.568194e-03 -3.267605e-03 -1.739074e-03
#> tv          -1.037730e-03  7.259669e-03 -8.335324e-03 -7.519791e-04
#> prop.err     6.821831e-04 -5.038815e-03  2.596891e-04 -2.848980e-04
#> pkadd.err   -5.038815e-03  5.487871e-02 -1.189142e-02  8.204657e-04
#> temax        2.596891e-04 -1.189142e-02  2.200705e-01  1.381360e-02
#> tec50       -2.848980e-04  8.204657e-04  1.381360e-02  8.173382e-03
#> tkout       -1.297532e-04  1.275223e-03 -1.772714e-03  1.166812e-03
#> te0         -7.951699e-05 -1.193547e-04 -7.510530e-04 -4.784036e-05
#> pdadd.err    7.448356e-04 -1.429033e-02 -8.698114e-04  1.736305e-02
#> om.eta.ktr  -2.387258e-03  1.453681e-02  9.310183e-03  1.155579e-03
#> om.eta.ka   -2.345137e-03  1.406989e-02  8.025076e-03  7.467251e-04
#> om.eta.cl   -3.103002e-06 -6.148344e-04 -4.238906e-05  1.946383e-04
#> om.eta.v    -7.525701e-05  8.409770e-04 -1.248577e-03  3.465350e-05
#> om.eta.emax -1.579304e-06  3.864264e-06 -3.535260e-05 -2.032010e-05
#> om.eta.ec50  3.667813e-04 -4.433852e-03 -7.603589e-03 -1.203092e-03
#> om.eta.kout  3.588062e-05 -3.272507e-04  1.258649e-04  1.303948e-04
#> om.eta.e0    4.283713e-06  2.356456e-05  1.108896e-04 -1.568744e-06
#>                     tkout           te0     pdadd.err    om.eta.ktr
#> tktr        -2.786143e-03 -5.912558e-04  1.131070e-02 -4.694672e-02
#> tka         -2.779347e-03 -5.895801e-04  1.109724e-02 -4.672466e-02
#> tcl         -1.788856e-04 -8.498603e-05  2.820960e-04 -1.754918e-03
#> tv           1.977709e-04  1.312103e-04 -2.781988e-04  5.926099e-03
#> prop.err    -1.297532e-04 -7.951699e-05  7.448356e-04 -2.387258e-03
#> pkadd.err    1.275223e-03 -1.193547e-04 -1.429033e-02  1.453681e-02
#> temax       -1.772714e-03 -7.510530e-04 -8.698114e-04  9.310183e-03
#> tec50        1.166812e-03 -4.784036e-05  1.736305e-02  1.155579e-03
#> tkout        6.770531e-04  3.296188e-05  2.807441e-03  1.934877e-03
#> te0          3.296188e-05  1.412530e-04 -2.462197e-04 -4.749483e-04
#> pdadd.err    2.807441e-03 -2.462197e-04  1.339923e-01 -1.268257e-02
#> om.eta.ktr   1.934877e-03 -4.749483e-04 -1.268257e-02  8.642113e-02
#> om.eta.ka    1.958104e-03 -4.517978e-04 -1.394824e-02  8.696388e-02
#> om.eta.cl   -4.264909e-05 -3.604806e-05  2.202643e-03 -4.960540e-04
#> om.eta.v     3.470873e-05 -3.225180e-05 -3.448092e-04 -4.610384e-04
#> om.eta.emax -3.090581e-06  9.661479e-07 -2.431409e-05  9.723530e-06
#> om.eta.ec50  9.103128e-05  6.815958e-05  1.130868e-03 -1.246263e-03
#> om.eta.kout  4.420724e-05 -1.748193e-06 -3.241685e-05  6.421451e-05
#> om.eta.e0   -1.357739e-06 -8.466892e-06 -7.339928e-05  4.579434e-05
#>                 om.eta.ka     om.eta.cl      om.eta.v   om.eta.emax
#> tktr        -4.697721e-02  3.748520e-04 -7.467170e-04 -1.533020e-05
#> tka         -4.672811e-02  3.594761e-04 -7.621411e-04 -1.507825e-05
#> tcl         -1.690611e-03  4.473161e-04 -5.331824e-05  1.443385e-06
#> tv           5.988940e-03 -1.795332e-04  1.280128e-04  7.004834e-06
#> prop.err    -2.345137e-03 -3.103002e-06 -7.525701e-05 -1.579304e-06
#> pkadd.err    1.406989e-02 -6.148344e-04  8.409770e-04  3.864264e-06
#> temax        8.025076e-03 -4.238906e-05 -1.248577e-03 -3.535260e-05
#> tec50        7.467251e-04  1.946383e-04  3.465350e-05 -2.032010e-05
#> tkout        1.958104e-03 -4.264909e-05  3.470873e-05 -3.090581e-06
#> te0         -4.517978e-04 -3.604806e-05 -3.225180e-05  9.661479e-07
#> pdadd.err   -1.394824e-02  2.202643e-03 -3.448092e-04 -2.431409e-05
#> om.eta.ktr   8.696388e-02 -4.960540e-04 -4.610384e-04  9.723530e-06
#> om.eta.ka    8.763982e-02 -5.810782e-04 -5.239121e-04  1.126968e-05
#> om.eta.cl   -5.810782e-04  5.158956e-04  9.209078e-05 -8.211953e-07
#> om.eta.v    -5.239121e-04  9.209078e-05  1.693764e-04 -7.874029e-07
#> om.eta.emax  1.126968e-05 -8.211953e-07 -7.874029e-07  7.952941e-08
#> om.eta.ec50 -9.051197e-04 -1.468285e-04 -3.227488e-05  5.636577e-06
#> om.eta.kout  9.996865e-05 -1.173449e-05 -1.281969e-05 -4.274223e-07
#> om.eta.e0    4.448749e-05  6.012552e-06  3.921909e-06 -9.338555e-08
#>               om.eta.ec50   om.eta.kout     om.eta.e0
#> tktr         3.906360e-03  2.494904e-04  2.258613e-05
#> tka          3.970848e-03  2.576575e-04  2.255651e-05
#> tcl          3.668623e-04  8.198417e-06  1.033845e-05
#> tv          -7.506830e-06 -5.380877e-05 -1.766507e-05
#> prop.err     3.667813e-04  3.588062e-05  4.283713e-06
#> pkadd.err   -4.433852e-03 -3.272507e-04  2.356456e-05
#> temax       -7.603589e-03  1.258649e-04  1.108896e-04
#> tec50       -1.203092e-03  1.303948e-04 -1.568744e-06
#> tkout        9.103128e-05  4.420724e-05 -1.357739e-06
#> te0          6.815958e-05 -1.748193e-06 -8.466892e-06
#> pdadd.err    1.130868e-03 -3.241685e-05 -7.339928e-05
#> om.eta.ktr  -1.246263e-03  6.421451e-05  4.579434e-05
#> om.eta.ka   -9.051197e-04  9.996865e-05  4.448749e-05
#> om.eta.cl   -1.468285e-04 -1.173449e-05  6.012552e-06
#> om.eta.v    -3.227488e-05 -1.281969e-05  3.921909e-06
#> om.eta.emax  5.636577e-06 -4.274223e-07 -9.338555e-08
#> om.eta.ec50  2.090969e-03  5.950018e-05 -9.139937e-06
#> om.eta.kout  5.950018e-05  2.390977e-05  4.983828e-07
#> om.eta.e0   -9.139937e-06  4.983828e-07  9.185209e-07
fit
#> ── nlmixr² nonmem2rx reading NONMEM ver 7.4.3 ──
#> 
#>              OBJF      AIC      BIC Log-likelihood Condition#(Cov)
#> nonmem2rx 1326.91 2252.605 2332.025      -1107.302     7.18696e+11
#>           Condition#(Cor)
#> nonmem2rx      9189297094
#> 
#> ── Time (sec fit$time): ──
#> 
#>             setup postprocess table compress NONMEM as.nlmixr2 covariance
#> elapsed 0.1173151       0.019 0.039    0.001 320.27      0.716    110.651
#> 
#> ── Population Parameters (fit$parFixed or fit$parFixedDf): ──
#> 
#>                Parameter     Est.     SE   %RSE Back-transformed(95%CI)
#> tktr            1 - tktr  6.24e-7  0.341 5.46e7      1.00 (0.513, 1.95)
#> tka              2 - tka -3.01e-6  0.341 1.13e7      1.00 (0.513, 1.95)
#> tcl              3 - tcl    -2.00 0.0587   2.93    0.135 (0.120, 0.151)
#> tv                4 - tv     2.05 0.0584   2.85       7.78 (6.94, 8.73)
#> prop.err    5 - prop.err   0.0986 0.0261   26.5  0.0986 (0.0474, 0.150)
#> pkadd.err  6 - pkadd.err    0.512  0.234   45.8   0.512 (0.0525, 0.971)
#> temax          7 - temax     6.42  0.469   7.31    0.998 (0.996, 0.999)
#> tec50          8 - tec50    0.141 0.0904   64.2      1.15 (0.964, 1.37)
#> tkout          9 - tkout    -2.95 0.0260  0.881 0.0522 (0.0496, 0.0549)
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
#>                       1.00                       0.362  
#>                 cor:tv,tktr           cor:prop.err,tktr 
#>                     -0.716                       0.853  
#>          cor:pkadd.err,tktr              cor:temax,tktr 
#>                     -0.832                       0.239   
#>              cor:tec50,tktr              cor:tkout,tktr 
#>                    -0.0789                       -0.314  
#>                cor:te0,tktr          cor:pdadd.err,tktr 
#>                     -0.146                       0.0907   
#>         cor:om.eta.ktr,tktr          cor:om.eta.ka,tktr 
#>                     -0.469                      -0.466  
#>          cor:om.eta.cl,tktr           cor:om.eta.v,tktr 
#>                     0.0484                       -0.168   
#>        cor:om.eta.emax,tktr        cor:om.eta.ec50,tktr 
#>                     -0.160                        0.251   
#>        cor:om.eta.kout,tktr          cor:om.eta.e0,tktr 
#>                      0.150                       0.0692   
#>                 cor:tcl,tka                  cor:tv,tka 
#>                      0.363                      -0.716  
#>            cor:prop.err,tka           cor:pkadd.err,tka 
#>                      0.855                      -0.834  
#>               cor:temax,tka               cor:tec50,tka 
#>                      0.238                      -0.0810   
#>               cor:tkout,tka                 cor:te0,tka 
#>                     -0.313                      -0.146   
#>           cor:pdadd.err,tka          cor:om.eta.ktr,tka 
#>                     0.0889                       -0.466  
#>           cor:om.eta.ka,tka           cor:om.eta.cl,tka 
#>                     -0.463                      0.0464   
#>            cor:om.eta.v,tka         cor:om.eta.emax,tka 
#>                     -0.172                       -0.157   
#>         cor:om.eta.ec50,tka         cor:om.eta.kout,tka 
#>                      0.255                        0.155   
#>           cor:om.eta.e0,tka                  cor:tv,tcl 
#>                     0.0690                      -0.0592   
#>            cor:prop.err,tcl           cor:pkadd.err,tcl 
#>                      0.486                      -0.332  
#>               cor:temax,tcl               cor:tec50,tcl 
#>                     -0.119                       -0.328  
#>               cor:tkout,tcl                 cor:te0,tcl 
#>                     -0.117                       -0.122   
#>           cor:pdadd.err,tcl          cor:om.eta.ktr,tcl 
#>                     0.0131                       -0.102   
#>           cor:om.eta.ka,tcl           cor:om.eta.cl,tcl 
#>                    -0.0974                        0.336  
#>            cor:om.eta.v,tcl         cor:om.eta.emax,tcl 
#>                    -0.0698                       0.0873   
#>         cor:om.eta.ec50,tcl         cor:om.eta.kout,tcl 
#>                      0.137                       0.0286   
#>           cor:om.eta.e0,tcl             cor:prop.err,tv 
#>                      0.184                       -0.680  
#>            cor:pkadd.err,tv                cor:temax,tv 
#>                      0.531                      -0.304  
#>                cor:tec50,tv                cor:tkout,tv 
#>                     -0.142                        0.130   
#>                  cor:te0,tv            cor:pdadd.err,tv 
#>                      0.189                      -0.0130   
#>           cor:om.eta.ktr,tv            cor:om.eta.ka,tv 
#>                      0.345                       0.346  
#>            cor:om.eta.cl,tv             cor:om.eta.v,tv 
#>                     -0.135                        0.168   
#>          cor:om.eta.emax,tv          cor:om.eta.ec50,tv 
#>                      0.425                    -0.00281   
#>          cor:om.eta.kout,tv            cor:om.eta.e0,tv 
#>                     -0.188                       -0.316  
#>      cor:pkadd.err,prop.err          cor:temax,prop.err 
#>                     -0.824                      0.0212   
#>          cor:tec50,prop.err          cor:tkout,prop.err 
#>                     -0.121                       -0.191   
#>            cor:te0,prop.err      cor:pdadd.err,prop.err 
#>                     -0.256                       0.0779   
#>     cor:om.eta.ktr,prop.err      cor:om.eta.ka,prop.err 
#>                     -0.311                      -0.303  
#>      cor:om.eta.cl,prop.err       cor:om.eta.v,prop.err 
#>                   -0.00523                       -0.221   
#>    cor:om.eta.emax,prop.err    cor:om.eta.ec50,prop.err 
#>                     -0.214                        0.307  
#>    cor:om.eta.kout,prop.err      cor:om.eta.e0,prop.err 
#>                      0.281                        0.171   
#>         cor:temax,pkadd.err         cor:tec50,pkadd.err 
#>                     -0.108                       0.0387   
#>         cor:tkout,pkadd.err           cor:te0,pkadd.err 
#>                      0.209                      -0.0429   
#>     cor:pdadd.err,pkadd.err    cor:om.eta.ktr,pkadd.err 
#>                     -0.167                        0.211   
#>     cor:om.eta.ka,pkadd.err     cor:om.eta.cl,pkadd.err 
#>                      0.203                       -0.116   
#>      cor:om.eta.v,pkadd.err   cor:om.eta.emax,pkadd.err 
#>                      0.276                       0.0585   
#>   cor:om.eta.ec50,pkadd.err   cor:om.eta.kout,pkadd.err 
#>                     -0.414                      -0.286   
#>     cor:om.eta.e0,pkadd.err             cor:tec50,temax 
#>                      0.105                        0.326  
#>             cor:tkout,temax               cor:te0,temax 
#>                     -0.145                       -0.135   
#>         cor:pdadd.err,temax        cor:om.eta.ktr,temax 
#>                   -0.00507                       0.0675   
#>         cor:om.eta.ka,temax         cor:om.eta.cl,temax 
#>                     0.0578                     -0.00398   
#>          cor:om.eta.v,temax       cor:om.eta.emax,temax 
#>                     -0.205                       -0.267   
#>       cor:om.eta.ec50,temax       cor:om.eta.kout,temax 
#>                     -0.354                      0.0549   
#>         cor:om.eta.e0,temax             cor:tkout,tec50 
#>                      0.247                        0.496  
#>               cor:te0,tec50         cor:pdadd.err,tec50 
#>                    -0.0445                        0.525  
#>        cor:om.eta.ktr,tec50         cor:om.eta.ka,tec50 
#>                     0.0435                       0.0279   
#>         cor:om.eta.cl,tec50          cor:om.eta.v,tec50 
#>                     0.0948                       0.0295   
#>       cor:om.eta.emax,tec50       cor:om.eta.ec50,tec50 
#>                     -0.797                      -0.291   
#>       cor:om.eta.kout,tec50         cor:om.eta.e0,tec50 
#>                      0.295                      -0.0181   
#>               cor:te0,tkout         cor:pdadd.err,tkout 
#>                      0.107                        0.295   
#>        cor:om.eta.ktr,tkout         cor:om.eta.ka,tkout 
#>                      0.253                        0.254   
#>         cor:om.eta.cl,tkout          cor:om.eta.v,tkout 
#>                    -0.0722                        0.102   
#>       cor:om.eta.emax,tkout       cor:om.eta.ec50,tkout 
#>                     -0.421                      0.0765   
#>       cor:om.eta.kout,tkout         cor:om.eta.e0,tkout 
#>                      0.347                     -0.0544   
#>           cor:pdadd.err,te0          cor:om.eta.ktr,te0 
#>                    -0.0566                       -0.136   
#>           cor:om.eta.ka,te0           cor:om.eta.cl,te0 
#>                     -0.128                       -0.134   
#>            cor:om.eta.v,te0         cor:om.eta.emax,te0 
#>                     -0.209                        0.288   
#>         cor:om.eta.ec50,te0         cor:om.eta.kout,te0 
#>                      0.125                      -0.0301   
#>           cor:om.eta.e0,te0    cor:om.eta.ktr,pdadd.err 
#>                     -0.743                      -0.118   
#>     cor:om.eta.ka,pdadd.err     cor:om.eta.cl,pdadd.err 
#>                     -0.129                        0.265   
#>      cor:om.eta.v,pdadd.err   cor:om.eta.emax,pdadd.err 
#>                    -0.0724                       -0.236   
#>   cor:om.eta.ec50,pdadd.err   cor:om.eta.kout,pdadd.err 
#>                     0.0676                      -0.0181   
#>     cor:om.eta.e0,pdadd.err    cor:om.eta.ka,om.eta.ktr 
#>                     -0.209                        0.999  
#>    cor:om.eta.cl,om.eta.ktr     cor:om.eta.v,om.eta.ktr 
#>                    -0.0743                       -0.121   
#>  cor:om.eta.emax,om.eta.ktr  cor:om.eta.ec50,om.eta.ktr 
#>                      0.117                      -0.0927   
#>  cor:om.eta.kout,om.eta.ktr    cor:om.eta.e0,om.eta.ktr 
#>                     0.0447                        0.163   
#>     cor:om.eta.cl,om.eta.ka      cor:om.eta.v,om.eta.ka 
#>                    -0.0864                       -0.136   
#>   cor:om.eta.emax,om.eta.ka   cor:om.eta.ec50,om.eta.ka 
#>                      0.135                      -0.0669   
#>   cor:om.eta.kout,om.eta.ka     cor:om.eta.e0,om.eta.ka 
#>                     0.0691                        0.157   
#>      cor:om.eta.v,om.eta.cl   cor:om.eta.emax,om.eta.cl 
#>                      0.312                      -0.128   
#>   cor:om.eta.ec50,om.eta.cl   cor:om.eta.kout,om.eta.cl 
#>                     -0.141                       -0.106   
#>     cor:om.eta.e0,om.eta.cl    cor:om.eta.emax,om.eta.v 
#>                      0.276                       -0.215   
#>    cor:om.eta.ec50,om.eta.v    cor:om.eta.kout,om.eta.v 
#>                    -0.0542                       -0.201   
#>      cor:om.eta.e0,om.eta.v cor:om.eta.ec50,om.eta.emax 
#>                      0.314                       0.437  
#> cor:om.eta.kout,om.eta.emax   cor:om.eta.e0,om.eta.emax 
#>                     -0.310                      -0.346  
#> cor:om.eta.kout,om.eta.ec50   cor:om.eta.e0,om.eta.ec50 
#>                      0.266                       -0.209   
#>   cor:om.eta.e0,om.eta.kout 
#>                      0.106   
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
