//loop
statement_list : (statement)+ ;
// noappend contains pred
// ,1PE11.4 = csv format
// firstonly = nodups

statement: identifier_nm 
    | paren_simple
    | etas_statement1
    | etas_statement2
    | format_statement
    | rformat_statement
    | ranmethod_statement
    | esample_statement
    | seed_statement
    | nosub_statement
    | parafile_statement
    | clockseed_statement
    | file_statement
    | idformat_statement
    | npdtype_statement
    | identifier_nm '=' identifier_nm
    ;

etas_paren_name: ('ETAS' | 'Etas' | 'etas' | 'ETA' | 'Eta' | 'eta') ;
paren_simple: ('ETA' | 'eta' | 'Eta' | 'VECTRA' | 'COM' | 'vectra' | 'com' | 'Vectra' | 'Com' ) '(' decimalintNo0 ')';
eta_num: (decimalintNo0 | 'LAST' | 'last'| 'Last');
etas_statement1: etas_paren_name '(' eta_num (':' | 'to' | 'TO' | 'To') eta_num (('BY' | 'by' | 'By') decimalintNegNo0 )? ')';
etas_statement2: etas_paren_name '(' eta_num  (',' eta_num )* ')';
format_statement: ('FORMAT' | 'format' | 'Format') '=' fortran_format;
rformat_statement: ('RFORMAT' | 'LFORMAT' | 'Rformat' | 'Lformat' | 'rformat' | 'lformat') '=' string;
ranmethod_statement: ('RANMETHOD' | 'Ranmethod' | 'ranmethod') '=' (decimalintNo0 | 'S' decimalintNo0 | 'm' decimalintNo0);
esample_statement: ('ESAMPLE' | 'esample' | 'Esample') '=' decimalintNo0;
seed_statement: ('SEED' | 'Seed' | 'seed') '=' decimalint;
nosub_statement: ('NOSUB' | 'nosub' | 'Nosub') '=' "[01]";
parafile_statement: ('PARAFILE' | 'Parafile' | 'parafile') '=' filename ;
clockseed_statement: ('CLOCKSEED' | 'clockseed' | 'Clockseed') '=' "[01]";
file_statement: ('FILE' | 'file' | 'File') '=' filename;
idformat_statement: ('IDFORMAT' | 'idformat' | 'Idformat') '=' fortran_format;
varcalc_statement: ('VARCALC' | 'varcalc' | 'Varcalc') '=' "[0-3]";
fixedetas_statement: ('FIXEDETAS' | 'fixedetas' | 'Fixedetas') '=' '(' decimalintNo0 ('-' decimalintNo0)* (',' decimalintNo0 ('-' decimalintNo0)*)* ')';

npdtype_statement: ('NPDTYPE' | 'Npdtype' | 'npdtype') '=' "[01]";

fortran_format: "[^ \t\r\n]+"; // for now be simple


decimalintNegNo0: '-'? decimalintNo0;
decimalintNo0: "([1-9][0-9]*)" $term -1;
decimalint: "0|([1-9][0-9]*)" $term -1;
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;

filename: filename_t1 | filename_t2 | filename_t3;
filename_t1: "\'([^\'\\]|\\[^])*\'";
filename_t2: "\"([^\"\\]|\\[^])*\"";
filename_t3: "[^ '\"\n]+";
string: string1 | string2;
string1: "\'([^\'\\]|\\[^])*\'";
string2: "\"([^\"\\]|\\[^])*\"";
whitespace: ( "[ \t\r\n]+" | singleLineComment)*;
singleLineComment: ';' "[^\n]*";
identifier_nm: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
