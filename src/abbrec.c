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
void wprint_parsetree_abbrec(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_abbrec) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  /* if (!strcmp("filename_t3", name)) { */

  /* } */
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_abbrec(pt, xpn, depth, fn, client_abbrec);
    }
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
