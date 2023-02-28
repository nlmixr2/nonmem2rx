#define getLine nonmem2rx_err_getLine
#define _rxode2_reallyHasAfter _nonmem2rx_reallyHasAfter
#define trans_syntax_error_report_fn0 nonmem2rx_trans_syntax_error_report_fn0
#define printSyntaxErrorHeader nonmem2rx_printSyntaxErrorHeader
#define printPriorLines nonmem2rx_printPriorLines
#define printErrorInfo nonmem2rx_printErrorInfo
#define printErrorLineHighlightPoint nonmem2rx_printErrorLineHighlightPoint
#define trans_syntax_error_report_fn nonmem2rx_trans_syntax_error_report_fn
#define printLineNumberAlone nonmem2rx_printLineNumberAlone
#define printErrorLineHighlight1 nonmem2rx_printErrorLineHighlight1
#define printErrorLineHighligt2afterCol nonmem2rx_printErrorLineHighligt2afterCol
#define printErrorLineHighligt2after nonmem2rx_printErrorLineHighligt2after
#define printErrorLineHighlight2 nonmem2rx_printErrorLineHighlight2
#define printErrorLineHiglightRegion nonmem2rx_printErrorLineHiglightRegion
#define updateSyntaxCol nonmem2rx_updateSyntaxCol
#define record nonmem2rx_record

#define rx_suppress_syntax_info nonmem2rx_suppress_syntax_info
#define lastSyntaxErrorLine nonmem2rx_lastSyntaxErrorLine
#define isEsc nonmem2rx_isEsc
#define syntaxErrorExtra nonmem2rx_syntaxErrorExtra

char *getLine (char *src, int line, int *lloc) {
  int cur = 1, col=0, i;
  for(i = 0; src[i] != '\0' && cur != line; i++){
    if(src[i] == '\n') cur++;
  }
  for(col = 0; src[i + col] != '\n' && src[i + col] != '\0'; col++);
  *lloc=i+col;
  char *buf = R_Calloc(col + 1, char);
  memcpy(buf, src + i, col);
  buf[col] = '\0';
  return buf;
}

extern sbuf sbErr1;
extern sbuf sbErr2;
extern char *eBuf;
extern int eBufLast;
extern int syntaxErrorExtra;
extern int isEsc;
extern int rx_suppress_syntax_info;
extern int lastSyntaxErrorLine;
extern sbuf firstErr;
extern D_Parser *errP;
extern int lastSyntaxErrorLine;
extern int lastStrLoc;
extern const char *lastStr;
extern char * rc_dup_str(const char *s, const char *e);


extern int _rxode2_reallyHasAfter;

extern const char *record;

void trans_syntax_error_report_fn0(char *err){
  if (!rx_suppress_syntax_info){
    if (lastSyntaxErrorLine == 0){
      if (isEsc) {
        Rprintf(_("\033[1m%s record syntax error error:\n================================================================================\033[0m"),
                   record);
      }
      else {
        Rprintf(_("%s record syntax error error:\n================================================================================"), record);
      }
      lastSyntaxErrorLine=1;
    }
    if (isEsc) {
      Rprintf("\n\033[1m:ERR:\033[0m %s:\n",  err);
    }
    else {
      Rprintf("\n:ERR: %s:\n", err);
    }
  }
  if (firstErr.s[0] == 0) {
    sAppend(&firstErr, "%s", err);
  }
}

static inline void printSyntaxErrorHeader(void) {
  if (lastSyntaxErrorLine == 0){
    if (isEsc) {
      Rprintf(_("\033[1m%s record syntax error error:\n================================================================================\033[0m"), record);
    }
    else {
      Rprintf(_("%s record syntax error:\n================================================================================"), record);
    }
    lastSyntaxErrorLine=1;
  }
}

static inline void printPriorLines(Parser *p) {
  char *buf;
  for (; lastSyntaxErrorLine < p->user.loc.line; lastSyntaxErrorLine++){
    buf = getLine(eBuf, lastSyntaxErrorLine, &eBufLast);
    Rprintf("\n:%03d: %s", lastSyntaxErrorLine, buf);
    R_Free(buf);
  }
  if (lastSyntaxErrorLine < p->user.loc.line){
    Rprintf("\n");
    lastSyntaxErrorLine++;
  }
}

static inline void printErrorInfo(Parser *p, char *err, char *after, int printLine) {
  if (printLine) {
    if (isEsc) {
      Rprintf("\n\033[1m:%03d:\033[0m %s:\n", p->user.loc.line, err);
    }
    else {
      Rprintf("\n:%03d: %s:\n", p->user.loc.line, err);
    }
  } else {
    if (_rxode2_reallyHasAfter == 1 && after){
      if (isEsc){
        Rprintf(_("\n\n\033[1m%s syntax error after\033[0m '\033[35m\033[1m%s\033[0m':\n"),  record, after);
      }
      else {
        Rprintf(_("\n\n%s syntax error after '%s'\n"),  record, after);
      }
      if (firstErr.s[0] == 0) {
        sAppend(&firstErr, _("%s syntax error after '%s':\n"), record, after);
      }
    }
    else{
      if (isEsc){
        Rprintf(_("\n\n\033[1m%s syntax error\033[0m:\n"), record);
      }
      else{
        Rprintf(_("\n\n%s syntax error:\n"), record);
      }
      if (firstErr.s[0] == 0) {
        sAppend(&firstErr, "%s syntax error:\n", record);
      }
    }
  }
}

