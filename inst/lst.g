//loop
statement_list : (statement)+ ;

statement: theta_est_line
    | omega_est_line
    | sigma_est_line
    | omega_cor_line
    | sigma_cor_line
    | constant_line
    | compress_line
    | one_stop_line
    ;

theta_est_line: 'THETA - VECTOR OF FIXED EFFECTS PARAMETERS';
omega_est_line: 'OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS';
sigma_est_line: 'SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS';
omega_cor_line: 'OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS';
sigma_cor_line: 'SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS';
one_stop_line: '1';

compress_line: (compress_lab2)+;
compress_lab2:  compress_lab '|' compress_lab;
compress_lab: ('TH' decimalint | "OM[0-9][0-9][0-9][0-9]" | "SG[0-9][0-9][0-9][0-9]");
constant_line: '+'? (constant_item)+;

constant_item: est_label | est_label_new | constant | na_item;
na_item: '.........';

est_label: ('TH' | 'ETA' | 'ET' | 'EPS' | 'EP' | 'OM' | 'SG' ) "[0-9]+";

est_label_new: ('THETA' '(' identifier_nm ')' 
  | 'ETA' '(' identifier_nm ')'
  | 'EPS' '(' identifier_nm ')'
  | 'ERR' '(' identifier_nm ')'
  | 'ET_' identifier_nm
  | 'TH_' identifier_nm
  | 'EP_' identifier_nm
);

constant: '-'? (float1 | float2);
decimalintNo0: "([1-9][0-9]*)" $term -1;
decimalint: "0|([1-9][0-9]*)" $term -1;
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
whitespace: "[ \t\r\n*]+";
identifier_nm: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
