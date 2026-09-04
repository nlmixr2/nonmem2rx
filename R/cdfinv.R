## NONMEM's inverse-CDF individual parameters.
##
## A NONMEM model can give an individual parameter a distribution other
## than normal by mapping a unit normal ETA through PHI() and then through
## an inverse CDF (Bauer, NONMEM 7.5.1, gamma_indpar.pdf):
##
##   $ABBR FUNCTION GAMMACDFINV(VQ,10)
##   $ABBR VECTOR VQ2(10)
##   ...
##   ETARNDCL=PHI(ETA(3))+DEL
##   VQ(1)=ETARNDCL
##   VQ(2)=ALPHACL
##   VQ(3)=BETACL
##   VQ(10)=1.0
##   CL=GAMMACDFINV(VQ)
##
## which is the same construction rxode2 expresses as a `dist()` line.
##
## The `$ABBR VECTOR` record parses (see inst/abbrec.g); the `VQ(i)=` slot
## assignments and the `*CDFINV(VQ)` call in the abbreviated code do not,
## because they are an argument-vector protocol rather than ordinary
## expressions.  Rather than let that surface as a syntax error pointing
## at `VQ2(3)=BETAV1`, it is reported here for what it is.

#' The inverse CDF routines NONMEM 7.5.1 ships
#'
#' A user can add more with `$SUBROUTINE OTHER=<copy of DISTRIBCDFE.f90>`,
#' so the detection is on the `CDFINV`/`INV` suffix rather than this list
#' alone; the list is what the message can name concretely.
#'
#' @noRd
#' @author Matthew L. Fidler
.nonmemCdfInvRoutines <- c("GAMMACDFINV", "WEIBULLCDFINV", "WEIBULLCCDFINV",
                           "LOGNORMALINV", "UNIFORMCDFINV", "GOMPMAKECDFINV")

#' Does this control stream map a parameter through an inverse CDF?
#'
#' @param ctl the control stream, as one string
#' @return the routine name(s) found, or `character(0)`
#' @noRd
#' @author Matthew L. Fidler
.nonmemCdfInvUsed <- function(ctl) {
  .up <- toupper(ctl)
  .found <- .nonmemCdfInvRoutines[
    vapply(.nonmemCdfInvRoutines,
           function(.r) regexpr(paste0(.r, "[ \t]*\\("), .up) != -1,
           logical(1), USE.NAMES=FALSE)]
  if (length(.found) > 0L) return(.found)
  ## a user supplied routine, named in an `$ABBR FUNCTION` record
  .m <- regmatches(.up, gregexpr("FUNCTION[ \t]+[A-Z0-9_]*(CDFINV|CCDFINV|NORMALINV)", .up))[[1]]
  if (length(.m) == 0L) return(character(0))
  unique(trimws(sub("^FUNCTION[ \t]+", "", .m)))
}

#' Refuse a control stream whose parameters go through an inverse CDF
#'
#' @param ctl the control stream, as one string
#' @return nothing, called for the error
#' @noRd
#' @author Matthew L. Fidler
.nonmemAssertNoCdfInv <- function(ctl) {
  .r <- .nonmemCdfInvUsed(ctl)
  if (length(.r) == 0L) return(invisible())
  stop("this model maps an individual parameter through an inverse CDF (",
       paste(.r, collapse=", "), "), which gives it a distribution other ",
       "than normal.  nonmem2rx cannot import that yet: the '$ABBR FUNCTION' ",
       "argument vector ('VQ(1)=...') is a statement protocol rather than an ",
       "expression, so it does not translate the way the rest of the ",
       "abbreviated code does.  rxode2 writes the same model as a 'dist()' ",
       "line in 'ini({})' -- see 'lotri::lotriEtaDists()'",
       call.=FALSE)
}