static inline void printErrorLineHighlightPoint(Parser *p) {
  char *buf = getLine(eBuf, p->user.loc.line, &eBufLast);
  sAppend(&sbErr1, "      ");
  int i, len = strlen(buf);
  for (i = 0; i < p->user.loc.col; i++){
    sAppend(&sbErr1, "%c", buf[i]);
    if (i == len-2) { i++; break;}
  }
  if (isEsc) {
    sAppend(&sbErr1, "\033[35m\033[1m%c\033[0m", buf[i++]);
  }
  else {
    sAppend(&sbErr1, "%c", buf[i++]);
  }
  for (; i < len; i++){
    sAppend(&sbErr1, "%c", buf[i]);
  }
  sAppend(&sbErr1, "\n      ");
  R_Free(buf);
  for (int i = 0; i < p->user.loc.col; i++){
    sAppendN(&sbErr1, " ", 1);
    if (i == len-2) { i++; break;}
  }
  if (isEsc) {
    sAppend(&sbErr1, "\033[35m\033[1m^\033[0m");
  }
  else {
    sAppend(&sbErr1, "^");
  }
  if (syntaxErrorExtra > 0 && syntaxErrorExtra < 40){
    for (int i = syntaxErrorExtra; i--;) {
      sAppend(&sbErr1, "~");
      _rxode2_reallyHasAfter=1;
    }
  }
  syntaxErrorExtra=0;
}

void trans_syntax_error_report_fn(char *err) {
  if (!rx_suppress_syntax_info){
    printSyntaxErrorHeader();
    Parser *p = (Parser *)errP;
    printPriorLines(p);
    sClear(&sbErr1);
    sClear(&sbErr2);
    _rxode2_reallyHasAfter = 0;
    printErrorLineHighlightPoint(p);
    printErrorInfo(p, err, 0, 1);
    Rprintf("%s", sbErr1.s);
  }
  if (firstErr.s[0] == 0) {
    sAppend(&firstErr, "%s", err);
  }
}

static inline void printLineNumberAlone(Parser *p) {
  if (isEsc) {
    sAppend(&sbErr1, "\033[1m:%03d:\033[0m ", p->user.loc.line);
  }
  else {
    sAppend(&sbErr1, ":%03d: ", p->user.loc.line);
  }
  if (firstErr.s[0] == 0) {
    sAppend(&sbErr2, ":%03d: ", p->user.loc.line);
  }
}

static inline void printErrorLineHighlight1(Parser *p, char *buf, char *after, int len) {
  int i;
  for (i = 0; i < p->user.loc.col; i++){
    sAppend(&sbErr1, "%c", buf[i]);
    if (firstErr.s[0] == 0) {
      sAppend(&sbErr2, "%c", buf[i]);
    }
    if (i == len-2) { i++; break;}
  }
  if (isEsc) {
    sAppend(&sbErr1, "\033[35m\033[1m%c\033[0m", buf[i++]);
  }
  else {
    sAppend(&sbErr1, "%c", buf[i++]);
  }
  if (firstErr.s[0] == 0) {
    sAppend(&sbErr2, "%c", buf[i-1]);
  }
  for (; i < len; i++){
    sAppend(&sbErr1, "%c", buf[i]);
    if (firstErr.s[0] == 0) {
      sAppend(&sbErr2, "%c", buf[i]);
    }
  }
}

static inline int printErrorLineHighligt2afterCol(Parser *p, char *buf, char *after, int len, int col) {
  if (!col || col == len) return 0;
  for (int i = 0; i < col; i++){
    sAppend(&sbErr1, " ");
    if (firstErr.s[0] == 0) {
      sAppendN(&sbErr2, " ", 1);
    }
    if (i == len-2) { i++; break;}
  }
  len = p->user.loc.col - col;
  if (len > 0 && len < 40){
    for (int i = len; i--;) {
      sAppend(&sbErr1, "~");
      _rxode2_reallyHasAfter=1;
      if (firstErr.s[0] == 0) {
        sAppendN(&sbErr2, "~", 1);
      }
    }
  }
  if (isEsc) {
    sAppend(&sbErr1, "\033[35m\033[1m^\033[0m");
  }
  else {
    sAppend(&sbErr1, "^");
  }
  if (firstErr.s[0] == 0) {
    sAppendN(&sbErr2, "^", 1);
  }
  return 1;
}

