#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>   /* dj: import intptr_t */
//#include "ode.h"
#include <rxode2parseSbuf.h>
#include <errno.h>
#include <dparserPtr.h>
#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <Rmath.h>
/* replace pkg as appropriate */
#else
#define _(String) (String)
#endif

void nonmem2rx_abbrec_parseFree(int last);
void nonmem2rx_abbrev_parseFree(int last);
void nonmem2rx_data_parseFree(int last);
void nonmem2rx_input_parseFree(int last);
void nonmem2rx_lst_parseFree(int last);
void nonmem2rx_model_parseFree(int last);
void nonmem2rx_omega_parseFree(int last);
void nonmem2rx_sub_parseFree(int last);
void nonmem2rx_tab_parseFree(int last);
void nonmem2rx_theta_parseFree(int last);

extern sbuf firstErr;
extern sbuf sbErr1;
extern sbuf sbErr2;
extern sbuf sbTransErr;
extern sbuf curLine;
extern sbuf modelName;
extern sbuf curOmegaLhs;
extern sbuf curOmegaRhs;
extern sbuf curOmega;
extern sbuf curThetaRhs;
extern sbuf curTheta;
extern vLines _dupStrs;

void nonmem2rx_full_parseFree(int last) {
  lineFree(&_dupStrs);
  if (last) {
    sFree(&firstErr);
    sFree(&sbTransErr);
    sFree(&sbErr1);
    sFree(&sbErr2);
    sFree(&curLine);
    sFree(&modelName);
    sFree(&curOmegaLhs);
    sFree(&curOmegaRhs);
    sFree(&curOmega);
    sFree(&curThetaRhs);
    sFree(&curTheta);
  } else {
    sClear(&firstErr);
    sClear(&sbTransErr);
    sClear(&sbErr1);
    sClear(&sbErr2);
    sClear(&curLine);
    sClear(&modelName);
    sClear(&curOmegaLhs);
    sClear(&curOmegaRhs);
    sClear(&curOmega);
    sClear(&curThetaRhs);
    sClear(&curTheta);
    lineIni(&_dupStrs);
  }
  nonmem2rx_abbrec_parseFree(last);
  nonmem2rx_abbrev_parseFree(last);
  nonmem2rx_data_parseFree(last);
  nonmem2rx_input_parseFree(last);
  nonmem2rx_lst_parseFree(last);
  nonmem2rx_model_parseFree(last);
  nonmem2rx_omega_parseFree(last);
  nonmem2rx_sub_parseFree(last);
  nonmem2rx_tab_parseFree(last);
  nonmem2rx_theta_parseFree(last);
}


int nonmem2rx_full_ini_done = 0;
void nonmem2rx_full_ini(void) {
  if (nonmem2rx_full_ini_done == 0) {
    sIni(&firstErr);
    sIni(&sbTransErr);
    sIni(&sbErr1);
    sIni(&sbErr2);
    sIni(&curLine);
    sIni(&modelName);
    sIni(&curOmegaLhs);
    sIni(&curOmegaRhs);
    sIni(&curOmega);
    sIni(&curThetaRhs);
    sIni(&curTheta);
    lineIni(&_dupStrs);
    nonmem2rx_full_ini_done = 1;
  }
}

SEXP _nonmem2rx_r_parseFree(void) {
  nonmem2rx_full_parseFree(0);
  return R_NilValue;
}

SEXP _nonmem2rx_r_parseIni(void) {
  nonmem2rx_full_ini();
  return R_NilValue;
}
