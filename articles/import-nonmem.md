# Importing NONMEM into rxode2

The goal of `nonmem2rx` is to convert a NONMEM control stream to
`rxode2` for easy clinical trial simulation in R.

Here is a quick example of a conversion:

``` r
library(nonmem2rx)

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
#> ℹ ignoring lines that begin with a letter (IGNORE=@)'
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
mod
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

## Setting up `nonmem2rx` for your model

Some common options that you may want to change when importing NONMEM
control stream are:

- The default NONMEM output extension; By default it is `.lst`. You can
  set it to something else, like `.res`, using the following option:
  `options(nonmem2rx.lst=".res")`.

- Turn on [extended control
  stream](https://wfn.sourceforge.net/wfncs.htm#control_streams)
  support. You can turn it on by `options(nonmem2rx.extended=TRUE)`

You probably also want to change the name of parameters and
compartments. The easiest way to name the parameters whatever you want
is to pre-specify the names. For example:

``` r
mod <- nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res", save=FALSE,
                 thetaNames=c("lcl", "lvc", "lq", "lvp", "prop.sd"),
                 etaNames=c("eta.cl", "eta.vc", "eta.q","eta.vp"),
                 cmtNames = c("central", "perip"))
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
#> ℹ ignoring lines that begin with a letter (IGNORE=@)'
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
#> ℹ done
#> ℹ renaming compartments
#> ℹ done
#> ℹ solving ipred problem
#> ℹ done
#> ℹ solving pred problem
#> ℹ done

