//loop
statement_list : model_statement? singleLineComment*
        (comp_statement)+
    link_statement*  singleLineComment*;

ncmt_name: ('NCOMPARTMENTS' | 'ncompartments' | 'NCOMP' | 'ncomp');

ncpt_statement: ncmt_name '=' decimalint ','? singleLineComment?;

comp_name: 'COMP' | 'comp' | 'COMPARTMENT' | 'compartment';

comp_option: identifier_nm;

comp_statement_1: comp_name '=' '(' identifier_nm  comp_option? ')' ','? ;
comp_statement_2: comp_name ','? ;

comp_statement: (comp_statement_1 | comp_statement_2) singleLineComment?;

model_statement: ncpt_statement | comp_statement;

link_statement: link_keyword link_cmt to_keyword link_cmt decimalint decimalint? singleLineComment?;
link_cmt: identifier_nm | decimalint;
to_keyword: 'TO' | 'to' | 'AND' | 'and' | ;
link_keyword: 'K' | 'k' | 'link' | 'LINK';
by_keyword: 'BY' | 'by' | '=' | 'IS' | 'is';

statement: comp_statement |
  singleLineComment?;


constant : decimalint | float1 | float2;


whitespace: ( "[ \t\r\n]+")*;
singleLineComment: ';' "[^\n]*";

identifier_nm: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
decimalint: "0|([1-9][0-9]*)" $term -1;
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
