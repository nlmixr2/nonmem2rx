#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>   /* dj: import intptr_t */
//#include "ode.h"
#include <rxode2parseSbuf.h>
#include <errno.h>
#include <dparser2.h>
#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <Rmath.h>
#ifdef ENABLE_NLS
#include <libintl.h>
#define _(String) dgettext ("nonmem2rx", String)
/* replace pkg as appropriate */
#else
#define _(String) (String)
#endif
#include "abbrec.g.d_parser.h"
#define max2( a , b )  ( (a) > (b) ? (a) : (b) )

#define gBuf nonmem2rx_abbrec_gBuf
#define gBufFree nonmem2rx_abbrec_gBufFree
#define gBufLast nonmem2rx_abbrec_gBufLast
#define curP nonmem2rx_abbrec_curP
#define errP nonmem2rx_curP
#define _pn nonmem2rx_abbrec__pn
#define freeP nonmem2rx_abbrec_freeP
#define parseFreeLast nonmem2rx_abbrec_parseFreeLast
#define parseFree nonmem2rx_abbrec_parseFree
#include "parseSyntaxErrors.h"

sbuf sbErr1;
sbuf sbErr2;
sbuf sbTransErr;
sbuf firstErr;
char *eBuf;
int eBufFree=0;
int eBufLast=0;
int syntaxErrorExtra = 0;
int isEsc=0;
int lastSyntaxErrorLine=0;
extern const char *lastStr;
extern int lastStrLoc;

int _rxode2_reallyHasAfter = 0;
int rx_suppress_syntax_info = 0;
const char *record;

SEXP _nonmem2rx_setRecord(SEXP rec) {
  record = (char*)rc_dup_str(CHAR(STRING_ELT(rec, 0)), 0);
  return R_NilValue;
}


extern D_ParserTables nonmem2rxAbbrevRec;

char* gBuf;
int gBufLast = 0;
int gBufFree = 0;
D_Parser *curP=NULL;
D_Parser *errP=NULL;
D_ParseNode *_pn = 0;

void freeP(void){
  if (_pn){
    free_D_ParseTreeBelow(curP,_pn);
    free_D_ParseNode(curP,_pn);
  }
  _pn=0;
  if (curP != NULL){
    free_D_Parser(curP);
  }
  curP = NULL;
}
void parseFreeLast(void) {
  if (gBufFree) R_Free(gBuf);
  //sFree(&sbOut);
  freeP();
  //sFree(&_bufw);
  //sFree(&_bufw2);
}
void parseFree(int last) {
  freeP();
  if (last){
    parseFreeLast();
  }
}

extern char * rc_dup_str(const char *s, const char *e);
typedef void (print_node_fn_t)(int depth, char *token_name, char *token_value, void *client_abbrec);
void wprint_node_abbrec(int depth, char *token_name, char *token_value, void *client_abbrec) {}

extern sbuf curLine;
int abbrecAddSeq = 0;
int abbrecAddNameItem = 0;

SEXP nonmem2rxAddReplaceDirect1(const char *type, const char *var, int num);
SEXP nonmem2rxAddReplaceDirect2(const char *what, const char *with);
SEXP nonmem2rxReplaceProcessSeq(const char *what);
SEXP nonmem2rxReplaceIsDataItem(const char *what);
SEXP nonmem2rxReplaceDataItem(const char *type);
SEXP nonmem2rxReplaceProcessLabel(const char *label);
SEXP nonmem2rxReplaceMultiple(const char *type);

int abbrecProcessLabel(const char* name, D_ParseNode *pn) {
  if (abbrecAddNameItem == 1 && !strcmp("identifier_nm", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    nonmem2rxReplaceProcessLabel(v);
    return 1;
  }
  return 0;
}

int abbrecProcessByStatement(const char* name, D_ParseNode *pn) {
  if (!strcmp("decimalintNo0neg", name)) {
    // This only occurs with the by statement, so finish the by statement parsing
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    sAppend(&curLine, ", by=%s)", v);
    nonmem2rxReplaceProcessSeq(curLine.s);
    sClear(&curLine);
    abbrecAddSeq = 1;
    return 1;
  }
  return 1;
}

int abbrecProcessSeq(const char* name, D_ParseNode *pn) {
  if (!strcmp("seq_nm", name)) {
    sAppendN(&curLine, "seq(", 4);
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 2);
    char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 3);
    char *v3 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v3[0] == 0) {
      // by statement will be processed later
      sAppend(&curLine, "%s, %s)", v, v2);
      nonmem2rxReplaceProcessSeq(curLine.s);
      sClear(&curLine);
    } else {
      sAppend(&curLine, "%s, %s", v, v2);
      abbrecAddSeq = 0;
    }
    return 1;
  }
  return 0;
}

int abbrecAddSingleDigit(const char* name, D_ParseNode *pn) {
  if (abbrecAddSeq == 1 &&
      (!strcmp("decimalintNo0", name) ||
       !strcmp("decimalint", name))) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    sAppend(&curLine, "c(%s)", v);
    nonmem2rxReplaceProcessSeq(curLine.s);
    sClear(&curLine);
  }
  return 0;
}

