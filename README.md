
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

The goal of nonmem2rx is to convert a NONMEM control stream to `rxode2`
for easy clinical trial simulation in R.

## Installation

You can install the development version of nonmem2rx from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("nlmixr2/nonmem2rx")
```

## Example

Once `nonmem2rx` has been loaded, you simply type the location of the
nonmem control stream for the parser to start. For example:

``` r
library(nonmem2rx)
mod <- nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res")
#> ℹ reading file '/tmp/RtmprZp9wS/temp_libpath16fde75a86264/nonmem2rx/mods/cpt/runODE032.ctl'
#> ℹ done
#> ℹ checking if the file is a nonmem output
#> ℹ this is control stream
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
#> Warning in nonmem2rxRec.sub(.ret): $SUBROUTINES TOL=# ignored
#> ℹ Processing record $PK
#> ℹ Processing record $DES
#> ℹ Processing record $ERROR
#> ℹ Processing record $ESTIMATION
#> ℹ Ignore record $ESTIMATION
#> ℹ Processing record $COVARIANCE
#> ℹ Ignore record $COVARIANCE
#> ℹ Processing record $TABLE
#> ℹ Getting run information from output
#> ℹ done
#> ℹ change initial estimate of `theta1` to `1.37034`
#> ℹ change initial estimate of `theta2` to `4.19815`
#> ℹ change initial estimate of `theta3` to `1.38003`
#> ℹ change initial estimate of `theta4` to `3.87657`
#> ℹ change initial estimate of `theta5` to `0.196446`
#> ℹ change initial estimate of `eta1` to `0.101251`
#> ℹ change initial estimate of `eta2` to `0.0993872`
#> ℹ change initial estimate of `eta3` to `0.101303`
#> ℹ change initial estimate of `eta4` to `0.0730498`
#> ℹ read in nonmem input data (for model validation): /tmp/RtmprZp9wS/temp_libpath16fde75a86264/nonmem2rx/mods/cpt/Bolus_2CPT.csv
#> ℹ ignoring lines that begin with a letter (IGNORE=@)'
#> ℹ applying names specified by $INPUT
#> ℹ subsetting accept/ignore filters code: .data[-which((.data$SD == 0)),]
#> ℹ done
#> ℹ read in nonmem IPRED data (for model validation): /tmp/RtmprZp9wS/temp_libpath16fde75a86264/nonmem2rx/mods/cpt/runODE032.csv
#> ℹ done
#> ℹ read in nonmem ETA data (for model validation): /tmp/RtmprZp9wS/temp_libpath16fde75a86264/nonmem2rx/mods/cpt/runODE032.csv
#> ℹ done
#> ℹ changing most variables to lower case
#> ℹ done
#> ℹ replace theta names
#> Warning: there are duplicate theta names, not renaming duplicate parameters
#> ℹ done
#> ℹ replace eta names
#> Warning: there are duplicate eta names, not renaming duplicate parameters
#> ℹ done (no labels)
#> ℹ renaming compartments
#> ℹ done
mod 
#>  ── rxode2-based free-form 2-cmt ODE model ────────────────────────────────────── 
#>  ── Initalization: ──  
#> Fixed Effects ($theta): 
#>   theta1   theta2   theta3   theta4      RSV 
#> 1.370340 4.198150 1.380030 3.876570 0.196446 
#> 
#> Omega ($omega): 
#>          eta1      eta2     eta3      eta4
#> eta1 0.101251 0.0000000 0.000000 0.0000000
#> eta2 0.000000 0.0993872 0.000000 0.0000000
#> eta3 0.000000 0.0000000 0.101303 0.0000000
#> eta4 0.000000 0.0000000 0.000000 0.0730498
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
#>     validation <- c("IPRED relative difference compared to Nonmem IPRED: 0%; 95% percentile: (0%,0%); rtol=6.99e-06", 
#>         "IPRED absolute difference compared to Nonmem IPRED: 95% percentile: (2.29e-05, 0.042); atol=0.00174", 
#>         "PRED relative difference compared to Nonmem PRED: 0%; 95% percentile: (0%,0%); rtol=7.26e-06", 
#>         "PRED absolute difference compared to Nonmem PRED: 95% percentile: (9.23e-07,0.00384) atol=7.26e-06")
#>     ini({
#>         theta1 <- 1.37034
#>         label("log Cl")
#>         theta2 <- 4.19815
#>         label("log Vc")
#>         theta3 <- 1.38003
#>         label("log Q")
#>         theta4 <- 3.87657
#>         label("log Vp")
#>         RSV <- c(0, 0.196446, 1)
#>         label("RSV")
#>         eta1 ~ 0.101251
#>         eta2 ~ 0.0993872
#>         eta3 ~ 0.101303
#>         eta4 ~ 0.0730498
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
```

The process steps are below:

  - Read in the nonmem control stream and convert the model to a
    `rxode2` ui function.

  - Try to determine an endpoint in the model (if possible), and convert
    to a fully qualified ui model that can be used in `nlmixr2` and
    `rxode2`.

  - If available, `nonmem2rx` will read the final parameter estimates
    and update the model. (It tries the `.ext` file followed by the
    `.lst` file; without these files, will simply keep the initial
    estimates in the model).

  - This will read in the nonmem input dataset, and search for the
    output files with `IPRED`, `PRED` and the `ETA` values. The
    translated `rxode2` model is run for the population parameters and
    the individual parameters. This will then compare the results
    between `NONMEM` and `rxode2` to make sure the translation makes
    sense. This only works when `nonmem2rx` has access to the input data
    and the output with the `IPRED`, `PRED` and the `ETA` values.

  - Converts the upper case NONMEM variables to lower case.

  - Replaces the NONMEM theta / eta names with the label-based names
    like an extended control stream

  - Replaces the compartment names with the defined compartment names in
    the control stream (ie `COMP=(compartmenName)`)

### Comparing differences between `NONMEM` and `rxode2`

You may wish to see where the differences in predictions are between
NONMEM and rxode2.

From the modified returned `ui` object you can look at the rtol, atol as
follows:

``` r
mod$ipredAtol
mod$ipredRtol
mod$predAtol
mod$predAtol
```

You can see they do not exactly match. You can explore these difference
further if you wish by looking at the `ipredCompare` and `predCompare`
datasets:

``` r
head(mod$ipredCompare)

head(mod$predCompare)
```

In these cases you can see that NONMEM seems to round the values for the
output (though I am not clear what the rounding rules are), but rxode2
seems to keep the entire number.

Note this is the **observation data only** that is compared. Dosing
predictions are excluded from these comparisons.

You can also explore the NONMEM input dataset that was used to make the
validation predictions (dosing and observations) by the `$nonmemData`
item:

``` r
head(mod$nonmemData)
```

### Simulating from the model

Unlike the traditional `rxode2` `ui` objects, this contains information
about the model that can be used for simulation with uncertainty: theta
covariance, number of subjects and number of observations. You can see
them below if you wish:

``` r
mod$dfSub # Number of subjects
mod$dfObs # Number of observations
# Covariance of the thetas (and omegas in this case)
mod$thetaMat
```
