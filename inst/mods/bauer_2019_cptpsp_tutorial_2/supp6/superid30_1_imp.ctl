$PROB Testing Inter-occasion with Inter-Site (example30_1.ctl)

$INPUT C SID ID OCC TIME AMT RATE EVID MDV CMT DV ROWNUM
$ABBR REPLACE ETA(OCC_CL)=ETA(5,7,9)
$ABBR REPLACE ETA(OCC_V)=ETA(6,8,10)
$DATA superid30.csv IGNORE=@

$SUBROUTINES ADVAN1 TRANS2

$PK
MU_1=THETA(1)
MU_2=THETA(2)
CL=EXP(MU_1+ETA(1)+ETA(3)+ETA(OCC_CL))
V=EXP(MU_2+ETA(2)+ETA(4)+ETA(OCC_V))
S1=V

$ERROR
IPRED=F
IF(IPRED==0.0) IPRED=0.00001
Y = IPRED+IPRED*EPS(1)


;Initial Thetas
$THETA
 2.0  ;[CL]
 3.0  ;[V]

;Individual omegas (1,2)
$OMEGA BLOCK(2)
 .1
 -.0001  .1

;SID OMEGAS (3,4)
$OMEGA BLOCK(2)
 .3
-.0001 .3

; inter-occasion omegas for occasion 1 (5,6)
$OMEGA BLOCK(2)
 .03 
 -.0001 .03

; inter-occasion omegas for occasion 2 and 3
; SAME(n) means repeat block structure n times;
; and omega parameters used for occasions 2 and 3 are shared 
; with those of occasion 1. 
$OMEGA BLOCK(2) SAME(2)

$SIGMA
 0.1

; PRIOR INFORMATION
$PRIOR NWPRI
;Individual omegas
$OMEGAP BLOCK(2)
 .03 FIXED
 0.0   .03
$OMEGAPD (2.0 FIXED)

;SID OMEGAS
$OMEGAP BLOCK(2)
 .1 FIXED
 0.0 .1
$OMEGAPD (2.0 FIXED)

; inter-occasion omegas
$OMEGAP BLOCK(2)
 .01 FIXED
 0.0 .01
$OMEGAP BLOCK(2) SAME(2)
$OMEGAPD (2.0 FIXED)

$LEVEL
SID=(3[1],4[2])

$EST METHOD=IMP INTERACTION PRINT=1 SIGL=8 FNLETA=0 NOABORT CTYPE=3 NOPRIOR=1
$COV MATRIX=R UNCONDITIONAL

$TABLE ID SID OCC TIME IPRED ETAS(1:LAST) 
       FILE=superid30_1_imp.tab NOPRINT NOAPPEND ONEHEADER
