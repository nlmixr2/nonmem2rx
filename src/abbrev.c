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
#include "abbrev.g.d_parser.h"

#define gBuf nonmem2rx_abbrev_gBuf
#define gBufFree nonmem2rx_abbrev_gBufFree
#define gBufLast nonmem2rx_abbrev_gBufLast
#define curP nonmem2rx_abbrev_curP
#define _pn nonmem2rx_abbrev__pn
#define freeP nonmem2rx_abbrev_freeP
#define parseFreeLast nonmem2rx_abbrev_parseFreeLast
#define parseFree nonmem2rx_abbrev_parseFree


extern D_ParserTables parser_tables_nonmem2rxAbbrev;

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
extern sbuf curLine;

// from mkdparse_tree.h
typedef void (print_node_fn_t)(int depth, char *token_name, char *token_value, void *client_data);

void wprint_node_abbrev(int depth, char *name, char *value, void *client_data)  {
  
}

extern char * rc_dup_str(const char *s, const char *e);

SEXP nonmem2rxPushModelLine(const char *item1);

void pushModel() {
  nonmem2rxPushModelLine(curLine.s);
  sClear(&curLine);
}

int abbrev_if_while_clause(char *name, int i) {
  if (strcmp("ifthen", name)) {
    if (i == 0) {
      sAppendN(&curLine, "if (", 4);
      return 1;
    } else if (i == 1 || i == 3) {
      return 1;
    } else if (i == 4) {
      sAppendN(&curLine, ") {", 3);
      pushModel();
      return 1;
    }
  } else if (!strcmp("elseif", name)) {
    if (i == 0) {
      sAppendN(&curLine, "} else if (", 11);
      return 1;
    } else if (i == 1 || i == 3) {
      return 1;
    } else if (i == 4) {
      sAppendN(&curLine, ") {", 3);
      pushModel();
      return 1;
    }
  } else if (!strcmp("if1", name)) {
    if (i == 0) {
      sAppendN(&curLine, "if (", 4);
      return 1;
    } else if (i == 1) {
      return 1;
    } else if (i == 3) {
      sAppendN(&curLine, ")", 1);
      return 1;
    }
  } else if (!strcmp("dowhile", name)) {
    if (i == 0) {
      sAppendN(&curLine, "while (", 7);
      return 1;
    } else if (i == 1 || i == 2) {
      return 1;
    } else if (i ==4) {
      sAppendN(&curLine, ") {", 3);
      pushModel();
      return 1;
    }
  }
  return 0;
}

void wprint_parsetree_abbrev(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  // These don't have any recursive paring involved and can be handled here
  if (!strcmp("else", name)) {
    sAppendN(&curLine, "} else {", 7);
    pushModel();
    return;
  } else if (!strcmp("endif", name) || !strcmp("enddo", name)) {
    sAppendN(&curLine, "}", 1);
    pushModel();
    return;
  }
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      if (abbrev_if_while_clause(name, i)) {
        continue;
      }
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_abbrev(pt, xpn, depth, fn, client_data);
    }
  }
}

void trans_abbrev(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxAbbrev, sizeof(D_ParseNode_User));
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
    Rf_errorcall(R_NilValue, "parsing error during the record parsing");
  } else {
    wprint_parsetree_abbrev(parser_tables_nonmem2rxAbbrev, _pn, 0, wprint_node_abbrev, NULL);
    pushModel();
  }
}

SEXP _nonmem2rx_trans_abbrev(SEXP in) {
  trans_abbrev(R_CHAR(STRING_ELT(in, 0)));
  parseFree(0);
  return R_NilValue;
}