static inline void printErrorLineHighligt2after(Parser *p, char *buf, char *after, int len) {
  int col = 0, lenv = strlen(after);
  while (col != len && strncmp(buf + col, after, lenv) != 0) col++;
  if (col == len) col = 0;
  if (!printErrorLineHighligt2afterCol(p, buf, after, len, col)) {
    for (int i = 0; i < p->user.loc.col; i++){
      sAppend(&sbErr1, " ");
      if (firstErr.s[0] == 0) {
        sAppendN(&sbErr2, " ", 1);
      }
      if (i == len-2) { i++; break;}
    }
    if (isEsc) {
      sAppend(&sbErr1, "\033[35m\033[1m^\033[0m");
    }
    else {
      sAppend(&sbErr1, "^");
    }
    if (firstErr.s[0] == 0) {
      sAppendN(&sbErr2, "^", 1);
    }
  }
}

static inline void printErrorLineHighlight2(Parser *p, char *buf, char *after, int len) {
  sAppend(&sbErr1, "\n      ");
  if (firstErr.s[0] == 0) {
    sAppendN(&sbErr2, "\n      ", 7);
  }
  if (_rxode2_reallyHasAfter == 1 && after){
    printErrorLineHighligt2after(p, buf, after, len);
  } else {
    for (int i = 0; i < p->user.loc.col; i++){
      sAppendN(&sbErr1, " ", 1);
      if (firstErr.s[0] == 0) {
        sAppendN(&sbErr2, " ", 1);
      }
      if (i == len-2) { i++; break;}
    }
    if (isEsc) {
      sAppendN(&sbErr1, "\033[35m\033[1m^\033[0m", 14);
    }
    else {
      sAppendN(&sbErr1, "^", 1);
    }
    if (firstErr.s[0] == 0) {
      sAppendN(&sbErr2, "^", 1);
    }
  }
}

static inline void printErrorLineHiglightRegion(Parser *p, char *after) {
  char *buf = getLine(eBuf, p->user.loc.line, &eBufLast);
  if (lastSyntaxErrorLine < p->user.loc.line) lastSyntaxErrorLine++;
  printLineNumberAlone(p);
  int len= strlen(buf);
  printErrorLineHighlight1(p, buf, after, len);
  printErrorLineHighlight2(p, buf, after, len);
  R_Free(buf);
}


static void nonmem2rxSyntaxError(struct D_Parser *ap) {
  if (!rx_suppress_syntax_info){
    printSyntaxErrorHeader();
    Parser *p = (Parser *)ap;
    printPriorLines(p);
    char *after = 0;
    ZNode *z = p->snode_hash.last_all ? p->snode_hash.last_all->zns.v[0] : 0;
    while (z && z->pn->parse_node.start_loc.s == z->pn->parse_node.end)
      z = (z->sns.v && z->sns.v[0]->zns.v) ? z->sns.v[0]->zns.v[0] : 0;
    if (_rxode2_reallyHasAfter==1 && z && z->pn->parse_node.start_loc.s != z->pn->parse_node.end)
      after = rc_dup_str(z->pn->parse_node.start_loc.s, z->pn->parse_node.end);
    sClear(&sbErr1);
    sClear(&sbErr2);
    _rxode2_reallyHasAfter = 0;
    printErrorLineHiglightRegion(p, after);
    printErrorInfo(p, 0, after, 0);
    Rprintf("%s", sbErr1.s);
    if (firstErr.s[0] == 0) {
      sAppend(&firstErr, "\n%s", sbErr2.s);
      sAppendN(&firstErr, "\nmore errors could be listed above", 34);
    }
  }
}

void updateSyntaxCol(void) {
  int i = lastStrLoc, lineNum=1, colNum=0;
  for(i = 0; eBuf[i] != '\0' && lastStr != eBuf + i; i++){
    if(eBuf[i] == '\n'){
      lineNum++;
      colNum=0;
    } else {
      colNum++;
    }
  }
  lastStrLoc=i;
  Parser *p = (Parser *)errP;
  p->user.loc.line=lineNum;
  p->user.loc.col=colNum;
}

static inline void finalizeSyntaxError(void) {
  if (firstErr.s[0] != 0) {
    if(!rx_suppress_syntax_info){
      if (eBuf[eBufLast] != 0){
        eBufLast++;
        Rprintf("\n:%03d: ", lastSyntaxErrorLine);
        while (eBufLast != 0 && eBuf[eBufLast] != '\n') {
          eBufLast--;
        }
        for (; eBuf[eBufLast] != '\0'; eBufLast++){
          if (eBuf[eBufLast] == '\n'){
            Rprintf("\n:%03d: ", ++lastSyntaxErrorLine);
          } else{
            Rprintf("%c", eBuf[eBufLast]);
          }
        }
      }
      if (isEsc){
        Rprintf("\n\033[1m================================================================================\033[0m\n");
      }
      else {
        Rprintf("\n================================================================================\n");
      }
    }
    char *v= rc_dup_str(firstErr.s, 0);
    sClear(&firstErr);
    Rf_errorcall(R_NilValue, v);
  }
}
