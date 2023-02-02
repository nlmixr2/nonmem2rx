//loop
statement_list : (statement)+ ;

statement: singleLineRecord |
  singleLineNoRecord;

singleLineRecord: "[ \t\r]*" "[$]" "[ \t\r]*" "[A-Za-z]+" "[^\n]*";
singleLineNoRecord: "[^$][^\n]*";
whitespace: "[\n]*";
