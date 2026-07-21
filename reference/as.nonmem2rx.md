# Convert a model to a nonmem2rx model

Convert a model to a nonmem2rx model

## Usage

``` r
as.nonmem2rx(
  model1,
  model2,
  compress = TRUE,
  chat = NULL,
  maxAttempts = 3,
  useLLM = getOption("nonmem2rx.useLLM", TRUE)
)
```

## Arguments

- model1:

  Input model 1

- model2:

  Input model 2

- compress:

  boolean to compress the ui at the end

- chat:

  optional `ellmer` chat object used when the model lacks a residual
  error specification (`$predDf`) and `useLLM=TRUE`. When `NULL` a
  default engine is selected: `getOption("nonmem2rx.llmProvider")` is
  honored first (it may be an `ellmer` chat function, a provider name
  such as `"openai"`, or a full function name such as `"chat_openai"`,
  exposing every engine exported by `ellmer`), otherwise the first
  provider with a detected API key is used (e.g. `ANTHROPIC_API_KEY`,
  `OPENAI_API_KEY`, `GEMINI_API_KEY`).

- maxAttempts:

  maximum number of LLM validation attempts when inferring the residual
  error structure

- useLLM:

  logical; when `TRUE` (default, controllable with
  `getOption("nonmem2rx.useLLM")`) an LLM is used to infer the residual
  error structure for models that lack one

## Value

nonmem2rx model

## Author

Matthew L. Fidler

## Examples

``` r

# \donttest{

 mod <- nonmem2rx(system.file("mods/cpt/runODE032.ctl", package="nonmem2rx"),
                  determineError=FALSE, lst=".res", save=FALSE)
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
#>  
#>  
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
#>  
#>  
#> ℹ solving ipred problem
#> ℹ done
#> ℹ solving pred problem
#> ℹ done

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

new <- try(as.nonmem2rx(mod2, mod))
#>  
#>  
#> ℹ parameter labels from comments are typically ignored in non-interactive mode
#> ℹ Need to run with the source intact to parse comments
#> ℹ copy 'dfSub' to nonmem2rx model
#> ℹ copy 'thetaMat' to nonmem2rx model
#> ℹ copy 'dfObs' to nonmem2rx model
#>  
#>  
#> ℹ solving ipred problem
#> ℹ done
#> ℹ solving pred problem
#> ℹ done
if (!inherits(new, "try-error")) print(new, page=1)
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

# }
```
