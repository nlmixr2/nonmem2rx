//loop
statement_list : (statement)+ ;

statement: advan_statement 
    | trans_statement
    | tol_statement
    | unsupported_statement
    ;

advan_keyword: 'advan' | 'ADVAN' | 'Advan';
advan_statement1: advan_keyword '=' advan_keyword decimalintNo0;
advan_statement2: advan_keyword decimalintNo0;
advan_statement:  advan_statement1 | advan_statement2;

trans_keyword: 'tran' | 'TRAN' | 'Tran' | 'trans' | 'TRANS' | 'Trans';
trans_statement1: trans_keyword '=' trans_keyword decimalintNo0;
trans_statement2: trans_keyword decimalintNo0;
trans_statement:  trans_statement1 | trans_statement2;

tol_keyword:  'TOL' | 'tol' | 'Tol';
tol_statement1: tol_keyword '=' decimalintNo0;
tol_statement2: tol_keyword '=' nonSpace;
tol_statement: tol_statement1 | tol_statement2;

unsupported_subnames: 'SS' | 'PK' | 'ERROR' | 'DES' | 'AES' | 'INFN' | 'MODEL'
    'ss' | 'pk' | 'error' | 'des' | 'aes' | 'infn' | 'model' |
    'Ss' | 'Pk' | 'Error' | 'Des' | 'Aes' | 'Infn' | 'Model';

unsupported_statement: unsupported_subnames '=' nonSpace;

decimalintNo0: "([1-9][0-9]*)" $term -1;
decimalint: "0|([1-9][0-9]*)" $term -1;
string: "\"([^\"\\]|\\[^])*\"";
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
whitespace: ( "[ \t\r\n]+" | singleLineComment )*;
singleLineComment: ';' "[^\n]*";
nonSpace: "[^ \n]+";
identifier_nm: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
