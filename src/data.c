#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>   /* dj: import intptr_t */
//#include "ode.h"
#include <rxode2parseSbuf.h>
#include <errno.h>
#include <dparserPtr.h>
#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <Rmath.h>
#define _(String) (String)
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
#include "parseSyntaxErrors.h"

extern D_ParserTables parser_tables_nonmem2rxData;

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
void wprint_node_data(int depth, char *token_name, char *token_value, void *client_data) {}

extern sbuf curLine;
SEXP nonmem2rxPushDataFile(const char* file);
SEXP nonmem2rxPushDataCond(const char* cond);
SEXP nonmem2rxPushDataRecords(int nrec);
SEXP nonmem2rxPushDataOption(const char* opt, const char* v1, const char* v2,
                             const char* v3);
int ignoreAcceptFlag=0;
// Set while walking a `simple_logic` whose operator is `.EQN.`/`.NEN.`, which
// request that the data item be converted to numeric before comparison.  When
// set, identifiers are emitted wrapped in as.numeric().
int curNumeric=0;
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
  } else if (!strcmp("char_t1", name) ||
             !strcmp("char_t2", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    sAppend(&curLine, "%s", v);
    return;
  } else if (!strcmp("word_value", name)) {
    // unquoted non-numeric value; NONMEM compares it as a character string
    // (quotes cannot occur in it; backslashes are escaped for R's parser)
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    sAppendN(&curLine, "'", 1);
    for (char *c = v; *c != 0; c++) {
      if (*c == '\\') sAppendN(&curLine, "\\\\", 2);
      else sAppend(&curLine, "%c", *c);
    }
    sAppendN(&curLine, "'", 1);
    return;
  } else if (!strcmp("format_statement", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    nonmem2rxPushDataOption("format", v, "", "");
    return;
  } else if (!strcmp("null_t1", name) ||
             !strcmp("null_t2", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    v++;
    v[strlen(v)-1] = 0;
    nonmem2rxPushDataOption("null", v, "", "");
    return;
  } else if (!strcmp("null_t3", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    nonmem2rxPushDataOption("null", v, "", "");
    return;
  } else if (!strcmp("records_label_statement", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxPushDataOption("recordsLabel", v, "", "");
    return;
  } else if (!strcmp("last20_statement", name) ||
             !strcmp("misdat_statement", name) ||
             !strcmp("repl_statement", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    char *opt = "repl";
    if (name[0] == 'l') opt = "last20";
    else if (name[0] == 'm') opt = "misdat";
    nonmem2rxPushDataOption(opt, v, "", "");
    return;
  } else if (!strcmp("noopen_statement", name)) {
    nonmem2rxPushDataOption("noopen", "", "", "");
    return;
  } else if (!strcmp("pred_ignore_data_statement", name)) {
    nonmem2rxPushDataOption("predIgnoreData", "", "", "");
    return;
  } else if (!strcmp("translate_item", name)) {
    // TRANSLATE=(TIME/F[/D], II/F[/D]): label / factor [/ digits]
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *item = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 2);
    char *factor = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    char *digits = "";
    xpn = d_get_child(pn, 3);
    if (xpn != NULL && d_get_number_of_children(xpn) > 0) {
      // optional ('/' translate_digits) group
      D_ParseNode *dpn = d_get_child(d_get_child(xpn, 0), 1);
      digits = (char*)rc_dup_str(dpn->start_loc.s, dpn->end);
    }
    nonmem2rxPushDataOption("translate", item, factor, digits);
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
  } else if (!strcmp("nen_expression_nm", name)) {
    sAppendN(&curLine, " != ", 4);
    return;
  } else if (!strcmp("eqn_expression_nm", name)) {
    sAppendN(&curLine, " == ", 4);
    return ;
  } else if (!strcmp("simple_logic", name)) {
    // Pre-scan the operator (logic_compare -> child 0) before recursing into
    // children, since the LHS identifier is visited first.  `.EQN.`/`.NEN.`
    // require numeric coercion of the data item(s).
    curNumeric = 0;
    if (nch > 1) {
      D_ParseNode *cmp = d_get_child(pn, 1);
      if (cmp != NULL && d_get_number_of_children(cmp) > 0) {
        D_ParseNode *op = d_get_child(cmp, 0);
        char *opn = (char*)pt.symbols[op->symbol].name;
        if (!strcmp("eqn_expression_nm", opn) ||
            !strcmp("nen_expression_nm", opn)) {
          curNumeric = 1;
        }
      }
    }
  } else if (!strcmp("identifier_nm", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    if (curNumeric) {
      sAppend(&curLine, "as.numeric(.data$%s)", v);
    } else {
      sAppend(&curLine, ".data$%s", v);
    }
  } else if (!strcmp("logic_constant", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    sAppend(&curLine, "%s", v);
  } else if (!strcmp("ignore_statement", name)) {
    ignoreAcceptFlag = 2;
  } else if (!strcmp("accept_statement", name)) {
    ignoreAcceptFlag = 1;
  } else if (!strcmp("ignore1_statement", name) ||
             !strcmp("ignore1b_statement", name)) {
    D_ParseNode *xpn = d_get_child(pn, name[7] == 'b' ? 1 : 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxPushDataCond(v);
    return;
  } else if (!strcmp("ignore1a_statement", name)) {
    D_ParseNode *xpn = d_get_child(pn, 3);
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
    curNumeric = 0;
  }
}

void trans_data(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxData, sizeof(D_ParseNode_User));
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
  /* TODO(long-term): switch to udparse() once dparser-R ships that symbol
   * to CRAN.  udparse() accepts an unsigned int for buf_len, eliminating
   * the silent (int)strlen truncation on inputs >= INT_MAX bytes.
   * Track at https://github.com/nlmixr2/dparser-R */
  _pn= dparse(curP, gBuf, (int)strlen(gBuf));
  if (!_pn || curP->syntax_errors) {
    //rx_syntax_error = 1;
  } else {
    wprint_parsetree_data(parser_tables_nonmem2rxData, _pn, 0, wprint_node_data, NULL);
  }
  finalizeSyntaxError();
}

SEXP _nonmem2rx_trans_data(SEXP in) {
  sClear(&curLine);
  ignoreAcceptFlag=0;
  curNumeric=0;
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
