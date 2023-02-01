;; 1. Based on: run200
;; 2. Description: Estimation based on simulated data
;; x1. Author: Matts
$SIZES NO=3000 LIM6=1000
$PROBLEM PN survival model With individual PK

; Implemented flip comments using PsN (e.g. sim_start and sim_end to define code to be used for VPC simulations).
;Sim_start
$INPUT ID TIME EVID DV CENS DUR RATE AMT CMT NDOS SEXX BW PPN PK ET1 ET2 ET3 ET4 ET5 ET6 RTTE=DROP



$DATA ../data/simdata202.csv IGNORE=@


;$INPUT MID TIME DUR RATE AMT EVID CMT DV CENS CENSD STUD ADC NDOS NAMT_MAX PL_DOSE AV_DOSE CUMDOSE DFREQ
; RITUX SEXX AGE BW BHT RACE BMI BSA CTYPE ALB BUN BSLD=DROP PDUR=DROP PCPLAT PCTAX PCVINCA PCPROT
; PPN DIAB ECOG1 DSBUILD=DROP ET1 ET2 ET3 ET4 ET5 ET6 PK ID
;
; $DATA ../data/nonmem_gr2_Nov13_2018_sim.csv IGNORE=@
; IGNORE(TIME.LT.0)
; IGNORE(STUD.EQ.29006) ; 13 patients
; IGNORE(ID.EQ.639) ; Unrealistic PK
;Sim_end

$SUBROUTINE ADVAN13 TRANS1 TOL=6
$MODEL COMP=(central) COMP=(peri) COMP=(effcpt) COMP=(cumhaz)
COMP=(trcpt) COMP(AUC)
$PK
;for simulation
RTTE=0
;end for simulation

; Covariate imputations etc
ageRef = 65
albref=4.0
bunref=16
bodyWeightRef=85 ; Male

IF(SEXX.EQ.1) SEX=1 ; Male
IF(SEXX.EQ.2) THEN
SEX=0 ; Female
bodyWeightRef=68
ENDIF

BWT=BW
IF(BW.EQ.-99) BWT=bodyWeightRef

; PK parameters

THETA1=0.312;1 CL
THETA2=1.21;2 V1
THETA3= 0.957;3 V2
THETA4= -1.02;4 Q
THETA5= 1.48;5 KDES
THETA6= 1.02;6 CLT
THETA7= 0.476;7 WT to CLinf
THETA8= 0.527;8 WT to V1
THETA9= 0.484;9 WT to 2
THETA10= 0.303;10 WT to Q
THETA11= 0.149;11 SEX to V1
THETA12= 0.223;12 SEX to V
THETA13= -0.212;13 power NDOS to CL

LWT75 = LOG(BWT/75)
MUX1 = THETA1+THETA7*LWT75 +THETA13*LOG(NDOS/2.4)
MUX2 = THETA2+THETA8*LWT75+THETA11*SEX
MUX3 = THETA3+THETA9*LWT75+THETA12*SEX
MUX4 = THETA4+THETA10*LWT75
MUX5 = THETA5
MUX6 = THETA6

CLINF = EXP(MUX1+ET1)
V1 = EXP(MUX2+ET2)
V2 = EXP(MUX3+ET3)
Q = EXP(MUX4+ET4)
KDES = EXP(MUX5+ET5)
CLT = EXP(MUX6+ET6)

S1 = V1/1000

;Reparameterization
K12 = Q/V1
K21 = Q/V2

; PD parameters
LOGKTR = THETA(1)+ETA(1) ; Eta1 Fixed to zero
KTR = EXP(LOGKTR) ; first order transit rate to and from transit and effect compartment
ALPHA = EXP(THETA(2)) ; slope of drug effect
BETA = EXP(THETA(3)) ; weibul function parameter

covar = THETA(4) * (BWT - 75) + THETA(5) * PPN ; covariate effects on Hazard

$DES
; PK model
CL = CLT * EXP(-KDES * T) + CLINF
K10 = CL / V1

DADT(1) = K21 * A(2) - K12 * A(1) - K10 * A(1)
DADT(2) = -K21 * A(2) + K12 * A(1)
CPT = A(1) / S1

; PD model
DADT(5) = KTR * CPT - KTR * A(5) ; Transit compartment
DADT(3) = KTR * A(5) - KTR * A(3) ; Effect compartment
A5=A(5)
A3=A(3)

EDRUGT = ALPHA * A(3)
HAZT = 0
IF(T > 0) HAZT = BETA * (EDRUGT**BETA) * (T**(BETA - 1)) * EXP(covar); WEIBULL (not defined at time zero)
DADT(4) = HAZT ; Cumulative Hazard
DADT(6) = CPT ; Cumulative AUC
AUCT=A(6) ; AUC up to time T
CAV=AUCT/T ; Average concentration up to time T

$ERROR
CP = A(1) / S1
EDRUG = ALPHA * A(3) ; Drug effect
HAZ = 0 ; redefine Hazard in $Error. Needed to compute pdf
IF(TIME > 0) HAZ = BETA * (EDRUG**BETA) * (TIME**(BETA - 1)) * EXP(covar); WEIBULL
SURV = EXP(-A(4)) ; Survival probability
PDF=SURV*HAZ

;Estimation (defined by sim start and end)
;Sim_start
IF(DV.EQ.0) THEN
Y=SURV
CHLAST=A(4)
ELSE
CHLAST=CHLAST ; Keep nmtran happy
ENDIF

IF(DV.EQ.1) THEN
Y=PDF ;pdf
ENDIF
;Sim_end


;Simulation
IF(ICALL.EQ.4) THEN
IF (NEWIND.NE.2) CALL RANDOM (2,R) ; random uniform distribution
DV=0 ; NO EVENT OCCURS
RTTE=0 ; NO EVENT OCCURS
IF(CENS.EQ.1) RTTE=1 ; RTTE set to 1 for censoring and event rows
IF(R.GT.SURV) THEN ; Event when R > SURV
DV=1 ; DV set to 1 at time of event
RTTE=1 ; RTTE set to 1 for censoring and event rows
ENDIF
Y=DV
ENDIF


$THETA
(-4.53) ; 1 LOGKE0
(-9.69) ; 2 LOGALPHA
(-0.327) ; 3 LOGBETA
(0.0145) ; 4 BWT
(0.434) ; 5 PPN 1/0


$OMEGA 0 FIX
;Sim_start
;$SIGMA
;0 FIXED

$ESTIMATION MAXEVAL=9999 PRINT=1 LIKE METHOD=1 LAPLACE NUMERICAL
NOABORT SIG=3
;$SIMULATION(123456) (23000 UNIFORM) ONLYSIM ; Uncomment this for VPC generation
;Sim_end

;$COVARIANCE MATRIX=S UNCONDITIONAL

;$TABLE TIME ID MID EVID AV_DOSE CAV AUCT CP A5 A3 HAZ SURV FORMAT= s1PE15.9 ONEHEADER NOPRINT FILE=HZtab202
