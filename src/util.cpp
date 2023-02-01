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

extern "C" SEXP nonmem2rxPushRecord(const char *rec, const char *info) {
  BEGIN_RCPP
    Environment nonmem2rxNs = loadNamespace("nonmem2rx");
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
    Environment nonmem2rxNs = loadNamespace("nonmem2rx");
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
    Environment nonmem2rxNs = loadNamespace("nonmem2rx");
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

extern "C" SEXP nonmem2rxPushOmega(const char *ini) {
  BEGIN_RCPP
    Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  CharacterVector iniC(1);
  iniC[0] = Rf_mkChar(ini);
  Function addIni(".addIni", nonmem2rxNs);
  addIni(iniC);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushOmegaComment(const char *comment, const char *prefix) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  CharacterVector commentC(1);
  if (comment == NULL) {
    commentC[0] = "";
  } else {
    commentC[0] = Rf_mkChar(comment);
  }
  CharacterVector prefixC(1);
  if (prefix == NULL) {
    prefixC[0] = "";
  } else {
    prefixC[0] = Rf_mkChar(prefix);
  }
  Function addOmegaComment(".addOmegaComment", nonmem2rxNs);
  addOmegaComment(commentC, prefixC);
  END_RCPP  
}

extern "C" SEXP nonmem2rxPushModel(const char *cmtName) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  CharacterVector cmtC(1);
  cmtC[0] = Rf_mkChar(cmtName);
  Function addModelName(".addModelName", nonmem2rxNs);
  addModelName(cmtName);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushInput(const char *item1, const char *item2) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  CharacterVector item1C(1);
  if (item1 == NULL) {
    item1C[0] = "DROP";
  } else {
    item1C[0] = Rf_mkChar(item1);
  }
  CharacterVector item2C(1);
  if (item2 == NULL) {
    item2C[0] = "DROP";
  } else {
    item2C[0] = Rf_mkChar(item2);
  }
  Function addInputItem(".addInputItem", nonmem2rxNs);
  addInputItem(item1C, item2C);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushModelLine(const char *item1) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  CharacterVector item1C(1);
  if (item1 == NULL) {
    item1C[0] = "";
  } else {
    item1C[0] = Rf_mkChar(item1);
  }
  Function addModel(".addModel", nonmem2rxNs);
  addModel(item1C);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushScale(int scale) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  IntegerVector scaleI(1);
  scaleI[0] = scale;
  Function addScale(".addScale", nonmem2rxNs);
  addScale(scaleI);
  END_RCPP
}

extern "C" SEXP nonmem2rxGetScale(int scale) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  IntegerVector scaleI(1);
  scaleI[0] = scale;
  Function getScale(".getScale", nonmem2rxNs);
  return getScale(scaleI);
  END_RCPP
}

extern "C" SEXP nonmem2rxSetAdvan(int advan) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  IntegerVector advanI(1);
  advanI[0] = advan;
  Function setAdvan(".setAdvan", nonmem2rxNs);
  return setAdvan(advanI);
  END_RCPP
}

extern "C" SEXP nonmem2rxSetTrans(int trans) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  IntegerVector transI(1);
  transI[0] = trans;
  Function setTrans(".setTrans", nonmem2rxNs);
  return setTrans(transI);
  END_RCPP
}

extern "C" SEXP nonmem2rxSetMaxA(int maxa) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  IntegerVector maxI(1);
  maxI[0] = maxa;
  Function setMax(".setMaxA", nonmem2rxNs);
  return setMax(maxI);
  END_RCPP
}
