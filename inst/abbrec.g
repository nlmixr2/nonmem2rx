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
    ;

comres: 'COMRES' '='? ('0' | '-' '1' | decimalint);
comsav: 'COMSAV' '='? decimalint;
deirv1no: 'DERIV1' '=' 'NO';
deriv2: 'DERIV2' '=' ('NO' | 'NOCOMMON') ;
fastder: ('FASTDER' | 'NOFASTDER');
checkmu: ('CHECKMU' | 'NOCHECKMU');
desfull:  'DES' '='? ('COMPACT' |'FULL');
protect: 'PROTECT';

declare_item: 'INTEGER'? 'DOWHILE'? identifier_nm ('(' "[^,]*" (',' "[^,]*")* ')')?;

declare: 'DECLARE' (declare_item ','?)+;

function: 'FUNCTION' identifier_nm '(' (identifier_nm | '*') ',' decimalintNo0 (',' decimalintNo0)? ')';

replace: 'REPLACE'  (replace_multiple1
  | replace_multiple2
  | replace_data_par1
  | replace_data_par2
  | replace_data1
  | replace_data2
  | replace_direct1
  | replace_direct2) ;

var_replace: ('THETA' | 'ETA' | 'EPS' | 'ERR');

dec_arg: '(' decimalintNo0 (',' decimalintNo0)+ ')';
seq_nm: decimalintNo0 (':' | 'TO' | 'to' | 'To') decimalintNo0
        (('BY' | 'By' | 'by') decimalintNo0neg)?;
seq_arg: '(' ','* seq_nm (',' seq_nm)* ')';

replace_direct1: var_replace '(' identifier_nm_no ')' '=' var_replace '(' decimalintNo0 ')';

replace_direct2: identifier_nm '=' (identifier_nm | constantneg | string );

replace_data1: var_replace '(' identifier_nm_no ')' '=' var_replace dec_arg;
replace_data2: var_replace '(' identifier_nm_no ')' '=' var_replace seq_arg;

replace_multiple1:  var_replace '(' identifier_nm (',' identifier_nm)+ ')' '='
    var_replace dec_arg;
replace_multiple2:  var_replace '(' identifier_nm (',' identifier_nm)+ ')' '='
    var_replace  seq_arg;

replace_data_par1: var_replace '(' identifier_nm_no '_' identifier_nm_no ')' '='
     var_replace dec_arg;
replace_data_par2: var_replace '(' identifier_nm_no '_' identifier_nm_no ')' '='
     var_replace seq_arg;

constantneg: '-'? constant;

constant : decimalint | float1 | float2;

whitespace: ( "[ \t\r\n]+" | singleLineComment)*;
singleLineComment: ';' "[^\n]*";

string:  str_t1 | str_t2;
str_t1: "\'([^\'\\]|\\[^])*\'";
str_t2: "\"([^\"\\]|\\[^])*\"";
identifier_nm: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
identifier_nm_no: "[a-zA-Z][a-zA-Z0-9]*" $term -4;
decimalintNo0neg: "([-]?[1-9][0-9]*)" $term -1;
decimalintNo0: "([1-9][0-9]*)" $term -1;
decimalint: "0|([1-9][0-9]*)" $term -1;
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;

