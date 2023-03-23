#ifndef __omegaBlock__
#define __omegaBlock__
int omegaParseNameOption(_arg_) {
  if (!strcmp("name_option", name)) {
    int nargs = d_get_number_of_children(d_get_child(pn,3))+1;
    if (nargs != nonmem2rx_omegaBlockn) {
      Rf_errorcall(R_NilValue,
                   "number items of NAMES() does not match number of diagonals (%d/%d)",
                   nargs, nonmem2rx_omegaBlockn);
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
    return 1;
  }
  return 0;
}
int omegaParseBlocknNameValue(_arg_) {
  if (!strcmp("blockn_name_value", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rx_omegaBlockn = atoi(v);
    int fixed = 0;
    xpn = d_get_child(pn, 4);
    v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v[0] != 0) {
      fixed = 1;
    }
    if (!fixed) {
      xpn = d_get_child(pn, 6);
      v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (v[0] != 0) {
        fixed = 1;
      }
    }
    if (!fixed) {
      xpn = d_get_child(pn, 13);
      v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (v[0] != 0) {
        fixed = 1;
      }
    }
    // parse name_option
    xpn = d_get_child(pn, 5);
    wprint_parsetree_omega(pt, xpn, depth, fn, client_data);
    // Get diag and off diagonal pieces
    xpn = d_get_child(pn, 9);
    v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 11);
    char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2xPushOmegaBlockNvalue(nonmem2rx_omegaBlockn, v, v2, omegaEstPrefix, nonmem2rx_omeganum, fixed);
    nonmem2rx_omeganum+=nonmem2rx_omegaBlockn;
    nonmem2rx_omegaBlockn=0;
    omegaParseEarlyExit = 1;
    return 1;
  }
  return 0;
}
int omegaParseOmegaName(_arg_) {
  if (!strcmp("omega_name", name)) {
    D_ParseNode *xpn = d_get_child(pn, 0);
    char *v = nonmem2rx_omegaLabel;
    nonmem2rx_omegaLabel = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v != NULL) {
      Rf_warning("label '%s' was changed to '%s', check control stream",
                 v, nonmem2rx_omegaLabel);
    }
    return 1;
  }
  return 0;
}
int omegaParseBlocknvalue (_arg_) {
  if (!strcmp("blocknvalue", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    int n = atoi(v);
    int fixed = 0;
    xpn = d_get_child(pn, 4);
    v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    if (v[0] != 0) {
      fixed = 1;
    }
    if (!fixed) {
      xpn = d_get_child(pn, 11);
      v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
      if (v[0] != 0) {
        fixed=1;
      }
    }
    xpn = d_get_child(pn, 7);
    v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    xpn = d_get_child(pn, 9);
    char *v2 = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2xPushOmegaBlockNvalue(n, v, v2, omegaEstPrefix, nonmem2rx_omeganum, fixed);
    for (int cur = 0; cur < n; cur++) {
      pushOmegaLabel();      
    }
    nonmem2rx_omeganum+=n;
    omegaParseEarlyExit = 1;
    return 1;
  }
  return 0;
}

int omegaParseDiagType(_arg_) {
  if (!strcmp("diag_type", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    if (v[0] == 'S' || v[0] == 's') {
      nonmem2rx_omegaSd = 1;
    }
    return 1;
  }
  return 0;
}
int omegaParseOffDiagType(_arg_) {
  if (!strcmp("off_diag_type", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    if (!strncmpci("cor", v, 3)) {
      nonmem2rx_omegaCor = 1;
    }
    return 1;
  }
  return 0;
}
int omegaParseBlockCholType(_arg_) {
  if (!strcmp("block_chol_type", name)) {
    char *v = (char*)rc_dup_str(pn->start_loc.s, pn->end);
    if (v[0] == 'C' || v[0] == 'c') {
      nonmem2rx_omegaChol = 1;
    }
    return 1;
  }
  return 0;
}

int omegaParseBlockn(_arg_) {
  if (!strcmp("blockn", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rx_omegaBlockn = atoi(v);
    nonmem2rx_omegaLastBlock = nonmem2rx_omegaBlockn;
    nonmem2rx_omegaBlockI = 0;
    nonmem2rx_omegaBlockJ = 0;
    nonmem2rx_omegaBlockCount = 0;
    return 1;
  }
  return 0;
}
int omegaParseBlockSame(_arg_) {
  int isBlockNsame = 0;
  int isBlockSameN = 0;
  int isBlockNsameN = 0;
  if (!strcmp("blocksame", name) ||
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
    return 1;
  }
  return 0;
}
int omegaParseDiagonal(_arg_) {
  if (!strcmp("diagonal", name)) {
    D_ParseNode *xpn = d_get_child(pn, 2);
    char *v = (char*)rc_dup_str(xpn->start_loc.s, xpn->end);
    nonmem2rx_omegaDiagonal = atoi(v);
    nonmem2rx_omegaBlockCount = 0;
    Rf_warning("DIAGONAL(%d) does not do anything right now, it is ignored", nonmem2rx_omegaDiagonal);
    nonmem2rx_omegaDiagonal = NA_INTEGER;
    return 1;
  }
  return 0;
}

#endif // __omegaBlock__
