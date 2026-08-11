$PROBLEM PDLIDR (Yan et al. 2021 Appendix 11)
;Following comment assures ddexpand utility implements DDE expansion code
;into control stream (not needed for ADVAN16-18)
;DDE
$INPUT ID AMT TIME DV EVID CMT
$DATA app11.csv IGNORE=@
$SUBROUTINES ADVAN13 TOL=8 ATOL=12
$MODEL NCOMPARTMENTS=3
$PK
KEL=THETA(1)
V=THETA(2)
K0=THETA(3)*EXP(ETA(1))
K1=THETA(4)*EXP(ETA(2))
SMAX=THETA(5)*EXP(ETA(3))
SC50=THETA(6)*EXP(ETA(4))
; TAUy
TAU1=THETA(7)*EXP(ETA(5))
; Initial conditions
A_0(1)=0
A_0(2)=K0/K1
A_0(3)=K0*TAU1
$DES
; AP_x_y is the State value of A(x) in the past, for time delay TAUy.
;past
AP_2_1=K0/K1
CC=A(1)/V
DADT(1)=-KEL*A(1)
DADT(2)=K0*(1+SMAX*CC/(SC50+CC))-K1*A(2)
DADT(3)=K1*A(2)-K1*AD_2_1
$ERROR
Y1=LOG(A(3))
IF(CMT.EQ.3) IPRED=Y1
Y=IPRED+EPS(1)
$THETA
0.25 FIX ; 1: KEL
1 FIX ; 2: V
(0,0.6,5) ; 3: K0
(0,0.06,0.5) ; 4: K1
(0,45.2,500) ; 5: SMAX
(0,1.1,10) ; 6: SC50
(0,18,200) ; 7: TR
$OMEGA
0 FIX ; K0
0.1 ; K1
0.3 ; SMAX
0.3 ; SC50
0.1 ; TR
$SIGMA
0.05
$ESTIMATION MAXEVAL=0 METHOD=1 INTERACTION NOHABORT
