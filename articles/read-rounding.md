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
#> → optimizing duplicate expressions in EBE model (2 chunks)...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → compiling EBE model...
#> ✔ done
#> rxode2 5.1.4 using 2 threads (see ?getRxThreads)
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
#> elapsed 0.6350346       0.022 0.046    0.001 320.27      2.422
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>                Parameter      Est. SE %RSE Back-transformed(95%CI)
#> tktr            1 - tktr  6.241e-7                           1.000
#> tka              2 - tka -3.006e-6                           1.000
#> tcl              3 - tcl    -2.004                          0.1348
#> tv                4 - tv     2.052                           7.783
#> prop.err    5 - prop.err   0.09858                         0.09858
#> pkadd.err  6 - pkadd.err    0.5116                          0.5116
#> temax          7 - temax     6.418                          0.9984
#> tec50          8 - tec50    0.1408                           1.151
#> tkout          9 - tkout    -2.953                         0.05216
#> te0             10 - te0     4.570                           96.59
#> pdadd.err 11 - pdadd.err     3.717                           3.717
#>           BSV(CV% or SD) Shrink(SD)%
#> tktr               86.45      59.84 
#> tka                86.48      59.84 
#> tcl                28.59      1.340 
#> tv                 22.83      6.442 
#> prop.err                            
#> pkadd.err                           
#> temax           0.007071      99.99 
#> tec50              44.98      6.065 
#> tkout              9.164      32.42 
#> te0                5.243      18.09 
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
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → optimizing duplicate expressions in inner model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → optimizing duplicate expressions in EBE model (2 chunks)...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
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
#> [====|====|====|====|====|====|====|====|====|====] 0:00:28 
#> done
#> → Calculating residuals/tables
#> ✔ done

