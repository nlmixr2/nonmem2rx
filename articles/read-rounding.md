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
#>     NULL
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
#>         y <- ipred + w * eps1
#>     })
#> }
#>  ── nonmem2rx translation notes ($notes): ──  
#>    • some etas defaulted to non-mu referenced, possible parsing error: eta.emax as a work-around try putting the mu-referenced expression on a simple line 
#>    • some etas defaulted to non-mu referenced, possible parsing error: eta5 as a work-around try putting the mu-referenced expression on a simple line 
#>    • some NONMEM input has tied times; they are offset by a small offset 
#>    • is.na() applied to non-(list or vector) of type 'language' 
#>    • 'dvid' variable has special meaning in rxode2, renamed to 'nmdvid', rename/copy in your data too 
#>    • $MODEL NCOMPARTMENTS/NEQUILIBRIUM/NPARAMETERS statement(s) ignored 
#>  ── nonmem2rx extra properties: ──  
#> 
#> Sigma ($sigma): 
#>      eps1
#> eps1    1
#> 
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
#> rxode2 5.1.7 using 2 threads (see ?getRxThreads)
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
#> elapsed 0.6828326       0.018 0.047    0.001 320.27      0.945
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
#> [====|====|====|====|====|====|====|====|====|====] 0:00:09 
#> done
#> → Calculating residuals/tables
#> ✔ done

