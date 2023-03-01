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
#include "sub.g.d_parser.h"
#include "strncmpi.h"

#define gBuf nonmem2rx_sub_gBuf
#define gBufFree nonmem2rx_sub_gBufFree
#define gBufLast nonmem2rx_sub_gBufLast
#define curP nonmem2rx_sub_curP
#define _pn nonmem2rx_sub__pn
#define freeP nonmem2rx_sub_freeP
#define parseFreeLast nonmem2rx_sub_parseFreeLast
#define parseFree nonmem2rx_sub_parseFree
#include "parseSyntaxErrors.h"

extern D_ParserTables parser_tables_nonmem2rxSub;

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
extern sbuf curLine;
const char *subPrefix;

// from mkdparse_tree.h
typedef void (print_node_fn_t)(int depth, char *token_name, char *token_value, void *client_data);

void wprint_node_sub(int depth, char *name, char *value, void *client_data)  {}

extern char * rc_dup_str(const char *s, const char *e);

SEXP nonmem2rxSetAdvan(int advan);
SEXP nonmem2rxSetTrans(int trans);

SEXP nonmem2rxSetAtol(int tol);
SEXP nonmem2rxSetRtol(int tol);
SEXP nonmem2rxSetSsAtol(int tol);
SEXP nonmem2rxSetSsRtol(int tol);

static inline int nonmem2rx_getSubTol(const char* name, D_ParseNode *pn) {
  if (!strcmp("tol_statement1", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxSetRtol(atoi(v));
    return 1;
  }
  if (!strcmp("atol_statement1", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxSetAtol(atoi(v));
    return 1;
  }
  if (!strcmp("ssatol_statement1", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxSetSsAtol(atoi(v));
    return 1;
  }
  if (!strcmp("ssrtol_statement1", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxSetSsRtol(atoi(v));
    return 1;
  }
  return 0;
}

static inline int nonmem2rx_sub_unsupported(const char* name, D_ParseNode *pn) {
  if (!strcmp("unsupported_statement", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "$SUBROUTINES '%s' unsupported for translation", v);
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
    return 1;
  }
  if (!strcmp("atol_statement2", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "$SUBROUTINES 'ATOL' subroutine from external fortran unsupported for translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
    return 1;
  }
  if (!strcmp("ssatol_statement2", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "$SUBROUTINES 'SSATOL' subroutine from external fortran unsupported for translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
    return 1;
  }
  if (!strcmp("ssrtol_statement2", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "$SUBROUTINES 'SSRTOL' subroutine from external fortran unsupported for translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
    return 1;
  }
  if (!strcmp("tol_statement2", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "$SUBROUTINES 'TOL' subroutine from external fortran unsupported for translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
    return 1;
  }
  return 0;
}


void wprint_parsetree_sub(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  if (nonmem2rx_getSubTol(name, pn)) {
    return;
  }
  if (nonmem2rx_sub_unsupported(name, pn)) {
    return;
  }
  if (!strcmp("advan_statement1", name)) {
    D_ParseNode *xpn = d_get_child(pn, 3);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxSetAdvan(atoi(v));
    return;
  }
  if (!strcmp("advan_statement2", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxSetAdvan(atoi(v));
    return;
  }
  if (!strcmp("trans_statement1", name)) {
    D_ParseNode *xpn = d_get_child(pn, 3);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxSetTrans(atoi(v));
    return;
  }
  if (!strcmp("trans_statement2", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxSetTrans(atoi(v));
    return;
  }
  int nch = d_get_number_of_children(pn);
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_sub(pt, xpn, depth, fn, client_data);
    }
  }
}

void trans_sub(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxSub, sizeof(D_ParseNode_User));
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
    wprint_parsetree_sub(parser_tables_nonmem2rxSub, _pn, 0, wprint_node_sub, NULL);
  }
  finalizeSyntaxError();
}

SEXP _nonmem2rx_trans_sub(SEXP in) {
  trans_sub(R_CHAR(STRING_ELT(in, 0)));
  parseFree(0);
  return R_NilValue;
}
