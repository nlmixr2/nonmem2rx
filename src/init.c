#define USE_FC_LEN_T
#define STRICT_R_HEADERS
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

SEXP _nonmem2rx_trans_records(SEXP in);
SEXP _nonmem2rx_trans_theta(SEXP in);
SEXP _nonmem2rx_thetanum_reset();
SEXP _nonmem2rx_trans_omega(SEXP in);
SEXP _nonmem2rx_omeganum_reset();
void R_init_nonmem2rx(DllInfo *info){
  R_CallMethodDef callMethods[]  = {
    {"_nonmem2rx_trans_records", (DL_FUNC) &_nonmem2rx_trans_records, 1},
    {"_nonmem2rx_trans_omega", (DL_FUNC) &_nonmem2rx_trans_omega, 1},
    {"_nonmem2rx_omeganum_reset", (DL_FUNC) &_nonmem2rx_omeganum_reset, 0},
    {"_nonmem2rx_trans_theta", (DL_FUNC) &_nonmem2rx_trans_theta, 1},
    {"_nonmem2rx_thetanum_reset", (DL_FUNC) &_nonmem2rx_thetanum_reset, 0},
    {NULL, NULL, 0}
  };
  // log likelihoods used in calculations
  static const R_CMethodDef cMethods[] = {
    {NULL, NULL, 0, NULL}
  };
  R_registerRoutines(info, cMethods, callMethods, NULL, NULL);
  R_useDynamicSymbols(info, FALSE);
}

void R_unload_nonmem2rx(DllInfo *info){
}
