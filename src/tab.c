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
#include "tab.g.d_parser.h"
#include "strncmpi.h"

#define gBuf nonmem2rx_tab_gBuf
#define gBufFree nonmem2rx_tab_gBufFree
#define gBufLast nonmem2rx_tab_gBufLast
#define curP nonmem2rx_tab_curP
#define _pn nonmem2rx_tab__pn
#define freeP nonmem2rx_tab_freeP
#define parseFreeLast nonmem2rx_tab_parseFreeLast
#define parseFree nonmem2rx_tab_parseFree
#include "parseSyntaxErrors.h"

extern D_ParserTables parser_tables_nonmem2rxTab;

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

// from mkdparse_tree.h
typedef void (print_node_fn_t)(int depth, char *token_name, char *token_value, void *client_data);

void wprint_node_tab(int depth, char *name, char *value, void *client_data)  {

}

extern char * rc_dup_str(const char *s, const char *e);

int tableHasPred=1;
int tableHasExplicitPred=0;
int tableFullData=1;
int tableHasIPred=0;
int tableHasEta=0;
char *tableFileName = NULL;

const char *nonmem2rx_defaultFormat="s1PE11.4";
const char *nonmem2rx_tableFormat = NULL;

void wprint_parsetree_tab(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  if (!strcmp("format_statement", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rx_tableFormat = v;
  } else if (!strcmp("identifier_nm", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    if (!nmrxstrcmpi("noappend", v)) {
      tableHasPred=0;
    } else if (!nmrxstrcmpi("ipre", v)) {
      tableHasIPred=1;
    } else if (!nmrxstrcmpi("ipred", v)) {
      tableHasIPred=1;
    } else if (!nmrxstrcmpi("pred", v)) {
      tableHasExplicitPred=1;
    } else if (!strncmpci("eta", v, 3)) {
      tableHasEta=1;
    } else if (!nmrxstrcmpi("firstonly", v)) {
      tableFullData = 0;
    }
    return;
  } else if (!strcmp("paren_simple", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (!nmrxstrcmpi("eta", v)) {
      tableHasEta=1;
    }
    return;
  } else if (!strcmp("etas_statement1", name) ||
             !strcmp("etas_statement2", name)) {
    tableHasEta=1;
    return;
  } else if (!strcmp("parafile_statement", name)) {
    // don't parse the parafile filename statements
  } else if (!strcmp("filename_t3", name)) {
    tableFileName = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    return;
  } else if (!strcmp("filename_t1", name) ||
             !strcmp("filename_t2", name)) {
    tableFileName = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    tableFileName++;
    int len = strlen(tableFileName);
    tableFileName[len-1] = 0;
    return;
  }
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_tab(pt, xpn, depth, fn, client_data);
    }
  }
}

void trans_tab(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxTab, sizeof(D_ParseNode_User));
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
    wprint_parsetree_tab(parser_tables_nonmem2rxTab, _pn, 0, wprint_node_tab, NULL);
  }
  finalizeSyntaxError();
}

SEXP nonmem2rxPushTableInfo(const char *file, int hasPred, int fullData,
                            int hasIpred, int hasEta, const char *fortranFormat);

SEXP _nonmem2rx_trans_tab(SEXP in) {
  tableHasPred  = 1;
  tableFullData = 1;
  tableHasIPred = 0;
  tableHasEta   = 0;
  nonmem2rx_tableFormat = nonmem2rx_defaultFormat;
  tableHasExplicitPred = 0;
  tableFileName = NULL;
  trans_tab(R_CHAR(STRING_ELT(in, 0)));
  parseFree(0);
  if (tableFileName != NULL) {
    if (tableHasExplicitPred & !tableHasPred) tableHasPred=1;
    nonmem2rxPushTableInfo(tableFileName, tableHasPred, tableFullData,
                           tableHasIPred, tableHasEta, nonmem2rx_tableFormat);
  }
  return R_NilValue;
}
