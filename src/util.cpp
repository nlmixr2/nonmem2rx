#define USE_FC_LEN_T
#define STRICT_R_HEADERS
#include <Rcpp.h>
#include <R.h>
#define _(String) (String)

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

extern "C" SEXP nonmem2rxPushTheta(const char *ini, const char *comment, const char *label, int nargs) {
  BEGIN_RCPP
    Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  CharacterVector iniC(1);
  if (ini == NULL) {
    iniC[0] = "";
  } else {
    iniC[0] = Rf_mkChar(ini);
  }
  CharacterVector commentS(1);
  if (comment == NULL) {
    commentS[0] = "";
  } else {
    commentS[0] = Rf_mkChar(comment);
  }
  CharacterVector labelS(1);
  if (label == NULL) {
    labelS[0] = "";
  } else {
    labelS[0] = Rf_mkChar(label);
  }
  Function pushTheta(".pushTheta", nonmem2rxNs);
  pushTheta(ini, commentS, labelS, nargs);
  END_RCPP
}
extern "C" SEXP nonmem2rxPushOmega(const char *ini, int sd, int cor, int chol) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  CharacterVector iniC(1);
  iniC[0] = Rf_mkChar(ini);
  Function addOmega(".addOmega", nonmem2rxNs);
  addOmega(iniC, sd, cor, chol);
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

extern "C" SEXP nonmem2rxPushOmegaLabel(const char *comment, const char *prefix) {
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
  Function addOmegaLabel(".addOmegaLabel", nonmem2rxNs);
  addOmegaLabel(commentC, prefixC);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushModel0(const char *cmtName) {
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

extern "C" SEXP nonmem2rxGetExtendedVar(const char *v) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function getExtendedVar(".getExtendedVar", nonmem2rxNs);
  return getExtendedVar(v);
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

extern "C" SEXP nonmem2rxPushLst(const char* type, const char *est) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushLst(".pushLst", nonmem2rxNs);
  return pushLst(type, est);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushDataFile(const char* file) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushDataFile(".pushDataFile", nonmem2rxNs);
  CharacterVector cur(1);
  cur[0] = Rf_mkChar(file);
  pushDataFile(cur);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushDataCond(const char* cond) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushDataCond(".pushDataCond", nonmem2rxNs);
  pushDataCond(cond);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushDataRecords(int nrec) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushDataRecords(".pushDataRecords", nonmem2rxNs);
  pushDataRecords(nrec);
  END_RCPP
}


extern "C" SEXP nonmem2rxNeedNmevid(void) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function needNmevid(".needNmevid", nonmem2rxNs);
  needNmevid();
  END_RCPP
}

extern "C" SEXP nonmem2rxNeedNmid(void) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function needNmid(".needNmid", nonmem2rxNs);
  needNmid();
  END_RCPP
}

extern "C" SEXP nonmem2rxPushTableInfo(const char *file, int hasPred, int fullData,
                                       int hasIpred, int hasEta, const char *fortranFormat) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushTableInfo(".pushTableInfo", nonmem2rxNs);
  pushTableInfo(file, LogicalVector::create(hasPred),
                LogicalVector::create(fullData),
                LogicalVector::create(hasIpred),
                LogicalVector::create(hasEta),
                fortranFormat);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushScaleVolume(int scale, const char *v) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushScaleVolume(".pushScaleVolume", nonmem2rxNs);
  pushScaleVolume(scale, v);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushCmtInfo(int defdose, int defobs) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushCmtInfo(".pushCmtInfo", nonmem2rxNs);
  pushCmtInfo(defdose, defobs);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushSigmaEst(int x, int y) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushSigmaEst(".pushSigmaEst", nonmem2rxNs);
  pushSigmaEst(x, y);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushOmegaEst(int x, int y) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushOmegaEst(".pushOmegaEst", nonmem2rxNs);
  pushOmegaEst(x, y);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushObservedDadt(int a) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushObservedDadt(".pushObservedDadt", nonmem2rxNs);
  pushObservedDadt(a);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushObservedThetaObs(int a) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushObservedThetaObs(".pushObservedThetaObs", nonmem2rxNs);
  pushObservedThetaObs(a);
  END_RCPP
}

extern "C" SEXP nonmem2rxPushObservedEtaObs(int a) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushObservedEtaObs(".pushObservedEtaObs", nonmem2rxNs);
  pushObservedEtaObs(a);
  END_RCPP
}


extern "C" SEXP nonmem2rxPushObservedMaxEta(int a) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushObservedMaxEta(".pushObservedMaxEta", nonmem2rxNs);
  pushObservedMaxEta(a);
  END_RCPP
}


extern "C" SEXP nonmem2rxPushObservedMaxTheta(int a) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushObservedMaxTheta(".pushObservedMaxTheta", nonmem2rxNs);
  pushObservedMaxTheta(a);
  END_RCPP
}

