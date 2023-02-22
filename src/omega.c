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
#include "strncmpi.h"

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
void wprint_node_omega(int depth, char *token_name, char *token_value, void *client_data) {
  
}

int nonmem2rx_unintFix = 0;
int nonmem2rx_omeganum = 1;
int nonmem2rx_omegaDiagonal = 0;
int nonmem2rx_omegaBlockn = 0;
int nonmem2rx_omegaBlockCount = 0;
int nonmem2rx_omegaSame = 0;
int nonmem2rx_omegaFixed = 0;
int nonmem2rx_omegaBlockI = 0;
int nonmem2rx_omegaBlockJ = 0;
int nonmem2rx_omegaLastBlock = 0;
int nonmem2rx_omegaSd=0;
int nonmem2rx_omegaChol=0;
int nonmem2rx_omegaCor=0;
int nonmem2rx_omegaRepeat=1;

char *omegaEstPrefix;
char *nonmem2rx_repeatVal;
char *nonmem2rx_omegaLabel;

extern char *curComment;
sbuf curOmegaLhs;
sbuf curOmegaRhs;
sbuf curOmega;

SEXP _nonmem2rx_omeganum_reset(void) {
  nonmem2rx_omeganum = 1;
  nonmem2rx_omegaDiagonal = NA_INTEGER; // diagonal but not specified
  nonmem2rx_omegaBlockn = 0;
  nonmem2rx_omegaSame = 0;
  nonmem2rx_omegaFixed = 0;
  nonmem2rx_omegaBlockI = 0;
  nonmem2rx_omegaBlockJ = 0;
  sClear(&curOmegaLhs);
  sClear(&curOmegaRhs);
  sClear(&curOmega);
  return R_NilValue;
}

SEXP nonmem2rxPushOmega(const char *ini, int sd, int cor, int chol);
SEXP nonmem2rxPushOmegaComment(const char *comment, const char *prefix);
SEXP nonmem2rxPushOmegaLabel(const char *comment, const char *prefix);
SEXP nonmem2xPushOmegaBlockNvalue(int n, const char *v1, const char *v2,
                                  const char *prefix, int num);

void pushOmega(void) {
  //nonmem2rx_omegaDiagonal = NA_INTEGER; // diagonal but not specified
  nonmem2rx_omegaBlockn   = 0;
  nonmem2rx_omegaSame     = 0;
  nonmem2rx_omegaFixed    = 0;
  nonmem2rx_omegaBlockI   = 0;
  nonmem2rx_omegaBlockJ   = 0;
  nonmem2rx_omegaBlockCount = 0;

  nonmem2rxPushOmega(curOmega.s, nonmem2rx_omegaSd, nonmem2rx_omegaCor,
                     nonmem2rx_omegaChol);
  nonmem2rx_omegaSd=0;
  nonmem2rx_omegaChol=0;
  nonmem2rx_omegaCor=0;
  sClear(&curOmegaLhs);
  sClear(&curOmega);
}

void pushOmegaComment(void) {
  nonmem2rxPushOmegaComment(curComment, omegaEstPrefix);
  curComment = NULL;
}

void pushOmegaLabel(void) {
  nonmem2rxPushOmegaLabel(nonmem2rx_omegaLabel, omegaEstPrefix);
  nonmem2rx_omegaLabel = NULL;
}

void addOmegaBlockItem(const char *v) {
  if (nonmem2rx_omegaBlockCount >= nonmem2rx_omegaBlockn) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "$OMEGA or $SIGMA BLOCK(N) has too many elements");
  }
  // This is a block
  if (nonmem2rx_omegaBlockJ == 0) {
    pushOmegaLabel();
  } else if (nonmem2rx_omegaLabel != NULL) {
    Rf_errorcall(R_NilValue,
                 "omega label '%s' should be at the beginning of the block line",
                 nonmem2rx_omegaLabel);
  }
  if (nonmem2rx_omegaBlockI == nonmem2rx_omegaBlockJ) {
    // Diagonal term
    nonmem2rx_omegaBlockI++;
    nonmem2rx_omegaBlockJ = 0;
    if (curOmegaLhs.s[0] == 0) {
      // not added yet
      sAppend(&curOmegaLhs, "%s%d", omegaEstPrefix, nonmem2rx_omeganum);
      sClear(&curOmegaRhs);
    } else {
      // added, use eta1 + eta2 ...
      sAppend(&curOmegaLhs, " + %s%d", omegaEstPrefix, nonmem2rx_omeganum);
    }
    pushOmegaComment();
    nonmem2rx_omegaBlockCount++;
    nonmem2rx_omeganum++;
  } else {
    nonmem2rx_omegaBlockJ++;
    curComment = NULL; // comments between estimates are not considered as labels
  }
  if (curOmegaRhs.s[0] == 0) {
    sClear(&curOmegaRhs);
    sAppend(&curOmegaRhs, "(%s", v);
  } else {
    sAppend(&curOmegaRhs, ", %s", v);
  }
}
void wprint_parsetree_omega(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data);