mod
#>  ── rxode2-based free-form 2-cmt ODE model ────────────────────────────────────── 
#>  ── Initalization: ──  
#> Fixed Effects ($theta): 
#>       lcl       lvc        lq       lvp   prop.sd 
#> 1.3703404 4.1981491 1.3800349 3.8765734 0.1964461 
#> 
#> Omega ($omega): 
#>           eta.cl     eta.vc     eta.q     eta.vp
#> eta.cl 0.1012514 0.00000000 0.0000000 0.00000000
#> eta.vc 0.0000000 0.09938724 0.0000000 0.00000000
#> eta.q  0.0000000 0.00000000 0.1013027 0.00000000
#> eta.vp 0.0000000 0.00000000 0.0000000 0.07304975
#> 
#> States ($state or $stateDf): 
#>   Compartment Number Compartment Name
#> 1                  1          central
#> 2                  2            perip
#>  ── μ-referencing ($muRefTable): ──  
#>   theta    eta level
#> 1   lcl eta.cl    id
#> 2   lvc eta.vc    id
#> 3    lq  eta.q    id
#> 4   lvp eta.vp    id
#> 
#>  ── Model (Normalized Syntax): ── 
#> function() {
#>     description <- "BOLUS_2CPT_CLV1QV2 SINGLE DOSE FOCEI (120 Ind/2280 Obs) runODE032"
#>     dfObs <- 2280
#>     dfSub <- 120
#>     sigma <- lotri({
#>         eps1 ~ 1
#>     })
#>     thetaMat <- lotri({
#>         lcl ~ c(lcl = 0.000887681)
#>         lvc ~ c(lcl = -0.00010551, lvc = 0.000871409)
#>         lq ~ c(lcl = 0.000184416, lvc = -0.000106195, lq = 0.00299336)
#>         lvp ~ c(lcl = -0.000120234, lvc = -5.06663e-05, lq = 0.000165252, 
#>             lvp = 0.00121347)
#>         prop.sd ~ c(lcl = 5.2783e-08, lvc = -1.56562e-05, lq = 5.99331e-06, 
#>             lvp = -2.53991e-05, prop.sd = 9.94218e-06)
#>         eps1 ~ c(lcl = 0, lvc = 0, lq = 0, lvp = 0, prop.sd = 0, 
#>             eps1 = 0)
#>         eta.cl ~ c(lcl = -4.71273e-05, lvc = 4.69667e-05, lq = -3.64271e-05, 
#>             lvp = 2.54796e-05, prop.sd = -8.16885e-06, eps1 = 0, 
#>             eta.cl = 0.000169296)
#>         omega.2.1 ~ c(lcl = 0, lvc = 0, lq = 0, lvp = 0, prop.sd = 0, 
#>             eps1 = 0, eta.cl = 0, omega.2.1 = 0)
#>         eta.vc ~ c(lcl = -7.37156e-05, lvc = 2.56634e-05, lq = -8.08349e-05, 
#>             lvp = 1.37e-05, prop.sd = -4.36564e-06, eps1 = 0, 
#>             eta.cl = 8.75181e-06, omega.2.1 = 0, eta.vc = 0.00015125)
#>         omega.3.1 ~ c(lcl = 0, lvc = 0, lq = 0, lvp = 0, prop.sd = 0, 
#>             eps1 = 0, eta.cl = 0, omega.2.1 = 0, eta.vc = 0, 
#>             omega.3.1 = 0)
#>         omega.3.2 ~ c(lcl = 0, lvc = 0, lq = 0, lvp = 0, prop.sd = 0, 
#>             eps1 = 0, eta.cl = 0, omega.2.1 = 0, eta.vc = 0, 
#>             omega.3.1 = 0, omega.3.2 = 0)
#>         eta.q ~ c(lcl = 6.63383e-05, lvc = -8.19002e-05, lq = 0.000548985, 
#>             lvp = 0.000168356, prop.sd = 1.59122e-06, eps1 = 0, 
#>             eta.cl = 3.48714e-05, omega.2.1 = 0, eta.vc = 4.31593e-07, 
#>             omega.3.1 = 0, omega.3.2 = 0, eta.q = 0.000959029)
#>         omega.4.1 ~ c(lcl = 0, lvc = 0, lq = 0, lvp = 0, prop.sd = 0, 
#>             eps1 = 0, eta.cl = 0, omega.2.1 = 0, eta.vc = 0, 
#>             omega.3.1 = 0, omega.3.2 = 0, eta.q = 0, omega.4.1 = 0)
#>         omega.4.2 ~ c(lcl = 0, lvc = 0, lq = 0, lvp = 0, prop.sd = 0, 
#>             eps1 = 0, eta.cl = 0, omega.2.1 = 0, eta.vc = 0, 
#>             omega.3.1 = 0, omega.3.2 = 0, eta.q = 0, omega.4.1 = 0, 
#>             omega.4.2 = 0)
#>         omega.4.3 ~ c(lcl = 0, lvc = 0, lq = 0, lvp = 0, prop.sd = 0, 
#>             eps1 = 0, eta.cl = 0, omega.2.1 = 0, eta.vc = 0, 
#>             omega.3.1 = 0, omega.3.2 = 0, eta.q = 0, omega.4.1 = 0, 
#>             omega.4.2 = 0, omega.4.3 = 0)
#>         eta.vp ~ c(lcl = -9.49661e-06, lvc = 0.000110108, lq = -0.000306537, 
#>             lvp = -9.12897e-05, prop.sd = 3.1877e-06, eps1 = 0, 
#>             eta.cl = 1.36628e-05, omega.2.1 = 0, eta.vc = -1.95096e-05, 
#>             omega.3.1 = 0, omega.3.2 = 0, eta.q = -0.00012977, 
#>             omega.4.1 = 0, omega.4.2 = 0, omega.4.3 = 0, eta.vp = 0.00051019)
#>     })
#>     validation <- c("IPRED relative difference compared to Nonmem IPRED: 0%; 95% percentile: (0%,0%); rtol=6.43e-06", 
#>         "IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (2.19e-05, 0.0418); atol=0.00167", 
#>         "IWRES relative difference compared to Nonmem IWRES: 0%; 95% percentile: (0%,0.01%); rtol=8.99e-06", 
#>         "IWRES absolute difference compared to Nonmem IWRES: 95% percentile: (1.82e-07, 4.63e-05); atol=3.65e-06", 
#>         "PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=6.41e-06", 
#>         "PRED absolute difference compared to Nonmem PRED: 95% percentile: (1.41e-07,0.00382) atol=6.41e-06")
#>     ini({
#>         lcl <- 1.37034036528946
#>         label("log Cl")
#>         lvc <- 4.19814911033061
#>         label("log Vc")
#>         lq <- 1.38003493562413
#>         label("log Q")
#>         lvp <- 3.87657341967489
#>         label("log Vp")
#>         prop.sd <- c(0, 0.196446108190896, 1)
#>         label("RSV")
#>         eta.cl ~ 0.101251418415006
#>         eta.vc ~ 0.0993872449483344
#>         eta.q ~ 0.101302674763154
#>         eta.vp ~ 0.0730497519364148
#>     })
#>     model({
#>         cmt(central)
#>         cmt(perip)
#>         cl <- exp(lcl + eta.cl)
#>         v <- exp(lvc + eta.vc)
#>         q <- exp(lq + eta.q)
#>         v2 <- exp(lvp + eta.vp)
#>         v1 <- v
#>         scale1 <- v
#>         k21 <- q/v2
#>         k12 <- q/v
#>         d/dt(central) <- k21 * perip - k12 * central - cl * central/v1
#>         d/dt(perip) <- -k21 * perip + k12 * central
#>         f <- central/scale1
#>         ipred <- f
#>         rescv <- prop.sd
#>         ipred ~ prop(prop.sd)
#>     })
#> }
#>  ── nonmem2rx extra properties: ──  
#> other properties include: $nonmemData, $etaData
#> captured NONMEM table outputs: $predData, $ipredData
#> NONMEM/rxode2 comparison data: $iwresCompare, $predCompare, $ipredCompare
#> NONMEM/rxode2 composite comparison: $predAtol, $predRtol, $ipredAtol, $ipredRtol, $iwresAtol, $iwresRtol
```

This checks the parameter names to make sure they are the same length as
the input names, if they are not, the model will skip parameter renaming
and keep the default translation names `theta#` and `eta#`.

