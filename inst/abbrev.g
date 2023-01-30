//loop
statement_list : (statement)+ ;

// return and exit statements not supported

statement 
  : assignment
  | if1
  | ifthen
  | elseif
  | else
  | endif
  | dowhile
  | enddo
  | ini       
  | fbio      
  | alag      
  | rate      
  | dur       
  | scale     
  | derivative
  | da        
  | dp
  | callsimeta
  | callsimeps
  | callpassmode
  | callrandom
  | exit_line
  | comresn1
  | ifexit
  | callfl
  | verbatimCode;


ini         :  'A_0' '(' decimalintNo0 ')' '=' logical_or_expression;
fbio        : "[Ff]([0-9]+|O)" '='  logical_or_expression;
alag        : "[Aa][Ll][Aa][Gg][1-9][0-9]*" '=' logical_or_expression;
rate        : "[Rr][1-9][0-9]*" '=' logical_or_expression;
dur         : "[Dd][1-9][0-9]*" '=' logical_or_expression;
scale       : "[Ss]([0-9]+|C)" '=' logical_or_expression;
derivative  : "[Dd][Aa][Dd][Tt]" '(' decimalintNo0 ')' '=' logical_or_expression;
da          : "[Dd][Aa]" '(' decimalintNo0 ',' decimalintNo0 ')' '=' logical_or_expression;
dp          : "[Dd][Pp]" '(' decimalintNo0 ',' decimalintNo0 ')' '=' logical_or_expression;

exit_line: 'EXIT' decimalint decimalint;
ifexit: 'IF' '(' logical_or_expression ')' 'EXIT' decimalint decimalint;
comresn1: 'COMRES' '=' '-' '1';
callfl: 'CALLFL' '=' ('-' ('1' | '2') | '0' | '1'); 

if1 : 'IF' '(' logical_or_expression ')' identifier  '='  logical_or_expression;
ifthen: 'IF' '(' logical_or_expression ')' 'THEN';
elseif: 'ELSEIF' '(' logical_or_expression ')' 'THEN';
else: 'ELSE';
endif: 'ENDIF';
dowhile: 'DO' 'WHILE' '(' logical_or_expression ')';
enddo: 'ENDDO';

callsimeta: 'CALL' 'SIMETA' '(' 'ETA' ')';
callsimeps: 'CALL' 'SIMEPS' '(' 'EPS' ')';
callpassmode: 'CALL' 'PASS' '(' 'MODE' ')';
callsupp:   'CALL' 'SUPP' '(' "[01]" ',' "[01]" ')';
callrandom: 'CALL' 'RANDOM' '(' "(10|[1-9])" ',' 'R' ')';

assignment : identifier  '='  logical_or_expression;

logical_or_expression : logical_and_expression 
    (or_expression_nm  logical_and_expression)* ;

or_expression_nm: '.or.' | '.OR.';

logical_and_expression : equality_expression0 
    (and_expression_nm equality_expression0)* ;

and_expression_nm: '.and.' | '.AND.';

equality_expression0 : equality_expression |
    '(' equality_expression ')';

equality_expression : relational_expression 
    ((neq_expression_nm | eq_expression_nm ) relational_expression)* ;

eq_expression_nm: '.eq.' | '.EQ.' | '==';
neq_expression_nm: '.ne.' | '.NE.';

relational_expression : additive_expression
    ((lt_expression_nm | gt_expression_nm | le_expression_nm | ge_expression_nm) additive_expression)* ;

lt_expression_nm: '<' | '.lt.' | '.LT.';
gt_expression_nm: '>' | '.gt.' | '.GT.';
ge_expression_nm: '>='| '.ge.' | '.GE.';
le_expression_nm: '<='| '.le.' | '.LE.';

additive_expression : multiplicative_expression
    (('+' | '-') multiplicative_expression)* ;

multiplicative_expression : unary_expression 
    (mult_part)* ;

mult_part : ('*' | '/') unary_expression ;

theta : ('THETA' | 'theta') '(' decimalintNo0 ')';
eta   : ('ETA' | 'eta') '(' decimalintNo0 ')';
eps   : ('EPS' | 'eps') '(' decimalintNo0 ')';
err   : ('ERR' | 'err') '(' decimalintNo0 ')';
dt    : ('DT' | 'dt') '(' decimalintNo0 ')';
amt   : ('A' | 'a') '(' decimalintNo0 ')';
mtime : ('MTIME' | 'mtime') '(' decimalintNo0 ')';
mnext : ('MNEXT' | 'mext') '(' decimalintNo0 ')';
mpast : ('MPAST' | 'mpast') '(' decimalintNo0 ')';
mixp : ('MIXP' | 'mixp') '(' decimalintNo0 ')';


unary_expression : ('+' | '-')? (theta | eta | eps | err | dt | amt | mtime | mnext | mpast | mixp | primary_expression | power_expression );

exponent_expression : ('+' | '-')? (theta | eta | eps | err | dt | amt | mtime | mnext | mpast | mixp | primary_expression | power_expression );

power_expression : primary_expression power_operator exponent_expression;

power_operator   : '**';

primary_expression 
  : constant
  | identifier
  | theta
  | eta
  | eps
  | err
  | dt
  | amt
  | mpast
  | mnext
  | mtime
  | mixp        
  | function
  | '(' logical_or_expression ')'
  ;

function : function_name '(' (logical_or_expression)* (',' logical_or_expression)* ')' ;

function_name: 'LOG' | 'LOG10' | 'EXP' | 'SQRT' | 'SIN' | 'COS' |
        'ABS' |'TAN' | 'ASIN' | 'ACOS' | 'ATAN' | 'INT' | 'MIN' |
        'MAX' |'MOD' | 'PHI'  | 'GAMLN' |
        'log' | 'log10' | 'exp' | 'sqrt' | 'sin' | 'cos' |
        'abs' |'tan' | 'asin' | 'acos' | 'atan' | 'int' | 'min' |
        'max' |'mod' | 'phi'  | 'gamln' |
        'Log' | 'Log10' | 'Exp' | 'Sqrt' | 'Sin' | 'Cos' |
        'Abs' |'Tan' | 'Asin' | 'Acos' | 'Atan' | 'Int' | 'Min' |
        'Max' |'Mod' | 'Phi'  | 'Gamln'
    ;

constant : decimalint | float1 | float2;

theta : ('THETA' | 'theta') '(' decimalintNo0 ')';
eta   : ('ETA' | 'eta') '(' decimalintNo0 ')';
eps   : ('EPS' | 'eps') '(' decimalintNo0 ')';
err   : ('ERR' | 'err') '(' decimalintNo0 ')';
dt    : ('DT' | 'dt') '(' decimalintNo0 ')';
amt   : ('A' | 'a') '(' decimalintNo0 ')';
mtime : ('MTIME' | 'mtime') '(' decimalintNo0 ')';
mnext : ('MNEXT' | 'mext') '(' decimalintNo0 ')';
mpast : ('MPAST' | 'mpast') '(' decimalintNo0 ')';
mixp : ('MIXP' | 'mixp') '(' decimalintNo0 ')';


decimalintNo0: "([1-9][0-9]*)" $term -1;
decimalint: "0|([1-9][0-9]*)" $term -1;
string: "\"([^\"\\]|\\[^])*\"";
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
identifier: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
whitespace: ( "[ \t\r\n]+" | singleLineComment )*;
singleLineComment: ';' "[^\n]*";
verbatimCode: '"' "[^\n]*";

