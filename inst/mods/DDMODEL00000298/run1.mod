;; PK-Pop model of sultiame with nonlinear distribution
;; Related article : Pharmacokinetic Profile of Sultiame in Healthy Volunteers with In Vitro Characterization of Its Uptake by Red Blood Cells
;; Kim Dao, Paul Thoueille, Laurent Arthur Decosterd, Thomas Mercier, Monia Guidi, Carine Bardinet, Sébastien Lebon, Eva Choong,
;; Arnaud Castang, Catherine Guittet, Luc-André Granier, Thierry Buclin
;; Under submission
;; Model author: Kim Dao
;; Date: 18.10.2019
;; NCOMP=4 which are 1= absorption site, 2= plasma, 3= erythrocytes, 4= urines

$PROBLEM PK

$INPUT ID TTT DAT1=DROP TIME DV UVOL AMT MDV EVID CMT

$DATA Simulated_data_PK_sultiame.csv IGNORE=I

$SUBROUTINES ADVAN13 TOL=3

$MODEL NCOMP=4

$PK
IF (AMT.GT.0) THEN
TDOS=TIME
TAD=0.0
ENDIF
IF (AMT.EQ.0) TAD=TIME-TDOS ; this is to calculate time after the dose

CL = THETA(1) * EXP(ETA(1)) ; clearance sultiame
V2 = THETA(2) ; volume of distribution of plasma (L)
V3 = THETA(3) ; volume of distribution of erythrocytes (L)
KON = THETA(4) ; association constant in h^-1· mg^-1
BTOT = THETA(5) ; maximal binding capacity in mg
KOFF = THETA(6) ; dissociation constant in h^-1
KA = THETA(7) ; absorption constant (h^-1) fixed to 1
KE = CL/V2 ; elimination constant
QREN = THETA(8) * EXP(ETA(2)) ; renal extraction fraction
S2 = V2
S3 = V3
S4 = UVOL/1000 ; conversion of units for volume of urines (L, in mL in dataset)

; differential equations according to model
$DES
DADT(1) = -KA * A(1) ; absorption compartment
DADT(2) = KA * A(1) - KE * A(2) - KON * A(2) * (BTOT - A(3)) + KOFF * A(3) ; plasma compartment
DADT(3) = KON * A(2) * (BTOT - A(3)) - KOFF * A(3) ; erythrocytes compartment
DADT(4) = KE * A(2) * QREN ; urine compartment

; error models for plasma (Q2), erythrocytes (Q3) and urines (Q4)
$ERROR
Q2=0
Q3=0
Q4=0

IF(CMT==2) THEN
Q2=1
IPRED2 = A(2)/S2
W2 = SQRT(THETA(9)**2*IPRED2**2 + THETA(10)**2)
Y2 = IPRED2 + W2*EPS(1)
IRES2 = DV-IPRED2
IWRES2 = IRES2/W2
ENDIF

IF(CMT==3) THEN
Q3=1
IPRED3 = A(3)/S3
W3 = SQRT(THETA(11)**2*IPRED3**2 + THETA(12)**2)
Y3 = IPRED3 + W3*EPS(1)
IRES3 = DV-IPRED3
IWRES3 = IRES3/W3
ENDIF

IF(CMT.EQ.4.AND.EVID.EQ.0) THEN
Q4=1
IPRED4 = A(4)/S4
W4 = SQRT(THETA(13)**2*IPRED4**2 + THETA(14)**2)
Y4 = IPRED4 + W4*EPS(1)
IRES4 = DV-IPRED4
IWRES4 = IRES4/W4
ENDIF

IPRED=Q2*IPRED2+Q3*IPRED3+Q4*IPRED4
Y=Y2*Q2+Q3*Y3+Y4*Q4
IRES=Q2*IRES2+Q3*IRES3+Q4*IRES4
IWRES=Q2*IWRES2+Q3*IWRES3+Q4*IWRES4

$THETA
(0, 9.9) ; Clearance
(0, 56) ; V2 = Volume of distribution (plasma)
(0, 3.3) ; V3 = Volume of distribution (erythrocytes)
(6960) FIX ; Kon = association constant
(0, 114) ; Btot = total binding capacity of the receptor
(0, 6000) ; Koff = dissociation constant
(0, 1.8) ; Ka = absorption constant
(0, 0.5, 1) ; Qren = renal extraction ratio
(0, 0.70) ; Prop.RE (sd) plasma
(0) FIX ; Add.RE (sd) plasma
(0, 0.22) ; Prop.RE (sd) erythrocytes
(0) FIX ; Add.RE (sd) erythrocytes
(0, 0.39) ; Prop.RE (sd) urines
(0) FIX ; Add.RE (sd) urines

$OMEGA
(0.1) ; IIV CL
(0.1) ; IIV QRen


$SIGMA
1 FIX ; Proportional error PK

$EST METHOD=1 INTER MAXEVAL=9999 NOABORT SIGL=3 NSIG=1 PRINT=1 POSTHOC

$COV

$TABLE ID TIME DV CMT AMT MDV EVID NOPRINT NOHEADER FILE=tab

; Xpose
$TABLE ID TIME TAD AMT DV UVOL MDV CMT EVID IPRED IWRES CWRES ONEHEADER NOPRINT FILE=sdtab
$TABLE CL V2 V3 KA KE KON BTOT KOFF FIRSTONLY ONEHEADER NOPRINT FILE=patab