fit2
#> ── nlmixr² FOCEi (outer: bobyqa) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 1423.043 2340.738 2403.438      -1155.369      1966036839        499851.9
#> 
#> ── Time (sec fit2$time): ──
#> 
#>            setup optimize covariance preprocess postprocess table compress
#> elapsed 9.105813 20.45482   52.78919      0.033       0.017 0.064    0.001
#>             other
#> elapsed 0.1281705
#> 
#> ── Population Parameters (fit2$parFixed or fit2$parFixedDf): ──
#> 
#>                Parameter    Est.      SE   %RSE    Back-transformed(95%CI)
#> tktr            1 - tktr 0.05093  0.1584  311.0      1.052 (0.7715, 1.435)
#> tka              2 - tka 0.05071  0.1113  219.4      1.052 (0.8459, 1.308)
#> tcl              3 - tcl  -1.996 0.05169  2.589    0.1358 (0.1227, 0.1503)
#> tv                4 - tv   2.055 0.04506  2.193       7.807 (7.147, 8.528)
#> prop.err    5 - prop.err  0.1606 0.03124  19.46   0.1606 (0.09932, 0.2218)
#> pkadd.err  6 - pkadd.err  0.5847 0.07771  13.29    0.5847 (0.4324, 0.7370)
#> temax          7 - temax   9.209  0.6280  6.819     0.9999 (0.9997, 1.000)
#> tec50          8 - tec50  0.1286 0.09121  70.90      1.137 (0.9511, 1.360)
#> tkout          9 - tkout  -2.964 0.02378 0.8024 0.05162 (0.04927, 0.05409)
#> te0             10 - te0   4.572 0.01129 0.2470       96.72 (94.60, 98.88)
#> pdadd.err 11 - pdadd.err   3.809  0.3318  8.711       3.809 (3.159, 4.460)
#>           BSV(CV%) Shrink(SD)%
#> tktr                          
#> tka                           
#> tcl          27.90      2.995 
#> tv           23.67      9.924 
#> prop.err                      
#> pkadd.err                     
#> temax                         
#> tec50        42.50      7.298 
#> tkout                         
#> te0          5.254      18.80 
#> pdadd.err                     
#>  
#>   Covariance Type (fit2$covMethod): |r|,|s|
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance (fit2$omega) or correlation (fit2$omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in fit2$shrink 
#>   Information about run found (fit2$runInfo):
#>    • gradient problems with covariance; see $scaleInfo 
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
#> 1 1       0.5 dcp     0    1.25 -1.25 -1.83 0.994 -0.994 -1.64  1.23 -1.23 -1.89
#> 2 1       1   dcp     1.9  3.61 -1.71 -1.45 2.85  -0.952 -1.28  3.52 -1.62 -1.64
#> 3 1       2   dcp     3.3  7.83 -4.53 -1.99 6.16  -2.86  -2.49  7.66 -4.36 -2.40
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
#> → optimizing duplicate expressions in inner model (2 chunks)...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → optimizing duplicate expressions in EBE model (2 chunks)...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
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
#> [====|====|====|====|====|====|====|====|====|====] 0:00:14
#> Warning in foceiFitCpp_(.ret): using R matrix to calculate covariance, can
#> check sandwich or S matrix with $covRS and $covS
#> Warning in foceiFitCpp_(.ret): gradient problems with covariance; see
#> $scaleInfo
#> Updated original fit object fit
#>                      tktr           tka           tcl            tv
#> tktr         7.117551e-04  1.226477e-05 -3.804048e-06  6.487412e-05
#> tka          1.226477e-05  2.236301e-05 -2.268007e-08  3.241752e-06
#> tcl         -3.804048e-06 -2.268007e-08  1.312454e-04  5.156170e-06
#> tv           6.487412e-05  3.241752e-06  5.156170e-06  1.358642e-04
#> prop.err    -3.082560e-05 -1.442396e-06 -7.446109e-06  1.872193e-05
#> pkadd.err    8.311740e-05  4.054890e-06  1.535522e-04 -5.614444e-05
#> temax        5.679707e-04 -3.312004e-05 -9.245357e-05  3.105047e-04
#> tec50        2.472474e-05  5.848648e-07 -1.832133e-04  5.324455e-05
#> tkout        1.872373e-05  1.134966e-06 -5.305420e-05  5.375822e-05
#> te0          2.884045e-06  1.400669e-07 -6.109209e-06  5.554689e-06
#> pdadd.err    9.726719e-05  5.108921e-06 -1.542511e-04  1.752999e-04
#> om.eta.ktr   2.491142e-04  1.141137e-06  2.494431e-06  4.145592e-05
#> om.eta.ka   -8.426159e-05  5.947916e-06  4.340370e-06  1.161604e-05
#> om.eta.cl    2.440707e-08  3.289216e-09  9.727122e-07  7.122064e-07
#> om.eta.v    -1.674692e-06 -7.593511e-08  1.140494e-06  8.963284e-07
#> om.eta.emax  4.795794e-08 -2.689360e-09 -1.166710e-08  3.074419e-08
#> om.eta.ec50 -4.866894e-07 -8.373748e-09  4.179315e-06 -1.233600e-06
#> om.eta.kout  2.407474e-07  1.302878e-08 -3.906939e-07  6.013430e-07
#> om.eta.e0    3.777665e-08  1.987335e-09 -6.333809e-08  7.562325e-08
#>                  prop.err     pkadd.err         temax         tec50
#> tktr        -3.082560e-05  8.311740e-05  5.679707e-04  2.472474e-05
#> tka         -1.442396e-06  4.054890e-06 -3.312004e-05  5.848648e-07
#> tcl         -7.446109e-06  1.535522e-04 -9.245357e-05 -1.832133e-04
#> tv           1.872193e-05 -5.614444e-05  3.105047e-04  5.324455e-05
#> prop.err     9.528457e-05 -2.713613e-04  2.375178e-05  1.943147e-05
#> pkadd.err   -2.713613e-04  2.909074e-03 -4.038898e-04 -2.473354e-04
#> temax        2.375178e-05 -4.038898e-04  3.717483e+00  2.238245e-02
#> tec50        1.943147e-05 -2.473354e-04  2.238245e-02  8.847216e-04
#> tkout        1.136123e-05 -9.152552e-05 -9.514660e-03  7.993296e-05
#> te0          1.151226e-06 -1.013283e-05 -1.240086e-04 -6.412860e-05
#> pdadd.err    3.701360e-05 -1.204600e-04 -2.332204e-02  1.637766e-04
#> om.eta.ktr   5.186590e-05 -2.695553e-06 -2.868540e-04  6.178644e-06
#> om.eta.ka    6.404873e-05 -3.681776e-05 -5.645412e-04 -5.485836e-06
#> om.eta.cl    5.078831e-07  1.587141e-05 -6.701757e-06 -1.149177e-06
#> om.eta.v     4.724737e-06  2.997372e-06 -2.589168e-05 -1.641539e-06
#> om.eta.emax  3.712916e-09 -3.135457e-08  2.996180e-04  1.831847e-06
#> om.eta.ec50 -5.294395e-07  3.677414e-05 -6.559946e-04 -1.575773e-05
#> om.eta.kout  1.669907e-07  9.224099e-07 -6.580260e-05  1.471163e-06
#> om.eta.e0    2.018697e-08 -3.971365e-08 -8.564827e-06  1.589712e-07
#>                     tkout           te0     pdadd.err    om.eta.ktr
#> tktr         1.872373e-05  2.884045e-06  9.726719e-05  2.491142e-04
#> tka          1.134966e-06  1.400669e-07  5.108921e-06  1.141137e-06
#> tcl         -5.305420e-05 -6.109209e-06 -1.542511e-04  2.494431e-06
#> tv           5.375822e-05  5.554689e-06  1.752999e-04  4.145592e-05
#> prop.err     1.136123e-05  1.151226e-06  3.701360e-05  5.186590e-05
#> pkadd.err   -9.152552e-05 -1.013283e-05 -1.204600e-04 -2.695553e-06
#> temax       -9.514660e-03 -1.240086e-04 -2.332204e-02 -2.868540e-04
#> tec50        7.993296e-05 -6.412860e-05  1.637766e-04  6.178644e-06
#> tkout        3.165048e-04  2.651478e-05  1.940087e-04  1.404801e-05
#> te0          2.651478e-05  4.413047e-05  1.230731e-05  1.388562e-06
#> pdadd.err    1.940087e-04  1.230731e-05  3.976383e-02  2.987240e-04
#> om.eta.ktr   1.404801e-05  1.388562e-06  2.987240e-04  9.253453e-02
#> om.eta.ka    5.450136e-06  6.522215e-08  2.492119e-04  2.965039e-02
#> om.eta.cl   -1.954464e-07 -3.521995e-08  5.635618e-06  2.059001e-05
#> om.eta.v    -3.300434e-07 -4.206716e-08  1.521112e-05  1.625102e-05
#> om.eta.emax -7.694311e-07 -1.462942e-08 -1.478714e-06 -6.780320e-09
#> om.eta.ec50 -4.223933e-06 -5.115733e-07  2.801966e-04  6.768802e-06
#> om.eta.kout  1.272296e-06 -1.942521e-07  5.322319e-05  4.488374e-06
#> om.eta.e0    6.589633e-08 -4.893808e-08  1.442266e-05  1.732708e-07
#>                 om.eta.ka     om.eta.cl      om.eta.v   om.eta.emax
#> tktr        -8.426159e-05  2.440707e-08 -1.674692e-06  4.795794e-08
#> tka          5.947916e-06  3.289216e-09 -7.593511e-08 -2.689360e-09
#> tcl          4.340370e-06  9.727122e-07  1.140494e-06 -1.166710e-08
#> tv           1.161604e-05  7.122064e-07  8.963284e-07  3.074419e-08
#> prop.err     6.404873e-05  5.078831e-07  4.724737e-06  3.712916e-09
#> pkadd.err   -3.681776e-05  1.587141e-05  2.997372e-06 -3.135457e-08
#> temax       -5.645412e-04 -6.701757e-06 -2.589168e-05  2.996180e-04
#> tec50       -5.485836e-06 -1.149177e-06 -1.641539e-06  1.831847e-06
#> tkout        5.450136e-06 -1.954464e-07 -3.300434e-07 -7.694311e-07
#> te0          6.522215e-08 -3.521995e-08 -4.206716e-08 -1.462942e-08
#> pdadd.err    2.492119e-04  5.635618e-06  1.521112e-05 -1.478714e-06
#> om.eta.ktr   2.965039e-02  2.059001e-05  1.625102e-05 -6.780320e-09
#> om.eta.ka    9.146140e-02  2.015145e-05  1.648622e-05 -3.141669e-08
#> om.eta.cl    2.015145e-05  3.900522e-04  2.332449e-07 -2.095038e-10
#> om.eta.v     1.648622e-05  2.332449e-07  1.672595e-04 -7.648997e-10
#> om.eta.emax -3.141669e-08 -2.095038e-10 -7.648997e-10  3.371466e-03
#> om.eta.ec50  6.857673e-06  2.113917e-06  6.300933e-07  1.267573e-07
#> om.eta.kout  4.297694e-06  6.795138e-08  2.175756e-07  1.868036e-09
#> om.eta.e0    1.523645e-07  5.359341e-09  8.067423e-09 -4.033401e-10
#>               om.eta.ec50   om.eta.kout     om.eta.e0
#> tktr        -4.866894e-07  2.407474e-07  3.777665e-08
#> tka         -8.373748e-09  1.302878e-08  1.987335e-09
#> tcl          4.179315e-06 -3.906939e-07 -6.333809e-08
#> tv          -1.233600e-06  6.013430e-07  7.562325e-08
#> prop.err    -5.294395e-07  1.669907e-07  2.018697e-08
#> pkadd.err    3.677414e-05  9.224099e-07 -3.971365e-08
#> temax       -6.559946e-04 -6.580260e-05 -8.564827e-06
#> tec50       -1.575773e-05  1.471163e-06  1.589712e-07
#> tkout       -4.223933e-06  1.272296e-06  6.589633e-08
#> te0         -5.115733e-07 -1.942521e-07 -4.893808e-08
#> pdadd.err    2.801966e-04  5.322319e-05  1.442266e-05
#> om.eta.ktr   6.768802e-06  4.488374e-06  1.732708e-07
#> om.eta.ka    6.857673e-06  4.297694e-06  1.523645e-07
#> om.eta.cl    2.113917e-06  6.795138e-08  5.359341e-09
#> om.eta.v     6.300933e-07  2.175756e-07  8.067423e-09
#> om.eta.emax  1.267573e-07  1.868036e-09 -4.033401e-10
#> om.eta.ec50  2.228655e-03  1.293380e-06  2.576137e-07
#> om.eta.kout  1.293380e-06  6.463107e-06  2.914145e-08
#> om.eta.e0    2.576137e-07  2.914145e-08  5.463700e-07
fit
#> ── nlmixr² nonmem2rx reading NONMEM ver 7.4.3 ──
#> 
#>               OBJF     AIC      BIC Log-likelihood Condition#(Cov)
#> nonmem2rx 439.2156 1364.91 1444.331      -663.4551         6871556
#>           Condition#(Cor)
#> nonmem2rx        10.42427
#> 
#> ── Time (sec fit$time): ──
#> 
#>             setup postprocess table compress NONMEM as.nlmixr2 covariance
#> elapsed 0.6350346       0.022 0.046    0.001 320.27      2.422      52.57
#> 
#> ── Population Parameters (fit$parFixed or fit$parFixedDf): ──
#> 
#>                Parameter      Est.       SE    %RSE    Back-transformed(95%CI)
#> tktr            1 - tktr  6.241e-7  0.09734 1.560e7      1.000 (0.8263, 1.210)
#> tka              2 - tka -3.006e-6  0.09745 3241000      1.000 (0.8261, 1.210)
#> tcl              3 - tcl    -2.004  0.01155  0.5764    0.1348 (0.1318, 0.1379)
#> tv                4 - tv     2.052  0.01261  0.6148       7.783 (7.592, 7.977)
#> prop.err    5 - prop.err   0.09858 0.009993   10.14  0.09858 (0.07899, 0.1182)
#> pkadd.err  6 - pkadd.err    0.5116  0.05401   10.56    0.5116 (0.4058, 0.6175)
#> temax          7 - temax     6.418    1.955   30.46     0.9984 (0.9300, 1.000)
#> tec50          8 - tec50    0.1408  0.03075   21.84       1.151 (1.084, 1.223)
#> tkout          9 - tkout    -2.953  0.01787  0.6050 0.05216 (0.05036, 0.05402)
#> te0             10 - te0     4.570 0.006660  0.1457       96.59 (95.34, 97.86)
#> pdadd.err 11 - pdadd.err     3.717   0.1974   5.311       3.717 (3.330, 4.104)
#>           BSV(CV% or SD) Shrink(SD)%
#> tktr               86.45      59.84 
#> tka                86.48      59.84 
#> tcl                28.59      1.340 
#> tv                 22.83      6.442 
#> prop.err                            
#> pkadd.err                           
#> temax           0.007071      99.99 
#> tec50              44.98      6.065 
#> tkout              9.164      32.42 
#> te0                5.243      18.09 
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
