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
#define max2( a , b )  ( (a) > (b) ? (a) : (b) )

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
const char *abbrevPrefix;

// from mkdparse_tree.h
typedef void (print_node_fn_t)(int depth, char *token_name, char *token_value, void *client_data);

void wprint_node_abbrev(int depth, char *name, char *value, void *client_data)  {}

extern char * rc_dup_str(const char *s, const char *e);

SEXP nonmem2rxPushModelLine(const char *item1);
SEXP nonmem2rxPushScale(int scale);

int maxA = 0;

void pushModel() {
  if (curLine.s == NULL) return;
  if (curLine.s[0] == 0) return;
  nonmem2rxPushModelLine(curLine.s);
  sClear(&curLine);
}

void writeAinfo(const char *v);

int abbrevLin = 0;

SEXP nonmem2rxGetScale(int scale);

int abbrev_identifier_or_constant(char *name, int i, D_ParseNode *pn) {
  if (!strcmp("fbioi", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppendN(&curLine, "f(", 2);
    writeAinfo(v + 1);
    sAppendN(&curLine, ")", 1);
    return 1;
  } else if (!strcmp("alagi", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppendN(&curLine, "alag(", 5);
    writeAinfo(v + 1);
    sAppendN(&curLine, ")", 1);
    return 1;
  } else if (!strcmp("ratei", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppendN(&curLine, "rate(", 5);
    writeAinfo(v + 1);
    sAppendN(&curLine, ")", 1);
    return 1;
  } else if (!strcmp("duri", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppendN(&curLine, "dur(", 4);
    writeAinfo(v + 1);
    sAppendN(&curLine, ")", 1);
    return 1;
  } else if (!strcmp("scalei", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppendN(&curLine, "scale", 5);
    if (v[1] == 'O' || v[1] == '0') {
      sAppendN(&curLine, "0", 1);
      return 1;
    }
    if (i == 0 && v[1] == 'C') {
      if (abbrevLin == 1) {
        sAppendN(&curLine, "1", 1);
        return 1;
      } else if (abbrevLin == 2) {
        sAppendN(&curLine, "2", 1);
        return 1;
      }
      sAppendN(&curLine, "c", 1);
      return 1;
    }
    sAppend(&curLine, "%s", v+1);
    return 1;
  } else if (!strcmp("avar", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "'A#' NONMEM reserved variable is not translated");
  } else if (!strcmp("cvar", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "'C#' NONMEM reserved variable is not translated");
  } else if (!strcmp("constant", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppend(&curLine, "%s", v);
    return 1;
  } else if (!strcmp("identifier", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (!nmrxstrcmpi("t", v)) {
      sAppendN(&curLine, "t", 1);
      return 1;
    } else if (!nmrxstrcmpi("time", v)) {
      sAppendN(&curLine, "t", 1);
      return 1;
    } else if (!nmrxstrcmpi("newind", v)) {
      sAppendN(&curLine, "newind", 6);
      return 1;
    } else if (!nmrxstrcmpi("MIXNUM", v)) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "'MIXNUM' NONMEM reserved variable is not translated");
    } else if (!nmrxstrcmpi("MIXEST", v)) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "'MIXEST' NONMEM reserved variable is not translated");
    } else if (!nmrxstrcmpi("ICALL", v)) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "'ICALL' NONMEM reserved variable is not translated");
    } else if (!nmrxstrcmpi("COMACT", v)) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "'COMACT' NONMEM reserved variable is not translated");
    } else if (!nmrxstrcmpi("COMSAV", v)) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "'COMSAV' NONMEM reserved variable is not translated");
    } else if (!nmrxstrcmpi("tscale", v)) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "'TSCALE' NONMEM reserved variable is not translated");
    }  else if (!nmrxstrcmpi("xscale", v)) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "'XSCALE' NONMEM reserved variable is not translated");
    }
    // use only upper case in output since NONMEM is case insensitive and rxode2 is sensitive.
    int i = 0;
    while(v[i] != 0) {
      v[i] = toupper(v[i]);
      i++;
    }
    sAppend(&curLine, v);
    return 1;
  }
  return 0;
}

