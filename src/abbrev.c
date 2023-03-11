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
#include "parseSyntaxErrors.h"

extern D_ParserTables parser_tables_nonmem2rxAbbrev;

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
extern sbuf curLine;
const char *abbrevPrefix;
const char *cmtInfoStr;

// from mkdparse_tree.h
typedef void (print_node_fn_t)(int depth, char *token_name, char *token_value, void *client_data);

void wprint_node_abbrev(int depth, char *name, char *value, void *client_data)  {}

extern char * rc_dup_str(const char *s, const char *e);

SEXP nonmem2rxPushModelLine(const char *item1);
SEXP nonmem2rxPushScale(int scale);
SEXP nonmem2rxPushObservedDadt(int a);
SEXP nonmem2rxPushObservedThetaObs(int a);
SEXP nonmem2rxPushObservedEtaObs(int a);
SEXP nonmem2rxGetModelNum(const char *v);
SEXP nonmem2rxGetThetaNum(const char *v);
SEXP nonmem2rxGetEtaNum(const char *v);
SEXP nonmem2rxGetEpsNum(const char *v);

int maxA = 0,
  definingScale = 0;

void pushModel(void) {
  if (curLine.s == NULL) return;
  if (curLine.s[0] == 0) return;
  nonmem2rxPushModelLine(curLine.s);
  sClear(&curLine);
  definingScale = 0;
}

void writeAinfo(const char *v);

int abbrevLin = 0;

SEXP nonmem2rxGetScale(int scale);

int evidWarning = 0;
int idWarning = 0;
int icallWarning = 0;
int irepWarning = 0;
int simWarning=0;
int ipredSimWarning = 0;

SEXP nonmem2rxPushTheta(const char *ini, const char *comment, const char *label);
SEXP nonmem2rxNeedNmevid(void);
SEXP nonmem2rxNeedNmid(void);
SEXP nonmem2rxNeedNmid(void);
SEXP nonmem2rxNeedYtype(void);
SEXP nonmem2rxPushScaleVolume(int scale, const char *v);
SEXP nonmem2rxHasVolume(const char *v);
SEXP nonmem2rxNeedExit(void);

