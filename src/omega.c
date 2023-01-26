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
#include "omega.g.d_parser.h"

#define gBuf nonmem2rx_omega_gBuf
#define gBufFree nonmem2rx_omega_gBufFree
#define gBufLast nonmem2rx_omega_gBufLast
#define curP nonmem2rx_omega_curP
#define _pn nonmem2rx_omega__pn
#define freeP nonmem2rx_omega_freeP
#define parseFreeLast nonmem2rx_omega_parseFreeLast
#define parseFree nonmem2rx_omega_parseFree

extern D_ParserTables parser_tables_nonmem2rxOmega;

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
void wprint_node_omega(int depth, char *token_name, char *token_value, void *client_data) {
  
}

int nonmem2rx_omeganum = 1;
int nonmem2rx_omegaDiagonal = 0;
int nonmem2rx_omegaBlockn = 0;
int nonmem2rx_omegaSame = 0;
int nonmem2rx_omegaFixed = 0;
char *omegaEstPrefix;

extern char *curComment;
sbuf curOmega;

SEXP _nonmem2rx_omeganum_reset() {
  nonmem2rx_omeganum = 1;
  nonmem2rx_omegaDiagonal = 1;
  nonmem2rx_omegaBlockn = 0;
  nonmem2rx_omegaSame = 0;
  nonmem2rx_omegaFixed = 0;
  sIni(&curOmega);
  return R_NilValue;
}

SEXP _nonmem2rx_omeganum_set(SEXP in) {
  nonmem2rx_omeganum = INTEGER(in)[0];
  return R_NilValue;
}

void wprint_parsetree_omega(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  if (!strcmp("omega_statement", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v[0] == 0) {
      curComment = NULL;
    } else {
      curComment = v;
    }
  } else if (!strcmp("blockn", name)) {
  } else if (!strcmp("blocknsame", name)) {
  } else if (!strcmp("blocksame", name)) {
  } else if (!strcmp("diagonal", name)) {
  } else if (!strcmp("omega2", name)) {
    // this form is only good for diagonal matrices
    if (nonmem2rx_omegaBlockn != 0) {
      
    }
    nonmem2rx_omegaFixed = 1;
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppend(&curOmega, "%s%d ~ fix(%s)", v);
    return;
  }
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_omega(pt, xpn, depth, fn, client_data);
    }
  }
}


void trans_omega(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxOmega, sizeof(D_ParseNode_User));
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
  } else {
    wprint_parsetree_omega(parser_tables_nonmem2rxOmega, _pn, 0, wprint_node_omega, NULL);
  }
}

SEXP _nonmem2rx_trans_omega(SEXP in, SEXP prefix) {
  omegaEstPrefix = (char*)rc_dup_str(R_CHAR(STRING_ELT(in, 0)), 0);
  trans_omega(R_CHAR(STRING_ELT(in, 0)));
  return R_NilValue;
}
