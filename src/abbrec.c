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
#define _pn nonmem2rx_abbrec__pn
#define freeP nonmem2rx_abbrec_freeP
#define parseFreeLast nonmem2rx_abbrec_parseFreeLast
#define parseFree nonmem2rx_abbrec_parseFree

extern D_ParserTables nonmem2rxAbbrevRec;

char *gBuf;
int gBufFree=0;
int gBufLast = 0;
D_Parser *curP=NULL;
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
//sbuf sbErr1;
//sbuf sbErr2;
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
SEXP nonmem2rxReplaceDataItem(const char *type, const char *dataItem);
SEXP nonmem2rxReplaceDataParItem(const char *type, const char *dataItem, const char *varItem);
SEXP nonmem2rxReplaceProcessLabel(const char *label);
SEXP nonmem2rxReplaceMultiple(const char *type);

void wprint_parsetree_abbrec(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_abbrec) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  char *varType = NULL;
  char *dataItem = NULL;
  char *varItem = NULL;
  int nch = d_get_number_of_children(pn);
  int isStr=0;
  if (abbrecAddNameItem == 1 && !strcmp("identifier_nm", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    nonmem2rxReplaceProcessLabel(v);
  } else if (!strcmp("decimalintNo0neg", name)) {
    // This only occurs with the by statement, so finish the by statement parsing
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    sAppend(&curLine, ", by=%s)", v);
    nonmem2rxReplaceProcessSeq(curLine.s);
    sClear(&curLine);
    abbrecAddSeq = 1;
  } else if (!strcmp("seq_nm", name)) {
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
  } else if (abbrecAddSeq == 1 && (!strcmp("decimalintNo0", name) ||
                                   !strcmp("decimalint", name))) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    sAppend(&curLine, "c(%s)", v);
    nonmem2rxReplaceProcessSeq(curLine.s);
    sClear(&curLine);
  } else if (!strcmp("replace_direct1", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 5);
    char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (strcmp(v, v2)) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "$ABBREVIATED nonmem2rx will not change var type from '%s' to '%s'", v, v2);
    }
    xpn = d_get_child(pn, 2);
    v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 7);
    char *v3 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    int num = atoi(v3);
    nonmem2rxAddReplaceDirect1(v, v2, num);
  } else if (!strcmp("replace_direct2", name) ||
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
  } else if (!strcmp("replace_data", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    varType = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 5); 
    char *tmp = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (strcmp(varType, tmp)) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "$ABBREVIATED nonmem2rx will not change var type from '%s' to '%s'", varType, tmp);
    }
    xpn = d_get_child(pn, 2);
    dataItem = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (!INTEGER(nonmem2rxReplaceIsDataItem(dataItem))[0]) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "$ABBREVIATED REPLACE requesting data item replacement for '%s' which is not defined in the $INPUT record", dataItem);
    }
    // parse sequence by continuing parse tree
    abbrecAddSeq = 1;
  } else if (!strcmp("replace_data_par", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    varType = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 7);
    char *tmp = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (strcmp(varType, tmp)) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "$ABBREVIATED nonmem2rx will not change var type from '%s' to '%s'", varType, tmp);
    }
    xpn = d_get_child(pn, 2);
    dataItem = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 4);
    varItem = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (!INTEGER(nonmem2rxReplaceIsDataItem(dataItem))[0]) {
      if (!INTEGER(nonmem2rxReplaceIsDataItem(varItem))[0]) {
        tmp = varItem;
        varItem = dataItem;
        dataItem = tmp;
      } else {
        parseFree(0);
        Rf_errorcall(R_NilValue, "$ABBREVIATED REPLACE requesting data item replacement for '%s' which is not defined in the $INPUT record", dataItem);
      }
    }
    // parse sequence by continuing parse tree
    abbrecAddSeq = 1;
  }
  /* if (!strcmp("filename_t3", name)) { */

  /* } */
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      if (!strcmp("replace_multiple", name)) {
        if (i == 1) continue;
        if (i == 4) continue;
        if (i == 5) continue;
        if (i == 6) continue;
        if (i == 0) {
          abbrecAddNameItem=1;
          abbrecAddSeq = 1;
          D_ParseNode *xpn = d_get_child(pn, 0);
          char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
          xpn = d_get_child(pn, 6);
          char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
          if (strcmp(v, v2)) {
            parseFree(0);
            Rf_errorcall(R_NilValue, "$ABBREVIATED nonmem2rx will not change var type from '%s' to '%s'", v, v2);
          }
          varType = v;
        }
      }
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_abbrec(pt, xpn, depth, fn, client_abbrec);
    }
  }
  if (!strcmp("replace_data", name)) {
    nonmem2rxReplaceDataItem(varType, dataItem);
    abbrecAddSeq = 0;
    return;
  } else if (!strcmp("replace_data_par", name)) {
    nonmem2rxReplaceDataParItem(varType, dataItem, varItem);
    abbrecAddSeq = 0;
  } else if (!strcmp("replace_multiple", name)) {
    nonmem2rxReplaceMultiple(varType);
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
  //curP->syntax_error_fn = rxSyntaxError;
  if (gBufFree) R_Free(gBuf);
  // Should be able to use gBuf directly, but I believe it cause
  // problems with R's garbage collection, so duplicate the string.
  gBuf = (char*)(parse);
  gBufFree=0;
  _pn= dparse(curP, gBuf, (int)strlen(gBuf));
  if (!_pn || curP->syntax_errors) {
    //rx_syntax_error = 1;
    parseFree(0);
    Rf_errorcall(R_NilValue, "parsing error $ABBREVIATED record");
  } else {
    wprint_parsetree_abbrec(parser_tables_nonmem2rxAbbrevRec , _pn, 0, wprint_node_abbrec, NULL);
  }
}

SEXP _nonmem2rx_trans_abbrec(SEXP in) {
  sIni(&curLine);
  sClear(&curLine);
  trans_abbrec(R_CHAR(STRING_ELT(in, 0)));
  parseFree(0);
  return R_NilValue;
}
