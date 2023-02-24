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
#include "data.g.d_parser.h"
#define max2( a , b )  ( (a) > (b) ? (a) : (b) )

#define gBuf nonmem2rx_data_gBuf
#define gBufFree nonmem2rx_data_gBufFree
#define gBufLast nonmem2rx_data_gBufLast
#define curP nonmem2rx_data_curP
#define _pn nonmem2rx_data__pn
#define freeP nonmem2rx_data_freeP
#define parseFreeLast nonmem2rx_data_parseFreeLast
#define parseFree nonmem2rx_data_parseFree

extern D_ParserTables parser_tables_nonmem2rxData;

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
  freeP();
}
void parseFree(int last) {
  freeP();
  if (last){
    parseFreeLast();
  }
}

extern char * rc_dup_str(const char *s, const char *e);
typedef void (print_node_fn_t)(int depth, char *token_name, char *token_value, void *client_data);
void wprint_node_data(int depth, char *token_name, char *token_value, void *client_data) {}

extern sbuf curLine;
SEXP nonmem2rxPushDataFile(const char* file);
SEXP nonmem2rxPushDataCond(const char* cond);
SEXP nonmem2rxPushDataRecords(int nrec);
int ignoreAcceptFlag=0;
void wprint_parsetree_data(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  if (!strcmp("filename_t3", name) ||
      !strcmp("filename_t4", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    nonmem2rxPushDataFile(v);
    return;
  } else if (!strcmp("filename_t1", name) ||
             !strcmp("filename_t2", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    v++;
    int len = strlen(v);
    v[len-1] = 0;
    nonmem2rxPushDataFile(v);
    return;
  } else if (!strcmp("le_expression_nm", name)) {
    sAppendN(&curLine, " <= ", 4);
    return;
  } else if (!strcmp("ge_expression_nm", name)) {
    sAppendN(&curLine, " >= ", 4);
    return;
  } else if (!strcmp("gt_expression_nm", name)) {
    sAppendN(&curLine, " > ", 3);
    return;
  } else if (!strcmp("lt_expression_nm", name)) {
    sAppendN(&curLine, " < ", 3);
    return;
  } else if (!strcmp("neq_expression_nm", name)) {
    sAppendN(&curLine, " != ", 4);
    return;
  } else if (!strcmp("eq_expression_nm", name)) {
    sAppendN(&curLine, " == ", 4);
    return ;
  } else if (!strcmp("identifier_nm", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    sAppend(&curLine, ".data$%s", v);
  } else if (!strcmp("logic_constant", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    sAppend(&curLine, "%s", v);
  } else if (!strcmp("ignore_statement", name)) {
    ignoreAcceptFlag = 2;
  } else if (!strcmp("accept_statement", name)) {
    ignoreAcceptFlag = 1;
  } else if (!strcmp("ignore1_statement", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxPushDataCond(v);
    return;
  } else if (!strcmp("records_statement", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxPushDataRecords(atoi(v));
    return;
  }
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_data(pt, xpn, depth, fn, client_data);
    }
  }
  if (!strcmp("simple_logic", name)) {
    nonmem2rxPushDataCond(curLine.s);
    sClear(&curLine);
  }
}

void trans_data(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxData, sizeof(D_ParseNode_User));
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
    Rf_errorcall(R_NilValue, "parsing error $DATA record");
  } else {
    wprint_parsetree_data(parser_tables_nonmem2rxData, _pn, 0, wprint_node_data, NULL);
  }
}

SEXP _nonmem2rx_trans_data(SEXP in) {
  sClear(&curLine);
  ignoreAcceptFlag=0;
  trans_data(R_CHAR(STRING_ELT(in, 0)));
  parseFree(0);
  SEXP ret = PROTECT(Rf_allocVector(STRSXP, 1));
  switch (ignoreAcceptFlag) {
  case 1:
    SET_STRING_ELT(ret, 0,Rf_mkChar("accept"));
    break;
  case 2:
    SET_STRING_ELT(ret, 0,Rf_mkChar("ignore"));
    break;
  default:
    SET_STRING_ELT(ret, 0,Rf_mkChar("none"));
    break;
  }
  UNPROTECT(1);
  return ret;
}