As a note, `sigma` parameters are not currently renamed; So for the
following model (which grabs the parameter automatically labels to
generate variables), `sigma` is simply `eps#`.

``` r
mod <- nonmem2rx(system.file("Theopd.ctl", package="nonmem2rx"), save=FALSE)
#> ℹ getting information from  '/home/runner/work/_temp/Library/nonmem2rx/Theopd.ctl'
#> ℹ reading in lst file
#> ℹ seeing if file argument is actually lst file
#> ℹ not list file, control stream
#> ℹ done
#> ℹ splitting control stream by records
#> ℹ done
#> ℹ Processing record $INPUT
#> ℹ Processing record $gTHETA
#> ℹ Processing record $OMEGA
#> ℹ Processing record $SIGMA
#> ℹ Processing record $PROBLEM
#> ℹ Processing record $DATA
#> ℹ Processing record $ESTIMATION
#> ℹ Ignore record $ESTIMATION
#> ℹ Processing record $COVARIANCE
#> ℹ Ignore record $COVARIANCE
#> ℹ Processing record $PRED
#> ℹ Processing record $TABLE
#> ℹ final parameters not updated, will skip validation
#> ℹ changing most variables to lower case
#> ℹ done
#> ℹ replace theta names
#> ℹ done
#> ℹ replace eta names
#> ℹ done
mod
#>  ── rxode2-based Pred model ───────────────────────────────────────────────────── 
#>  ── Initalization: ──  
#> Fixed Effects ($theta): 
#>   POP_E0 POP_EMAX  POP_C50 
#>      150      200       10 
#> 
#> Omega ($omega): 
#>          PPV_E0 PPV_EMAX PPV_C50
#> PPV_E0      0.5      0.0     0.0
#> PPV_EMAX    0.0      0.5     0.0
#> PPV_C50     0.0      0.0     0.5
#>  ── Model (Normalized Syntax): ── 
#> function() {
#>     description <- "theophylline pharmacodynamics standard control stream"
#>     sigma <- lotri({
#>         eps1 ~ 100
#>     })
#>     validation <- "final parameters not updated, validation skipped"
#>     ini({
#>         POP_E0 <- c(0, 150)
#>         label("POP_E0 1")
#>         POP_EMAX <- c(0, 200)
#>         label("POP_EMAX 2")
#>         POP_C50 <- c(0.001, 10)
#>         label("POP_C50 3")
#>         PPV_E0 ~ 0.5
#>         PPV_EMAX ~ 0.5
#>         PPV_C50 ~ 0.5
#>     })
#>     model({
#>         e0 <- POP_E0 * exp(PPV_E0)
#>         emax <- POP_EMAX * exp(PPV_EMAX)
#>         ec50 <- POP_C50 * exp(PPV_C50)
#>         y <- e0 + emax * THEO/(THEO + ec50) + eps1
#>     })
#> }
#>  ── nonmem2rx extra properties: ──  
#> 
#> Sigma ($sigma): 
#>      eps1
#> eps1  100
#> 
#> other properties include: $etaData
#> captured NONMEM table outputs: $predData, $ipredData
#> NONMEM/rxode2 comparison data: $iwresCompare, $predCompare, $ipredCompare
#> NONMEM/rxode2 composite comparison: $predAtol, $predRtol, $ipredAtol, $ipredRtol, $iwresAtol, $iwresRtol
```

