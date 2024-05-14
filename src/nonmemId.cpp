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

//[[Rcpp::export]]
IntegerVector fromNonmemToRxId_(IntegerVector nonmemId, NumericVector time) {
  std::vector<std::string> lvl;
  IntegerVector ret(nonmemId.size());
  std::string cur0, cur;
  unsigned int j;
  int fctInt = 1;
  for (unsigned int i = 0; i < nonmemId.size(); ++i) {
    int nmid = nonmemId[i];
    double nmt = time[i];
    if (ISNA(nmt)) nmt = 0.0;
    if (nmid == NA_INTEGER) nmid = 0; // NONMEM convention na=0
    cur = cur0 = "NM:'" + std::to_string(nmid) + "'";
    j = 1;
    while (true) {
      if (std::find(lvl.begin(), lvl.end(), cur) == lvl.end()) {
        lvl.push_back(cur);
        break;
      }
      cur = cur0 + "#" + std::to_string(j+1);
    }
    ret[i] = fctInt;
    while (i < nonmemId.size() - 1) {
      int nmid2 = nonmemId[i+1];
      if (nmid2 == NA_INTEGER) nmid2 = 0;
      double nmt2 = time[i+1];
      if (ISNA(nmt2)) nmt2 = 0.0;
      if (nmid == nmid2 && nmt2 >= nmt) {
        // if the id is the same and the time is the same or bigger,
        // than it is the same NONMEM id
        i++;
        ret[i] = fctInt;
        nmid = nmid2;
        nmt = nmt2;
      } else {
        nmid = nmid2;
        nmt = nmt2;
        break;
      }
    }
    fctInt++;
  }
  SEXP lvlF = PROTECT(Rf_allocVector(STRSXP, lvl.size()));
  for (unsigned int i = 0; i < lvl.size(); ++i) {
    SET_STRING_ELT(lvlF, i, Rf_mkChar((lvl[i]).c_str()));
  }
  ret.attr("levels") = lvlF;
  ret.attr("class") = "factor";
  UNPROTECT(1);
  return ret;
}
