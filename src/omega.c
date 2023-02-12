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
  sIni(&curOmegaLhs);
  sIni(&curOmegaRhs);
  sIni(&curOmega);
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

void wprint_parsetree_omega(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  int isBlockNsame = 0;
  int isBlockSameN = 0;
  int isBlockNsameN = 0;
  if (!strcmp("name_option", name)) {
    int nargs = d_get_number_of_children(d_get_child(pn,3))+1;
    if (nargs != nonmem2rx_omegaBlockn) {
      Rf_errorcall(R_NilValue,
                   "number items of NAMES() does not match number of diagonals");
    }
    D_ParseNode *xpn = d_get_child(pn, 2);
    nonmem2rx_omegaLabel = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    pushOmegaLabel();
    xpn = d_get_child(pn, 3);
    nargs--;
    for (int i = 0; i < nargs; i++) {
      D_ParseNode *ypn = d_get_child(d_get_child(xpn, i), 1);
      nonmem2rx_omegaLabel = (char*)rc_dup_str(ypn->start_loc.s, ypn->end);
      pushOmegaLabel();
    }
  } else if (!strcmp("blockn_name_value", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rx_omegaBlockn = atoi(v);
    // parse name_option
    xpn = d_get_child(pn, 4);
    wprint_parsetree_omega(pt, xpn, depth, fn, client_data);
    // Get diag and off diagonal pieces
    xpn = d_get_child(pn, 7);
    v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 9);
    char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2xPushOmegaBlockNvalue(nonmem2rx_omegaBlockn, v, v2, omegaEstPrefix, nonmem2rx_omeganum);
    nonmem2rx_omeganum+=nonmem2rx_omegaBlockn;
    nonmem2rx_omegaBlockn=0;
    return;
  } else if (!strcmp("omega_name", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    nonmem2rx_omegaLabel = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
  } else if (!strcmp("blocknvalue", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    int n = atoi(v);
    xpn = d_get_child(pn, 6);
    v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 8);
    char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2xPushOmegaBlockNvalue(n, v, v2, omegaEstPrefix, nonmem2rx_omeganum);
    for (int cur = 0; cur < n; cur++) {
      pushOmegaLabel();      
    }
    nonmem2rx_omeganum+=n;
    return;
  } else if (!strcmp("repeat", name)) {
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
  } else if (!strcmp("diag_type", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    if (v[0] == 'S' || v[0] == 's') {
      nonmem2rx_omegaSd = 1;
    }
  } else if (!strcmp("off_diag_type", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    if (!strncmpci("cor", v, 3)) {
      nonmem2rx_omegaCor = 1;
    }
  } else if (!strcmp("block_chol_type", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    if (v[0] == 'C' || v[0] == 'c') {
      nonmem2rx_omegaChol = 1;
    }
  } else if (!strcmp("fixed", name)) {
    nonmem2rx_omegaFixed = 1;
  } else if (!strcmp("omega_statement", name)) {
    D_ParseNode *xpn = d_get_child(pn, 4);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v[0] != 0) {
      curComment = v;
    }
  } else if (!strcmp("blockn", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rx_omegaBlockn = atoi(v);
    nonmem2rx_omegaLastBlock = nonmem2rx_omegaBlockn;
    nonmem2rx_omegaBlockI = 0;
    nonmem2rx_omegaBlockJ = 0;
    nonmem2rx_omegaBlockCount = 0;
  } else if (!strcmp("blocksame", name) ||
             (isBlockNsame = !strcmp("blocknsame", name)) ||
             (isBlockNsameN = !strcmp("blocknsamen", name)) ||
             (isBlockSameN = !strcmp("blocksamen", name))) {
    sClear(&curOmegaLhs);
    if (isBlockNsame || isBlockNsameN) {
      D_ParseNode *xpn = d_get_child(pn, 2);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      int curI = atoi(v);
      if (atoi(v) != nonmem2rx_omegaLastBlock) {
        parseFree(0);
        Rf_errorcall(R_NilValue, "Requested BLOCK(%d) but last BLOCK was size %d",
                     curI, nonmem2rx_omegaLastBlock);
      }
    }
    if (curOmegaRhs.s[0] == 0) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "Requested BLOCK SAME before a block was defined");
    }
    curComment=NULL;
    int nsame = 1;
    if (isBlockNsameN) {
      D_ParseNode *xpn = d_get_child(pn, 6);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      nsame = atoi(v);
    } else if (isBlockSameN) {
      D_ParseNode *xpn = d_get_child(pn, 3);
      char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      nsame = atoi(v);
    }
    for (int cur = 0; cur < nsame; cur++) {
      for (int i = 0; i < nonmem2rx_omegaLastBlock; i++) {
        if (i == 0) {
          sAppend(&curOmegaLhs, "%s%d", omegaEstPrefix, nonmem2rx_omeganum);
        } else {
          sAppend(&curOmegaLhs, " + %s%d", omegaEstPrefix, nonmem2rx_omeganum);
        }
        pushOmegaComment();
        pushOmegaLabel();
        nonmem2rx_omeganum++;
      }
      sAppend(&curOmega, "%s ~ fix%s)", curOmegaLhs.s, curOmegaRhs.s);
      nonmem2rx_omegaSame = 1;
      pushOmega();
    }
  } else if (!strcmp("diagonal", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rx_omegaDiagonal = atoi(v);
    nonmem2rx_omegaBlockCount = 0;
    Rf_warning("DIAGONAL(%d) does not do anything right now, it is ignored", nonmem2rx_omegaDiagonal);
    nonmem2rx_omegaDiagonal = NA_INTEGER;
  } else if (nonmem2rx_omegaBlockn != 0 && !strcmp("omega1", name)) {
  } else if (!strcmp("omega2", name)) {
    D_ParseNode *xpn = d_get_child(pn, 4);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    // parse block type first
    xpn = d_get_child(pn, 1);
    wprint_parsetree_omega(pt, xpn, depth, fn, client_data);
    xpn = d_get_child(pn, 3);
    wprint_parsetree_omega(pt, xpn, depth, fn, client_data);
    // this form is only good for diagonal matrices
    if (nonmem2rx_omegaBlockn != 0) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "(FIXED %s) is not supported in an $OMEGA or $SIGMA BLOCK", v);
    }
    sAppend(&curOmega, "%s%d", omegaEstPrefix, nonmem2rx_omeganum);
    sAppend(&curOmega, " ~ fix(%s)", v);
    if (nonmem2rx_omegaDiagonal != NA_INTEGER) nonmem2rx_omegaDiagonal++;
    nonmem2rx_omeganum++;
    pushOmegaComment();
    pushOmegaLabel();
    pushOmega();
    nonmem2rx_repeatVal = v;
    nonmem2rx_omegaRepeat = -1;
    return;
  } else if (!strcmp("omega0", name)) {
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
    if (nonmem2rx_omegaBlockn == 0) {
      // This is a regular initialization
      nonmem2rx_repeatVal = v;
      if (fix[0] != 0) {
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
        nonmem2rx_omegaFixed = 1; 
      }
      addOmegaBlockItem(v);
      nonmem2rx_repeatVal = v;
    }
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

SEXP _nonmem2rx_trans_omega(SEXP in, SEXP prefix) {
  curComment=NULL;
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