You can still rename however you wish, though, using model piping
([`rxRename()`](https://nlmixr2.github.io/rxode2/reference/rxRename.html)
or
[`dplyr::rename()`](https://dplyr.tidyverse.org/reference/rename.html)
would both work):

``` r
mod <- mod %>% rxRename(add.var=eps1)
mod
#>  ── rxode2-based Pred model ───────────────────────────────────────────────────── 
#>  ── Initalization: ──  
#> Fixed Effects ($theta): 
#>   POP_E0 POP_EMAX  POP_C50 
#>      150      200       10 
#> 
#> Omega ($omega): 
#>          PPV_E0 PPV_EMAX PPV_C50
#> PPV_E0      0.5      0.0     0.0
#> PPV_EMAX    0.0      0.5     0.0
#> PPV_C50     0.0      0.0     0.5
#>  ── Model (Normalized Syntax): ── 
#> function() {
#>     description <- "theophylline pharmacodynamics standard control stream"
#>     sigma <- lotri({
#>         add.var ~ 100
#>     })
#>     validation <- "final parameters not updated, validation skipped"
#>     ini({
#>         POP_E0 <- c(0, 150)
#>         label("POP_E0 1")
#>         POP_EMAX <- c(0, 200)
#>         label("POP_EMAX 2")
#>         POP_C50 <- c(0.001, 10)
#>         label("POP_C50 3")
#>         PPV_E0 ~ 0.5
#>         PPV_EMAX ~ 0.5
#>         PPV_C50 ~ 0.5
#>     })
#>     model({
#>         e0 <- POP_E0 * exp(PPV_E0)
#>         emax <- POP_EMAX * exp(PPV_EMAX)
#>         ec50 <- POP_C50 * exp(PPV_C50)
#>         y <- e0 + emax * THEO/(THEO + ec50) + add.var
#>     })
#> }
#>  ── nonmem2rx extra properties: ──  
#> 
#> Sigma ($sigma): 
#>         add.var
#> add.var     100
#> 
#> other properties include: $etaData
#> captured NONMEM table outputs: $predData, $ipredData
#> NONMEM/rxode2 comparison data: $iwresCompare, $predCompare, $ipredCompare
#> NONMEM/rxode2 composite comparison: $predAtol, $predRtol, $ipredAtol, $ipredRtol, $iwresAtol, $iwresRtol
```

This model does not specify the residuals in a way that makes sense to
`nlmixr2`. If you want, you can still [convert the `rxode2` model to a
nlmixr2
fit](https://nlmixr2.github.io/nonmem2rx/articles/convert-nlmixr2.html).

## Technical details about reading NONMEM to rxode2

The key files to import are the NONMEM control stream (or related file)
and the NONMEM output (often with a `.lst` or `.res` extension).

The import process steps are below:

- Read in the nonmem control stream and convert the model to a `rxode2`
  ui function.

- Try to determine an endpoint/residual specification in the model (if
  possible), and convert to a fully qualified ui model that can be used
  in `nlmixr2` and `rxode2`. If it cannot be determined automatically,
  [you can manually fix
  this](https://nlmixr2.github.io/nonmem2rx/articles/convert-nlmixr2.html)
  and still convert to a `nlmixr2` object (if the data/estimates are
  available of course).

- If available, `nonmem2rx` will read the final parameter estimates and
  update the model.

- The converter will read in the nonmem input dataset, and search for
  the output files with `IPRED`, `PRED` and the `ETA` values. The
  translated `rxode2` model is run for the population parameters and the
  individual parameters. This will then compare the results between
  `NONMEM` and `rxode2` to make sure the translation makes sense. This
  only works when `nonmem2rx` has access to the input data and the
  output with the `IWRES`, `IPRED`, `PRED` and the `ETA` values.

- Converts the upper case NONMEM variables to lower case (can be turned
  off with `nonmem2rx(..., toLowerLhs=FALSE))`)

- Replaces the NONMEM theta / eta names with the label-based names like
  an extended control stream (can be turned off with
  `nonmem2rx(thetaNames=FALSE, etaNames=FALSE)`)

- Replaces the compartment names with the defined compartment names in
  the control stream (ie `COMP=(compartmenName)`)
