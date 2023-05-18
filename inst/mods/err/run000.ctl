$PROB Warfarin PKPD; run000

;O'Reilly RA, Aggeler PM. Studies on coumarin anticoagulant drugs
;Initiation of warfarin therapy without a loading dose.
;Circulation 1968;38:169-177
;
;O'Reilly RA, Aggeler PM, Leong LS. Studies of the coumarin anticoagulant
;drugs: The pharmacodynamics of warfarin in man.
;Journal of Clinical Investigation 1963;42(10):1542-1551


$INPUT ID TIME AMT DV EVID WT AGE SEX SPARSE
$DATA warfarin_PKS.csv IGNORE=@

$SUBR ADVAN2
$PK
	POP_ka  = THETA(1)
	POP_cl  = THETA(2)
	POP_v   = THETA(3)

    KA = exp(POP_ka+ETA(1))
    CL = exp(POP_cl+ETA(2))
    VC = exp(POP_v+ETA(3))
    
    S2 = VC
    K  = CL/VC 
 
$ERROR
	IPRED  = F
    RESCV  = THETA(4) 
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
$TABLE ID TIME AMT DV EVID WT AGE SEX SPARSE Y KA CL VC IRES IWRES IPRED
ONEHEADER NOPRINT FILE=run000.csv
