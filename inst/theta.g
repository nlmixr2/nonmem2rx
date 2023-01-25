//loop
statement_list : (statement)+ ;

statement: theta_statement ','* |
  numberpointsLine ','* |
  abortInfo ','* |
  singleLineComment?;

abortInfo: 'ABORT' | 'NOABORT';

numberpoints: 'NUMBERPOINTS' | 'NUM' | 'NUMPTS' | 'NUMBERPTS' ;

numberpointsLine: numberpoints '=' decimalint singleLineComment?;

theta_statement:  theta singleLineComment?;

theta: theta0 | theta1 | theta2 | theta3 | theta4 | theta5 ;

theta0: ini_constant fixed?;
theta1: '(' theta0 ')';

theta2: '(' low_ini ','? ini_constant ')' fixed?;
theta3: '(' low_ini ','? ini_constant fixed? ')' ;

theta4: '(' low_ini ','? ini_constant ','? hi_constant ')' fixed?;
theta5: '(' low_ini ','? ini_constant ','? hi_constant fixed? ')' ;


fixed: 'fixed' | 'FIXED' | 'FIX' | 'fix';

infinite: 'INF' | 'inf';

low_ini:  '-' infinite | ini_constant;

hi_constant: infinite | ini_constant;

ini_constant: '-'? constant;

constant : decimalint | float1 | float2;


whitespace: ( "[ \t\r\n]+")*;
singleLineComment: ';' "[^\n]*";

decimalint: "0|([1-9][0-9]*)" $term -1;
string: "\"([^\"\\]|\\[^])*\"";
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
