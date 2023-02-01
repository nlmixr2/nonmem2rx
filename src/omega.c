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
char *omegaEstPrefix;

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

SEXP nonmem2rxPushOmega(const char *ini);
SEXP nonmem2rxPushOmegaComment(const char *comment, const char *prefix);

void pushOmega(void) {
  //nonmem2rx_omegaDiagonal = NA_INTEGER; // diagonal but not specified
  nonmem2rx_omegaBlockn   = 0;
  nonmem2rx_omegaSame     = 0;
  nonmem2rx_omegaFixed    = 0;
  nonmem2rx_omegaBlockI   = 0;
  nonmem2rx_omegaBlockJ   = 0;
  nonmem2rx_omegaBlockCount = 0;
  nonmem2rxPushOmega(curOmega.s);
  sClear(&curOmegaLhs);
  sClear(&curOmega);
}

void pushOmegaComment(void) {
  nonmem2rxPushOmegaComment(curComment, omegaEstPrefix);
  curComment = NULL;
}

void wprint_parsetree_omega(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  int isBlockNsame = 0;
  if (!strcmp("omega_statement", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
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
             (isBlockNsame = !strcmp("blocknsame", name))) {
    sClear(&curOmegaLhs);
    if (isBlockNsame) {
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
    for (int i = 0; i < nonmem2rx_omegaLastBlock; i++) {
      if (i == 0) {
        sAppend(&curOmegaLhs, "%s%d", omegaEstPrefix, nonmem2rx_omeganum);
      } else {
        sAppend(&curOmegaLhs, " + %s%d", omegaEstPrefix, nonmem2rx_omeganum);
      }
      nonmem2rx_omeganum++;
    }
    sAppend(&curOmega, "%s ~ fix%s)", curOmegaLhs.s, curOmegaRhs.s);
    nonmem2rx_omegaSame = 1;
    pushOmega();
  } else if (!strcmp("diagonal", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rx_omegaDiagonal = atoi(v);
    nonmem2rx_omegaBlockCount = 0;
    Rf_warning("DIAGONAL(%d) does not do anything right now, it is ignored", nonmem2rx_omegaDiagonal);
    nonmem2rx_omegaDiagonal = NA_INTEGER;
  } else if (nonmem2rx_omegaBlockn != 0 && !strcmp("omega1", name)) {
    if (nonmem2rx_omegaBlockn != 0) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "parenthetical estimates are is not supported in an $OMEGA or $SIGMA BLOCK");
    }
  } else if (!strcmp("omega2", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    // this form is only good for diagonal matrices
    if (nonmem2rx_omegaBlockn != 0) {
      parseFree(0);
      Rf_errorcall(R_NilValue, "(FIXED %s) is not supported in an $OMEGA or $SIGMA BLOCK", v);
    }
    sAppend(&curOmega, "%s%d", omegaEstPrefix, nonmem2rx_omeganum);
    sAppend(&curOmega, " ~ fix(%s)", v);
    if (nonmem2rx_omegaDiagonal != NA_INTEGER) nonmem2rx_omegaDiagonal++;
    nonmem2rx_omeganum++;
    pushOmega();
  } else if (!strcmp("omega0", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 1);
    char *fix = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (nonmem2rx_omegaBlockn == 0) {
      // This is a regular initialization
      if (fix[0] != 0) {
        sAppend(&curOmega, "%s%d ~ fix(%s)", omegaEstPrefix, nonmem2rx_omeganum, v);
      } else {
        sAppend(&curOmega, "%s%d ~ %s", omegaEstPrefix, nonmem2rx_omeganum, v);
      }
      if (nonmem2rx_omegaDiagonal != NA_INTEGER) nonmem2rx_omegaDiagonal++;
      nonmem2rx_omeganum++;
      pushOmegaComment();
      pushOmega();
    } else {
      if (fix[0] != 0) {
        nonmem2rx_omegaFixed = 1; 
      }
      if (nonmem2rx_omegaBlockCount >= nonmem2rx_omegaBlockn) {
        parseFree(0);
        Rf_errorcall(R_NilValue, "$OMEGA or $SIGMA BLOCK(N) has too many elements");
      }
      // This is a block
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

SEXP _nonmem2rx_trans_omega(SEXP in, SEXP prefix) {
  curComment=NULL;
  omegaEstPrefix = (char*)rc_dup_str(R_CHAR(STRING_ELT(prefix, 0)), 0);
  trans_omega(R_CHAR(STRING_ELT(in, 0)));
  parseFree(0);
  return R_NilValue;
}
