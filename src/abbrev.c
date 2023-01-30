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
#include "strncmpi.h"

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

void wprint_node_abbrev(int depth, char *name, char *value, void *client_data)  {}

extern char * rc_dup_str(const char *s, const char *e);

SEXP nonmem2rxPushModelLine(const char *item1);

void pushModel() {
  nonmem2rxPushModelLine(curLine.s);
  sClear(&curLine);
}

int abbrev_function(char *name, int i, D_ParseNode *pn) {
  if (i == 1 && !nmrxstrcmpi("LOG", name)) {
    sAppendN(&curLine, "log", 3);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("LOG10", name)) {
    sAppendN(&curLine, "log10", 5);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("EXP", name)) {
    sAppendN(&curLine, "exp", 3);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("SQRT", name)) {
    sAppendN(&curLine, "sqrt", 4);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("SIN", name)) {
    sAppendN(&curLine, "sin", 3);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("COS", name)) {
    sAppendN(&curLine, "cos", 3);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("ABS", name)) {
    sAppendN(&curLine, "abs", 3);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("TAN", name)) {
    sAppendN(&curLine, "tan", 3);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("ASIN", name)) {
    sAppendN(&curLine, "asin", 4);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("ACOS", name)) {
    sAppendN(&curLine, "acos", 4);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("ATAN", name)) {
    sAppendN(&curLine, "atan", 4);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("ATAN", name)) {
    sAppendN(&curLine, "atan", 4);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("MIN", name)) {
    sAppendN(&curLine, "min", 3);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("MAX", name)) {
    sAppendN(&curLine, "max", 3);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("PHI", name)) {
    sAppendN(&curLine, "phi", 3);
    return 1;
  } else if (i == 1 && !nmrxstrcmpi("GAMLN", name)) {
    sAppendN(&curLine, "lgamma", 6);
    return 1;
  } else if (!nmrxstrcmpi("mod", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "'MOD' function not supported in translation");
  } else if (!nmrxstrcmpi("int", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "'INT' function not supported in translation");
  } 
  return 0;
}

int abbrev_if_while_clause(char *name, int i, D_ParseNode *pn) {
  if (!strcmp("ifthen", name)) {
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
    return 0;
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
    return 0;
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
    return 0;
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
    return 0;
  }
  return 0;
}

int abbrev_unsupported_lines(char *name, int i, D_ParseNode *pn) {
  if (!strcmp("exit_line", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "Verbatim code is not supported in translation");
  } else if (!strcmp("exit_line", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "'EXIT # #' statements not supported in translation");
  } else if (!strcmp("ifexit", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "'IF () EXIT # #' statements not supported in translation");
  } else if (!strcmp("comresn1", name)) {
    Rf_warning("'COMRES = -1' ignored");
  } else if (!strcmp("callfl", name)) {
    Rf_warning("'CALLFL = ' ignored");
    return 1;
  } else if (!strcmp("callpassmode", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "'CALL PASS(MODE)' statements not supported in translation");
  } else if (!strcmp("callsupp", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "'CALL SUPP(# , #)' statements not supported in translation");
  } else if (!strcmp("callrandom", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "'CALL RANDOM()' statements not supported in translation");
  } else if (!strcmp("dt", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "DT(#) not supported in translation");
  } else if (!strcmp("mtime", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "MTIME(#) not supported in translation");
  } else if (!strcmp("mnext", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "MNEXT(#) not supported in translation");
  } else if (!strcmp("mpast", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "MPAST(#) not supported in translation");
  } else if (!strcmp("mixp", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "MIXP(#) not supported in translation");
  } else if (!strcmp("com", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "COM(#) not supported in translation");
  }
  return 0;
}

int abbrev_cmt_ddt_related(char *name, int i, D_ParseNode *pn) {
  if (!strcmp("derivative", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 2);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppend(&curLine, "d/dt(a%s) <- ", v);
      return 1;
    } else if (i == 1 || i == 2 || i == 3 || i == 4) {
      return 1;
    }
    return 0;
  } else if (!strcmp("da", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "DA(#, #) not supported in translation");
  } else if (!strcmp("dp", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "DP(#, #) not supported in translation");
  }
  return 0;
}

