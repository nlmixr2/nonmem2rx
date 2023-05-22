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
IntegerVector fromNonmemToRxId(IntegerVector nonmemId) {
  std::vector<std::string> lvl;
  IntegerVector ret(nonmemId.size());
  std::string cur0, cur;
  unsigned int j;
  int fctInt = 1;
  for (unsigned int i = 0; i < nonmemId.size(); ++i) {
    cur = cur0 = "NM: " + std::to_string(nonmemId[i]);
    j = 1;
    while (true) {
      if (std::find(lvl.begin(), lvl.end(), cur) == lvl.end()) {
        lvl.push_back(cur);
        break;
      }
      cur = cur0 + " #" + std::to_string(j);
    }
    ret[i] = fctInt;
    while (i < nonmemId.size() - 1 && nonmemId[i] == nonmemId[i+1]) {
      i++;
      ret[i] = fctInt;
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
