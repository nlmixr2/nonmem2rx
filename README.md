
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
#> ℹ getting information from  '/tmp/Rtmps9ZnWQ/temp_libpath115e2a3a319c/nonmem2rx/mods/cpt/runODE032.ctl'
#> ℹ reading in xml file
#> ℹ done
#> ℹ reading in phi file
#> ℹ problems reading phi file
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
#> Warning in nonmem2rxRec.sub(.ret): $SUBROUTINES TOL=# ignored
#> ℹ Processing record $PK
#> ℹ Processing record $DES
#> ℹ Processing record $ERROR
#> ℹ Processing record $ESTIMATION
#> ℹ Ignore record $ESTIMATION
#> ℹ Processing record $COVARIANCE
#> ℹ Ignore record $COVARIANCE
#> ℹ Processing record $TABLE
#> ℹ change initial estimate of `theta1` to `1.37034`
#> ℹ change initial estimate of `theta2` to `4.19815`
#> ℹ change initial estimate of `theta3` to `1.38003`
#> ℹ change initial estimate of `theta4` to `3.87657`
#> ℹ change initial estimate of `theta5` to `0.196446`
#> ℹ change initial estimate of `eta1` to `0.101251`
#> ℹ change initial estimate of `eta2` to `0.0993872`
#> ℹ change initial estimate of `eta3` to `0.101303`
#> ℹ change initial estimate of `eta4` to `0.0730498`
#> ℹ read in nonmem input data (for model validation): /tmp/Rtmps9ZnWQ/temp_libpath115e2a3a319c/nonmem2rx/mods/cpt/Bolus_2CPT.csv
#> ℹ ignoring lines that begin with a letter (IGNORE=@)'
#> ℹ applying names specified by $INPUT
#> ℹ subsetting accept/ignore filters code: .data[-which((.data$SD == 0)),]
#> ℹ done
#> ℹ read in nonmem IPRED data (for model validation): /tmp/Rtmps9ZnWQ/temp_libpath115e2a3a319c/nonmem2rx/mods/cpt/runODE032.csv
#> ℹ done
#> ℹ read in nonmem ETA data (for model validation): /tmp/Rtmps9ZnWQ/temp_libpath115e2a3a319c/nonmem2rx/mods/cpt/runODE032.csv
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
#> ℹ solving ipred problem
#> ℹ done
#> ℹ solving pred problem
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
#>         50% 
#> 0.001735466
mod$ipredRtol
#>          50% 
#> 6.994654e-06
mod$predAtol
#>          50% 
#> 7.263317e-06
mod$predAtol
#>          50% 
#> 7.263317e-06
```

You can see they do not exactly match. You can explore these difference
further if you wish by looking at the `ipredCompare` and `predCompare`
datasets:

``` r
head(mod$ipredCompare)
#>   ID TIME nonmemIPRED    IPRED
#> 1  1 0.25      1215.4 1215.362
#> 2  1 0.50      1191.9 1191.928
#> 3  1 0.75      1169.2 1169.168
#> 4  1 1.00      1147.1 1147.061
#> 5  1 1.50      1104.7 1104.724
#> 6  1 2.00      1064.8 1064.762

