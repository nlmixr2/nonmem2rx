//loop
statement_list : filename
        (statement)*;

filename: filename_t1 | filename_t2 | filename_t3 | filename_t4;
filename_t1: "\'([^\'\\]|\\[^])*\'";
filename_t2: "\"([^\"\\]|\\[^])*\"";
filename_t3: "[^ '\"\n]+";
filename_t4: ("[^ .\n]+")+ '.'  "[A-Za-z0-9_]+";

ignore_name: ('IGNORE' | 'ignore' | 'Ignore' | 'ign' | 'Ign' | 'IGN');
ignore1_statement: ignore_name '='? "[^\n]";
ignore1a_statement: ignore_name '='? "['\"]" "[^\n]" "['\"]";
ignore_statement: ignore_name '='? logic_bracket;
accept_statement: ('ACCEPT' | 'accept' | 'Accept') '='? logic_bracket;
null_statement: 'NULL' '='? "[^\n]";
wide_statement: ('NOWIDE' | 'WIDE' | 'nowide' | 'wide' | 'Nowide' | 'Wide');
checkout_statement: ('CHECKOUT' | 'checkout' | 'Checkout' );
records_statement: ('RECORDS' | 'Records' | 'records') '='? decimalint;
lrecl_statement: ('LRECL' | 'lrecl' | 'Lrecl') '='? decimalint;
rewind_statement: ('NOREWIND' | 'REWIND' | 'norewind' | 'rewind' | 'Norewind' | 'Rewind');

logic_bracket: '(' (simple_logic | quote_logic)*  (',' (simple_logic | quote_logic))* ')';
simple_logic: identifier_nm logic_compare (identifier_nm | logic_constant);

char_t1: "\'([^\'\\]|\\[^])*\'";
char_t2: "\"([^\"\\]|\\[^])*\"";

quote_logic: identifier_nm (neq_expression_nm | eq_expression_nm) (char_t1 | char_t2);

logic_compare: eq_expression_nm
    | neq_expression_nm
    | lt_expression_nm
    | gt_expression_nm
    | ge_expression_nm
    | le_expression_nm;

eq_expression_nm: '.eq.' | '.EQ.' | '==' | '=' | '.eqn.' | '.EQN.';
neq_expression_nm: '.ne.' | '.NE.';
lt_expression_nm: '<' | '.lt.' | '.LT.';
gt_expression_nm: '>' | '.gt.' | '.GT.';
ge_expression_nm: '>='| '.ge.' | '.GE.';
le_expression_nm: '<='| '.le.' | '.LE.';


statement: ignore1_statement
    | ignore1a_statement
    | ignore_statement
    | accept_statement
    | null_statement
    | wide_statement
    | checkout_statement
    | records_statement
    | lrecl_statement
    | rewind_statement
    ;

logic_constant: '-'? constant;
constant : decimalint | float1 | float2;

whitespace: ( "[ \t\r\n]+" | singleLineComment)*;
singleLineComment: ';' "[^\n]*";

identifier_nm: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
decimalint: "0|([1-9][0-9]*)" $term -1;
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