extern "C" SEXP nonmem2xPushOmegaBlockNvalue(int n, const char *v1, const char *v2,
                                             const char *prefix, int num, int fixed) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function pushOmegaBlockNvalue(".pushOmegaBlockNvalue", nonmem2rxNs);
  pushOmegaBlockNvalue(n, v1, v2, prefix, num, fixed);
  END_RCPP
}

extern "C" SEXP nonmem2rxGetModelNum(const char *v) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function getModelNum(".getModelNum", nonmem2rxNs);
  return getModelNum(v);
  END_RCPP
}

extern "C" SEXP nonmem2rxGetThetaNum(const char *v) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function getThetaNum(".getThetaNum", nonmem2rxNs);
  return getThetaNum(v);
  END_RCPP
}


extern "C" SEXP nonmem2rxGetEtaNum(const char *v) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function getEtaNum(".getEtaNum", nonmem2rxNs);
  return getEtaNum(v);
  END_RCPP
}

extern "C" SEXP nonmem2rxGetEpsNum(const char *v) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function getEpsNum(".getEpsNum", nonmem2rxNs);
  return getEpsNum(v);
  END_RCPP
}


extern "C" SEXP nonmem2rxAddReplaceDirect1(const char *type, const char *var, int num) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function addReplaceDirect1(".addReplaceDirect1", nonmem2rxNs);
  return addReplaceDirect1(type, var, num);
  END_RCPP
}

extern "C" SEXP nonmem2rxAddReplaceDirect2(const char *what, const char *with) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function addReplaceDirect2(".addReplaceDirect2", nonmem2rxNs);
  return addReplaceDirect2(what, with);
  END_RCPP
}

extern "C" SEXP nonmem2rxReplaceProcessSeq(const char *what) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function processSeq(".processSeq", nonmem2rxNs);
  return processSeq(what);
  END_RCPP
}

extern "C" SEXP nonmem2rxReplaceIsDataItem(const char *what) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function replaceIsDataItem(".replaceIsDataItem", nonmem2rxNs);
  return replaceIsDataItem(what);
  END_RCPP
}

extern "C" SEXP nonmem2rxReplaceDataItem(const char *type) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function replaceDataItem(".replaceDataItem", nonmem2rxNs);
  return replaceDataItem(type);
  END_RCPP
}
extern "C" SEXP nonmem2rxReplaceProcessLabel(const char *label) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function replaceProcessLabel(".replaceProcessLabel", nonmem2rxNs);
  return replaceProcessLabel(label);
  END_RCPP
}

extern "C" SEXP nonmem2rxReplaceMultiple(const char *type) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function replaceMultiple(".replaceMultiple", nonmem2rxNs);
  return replaceMultiple(type);
  END_RCPP
}

extern "C" SEXP nonmem2rxHasVolume(const char *v) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function hasVolume(".hasVolume", nonmem2rxNs);
  return hasVolume(v);
  END_RCPP
}

extern "C" SEXP nonmem2rxNeedYtype(void) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function needYtype(".needYtype", nonmem2rxNs);
  return needYtype();
  END_RCPP
}

extern "C" SEXP nonmem2rxNeedDvid(void) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function needDvid(".needDvid", nonmem2rxNs);
  return needDvid();
  END_RCPP
}

extern "C" SEXP nonmem2rxNeedExit(void) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function needExit(".needExit", nonmem2rxNs);
  return needExit();
  END_RCPP
}

extern "C" SEXP nonmem2rxSetAtol(int tol) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function setAtol(".setAtol", nonmem2rxNs);
  return setAtol(tol);
  END_RCPP
}
extern "C" SEXP nonmem2rxSetRtol(int tol) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function setRtol(".setRtol", nonmem2rxNs);
  return setRtol(tol);
  END_RCPP
}
extern "C" SEXP nonmem2rxSetSsAtol(int tol) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function setSsAtol(".setSsAtol", nonmem2rxNs);
  return setSsAtol(tol);
  END_RCPP
}
extern "C" SEXP nonmem2rxSetSsRtol(int tol) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function setSsRtol(".setSsRtol", nonmem2rxNs);
  return setSsRtol(tol);
  END_RCPP
}
extern "C" SEXP nonmem2rxAddLhsVar(const char* v) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function addLhsVar(".addLhsVar", nonmem2rxNs);
  return addLhsVar(v);
  END_RCPP
}
extern "C" SEXP nonmem2rxMixP(int p) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function addMixP(".addMixP", nonmem2rxNs);
  return addMixP(p);
  END_RCPP
}
extern "C" SEXP nonmem2rxNspop(int nspop) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function setNspop(".setNspop", nonmem2rxNs);
  return setNspop(nspop);
  END_RCPP
}


extern "C" SEXP nonmem2rxAdvan5handleK(const char* v) {
  BEGIN_RCPP
  Environment nonmem2rxNs = loadNamespace("nonmem2rx");
  Function advan5handleK(".advan5handleK", nonmem2rxNs);
  return advan5handleK(v);
  END_RCPP
}