head(mod$predCompare)
#>   ID TIME nonmemPRED     PRED
#> 1  1 0.25     1750.3 1750.289
#> 2  1 0.50     1699.8 1699.833
#> 3  1 0.75     1651.3 1651.348
#> 4  1 1.00     1604.8 1604.752
#> 5  1 1.50     1516.9 1516.912
#> 6  1 2.00     1435.7 1435.723
```

In these cases you can see that NONMEM seems to round the values for the
output (the rounding rules are based on the `FORMAT` option), but rxode2
seems to keep the entire number.

Note this is the **observation data only** that is compared. Dosing
predictions are excluded from these comparisons.

You can also explore the NONMEM input dataset that was used to make the
validation predictions (dosing and observations) by the `$nonmemData`
item:

``` r
head(mod$nonmemData) # with nlme loaded you can also use getData(mod)
#>   ID TIME     DV   LNDV MDV    AMT EVID   DOSE   V1I  CLI   QI   V2I SSX IIX SD
#> 1  1 0.00    0.0 0.0000   1 120000    1 120000 101.5 3.57 6.99 59.19  99   0  1
#> 2  1 0.25 1040.7 6.9476   0      0    0 120000 101.5 3.57 6.99 59.19  99   0  1
#> 3  1 0.50 1629.0 7.3957   0      0    0 120000 101.5 3.57 6.99 59.19  99   0  1
#> 4  1 0.75  877.8 6.7774   0      0    0 120000 101.5 3.57 6.99 59.19  99   0  1
#> 5  1 1.00 1247.2 7.1286   0      0    0 120000 101.5 3.57 6.99 59.19  99   0  1
#> 6  1 1.50 1225.1 7.1107   0      0    0 120000 101.5 3.57 6.99 59.19  99   0  1
#>   CMT
#> 1   1
#> 2   1
#> 3   1
#> 4   1
#> 5   1
#> 6   1
```

### Notes on validation

The validation of the model uses the best data available for NONMEM
estimates. This is:

  - `theta` or population parameters
  - `eta` or individual parameters

The `omega` and `sigma` matrices are captured but do not contribute to
the validation. Also the overall covariance is captured, but not used in
the validation.

#### `theta` parameters:

This section discusses the source of the `theta` parameters. Often it is
the same source of the `omega` and `sigma` matrices as well. In many
cases it is the source of the overall covariance too. So the sources of
all these data will be mentioned.

In order of preference, the model run parameters are gathered from:

  - XML parameter estimates (which are the most accurate). On some
    systems, the `xml` may be broken (or not present). This also gets
    the covariance, `omega`, `sigma` values.

  - `.ext` is the next source of the `theta`, `sigma` and `omega`
    matrices, and is slightly less accurate than the `xml` file. If the
    covariance file `.cov` exists the overall covariance is read from
    this file when the `xml` file is not present.

  - The NONMEM output file is the next source of information for the
    `theta` values. This is the least accurate, but may be useful for
    models in libraries like the ddmore repository since often the
    `xml`, `ext` and `cov` files are not present.

  - The model control stream is the last source of parameter estimates,
    and may not even reflect the minimum value of the model. In common
    practice many people adjust parameters close to the final parameter
    estimates so this may be close enough, or a starting place to start
    your own estimation with `nlmxir2`.

### Eta parameters

The `eta` parameters come from 2 different sources.

  - The first file (which is preferred) is used for classical estimation
    methods like `focei`. In these circumstances the `.phi` file
    contains more accurate estimate information than the table files
    (without a `FORMAT` specifier).

  - The next source of the `eta` parameters come from the tables. The
    tables by default are not very accurate compared to the `xml` or
    `ext` files above. The accuracy can be increased by changing the
    `FORMAT` option in the NONMEM tables.

Since these values are not as accurate as the population parameters,
these are much more likely to have a mismatch between `rxode2` and
`NONMEM`. You can compare the predictions if you wish.

### What NONMEM and rxode2 compare

For the comparison we use the `PRED` and `IPRED` output in the tables
from NONMEM.

### Using `FORMAT` in nonmem

If you wish to be more precise for the `IPRED` and `ETA` values output
in your tables you can change the FORTRAN format to a something a bit
higher.

The default for tables is `FORMAT=s1PE11.4`, if you really want to
increase the precision for the output you could use `FORMAT=s1PE17.9` or
something similar, this can help with validation of individuals if you
get in a situation where it is important.

See [discussion on
nmusers](mail-archive.com/nmusers@globomaxnm.com/msg05466.html).

That being said, a verification on the population level and a
verification from a vpc is likely sufficient.

### What do the values mean

Depending on the precision the validation numbers can be quite
different. For example:

``` r
# full parameter precision
mod <- suppressMessages(nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res"))
#> Warning in nonmem2rxRec.sub(.ret): $SUBROUTINES TOL=# ignored
#> Warning: there are duplicate theta names, not renaming duplicate parameters
#> Warning: there are duplicate eta names, not renaming duplicate parameters

print(mod$ipredAtol)
#>         50% 
#> 0.001735466
print(mod$ipredRtol)
#>          50% 
#> 6.994654e-06

print(mod$predAtol)
#>          50% 
#> 7.263317e-06
print(mod$predRtol)
#>          50% 
#> 7.263317e-06

# now reduce precision by using table/lst output only
mod <- suppressMessages(nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"), lst=".res",
                                  useXml=FALSE, useExt=FALSE,usePhi=FALSE))
#> Warning in nonmem2rxRec.sub(.ret): $SUBROUTINES TOL=# ignored
#> Warning: there are duplicate theta names, not renaming duplicate parameters
#> Warning: there are duplicate eta names, not renaming duplicate parameters

print(mod$predAtol)
#>         50% 
#> 0.001258165
print(mod$predRtol)
#>         50% 
#> 0.001258165

