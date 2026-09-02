#define USE_FC_LEN_T
#define STRICT_R_HEADERS
#include <Rcpp.h>
#include <unordered_map>
#include <R.h>
#define _(String) (String)

using namespace Rcpp;

//[[Rcpp::export]]
IntegerVector fromNonmemToRxId_(IntegerVector nonmemId, NumericVector time) {
  std::vector<std::string> lvl;
  // Aliases for one base id are handed out in order -- the first block of an
  // id takes the bare name, the next "#2", then "#3" -- so the next free
  // suffix is all that has to be remembered.  Searching lvl for it instead
  // walked every alias already given out AND scanned the whole of lvl for
  // each: 4000 blocks took 9.9s.  A base id is "NM:'<int>'" and never holds a
  // '#', so a suffixed name can never collide with a base name.
  std::unordered_map<std::string, unsigned int> nextAlias;
  IntegerVector ret(nonmemId.size());
  std::string cur0, cur;
  int fctInt = 1;
  for (unsigned int i = 0; i < nonmemId.size(); ++i) {
    int nmid = nonmemId[i];
    double nmt = time[i];
    if (ISNA(nmt)) nmt = 0.0;
    if (nmid == NA_INTEGER) nmid = 0; // NONMEM convention na=0
    cur = cur0 = "NM:'" + std::to_string(nmid) + "'";
    // A NONMEM id is reused whenever time restarts, so the same id can name
    // several distinct subjects; the second and later ones are aliased
    // "<id>#2", "<id>#3", ...
    std::unordered_map<std::string, unsigned int>::iterator na = nextAlias.find(cur0);
    if (na == nextAlias.end()) {
      nextAlias[cur0] = 2;
    } else {
      cur = cur0 + "#" + std::to_string(na->second);
      na->second++;
    }
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
