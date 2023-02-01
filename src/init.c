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
SEXP _nonmem2rx_thetanum_reset(void);
SEXP _nonmem2rx_trans_omega(SEXP in, SEXP prefix);
SEXP _nonmem2rx_omeganum_reset(void);
SEXP _nonmem2rx_trans_model(SEXP in);
SEXP _nonmem2rx_trans_input(SEXP in);
SEXP _nonmem2rx_trans_abbrev(SEXP in, SEXP prefix, SEXP linCmt);
SEXP _nonmem2rx_parse_strncmpci(void);
SEXP _nonmem2rx_trans_sub(SEXP in);
SEXP _nonmem2rx_trans_lst(SEXP in);
void R_init_nonmem2rx(DllInfo *info){
  R_CallMethodDef callMethods[]  = {
    {"_nonmem2rx_trans_input", (DL_FUNC) &_nonmem2rx_trans_input, 1},
    {"_nonmem2rx_trans_records", (DL_FUNC) &_nonmem2rx_trans_records, 1},
    {"_nonmem2rx_trans_omega", (DL_FUNC) &_nonmem2rx_trans_omega, 2},
    {"_nonmem2rx_omeganum_reset", (DL_FUNC) &_nonmem2rx_omeganum_reset, 0},
    {"_nonmem2rx_trans_theta", (DL_FUNC) &_nonmem2rx_trans_theta, 1},
    {"_nonmem2rx_thetanum_reset", (DL_FUNC) &_nonmem2rx_thetanum_reset, 0},
    {"_nonmem2rx_trans_model", (DL_FUNC) &_nonmem2rx_trans_model, 1},
    {"_nonmem2rx_trans_abbrev", (DL_FUNC) &_nonmem2rx_trans_abbrev, 3},
    {"_nonmem2rx_parse_strncmpci", (DL_FUNC) &_nonmem2rx_parse_strncmpci, 0},
    {"_nonmem2rx_trans_sub", (DL_FUNC) &_nonmem2rx_trans_sub, 1},
    {"_nonmem2rx_trans_lst", (DL_FUNC) &_nonmem2rx_trans_lst, 1},
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

