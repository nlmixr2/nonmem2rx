#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>   /* dj: import intptr_t */
//#include "ode.h"
#include <rxode2parseSbuf.h>
#include <errno.h>

#define iniDparserPtr _nonmem2rx_iniDparserPtr
#include <dparserPtr.h>
dparserPtrIni

#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <Rmath.h>
#define _(String) (String)

sbuf curLine;

const char *lastStr;
int lastStrLoc=0;
vLines _dupStrs;
char * rc_dup_str(const char *s, const char *e) {
  lastStr=s;
  int l;
  if (e) {
    ptrdiff_t diff = e - s;
    if (diff < 0 || diff > (ptrdiff_t)INT_MAX) {
      Rf_error(_("string segment too long in rc_dup_str"));
    }
    l = (int)diff;
  } else {
    size_t sLen = strlen(s);
    if (sLen > (size_t)INT_MAX) {
      Rf_error(_("string too long in rc_dup_str"));
    }
    l = (int)sLen;
  }
  //syntaxErrorExtra=min(l-1, 40);
  addLine(&_dupStrs, "%.*s", l, s);
  return _dupStrs.line[_dupStrs.n-1];
}
