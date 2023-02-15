#define USE_FC_LEN_T
#define STRICT_R_HEADERS
#include <rxode2parseSbuf.h>
#define _(String) (String)

void sIniTo(sbuf *sbb, int to) {
  if (sbb->s != NULL) R_Free(sbb->s);
  sbb->s    = R_Calloc(to, char);
  sbb->sN   = to;
  sbb->s[0] = '\0';
  sbb->o    = 0;
}

void sIni(sbuf *sbb) {
  sIniTo(sbb, SBUF_MXBUF);
}

void sFree(sbuf *sbb) {
  if (sbb->s != NULL) R_Free(sbb->s);
  sNull(sbb);
}

void sFreeIni(sbuf *sbb) {
  sFree(sbb);
  sIni(sbb);
}

void sAppendN(sbuf *sbb, const char *what, int n) {
  if (sbb->sN == 0) sIni(sbb);
  if (sbb->sN <= 2 + n + sbb->o){
    int mx = sbb->o + 2 + n + SBUF_MXBUF;
    sbb->s = R_Realloc(sbb->s, mx, char);
    sbb->sN = mx;
  }
  snprintf(sbb->s+sbb->o, sbb->sN - sbb->o, "%s", what);
  sbb->o +=n;
}


void sAppend(sbuf *sbb, const char *format, ...) {
  if (sbb->sN == 0) sIni(sbb);
  if (format == NULL) return;
  int n = 0;
  va_list argptr, copy;
  va_start(argptr, format);
  va_copy(copy, argptr);
#if defined(_WIN32) || defined(WIN32)
  n = vsnprintf(NULL, 0, format, copy) + 1;
#else
  char zero[2];
  n = vsnprintf(zero, 0, format, copy) + 1;
#endif
  va_end(copy);
  if (sbb->sN <= sbb->o + n + 1) {
    int mx = sbb->o + n + 1 + SBUF_MXBUF;
    sbb->s = R_Realloc(sbb->s, mx, char);
    sbb->sN = mx;
  }
  vsnprintf(sbb->s+ sbb->o, sbb->sN - sbb->o, format, argptr);
  va_end(argptr);
  sbb->o += n-1;
}

void lineIni(vLines *sbb) {
  if (sbb->s != NULL) R_Free(sbb->s);
  sbb->s = R_Calloc(SBUF_MXBUF, char);
  sbb->sN = SBUF_MXBUF;
  sbb->s[0]='\0';
  sbb->o = 0;
  if (sbb->lProp != NULL) R_Free(sbb->lProp);
  if (sbb->line != NULL) R_Free(sbb->line);
  if (sbb->lType != NULL) R_Free(sbb->lType);
  if (sbb->os != NULL) R_Free(sbb->os);
  sbb->lProp = R_Calloc(SBUF_MXLINE, int);
  sbb->lType = R_Calloc(SBUF_MXLINE, int);
  sbb->line = R_Calloc(SBUF_MXLINE, char*);
  sbb->os = R_Calloc(SBUF_MXLINE, int);
  sbb->nL=SBUF_MXLINE;
  sbb->lProp[0] = -1;
  sbb->lType[0] = 0;
  sbb->n = 0;
}

void lineFree(vLines *sbb) {
  if (sbb->s != NULL) R_Free(sbb->s);
  if (sbb->lProp != NULL) R_Free(sbb->lProp);
  if (sbb->line != NULL) R_Free(sbb->line);
  if (sbb->lType != NULL) R_Free(sbb->lType);
  if (sbb->os != NULL) R_Free(sbb->os);
  lineNull(sbb);
}

void addLine(vLines *sbb, const char *format, ...) {
  if (sbb->sN == 0) lineIni(sbb);
  if (format == NULL) return;
  int n = 0;
  va_list argptr, copy;
  va_start(argptr, format);
  va_copy(copy, argptr);
  errno = 0;
  // Try first.
#if defined(_WIN32) || defined(WIN32)
  n = vsnprintf(NULL, 0, format, copy);
#else
  char zero[2];
  n = vsnprintf(zero, 0, format, copy);
#endif
  if (n < 0){
    Rf_errorcall(R_NilValue, _("encoding error in 'addLine' format: '%s' n: %d; errno: %d"), format, n, errno);
  }
  va_end(copy);
  if (sbb->sN <= sbb->o + n){
    int mx = sbb->sN + n + 2 + SBUF_MXBUF;
    sbb->s = R_Realloc(sbb->s, mx, char);
    // The sbb->line are not correct any longer because the pointer for sbb->s has been updated;
    // Fix them
    for (int i = sbb->n; i--;){
      sbb->line[i] = &(sbb->s[sbb->os[i]]);
    }
    sbb->sN = mx;
  }
  vsnprintf(sbb->s + sbb->o, sbb->sN - sbb->o, format, argptr);
  va_end(argptr);
  if (sbb->n + 2 >= sbb->nL){
    int mx = sbb->nL + n + 2 + SBUF_MXLINE;
    sbb->lProp = R_Realloc(sbb->lProp, mx, int);
    sbb->lType = R_Realloc(sbb->lType, mx, int);
    sbb->line = R_Realloc(sbb->line, mx, char*);
    sbb->os = R_Realloc(sbb->os, mx, int);
    sbb->nL = mx;
  }
  sbb->line[sbb->n]=&(sbb->s[sbb->o]);
  sbb->os[sbb->n]= sbb->o;
  sbb->o += n + 1; // n should include the \0 character
  sbb->n = sbb->n+1;
  sbb->lProp[sbb->n] = -1;
  sbb->lType[sbb->n] = 0;
  sbb->os[sbb->n]= sbb->o;
}