int abbrev_identifier_or_constant(char *name, int i, D_ParseNode *pn) {
  if (!strcmp("fbioi", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppendN(&curLine, "rxf.", 4);
    writeAinfo(v + 1);
    sAppendN(&curLine, ".", 1);
    return 1;
  } else if (!strcmp("alagi", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppendN(&curLine, "rxalag.", 7);
    writeAinfo(v + 4);
    sAppendN(&curLine, ".", 1);
    return 1;
  } else if (!strcmp("ratei", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppendN(&curLine, "rxrate.", 7);
    writeAinfo(v + 1);
    sAppendN(&curLine, ".", 1);
    return 1;
  } else if (!strcmp("duri", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppendN(&curLine, "rxdur.", 6);
    writeAinfo(v + 1);
    sAppendN(&curLine, ".", 1);
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
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "'A#' NONMEM reserved variable is not translated");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
    return 1;
  } else if (!strcmp("cvar", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "'C#' NONMEM reserved variable is not translated");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
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
      sClear(&sbTransErr);
      sAppend(&sbTransErr, "'MIXNUM' NONMEM reserved variable is not translated");
      updateSyntaxCol();
      trans_syntax_error_report_fn0(sbTransErr.s);
      finalizeSyntaxError();
    } else if (!nmrxstrcmpi("MIXEST", v)) {
      sClear(&sbTransErr);
      sAppend(&sbTransErr, "'MIXEST' NONMEM reserved variable is not translated");
      updateSyntaxCol();
      trans_syntax_error_report_fn0(sbTransErr.s);
      finalizeSyntaxError();
    } else if (!nmrxstrcmpi("ICALL", v)) {
      if (icallWarning == 0) {
        nonmem2rxPushTheta("icall <- fix(1)", "icall set to 1 for non-simulation",
                           NULL);
        Rf_warning("icall found and added as rxode2 parameter to model; set to 4 to activate simulation code");
        icallWarning=1;
      }
      sAppendN(&curLine, "icall", 5);
      return 1;
    } else if (!nmrxstrcmpi("IREP", v)) {
       if (irepWarning == 0) {
         nonmem2rxPushTheta("irep <- fix(0)", "irep set to 0 (not supported)",
                            NULL);
        Rf_warning("irep found and added as rxode2 parameter to model (=0); 'sim.id' is added to all multi-study simulations and currently cannot be accessed in the simulation code");
        irepWarning=1;
      }
       sAppendN(&curLine, "irep", 4);
      return 1;
    } else if (!nmrxstrcmpi("COMACT", v)) {
      sClear(&sbTransErr);
      sAppend(&sbTransErr, "'COMACT' NONMEM reserved variable is not translated");
      updateSyntaxCol();
      trans_syntax_error_report_fn0(sbTransErr.s);
      finalizeSyntaxError();
    } else if (!nmrxstrcmpi("COMSAV", v)) {
      sClear(&sbTransErr);
      sAppend(&sbTransErr, "'COMSAV' NONMEM reserved variable is not translated");
      updateSyntaxCol();
      trans_syntax_error_report_fn0(sbTransErr.s);
      finalizeSyntaxError();
    } else if (!nmrxstrcmpi("tscale", v)) {
      sClear(&sbTransErr);
      sAppend(&sbTransErr, "'TSCALE' NONMEM reserved variable is not translated");
      updateSyntaxCol();
      trans_syntax_error_report_fn0(sbTransErr.s);
      finalizeSyntaxError();
    } else if (!nmrxstrcmpi("xscale", v)) {
      sClear(&sbTransErr);
      sAppend(&sbTransErr, "'XSCALE' NONMEM reserved variable is not translated");
      updateSyntaxCol();
      trans_syntax_error_report_fn0(sbTransErr.s);
      finalizeSyntaxError();
    } else if (!nmrxstrcmpi("id", v)) {
      if (idWarning == 0) {
        Rf_warning("'id' variable is supported differently rxode2, renamed to 'nmid', rename/copy in your data too");
        idWarning = 1;
        nonmem2rxNeedNmid();
      }
      sAppendN(&curLine, "nmid", 4);
      return 1;
    } else if (!nmrxstrcmpi("evid", v)) {
      if (evidWarning == 0) {
        Rf_warning("'evid' variable is not supported in rxode2, renamed to 'nmevid', rename/copy in your data too");
        evidWarning = 1;
        nonmem2rxNeedNmevid();
      }
      sAppendN(&curLine, "nmevid", 6);
      return 1;
    } else if (!nmrxstrcmpi("amt", v)) {
      // make sure amt is lower case; works around a parser bug in rxode2parse
      sAppendN(&curLine, "amt", 3);
      return 1;
    } else if (!nmrxstrcmpi("ytype", v)) {
      nonmem2rxNeedYtype();
      sAppendN(&curLine, "nmytype", 7);
      return 1;
    } else if (!nmrxstrcmpi("sim", v)) {
      if (simWarning == 0) {
        Rf_warning("'sim' variable is used in rxode2 simulations, renamed to 'nmsim'");
        simWarning = 1;
      }
      sAppendN(&curLine, "nmsim", 5);
      return 1;
    } else if (!nmrxstrcmpi("ipredSim", v)) {
      if (ipredSimWarning == 0) {
        Rf_warning("'ipredSim' variable is used in rxode2 simulations, renamed to 'nmipredsim'");
        ipredSimWarning = 1;
      }
      sAppendN(&curLine, "nmipredsim", 10);
      return 1;
    }
    // use only upper case in output since NONMEM is case insensitive and rxode2 is sensitive.
    int i = 0;
    while(v[i] != 0) {
      v[i] = toupper(v[i]);
      i++;
    }
    int hasV = v[0] == 'V';
    if (hasV) {
      nonmem2rxHasVolume(v);
    }
    if (definingScale && hasV) {
      nonmem2rxPushScaleVolume(definingScale-1, v);
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
    int num = atoi(v);
    maxA = max2(maxA, num);
    sAppend(&curLine, "rxddta%s", v);
    return;
  }
  int cur = atoi(v);
  if (abbrevLin == 3) {
    maxA = max2(maxA, cur);
    sAppend(&curLine, "rxddta%s%s", v, CHAR(STRING_ELT(nonmem2rxGetScale(cur), 0)));
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
  sClear(&sbTransErr);
  sAppend(&sbTransErr, "can only request depot and central compartments for solved systems in rxode2 translations");
  updateSyntaxCol();
  trans_syntax_error_report_fn0(sbTransErr.s);
  finalizeSyntaxError();
}

int abbrevParamTheta(char *name, int i,  D_ParseNode *pn) {
  int needName=0;
  if (!strcmp("theta", name) ||
      (needName = !strcmp("thetaI", name))) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (needName) {
        SEXP namePar = PROTECT(nonmem2rxGetThetaNum(v));
        v  = (char*)rc_dup_str(CHAR(STRING_ELT(namePar, 0)), 0);
        UNPROTECT(1);
      }
      int num = atoi(v);
      nonmem2rxPushObservedThetaObs(num);
      sAppend(&curLine, "theta%d", num);
    }
    return 1;
  }
  return 0;
}

int abbrevParamEta(char *name, int i,  D_ParseNode *pn) {
  int needName=0;
  if (!strcmp("eta", name) ||
      (needName = !strcmp("etaI", name))) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (needName) {
        SEXP namePar = PROTECT(nonmem2rxGetEtaNum(v));
        v  = (char*)rc_dup_str(CHAR(STRING_ELT(namePar, 0)), 0);
        UNPROTECT(1);
      }
      int num = atoi(v);
      nonmem2rxPushObservedEtaObs(num);
      sAppend(&curLine, "eta%d", num);
    }
    return 1;
  }
  return 0;
}
int abbrevParamEps(char *name, int i,  D_ParseNode *pn) {
  int needName = 0;
  if (!strcmp("eps", name) ||
             (needName = !strcmp("epsI", name))) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (needName) {
        SEXP namePar = PROTECT(nonmem2rxGetEpsNum(v));
        v  = (char*)rc_dup_str(CHAR(STRING_ELT(namePar, 0)), 0);
        UNPROTECT(1);
      }
      sAppend(&curLine, "eps%s", v);
    }
    return 1;
  }
  return 0;
}

