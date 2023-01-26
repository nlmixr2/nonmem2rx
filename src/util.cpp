#define USE_FC_LEN_T
#define STRICT_R_HEADERS
#include <Rcpp.h>
#include <R.h>
#ifdef ENABLE_NLS
#include <libintl.h>
#define _(String) dgettext ("nonmem2rx", String)
/* replace pkg as appropriate */
#else
#define _(String) (String)
#endif

using namespace Rcpp;
Function loadNamespace("loadNamespace", R_BaseNamespace);

Environment nonmem2rxNs = loadNamespace("nonmem2rx");

extern "C" SEXP nonmem2rxPushRecord(const char *rec, const char *info) {
  BEGIN_RCPP
  CharacterVector recS(1);
  if (rec == NULL) {
    recS[0] = Rf_mkChar("aaa");     
  } else {
    recS[0] = Rf_mkChar(rec);
  }
  CharacterVector infoS(1);
  infoS[0] = Rf_mkChar(info);
  Function addRec(".addRec", nonmem2rxNs);
  addRec(recS, infoS);
  END_RCPP
}

extern "C" SEXP nonmem2rxThetaGetMiddle(const char *low, const char *hi) {
  BEGIN_RCPP
  CharacterVector lowC(1);
  lowC[0] = Rf_mkChar(low);
  CharacterVector hiC(1);
  hiC[0] = Rf_mkChar(hi);
  Function midpoint(".thetaMidpoint", nonmem2rxNs);
  return midpoint(lowC, hiC);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushTheta(const char *ini, const char *comment) {
  BEGIN_RCPP
  CharacterVector iniC(1);
  iniC[0] = Rf_mkChar(ini);
  CharacterVector commentS(1);
  if (comment == NULL) {
    commentS[0] = "";
  } else {
    commentS[0] = Rf_mkChar(comment);
  }
  Function pushTheta(".pushTheta", nonmem2rxNs);
  pushTheta(ini, commentS);
  END_RCPP
}
