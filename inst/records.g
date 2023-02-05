//loop
statement_list : (statement)+ ;

statement: recLine | singleLineNoRecord;

recLine: singleLineRecord singleLineComment?;

singleLineRecord: "[ \t\r]*" "[$]" "[ \t\r]*" "[A-Za-z]+" "[^\n;$]*";
singleLineNoRecord: "[^$][^\n]*";
singleLineComment: ';' "[^\n]*";
