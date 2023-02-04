
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
mod <- nonmem2rx(system.file("run001.mod", package="nonmem2rx"))
#> Warning: multiple $PROBLEM statements; only use first $PROBLEM for translation
#> Reading /tmp/RtmpTtRIFL/temp_libpath201f5e0d392c/nonmem2rx/run001.ext
#> ℹ change initial estimate of `theta1` to `26.2909`
#> ℹ change initial estimate of `theta2` to `1.34809`
#> ℹ change initial estimate of `theta3` to `4.20364`
#> ℹ change initial estimate of `theta4` to `0.207958`
#> ℹ change initial estimate of `theta5` to `0.20461`
#> ℹ change initial estimate of `theta6` to `0.0105527`
#> ℹ change initial estimate of `theta7` to `0.00717161`
#> ℹ change initial estimate of `eta1` to `0.0729525`
#> ℹ change initial estimate of `eta2` to `0.0380192`
#> ℹ change initial estimate of `eta3` to `1.90699`
#> ℹ done
#> ℹ changing most variables to lower case
#> ℹ done
#> ℹ replace theta names
#> ℹ done
#> ℹ replace eta names
#> ℹ done
mod 
#>  ── rxode2-based solved PK 1-compartment model with first-order absorption ────── 
#>  ── Initalization: ──  
#> Fixed Effects ($theta): 
#>      t.TVCL       t.TVV        TVKA         LAG       Prop.      t.Add. 
#> 26.29090000  1.34809000  4.20364000  0.20795800  0.20461000  0.01055270 
#>      t.CRCL 
#>  0.00717161 
#> 
#> Omega ($omega): 
#>           IIV.CL     IIV.V  IIV.KA
#> IIV.CL 0.0729525 0.0000000 0.00000
#> IIV.V  0.0000000 0.0380192 0.00000
#> IIV.KA 0.0000000 0.0000000 1.90699
#>  ── Model (Normalized Syntax): ── 
#> function() {
#>     description <- c(";; 1. Based on:     000", ";; 2. Description:       ", 
#>         ";;    NONMEM PK example for xpose", "    Parameter estimation", 
#>         "    Model simulations")
#>     sigma <- structure(1, dim = c(1L, 1L), dimnames = list("eps1", 
#>         "eps1"))
#>     ini({
#>         t.TVCL <- c(0, 26.2909)
#>         label("TVCL")
#>         t.TVV <- c(0, 1.34809)
#>         label("TVV")
#>         TVKA <- c(0, 4.20364)
#>         label("TVKA")
#>         LAG <- c(0, 0.207958)
#>         label("LAG")
#>         Prop. <- c(0, 0.20461)
#>         label("Prop.Err")
#>         t.Add. <- c(0, 0.0105527)
#>         label("Add.Err")
#>         t.CRCL <- c(0, 0.00717161, 0.02941)
#>         label("CRCL onCL")
#>         IIV.CL ~ 0.0729525
#>         IIV.V ~ 0.0380192
#>         IIV.KA ~ 1.90699
#>     })
#>     model({
#>         tvcl <- t.TVCL * (1 + t.CRCL * (CLCR - 65))
#>         tvv <- t.TVV * WT
#>         cl <- tvcl * exp(IIV.CL)
#>         v <- tvv * exp(IIV.V)
#>         ka <- TVKA * exp(IIV.KA)
#>         alag(depot) <- LAG
#>         k <- cl/v
#>         rxlincmt1 <- linCmt()
#>         f <- rxlincmt1
#>         a1 <- depot
#>         a2 <- central
#>         ipred <- a2/v
#>         ipred ~ add(t.Add.) + prop(Prop.) + combined1()
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
