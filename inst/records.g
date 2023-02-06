//loop
statement_list : (statement)+ ;

statement: problemLineRecord | recLine | singleLineNoRecord;

recLine: singleLineRecord singleLineComment?;

problemLineRecord: "[ \t\r]*" "[$]" "[ \t\r]*" "[Pp][Rr][Oo][A-Za-z]+" "[^\n]*";
singleLineRecord: "[ \t\r]*" "[$]" "[ \t\r]*" "[A-Za-z]+" "[^\n;$]*";
singleLineNoRecord: "[^$][^\n]*";
singleLineComment: ';' "[^\n]*";
