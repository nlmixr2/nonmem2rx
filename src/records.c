#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>   /* dj: import intptr_t */
//#include "ode.h"
#include <rxode2parseSbuf.h>
#include <errno.h>
#include <dparser.h>
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
#include "records.g.d_parser.h"

extern D_ParserTables parser_tables_nonmem2rxRecords;

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

char *curRecord = NULL;
sbuf curLine;

void pushRecord() {
  if (curRecord != NULL) {
    // push record information
    curRecord = NULL;
    sClear(&curLine);
  }
}

const char *lastStr;
int lastStrLoc=0;
vLines _dupStrs;
char * rc_dup_str(const char *s, const char *e) {
  lastStr=s;
  int l = e ? e-s : (int)strlen(s);
  //syntaxErrorExtra=min(l-1, 40);
  addLine(&_dupStrs, "%.*s", l, s);
  return _dupStrs.line[_dupStrs.n-1];
}

// from mkdparse_tree.h
typedef void (print_node_fn_t)(int depth, char *token_name, char *token_value, void *client_data);

void wprint_parsetree_records(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn), i, ii, found, safe_zero = 0;
  char *value = (char*)rc_dup_str(pn->start_loc.s, pn->end);
  if (!strcmp("singleLineRecord", name)) {
    D_ParseNode *xpn = d_get_child(pn,1); // record
    pushRecord();
    curRecord = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn,2); // rest of line
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppend(&curLine, "%s\n",v);
  } else if (!strcmp("singleLineNoRecord", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0); // line
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppend(&curLine, "%s\n",v);
  }
}

void trans_records(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxRecords, sizeof(D_ParseNode_User));
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
    wprint_parsetree_records(parser_tables_nonmem2rxRecords, _pn, 0, wprint_parsetree_records, NULL);
  }
}


