//loop
statement_list : (statement)+ ;

statement: name_option ','*
    | theta_statement ','*
    | numberpointsLine ','*
    | abortInfo ','*
    | singleLineComment?;

abortInfo: 'ABORT' | 'NOABORT' | 'Abort' | 'Noabort' | 'abort' | 'noabort';

numberpoints: 'NUMBERPOINTS' | 'NUM' | 'NUMPTS' | 'NUMBERPTS' |
    'numberpoints' | 'num' | 'numpts' | 'numberpts' |
    'Numberpoints' | 'Num' | 'Numpts' | 'Numberpts';

numberpointsLine: numberpoints '=' decimalint singleLineComment?;

theta_name: identifier '=';
repeat: "[Xx]" decimalint;

theta_statement: theta_name? theta repeat? singleLineComment?;

theta: theta0 | theta1 | theta2 | theta3 | theta4 | theta5 | theta6 | theta7 | theta8;

theta0: ini_constant fixed?;

theta1: '(' theta0 ','?  ','? ')';
theta6: '(' ini_constant ','? ','? ')' fixed;

theta2: '(' low_ini ','? ini_constant ','? ')' fixed;
theta3: '(' low_ini ','? ini_constant ','? fixed? ','? ')' ;

theta4: '(' low_ini ','? ini_constant ','? hi_constant ')' fixed;
theta5: '(' low_ini ','? ini_constant ','? hi_constant fixed? ')' ;

theta7: '(' ini_constant ',' ',' ini_constant ')' ;

theta8: '(' ini_constant ',' ','? fixed ')';

name_id: 'NAMES' | 'NAME' |
        'names' | 'name' |
        'Names' | 'Name' ;

name_option:  name_id '(' identifier (',' identifier)* ')';

fixed: 'fixed'
 | 'FIXED'
 | 'FIX'
 | 'fix'
 | 'UNINT'
 | 'unint'
 | 'Unint' ;

infinite: 'INF' | 'inf' | 'Inf';

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
identifier: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
