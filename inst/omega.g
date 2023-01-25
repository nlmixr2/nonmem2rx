//loop
statement_list : first? (statement)+ ;

diagonal: ('diagonal' | 'DIAGONAL') '(' decimalint ')';

block : ('block' | 'BLOCK');

blockn : block '(' decimalint ')';

same : 'SAME' | 'same';

blocknsame : blockn same;

blocksame : block same;

first: diagonal | block | blockn | blocknsame | blocksame;

statement: omega_statement  |
  singleLineComment?;

omega_statement: omega ','* singleLineComment?;

omega: omega0 | omega1 | omega2 ;

omega0: ini_constant fixed?;
omega1: '(' omega0 ')';
omega2: '(' fixed  ini_constant ')';

fixed: 'fixed' | 'FIXED' | 'FIX' | 'fix';

ini_constant: '-'? constant;

constant : decimalint | float1 | float2;


whitespace: ( "[ \t\r\n]+")*;
singleLineComment: ';' "[^\n]*";

decimalint: "0|([1-9][0-9]*)" $term -1;
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
