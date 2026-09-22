//loop
statement_list : (statement)+ ;

// Each statement is a single token, never a list of them.  A
// `constant_line : '+'? (constant_item)+` under `(statement)+` lets any run of
// numbers be cut into lines in exponentially many ways, and dparser's
// greediness disambiguation re-walks the whole tree at every split point --
// that made a `.lst` covariance block cubic in its size.  Nothing in
// `wprint_parsetree_lst` looks at the line grouping, only at the individual
// `constant`/`na_item` nodes, so flattening it is free.
statement: theta_est_line
    | omega_est_line
    | sigma_est_line
    | omega_cor_line
    | sigma_cor_line
    | constant_item
    | compress_lab2
    | plus_item
    | one_stop_line
    ;

theta_est_line: 'THETA - VECTOR OF FIXED EFFECTS PARAMETERS';
omega_est_line: 'OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS';
sigma_est_line: 'SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS';
omega_cor_line: 'OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS';
sigma_cor_line: 'SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS';
one_stop_line: '1';

compress_lab2:  compress_lab '|' compress_lab;
compress_lab: ('TH' decimalint | "OM[0-9][0-9][0-9][0-9]" | "SG[0-9][0-9][0-9][0-9]");
plus_item: '+';

constant_item: est_label | est_label_new | constant | na_item;
na_item: '.........';

est_label: ('TH' | 'ETA' | 'ET' | 'EPS' | 'EP' | 'OM' | 'SG' ) decimalintY0;

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
decimalintY0: "([0-9][0-9]*)" $term -1;
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
whitespace: "[ \t\r\n*]+";
identifier_nm: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
