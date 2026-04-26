# Created Augmented pred/ipred plots with \`augPred()\`

This is a simple process to create individual predictions augmented with
more observations than was modeled. This allows smoother plots and a
better examination of the observed concentrations for an individual and
population.

## Step 1: Convert the `NONMEM` model to `rxode2`:

``` r
library(babelmixr2)
library(nonmem2rx)

# First we need the location of the nonmem control stream Since we are running an example, we will use one of the built-in examples in `nonmem2rx`
ctlFile <- system.file("mods/cpt/runODE032.ctl", package="nonmem2rx")
# You can use a control stream or other file. With the development
# version of `babelmixr2`, you can simply point to the listing file

mod <- nonmem2rx(ctlFile, lst=".res", save=FALSE)
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
```

## Step 2: convert the `rxode2` model to `nlmixr2`

In this step, you convert the model to `nlmixr2` by `as.nlmixr2(mod)`;
You may need to do a [little manual work to get the residual
specification to match between nlmixr2 and NONMEM](convert-nlmixr2.md).

Once the residual specification is compatible with a nlmixr2 object, you
can convert the model, `mod`, to a nlmixr2 fit object:

``` r
fit <- as.nlmixr2(mod)
#> → loading into symengine environment...
#> → pruning branches (`if`/`else`) of full model...
#> ✔ done
#> → finding duplicate expressions in EBE model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → optimizing duplicate expressions in EBE model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → compiling EBE model...
#> ✔ done
#> rxode2 5.0.2 using 2 threads (see ?getRxThreads)
#>   no cache: create with `rxCreateCache()`
#> → Calculating residuals/tables
#> ✔ done

fit
```

$$\begin{aligned}
{cmt(CENTRAL)} & \\
{cmt(PERI)} & \\
{cl} & {= \exp\left( {theta1} + {eta1} \right)} \\
v & {= \exp\left( {theta2} + {eta2} \right)} \\
q & {= \exp\left( {theta3} + {eta3} \right)} \\
{v2} & {= \exp\left( {theta4} + {eta4} \right)} \\
{v1} & {= v} \\
{scale1} & {= v} \\
{k21} & {= \frac{q}{v2}} \\
{k12} & {= \frac{q}{v}} \\
\frac{d\ CENTRAL}{dt} & {= {k21} \times {PERI} - {k12} \times {CENTRAL} - \frac{{cl} \times {CENTRAL}}{v1}} \\
\frac{d\ PERI}{dt} & {= - {k21} \times {PERI} + {k12} \times {CENTRAL}} \\
f & {= \frac{CENTRAL}{scale1}} \\
{ipred} & {= f} \\
{rescv} & {= {RSV}} \\
{ipred} & {\sim prop(RSV)}
\end{aligned}$$

## Step 3: Create and plot an augmented prediction

``` r
ap <- augPred(fit)

head(ap)
#>     values        ind id   time Endpoint
#> 1 1239.488 Individual  1 0.0000  CENTRAL
#> 2 1215.358 Individual  1 0.2500  CENTRAL
#> 3 1191.924 Individual  1 0.5000  CENTRAL
#> 4 1169.164 Individual  1 0.7500  CENTRAL
#> 5 1147.057 Individual  1 1.0000  CENTRAL
#> 6 1109.689 Individual  1 1.4398  CENTRAL

plot(ap)
```

![](create-augPred_files/figure-html/augPred-1.png)![](create-augPred_files/figure-html/augPred-2.png)![](create-augPred_files/figure-html/augPred-3.png)![](create-augPred_files/figure-html/augPred-4.png)![](create-augPred_files/figure-html/augPred-5.png)![](create-augPred_files/figure-html/augPred-6.png)![](create-augPred_files/figure-html/augPred-7.png)![](create-augPred_files/figure-html/augPred-8.png)
