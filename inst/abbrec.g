//loop
statement_list : (statement)*;

statement: comres
    | comsav
    | deirv1no
    | deriv2
    | fastder
    | checkmu
    | declare
    | protect
    | function
    | replace
    | desfull
    ;

comres: 'COMRES' '='? ('0' | '-' '1' | decimalint);
comsav: 'COMSAV' '='? decimalint;
deirv1no: 'DERIV1' '=' 'NO';
deriv2: 'DERIV2' '=' ('NO' | 'NOCOMMON') ;
fastder: ('FASTDER' | 'NOFASTDER');
checkmu: ('CHECKMU' | 'NOCHECKMU');
desfull:  'DES' '='? ('COMPACT' |'FULL');
protect: 'PROTECT';

declare_item: 'INTEGER'? 'DOWHILE'? identifier_nm ('(' "[^,)]*" (',' "[^,)]*")* ')')?;

declare: 'DECLARE' (declare_item ','*)+;

function: 'FUNCTION' identifier_nm '(' (identifier_nm | '*') ',' decimalintNo0 (',' decimalintNo0)? ')';

replace: 'REPLACE'  (replace_multiple
  | replace_data
  | replace_direct1
  | replace_direct2
  | replace_direct3);

var_replace: ('THETA' | 'ETA' | 'EPS' | 'ERR' | 'A' | 'DADT');

// clearly states these are the only variables permitted in the data selection types
var_rep2: ('THETA' | 'ETA' | 'EPS');

dec_arg: '(' decimalint (',' decimalint)+ ')';
seq_nm: decimalint (':' | 'TO' | 'to' | 'To') decimalint
        (('BY' | 'By' | 'by') decimalintNo0neg)?;
seq_arg: '(' ','* (seq_nm | decimalint)  (',' (seq_nm | decimalint))* ')';

replace_direct1: var_replace '(' identifier_nm ')' '=' var_replace '(' decimalintNo0 ')';
replace_direct2: identifier_nm '=' (identifier_nm | constantneg | var_replace '(' decimalintNo0 ')');
replace_direct3: identifier_nm '=' string;

replace_data: var_rep2 '(' identifier_nm ')' '=' var_rep2 (seq_arg | dec_arg);

replace_multiple:  var_replace '(' identifier_nm (',' identifier_nm)+ ')' '='
    var_replace (dec_arg | seq_arg );

constantneg: '-'? constant;

constant : decimalint | float1 | float2;

whitespace: ( "[ \t\r\n]+" | singleLineComment)*;
singleLineComment: ';' "[^\n]*";

string:  str_t1 | str_t2;
str_t1: "\'([^\'\\]|\\[^])*\'";
str_t2: "\"([^\"\\]|\\[^])*\"";
identifier_nm: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
decimalintNo0neg: "([-]?[1-9][0-9]*)" $term -1;
decimalintNo0: "([1-9][0-9]*)" $term -1;
decimalint: "0|([1-9][0-9]*)" $term -1;
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
