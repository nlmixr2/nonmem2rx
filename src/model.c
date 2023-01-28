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
#include "model.g.d_parser.h"

#define gBuf nonmem2rx_model_gBuf
#define gBufFree nonmem2rx_model_gBufFree
#define gBufLast nonmem2rx_model_gBufLast
#define curP nonmem2rx_model_curP
#define _pn nonmem2rx_model__pn
#define freeP nonmem2rx_model_freeP
#define parseFreeLast nonmem2rx_model_parseFreeLast
#define parseFree nonmem2rx_model_parseFree

extern D_ParserTables parser_tables_nonmem2rxModel;
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
typedef void (print_node_fn_t)(int depth, char *token_name, char *token_value, void *client_data);
void wprint_node_model(int depth, char *token_name, char *token_value, void *client_data) {
}

sbuf modelName;
SEXP nonmem2rxPushModel(const char *cmtName);
int nonmem2rx_model_cmt = 1;
int nonmem2rx_model_warn_npar = 0;

void wprint_parsetree_model(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  if (!strcmp("ncpt_statement", name)) {
    if (nonmem2rx_model_warn_npar ==0)
      Rf_warning("$MODEL NCOMPARTMENTS/NEQUILIBRIUM/NPARAMETERS statement(s) ignored");
    nonmem2rx_model_warn_npar = 1;
  } else if (!strcmp("link_statement", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "$MODEL statements with LINK are not currently translated");
  } else if (!strcmp("comp_statement_1", name)) {
    D_ParseNode *xpn = d_get_child(pn, 3);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxPushModel(v);
    nonmem2rx_model_cmt++;
  } else if (!strcmp("comp_statement_2", name)) {
    sClear(&modelName);
    sAppend(&modelName, "a%d", nonmem2rx_model_cmt);
    nonmem2rxPushModel(modelName.s);
    nonmem2rx_model_cmt++;
  }
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_model(pt, xpn, depth, fn, client_data);
    }
  }
}

void trans_model(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxModel, sizeof(D_ParseNode_User));
  curP->save_parse_tree = 1;
  curP->error_recovery = 1;
  curP->initial_scope = NULL;
  //curP->syntax_error_fn = rxSyntaxError;
  if (gBufFree) R_Free(gBuf);
  // Should be able to use gBuf directly, but I believe it cause
  // problems with R's garbage collection, so duplicate the string.
  gBuf = (char*)(parse);
  gBufFree=0;
  nonmem2rx_model_cmt = 1;
  nonmem2rx_model_warn_npar = 0;
  _pn= dparse(curP, gBuf, (int)strlen(gBuf));
  if (!_pn || curP->syntax_errors) {
    //rx_syntax_error = 1;
    parseFree(0);
    Rf_errorcall(R_NilValue, "error parsing $MODEL statement");
  } else {
    wprint_parsetree_model(parser_tables_nonmem2rxModel, _pn, 0, wprint_node_model, NULL);
  }
}

SEXP _nonmem2rx_trans_model(SEXP in) {
  sIni(&modelName);
  trans_model(R_CHAR(STRING_ELT(in, 0)));
  parseFree(0);
  sFree(&modelName);
  parseFree(0);
  return R_NilValue;
}
