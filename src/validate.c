#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>   /* dj: import intptr_t */
//#include "ode.h"
#include <rxode2parseSbuf.h>
#include <errno.h>
#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <Rmath.h>
#ifdef ENABLE_NLS
#include <libintl.h>
#define _(String) dgettext ("nonmem2rx", String)
/* replace pkg as appropriate */
#else
#define _(String) (String)
#endif

SEXP _nonmem2rx_fixNonmemTies(SEXP idS, SEXP timeS, SEXP deltaS) {
  int *id = INTEGER(idS);
  double *time = REAL(timeS);
  double delta = REAL(deltaS)[0];
  SEXP retS = PROTECT(Rf_allocVector(REALSXP, Rf_length(idS)));
  double *ret = REAL(retS);
  double tlast = time[0]-7;
  int idlast = id[0]-7;
  int count = 0;
  int warn = 0;
  for (int i = 0; i < Rf_length(idS); i++) {
    if (idlast != id[i]) {
      ret[i] = time[i];
      count = 0;
    } else if (tlast == time[i]) {
      // same time
      warn = 1;
      count++;
      ret[i] = (double)(count) * delta + time[i];
    } else {
      count=0;
      ret[i] = time[i];
    }
    idlast = id[i];
    tlast = time[i];
  }
  if (warn) {
    Rf_warning("some NONMEM input has tied times; they are offset by a small offset");
  }
  UNPROTECT(1);
  return retS;
}
