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
void wprint_node_theta(int depth, char *token_name, char *token_value, void *client_data) {
  
}

int nonmem2rx_thetanum = 1;
int nonmem2rx_names_nargs = 0;

char *curComment = NULL;
char *curLabel = NULL;
sbuf curThetaRhs;
sbuf curTheta;

SEXP _nonmem2rx_thetanum_reset(void) {
  nonmem2rx_thetanum = 1;
  sClear(&curTheta);
  sClear(&curThetaRhs);
  return R_NilValue;
}

SEXP nonmem2rxThetaGetMiddle(const char *low, const char *hi);

SEXP nonmem2rxPushTheta(const char *ini, const char *comment, const char *label,
                        int nargs);

void pushTheta(void) {
  if (curTheta.s[0] != 0 && curLabel != NULL && nonmem2rx_names_nargs != 0) {
    Rf_warning("Label '%s' ignored because NAMES() is preferred in nonmem2rx translation", curLabel);
  }
  nonmem2rxPushTheta(curTheta.s, curComment, curLabel, nonmem2rx_names_nargs);
  if (curTheta.s[0] != 0 && nonmem2rx_names_nargs) nonmem2rx_names_nargs--;
  sClear(&curTheta);
  curComment = NULL;
  curLabel = NULL;
}

void wprint_parsetree_theta(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  if (!strcmp("name_option", name)) {
    nonmem2rx_names_nargs = d_get_number_of_children(d_get_child(pn,3))+1;
    int nargs = nonmem2rx_names_nargs;
    sClear(&curTheta);
    D_ParseNode *xpn = d_get_child(pn, 2);
    curLabel = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    pushTheta();
    xpn = d_get_child(pn, 3);
    for (int i = 0; i < nargs-1; i++) {
      D_ParseNode *ypn = d_get_child(d_get_child(xpn, i), 1);
      curLabel = (char*)rc_dup_str(ypn->start_loc.s, ypn->end);
      pushTheta();
    }
  } else if (!strcmp("theta_name", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    curLabel = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
  } else if (!strcmp("repeat", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    int n = atoi(v);
    for (int i = 0; i < n-1; i++) {
      sAppend(&curTheta, "theta%d%s",
              nonmem2rx_thetanum, curThetaRhs.s);
      pushTheta();
      nonmem2rx_thetanum++;
    }
  } else if (!strcmp("theta_statement", name)) {
    sClear(&curThetaRhs);
    D_ParseNode *xpn = d_get_child(pn, 3);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v[0] == 0) {
      curComment = NULL;
    } else {
      curComment = v;
    }
    xpn = d_get_child(pn, 0);
    v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v[0] == 0) {
      curLabel=NULL;
    }
  } else if (!strcmp("theta0", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 1);
    char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v2[0] == 0) {
      // not fixed
      sAppend(&curThetaRhs, " <- %s", v);
      sAppend(&curTheta, "theta%d%s",
              nonmem2rx_thetanum, curThetaRhs.s);
    } else {
      if (v2[0] == 'u' || v2[0] == 'U') {
        Rf_warning("Un-interesting values (UNINT) are treated as fixed in translation");
      }
      sAppend(&curThetaRhs, " <- fix(%s)", v);
      sAppend(&curTheta, "theta%d%s",
              nonmem2rx_thetanum, curThetaRhs.s);
    }
    pushTheta();
    nonmem2rx_thetanum++;
    return;
  } else if (!strcmp("theta6", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 3);
    char *fix = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (fix[0] == 'u' || fix[0] == 'U') {
      Rf_warning("Un-interesting values (UNINT) are treated as fixed in translation");
    }
    sAppend(&curThetaRhs, " <- fix(%s)", v);
    sAppend(&curTheta, "theta%d%s", nonmem2rx_thetanum, curThetaRhs.s);
    pushTheta();
    nonmem2rx_thetanum++;
    return;
  } else if (!strcmp("theta2", name)) {
    D_ParseNode *xpn = d_get_child(pn, 1);
    char *low = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 3);
    char *ini = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 5);
    char *fix = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (fix[0] == 'u' || fix[0] == 'U') {
      Rf_warning("Un-interesting values (UNINT) are treated as fixed in translation");
    }
    sAppend(&curThetaRhs, " <- fix(%s, %s)", low, ini);
    sAppend(&curTheta, "theta%d%s", nonmem2rx_thetanum, curThetaRhs.s);
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
      sAppend(&curThetaRhs, " <- c(%s, %s)", low, ini);
      sAppend(&curTheta, "theta%d%s", nonmem2rx_thetanum,
              curThetaRhs.s);
    } else {
      if (fix[0] == 'u' || fix[0] == 'U') {
        Rf_warning("Un-interesting values (UNINT) are treated as fixed in translation");
      }
      sAppend(&curThetaRhs, " <- fix(%s, %s)", low, ini);
      sAppend(&curTheta, "theta%d%s", nonmem2rx_thetanum,
              curThetaRhs.s);
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
    xpn = d_get_child(pn, 7);
    char *fix = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (fix[0] == 'u' || fix[0] == 'U') {
      Rf_warning("Un-interesting values (UNINT) are treated as fixed in translation");
    }
    sAppend(&curThetaRhs, " <- fix(%s, %s, %s)", low, ini, hi);
    sAppend(&curTheta, "theta%d%s", nonmem2rx_thetanum, curThetaRhs.s);
    pushTheta();
    nonmem2rx_thetanum++;
    return;
  } else if (!strcmp("theta5", name)) {
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
      sAppend(&curThetaRhs, " <- c(%s, %s, %s)", low, ini, hi);
      sAppend(&curTheta, "theta%d%s", nonmem2rx_thetanum, curThetaRhs.s);
    } else {
      if (fix[0] == 'u' || fix[0] == 'U') {
        Rf_warning("Un-interesting values (UNINT) are treated as fixed in translation");
      }
      sAppend(&curThetaRhs, " <- fix(%s, %s, %s)", low, ini, hi);
      sAppend(&curTheta, "theta%d%s", nonmem2rx_thetanum, curThetaRhs.s);
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
    sAppend(&curThetaRhs, " <- c(%s, %s, %s)", low, ini, hi);
    sAppend(&curTheta, "theta%d%s", nonmem2rx_thetanum, curThetaRhs.s);
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
    parseFree(0);
    Rf_errorcall(R_NilValue, "parsing error in $THETA");
  } else {
    wprint_parsetree_theta(parser_tables_nonmem2rxTheta, _pn, 0, wprint_node_theta, NULL);
  }
}

SEXP nonmem2rxPushObservedMaxTheta(int a);
SEXP _nonmem2rx_trans_theta(SEXP in) {
  trans_theta(R_CHAR(STRING_ELT(in, 0)));
  parseFree(0);
  nonmem2rxPushObservedMaxTheta(nonmem2rx_thetanum);
  if (nonmem2rx_names_nargs) {
    Rf_errorcall(R_NilValue, "the NAMES() statement named more parameters than present in this $THETA block, error in translation.");
    nonmem2rx_names_nargs = 0;
  }
  return R_NilValue;
}