#define _arg_ char *name, D_ParseNode *pn, D_ParserTables pt, int depth, print_node_fn_t fn, void *client_data

int omegaParseEarlyExit = 0;

#include "omegaBlock.h"

int omegaParseRepeat(_arg_) {
  if (!strcmp("repeat", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (nonmem2rx_omegaBlockn == 0) {
      // repeat last "normal" item
      curComment = NULL;
      if (nonmem2rx_omegaRepeat == -1) {
        // fixed
        nonmem2rx_omegaRepeat = atoi(v);
        for (int cur = 0; cur < nonmem2rx_omegaRepeat-1; cur++) {
          sAppend(&curOmega, "%s%d ~ fix(%s)", omegaEstPrefix, nonmem2rx_omeganum,
                  nonmem2rx_repeatVal);
          nonmem2rx_omeganum++;
          pushOmegaComment();
          pushOmegaLabel();
          pushOmega();
        }
      } else {
        // unfixed
        nonmem2rx_omegaRepeat = atoi(v);
        for (int cur = 0; cur < nonmem2rx_omegaRepeat-1; cur++) {
          sAppend(&curOmega, "%s%d ~ %s", omegaEstPrefix, nonmem2rx_omeganum,
                  nonmem2rx_repeatVal);
          nonmem2rx_omeganum++;
          pushOmegaComment();
          pushOmegaLabel();
          pushOmega();
        }
      }
      nonmem2rx_omegaRepeat = 1;
    } else {
      nonmem2rx_omegaRepeat = atoi(v);
      for (int cur = 0; cur <nonmem2rx_omegaRepeat -1; cur++) {
        addOmegaBlockItem(nonmem2rx_repeatVal);
      }
      nonmem2rx_omegaRepeat = 1;
    }
    return 1;
  }
  return 0;
}
int omegaParseFixed(_arg_) {
  if (!strcmp("fixed", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    if (v[0] == 'u' || v[0] == 'U') {
      if (nonmem2rx_unintFix) {
        nonmem2rx_omegaFixed = 1;
      } else {
        nonmem2rx_omegaFixed = 0;
      }
    } else {
      nonmem2rx_omegaFixed = 1;
    }
    return 1;
  }
  return 0;
}
int omegaParseOmegaStatement(_arg_) {
  if (!strcmp("omega_statement", name)) {
    D_ParseNode *xpn = d_get_child(pn, 4);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v[0] != 0) {
      curComment = v;
    }
    return 1;
  }
  return 0;
}
int omegaParseOmega1(_arg_) {
  if (nonmem2rx_omegaBlockn != 0 && !strcmp("omega1", name)) {
    return 1;
  }
  return 0;
}
int omegaParseOmega2(_arg_) {
  if (!strcmp("omega2", name)) {
    D_ParseNode *xpn = d_get_child(pn, 4);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    // parse block type first
    xpn = d_get_child(pn, 1);
    wprint_parsetree_omega(pt, xpn, depth, fn, client_data);
    xpn = d_get_child(pn, 3);
    wprint_parsetree_omega(pt, xpn, depth, fn, client_data);
    xpn = d_get_child(pn, 2);
    int unint = 0;
    char *fix = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (fix[0] == 'u' || fix[0] == 'U') {
      unint = 1;
    }
    // this form is only good for diagonal matrices
    if (nonmem2rx_omegaBlockn != 0) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "(FIXED/UNINT %s) is not supported in an $OMEGA or $SIGMA BLOCK", v);
    }
    sAppend(&curOmega, "%s%d", omegaEstPrefix, nonmem2rx_omeganum);
    if (unint && nonmem2rx_unintFix == 0) {
      sAppend(&curOmega, " ~ %s", v);
    } else {
      sAppend(&curOmega, " ~ fix(%s)", v);
    }
    if (nonmem2rx_omegaDiagonal != NA_INTEGER) nonmem2rx_omegaDiagonal++;
    nonmem2rx_omeganum++;
    pushOmegaComment();
    pushOmegaLabel();
    pushOmega();
    nonmem2rx_repeatVal = v;
    nonmem2rx_omegaRepeat = -1;
    omegaParseEarlyExit = 1;
    return 1;
  }
  return 0;
}
int omegaParseOmeg0(_arg_) {
  if (!strcmp("omega0", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    // Parse the block type statements before the estimate to get properties
    xpn = d_get_child(pn, 1);
    wprint_parsetree_omega(pt, xpn, depth, fn, client_data);
    xpn = d_get_child(pn, 3);
    wprint_parsetree_omega(pt, xpn, depth, fn, client_data);
    // Get the fixed statement
    xpn = d_get_child(pn, 2);
    char *fix = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    int unint = 0, fixed = 0;
    if (nonmem2rx_omegaBlockn == 0) {
      // This is a regular initialization
      nonmem2rx_repeatVal = v;
      fixed = fix[0] != 0;
      unint = fixed  && (fix[0] == 'u' || fix[0] == 'U');
      fixed = unint ? nonmem2rx_unintFix : fixed;
      if (fixed) {
          sAppend(&curOmega, "%s%d ~ fix(%s)", omegaEstPrefix, nonmem2rx_omeganum, v);
          nonmem2rx_omegaRepeat = -1;
      } else {
        sAppend(&curOmega, "%s%d ~ %s", omegaEstPrefix, nonmem2rx_omeganum, v);
        nonmem2rx_omegaRepeat = -2;
      }
      if (nonmem2rx_omegaDiagonal != NA_INTEGER) nonmem2rx_omegaDiagonal++;
      nonmem2rx_omeganum++;
      pushOmegaComment();
      pushOmegaLabel();
      pushOmega();
    } else {
      if (fix[0] != 0) {
        if ((fix[0] == 'u' || fix[0] == 'U')){
          if (nonmem2rx_unintFix) 
            nonmem2rx_omegaFixed = 1; 
        } else {
          nonmem2rx_omegaFixed = 1; 
        }
      }
      addOmegaBlockItem(v);
      nonmem2rx_repeatVal = v;
    }
    omegaParseEarlyExit = 1;
    return 1;
  }
  return 0;
}
#undef _arg_
void wprint_parsetree_omega(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
#define _arg_ name, pn, pt, depth, fn, client_data
  int doRet = omegaParseOmeg0(_arg_)
    || omegaParseOmega1(_arg_)
    || omegaParseOmega2(_arg_)
    || omegaParseFixed(_arg_)
    || omegaParseBlockn(_arg_)
    || omegaParseBlockSame(_arg_)
    || omegaParseDiagonal(_arg_)
    || omegaParseBlocknNameValue(_arg_)
    || omegaParseOmegaName(_arg_)
    || omegaParseBlocknvalue(_arg_)
    || omegaParseRepeat(_arg_)
    || omegaParseDiagType(_arg_)
    || omegaParseOffDiagType(_arg_)
    || omegaParseBlockCholType(_arg_)
    || omegaParseOmegaStatement(_arg_)
    || omegaParseNameOption(_arg_)
    ;
#undef _arg_
  if (omegaParseEarlyExit) {
    omegaParseEarlyExit = 0;
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
  nonmem2rx_omegaDiagonal   = NA_INTEGER; // diagonal but not specified
  nonmem2rx_omegaBlockn     = 0;
  nonmem2rx_omegaSame       = 0;
  nonmem2rx_omegaFixed      = 0;
  nonmem2rx_omegaBlockI     = 0;
  nonmem2rx_omegaBlockJ     = 0;
  nonmem2rx_omegaBlockCount = 0;
  _pn= dparse(curP, gBuf, (int)strlen(gBuf));
  if (!_pn || curP->syntax_errors) {
    //rx_syntax_error = 1;
    parseFree(0);
    Rf_errorcall(R_NilValue, "parsing error in $OMEGA");
  } else {
    wprint_parsetree_omega(parser_tables_nonmem2rxOmega, _pn, 0, wprint_node_omega, NULL);
  }
  if (nonmem2rx_omegaBlockn == 0) {
  } else if (nonmem2rx_omegaSame == 1) {
  } else if (nonmem2rx_omegaBlockCount < nonmem2rx_omegaBlockn) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "$OMEGA or $SIGMA BLOCK(N) does not have enough elements");
  } else {
    // push block
    if (nonmem2rx_omegaFixed == 0) {
      sAppend(&curOmega, "%s ~ c%s)", curOmegaLhs.s, curOmegaRhs.s);
    } else {
      sAppend(&curOmega, "%s ~ fix%s)", curOmegaLhs.s, curOmegaRhs.s);
    }
    pushOmega();
  }
}

SEXP nonmem2rxPushObservedMaxEta(int a);

SEXP _nonmem2rx_trans_omega(SEXP in, SEXP prefix, SEXP unintFix) {
  curComment=NULL;
  nonmem2rx_unintFix = INTEGER(unintFix)[0];
  nonmem2rx_omegaFixed = 0;
  nonmem2rx_omegaRepeat = 1;
  nonmem2rx_omegaDiagonal = 0;
  nonmem2rx_omegaBlockn = 0;
  nonmem2rx_omegaBlockCount = 0;
  nonmem2rx_omegaSame = 0;
  nonmem2rx_omegaFixed = 0;
  nonmem2rx_omegaBlockI = 0;
  nonmem2rx_omegaBlockJ = 0;
  nonmem2rx_omegaSd=0;
  nonmem2rx_omegaChol=0;
  nonmem2rx_omegaCor=0;

  omegaEstPrefix = (char*)rc_dup_str(R_CHAR(STRING_ELT(prefix, 0)), 0);
  trans_omega(R_CHAR(STRING_ELT(in, 0)));
  parseFree(0);
  nonmem2rxPushObservedMaxEta(nonmem2rx_omeganum);
  return R_NilValue;
}
