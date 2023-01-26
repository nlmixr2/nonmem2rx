#define USE_FC_LEN_T
#define STRICT_R_HEADERS
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

void R_init_nonmem2rx(DllInfo *info){
  R_CallMethodDef callMethods[]  = {
    //{"_rxode2_parse_strncmpci", (DL_FUNC) &_rxode2_parse_strncmpci, 0}
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
