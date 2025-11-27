# Create PowerPoint and Word documents using nonmem2rx

## Step 1: import the model into `nonmem2rx`

``` r
library(nonmem2rx)
library(babelmixr2)
library(nlmixr2rpt)
library(onbrand)

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
#> rxode2 5.0.0 using 2 threads (see ?getRxThreads)
#>   no cache: create with `rxCreateCache()`
#> → Calculating residuals/tables
#> ✔ done
#> → compress origData in nlmixr2 object, save 203816
#> → compress parHistData in nlmixr2 object, save 2184

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

## Step 3: Create a PowerPoint file

A PowerPoint can be created from your own [custom powerpoint
templates](https://nlmixr2.github.io/nlmixr2rpt/articles/Reporting_nlmixr_Fit_Results.html#customizing-reports-for-your-organization),
but in this example we will use the ones that come from `nlmixr2rpt`
directly:

``` r
obnd_pptx = read_template(
  template = system.file(package="nlmixr2rpt", "templates","nlmixr_obnd_template.pptx"),
  mapping  = system.file(package="nlmixr2rpt", "templates","nlmixr_obnd_template.yaml"))

obnd_pptx = report_fit(
  fit     = fit, 
  obnd    = obnd_pptx)
#> 
#> Attaching package: 'xpose'
#> The following object is masked from 'package:stats':
#> 
#>     filter
#> 
#> Attaching package: 'ggPMX'
#> The following object is masked from 'package:xpose':
#> 
#>     get_data
#> → loading into symengine environment...
#> → pruning branches (`if`/`else`) of full model...
#> ✔ done
#> → calculate jacobian
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
#> → finding duplicate expressions in EBE model...
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> → optimizing duplicate expressions in EBE model...
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
#> → Calculating residuals/tables
#> ✔ done
#> Warning in xpose.nlmixr2::xpose_data_nlmixr(fit): Added CWRES to fit (using
#> nlmixr2est::addCwres)...
#> Warning in is.na(p_res): is.na() applied to non-(list or vector) of type
#> 'object'
#> Warning in is.na(p_res): is.na() applied to non-(list or vector) of type
#> 'object'
#> Warning in is.na(p_res): is.na() applied to non-(list or vector) of type
#> 'object'
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> Warning in melt.data.table(dx.cats, measure.vars = cats): id.vars and
#> measure.vars are internally guessed when both are 'NULL'. All
#> non-numeric/integer/logical type columns are considered id.vars, which in this
#> case are columns [EFFECT]. Consider providing at least one of 'id' or 'measure'
#> vars in future.
#> Warning in melt.data.table(dx.cats, measure.vars = cats): is.na() applied to
#> non-(list or vector) of type 'object'
#> Skipping table: skip_table (NA found, not generated)
#> Skipping figure: res_vs_pred_idv (NA found, not generated)
#> Skipping figure: eta_cont (NA found, not generated)
#> Skipping figure: eta_cat (NA found, not generated)
#> Skipping figure: skip_figure (NA found, not generated)

save_report(obnd_pptx, "mod-PowerPoint.pptx")
#> $isgood
#> [1] TRUE
#> 
#> $msgs
#> NULL
```

Which gives the powerpoint [here](mod-PowerPoint.pptx)

## Step 4: Create a Word file

Just like in PowerPoint, you can customizeown [custom word
templates](https://nlmixr2.github.io/nlmixr2rpt/articles/Reporting_nlmixr_Fit_Results.html#customizing-reports-for-your-organization),
but in this example we will use the ones that come from `nlmixr2rpt`
directly:

``` r
obnd_docx = read_template(
  template = system.file(package="nlmixr2rpt", "templates","nlmixr_obnd_template.docx"),
  mapping  = system.file(package="nlmixr2rpt", "templates","nlmixr_obnd_template.yaml"))

obnd_docx = report_fit(
  fit     = fit, 
  obnd    = obnd_docx)
#> → Calculating residuals/tables
#> ✔ done
#> Warning in xpose.nlmixr2::xpose_data_nlmixr(fit): Added CWRES to fit (using
#> nlmixr2est::addCwres)...
#> Warning in is.na(p_res): is.na() applied to non-(list or vector) of type
#> 'object'
#> Warning in is.na(p_res): is.na() applied to non-(list or vector) of type
#> 'object'
#> Warning in is.na(p_res): is.na() applied to non-(list or vector) of type
#> 'object'
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> Warning in melt.data.table(dx.cats, measure.vars = cats): id.vars and
#> measure.vars are internally guessed when both are 'NULL'. All
#> non-numeric/integer/logical type columns are considered id.vars, which in this
#> case are columns [EFFECT]. Consider providing at least one of 'id' or 'measure'
#> vars in future.
#> Warning in melt.data.table(dx.cats, measure.vars = cats): is.na() applied to
#> non-(list or vector) of type 'object'
#> Skipping figure: res_vs_pred_idv (NA found, not generated)
#> Skipping figure: skip_figure (NA found, not generated)
#> Skipping figure: eta_cont (NA found, not generated)
#> Skipping figure: eta_cat (NA found, not generated)

save_report(obnd_docx, "mod-Word.docx")
#> $isgood
#> [1] TRUE
#> 
#> $msgs
#> NULL
```

Which gives the word document [here](mod-Word.docx)
