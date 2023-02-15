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
#include "input.g.d_parser.h"

#define gBuf nonmem2rx_input_gBuf
#define gBufFree nonmem2rx_input_gBufFree
#define gBufLast nonmem2rx_input_gBufLast
#define curP nonmem2rx_input_curP
#define _pn nonmem2rx_input__pn
#define freeP nonmem2rx_input_freeP
#define parseFreeLast nonmem2rx_input_parseFreeLast
#define parseFree nonmem2rx_input_parseFree


extern D_ParserTables parser_tables_nonmem2rxInput;

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

// from mkdparse_tree.h
typedef void (print_node_fn_t)(int depth, char *token_name, char *token_value, void *client_data);

void wprint_node_input(int depth, char *name, char *value, void *client_data)  {
  
}

extern char * rc_dup_str(const char *s, const char *e);
SEXP nonmem2rxPushInput(const char *item1, const char *item2);

void wprint_parsetree_input(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  if (!strcmp("reg_item", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0); // record
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxPushInput(v, v);
    return;
  } else if (!strcmp("alias_item", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0); // line
    char *v1 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 2); // line
    char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxPushInput(v1, v2);
    return;
  } else if (!strcmp("drop1", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v1 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    char *v2 = NULL;
    nonmem2rxPushInput(v1, v2);
  } else if (!strcmp("drop2", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v1 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    char *v2 = NULL;
    nonmem2rxPushInput(v1, v2);
  } else if (!strcmp("drop3", name)) {
    char *v1 = NULL;
    nonmem2rxPushInput(v1, v1);
  }
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_input(pt, xpn, depth, fn, client_data);
    }
  }
}

void trans_input(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxInput, sizeof(D_ParseNode_User));
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
    Rf_errorcall(R_NilValue, "parsing error for $INPUT");
  } else {
    wprint_parsetree_input(parser_tables_nonmem2rxInput, _pn, 0, wprint_node_input, NULL);
  }
}

SEXP _nonmem2rx_trans_input(SEXP in) {
  trans_input(R_CHAR(STRING_ELT(in, 0)));
  parseFree(0);
  return R_NilValue;
}
