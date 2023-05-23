#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>   /* dj: import intptr_t */
//#include "ode.h"
#include <rxode2parseSbuf.h>
#include <errno.h>
#include "dparser3.h"
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
#include "lst.g.d_parser.h"
#define max2( a , b )  ( (a) > (b) ? (a) : (b) )

#define gBuf nonmem2rx_lst_gBuf
#define gBufFree nonmem2rx_lst_gBufFree
#define gBufLast nonmem2rx_lst_gBufLast
#define curP nonmem2rx_lst_curP
#define _pn nonmem2rx_lst__pn
#define freeP nonmem2rx_lst_freeP
#define parseFreeLast nonmem2rx_lst_parseFreeLast
#define parseFree nonmem2rx_lst_parseFree
#include "parseSyntaxErrors.h"

extern D_ParserTables parser_tables_nonmem2rxLst;

extern char *eBuf;
extern int eBufLast;
extern sbuf sbTransErr;

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
void wprint_node_lst(int depth, char *token_name, char *token_value, void *client_data) {}

extern sbuf curLine;
void sExchangeParen(sbuf *sbb) {
  if (sbb->o == 0) return;
  char *cur =sbb->s+sbb->o - 1;
  cur[0] = ')';
}
int lstType = 0;
SEXP nonmem2rxPushLst(const char* type, const char *est);
void pushList(void) {
  switch(lstType) {
  case 1:
    nonmem2rxPushLst("theta", curLine.s);
    break;
  case 2:
    nonmem2rxPushLst("eta", curLine.s);
    break;
  case 3:
    nonmem2rxPushLst("eps", curLine.s);
    break;
  case 5:
    nonmem2rxPushLst("cov", curLine.s);
    break;
  }
  lstType=0;
}
void wprint_parsetree_lst(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  if (!strcmp("constant", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v[0] != 0) sAppend(&curLine, "%s", v);
    xpn = d_get_child(pn, 1);
    v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppend(&curLine, "%s,", v);
  /* } else if (!strcmp("est_label", name)) { */
  } else if (!strcmp("na_item", name)) {
    if (lstType == 1) {
      sAppendN(&curLine, "NA,", 3);
    } else {
      sAppendN(&curLine, "0.0,", 4);
    }
  } else if (!strcmp("theta_est_line", name)) {
    lstType=1;
    sClear(&curLine);
    sAppendN(&curLine, "c(", 2);
  } else if (!strcmp("omega_est_line", name)) {
    sExchangeParen(&curLine);
    pushList();
    lstType=2;
    sClear(&curLine);
    sAppendN(&curLine, "c(", 2);
  } else if (!strcmp("sigma_est_line", name)) {
    sExchangeParen(&curLine);
    pushList();
    lstType=3;
    sClear(&curLine);
    sAppendN(&curLine, "c(", 2);
  } else if (!strcmp("omega_cor_line", name)) {
    sExchangeParen(&curLine);
    pushList();
    lstType=4;
    sClear(&curLine);
    sAppendN(&curLine, "c(", 2);
  } else if (!strcmp("sigma_cor_line", name)) {
    sExchangeParen(&curLine);
    pushList();
    lstType=4;
    sClear(&curLine);
    sAppendN(&curLine, "c(", 2);
  }
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_lst(pt, xpn, depth, fn, client_data);
    }
  }
}

void trans_lst(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxLst, sizeof(D_ParseNode_User));
  curP->save_parse_tree = 1;
  curP->error_recovery = 1;
  curP->initial_scope = NULL;
  curP->syntax_error_fn = nonmem2rxSyntaxError;
  if (gBufFree) R_Free(gBuf);
  // Should be able to use gBuf directly, but I believe it cause
  // problems with R's garbage collection, so duplicate the string.
  gBuf = (char*)(parse);
  gBufFree=0;
  
  eBuf = gBuf;
  eBufLast = 0;
  errP = curP;

  _pn= dparse(curP, gBuf, (int)strlen(gBuf));
  if (!_pn || curP->syntax_errors) {
    //rx_syntax_error = 1;
  } else {
    wprint_parsetree_lst(parser_tables_nonmem2rxLst, _pn, 0, wprint_node_lst, NULL);
  }
  if (lstType != 0) {
    sExchangeParen(&curLine);
    pushList();
  }
  finalizeSyntaxError();
}

SEXP _nonmem2rx_trans_lst(SEXP in, SEXP cov) {
  if (INTEGER(cov)[0]) {
    lstType = 5;
  }
  sClear(&curLine);
  trans_lst(R_CHAR(STRING_ELT(in, 0)));
  parseFree(0);
  return R_NilValue;
}
