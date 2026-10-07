## Estimation methods and output-file forms.  The model is the plain
## one-compartment oral case from 04-data.R; these matter most in full
## mode, where nonmem2rx reads the .ext/.phi/.cov/.xml/tables NONMEM
## wrote for each method.

.estCase <- function(name, covers, tags, est=NULL, table=NULL, ...) {
  .ctl <- .oral1Ctl()
  if (!is.null(table)) .ctl <- sub("{{TABLE}}", table, .ctl, fixed=TRUE)
  kitCase(name=name, covers=covers, tags=c("estimation", tags),
          sim=.simOral1, data=.dataOral1, ctl=.ctl,
          est=if (is.null(est)) "default" else est, ...)
}

.estCase("est-saem-imp",
         "Two estimation steps: SAEM then IMP EONLY=1 (.ext holds two tables; final is IMP)",
         c("saem", "imp", "multiple-est"),
         est="$EST METHOD=SAEM INTER NBURN=300 NITER=200 PRINT=50 NOABORT
$EST METHOD=IMP INTER EONLY=1 ISAMPLE=1000 NITER=5 PRINT=1
$COV UNCONDITIONAL")

.estCase("est-its-foce",
         "ITS followed by FOCE-I (METHOD=COND INTER) with MATRIX=R covariance",
         c("its", "foce", "multiple-est", "cov"),
         est="$EST METHOD=ITS INTER NITER=50 PRINT=10 NOABORT
$EST METHOD=COND INTER MAXEVAL=9999 PRINT=5 NOABORT
$COV MATRIX=R UNCONDITIONAL")

.estCase("est-foce-no-inter",
         "FOCE without INTERACTION (METHOD=1) and no $COV step",
         c("foce", "no-cov"),
         est="$EST METHOD=1 MAXEVAL=9999 PRINT=5 NOABORT")

.estCase("est-fo-posthoc",
         "First-order (METHOD=0) estimation with POSTHOC etas",
         "fo",
         est="$EST METHOD=0 MAXEVAL=9999 POSTHOC PRINT=5 NOABORT
$COV UNCONDITIONAL")

.estCase("est-maxeval0",
         "MAXEVAL=0 POSTHOC evaluation only (final estimates = initial estimates)",
         "maxeval0",
         est="$EST METHOD=1 INTER MAXEVAL=0 POSTHOC")

.estCase("table-noheader-format",
         "NOHEADER/NOAPPEND tables with FORMAT=s1PE17.9, PRED listed explicitly, separate FIRSTONLY ETA1 ETA2 table",
         c("table", "noheader", "format"),
         knownFull="NOHEADER tables are read without column names, so IPRED/PRED validation does not happen",
         table="$TABLE ID TIME EVID ROWID IPRED IWRES PRED NOAPPEND NOHEADER NOPRINT FORMAT=s1PE17.9 FILE=sdtab1
$TABLE ID ETA1 ETA2 FIRSTONLY NOAPPEND NOPRINT FILE=patab1")

kitCase(
  name="table-ipre-alias",
  covers="Legacy 4-character IPRE in code and tables, an extra full table without IPRED listed first, ETAs in a full table",
  tags=c("estimation", "table", "alias"),
  sim=.simOral1, data=.dataOral1,
  ctl=sub("{{TABLE}}", "$TABLE ID TIME CMT NOPRINT ONEHEADER FILE=cotab1
$TABLE ID TIME EVID ROWID IPRE IWRES ETAS(1:LAST) ONEHEADER NOPRINT FILE=sdtab2",
          gsub("IPRED", "IPRE", .oral1Ctl(), fixed=TRUE), fixed=TRUE))

.estCase("table-repeated-headers",
         "Tables longer than 900 records without ONEHEADER (NONMEM repeats the TABLE NO. header block)",
         c("table", "headers"),
         nSub=90L,
         table="$TABLE ID TIME EVID ROWID IPRED IWRES NOPRINT FILE=sdtab3
$TABLE ID ETAS(1:LAST) FIRSTONLY NOAPPEND NOPRINT FILE=patab3")
