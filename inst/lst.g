//loop
statement_list : (statement)+ ;

statement: theta_est_line
    | omega_est_line
    | sigma_est_line
    | omega_cor_line
    | sigma_cor_line
    | constant_line
    | one_stop_line
    ;

theta_est_line: 'THETA - VECTOR OF FIXED EFFECTS PARAMETERS';
omega_est_line: 'OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS';
sigma_est_line: 'SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS';
omega_cor_line: 'OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS';
sigma_cor_line: 'SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS';
one_stop_line: '1';

constant_line: '+'? (constant_item)+;

constant_item: est_label | constant | na_item;

na_item: '.........';

est_label: ('TH' | 'ETA' | 'EPS') decimalint;

constant : float1 | float2;
decimalintNo0: "([1-9][0-9]*)" $term -1;
decimalint: "0|([1-9][0-9]*)" $term -1;
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
whitespace: "[ \t\r\n*]+";


