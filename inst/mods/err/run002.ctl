$PROB Warfarin PKPD; run002

;O'Reilly RA, Aggeler PM. Studies on coumarin anticoagulant drugs
;Initiation of warfarin therapy without a loading dose.
;Circulation 1968;38:169-177
;
;O'Reilly RA, Aggeler PM, Leong LS. Studies of the coumarin anticoagulant
;drugs: The pharmacodynamics of warfarin in man.
;Journal of Clinical Investigation 1963;42(10):1542-1551


$INPUT id time amt dv evid wt age sex sparse
$DATA warfarin_PKS.csv IGNORE=@

$SUBR ADVAN13 TOL=9
$MODEL
   COMP=GUT
   COMP=CENTRAL
$PK
	POP_ka  = THETA(1)
	POP_cl  = THETA(2)
	POP_v   = THETA(3)
	POP_TLAG= THETA(4)

    ka = exp(POP_ka+ETA(1))
    cl = exp(POP_cl+ETA(2))
    v = exp(POP_v+ETA(3))
	ALAG1=exp(POP_TLAG+ETA(4))
    
$DES
    gut   = A(1)
    center= A(2)

    DADT(1) = -ka * gut
    DADT(2) =  ka * gut - cl / v * center

$ERROR
    conc=A(2)/v
	IPRED = conc     
    RESCV = THETA(5) 
	RESADD = THETA(6)	 
    IRES   = DV-IPRED
    IWRES  = (DV-IPRED)/(IPRED*RESCV+RESADD)
    Y      = IPRED + RESCV*IPRED*EPS(1) + RESADD*EPS(2)

$THETA 0.2  ; log ka
$THETA  -2  ; log cl
$THETA   2  ; log v
$THETA -0.2 ; log Tlag
$THETA (0.001,0.2)  ; EPS_prop
$THETA (0.001,0.5)  ; EPS_pkadd

$OMEGA
0.7  ; ETA_ka
0.2  ; ETA_cl
0.2  ; ETA_v
0.6  ; ETA_Tlag

$SIGMA   1 FIX 1 FIX


$EST METHOD=1 INTERACTION MAXEVAL=9999 SIGL=5 PRINT=10 NOHABORT
$COV UNCONDITIONAL 
$TABLE id time conc sparse Y ka cl v ALAG1 IRES IWRES IPRED ETAS(1:LAST)
ONEHEADER NOPRINT FILE=run002.csv
