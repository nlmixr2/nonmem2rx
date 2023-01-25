//loop
statement_list : (statement)+ ;

statement: singleLineRecord |
  singleLineNoRecord;

singleLineRecord: '$' "[A-Za-z]+" "[^\n]*";
singleLineNoRecord: "[^\n]*";
whitespace: ( "[ \t\r\n]+")*;
