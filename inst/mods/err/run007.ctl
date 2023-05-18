$PROB Warfarin PKPD; run007

;O'Reilly RA, Aggeler PM. Studies on coumarin anticoagulant drugs
;Initiation of warfarin therapy without a loading dose.
;Circulation 1968;38:169-177
;
;O'Reilly RA, Aggeler PM, Leong LS. Studies of the coumarin anticoagulant
;drugs: The pharmacodynamics of warfarin in man.
;Journal of Clinical Investigation 1963;42(10):1542-1551


$INPUT ID TIME AMT DV EVID WT AGE SEX SPARSE
$DATA warfarin_PKS.csv IGNORE=@

$SUBR ADVAN13 TOL=9
$MODEL
   COMP=GUT
   COMP=CENTRAL
$PK
	POP_ka  = THETA(1)
	POP_cl  = THETA(2)
	POP_v   = THETA(3)

    ka = exp(POP_ka+ETA(1))
    cl = exp(POP_cl+ETA(2))
    v = exp(POP_v+ETA(3))
    
$DES
    gut   = A(1)
    center= A(2)

    DADT(1) = -ka * gut
    DADT(2) =  ka * gut - cl / v * center

$ERROR
    conc=A(2)/v
	IPRED = conc     
    RESCV = THETA(4) 
	RESADD = THETA(5)	 
    W      = SQRT(IPRED*IPRED*RESCV*RESCV+RESADD*RESADD)	
    IRES   = DV-IPRED
    IWRES  = IRES/W
    Y      = IPRED + W*EPS(1)

$THETA 0.15 ; log ka
$THETA  -2  ; log cl
$THETA   2  ; log v
$THETA 0.2  ; EPS_prop
$THETA 0.5  ; EPS_pkadd

$OMEGA
1   ; ETA_ka
1   ; ETA_cl
1   ; ETA_v

$SIGMA   1 FIX 


$EST METHOD=1 INTERACTION MAXEVAL=9999 SIGL=5 PRINT=10 NOHABORT
$COV UNCONDITIONAL 
$TABLE ID TIME AMT DV EVID WT AGE SEX SPARSE Y ka cl v IRES IWRES IPRED
ONEHEADER NOPRINT FILE=run007.csv
