$PROBLEM WARFARIN
$INPUT ID TIME AMT RATE EVID MDV DV 
$DATA warfarin.csv ignore=C

$SUBROUTINES ADVAN2 TRANS2

$PK
; MU referencing can be helpful in evaluating FIM analytically, 
; providing greater singificant digit precision and speed
MU_1=LOG(THETA(1))
MU_2=LOG(THETA(2))
MU_3=LOG(THETA(3))
CL=EXP(MU_1+ETA(1))
V=EXP(MU_2+ETA(2))
KA=EXP(MU_3+ETA(3))
S2=V
F1=1.0

$ERROR
IPRED=A(2)/V
Y=IPRED + IPRED*EPS(1) + EPS(2)

$THETA
0.15 ;[CL]
8.0  ;[V]
1.0  ;[KA]

$OMEGA (0.07) (0.02) (0.6)
$SIGMA 0.01 (0.001 FIXED)

$DESIGN GROUPSIZE=32 FIMDIAG=1
