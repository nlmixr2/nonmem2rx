#define USE_FC_LEN_T
#define STRICT_R_HEADERS
#include <Rcpp.h>
#include <R.h>
#include <unordered_map>
#define _(String) (String)

using namespace Rcpp;

//[[Rcpp::export]]
IntegerVector fromNonmemToRxId_(IntegerVector nonmemId, NumericVector time) {
  std::vector<std::string> lvl;
  IntegerVector ret(nonmemId.size());
  std::string cur0, cur;
  // How many times each base id has been seen so far, so the alias suffix
  // ("<id>#2", "<id>#3", ...) always advances to the next unused number.
  // This used to be found by rescanning `lvl` (all labels seen so far) with
  // std::find for the first free suffix starting at "#2" every time; besides
  // once being buggy enough to never advance (see git history), that rescan
  // is O(k) std::find calls over a growing vector for the k-th reuse of one
  // id, i.e. quadratic for an id reused many times. Different ids never
  // collide (their base strings differ), so a plain reuse count per base id
  // is sufficient and O(1) amortized.
  std::unordered_map<std::string, unsigned int> nSeen;
  int fctInt = 1;
  for (unsigned int i = 0; i < nonmemId.size(); ++i) {
    int nmid = nonmemId[i];
    double nmt = time[i];
    if (ISNA(nmt)) nmt = 0.0;
    if (nmid == NA_INTEGER) nmid = 0; // NONMEM convention na=0
    cur0 = "NM:'" + std::to_string(nmid) + "'";
    unsigned int k = ++nSeen[cur0];
    cur = (k == 1) ? cur0 : cur0 + "#" + std::to_string(k);
    lvl.push_back(cur);
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
