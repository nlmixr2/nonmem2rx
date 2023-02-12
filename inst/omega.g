//loop
statement_list :  block_type? first? block_type? fixed?
        (statement)+ ;

diagonal: ('diagonal' | 'DIAGONAL') '(' decimalint ')';

block : ('block' | 'BLOCK');

blockn : block '(' decimalint ')';

same : 'SAME' | 'same';

blocknsame : block '(' decimalint ')'  same;

blocknsamen : block '(' decimalint ')'  same '(' decimalint ')';

blocksame : block same;

blocksamen : block same '(' decimalint ')';

first: diagonal | block | blockn | blocknsame | blocksame | blocksamen | blocknsamen;

statement: omega_statement  |
        block_type |
  singleLineComment?;

omega_statement: omega repeat? ','* singleLineComment?;

omega: omega0 | omega1 | omega2 ;

omega0: ini_constant block_type? fixed? block_type?;
omega1: '(' omega0 ')';
omega2: '(' block_type? fixed block_type? ini_constant ')';

repeat: "[Xx]" decimalint;

fixed: 'fixed' | 'FIXED' | 'FIX' | 'fix';

ini_constant: '-'? constant;

constant : decimalint | float1 | float2;

diag_type: ('standard'
        | 'sd'
        | 'variance'
        | 'Standard'
        | 'Sd'
        | 'Variance'
        | 'STANDARD'
        | 'SD'
        | 'VARIANCE'
        );
off_diag_type: ('COVARIANCE'
        | 'CORRELATON'
        | 'CORRELATION'
        | 'covariance'
        | 'correlaton'
        | 'correlation'
        | 'Covariance'
        | 'Correlaton'
        | 'Correlation'
        );

block_chol_type: 'CHOLESKY';

block_type: off_diag_type? diag_type? | diag_type? off_diag_type? | block_chol_type?;

whitespace: ( "[ \t\r\n]+")*;
singleLineComment: ';' "[^\n]*";

decimalint: "0|([1-9][0-9]*)" $term -1;
float1: "([0-9]+.[0-9]*|[0-9]*.[0-9]+)([eE][\-\+]?[0-9]+)?" $term -2;
float2: "[0-9]+[eE][\-\+]?[0-9]+" $term -3;
