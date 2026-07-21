# Converting a NONMEM fit to a nlmixr2 object

### Creating a nlmixr2 compatible model

Depending on the model, not all the residual specifications are
translated to the `nlmixr2` style residuals. This means the model cannot
be immediately used for either
[`nlmixr2()`](https://nlmixr2.github.io/nlmixr2est/reference/nlmixr2.html)
estimation or creating a `nlmixr2` fit object (though you can simulate
with and without certainty without any modifications)

For example you could have something like:

``` r

y <- ipred*(1+eps1)
```

For a model that can do `nlmixr2` estimation instead of simply
simulation the residual needs to be changed to something like:

``` r

cp ~ prop(prop.sd)
```

Since the model when import has most of the translation done already,
you can easily tweak the model to have this form.

Here is the same example where the residual errors are not automatically
translated to the `nlmixr2` parameter style (in this case because of the
option `determineError=FALSE`)

## Example – no error determined

``` r

library(nonmem2rx)
library(babelmixr2)

# First we need the location of the nonmem control stream Since we are running an example, we will use one of the built-in examples in `nonmem2rx`
ctlFile <- system.file("mods/cpt/runODE032.ctl", package="nonmem2rx")
# You can use a control stream or other file. With the development
# version of `babelmixr2`, you can simply point to the listing file

mod <- nonmem2rx(ctlFile, lst=".res", save=FALSE, determineError=FALSE)
#> ℹ getting information from  '/home/runner/work/_temp/Library/nonmem2rx/mods/cpt/runODE032.ctl'
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
#> ℹ change initial estimate of `theta1` to `1.37034036528946`
#> ℹ change initial estimate of `theta2` to `4.19814911033061`
#> ℹ change initial estimate of `theta3` to `1.38003493562413`
#> ℹ change initial estimate of `theta4` to `3.87657341967489`
#> ℹ change initial estimate of `theta5` to `0.196446108190896`
#> ℹ change initial estimate of `eta1` to `0.101251418415006`
#> ℹ change initial estimate of `eta2` to `0.0993872449483344`
#> ℹ change initial estimate of `eta3` to `0.101302674763154`
#> ℹ change initial estimate of `eta4` to `0.0730497519364148`
#> ℹ read in nonmem input data (for model validation): /home/runner/work/_temp/Library/nonmem2rx/mods/cpt/Bolus_2CPT.csv
#> ℹ ignoring lines that begin with a letter (IGNORE=@)
#> ℹ applying names specified by $INPUT
#> ℹ subsetting accept/ignore filters code: .data[-which((.data$SD == 0)),]
#> ℹ renaming 'ytype' to 'nmytype'
#> ℹ done
#> ℹ read in nonmem IPRED data (for model validation): /home/runner/work/_temp/Library/nonmem2rx/mods/cpt/runODE032.csv
#> ℹ done
#> ℹ changing most variables to lower case
#> ℹ done
#> ℹ replace theta names
#> ℹ done
#> ℹ replace eta names
#> ℹ done (no labels)
#> ℹ renaming compartments
#> ℹ done
#> ℹ solving ipred problem
#> ℹ done
#> ℹ solving pred problem
#> ℹ done

print(mod)
#>  ── rxode2-based free-form 2-cmt ODE model ────────────────────────────────────── 
#>  ── Initalization: ──  
#> Fixed Effects ($theta): 
#>    theta1    theta2    theta3    theta4       RSV 
#> 1.3703404 4.1981491 1.3800349 3.8765734 0.1964461 
#> 
#> Omega ($omega): 
#>           eta1       eta2      eta3       eta4
#> eta1 0.1012514 0.00000000 0.0000000 0.00000000
#> eta2 0.0000000 0.09938724 0.0000000 0.00000000
#> eta3 0.0000000 0.00000000 0.1013027 0.00000000
#> eta4 0.0000000 0.00000000 0.0000000 0.07304975
#> 
#> States ($state or $stateDf): 
#>   Compartment Number Compartment Name
#> 1                  1          CENTRAL
#> 2                  2             PERI
#>  ── μ-referencing ($muRefTable): ──  
#>    theta  eta level
#> 1 theta1 eta1    id
#> 2 theta2 eta2    id
#> 3 theta3 eta3    id
#> 4 theta4 eta4    id
#> 
#>  ── Model (Normalized Syntax): ── 
#> function() {
#>     NULL
#>     description <- "BOLUS_2CPT_CLV1QV2 SINGLE DOSE FOCEI (120 Ind/2280 Obs) runODE032"
#>     dfObs <- 2280
#>     dfSub <- 120
#>     sigma <- lotri({
#>         eps1 ~ 1
#>     })
#>     thetaMat <- lotri({
#>         theta1 ~ c(theta1 = 0.000887681)
#>         theta2 ~ c(theta1 = -0.00010551, theta2 = 0.000871409)
#>         theta3 ~ c(theta1 = 0.000184416, theta2 = -0.000106195, 
#>             theta3 = 0.00299336)
#>         theta4 ~ c(theta1 = -0.000120234, theta2 = -5.06663e-05, 
#>             theta3 = 0.000165252, theta4 = 0.00121347)
#>         RSV ~ c(theta1 = 5.2783e-08, theta2 = -1.56562e-05, theta3 = 5.99331e-06, 
#>             theta4 = -2.53991e-05, RSV = 9.94218e-06)
#>         eps1 ~ c(theta1 = 0, theta2 = 0, theta3 = 0, theta4 = 0, 
#>             RSV = 0, eps1 = 0)
#>         eta1 ~ c(theta1 = -4.71273e-05, theta2 = 4.69667e-05, 
#>             theta3 = -3.64271e-05, theta4 = 2.54796e-05, RSV = -8.16885e-06, 
#>             eps1 = 0, eta1 = 0.000169296)
#>         omega.2.1 ~ c(theta1 = 0, theta2 = 0, theta3 = 0, theta4 = 0, 
#>             RSV = 0, eps1 = 0, eta1 = 0, omega.2.1 = 0)
#>         eta2 ~ c(theta1 = -7.37156e-05, theta2 = 2.56634e-05, 
#>             theta3 = -8.08349e-05, theta4 = 1.37e-05, RSV = -4.36564e-06, 
#>             eps1 = 0, eta1 = 8.75181e-06, omega.2.1 = 0, eta2 = 0.00015125)
#>         omega.3.1 ~ c(theta1 = 0, theta2 = 0, theta3 = 0, theta4 = 0, 
#>             RSV = 0, eps1 = 0, eta1 = 0, omega.2.1 = 0, eta2 = 0, 
#>             omega.3.1 = 0)
#>         omega.3.2 ~ c(theta1 = 0, theta2 = 0, theta3 = 0, theta4 = 0, 
#>             RSV = 0, eps1 = 0, eta1 = 0, omega.2.1 = 0, eta2 = 0, 
#>             omega.3.1 = 0, omega.3.2 = 0)
#>         eta3 ~ c(theta1 = 6.63383e-05, theta2 = -8.19002e-05, 
#>             theta3 = 0.000548985, theta4 = 0.000168356, RSV = 1.59122e-06, 
#>             eps1 = 0, eta1 = 3.48714e-05, omega.2.1 = 0, eta2 = 4.31593e-07, 
#>             omega.3.1 = 0, omega.3.2 = 0, eta3 = 0.000959029)
#>         omega.4.1 ~ c(theta1 = 0, theta2 = 0, theta3 = 0, theta4 = 0, 
#>             RSV = 0, eps1 = 0, eta1 = 0, omega.2.1 = 0, eta2 = 0, 
#>             omega.3.1 = 0, omega.3.2 = 0, eta3 = 0, omega.4.1 = 0)
#>         omega.4.2 ~ c(theta1 = 0, theta2 = 0, theta3 = 0, theta4 = 0, 
#>             RSV = 0, eps1 = 0, eta1 = 0, omega.2.1 = 0, eta2 = 0, 
#>             omega.3.1 = 0, omega.3.2 = 0, eta3 = 0, omega.4.1 = 0, 
#>             omega.4.2 = 0)
#>         omega.4.3 ~ c(theta1 = 0, theta2 = 0, theta3 = 0, theta4 = 0, 
#>             RSV = 0, eps1 = 0, eta1 = 0, omega.2.1 = 0, eta2 = 0, 
#>             omega.3.1 = 0, omega.3.2 = 0, eta3 = 0, omega.4.1 = 0, 
#>             omega.4.2 = 0, omega.4.3 = 0)
#>         eta4 ~ c(theta1 = -9.49661e-06, theta2 = 0.000110108, 
#>             theta3 = -0.000306537, theta4 = -9.12897e-05, RSV = 3.1877e-06, 
#>             eps1 = 0, eta1 = 1.36628e-05, omega.2.1 = 0, eta2 = -1.95096e-05, 
#>             omega.3.1 = 0, omega.3.2 = 0, eta3 = -0.00012977, 
#>             omega.4.1 = 0, omega.4.2 = 0, omega.4.3 = 0, eta4 = 0.00051019)
#>     })
#>     validation <- c("IPRED relative difference compared to Nonmem IPRED: 0%; 95% percentile: (0%,0%); rtol=6.43e-06", 
#>         "IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (2.19e-05, 0.0418); atol=0.00167", 
#>         "IWRES relative difference compared to Nonmem IWRES: 0%; 95% percentile: (0%,0.01%); rtol=8.99e-06", 
#>         "IWRES absolute difference compared to Nonmem IWRES: 95% percentile: (1.82e-07, 4.63e-05); atol=3.65e-06", 
#>         "PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=6.41e-06", 
#>         "PRED absolute difference compared to Nonmem PRED: 95% percentile: (1.41e-07,0.00382) atol=6.41e-06")
#>     ini({
#>         theta1 <- 1.37034036528946
#>         label("log Cl")
#>         theta2 <- 4.19814911033061
#>         label("log Vc")
#>         theta3 <- 1.38003493562413
#>         label("log Q")
#>         theta4 <- 3.87657341967489
#>         label("log Vp")
#>         RSV <- c(0, 0.196446108190896, 1)
#>         label("RSV")
#>         eta1 ~ 0.101251418415006
#>         eta2 ~ 0.0993872449483344
#>         eta3 ~ 0.101302674763154
#>         eta4 ~ 0.0730497519364148
#>     })
#>     model({
#>         cmt(CENTRAL)
#>         cmt(PERI)
#>         cl <- exp(theta1 + eta1)
#>         v <- exp(theta2 + eta2)
#>         q <- exp(theta3 + eta3)
#>         v2 <- exp(theta4 + eta4)
#>         v1 <- v
#>         scale1 <- v
#>         k21 <- q/v2
#>         k12 <- q/v
#>         d/dt(CENTRAL) <- k21 * PERI - k12 * CENTRAL - cl * CENTRAL/v1
#>         d/dt(PERI) <- -k21 * PERI + k12 * CENTRAL
#>         f <- CENTRAL/scale1
#>         ipred <- f
#>         rescv <- RSV
#>         w <- ipred * rescv
#>         ires <- DV - ipred
#>         iwres <- ires/w
#>         y <- ipred + w * eps1
#>     })
#> }
#>  ── nonmem2rx translation notes ($notes): ──  
#>    • there are duplicate eta names, not renaming duplicate parameters 
#>    • there are duplicate theta names, not renaming duplicate parameters 
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

One approach to get a nlmixr2 compatible model is to copy the printed
model above and then modify it as needed.

In this case, I will name the parameters to something a bit more
meaningful while keeping the estimates the same:

``` r

mod2 <-function() {
  ini({
    lcl <- 1.37034036528946
    lvc <- 4.19814911033061
    lq <- 1.38003493562413
    lvp <- 3.87657341967489
    RSV <- c(0, 0.196446108190896, 1)
    eta.cl ~ 0.101251418415006
    eta.v ~ 0.0993872449483344
    eta.q ~ 0.101302674763154
    eta.v2 ~ 0.0730497519364148
  })
  model({
    cmt(CENTRAL)
    cmt(PERI)
    cl <- exp(lcl + eta.cl)
    v <- exp(lvc + eta.v)
    q <- exp(lq + eta.q)
    v2 <- exp(lvp + eta.v2)
    v1 <- v
    scale1 <- v
    k21 <- q/v2
    k12 <- q/v
    d/dt(CENTRAL) <- k21 * PERI - k12 * CENTRAL - cl * CENTRAL/v1
    d/dt(PERI) <- -k21 * PERI + k12 * CENTRAL
    f <- CENTRAL/scale1
    f ~ prop(RSV)
  })
}
```

The [`as.nonmem2rx()`](../reference/as.nonmem2rx.md) function will
compare the already imported rxode2 model function with the model you
made some manual tweaks to:

``` r

new <- as.nonmem2rx(mod2, mod)
#> ℹ parameter labels from comments are typically ignored in non-interactive mode
#> ℹ Need to run with the source intact to parse comments
#> ℹ copy 'dfSub' to nonmem2rx model
#> ℹ copy 'thetaMat' to nonmem2rx model
#> ℹ copy 'dfObs' to nonmem2rx model
#> ℹ solving ipred problem
#> ℹ done
#> ℹ solving pred problem
#> ℹ done

print(new)
#>  ── rxode2-based free-form 2-cmt ODE model ────────────────────────────────────── 
#>  ── Initalization: ──  
#> Fixed Effects ($theta): 
#>       lcl       lvc        lq       lvp       RSV 
#> 1.3703404 4.1981491 1.3800349 3.8765734 0.1964461 
#> 
#> Omega ($omega): 
#>           eta.cl      eta.v     eta.q     eta.v2
#> eta.cl 0.1012514 0.00000000 0.0000000 0.00000000
#> eta.v  0.0000000 0.09938724 0.0000000 0.00000000
#> eta.q  0.0000000 0.00000000 0.1013027 0.00000000
#> eta.v2 0.0000000 0.00000000 0.0000000 0.07304975
#> 
#> States ($state or $stateDf): 
#>   Compartment Number Compartment Name
#> 1                  1          CENTRAL
#> 2                  2             PERI
#>  ── μ-referencing ($muRefTable): ──  
#>   theta    eta level
#> 1   lcl eta.cl    id
#> 2   lvc  eta.v    id
#> 3    lq  eta.q    id
#> 4   lvp eta.v2    id
#> 
#>  ── Model (Normalized Syntax): ── 
#> function() {
#>     description <- "BOLUS_2CPT_CLV1QV2 SINGLE DOSE FOCEI (120 Ind/2280 Obs) runODE032"
#>     dfObs <- 2280
#>     dfSub <- 120
#>     thetaMat <- lotri({
#>         lcl ~ c(lcl = 0.000887681)
#>         lvc ~ c(lcl = -0.00010551, lvc = 0.000871409)
#>         lq ~ c(lcl = 0.000184416, lvc = -0.000106195, lq = 0.00299336)
#>         lvp ~ c(lcl = -0.000120234, lvc = -5.06663e-05, lq = 0.000165252, 
#>             lvp = 0.00121347)
#>         RSV ~ c(lcl = 5.2783e-08, lvc = -1.56562e-05, lq = 5.99331e-06, 
#>             lvp = -2.53991e-05, RSV = 9.94218e-06)
#>         eta.cl ~ c(lcl = -4.71273e-05, lvc = 4.69667e-05, lq = -3.64271e-05, 
#>             lvp = 2.54796e-05, RSV = -8.16885e-06, eta.cl = 0.000169296)
#>         eta.v ~ c(lcl = -7.37156e-05, lvc = 2.56634e-05, lq = -8.08349e-05, 
#>             lvp = 1.37e-05, RSV = -4.36564e-06, eta.cl = 8.75181e-06, 
#>             eta.v = 0.00015125)
#>         eta.q ~ c(lcl = 6.63383e-05, lvc = -8.19002e-05, lq = 0.000548985, 
#>             lvp = 0.000168356, RSV = 1.59122e-06, eta.cl = 3.48714e-05, 
#>             eta.v = 4.31593e-07, eta.q = 0.000959029)
#>         eta.v2 ~ c(lcl = -9.49661e-06, lvc = 0.000110108, lq = -0.000306537, 
#>             lvp = -9.12897e-05, RSV = 3.1877e-06, eta.cl = 1.36628e-05, 
#>             eta.v = -1.95096e-05, eta.q = -0.00012977, eta.v2 = 0.00051019)
#>     })
#>     validation <- c("IPRED relative difference compared to Nonmem IPRED: 0%; 95% percentile: (0%,0%); rtol=6.43e-06", 
#>         "IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (2.19e-05, 0.0418); atol=0.00167", 
#>         "IWRES relative difference compared to Nonmem IWRES: 0%; 95% percentile: (0%,0.01%); rtol=8.99e-06", 
#>         "IWRES absolute difference compared to Nonmem IWRES: 95% percentile: (1.82e-07, 4.63e-05); atol=3.65e-06", 
#>         "PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=6.41e-06", 
#>         "PRED absolute difference compared to Nonmem PRED: 95% percentile: (1.41e-07,0.00382) atol=6.41e-06")
#>     ini({
#>         lcl <- 1.37034036528946
#>         lvc <- 4.19814911033061
#>         lq <- 1.38003493562413
#>         lvp <- 3.87657341967489
#>         RSV <- c(0, 0.196446108190896, 1)
#>         eta.cl ~ 0.101251418415006
#>         eta.v ~ 0.0993872449483344
#>         eta.q ~ 0.101302674763154
#>         eta.v2 ~ 0.0730497519364148
#>     })
#>     model({
#>         cmt(CENTRAL)
#>         cmt(PERI)
#>         cl <- exp(lcl + eta.cl)
#>         v <- exp(lvc + eta.v)
#>         q <- exp(lq + eta.q)
#>         v2 <- exp(lvp + eta.v2)
#>         v1 <- v
#>         scale1 <- v
#>         k21 <- q/v2
#>         k12 <- q/v
#>         d/dt(CENTRAL) <- k21 * PERI - k12 * CENTRAL - cl * CENTRAL/v1
#>         d/dt(PERI) <- -k21 * PERI + k12 * CENTRAL
#>         f <- CENTRAL/scale1
#>         f ~ prop(RSV)
#>     })
#> }
#>  ── nonmem2rx extra properties: ──  
#> other properties include: $nonmemData, $etaData
#> captured NONMEM table outputs: $predData, $ipredData
#> NONMEM/rxode2 comparison data: $iwresCompare, $predCompare, $ipredCompare
#> NONMEM/rxode2 composite comparison: $predAtol, $predRtol, $ipredAtol, $ipredRtol, $iwresAtol, $iwresRtol
```

In this case the `new` model qualifies and now has all the information
from the imported nonmem2rx model.

This means you can estimate from the new model knowing it was the same
model specified in NONMEM.

Since `iwres` is affected by how your specify your residuals, pay
special attention to that validation. If it does not validate, you may
have forgot to translate the NONMEM variance estimate to the standard
deviation estimate required by many estimation methods.

### Converting the model to a nlmixr2 fit

Once you have a
[`rxode2()`](https://nlmixr2.github.io/rxode2/reference/rxode2.html)
model that:

- Qualifies against the NONMEM model,

- Has `nlmixr2` compatible residuals

You can then convert it to a `nlmixr2` fit object with `babelmixr2`:

``` r

library(babelmixr2)

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
#> rxode2 5.1.4 using 2 threads (see ?getRxThreads)
#>   no cache: create with `rxCreateCache()`
#> → Calculating residuals/tables
#> ✔ done

print(fit)
#> ── nlmixr² nonmem2rx reading NONMEM ver 7.4.3 ──
#> 
#>               OBJF      AIC      BIC Log-likelihood Condition#(Cov)
#> nonmem2rx 15977.28 20185.64 20237.23      -10083.82        335.4129
#>           Condition#(Cor)
#> nonmem2rx        2.096559
#> 
#> ── Time (sec $time): ──
#> 
#>             setup postprocess table compress NONMEM as.nlmixr2
#> elapsed 0.6853482       0.017 0.068    0.002 100.95      1.876
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>       Est.       SE   %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> lcl  1.370  0.02979  2.174    3.937 (3.713, 4.173)    32.64      1.935 
#> lvc  4.198  0.02952 0.7032    66.56 (62.82, 70.53)    32.33      2.465 
#> lq   1.380  0.05471  3.965    3.975 (3.571, 4.425)    32.65      40.50 
#> lvp  3.877  0.03483 0.8986    48.26 (45.07, 51.67)    27.53      28.37 
#> RSV 0.1964 0.003153  1.605 0.1964 (0.1903, 0.2026)                     
#>  
#>   Covariance Type ($covMethod): nonmem2rx
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
#> 0MINIMIZATION SUCCESSFUL
#>  NO. OF FUNCTION EVALUATIONS USED:      320
#>  NO. OF SIG. DIGITS IN FINAL EST.:  2.5
#> 
#>     IPRED relative difference compared to Nonmem IPRED: 0%; 95% percentile: (0%,0%); rtol=6.43e-06
#>     PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=6.41e-06
#>     IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (2.25e-05, 0.0418); atol=0.00167
#>     PRED absolute difference compared to Nonmem PRED: 95% percentile: (1.41e-07,0.00382); atol=6.41e-06
#>     nonmem2rx model file: '/home/runner/work/_temp/Library/nonmem2rx/mods/cpt/runODE032.ctl' 
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 2,280 × 25
#>   ID     TIME    DV  PRED    RES IPRED  IRES  IWRES eta.cl eta.v  eta.q eta.v2
#>   <fct> <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl>  <dbl>  <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0.25 1041. 1750. -710.  1215. -175. -0.732 -0.144 0.375 0.0650  0.241
#> 2 1      0.5  1629  1700.  -70.8 1192.  437.  1.87  -0.144 0.375 0.0650  0.241
#> 3 1      0.75  878. 1651. -774.  1169. -291. -1.27  -0.144 0.375 0.0650  0.241
#> # ℹ 2,277 more rows
#> # ℹ 13 more variables: f <dbl>, CENTRAL <dbl>, PERI <dbl>, cl <dbl>, v <dbl>,
#> #   q <dbl>, v2 <dbl>, v1 <dbl>, scale1 <dbl>, k21 <dbl>, k12 <dbl>, tad <dbl>,
#> #   dosenum <dbl>
```
