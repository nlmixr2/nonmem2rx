//loop
statement_list : filename format_statement?
        (statement)*;

filename: filename_t1 | filename_t2 | filename_t3 | filename_t4;
filename_t1: "\'([^\'\\]|\\[^])*\'";
filename_t2: "\"([^\"\\]|\\[^])*\"";
filename_t3: "[^ '\"\n]+";
filename_t4: ("[^ .\n]+")+ '.'  "[A-Za-z0-9_]+";

// FORTRAN format specification, e.g. (3F10.0) or (2(F5.0,1X)); may span lines
format_statement: "\(([^()]|\(([^()]|\([^()]*\))*\))*\)";

ignore_name: "([Ii][Gg][Nn][Oo][Rr][Ee]|[Ii][Gg][Nn])";
// IGNORE=c (c cannot be "(" which starts an IGNORE list) or IGNORE c
ignore1_statement: ignore_name '=' "[^\n(]";
ignore1b_statement: ignore_name "[^\n(= \t]";
ignore1a_statement: ignore_name '='? "['\"]" "[^\n]" "['\"]";
ignore_statement: ignore_name '='? logic_bracket;
accept_statement: "([Aa][Cc][Cc][Ee][Pp][Tt])" '='? logic_bracket;
null_statement: "([Nn][Uu][Ll][Ll])" '='? (null_t1 | null_t2 | null_t3);
null_t1: "'[^\n]'";
null_t2: "\"[^\n]\"";
null_t3: "[^ \t\n;]";
wide_statement: "([Nn][Oo][Ww][Ii][Dd][Ee]|[Ww][Ii][Dd][Ee])";
checkout_statement: "([Cc][Hh][Ee][Cc][Kk][Oo][Uu][Tt]|[Cc][Hh][Ee][Cc][Kk][Dd][Aa][Tt][Aa])";
records_name: "([Nn][Rr][Ee][Cc][Oo][Rr][Dd][Ss]|[Rr][Ee][Cc][Oo][Rr][Dd][Ss]|[Nn][Rr][Ee][Cc][Ss]|[Rr][Ee][Cc][Ss])";
records_statement: records_name '='? decimalint;
records_label_statement: records_name '='? identifier_nm;
lrecl_statement: "([Ll][Rr][Ee][Cc][Ll])" '='? decimalint;
rewind_statement: "([Nn][Oo][Rr][Ee][Ww][Ii][Nn][Dd]|[Rr][Ee][Ww][Ii][Nn][Dd])";
noopen_statement: "([Nn][Oo][Oo][Pp][Ee][Nn])";
last20_statement: "([Ll][Aa][Ss][Tt]20)" '='? logic_constant;
blankok_statement: "([Bb][Ll][Aa][Nn][Kk][Oo][Kk])";
misdat_statement: "([Mm][Ii][Ss][Dd][Aa][Tt])" '='? logic_constant;
repl_statement: "([Rr][Ee][Pp][Ll])" '='? decimalint;
fdatacsv_statement: "([Nn][Oo][Ff][Dd][Aa][Tt][Aa][Cc][Ss][Vv]|[Ff][Dd][Aa][Tt][Aa][Cc][Ss][Vv])";
pred_ignore_data_statement: "([Pp][Rr][Ee][Dd]_[Ii][Gg][Nn][Oo][Rr][Ee]_[Dd][Aa][Tt][Aa])";

// TRANSLATE=(TIME/F[/D], II/F[/D]); TIME and II may be referred to by
// their $INPUT synonyms
translate_statement: "([Tt][Rr][Aa][Nn][Ss][Ll][Aa][Tt][Ee])" '='? '(' translate_item (','? translate_item)* ')';
translate_item: identifier_nm '/' translate_factor ('/' translate_digits)?;
translate_factor: constant;
translate_digits: constant;

logic_bracket: '(' simple_logic (','? simple_logic)* ')';
simple_logic: identifier_nm logic_compare logic_value;
logic_value: logic_constant | char_t1 | char_t2 | word_value;

char_t1: "\'([^\'\\]|\\[^])*\'";
char_t2: "\"([^\"\\]|\\[^])*\"";
// unquoted non-numeric value (compared as a character string)
word_value: "[^ \t\r\n,()'\"=<>/!.+\-][^ \t\r\n,()'\"]*" $term -5;

logic_compare: eq_expression_nm
    | neq_expression_nm
    | eqn_expression_nm
    | nen_expression_nm
    | lt_expression_nm
    | gt_expression_nm
    | ge_expression_nm
    | le_expression_nm;

eq_expression_nm: "(\.[Ee][Qq]\.)" | '==' | '=';
neq_expression_nm: "(\.[Nn][Ee]\.)" | '/=' | '!=';
eqn_expression_nm: "(\.[Ee][Qq][Nn]\.)";
nen_expression_nm: "(\.[Nn][Ee][Nn]\.)";
lt_expression_nm: '<' | "(\.[Ll][Tt]\.)";
gt_expression_nm: '>' | "(\.[Gg][Tt]\.)";
ge_expression_nm: '>='| "(\.[Gg][Ee]\.)";
le_expression_nm: '<='| "(\.[Ll][Ee]\.)";

statement: ignore1_statement
    | ignore1b_statement
    | ignore1a_statement
    | ignore_statement
    | accept_statement
    | null_statement
    | wide_statement
    | checkout_statement
    | records_statement
    | records_label_statement
    | lrecl_statement
    | rewind_statement
    | noopen_statement
    | last20_statement
    | blankok_statement
    | misdat_statement
    | repl_statement
    | fdatacsv_statement
    | pred_ignore_data_statement
    | translate_statement
    ;

logic_constant: ('-' | '+')? constant;
constant : decimalint | float1 | float2;

whitespace: ( "[ \t\r\n]+" | singleLineComment)*;
singleLineComment: ";[^\n]*";

identifier_nm: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
decimalint: "0|([1-9][0-9]*)" $term -1;
float1: "([0-9]+\.[0-9]*|[0-9]*\.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
