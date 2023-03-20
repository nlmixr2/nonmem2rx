//loop
statement_list : 
 (statement)+ ;

// return and exit statements not supported

statement 
  : call_protocol_phrase singleLineComment?
  | assignment singleLineComment?
  | if1 singleLineComment?
  | if1other singleLineComment?
  | ifthen singleLineComment?
  | ifcallrandom singleLineComment?
  | ifcallsimeps singleLineComment?
  | ifcallsimeta singleLineComment?
  | elseif singleLineComment?
  | else singleLineComment?
  | endif singleLineComment?
  | dowhile singleLineComment?
  | enddo singleLineComment?
  | ini singleLineComment?
  | iniI singleLineComment?
  | fbio singleLineComment?
  | alag singleLineComment?     
  | rate singleLineComment?
  | dur singleLineComment?
  | scale singleLineComment?
  | derivative singleLineComment?
  | derivativeI singleLineComment?
  | prob singleLineComment?
  | da singleLineComment?
  | dp singleLineComment?
  | callsimeta singleLineComment?
  | callgeteta singleLineComment?
  | callsimeps singleLineComment?
  | callpassmode singleLineComment?
  | callsupp singleLineComment?
  | callrandom singleLineComment?
  | exit_line singleLineComment?
  | comresn1 singleLineComment?
  | ifexit singleLineComment?
  | callfl singleLineComment?
  | nspop singleLineComment?
  | verbatimCode singleLineComment?
  | singleLineComment;


ini         :  'A_0(' decimalintNo0 ')' '=' logical_or_expression;
iniI        :  'A_0(' identifier ')' '=' logical_or_expression;
nspop       :  'NSPOP' '=' decimalintNo0;
fbio        : "[Ff]([0-9]+|O)" '='  logical_or_expression;
alag        : "[Aa][Ll][Aa][Gg][1-9][0-9]*" '=' logical_or_expression;
rate        : "[Rr][1-9][0-9]*" '=' logical_or_expression;
dur         : "[Dd][1-9][0-9]*" '=' logical_or_expression;
scale       : "[Ss]([0-9]+|C|O)" '=' logical_or_expression;
derivative  : ('DADT(' | 'dadt(' ) decimalintNo0 ')' '=' logical_or_expression;
derivativeI : ('DADT(' | 'dadt(' ) identifier ')' '=' logical_or_expression;
da          : ('DA(' | 'da(' ) decimalintNo0 ',' decimalintNo0 ')' '=' logical_or_expression;
dp          : ('DP(' | 'dp(' ) decimalintNo0 ',' decimalintNo0 ')' '=' logical_or_expression;
prob        : ('P(' | 'p(') decimalintNo0 ')' '=' logical_or_expression;

exit_line: 'EXIT' decimalint decimalint;
ifexit: 'IF' '(' logical_or_expression ')' 'EXIT' decimalint decimalint;
comresn1: 'COMRES' '=' '-' '1';
callfl: 'CALLFL' '=' ('-' ('1' | '2') | '0' | '1');

call_protocol_phrase: '(' ('OBSERVATION' 'EVENT'
        | 'OBS'
        | 'OBSERVATION' 'ONLY'
        | 'ONLY' 'OBSERVATION' 
        | 'ONLY' 'OBSERVATIONS' 
        | 'OBS' 'ONLY'
        | 'ONCE' 'PER' 'INDIVIDUAL' 'RECORD'
        | 'ONCE'
        | 'IND.' 'REC.'
        | 'IND' 'REC'
        | 'EVERY' 'EVENT'
        | 'EVERY'
        | 'NEW' 'TIME'
        | 'NEW' 'EVENT' 'TIME'
        ) ')';

if1 : 'IF' '(' logical_or_expression ')' identifier  '='  logical_or_expression;
if1other : 'IF' '(' logical_or_expression ')' (ini | iniI | fbio | alag | rate | dur | scale | derivative | derivativeI | da | dp | prob);


ifthen: 'IF' '(' logical_or_expression ')' 'THEN';
elseif: ('ELSEIF' | 'ELSE' 'IF') '(' logical_or_expression ')' 'THEN';
else: 'ELSE';
endif: ('ENDIF' | 'END' 'IF');
dowhile: 'DO' 'WHILE' '(' logical_or_expression ')';
enddo: ('ENDDO' | 'END' 'DO');

callsimeta: 'CALL' 'SIMETA' '(' 'ETA' ')';
ifcallsimeta: 'IF' '(' logical_or_expression ')' 'CALL' 'SIMETA' '(' 'ETA' ')';
callgeteta: 'CALL' 'GETETA' '(' 'ETA' ')';
callsimeps: 'CALL' 'SIMEPS' '(' 'EPS' ')';
ifcallsimeps:'IF' '(' logical_or_expression ')' 'CALL' 'SIMEPS' '(' 'EPS' ')';
callpassmode: 'CALL' 'PASS' '(' 'MODE' ')';
callsupp:   'CALL' 'SUPP' '(' "[01]" ',' "[01]" ')';
callrandom: 'CALL' 'RANDOM' '(' "(10|[1-9])" ',' 'R' ')';
ifcallrandom: 'IF' '(' logical_or_expression ')' 'CALL' 'RANDOM' '(' "(10|[1-9])" ',' 'R' ')';

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