void writeAinfo(const char *v) {
  // abbrevLin = 0 is ode
  // abbrevLin = 1 is linCmt() without ka
  // abbrevLin = 2 is linCmt() with ka
  //
  // $error block abbrevLin
  // abbrevLin = 3 is ode in  block
  // abbrevLin = 4 is linCmt() without ka
  // abbrevLin = 5 is linCmt() with ka
  if (abbrevLin == 0) {
    maxA = max2(maxA, atoi(v));
    sAppend(&curLine, "a%s", v);
    return;
  }
  int cur = atoi(v);
  if (abbrevLin == 3) {
    sAppend(&curLine, "a%s%s", v, CHAR(STRING_ELT(nonmem2rxGetScale(cur), 0)));
    return;
  }
  if (abbrevLin == 2 && cur == 1) {
    sAppendN(&curLine, "depot", 5);
    return;
  }
  if (abbrevLin == 5 && cur == 1) {
    sAppend(&curLine, "dose(depot)*exp(-KA*tad(depot))%s", CHAR(STRING_ELT(nonmem2rxGetScale(cur), 0)));
    return;
  }
  if ((abbrevLin == 1 && cur == 1) || (abbrevLin == 2 && cur == 2)) {
    sAppendN(&curLine, "central", 7);
    return;
  }
  if ((abbrevLin == 4 && cur == 1) || (abbrevLin == 5 && cur == 2)) {
    sAppend(&curLine, "rxLinCmt1%s", CHAR(STRING_ELT(nonmem2rxGetScale(cur), 0)));
    return;
  }
  parseFree(0);
  Rf_errorcall(R_NilValue, "can only request depot and central compartments for solved systems in rxode2 translations");
}

int abbrev_params(char *name, int i,  D_ParseNode *pn) {
  if (!strcmp("theta", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppend(&curLine, "theta%s", v);
    }
    return 1;
  } else if (!strcmp("eta", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppend(&curLine, "eta%s", v);
    }
    return 1;
  } else if (!strcmp("eps", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppend(&curLine, "eps%s", v);
    }
    return 1;
  } else if (!strcmp("err", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      // since parser translates  $sigma
      sAppend(&curLine, "eps%s", v);
    }
    return 1;
  } else if (!strcmp("amt", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      // since parser translates  $sigma
      writeAinfo(v);
    }
    return 1;
  }
  return 0;
}

