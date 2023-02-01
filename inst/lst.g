//loop
statement_list : (statement)+ ;

statement: theta_est_line
    | omega_est_line
    | sigma_est_line
    | omega_cor_line
    | sigma_cor_line
    | constant_line
    | one_stop_line
    | blank_line
    ;

theta_est_line: 'THETA' '-' 'VECTOR' ".*";
omega_est_line: 'OMEGA' '-' 'COV' ".*";
sigma_est_line: 'SIGMA' '-' 'COV' ".*";
omega_cor_line: 'OMEGA' '-' 'COR' ".*";
sigma_cor_line: 'SIGMA' '-' 'COR' ".*";
one_stop_line: '1';
blank_line: "[ ]+";

constant_line: '+'? (constant_item)+;

constant_item: constant | na_item;

na_item: '.........';

th_label: 'TH' decimalint;
eta_label: 'ETA' decimalint;
eps_label: 'EPS' decimalint;

constant : decimalint | float1 | float2;
decimalintNo0: "([1-9][0-9]*)" $term -1;
decimalint: "0|([1-9][0-9]*)" $term -1;
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
whitespace: "[ \t\r\n]+";


