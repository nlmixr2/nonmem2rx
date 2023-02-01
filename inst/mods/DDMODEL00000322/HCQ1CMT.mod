;; Description:
;; Author: Pauline THEMANS1, Flora TSHINANU MUSUAMBA2
;; 1. University of Namur, department of Mathematics
;; 2 Belgian Federal Agency for Medicines and Health Products, Brussels
;; based on : run9.dir1

$PROBLEM 1CMT ORAL PK MODEL OF HCQ IN COVID-19 PATIENTS
$ PARAMETER ESTIMATION

; ------------dataset------------
$INPUT ID SEX WT AGE TIME AMT ADDL II CMT DV MDV EVID
$DATA Simulated_dataset.csv IGNORE=@

; ------------model------------
$SUBROUTINE ADVAN2 TRANS2

$PK

TVCL=THETA(1)*((WT/80)**THETA(5));*((AGE/...)**THETA(5));
TVV=THETA(2)
TVKA=THETA(3)
TVF1=THETA(4)
; TVALAG1=THETA()


CL=TVCL*EXP(ETA(1))
V=TVV*EXP(ETA(2))
KA=TVKA;*EXP(ETA(3))
F1=TVF1;*EXP(ETA(4))


; scaling factor
KE=CL/V
S2=V/1000 ; dose [mg] and conc. [ng/mL]


$ERROR
Y=F*(1+EPS(1));+EPS(2)
W=F

IPRED=F ; prediction individuelle
IRES=DV-IPRED ; (individual-specific residual)
IWRES=IRES/W ; (individual-specific weighted residual)


; Intial conditions
$THETA (0,14.9221) ; CL
$THETA (0,861.497) ; V
$THETA (0,9.30202,10) ; KA
$THETA (0,0.746) FIX ; F1
;$THETA (0,0.00445) ; ALAG1
$THETA 1.20375 ; WTonCL
$OMEGA 0.163103 ; IIVCL
0.271008 ; IIVV
; 0.94 ; IVVKA
; 0.004 FIXED ; IIVF
$SIGMA 0.0290151 ; epsPROP1
;0.000365 ; epsADD1


$ESTIMATION METHOD=1 INTER MAXEVAL=9999 PRINT=5 SIG=3 POSTHOC
; standard error of estimates :
$COVARIANCE

$TABLE ID WT AGE TIME DV PRED CPRED IPRED EVID RES WRES IRES
IWRES CWRES NPDE ESAMPLE=300 NOPRINT FILE=pred
; population and individual predictions and residuals
$TABLE ID WT AGE CL V KA ETA(1) ETA(2)
NOPRINT NOAPPEND FIRSTONLY FILE=param
; individual PK parameters (bayesiens,posthoc)