int abbrevParamErr(char *name, int i,  D_ParseNode *pn) {
  int needName = 0;
  if (!strcmp("err", name) ||
      (needName = !strcmp("errI", name))) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (needName) {
        SEXP namePar = PROTECT(nonmem2rxGetEpsNum(v));
        v  = (char*)rc_dup_str(CHAR(STRING_ELT(namePar, 0)), 0);
        UNPROTECT(1);
      }
      // since parser translates  $sigma
      sAppend(&curLine, "eps%s", v);
    }
    return 1;
  }
  return 0;
}

int abbrevParamAmt (char *name, int i,  D_ParseNode *pn) {
  int needName = 0;
  if (!strcmp("amt", name) ||
             (needName = !strcmp("amtI", name))) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (needName) {
        SEXP namePar = PROTECT(nonmem2rxGetModelNum(v));
        v  = (char*)rc_dup_str(CHAR(STRING_ELT(namePar, 0)), 0);
        UNPROTECT(1);
      }
      // since parser translates  $sigma
      writeAinfo(v);
    }
    return 1;
  }
  return 0;
}

int abbrev_params(char *name, int i,  D_ParseNode *pn) {
  return abbrevParamTheta(name, i,  pn) ||
    abbrevParamEta(name, i,  pn) ||
    abbrevParamEps(name, i,  pn) ||
    abbrevParamErr(name, i,  pn) ||
    abbrevParamAmt(name, i,  pn);
}

