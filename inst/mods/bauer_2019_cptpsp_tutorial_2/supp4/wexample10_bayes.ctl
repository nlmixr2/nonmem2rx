$PROB  wexample10 (from F_FLAG04est2a.ctl)
$INPUT C ID DOSE=AMT TIME DV WT TYPE
$DATA wexample10.csv IGNORE=@

$SUBROUTINES  ADVAN2 TRANS2

$PK
   MU_1=THETA(1)
   KA=EXP(MU_1+ETA(1))
   MU_2=THETA(2)
   V=EXP(MU_2+ETA(2))
   MU_3=THETA(3)
   CL=EXP(MU_3+ETA(3))
   S2=V/1000

$THETA  
1.6 ; [LN(KA)]
2.3 ; [LN(V)]
0.7 ; [LN(CL)]
0.1 ; [INTRCEPT]
0.1 ; [SLOPE]

$OMEGA BLOCK(3) VALUES(0.5,0.01) ;[P]
; Priors to Omegas
$PRIOR NWPRI
$OMEGAP BLOCK(3) FIXED VALUES(0.09,0.0)
$OMEGAPD (3 FIX)

;Because THETA(4) and THETA(5) have no inter-subject variability associated with them, the
; algorithm must use a more computationally expensive gradient evaluation for these two parameters

$SIGMA
0.1; [P]

$ERROR
IPRED=A(2)/S2
    EXPP=THETA(4)+IPRED*THETA(5)
; Put a limit on this, as it will be exponentiated, to avoid floating overflow
    IF(EXPP.GT.40.0) EXPP=40.0
IF (TYPE.EQ.0) THEN
; PK Data
    F_FLAG=0
    Y=IPRED+IPRED*ERR(1) ; a prediction
 ELSE
; Categorical data
    F_FLAG=1
; IF EXPP>40, then A>1.0d+17, A/B=1, and Y=DV
    AA=EXP(EXPP)
    B=1+AA
    Y=DV*AA/B+(1-DV)/B      ; a likelihood
 ENDIF

; NOPRIOR=1 can turn off incorporation of prior information for a particular method, 
; and turned back on (NOPRIOR=0) for others.  Prior information is not needed for ITS, but is needed for BAYES
; Raw output content can be routed to specific files for each $EST record, with the FILE= option
$EST METHOD=ITS INTER LAP AUTO=1 PRINT=5 SIGL=6 NOPRIOR=1 FILE=wexample10_its.ext
$EST METHOD=BAYES AUTO=1 NOPRIOR=0 PRINT=100
     FILE=wexample10_bayes.ext

$COV UNCONDITIONAL PRINT=E MATRIX=R SIGL=10
$TABLE ID DOSE WT TIME TYPE DV AA NOPRINT FILE=wexample10_bayes.tab