int abbrecProcessDirect1(const char* name, D_ParseNode *pn) {
  if (!strcmp("replace_direct1", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 5);
    char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (strcmp(v, v2)) {
      sClear(&sbTransErr);
      sAppend(&sbTransErr, "compartment '%s' needs differential equations defined", v);
      updateSyntaxCol();
      trans_syntax_error_report_fn0(sbTransErr.s);
      return 1;
    }
    xpn = d_get_child(pn, 2);
    v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 7);
    char *v3 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    int num = atoi(v3);
    nonmem2rxAddReplaceDirect1(v, v2, num);
    return 1;
  }
  return 0;
}

int abbrecProcessDirect2(const char* name, D_ParseNode *pn) {
  int isStr=0;
  if (!strcmp("replace_direct2", name) ||
      (isStr = !strcmp("replace_direct3", name))) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *what = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 2);
    char *with = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (isStr) {
      // take off quotes
      with++;
      int len = strlen(with);
      with[len-1] = 0;
    }
    nonmem2rxAddReplaceDirect2(what, with);
    return 1;
  }
  return 0;
}
char *abbrecVarType = NULL;

int abbrecProcessDataParItem(const char* name, D_ParseNode *pn) {
  char *dataItem = NULL;
  if (!strcmp("replace_data", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    abbrecVarType = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 5); 
    char *tmp = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (strcmp(abbrecVarType, tmp)) {
      sClear(&sbTransErr);
      sAppend(&sbTransErr, "$ABBREVIATED nonmem2rx will not change var type from '%s' to '%s'", abbrecVarType, tmp);
      updateSyntaxCol();
      trans_syntax_error_report_fn0(sbTransErr.s);
      return 1;
    }
    xpn = d_get_child(pn, 2);
    dataItem = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (!INTEGER(nonmem2rxReplaceIsDataItem(dataItem))[0]) {
      sClear(&sbTransErr);
      sAppend(&sbTransErr, "$ABBREVIATED REPLACE requesting data item replacement for '%s' which is not defined in the $INPUT record", dataItem);
      updateSyntaxCol();
      trans_syntax_error_report_fn0(sbTransErr.s);
      return 1;
    }
    // parse sequence by continuing parse tree
    abbrecAddSeq = 1;
    return 1;
  }
  return 0;
}

int abbrecProcessMultipleItem(const char* name, D_ParseNode *pn, int i) {
  if (!strcmp("replace_multiple", name)) {
    if (i == 1) return 1;
    if (i == 4) return 1;
    if (i == 5) return 1;
    if (i == 6) return 1;
    if (i == 0) {
      abbrecAddNameItem=1;
      abbrecAddSeq = 1;
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      xpn = d_get_child(pn, 6);
      char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (strcmp(v, v2)) {
        sClear(&sbTransErr);
        sAppend(&sbTransErr, "$ABBREVIATED nonmem2rx will not change var type from '%s' to '%s'", v, v2);
        updateSyntaxCol();
        trans_syntax_error_report_fn0(sbTransErr.s);
      }
      abbrecVarType = v;
    }
  }
  return 0;
}


void wprint_parsetree_abbrec(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_abbrec) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  abbrecProcessDataParItem(name, pn) ||
    abbrecAddSingleDigit(name, pn) ||
    abbrecProcessDirect1(name, pn) ||
    abbrecProcessDirect2(name, pn) ||
    abbrecProcessLabel(name, pn) ||
    abbrecProcessSeq(name, pn) ||
    abbrecProcessByStatement(name, pn);
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      if (abbrecProcessMultipleItem(name, pn, i)) {
        continue;
      }
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_abbrec(pt, xpn, depth, fn, client_abbrec);
    }
  }
  if (!strcmp("replace_data", name)) {
    nonmem2rxReplaceDataItem(abbrecVarType);
    abbrecAddSeq = 0;
    return;
  } else if (!strcmp("replace_multiple", name)) {
    nonmem2rxReplaceMultiple(abbrecVarType);
    abbrecAddSeq = 0;
    abbrecAddNameItem=0;
  }
}

void trans_abbrec(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxAbbrevRec, sizeof(D_ParseNode_User));
  curP->save_parse_tree = 1;
  curP->error_recovery = 1;
  curP->initial_scope = NULL;
  curP->syntax_error_fn = nonmem2rxSyntaxError;
  if (gBufFree) R_Free(gBuf);
  errP=curP;
  // Should be able to use gBuf directly, but I believe it cause
  // problems with R's garbage collection, so duplicate the string.
  gBuf = (char*)(parse);
  eBuf = gBuf;
  eBufLast = 0;
  gBufFree=0;
  _pn= dparse(curP, gBuf, (int)strlen(gBuf));
  if (!_pn || curP->syntax_errors) {
  } else {
    wprint_parsetree_abbrec(parser_tables_nonmem2rxAbbrevRec , _pn, 0, wprint_node_abbrec, NULL);
  }
  finalizeSyntaxError();
}

SEXP _nonmem2rx_trans_abbrec(SEXP in) {
  sClear(&curLine);
  sClear(&firstErr);
  trans_abbrec(R_CHAR(STRING_ELT(in, 0)));
  parseFree(0);
  return R_NilValue;
}
