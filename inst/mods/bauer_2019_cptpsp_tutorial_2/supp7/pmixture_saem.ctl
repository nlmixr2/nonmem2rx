;Model Desc: Population Mixture Problem in 1 Compartment model, with Volume and rate constant parameters
;            and their inter-subject variances modeled from two sub-populations
;Project Name: nm7examples
;Project ID: NO PROJECT DESCRIPTION

$PROB RUN#  pmixture.ctl
$INPUT C SET ID JID TIME CONC=DV DOSE=AMT RATE EVID MDV CMT VC1 K101 VC2 K102 SIGZ PROB
$DATA pmixture.csv IGNORE=C

$SUBROUTINES ADVAN1 TRANS1

; The mixture model uses THETA(5) as the mixture proportion parameter, defining the proportion
; of subjects in sub-population 1 (P(1), and in sub-population 2 (P(2)
$MIX
P(1)=THETA(5)
P(2)=1.0-THETA(5)
NSPOP=2


$PK
;  The MUs should always be unconditionally defined, that is, they should never be
; defined in IF?THEN blocks
; THETA(1) models the Volume of sub-population 1
MU_1=THETA(1)
; THETA(2) models the clearance of sub-population 1
MU_2=THETA(2)
; THETA(3) models the Volume of sub-population 2
MU_3=THETA(3)
; THETA(4) models the clearance of sub-population 2
MU_4=THETA(4)
VCM=DEXP(MU_1+ETA(1))
K10M=DEXP(MU_2+ETA(2))
VCF=DEXP(MU_3+ETA(3))
K10F=DEXP(MU_4+ETA(4))
Q=1
IF(MIXNUM.EQ.2) Q=0
V=Q*VCM+(1.0-Q)*VCF
K=Q*K10M+(1.0-Q)*K10F
S1=V
BESTSUB=MIXEST

$ERROR
Y = F + F*EPS(1)

; Initial THETAs
$THETA 4.3 -2.9 4.3 -0.67 (0.00001,0.5,0.99999)

;Initial OMEGA block 1, for sub-population 1
$OMEGA BLOCK(2)
 .04 ;[p]
 .01 ; [f]
.027; [p]

;Initial OMEGA block 2, for sub-population 2
$OMEGA BLOCK(2)
 .05; [p]
 .01; [f]
.06; [p]

$SIGMA 
0.01 ;[p]


$EST METHOD=ITS INTERACTION NITER=0
$EST METHOD=SAEM INTERACTION NITER=500 PRINT=10 SIGL=6 AUTO=1
$EST METHOD=IMP INTERACTION NITER=5 PRINT=1 EONLY=1 MAPITER=0 
$COV MATRIX=R UNCONDITIONAL

$TABLE ID V K BESTSUB FIRSTONLY NOPRINT NOAPPEND FILE=pmixture_saem.par
