## Residual error model forms.  Same one-compartment oral structure,
## different $ERROR / $SIGMA coding.

## Build an rxode2 simulation model from .simOral1 with a different
## residual error: `ini` and `err` are lists of expressions.
.simOral1Err <- function(ini, err, pre=list()) {
  eval(bquote(function() {
    ini({
      tcl <- 3; tv <- 30; tka <- 1.2
      eta.cl ~ 0.09; eta.v ~ 0.04
      ..(ini)
    })
    model({
      cl <- tcl * exp(eta.cl); v <- tv * exp(eta.v); ka <- tka
      d/dt(depot) <- -ka * depot
      d/dt(central) <- ka * depot - cl / v * central
      ipred <- central / v
      ..(pre)
      ..(err)
    })
  }, splice=TRUE))
}

.errCtl <- function(err, theta="", sigma="1 FIX") {
  paste0("$PROBLEM {{PROBLEM}}
$INPUT {{INPUT}}
$DATA {{DATA}} IGNORE=@
$SUBROUTINES ADVAN2 TRANS2
$PK
  CL = THETA(1)*EXP(ETA(1))
  V  = THETA(2)*EXP(ETA(2))
  KA = THETA(3)
  S2 = V
$ERROR
", err, "
$THETA (0, 3) (0, 30) (0, 1.2) ", theta, "
$OMEGA 0.09 0.04
$SIGMA ", sigma, "
{{EST}}
{{TABLE}}
")
}

kitCase(
  name="err-add-eps",
  covers="Additive error on EPS with an estimated $SIGMA (Y = IPRED + EPS(1))",
  tags=c("error", "error-eps", "add"),
  sim=.simOral1Err(list(quote(add.sd <- 0.05)), list(quote(ipred ~ add(add.sd)))),
  data=.dataOral1,
  sigma=matrix(0.0025, dimnames=list("eps1", "eps1")),
  ctl=.errCtl("  IPRED = F
  IWRES = (DV - IPRED)/SQRT(SIGMA(1,1))
  Y = IPRED + EPS(1)", sigma="0.0025"))

kitCase(
  name="err-exp-eps",
  covers="Exponential error Y = IPRED*EXP(EPS(1)) (log-normal on the original scale)",
  tags=c("error", "error-eps", "exponential"),
  sim=.simOral1Err(list(quote(ln.sd <- 0.1)), list(quote(ipred ~ lnorm(ln.sd)))),
  data=.dataOral1,
  sigma=matrix(0.01, dimnames=list("eps1", "eps1")),
  ctl=.errCtl("  IPRED = F
  IWRES = (LOG(DV) - LOG(IPRED))/0.1
  Y = IPRED*EXP(EPS(1))", sigma="0.01"))

kitCase(
  name="err-log-dv",
  covers="Log-transformed DV with additive error on the log scale and a guarded LOG(F)",
  tags=c("error", "log-dv", "error-theta"),
  sim=.simOral1Err(list(quote(add.sd <- 0.1)),
                   list(quote(lcp ~ add(add.sd))),
                   pre=list(quote(lcp <- log(ipred)))),
  data=.dataOral1,  # DV is log(conc): the endpoint lcp is log-scale
  ctl=.errCtl("  IPRED = -5
  IF (F .GT. 0) IPRED = LOG(F)
  IWRES = (DV - IPRED)/THETA(4)
  Y = IPRED + THETA(4)*EPS(1)", theta="(0, 0.1)"))

kitCase(
  name="err-two-eps-theta",
  covers="Combined error with two THETA-scaled EPS and $SIGMA 1 FIX 1 FIX",
  tags=c("error", "error-theta", "combined"),
  sim=.simOral1Err(list(quote(prop.sd <- 0.1), quote(add.sd <- 0.05)),
                   list(quote(ipred ~ prop(prop.sd) + add(add.sd)))),
  data=.dataOral1,
  ctl=.errCtl("  IPRED = F
  W = SQRT((THETA(4)*IPRED)**2 + THETA(5)**2)
  IWRES = (DV - IPRED)/W
  Y = IPRED + IPRED*THETA(4)*EPS(1) + THETA(5)*EPS(2)",
  theta="(0, 0.1) (0, 0.05)", sigma="1 FIX 1 FIX"))

kitCase(
  name="err-combined1",
  covers="Combined error on the SD scale, W = THETA(a) + THETA(b)*IPRED (rxode2 combined1)",
  tags=c("error", "error-theta", "combined1"),
  sim=.simOral1Err(list(quote(add.sd <- 0.05), quote(prop.sd <- 0.1)),
                   list(quote(ipred ~ add(add.sd) + prop(prop.sd) + combined1()))),
  data=.dataOral1,
  ctl=.errCtl("  IPRED = F
  W = THETA(4) + THETA(5)*IPRED
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)", theta="(0, 0.05) (0, 0.1)"))

kitCase(
  name="err-power",
  covers="Power error model W = THETA*IPRED**THETA",
  tags=c("error", "error-theta", "power"),
  sim=.simOral1Err(list(quote(pow.sd <- 0.15), quote(pw <- 0.7)),
                   list(quote(ipred ~ pow(pow.sd, pw)))),
  data=.dataOral1,
  ctl=.errCtl("  IPRED = F
  W = THETA(4)*IPRED**THETA(5)
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  Y = IPRED + W*EPS(1)", theta="(0, 0.15) (0, 0.7)"))

kitCase(
  name="err-m3-blq",
  covers="M3 censoring: BLQ records use F_FLAG=1 with Y = PHI((LLOQ-IPRED)/W) (LAPLACE)",
  tags=c("error", "m3", "censoring", "laplace"),
  knownFull="M3 is not recognised as censoring (no predDf), so validation compares Y -- the PHI() likelihood on BLQ rows -- with NONMEM's IPRED (concentration)",
  sim=.simOral1Err(list(quote(prop.sd <- 0.2)), list(quote(ipred ~ prop(prop.sd)))),
  data=function(nSub) {
    .d <- .dataOral1(nSub)
    .d$LLOQ <- 0.5
    .d$BLQ <- 0
    .d
  },
  postSim=function(d, s) {
    .m <- match(d$ROWID, s$ROWID)
    .obs <- d$EVID == 0 & d$MDV == 0 & !is.na(.m)
    d$DV[.obs] <- signif(s$sim[.m[.obs]], 6)
    .blq <- .obs & d$DV < d$LLOQ
    d$BLQ[.blq] <- 1
    d$DV[.blq] <- d$LLOQ[.blq]
    d
  },
  dryRows=function(d) d$BLQ == 0,
  ctl=.errCtl("  IPRED = F
  W = THETA(4)*IPRED
  IF (W .EQ. 0) W = 1
  IWRES = (DV - IPRED)/W
  IF (BLQ .EQ. 1) THEN
    F_FLAG = 1
    Y = PHI((LLOQ - IPRED)/W)
  ELSE
    F_FLAG = 0
    Y = IPRED + W*EPS(1)
  ENDIF", theta="(0, 0.2)"),
  ## the M3 likelihood needs LAPLACE; used for both --est modes
  est="$EST METHOD=COND LAPLACE INTER MAXEVAL=9999 PRINT=5 NOABORT\n$COV PRINT=E UNCONDITIONAL")
