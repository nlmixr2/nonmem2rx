$PROB RUN# from r2compl, using FAST
$INPUT C SET ID JID TIME DV AMT RATE EVID MDV CMT
$DATA r2comp.csv IGNORE=C

; The new numerical integration solver is used, although ADVAN=9 is also efficient
; for this problem.
$SUBROUTINES ADVAN13 TRANS1 TOL=9
$MODEL NCOMPARTMENTS=3

$PK
MU_1=THETA(1)
MU_2=THETA(2)
MU_3=THETA(3)
MU_4=THETA(4)
MU_5=THETA(5)
MU_6=THETA(6)
MU_7=THETA(7)
MU_8=THETA(8)
VC=EXP(MU_1+ETA(1))
K10=EXP(MU_2+ETA(2))
K12=EXP(MU_3+ETA(3))
K21=EXP(MU_4+ETA(4))
VM=EXP(MU_5+ETA(5))
KMC=EXP(MU_6+ETA(6))
K03=EXP(MU_7+ETA(7))
K30=EXP(MU_8+ETA(8))
S3=VC
S1=VC
KM=KMC*S1
A_0(3)=K03/K30

$DES
DADT(1) = -(K10+K12)*A(1) + K21*A(2) - VM*A(1)*A(3)/(A(1)+KM)
DADT(2) = K12*A(1) - K21*A(2)
DADT(3) =  -(VM-K30)*A(1)*A(3)/(A(1)+KM) - K30*A(3) + K03

$ERROR
ETYPE=1
IF(CMT.NE.1) ETYPE=0
CP=A(1)/S1
CR=A(3)/S3
IPRE=CP
IF(CMT.NE.1) IPRE=CR
Y = IPRE + IPRE*ETYPE*EPS(1) + IPRE*(1.0-ETYPE)*EPS(2)


$THETA 
;Initial Thetas
( 4.0 )  ;[LN(VC)]
( -3.1 ) ;[LN(K10)]
( 0.5 )  ;[LN(K12)]
( -0.2 );[LN(K21)]      
( 3.2 ) ;[LN(VM)]
( 0.01 )  ;[LN(KMC)]
( 4.0 )  ;[LN(K03)]
( -0.1) ;[LN(K30)]

;Initial Omegas
$OMEGA BLOCK(8) VALUES(0.5,0.01) ;[P]

$SIGMA  
0.1 ;[p]
0.1 ;[p]

$EST METHOD=1 INTERACTION PRINT=1 NOHABORT NOPRIOR=1 SIGL=9 ATOL=9 MAXEVAL=9999 NSIG=3 MCETA=1
     NOTHETABOUNDTEST NOOMEGABOUNDTEST NOSIGMABOUNDTEST
$COV MATRIX=R UNCONDITIONAL PRINT=E