theta_start: ('THETA(' | 'theta(' | "THETA +[(]");
theta : theta_start decimalintNo0 ')';
thetaI : theta_start identifier ')';
eta   : ('ETA(' | 'eta(') decimalintNo0 ')';
etaI   : ('ETA(' | 'eta(') identifier ')';
eps   : ('EPS(' | 'eps(') decimalintNo0 ')';
epsI   : ('EPS(' | 'eps(') identifier ')';
err   : ('ERR(' | 'err(') decimalintNo0 ')';
errI   : ('ERR(' | 'err(') identifier ')';
amt   : ('A(' | 'a(')  decimalintNo0 ')';
amtI  : ('A(' | 'a(')  identifier ')';
a0   : "[Aa][_][0][(]" decimalintNo0 ')';
a0i  : "[Aa][_][0][(]" identifier ')';
mtime : ('MTIME(' | 'mtime(') decimalintNo0 ')';
mnext : ('MNEXT(' | 'mext(') decimalintNo0 ')';
mpast : ('MPAST(' | 'mpast(') decimalintNo0 ')';
mixp  : ('MIXP(' | 'mixp(') decimalintNo0 ')';
mixpc : ('MIXP(' | 'mixp(') ('MIXNUM' | 'MIXEST')  ')';
com   : ('COM(' | 'com(') decimalintNo0 ')';
pcmt  : ('PCMT(' | 'pcmt(') decimalintNo0 ')';
sigma  : ('SIGMA(' | 'sigma(') decimalintNo0 ',' decimalintNo0 ')';
omega  : ('OMEGA(' | 'omega(') decimalintNo0 ',' decimalintNo0 ')';
sigma1  : ('SIGMA(' | 'sigma(') decimalintNo0 ')';
omega1  : ('OMEGA(' | 'omega(') decimalintNo0 ')';

avar:  "[Aa][0-9][0-9][0-9][0-9][0-9]";
cvar:  "[Cc][0-9][0-9][0-9][0-9][0-9]";


unary_expression : ('+' | '-')? (primary_expression | power_expression);

exponent_expression : ('+' | '-')? (primary_expression | power_expression);

power_expression : primary_expression power_operator exponent_expression;

power_operator   : '**';

fbioi        : "[Ff]([0-9]+|O)";
alagi        : "[Aa][Ll][Aa][Gg][1-9][0-9]*";
ratei        : "[Rr][1-9][0-9]*";
duri         : "[Dd][1-9][0-9]*";
scalei       : "[Ss]([0-9]+|C|O)";


primary_expression 
  : constant
  | a0
  | a0i
  | fbioi
  | alagi
  | ratei
  | duri
  | scalei
  | identifier
  | theta
  | thetaI
  | eta
  | etaI
  | eps
  | epsI
  | err
  | errI
  | dt
  | amt
  | amtI
  | mpast
  | mnext
  | mtime
  | mixp
  | mixpc
  | avar
  | cvar
  | com
  | pcmt
  | sigma
  | omega
  | sigma1
  | omega1
  | function
  | '(' logical_or_expression ')'
  ;

function : function_name (logical_or_expression)*  (',' logical_or_expression)* ')' ;

function_name: 'LOG(' | 'LOG10(' | 'EXP(' | 'SQRT(' | 'SIN(' | 'COS(' |
        'ABS(' |'TAN(' | 'ASIN(' | 'ACOS(' | 'ATAN(' | 'INT(' | 'MIN(' |
        'MAX(' |'MOD(' | 'PHI('  | 'GAMLN(' |
        'DLOG(' |'DLOG10(' | 'DEXP(' | 'DSQRT(' | 'DSIN(' | 'DCOS(' |
        'DABS(' |'DTAN(' | 'DASIN(' | 'DACOS(' | 'DATAN(' | 'DINT(' | 'DMIN(' |
        'DMAX(' |'DMOD(' | 'DPHI('  | 'DGAMLN(' |
        'log(' | 'log10(' | 'exp(' | 'sqrt(' | 'sin(' | 'cos(' |
        'abs(' |'tan(' | 'asin(' | 'acos(' | 'atan(' | 'int(' | 'min(' |
        'max(' |'mod(' | 'phi('  | 'gamln(' |
        'dlog(' |'dlog10(' |'dexp'  | 'dsqrt(' | 'dsin(' | 'dcos(' |
        'dabs(' |'dtan('   |'dasin(' | 'dacos(' | 'datan(' | 'dint(' | 'dmin(' |
        'dmax(' |'dmod('   |'dphi'  | 'dgamln(' |
        'Log(' | 'Log10(' | 'Exp(' | 'Sqrt(' | 'Sin(' | 'Cos(' |
        'Abs(' |'Tan(' | 'Asin(' | 'Acos(' | 'Atan(' | 'Int(' | 'Min(' |
        'Max(' |'Mod(' | 'Phi(' | 'Gamln('
    ;

constant : decimalint | float1 | float2;
dt    : ('DT(' | 'dt(') decimalintNo0 ')';


decimalintNo0: "([1-9][0-9]*)" $term -1;
decimalint: "0|([1-9][0-9]*)" $term -1;
string: "\"([^\"\\]|\\[^])*\"";
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
identifier: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
whitespace: ( "[ \t\r\n]+" | singleLineComment )*;
singleLineComment: "[;:]" "[^\n]*";
verbatimCode: '"' "[^\n]*";