int abbrev_function(char *name, int i, D_ParseNode *pn) {
  if (!strcmp("function", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (v[0] == 'D' || v[0] == 'd') v++;
      if (!nmrxstrcmpi("LOG(", v)) {
        sAppendN(&curLine, "log(", 4);
        return 1;
      } else if (!nmrxstrcmpi("LOG10(", v)) {
        sAppendN(&curLine, "log10(", 6);
        return 1;
      } else if (!nmrxstrcmpi("EXP(", v)) {
        sAppendN(&curLine, "exp(", 4);
        return 1;
      } else if (!nmrxstrcmpi("SQRT(", v)) {
        sAppendN(&curLine, "sqrt(", 5);
        return 1;
      } else if (!nmrxstrcmpi("SIN(", v)) {
        sAppendN(&curLine, "sin(", 4);
        return 1;
      } else if (!nmrxstrcmpi("COS(", v)) {
        sAppendN(&curLine, "cos(", 4);
        return 1;
      } else if (!nmrxstrcmpi("ABS(", v)) {
        sAppendN(&curLine, "abs(", 4);
        return 1;
      } else if (!nmrxstrcmpi("TAN(", v)) {
        sAppendN(&curLine, "tan(", 4);
        return 1;
      } else if (!nmrxstrcmpi("ASIN(", v)) {
        sAppendN(&curLine, "asin(", 5);
        return 1;
      } else if (!nmrxstrcmpi("ACOS(", v)) {
        sAppendN(&curLine, "acos(", 5);
        return 1;
      } else if (!nmrxstrcmpi("ATAN(", v)) {
        sAppendN(&curLine, "atan(", 5);
        return 1;
      } else if (!nmrxstrcmpi("MIN(", v)) {
        sAppendN(&curLine, "min(", 4);
        return 1;
      } else if (!nmrxstrcmpi("MAX(", v)) {
        sAppendN(&curLine, "max(", 4);
        return 1;
      } else if (!nmrxstrcmpi("PHI(", v)) {
        sAppendN(&curLine, "phi(", 4);
        return 1;
      } else if (!nmrxstrcmpi("GAMLN(", v)) {
        sAppendN(&curLine, "lgamma(", 7);
        return 1;
      } else if (!nmrxstrcmpi("mod(", v)) {
        sClear(&sbTransErr);
        sAppend(&sbTransErr, "'MOD' function not supported in translation");
        updateSyntaxCol();
        trans_syntax_error_report_fn0(sbTransErr.s);
        finalizeSyntaxError();
      } else if (!nmrxstrcmpi("int(", v)) {
        sClear(&sbTransErr);
        sAppend(&sbTransErr, "'INT' function not supported in translation");
        updateSyntaxCol();
        trans_syntax_error_report_fn0(sbTransErr.s);
        finalizeSyntaxError();
      }
    }
    return 0;
  }
  return 0;
}

