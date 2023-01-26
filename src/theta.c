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
#include "theta.g.d_parser.h"

#define gBuf nonmem2rx_theta_gBuf
#define gBufFree nonmem2rx_theta_gBufFree
#define gBufLast nonmem2rx_theta_gBufLast
#define curP nonmem2rx_theta_curP
#define _pn nonmem2rx_theta__pn
#define freeP nonmem2rx_theta_freeP
#define parseFreeLast nonmem2rx_theta_parseFreeLast
#define parseFree nonmem2rx_theta_parseFree

extern D_ParserTables parser_tables_nonmem2rxTheta;

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
void wprint_node_theta(int depth, char *token_name, char *token_value, void *client_data) {
  
}

int nonmem2rx_thetanum = 1;

char *curComment = NULL;
sbuf curTheta;

SEXP _nonmem2rx_thetanum_reset() {
  nonmem2rx_thetanum = 1;
  sIni(&curTheta);
  return R_NilValue;
}

SEXP nonmem2rxThetaGetMiddle(const char *low, const char *hi);

SEXP nonmem2rxPushTheta(const char *ini, const char *comment);

void pushTheta() {
  nonmem2rxPushTheta(curTheta.s, curComment);
  sClear(&curTheta);
}

void wprint_parsetree_theta(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  if (!strcmp("theta_statement", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v[0] == 0) {
      curComment = NULL;
    } else {
      curComment = v;
    }
  } else if (!strcmp("theta0", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 1);
    char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v2[0] == 0) {
      // not fixed
      sAppend(&curTheta, "theta%d <- %s", nonmem2rx_thetanum, v);
    } else {
      sAppend(&curTheta, "theta%d <- fix(%s)", nonmem2rx_thetanum, v);
    }
    pushTheta();
    nonmem2rx_thetanum++;
    return;
  } else if (!strcmp("theta6", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppend(&curTheta, "theta%d <- fix(%s)", nonmem2rx_thetanum, v);
    pushTheta();
    nonmem2rx_thetanum++;
    return;
  } else if (!strcmp("theta2", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *low = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 3);
    char *ini = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppend(&curTheta, "theta%d <- fix(%s, %s)", nonmem2rx_thetanum, low, ini);
    pushTheta();
    nonmem2rx_thetanum++;
    return;
  } else if (!strcmp("theta3", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *low = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 3);
    char *ini = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 4);
    char *fix = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (fix[0] == 0) {
      // not fixed
      sAppend(&curTheta, "theta%d <- c(%s, %s)", nonmem2rx_thetanum, low, ini);
    } else {
      sAppend(&curTheta, "theta%d <- fix(%s, %s)", nonmem2rx_thetanum, low, ini);
    }
    pushTheta();
    nonmem2rx_thetanum++;
    return;
  } else if (!strcmp("theta4", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *low = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 3);
    char *ini = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 5);
    char *hi = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sAppend(&curTheta, "theta%d <- fix(%s, %s, %s)", nonmem2rx_thetanum, low, ini, hi);
    pushTheta();
    nonmem2rx_thetanum++;
    return;
  }  else if (!strcmp("theta5", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *low = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 3);
    char *ini = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 5);
    char *hi = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 6);
    char *fix = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (fix[0] == 0) {
      // unfixed
      sAppend(&curTheta, "theta%d <- c(%s, %s, %s)", nonmem2rx_thetanum, low, ini, hi);
    } else {
      sAppend(&curTheta, "theta%d <- fix(%s, %s, %s)", nonmem2rx_thetanum, low, ini, hi);
    }
    pushTheta();
    nonmem2rx_thetanum++;
    return;    
  } else if (!strcmp("theta7", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *low = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 4);
    char *hi = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    SEXP cur = PROTECT(nonmem2rxThetaGetMiddle(low, hi));
    char *ini = (char*)rc_dup_str(CHAR(STRING_ELT(cur, 0)), 0);
    UNPROTECT(1);
    sAppend(&curTheta, "theta%d <- c(%s, %s, %s)", nonmem2rx_thetanum, low, ini, hi);
    pushTheta();
    nonmem2rx_thetanum++;
    return;
  } else if (!strcmp("abortInfo", name)) {
    Rf_warning(_("ABORT / NOABORT ignored in $THETA ignored"));
    return;
  } else if (!strcmp("numberpointsLine", name)) {
    Rf_warning(_("NUMBERPOINTS=# ignored  in $THETA ignored"));
    return;
  }
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_theta(pt, xpn, depth, fn, client_data);
    }
  }
}


void trans_theta(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxTheta, sizeof(D_ParseNode_User));
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
    wprint_parsetree_theta(parser_tables_nonmem2rxTheta, _pn, 0, wprint_node_theta, NULL);
  }
}

SEXP _nonmem2rx_trans_theta(SEXP in) {
  trans_theta(R_CHAR(STRING_ELT(in, 0)));
  return R_NilValue;
}
