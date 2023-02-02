//loop
statement_list : (statement)+ ;

drop_keyword: 'drop' | 'DROP' | 'Drop' | 'SKIP' | 'skip' | 'Skip';

drop1: drop_keyword '=' identifier_nm;

drop2: identifier_nm '=' drop_keyword;

drop3: drop_keyword;

drop_item: drop1 | drop2 | drop3;

alias_item: identifier_nm '=' identifier_nm;

reg_item: identifier_nm;

statement: (drop_item | alias_item | reg_item);

whitespace: ( "[ \t\r\n]+" | singleLineComment)*;
singleLineComment: ';' "[^\n]*";
identifier_nm: "[a-zA-Z][a-zA-Z0-9_]*" $term -4;
