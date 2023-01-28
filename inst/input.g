//loop
statement_list : (statement)+ ;

drop_keyword: 'drop' | 'DROP' | 'Drop' | 'SKIP' | 'skip' | 'Skip';

drop_item: drop_keyword '=' identifier_nm | identifier_nm '=' drop_keyword | drop_keyword;

alias_item: identifier_nm '=' identifier_nm;

reg_item: identifier_nm;

statement: (drop_item | alias_item | reg_item) singleLineComment?;

whitespace: ( "[ \t\r\n]+")*;
singleLineComment: ';' "[^\n]*";
identifier_nm: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