print(mod$ipredAtol)
#>       50% 
#> 0.2199907
print(mod$ipredRtol)
#>         50% 
#> 0.001273287
```

You can see that using less precise values will lead to larger
differences between the NONMEM model predictions and the rxode2 model
predictions. The key to validating models is to use the most precision
in parameter estimates (thetas and etas).

You can have situations where the model validates for the most precise
estimates, the population predictions, but doesn’t seem to do a good job
for the individual estimates (which are a bit less precise since they
are not captured in the xml file). This could mean that one or more
`eta` values are highly sensitive to rounding.

Another possibility is that there are slight differences in how NONMEM
and rxode2 protects from division from zero and other possibilities that
can lead to `NaN` values.

If these model parameters are not as precise as you wish, try to get
more files, or maybe see if it still predicts the data accurately enough
by using the model to perform a `vpc`.

### Simulating from the model

Unlike the traditional `rxode2` `ui` objects, this contains information
about the model that can be used for simulation with uncertainty: theta
covariance, number of subjects and number of observations. You can see
them below if you wish:

``` r
mod$dfSub # Number of subjects
#> [1] 120
mod$dfObs # Number of observations
#> [1] 2280
# Covariance of the thetas (and omegas in this case)
mod$thetaMat
#>                 theta1       theta2       theta3       theta4          RSV eps1
#> theta1     8.87681e-04 -1.05510e-04  1.84416e-04 -1.20234e-04  5.27830e-08    0
#> theta2    -1.05510e-04  8.71409e-04 -1.06195e-04 -5.06663e-05 -1.56562e-05    0
#> theta3     1.84416e-04 -1.06195e-04  2.99336e-03  1.65252e-04  5.99331e-06    0
#> theta4    -1.20234e-04 -5.06663e-05  1.65252e-04  1.21347e-03 -2.53991e-05    0
#> RSV        5.27830e-08 -1.56562e-05  5.99331e-06 -2.53991e-05  9.94218e-06    0
#> eps1       0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00    0
#> eta1      -4.71273e-05  4.69667e-05 -3.64271e-05  2.54796e-05 -8.16885e-06    0
#> omega.2.1  0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00    0
#> eta2      -7.37156e-05  2.56634e-05 -8.08349e-05  1.37000e-05 -4.36564e-06    0
#> omega.3.1  0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00    0
#> omega.3.2  0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00    0
#> eta3       6.63383e-05 -8.19002e-05  5.48985e-04  1.68356e-04  1.59122e-06    0
#> omega.4.1  0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00    0
#> omega.4.2  0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00    0
#> omega.4.3  0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00  0.00000e+00    0
#> eta4      -9.49661e-06  1.10108e-04 -3.06537e-04 -9.12897e-05  3.18770e-06    0
#>                   eta1 omega.2.1         eta2 omega.3.1 omega.3.2         eta3
#> theta1    -4.71273e-05         0 -7.37156e-05         0         0  6.63383e-05
#> theta2     4.69667e-05         0  2.56634e-05         0         0 -8.19002e-05
#> theta3    -3.64271e-05         0 -8.08349e-05         0         0  5.48985e-04
#> theta4     2.54796e-05         0  1.37000e-05         0         0  1.68356e-04
#> RSV       -8.16885e-06         0 -4.36564e-06         0         0  1.59122e-06
#> eps1       0.00000e+00         0  0.00000e+00         0         0  0.00000e+00
#> eta1       1.69296e-04         0  8.75181e-06         0         0  3.48714e-05
#> omega.2.1  0.00000e+00         0  0.00000e+00         0         0  0.00000e+00
#> eta2       8.75181e-06         0  1.51250e-04         0         0  4.31593e-07
#> omega.3.1  0.00000e+00         0  0.00000e+00         0         0  0.00000e+00
#> omega.3.2  0.00000e+00         0  0.00000e+00         0         0  0.00000e+00
#> eta3       3.48714e-05         0  4.31593e-07         0         0  9.59029e-04
#> omega.4.1  0.00000e+00         0  0.00000e+00         0         0  0.00000e+00
#> omega.4.2  0.00000e+00         0  0.00000e+00         0         0  0.00000e+00
#> omega.4.3  0.00000e+00         0  0.00000e+00         0         0  0.00000e+00
#> eta4       1.36628e-05         0 -1.95096e-05         0         0 -1.29770e-04
#>           omega.4.1 omega.4.2 omega.4.3         eta4
#> theta1            0         0         0 -9.49661e-06
#> theta2            0         0         0  1.10108e-04
#> theta3            0         0         0 -3.06537e-04
#> theta4            0         0         0 -9.12897e-05
#> RSV               0         0         0  3.18770e-06
#> eps1              0         0         0  0.00000e+00
#> eta1              0         0         0  1.36628e-05
#> omega.2.1         0         0         0  0.00000e+00
#> eta2              0         0         0 -1.95096e-05
#> omega.3.1         0         0         0  0.00000e+00
#> omega.3.2         0         0         0  0.00000e+00
#> eta3              0         0         0 -1.29770e-04
#> omega.4.1         0         0         0  0.00000e+00
#> omega.4.2         0         0         0  0.00000e+00
#> omega.4.3         0         0         0  0.00000e+00
#> eta4              0         0         0  5.10190e-04
```
