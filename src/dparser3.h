#ifndef __dparser3_H__
#define __dparser3_H__
#define __dparser_H__
#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>
#include <Rconfig.h>
#include <R_ext/Rdynload.h>
#include "gramgram.h"
#include "d.h"
#include "mkdparse.h"
#include "dparse.h"
#include "read_binary.h"
#if defined(__cplusplus)
extern "C" {
#endif
  extern D_Parser *new_D_Parser(struct D_ParserTables *t, int sizeof_ParseNode_User);
  extern void free_D_Parser(D_Parser *p);
  extern D_ParseNode *dparse(D_Parser *p, char *buf, int buf_len);
  extern void free_D_ParseNode(D_Parser *p, D_ParseNode *pn);
  extern void free_D_ParseTreeBelow(D_Parser *p, D_ParseNode *pn);
  extern int d_get_number_of_children(D_ParseNode *pn);
  extern D_ParseNode *d_get_child(D_ParseNode *pn, int child);
  extern D_ParseNode *d_find_in_tree(D_ParseNode *pn, int symbol);
  extern char  * d_ws_before (D_Parser *p, D_ParseNode *pn);
  extern char   *  d_ws_after  (D_Parser *p, D_ParseNode *pn);
  extern void d_pass(D_Parser *p, D_ParseNode *pn, int pass_number);
  extern int resolve_amb_greedy(D_Parser *dp, int n, D_ParseNode **v);
  extern char *d_dup_pathname_str(const char *str);
  extern void parse_whitespace(struct D_Parser *p, d_loc_t *loc, void **p_globals);
  extern D_Scope *new_D_Scope(D_Scope *parent);
  extern D_Scope *enter_D_Scope(D_Scope *current, D_Scope *scope);
  extern D_Scope *commit_D_Scope(D_Scope *scope);
  extern D_Scope *equiv_D_Scope(D_Scope *scope);
  extern D_Scope *global_D_Scope(D_Scope *scope);
  extern D_Scope *scope_D_Scope(D_Scope *current, D_Scope *scope);
  extern void free_D_Scope(D_Scope *st, int force);
  extern D_Sym *new_D_Sym(D_Scope *st, char *name, char *end, int sizeof_D_Sym);
  extern D_Sym *find_D_Sym(D_Scope *st, char *name, char *end);
  extern D_Sym *find_global_D_Sym(D_Scope *st, char *name, char *end);
  extern D_Sym *update_D_Sym(D_Sym *sym, D_Scope **st, int sizeof_D_Sym);
  extern D_Sym *update_additional_D_Sym(D_Scope *st, D_Sym *sym, int sizeof_D_Sym);
  extern D_Sym *current_D_Sym(D_Scope *st, D_Sym *sym);
  extern D_Sym *find_D_Sym_in_Scope(D_Scope *st, D_Scope *cur, char *name, char *end);
  extern D_Sym *next_D_Sym_in_Scope(D_Scope **st, D_Sym **sym);
  extern void print_scope(D_Scope *st);
  extern Grammar *new_D_Grammar(char *pathname);
  extern void free_D_Grammar(Grammar *g);
  extern int build_grammar(Grammar *g);
  extern int parse_grammar(Grammar *g, char *pathname, char *str);
  extern void print_grammar(Grammar *g);
  extern void print_rdebug_grammar(Grammar *g, char *pathname);
  extern void print_states(Grammar *g);
  extern void print_rule(Rule *r);
  extern void print_term(Term *t);
  extern Production *lookup_production(Grammar *g, char *name, uint len);
  extern Rule *new_rule(Grammar *g, Production *p);
  extern Elem *new_elem_nterm(Production *p, Rule *r);
  extern void new_declaration(Grammar *g, Elem *e, uint kind);
  extern Production *new_production(Grammar *g, char *name);
  extern Elem *new_string(Grammar *g, char *s, char *e, Rule *r);
  extern Elem *new_utf8_char(Grammar *g, char *s, char *e, Rule *r);
  extern Elem *new_ident(char *s, char *e, Rule *r);
  extern void new_token(Grammar *g, char *s, char *e);
  extern Elem *new_code(Grammar *g, char *s, char *e, Rule *r);
  extern void add_global_code(Grammar *g, char *start, char *end, int line);
  extern Production *new_internal_production(Grammar *g, Production *p);
  extern Elem *dup_elem(Elem *e, Rule *r);
  extern void add_declaration(Grammar *g, char *start, char *end, uint kind, uint line);
  extern void add_pass(Grammar *g, char *start, char *end, uint kind, uint line);
  extern void add_pass_code(Grammar *g, Rule *r, char *pass_start, char *pass_end, char *code_start, char *code_end, uint line, uint pass_line);
  extern D_Pass *find_pass(Grammar *g, char *start, char *end);
  extern void   conditional_EBNF (Grammar *g );
  extern void star_EBNF (Grammar *g);
  extern void plus_EBNF (Grammar *g );
  extern void rep_EBNF(Grammar *g, int minimum, int maximum);
  extern void initialize_productions(Grammar *g);
  extern uint state_for_declaration(Grammar *g, uint iproduction);
  extern void build_scanners(struct Grammar *g);
  extern void build_LR_tables(Grammar *g);
  extern void sort_VecAction(VecAction *v);
  extern uint elem_symbol(Grammar *g, Elem *e);
  extern State *goto_State(State *s, Elem *e);
  extern void free_Action(Action *a);
  extern void mkdparse(struct Grammar *g, char *grammar_pathname);
  extern void mkdparse_from_string(struct Grammar *g, char *str);
  extern D_ParseNode *ambiguity_count_fn(D_Parser *pp, int n, D_ParseNode **v);
  extern BinaryTables *read_binary_tables(char *file_name, D_ReductionCode spec_code, D_ReductionCode final_code);
  extern BinaryTables *read_binary_tables_from_file(FILE *fp, D_ReductionCode spec_code, D_ReductionCode final_code);
  extern BinaryTables *read_binary_tables_from_string(unsigned char *buf, D_ReductionCode spec_code, D_ReductionCode final_code);
  extern void free_BinaryTables(BinaryTables *binary_tables);
  extern int scan_buffer(d_loc_t *loc, D_State *st, ShiftResult *result);
  extern void vec_add_internal(void *v, void *elem);
  extern int vec_eq(void *v, void *vv);
  extern int set_find(void *v, void *t);
  extern int set_add(void *v, void *t);
  extern int set_union(void *v, void *vv);
  extern void set_union_fn(void *v, void *vv, hash_fns_t *fns);
  extern void set_to_vec(void *av);
  extern int buf_read(const char *pathname, char **buf, int *len);
  extern char *sbuf_read(const char *pathname);
  extern char *dup_str(const char *str, const char *end);
  extern uint strhashl(const char *s, int len);
  extern void d_free(void *x);
  extern void int_list_diff(int *a, int *b, int *c);
  extern void int_list_intersect(int *a, int *b, int *c);
  extern int *int_list_dup(int *aa);
  extern char *escape_string(char *s);
  extern char *escape_string_single_quote(char *s);
  extern int write_c_tables(Grammar *g);
  extern int write_binary_tables(Grammar *g);
  extern int write_binary_tables_to_file(Grammar *g, FILE *fp);
  extern int write_binary_tables_to_string(Grammar *g, unsigned char **str, unsigned int *str_len);
  extern void set_d_use_r_headers(int x);
  extern void set_d_rdebug_grammar_level(int x);
  extern void set_d_use_file_name(int x);
  extern void set_d_verbose_level(int x);
  extern void set_d_debug_level(int x);
  //extern int get_d_use_r_headers();
  //extern int get_d_rdebug_grammar_level();
  //extern int get_d_use_file_name();
  //extern int get_d_verbose_level();
  //extern int get_d_debug_level();
  extern void set_d_file_name(char *x);
  extern void d_fail(const char *str, ...);
  extern void d_warn(const char *str, ...);
#if defined(__cplusplus)
}
#endif
#endif
