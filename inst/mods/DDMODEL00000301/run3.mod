;; Pauline Thémans, Joseph J. Winkin, Flora T. Musuamba

;; 1. Based on: 3
;; 2. Description: covariate model + WT on V2 + CPRED in pred3 ($TABLE)
;; x1. Author: user

$PROBLEM    MEROPENEM IV INFUSION 3COMP DESCRIPTION PLASMA AND ELF 
;           CONCENTRATIONS FINAL COV MODEL

; ------------dataset------------
$INPUT      ID WT GFR DV TIME MDV CMT AMT RATE SS II EVID
; WT [kg], GFRC [0: poor hepatic function, 1: good hepatic function], 
; GFR [mL/min], DV [mg/L], TIME [h], CMT [1: plasma conc., 2: ELF conc],
; AMT (DOSE) [g], RATE (K) [g/h], II (T) [h], GRP=AMT/RATE (delta) [h]

; CL [L/h], V1 V2 V3 [L], Q2 Q3 [L/h], S1 S2 [L]
$DATA      Simulated_dataset.csv IGNORE=@

; ------------model------------
$SUBROUTINE ADVAN11 TRANS4
$PK   
    ; parmacokinetic parameters
	TVCL=THETA(1)*((GFR/65)**THETA(2)) ; CENTRAL
	TVV1=THETA(3)*((WT/75)**THETA(4))
    TVQ2=THETA(5)                      ; ELF
	TVV2=THETA(6)*((WT/75)**THETA(9))
	TVQ3=THETA(7)                      ; PERIPHERAL
	TVV3=THETA(8)

	; interindividual variance model
	CL=TVCL*EXP(ETA(1))
	V1=TVV1*EXP(ETA(2))
	Q2=TVQ2
	V2=TVV2*EXP(ETA(3))
	Q3=TVQ3*EXP(ETA(4))
	V3=TVV3 

	; scaling factor
	S1=V1/1000 ; dose [g] and conc. [mg/L]
	S2=V2/THETA(10)




$ERROR 
; calcultate de result (i.e. model prediction) 
	H1=0
	H2=0
	IF(CMT.EQ.1) H1=1
	IF(CMT.EQ.2) H2=1
	Y=H1*(F*(1+EPS(1))+EPS(2))+H2*(F*(1+EPS(3)))   ; +EPS(4)
	W=F
	
	IPRED=F ; prediction individuelle 
	IRES=DV-IPRED ; (individual-specific residual) 
	IWRES=IRES/W ;  (individual-specific weighted residual)
	


; Initial conditions
$THETA  (0,7.94418) ; CL
$THETA  0.722104    ; GFRCL
$THETA  (0,13.5735) ; V1
$THETA  (0,0.948774); WTV1
$THETA  (0,6.72748) ; Q2; ELF
$THETA  (0,4.08255) ; V2
$THETA  (0,8.22236) ; Q3; PERIPHERAL
$THETA  (0,10.1118) ; V3
$THETA  (0,1.04299) ; WTV2
$THETA  248.608 ; V2/S2
$OMEGA  BLOCK(4)
 0.126073  ;      IIVCL
 0 0.139857  ;      IIVV1
 0 0 1.76372  ;      IIVV2
 0 0 0 0.186898  ;      IIVQ3
$SIGMA  0.0240037  ;   epsPROP1
 0.207718  ;    epsADD1
 0.404161  ;   epsPROP2
$ESTIMATION METHOD=1 INTER MAXEVAL=9999 SIGDIGITS=3 POSTHOC PRINT=5 ; PRINT=1 ; 

; standard error of estimates & correlation matrix
$COVARIANCE PRINT=E 


$TABLE      ID WT GFR TIME MDV CMT RATE PRED CPRED RES WRES
            IPRED IRES IWRES CWRES EVID NOPRINT FILE=pred4new ; population and individual predictions and residuals
$TABLE      ID WT GFR CL V1 Q2 V2 Q3 V3 ETA(1) ETA(2) ETA(3)
            ETA(4) TVCL TVV1 TVQ2 TVV2 TVQ3 TVV3 NOPRINT NOAPPEND
            FIRSTONLY FILE=param4new ; individual PK parameters (bayesiens,posthoc)

