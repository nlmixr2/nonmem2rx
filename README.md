
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nonmem2rx

<!-- badges: start -->

[![R-CMD-check](https://github.com/nlmixr2/nonmem2rx/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nlmixr2/nonmem2rx/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/nlmixr2/nonmem2rx/branch/main/graph/badge.svg)](https://app.codecov.io/gh/nlmixr2/nonmem2rx?branch=main)
[![CRAN
version](http://www.r-pkg.org/badges/version/nonmem2rx)](https://cran.r-project.org/package=nonmem2rx)
[![CRAN total
downloads](https://cranlogs.r-pkg.org/badges/grand-total/nonmem2rx)](https://cran.r-project.org/package=nonmem2rx)
[![CRAN total
downloads](https://cranlogs.r-pkg.org/badges/nonmem2rx)](https://cran.r-project.org/package=nonmem2rx)
[![CodeFactor](https://www.codefactor.io/repository/github/nlmixr2/nonmem2rx/badge)](https://www.codefactor.io/repository/github/nlmixr2/nonmem2rx)
![r-universe](https://nlmixr2.r-universe.dev/badges/nonmem2rx)
<!-- badges: end -->

The goal of nonmem2rx is to convert a NONMEM control stream to a
`rxode2` (or even a `nlmixr2` fit) for easy clinical trial simulation in
R.

## Installation

You can install the development version of nonmem2rx from
[GitHub](https://github.com/) with the r-universe:

``` r
install.packages('nonmem2rx', repos = c('https://nlmixr2.r-universe.dev', 'https://cloud.r-project.org'))
```

When on CRAN, you can also get the CRAN version by:

``` r
install.packages('nonmem2rx')
```

## What you can do with `nonmem2rx`/`babelmixr2`

![nonmem2rx-flowchart](https://github.com/nlmixr2/nonmem2rx/assets/514778/803feb11-f2d9-4a5e-af08-834d9541ac11)

You can do many useful tasks directly converting between nlmixr2 and
NONMEM models; you can:

  - [Convert a NONMEM model to a rxode2
    model](https://nlmixr2.github.io/nonmem2rx/articles/import-nonmem.html)

  - [Do development in nlmixr2 and then run NONMEM from a nlmixr2
    model](https://nlmixr2.github.io/babelmixr2/articles/running-nonmem.html)
    for reviewers who want to know about NONMEM results.

  - In both conversions, [automatically make sure the model is
    translated
    correctly](https://nlmixr2.github.io/nonmem2rx/articles/rxode2-validate.html)
    (for
    [babelmixr2](https://nlmixr2.github.io/babelmixr2/articles/running-nonmem.html#optional-step-2-recover-a-failed-nonmem-run))

Then with nlmixr2 fit models and nonmem2rx models coming from both
conversions, you can:

  - [Perform simulations of new
    dosing](https://nlmixr2.github.io/nonmem2rx/articles/simulate-new-dosing.html)
    from the NONMEM model or even [simulate using the uncertainty in
    your model to simulate new
    scenarios](https://nlmixr2.github.io/nonmem2rx/articles/simulate-uncertainty.html)

  - [Modify the model to calculate derived
    parameters](https://nlmixr2.github.io/nonmem2rx/articles/simulate-extra-items.html)
    (like AUC). These parameters slow down NONMEM’s optimization, but
    can help in your simulation scenario.

  - [Simulating with Covariates/Input PK
    parameters](https://nlmixr2.github.io/nonmem2rx/articles/simulate-new-dosing-with-covs.html).
    This example shows approaches to resample from the input dataset for
    covariate selection.

With nonmem2rx and babelmixr2, convert the imported rxode2 model to a
nlmixr2 object, allowing:

  - [Generation of Word and PowerPoint plots with
    nlmixr2rpt](https://nlmixr2.github.io/nonmem2rx/articles/create-office.html)

  - [Easy VPC
    creation](https://nlmixr2.github.io/nonmem2rx/articles/create-vpc.html)
    (with `vpcPlot()`)

  - [Easy Individual plots with extra solved
    points](https://nlmixr2.github.io/nonmem2rx/articles/create-augPred.html).
    This will show the curvature of individual and population fits for
    sparse data-sets (with `augPred()`)

You can even use this conversion to help debug your NONMEM model (or
even try it in nlmixr2 instead)

  - [Understand how to simplify the NONMEM model to avoid rounding
    errors](https://nlmixr2.github.io/nonmem2rx/articles/read-rounding.html)

  - [Run nlmixr2’s covariance step when NONMEMs covariance step has
    failed](https://nlmixr2.github.io/nonmem2rx/articles/read-rounding.html#step-5-get-the-covariance-of-the-model)
    (in the linked example, there was no covariance step because
    rounding errors)

## Simple example

Once `nonmem2rx` has been loaded, you simply type the location of the
nonmem control stream for the parser to start. For example:

``` r
library(nonmem2rx)

# First we need the location of the nonmem control stream Since we are
# running an example, we will use one of the built-in examples in
# `nonmem2rx`
ctlFile <- system.file("mods/cpt/runODE032.ctl", package="nonmem2rx")
# You can use a control stream or other file. With the development
# version of `babelmixr2`, you can simply point to the listing file
mod <- nonmem2rx(ctlFile, lst=".res", save=FALSE)
#> ℹ getting information from  '/tmp/RtmphCfr0E/temp_libpathaf275a605b00/nonmem2rx/mods/cpt/runODE032.ctl'
#> ℹ reading in xml file
#> ℹ done
#> ℹ reading in phi file
#> ℹ done
#> ℹ reading in lst file
#> ℹ abbreviated list parsing
#> ℹ done
#> ℹ done
#> ℹ splitting control stream by records
#> ℹ done
#> ℹ Processing record $INPUT
#> ℹ Processing record $MODEL
#> ℹ Processing record $THETA
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
#> ℹ read in nonmem input data (for model validation): /tmp/RtmphCfr0E/temp_libpathaf275a605b00/nonmem2rx/mods/cpt/Bolus_2CPT.csv
#> ℹ ignoring lines that begin with a letter (IGNORE=@)'
#> ℹ applying names specified by $INPUT
#> ℹ subsetting accept/ignore filters code: .data[-which((.data$SD == 0)),]
#> ℹ done
#> using C compiler: ‘gcc (Ubuntu 11.3.0-1ubuntu1~22.04.1) 11.3.0’
#> In file included from /usr/share/R/include/R.h:71,
#>                  from /home/matt/R/x86_64-pc-linux-gnu-library/4.3/rxode2/include/rxode2.h:9,
#>                  from /home/matt/R/x86_64-pc-linux-gnu-library/4.3/rxode2parse/include/rxode2_model_shared.h:3,
#>                  from rx_d16f021bc9a6b4f5e2be95cdc7bf3d57_.c:115:
#> /usr/share/R/include/R_ext/Complex.h:80:6: warning: ISO C99 doesn’t support unnamed structs/unions [-Wpedantic]
#>    80 |     };
#>       |      ^
#> ℹ read in nonmem IPRED data (for model validation): /tmp/RtmphCfr0E/temp_libpathaf275a605b00/nonmem2rx/mods/cpt/runODE032.csv
#> ℹ done
#> ℹ changing most variables to lower case
#> ℹ done
#> ℹ replace theta names
#> ℹ done
#> ℹ replace eta names
#> ℹ done (no labels)
#> ℹ renaming compartments
#> ℹ done
#> using C compiler: ‘gcc (Ubuntu 11.3.0-1ubuntu1~22.04.1) 11.3.0’
#> In file included from /usr/share/R/include/R.h:71,
#>                  from /home/matt/R/x86_64-pc-linux-gnu-library/4.3/rxode2/include/rxode2.h:9,
#>                  from /home/matt/R/x86_64-pc-linux-gnu-library/4.3/rxode2parse/include/rxode2_model_shared.h:3,
#>                  from rx_edd6c2bb8fc0df18bd2c37d123e584da_.c:115:
#> /usr/share/R/include/R_ext/Complex.h:80:6: warning: ISO C99 doesn’t support unnamed structs/unions [-Wpedantic]
#>    80 |     };
#>       |      ^
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
#>         ipred ~ prop(RSV)
#>     })
#> }
#>  ── nonmem2rx translation notes ($notes): ──  
#>    • there are duplicate eta names, not renaming duplicate parameters 
#>    • there are duplicate theta names, not renaming duplicate parameters 
#>  ── nonmem2rx extra properties: ──  
#> other properties include: $nonmemData, $etaData, $thetaMat, $dfSub, $dfObs
#> captured NONMEM table outputs: $predData, $ipredData
#> NONMEM/rxode2 comparison data: $iwresCompare, $predCompare, $ipredCompare
#> NONMEM/rxode2 composite comparison: $predAtol, $predRtol, $ipredAtol, $ipredRtol, $iwresAtol, $iwresRtol
```

You can see this automatically validates NONMEM and rxode2 outputs for a
couple of metrics.

# External projects that contributed to the tool’s validation

The `nonmem2rx` tool was validated against:

  - The `PsN` library test suite of NONMEM listings
    (<https://github.com/UUPharmacometrics/PsN/tree/master/test>)

  - The ddmore model scrapings
    (<https://github.com/dpastoor/ddmore_scraping>).

  - Models from NONMEM design tutorial Bauer 2021
    <https://doi.org/10.1002/psp4.12713>

  - Models from NONMEM tutorial 1 (Bauer 2019)
    <https://doi.org/10.1002/psp4.12404>

  - Models from NONMEM tutorial 2 (Bauer 2019)
    <https://doi.org/10.1002/psp4.12422>

Due to the sheer size of the zipped models for these nonmem control
stream sources, these are excluded to keep the binary below 3 mgs (CRAN
requirement).

However, I would like to acknowledge all who helped in these projects.
With these projects the NONMEM conversion to rxode2 has been made much
more robust.

Still, while the tests are not/will not be in the CRAN binaries, you can
test them yourself by:

1.  Downloading this repository
2.  Running the tests `devtools::test()`