int abbrev_cmt_properties(char *name, int i, D_ParseNode *pn) {
  if (!strcmp("ini", name)) {
    if (i ==0) {
      D_ParseNode *xpn = d_get_child(pn, 2);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      // a1(0) <- ....
      sAppend(&curLine, "a%s(0) <- ", v);
      return 1;
    } else if (i == 1 || i == 2 || i == 3 || i == 4) {
      return 1;
    }
    return 0;
  } else if (!strcmp("fbio", name)) {
    // would have to parse what the output compartment is....
    // f0 and FO default to absorption lag parameters if they are not in abbreviated code
    // for the translation you are out of luck.
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (v[1] == 'O' || v[1] == '0') {
        parseFree(0);
        Rf_errorcall(R_NilValue, "F0/FO is not supported in translation");
      }
      // f(a1) <- ....
      sAppend(&curLine, "f(a%s) <- ", v + 1);
      return 1;
    } else if (i == 1) {
      return 1;
    }
    return 0;
  } else if (!strcmp("alag", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppend(&curLine, "alag(a%s) <- ", v + 4);
      return 1;
    } else if (i == 1) {
      return 1;
    }
    return 0;
  } else if (!strcmp("rate", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppend(&curLine, "rate(a%s) <- ", v + 1);
      return 1;
    } else if (i == 1) {
      return 1;
    }
    return 0;
  } else if (!strcmp("dur", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppend(&curLine, "dur(a%s) <- ", v + 1);
      return 1;
    } else if (i == 1) {
      return 1;
    }
    return 0;
  } else if (!strcmp("scale", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (v[1] == 'O' || v[1] == '0') {
        parseFree(0);
        Rf_errorcall(R_NilValue, "S0/SO is not supported in translation");
      }
      if (v[1] == 'C') {
        sAppendN(&curLine, "scalec <- ", 10);
        return 1;
      }
      // scale# <- ....
      sAppend(&curLine, "scale%s <- ", v + 1);
      return 1;
    } else if (i == 1) {
      return 1;
    }
    return 0;
  }
  return 0;
}

int abbrev_logic_operators(const char *name) {
  if (!strcmp("le_expression_nm", name)) {
    sAppendN(&curLine, " <= ", 4);
    return 1;
  } else if (!strcmp("ge_expression_nm", name)) {
    sAppendN(&curLine, " >= ", 4);
    return 1;
  } else if (!strcmp("gt_expression_nm", name)) {
    sAppendN(&curLine, " > ", 3);
    return 1;
  } else if (!strcmp("lt_expression_nm", name)) {
    sAppendN(&curLine, " < ", 3);
    return 1;
  } else if (!strcmp("neq_expression_nm", name)) {
    sAppendN(&curLine, " != ", 4);
    return 1;
  } else if (!strcmp("eq_expression_nm", name)) {
    sAppendN(&curLine, " == ", 4);
    return 1;
  } else if (!strcmp("and_expression_nm", name)) {
    sAppendN(&curLine, " && ", 4);
    return 1;
  } else if (!strcmp("or_expression_nm", name)) {
    sAppendN(&curLine, " || ", 4);
    return 1;
  }
  return 0;
}

int abbrev_operators(const char *name) {
  if (!strcmp("(", name) ||
      !strcmp(")", name) ||
      !strcmp("*", name) ||
      !strcmp("/", name) ||
      !strcmp("+", name) ||
      !strcmp("-", name)) {
    sAppend(&curLine, "%s", name);
    return 1;
  }
  if (!strcmp("**", name)) {
    sAppendN(&curLine, "^", 1);
    return 1;
  }
  if (!strcmp("=", name)) {
    sAppendN(&curLine, "<-", 2);
    return 1;
  }
  return 0;
}

// nonmem variables
// NEWIND
// COMRES = -1 unsupported
// PCMT() not supported
// MIXNUM
// MIXEST
// ICALL
// COMACT
// COMSAV
// COM(n)
// A#
// C#
// verbatim code

void wprint_parsetree_abbrev(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  // These don't have any recursive paring involved and can be handled here
  if (abbrev_logic_operators(name) ||
      abbrev_operators(name)) {
    return;
  } else if (!strcmp("else", name)) {
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
      if (abbrev_if_while_clause(name, i, pn) ||
          abbrev_cmt_properties(name, i, pn) ||
          abbrev_cmt_ddt_related(name, i, pn) ||
          abbrev_function(name, i, pn) ||
          abbrev_unsupported_lines(name, i ,pn)) {
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
