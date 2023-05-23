#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>   /* dj: import intptr_t */
//#include "ode.h"
#include <rxode2parseSbuf.h>
#include <errno.h>
#include "dparser3.h"
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
#include "model.g.d_parser.h"
#include "strncmpi.h"

#define gBuf nonmem2rx_model_gBuf
#define gBufFree nonmem2rx_model_gBufFree
#define gBufLast nonmem2rx_model_gBufLast
#define curP nonmem2rx_model_curP
#define _pn nonmem2rx_model__pn
#define freeP nonmem2rx_model_freeP
#define parseFreeLast nonmem2rx_model_parseFreeLast
#define parseFree nonmem2rx_model_parseFree
#include "parseSyntaxErrors.h"

extern D_ParserTables parser_tables_nonmem2rxModel;

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
void wprint_node_model(int depth, char *token_name, char *token_value, void *client_data) {
}

sbuf modelName;
SEXP nonmem2rxPushModel0(const char *cmtName);
int nonmem2rx_model_cmt = 1;
int nonmem2rx_model_warn_npar = 0;

int nonmem2rxDefObs = 0;
int nonmem2rxDefDose = 0;

int nonmem2rxDefDepot = 0;
int nonmem2rxDefCentral = 0;

SEXP nonmem2rxPushModel(const char *cmtName) {
  if (!nmrxstrcmpi("depot", cmtName)) {
    nonmem2rxDefDepot = nonmem2rx_model_cmt;
  } else if (!nmrxstrcmpi("central", cmtName)) {
    nonmem2rxDefCentral = nonmem2rx_model_cmt;
  }
  nonmem2rx_model_cmt++;
  return nonmem2rxPushModel0(cmtName);
}

int model_comp_handle(char *name, D_ParseNode *pn) {
  if (!strcmp("comp_statement_1", name)) {
    D_ParseNode *xpn = d_get_child(pn, 3);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxPushModel(v);
    return 1;
  } else if (!strcmp("comp_statement_5", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rxPushModel(v);
    return 1;
  } else if (!strcmp("comp_statement_7", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sClear(&modelName);
    sAppend(&modelName, "rxddta%s", v);
    nonmem2rxPushModel(modelName.s);
    return 1;
  } else if (!strcmp("comp_statement_6", name)) {
    D_ParseNode *xpn = d_get_child(pn, 3);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    sClear(&modelName);
    sAppend(&modelName, "rxddta%s", v);
    nonmem2rxPushModel(modelName.s);
    return 1;
  } else if (!strcmp("comp_statement_2", name) ||
             !strcmp("comp_statement_4", name)) {
    sClear(&modelName);
    sAppend(&modelName, "rxddta%d", nonmem2rx_model_cmt);
    nonmem2rxPushModel(modelName.s);
    return 1;
  } else if (!strcmp("comp_statement_3", name)) {
    sClear(&modelName);
    D_ParseNode *xpn = d_get_child(pn, 3);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    v++;
    int len = strlen(v);
    v[len-1] = 0;
    nonmem2rxPushModel(v);
    return 1;
  }
  return 0;
}

void wprint_parsetree_model(D_ParserTables pt, D_ParseNode *pn, int depth, print_node_fn_t fn, void *client_data) {
  char *name = (char*)pt.symbols[pn->symbol].name;
  int nch = d_get_number_of_children(pn);
  if (model_comp_handle(name, pn)) {
  } else if (!strcmp("ncpt_statement", name)) {
    if (nonmem2rx_model_warn_npar ==0)
      Rf_warning("$MODEL NCOMPARTMENTS/NEQUILIBRIUM/NPARAMETERS statement(s) ignored");
    nonmem2rx_model_warn_npar = 1;
  } else if (!strcmp("link_statement", name)) {
    parseFree(0);
    Rf_errorcall(R_NilValue, "$MODEL statements with LINK are not currently translated");
  } else  if (!strcmp("identifier_nm", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    if (!nmrxstrcmpi("defdose", v)) {
      nonmem2rxDefDose = nonmem2rx_model_cmt - 1;
    } else if (!strncmpci("defobs", v, 6)) {
      nonmem2rxDefDose = nonmem2rx_model_cmt - 1;
    }
  }
  if (nch != 0) {
    for (int i = 0; i < nch; i++) {
      D_ParseNode *xpn = d_get_child(pn, i);
      wprint_parsetree_model(pt, xpn, depth, fn, client_data);
    }
  }
}

void trans_model(const char* parse){
  freeP();
  curP = new_D_Parser(&parser_tables_nonmem2rxModel, sizeof(D_ParseNode_User));
  curP->save_parse_tree = 1;
  curP->error_recovery = 1;
  curP->initial_scope = NULL;
  curP->syntax_error_fn = nonmem2rxSyntaxError;
  if (gBufFree) R_Free(gBuf);
  // Should be able to use gBuf directly, but I believe it cause
  // problems with R's garbage collection, so duplicate the string.
  gBuf = (char*)(parse);
  gBufFree=0;
  nonmem2rx_model_cmt = 1;
  nonmem2rx_model_warn_npar = 0;

  eBuf = gBuf;
  eBufLast = 0;
  errP = curP;
  _pn= dparse(curP, gBuf, (int)strlen(gBuf));
  if (!_pn || curP->syntax_errors) {
    //rx_syntax_error = 1;
  } else {
    wprint_parsetree_model(parser_tables_nonmem2rxModel, _pn, 0, wprint_node_model, NULL);
  }
  finalizeSyntaxError();
}

SEXP nonmem2rxPushCmtInfo(int defdose, int defobs);
SEXP _nonmem2rx_trans_model(SEXP in) {
  nonmem2rxDefObs = 0;
  nonmem2rxDefDose = 0;
  nonmem2rxDefDepot = 0;
  nonmem2rxDefCentral = 0;

  trans_model(R_CHAR(STRING_ELT(in, 0)));
  parseFree(0);
  sClear(&modelName);
  if (nonmem2rxDefObs == 0) nonmem2rxDefObs = nonmem2rxDefCentral;
  if (nonmem2rxDefDose == 0) nonmem2rxDefDose = nonmem2rxDefDepot;
  if (nonmem2rxDefObs == 0) nonmem2rxDefObs = 1;
  if (nonmem2rxDefDose == 0) nonmem2rxDefDose = 1;

  nonmem2rxPushCmtInfo(nonmem2rxDefDose, nonmem2rxDefObs);
  return R_NilValue;
}
