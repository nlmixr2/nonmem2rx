//loop
statement_list : (statement)+ ;

statement: advan_statement 
    | trans_statement
    | tol_statement
    | atol_statement
    | sstol_statement
    | ssatol_statement
    | unsupported_statement
    ;

advan_keyword: 'advan' | 'ADVAN' | 'Advan';
advan_statement1: advan_keyword '=' advan_keyword decimalintNo0;
advan_statement2: advan_keyword decimalintNo0;
advan_statement3: advan_keyword '=' decimalintNo0;
advan_statement:  advan_statement1 | advan_statement2 | advan_statement3;

trans_keyword: 'tran' | 'TRAN' | 'Tran' | 'trans' | 'TRANS' | 'Trans';
trans_statement1: trans_keyword '=' trans_keyword decimalintNo0;
trans_statement2: trans_keyword decimalintNo0;
trans_statement3: trans_keyword '=' decimalintNo0;
trans_statement:  trans_statement1 | trans_statement2 | trans_statement3;

tol_keyword:  'TOL' | 'tol' | 'Tol';
tol_statement1: tol_keyword '=' decimalintNo0;
tol_statement3: tol_keyword decimalintNo0;
tol_statement2: tol_keyword '=' nonSpace;
tol_statement: tol_statement1 | tol_statement2 | tol_statement3;

atol_keyword:  'ATOL' | 'atol' | 'Atol';
atol_statement1: atol_keyword '=' decimalintNo0;
atol_statement3: atol_keyword decimalintNo0;
atol_statement2: atol_keyword '=' nonSpace;
atol_statement: atol_statement1 | atol_statement2 | atol_statement3;

ssatol_keyword:  'SSATOL' | 'ssatol' | 'SsAtol' | 'Ssatol';
ssatol_statement1: ssatol_keyword '=' decimalintNo0;
ssatol_statement3: ssatol_keyword  decimalintNo0;
ssatol_statement2: ssatol_keyword '=' nonSpace;
ssatol_statement: ssatol_statement1 | ssatol_statement2 | ssatol_statement3;

sstol_keyword:  'SSTOL' | 'sstol' | 'SsTol' | 'Sstol';
sstol_statement1: sstol_keyword '=' decimalintNo0;
sstol_statement3: sstol_keyword decimalintNo0;
sstol_statement2: sstol_keyword '=' nonSpace;
sstol_statement: sstol_statement1 | sstol_statement2 | sstol_statement3;

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
nonSpace: "[^0-9 \n][^ \n]*";
identifier_nm: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
