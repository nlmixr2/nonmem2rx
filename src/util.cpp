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