int abbrev_function(char *name, int i, D_ParseNode *pn) {
  if (!strcmp("function", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (v[0] == 'D' || v[0] == 'd') v++;
      if (!nmrxstrcmpi("LOG", v)) {
        sAppendN(&curLine, "log", 3);
        return 1;
      } else if (!nmrxstrcmpi("LOG10", v)) {
        sAppendN(&curLine, "log10", 5);
        return 1;
      } else if (!nmrxstrcmpi("EXP", v)) {
        sAppendN(&curLine, "exp", 3);
        return 1;
      } else if (!nmrxstrcmpi("SQRT", v)) {
        sAppendN(&curLine, "sqrt", 4);
        return 1;
      } else if (!nmrxstrcmpi("SIN", v)) {
        sAppendN(&curLine, "sin", 3);
        return 1;
      } else if (!nmrxstrcmpi("COS", v)) {
        sAppendN(&curLine, "cos", 3);
        return 1;
      } else if (!nmrxstrcmpi("ABS", v)) {
        sAppendN(&curLine, "abs", 3);
        return 1;
      } else if (!nmrxstrcmpi("TAN", v)) {
        sAppendN(&curLine, "tan", 3);
        return 1;
      } else if (!nmrxstrcmpi("ASIN", v)) {
        sAppendN(&curLine, "asin", 4);
        return 1;
      } else if (!nmrxstrcmpi("ACOS", v)) {
        sAppendN(&curLine, "acos", 4);
        return 1;
      } else if (!nmrxstrcmpi("ATAN", v)) {
        sAppendN(&curLine, "atan", 4);
        return 1;
      } else if (!nmrxstrcmpi("ATAN", v)) {
        sAppendN(&curLine, "atan", 4);
        return 1;
      } else if (!nmrxstrcmpi("MIN", v)) {
        sAppendN(&curLine, "min", 3);
        return 1;
      } else if (!nmrxstrcmpi("MAX", v)) {
        sAppendN(&curLine, "max", 3);
        return 1;
      } else if (!nmrxstrcmpi("PHI", v)) {
        sAppendN(&curLine, "phi", 3);
        return 1;
      } else if (!nmrxstrcmpi("GAMLN", v)) {
        sAppendN(&curLine, "lgamma", 6);
        return 1;
      } else if (!nmrxstrcmpi("mod", v)) {
        parseFree(0);
        Rf_errorcall(R_NilValue, "'MOD' function not supported in translation");
      } else if (!nmrxstrcmpi("int", v)) {
        parseFree(0);
        Rf_errorcall(R_NilValue, "'INT' function not supported in translation");
      }
    }
    return 0;
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
      sAppendN(&curLine, ") ", 2);
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
int verbWarning = 0;
int abbrev_unsupported_lines(char *name, int i, D_ParseNode *pn) {
  if (!strcmp("verbatimCode", name)) {
    if (verbWarning == 0) {
      Rf_warning("Verbatim code is not supported in translation\nignored verbatim in %s", abbrevPrefix);
      verbWarning = 1;
    }
  } else if (!strcmp("exit_line", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "'EXIT # #' statements not supported in translation");
  } else if (!strcmp("ifexit", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "'IF () EXIT # #' statements not supported in translation");
  } else if (!strcmp("comresn1", name)) {
    if (i ==0) Rf_warning("'COMRES = -1' ignored");
  } else if (!strcmp("callfl", name)) {
    if (i == 1) Rf_warning("'CALLFL = ' ignored");
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
  } else if (!strcmp("pcmt", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "PCMT(#) not supported in translation");
  }
  return 0;
}

int abbrev_cmt_ddt_related(char *name, int i, D_ParseNode *pn) {
  if (!strcmp("derivative", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppend(&curLine, "d/dt(a%s) <- ", v);
      return 1;
    } else if (i == 1 || i == 2 || i == 3) {
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
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      // a1(0) <- ....
      writeAinfo(v);
      sAppendN(&curLine, "(0) <- ", 7);
      return 1;
    } else if (i == 1 || i == 2 || i == 3) {
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
      sAppendN(&curLine, "f(", 2);
      writeAinfo(v + 1);
      sAppendN(&curLine, ") <- ", 5);
      return 1;
    } else if (i == 1) {
      return 1;
    }
    return 0;
  } else if (!strcmp("alag", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppendN(&curLine, "alag(", 5);
      writeAinfo(v + 4);
      sAppendN(&curLine, ") <- ", 5);
      return 1;
    } else if (i == 1) {
      return 1;
    }
    return 0;
  } else if (!strcmp("rate", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppend(&curLine, "rate(", 5);
      writeAinfo(v + 1);
      sAppendN(&curLine, ") <- ", 5);
      return 1;
    } else if (i == 1) {
      return 1;
    }
    return 0;
  } else if (!strcmp("dur", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppendN(&curLine, "dur(",4);
      writeAinfo(v + 1);
      sAppendN(&curLine, ") <- ", 5);
      return 1;
    } else if (i == 1) {
      return 1;
    }
    return 0;
  } else if (!strcmp("scale", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v[1] == 'O' || v[1] == '0') {
      if (i == 0) {
        sAppendN(&curLine, "scale0 <- ", 10);
        nonmem2rxPushScale(0);
        return 1;
      }
      if (i == 1) return 1;
    }
    int scaleCmt = NA_INTEGER;
    if (i == 0 && v[1] == 'C') {
      if (abbrevLin == 1) {
        scaleCmt = 1;
      } else if (abbrevLin == 2) {
        scaleCmt = 2;
      } else {
        Rf_warning("translation cannot determine 'SC', using as constant");
        sAppendN(&curLine, "scalec <- ", 10);
        return 1;
      }
    } else {
      scaleCmt = atoi(v + 1);
    }
    if (abbrevLin == 1) {
      if (scaleCmt > 1) {
        if (i == 0) Rf_warning("scale%d could be meaningless with this linCmt() model translation");
      }
    } else if (abbrevLin == 2) {
      if (scaleCmt > 2) {
        if (i == 0) Rf_warning("scale%d could be meaningless with this linCmt() model translation");
      }
    }
    if (i == 0) {
      // scale# <- ....
      nonmem2rxPushScale(scaleCmt);
      sAppend(&curLine, "scale%d <- ", scaleCmt);
      return 1;
    }
    if (i == 1) return 1;
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
      !strcmp(")", name)) {
    sAppend(&curLine, "%s", name);
    return 1;
  } else if (!strcmp("*", name) ||
             !strcmp("/", name) ||
             !strcmp("+", name) ||
             !strcmp("-", name)) {
    sAppend(&curLine, " %s ", name);
    return 1;
  } else if (!strcmp(",", name)) {
    sAppendN(&curLine, ", ", 2);
  }
  if (!strcmp("**", name)) {
    sAppendN(&curLine, "^", 1);
    return 1;
  }
  if (!strcmp("=", name)) {
    sAppendN(&curLine, " <- ", 4);
    return 1;
  }
  return 0;
}

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
  } else if (!strcmp("callsimeta", name)) {
    sAppendN(&curLine,"simeta()", 8);
    pushModel();
    return;
  } else if (!strcmp("callsimeps", name)) {
    sAppendN(&curLine,"simeps()", 8);
    pushModel();
    return;
  } else if (!strcmp("callgeteta", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "'CALL GETETA(ETA)' not supported in translation");
  }
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      if (abbrev_identifier_or_constant(name, i, pn) ||
          abbrev_params(name, i,  pn) ||
          abbrev_if_while_clause(name, i, pn) ||
          abbrev_cmt_ddt_related(name, i, pn) ||
          abbrev_cmt_properties(name, i, pn) ||
          abbrev_function(name, i, pn) ||
          abbrev_unsupported_lines(name, i ,pn)) {
        continue;
      }
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_abbrev(pt, xpn, depth, fn, client_data);
    }
  }
  if (!strcmp("assignment", name) ||
      !strcmp("if1", name) ||
      !strcmp("derivative", name) ||
      !strcmp("ini", name) ||
      !strcmp("fbio", name) ||
      !strcmp("alag", name) ||
      !strcmp("rate", name) ||
      !strcmp("dur", name) ||
      !strcmp("scale", name)) {
    pushModel();
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
    Rf_errorcall(R_NilValue, "parsing error with abbreviated code in %s", abbrevPrefix);
  } else {
    wprint_parsetree_abbrev(parser_tables_nonmem2rxAbbrev, _pn, 0, wprint_node_abbrev, NULL);
  }
}

SEXP nonmem2rxSetMaxA(int maxa);

SEXP _nonmem2rx_trans_abbrev(SEXP in, SEXP prefix, SEXP abbrevLinSEXP) {
  sIni(&curLine);
  abbrevPrefix = (char*)rc_dup_str(R_CHAR(STRING_ELT(prefix, 0)), 0);
  abbrevLin = INTEGER(abbrevLinSEXP)[0];
  verbWarning = 0;
  maxA = 0;
  trans_abbrev(R_CHAR(STRING_ELT(in, 0)));
  nonmem2rxSetMaxA(maxA);
  parseFree(0);
  return R_NilValue;
}