int abbrev_if1_clauses(char *name, int i, D_ParseNode *pn) {
  if (!strcmp("if1", name)) {
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
  } else if (!strcmp("if1other", name)) {
    if (i == 0) {
      sAppendN(&curLine, "if (", 4);
      return 1;
    } else if (i == 1) {
      return 1;
    } else if (i == 3) {
      sAppendN(&curLine, ") {", 3);
      pushModel();
      return 1;
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
  } else if (!strcmp("ifcallsimeta", name)) {
    if (i == 0) {
      sAppendN(&curLine, "if (", 4);
      return 1;
    } else if (i == 3) {
      sAppendN(&curLine, ") simeta()", 10);
      return 1;
    } else if (i != 2) {
      return 1;
    }
    return 0;
  } else if (!strcmp("ifcallsimeps", name)) {
    if (i == 0) {
      sAppendN(&curLine, "if (", 4);
      return 1;
    } else if (i == 3) {
      sAppendN(&curLine, ") simeps()", 10);
      return 1;
    } else if (i != 2) {
      return 1;
    }
    return 0;
  } else if (!strcmp("ifcallrandom", name)) {
    if (i == 0) {
      sAppendN(&curLine, "if (", 4);
      return 1;
    } else if (i == 3) {
      sAppendN(&curLine, ") R <- rxunif()", 15);
      return 1;
    } else if (i != 2) {
      return 1;
    }
    return 0;
  } else if (!strcmp("ifexit", name)) {
    if (i == 0) {
      sAppendN(&curLine, "if (", 4);
      return 1;
    } else if (i == 1 || i == 4 || i == 5 || i == 6) {
      return 1;
    } else if (i == 3) {
      D_ParseNode *xpn = d_get_child(pn, 5);
      char *v1 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      xpn = d_get_child(pn, 6);
      char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppend(&curLine, ") ierprdu <- 100000 * %s + %s", v1, v2);
      nonmem2rxNeedExit();
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

SEXP nonmem2rxPushSigmaEst(int x, int y);
SEXP nonmem2rxPushOmegaEst(int x, int y);

int verbWarning = 0;
int abbrev_unsupported_lines(char *name, int i, D_ParseNode *pn) {
  if (!strcmp("verbatimCode", name)) {
    if (verbWarning == 0) {
      Rf_warning("Verbatim code is not supported in translation\nignored verbatim in %s", abbrevPrefix);
      verbWarning = 1;
    }
    return 1;
  } else if (!strcmp("comresn1", name)) {
    if (i ==0) Rf_warning("'COMRES = -1' ignored");
  } else if (!strcmp("callfl", name)) {
    if (i == 1) Rf_warning("'CALLFL = ' ignored");
    return 1;
  } else if (!strcmp("call_protocol_phrase", name)) {
    if (i == 1) {
      char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
      Rf_warning("NONMEM call protocol phrase ignored\n  %s", v);
    }
    return 1; 
  } else if (!strcmp("callpassmode", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "'CALL PASS(MODE)' statements not supported in translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
  } else if (!strcmp("callsupp", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "'CALL SUPP(# , #)' statements not supported in translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
  } else if (!strcmp("dt", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "DT(#) not supported in translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
  } else if (!strcmp("mtime", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "MTIME(#) not supported in translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
  } else if (!strcmp("mnext", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "MNEXT(#) not supported in translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
  } else if (!strcmp("mpast", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "MPAST(#) not supported in translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
  } else if (!strcmp("mixp", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "MIXP(#) not supported in translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
  } else if (!strcmp("com", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "COM(#) not supported in translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
  } else if (!strcmp("pcmt", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "PCMT(#) not supported in translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
  } else if (!strcmp("sigma", name)) {
    if (i != 0) return 1;
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *v1 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 3);
    char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    //parseFree(0);
    int x = atoi(v1), y = atoi(v2);
    Rf_warning("SIGMA(%d, %d) does not have an equivalent rxode2/nlmixr2 code\nreplacing with a constant from the model translation\nthis will not be updated with simulations",
                 x, y);
    sAppend(&curLine, "sigma.%d.%d", x, y);
    nonmem2rxPushSigmaEst(x, y);
    return 0;
  } else if (!strcmp("omega", name)) {
    if (i != 0) return 1;
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *v1 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 3);
    char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    int x = atoi(v1), y = atoi(v2);
    Rf_warning("OMEGA(%d, %d) does not have an equivalent rxode2/nlmixr2 code\nreplacing with a constant from the model translation\nthis will not be updated with simulations",
                 x, y);
    sAppend(&curLine, "omega.%d.%d", x, y);
    nonmem2rxPushOmegaEst(x, y);
  }
  return 0;
}

int abbrev_cmt_ddt_related(char *name, int i, D_ParseNode *pn) {
  int needName = 0;
  if (!strcmp("derivative", name) ||
      (needName = !strcmp("derivativeI", name))) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (needName) {
        SEXP namePar = PROTECT(nonmem2rxGetModelNum(v));
        v  = (char*)rc_dup_str(CHAR(STRING_ELT(namePar, 0)), 0);
        UNPROTECT(1);
      }
      int cur = atoi(v);
      maxA = max2(maxA, cur);
      nonmem2rxPushObservedDadt(cur);
      sAppend(&curLine, "d/dt(rxddta%s) <- ", v);
      return 1;
    } else if (i == 1 || i == 2 || i == 3) {
      return 1;
    }
    return 0;
  } else if (!strcmp("da", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "DA(#, #) not supported in translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
  } else if (!strcmp("dp", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "DP(#, #) not supported in translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
  }
  return 0;
}

int abbrev_cmt_properties(char *name, int i, D_ParseNode *pn) {
  int needName = 0;
  if (!strcmp("ini", name) ||
      (needName = !strcmp("iniI", name))) {
    if (i ==0) {
      D_ParseNode *xpn = d_get_child(pn, 1);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (needName) {
        SEXP namePar = PROTECT(nonmem2rxGetModelNum(v));
        v  = (char*)rc_dup_str(CHAR(STRING_ELT(namePar, 0)), 0);
        UNPROTECT(1);
      }
      // a1(0) <- ....
      sAppendN(&curLine, "rxini.", 6);
      cmtInfoStr=v;
      writeAinfo(v);
      sAppendN(&curLine, ". <- ", 5);
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
        sClear(&sbTransErr);
        sAppend(&sbTransErr, "F0/FO is not supported in translation");
        updateSyntaxCol();
        trans_syntax_error_report_fn0(sbTransErr.s);
        finalizeSyntaxError();
      }
      // f(a1) <- ....
      sAppendN(&curLine, "rxf.", 4);
      cmtInfoStr = v + 1;
      writeAinfo(v + 1);
      sAppendN(&curLine, ". <- ", 5);
      return 1;
    } else if (i == 1) {
      return 1;
    }
    return 0;
  } else if (!strcmp("alag", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppendN(&curLine, "rxalag.", 7);
      writeAinfo(v + 4);
      cmtInfoStr = v + 4;
      sAppendN(&curLine, ". <- ", 5);
      return 1;
    } else if (i == 1) {
      return 1;
    }
    return 0;
  } else if (!strcmp("rate", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppend(&curLine, "rxrate.", 7);
      cmtInfoStr = v + 1;
      writeAinfo(v + 1);
      sAppendN(&curLine, ". <- ", 5);
      return 1;
    } else if (i == 1) {
      return 1;
    }
    return 0;
  } else if (!strcmp("dur", name)) {
    if (i == 0) {
      D_ParseNode *xpn = d_get_child(pn, 0);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      sAppendN(&curLine, "rxdur.", 6);
      cmtInfoStr = v + 1;
      writeAinfo(v + 1);
      sAppendN(&curLine, ". <- ", 5);
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
        definingScale = 1;
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
        definingScale = -1;
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
      definingScale = scaleCmt+1;
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
  } else if (!strcmp("callrandom", name)) {
    sAppendN(&curLine,"R <- rxunif()", 13);
    pushModel();
  } else if (!strcmp("callsimeta", name)) {
    sAppendN(&curLine,"simeta()", 8);
    pushModel();
    return;
  } else if (!strcmp("callsimeps", name)) {
    sAppendN(&curLine,"simeps()", 8);
    pushModel();
    return;
  } else if (!strcmp("callgeteta", name)) {
    sClear(&sbTransErr);
    sAppend(&sbTransErr, "'CALL GETETA(ETA)' not supported in translation");
    updateSyntaxCol();
    trans_syntax_error_report_fn0(sbTransErr.s);
    finalizeSyntaxError();
    parseFree(0);
  } else if (!strcmp("exit_line", name)) {
    /* With NONMEM 7.4.2, there is a new variable, IERPRDU.  Both n and k are */
    /* stored in IERPRDU.  k must be between 0 and 999. The value  stored  is */
    /* n*10000+k.  E.g., "EXIT 1 500" is stored in IERPRDU as 10500. */
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *v1 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 2);
    char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppend(&curLine, "ierprdu <- %s*100000+%s", v1, v2);
    nonmem2rxNeedExit();
    pushModel();
    return;
  }
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      if (abbrev_identifier_or_constant(name, i, pn) ||
          abbrev_params(name, i,  pn) ||
          abbrev_if_while_clause(name, i, pn) ||
          abbrev_if1_clauses(name, i, pn) ||
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
      !strcmp("ifexit", name) ||
      !strcmp("if1", name) ||
      !strcmp("derivative", name) ||
      !strcmp("derivativeI", name) ||
      !strcmp("scale", name) ||
      !strcmp("ifcallrandom", name) ||
      !strcmp("ifcallsimeta", name) ||
      !strcmp("ifcallsimeps", name) ) {
    pushModel();
  } else if (!strcmp("if1other", name)) {
    pushModel();
    sAppendN(&curLine, "}", 1);
    pushModel();
  } else if (!strcmp("fbio", name)) {
    pushModel();
    sAppendN(&curLine, "f(", 2);
    writeAinfo(cmtInfoStr);
    sAppendN(&curLine, ") <- rxf.", 9);
    writeAinfo(cmtInfoStr);
    sAppendN(&curLine, ".", 1);
    pushModel();
    cmtInfoStr = NULL;
  } else if (!strcmp("alag", name)) {
    pushModel();
    sAppendN(&curLine, "alag(", 5);
    writeAinfo(cmtInfoStr);
    sAppendN(&curLine, ") <- rxalag.", 12);
    writeAinfo(cmtInfoStr);
    sAppendN(&curLine, ".", 1);
    pushModel();
    cmtInfoStr = NULL;
  } else if (!strcmp("rate", name)) {
    pushModel();
    sAppendN(&curLine, "rate(", 5);
    writeAinfo(cmtInfoStr);
    sAppendN(&curLine, ") <- rxrate.", 12);
    writeAinfo(cmtInfoStr);
    sAppendN(&curLine, ".", 1);
    pushModel();
    cmtInfoStr = NULL;
  } else if (!strcmp("dur", name)) {
    pushModel();
    sAppendN(&curLine, "dur(", 4);
    writeAinfo(cmtInfoStr);
    sAppendN(&curLine, ") <- rxdur.", 11);
    writeAinfo(cmtInfoStr);
    sAppendN(&curLine, ".", 1);
    pushModel();
    cmtInfoStr = NULL;
  } else if (!strcmp("ini", name) ||
             !strcmp("iniI", name)) {
    pushModel();
    writeAinfo(cmtInfoStr);
    sAppendN(&curLine, "(0) <- rxini.", 13);
    writeAinfo(cmtInfoStr);
    sAppendN(&curLine, ".", 1);
    pushModel();
    cmtInfoStr = NULL;
  }
}

void trans_abbrev(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxAbbrev, sizeof(D_ParseNode_User));
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
    wprint_parsetree_abbrev(parser_tables_nonmem2rxAbbrev, _pn, 0, wprint_node_abbrev, NULL);
  }
  finalizeSyntaxError();
}

SEXP nonmem2rxSetMaxA(int maxa);

SEXP _nonmem2rx_trans_abbrev(SEXP in, SEXP prefix, SEXP abbrevLinSEXP) {
  sClear(&curLine);
  abbrevPrefix = (char*)rc_dup_str(R_CHAR(STRING_ELT(prefix, 0)), 0);
  abbrevLin = INTEGER(abbrevLinSEXP)[0];
  verbWarning = 0;
  maxA = 0;
  evidWarning=0;
  idWarning=0;
  simWarning=0;
  ipredSimWarning=0;
  icallWarning=0;
  irepWarning=0;
  trans_abbrev(R_CHAR(STRING_ELT(in, 0)));
  nonmem2rxSetMaxA(maxA);
  parseFree(0);
  return R_NilValue;
}