fit2
#> ── nlmixr² FOCEi (outer: bobyqa) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 1423.589 2341.284 2403.984      -1155.642        173268.4        25.84419
#> 
#> ── Time (sec fit2$time): ──
#> 
#>            setup optimize covariance preprocess postprocess table compress
#> elapsed 2.297046 2.247638   14.50267      0.033       0.015  0.05    0.001
#>              other
#> elapsed 0.08664472
#> 
#> ── Population Parameters (fit2$parFixed or fit2$parFixedDf): ──
#> 
#>                Parameter   Est.     SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tktr            1 - tktr 0.0616 0.0148  24.0       1.06 (1.03, 1.09)         
#> tka              2 - tka 0.0578 0.0229  39.5       1.06 (1.01, 1.11)         
#> tcl              3 - tcl  -1.99 0.0794  3.98    0.136 (0.117, 0.159)     28.7
#> tv                4 - tv   2.05 0.0921  4.48       7.80 (6.51, 9.34)     24.3
#> prop.err    5 - prop.err  0.157 0.0379  24.1   0.157 (0.0831, 0.232)         
#> pkadd.err  6 - pkadd.err  0.642 0.0915  14.3    0.642 (0.462, 0.821)         
#> temax          7 - temax   7.10   3.96  55.8     0.999 (0.341, 1.00)         
#> tec50          8 - tec50  0.106  0.176   166      1.11 (0.787, 1.57)     41.1
#> tkout          9 - tkout  -2.96 0.0136 0.460 0.0516 (0.0502, 0.0530)         
#> te0             10 - te0   4.57 0.0124 0.270       96.7 (94.4, 99.1)     5.24
#> pdadd.err 11 - pdadd.err   3.75  0.290  7.75       3.75 (3.18, 4.32)         
#>           Shrink(SD)%
#> tktr                 
#> tka                  
#> tcl             5.46 
#> tv              11.4 
#> prop.err             
#> pkadd.err            
#> temax                
#> tec50           5.65 
#> tkout                
#> te0             18.0 
#> pdadd.err            
#>  
#>   Covariance Type (fit2$covMethod): |r|
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance (fit2$omega) or correlation (fit2$omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in fit2$shrink 
#>   Information about run found (fit2$runInfo):
#>    • gradient problems with covariance; see $scaleInfo 
#>    • using R matrix to calculate covariance, can check sandwich or S matrix with $covRS and $covS 
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
#> 1 1       0.5 dcp     0    1.27 -1.27 -1.73  1.01 -1.01  -1.53  1.24 -1.24 -1.77
#> 2 1       1   dcp     1.9  3.65 -1.75 -1.43  2.89 -0.989 -1.26  3.57 -1.67 -1.60
#> 3 1       2   dcp     3.3  7.90 -4.60 -1.98  6.22 -2.92  -2.49  7.72 -4.42 -2.37
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
#> [====|====|====|====|====|====|====|====|====|====] 0:00:10
#> Warning in foceiFitCpp_(.ret): using R matrix to calculate covariance, can
#> check sandwich or S matrix with $covRS and $covS
#> Warning in foceiFitCpp_(.ret): gradient problems with covariance; see
#> $scaleInfo
#> Updated original fit object fit
#>                    tktr           tka           tcl            tv      prop.err
#> tktr       9.475892e-03 -7.615446e-03 -8.904753e-06  1.633236e-04 -7.552254e-05
#> tka       -7.615446e-03  9.496620e-03 -1.023068e-05  1.656049e-04 -7.619275e-05
#> tcl       -8.904753e-06 -1.023068e-05  1.334429e-04  3.137332e-06 -6.811161e-06
#> tv         1.633236e-04  1.656049e-04  3.137332e-06  1.591279e-04  7.634461e-06
#> prop.err  -7.552254e-05 -7.619275e-05 -6.811161e-06  7.634461e-06  9.985560e-05
#> pkadd.err  2.277057e-04  2.284631e-04  1.530988e-04 -2.658582e-05 -2.819467e-04
#> temax      8.605237e-04  1.402899e-04 -3.887930e-04  4.331181e-04  3.734071e-05
#> tec50      6.212825e-05  5.792502e-05 -1.947472e-04  6.457748e-05  1.611343e-05
#> tkout      4.368879e-05  5.232452e-05 -5.435173e-05  6.078425e-05  7.990995e-06
#> te0        6.235052e-06  7.779588e-06 -5.359718e-06  6.398256e-06  5.987876e-07
#> pdadd.err  2.427914e-04  2.515300e-04 -1.537365e-04  2.036940e-04  1.803518e-05
#>               pkadd.err         temax         tec50         tkout           te0
#> tktr       2.277057e-04  8.605237e-04  6.212825e-05  4.368879e-05  6.235052e-06
#> tka        2.284631e-04  1.402899e-04  5.792502e-05  5.232452e-05  7.779588e-06
#> tcl        1.530988e-04 -3.887930e-04 -1.947472e-04 -5.435173e-05 -5.359718e-06
#> tv        -2.658582e-05  4.331181e-04  6.457748e-05  6.078425e-05  6.398256e-06
#> prop.err  -2.819467e-04  3.734071e-05  1.611343e-05  7.990995e-06  5.987876e-07
#> pkadd.err  2.916805e-03 -7.208832e-04 -2.492685e-04 -8.357900e-05 -7.656990e-06
#> temax     -7.208832e-04  3.821188e+00  2.434656e-02 -9.592252e-03 -2.409647e-04
#> tec50     -2.492685e-04  2.434656e-02  9.453561e-04  8.518911e-05 -6.754105e-05
#> tkout     -8.357900e-05 -9.592252e-03  8.518911e-05  3.193456e-04  2.655254e-05
#> te0       -7.656990e-06 -2.409647e-04 -6.754105e-05  2.655254e-05  4.435613e-05
#> pdadd.err -8.688221e-05 -2.288315e-02  1.711972e-04  1.989664e-04  1.591483e-05
#>               pdadd.err
#> tktr       2.427914e-04
#> tka        2.515300e-04
#> tcl       -1.537365e-04
#> tv         2.036940e-04
#> prop.err   1.803518e-05
#> pkadd.err -8.688221e-05
#> temax     -2.288315e-02
#> tec50      1.711972e-04
#> tkout      1.989664e-04
#> te0        1.591483e-05
#> pdadd.err  3.897703e-02
fit
#> ── nlmixr² nonmem2rx reading NONMEM ver 7.4.3 ──
#> 
#>               OBJF     AIC      BIC Log-likelihood Condition#(Cov)
#> nonmem2rx 439.2156 1364.91 1444.331      -663.4551        152342.4
#>           Condition#(Cor)
#> nonmem2rx        14.61083
#> 
#> ── Time (sec fit$time): ──
#> 
#>             setup postprocess table compress NONMEM as.nlmixr2 covariance
#> elapsed 0.6828326       0.018 0.047    0.001 320.27      0.945     35.037
#> 
#> ── Population Parameters (fit$parFixed or fit$parFixedDf): ──
#> 
#>                Parameter     Est.      SE   %RSE Back-transformed(95%CI)
#> tktr            1 - tktr  6.24e-7  0.0973 1.56e7      1.00 (0.826, 1.21)
#> tka              2 - tka -3.01e-6  0.0975 3.24e6      1.00 (0.826, 1.21)
#> tcl              3 - tcl    -2.00  0.0116  0.576    0.135 (0.132, 0.138)
#> tv                4 - tv     2.05  0.0126  0.615       7.78 (7.59, 7.98)
#> prop.err    5 - prop.err   0.0986 0.00999   10.1  0.0986 (0.0790, 0.118)
#> pkadd.err  6 - pkadd.err    0.512  0.0540   10.6    0.512 (0.406, 0.617)
#> temax          7 - temax     6.42    1.95   30.5     0.998 (0.930, 1.00)
#> tec50          8 - tec50    0.141  0.0307   21.8       1.15 (1.08, 1.22)
#> tkout          9 - tkout    -2.95  0.0179  0.605 0.0522 (0.0504, 0.0540)
#> te0             10 - te0     4.57 0.00666  0.146       96.6 (95.3, 97.9)
#> pdadd.err 11 - pdadd.err     3.72   0.197   5.31       3.72 (3.33, 4.10)
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
#>   Covariance Type (fit$covMethod): r
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
