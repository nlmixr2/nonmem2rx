$PROBLEM WARFARIN
$INPUT ID TIME AMT RATE EVID MDV DV TSTRAT TMIN TMAX
$DATA priortrue.csv ignore=@

$SUBROUTINES ADVAN2 TRANS2

$PK
MU_1=THETA(1)
MU_2=THETA(2)
MU_3=THETA(3)
CL=EXP(MU_1+ETA(1))
V=EXP(MU_2+ETA(2))
KA=EXP(MU_3+ETA(3))
S2=V
F1=1.0
LTVCL=THETA(1) ; log of typical value Clearance
LTVV=THETA(2) ; log of typical value Volume
LTVKA=THETA(3) ; log of typical value KA

$ERROR
IPRED=A(2)/V
Y=IPRED*(1.0+EPS(1)) + EPS(2)

$THETA
-1.897 ;[lnCL]
2.079  ;[lnV]
0.0001  ;[lnKA]

$OMEGA (0.07 ) (0.02 ) (0.6 )
$SIGMA (0.01 ) (0.001 FIXED )

; NWPRI=Normal Wishart Prior.  That is, theta priors are assumed normally distributed, 
; and Omegas and Sigmas are assumed Wishart distributed.
; PLEV=probability level over which random samples generated 
; from the respective samplers are to be accepted.  
; PLEV=0.99 allows acceptance of 99% of the samples generated, 
; while avoiding extreme values that are outside of the 99% 
; confidence bound of the distribution. When using the $PRIOR record to 
; define the random sampler (Normal sampler for thetas, Wishart sampler for 
; Omegas/Sigmas, PLEV must be specified. 

$PRIOR NWPRI PLEV=0.99
; Thetas are in log units, to ensure 30% variation does not produce negative parameters
$THETAP (-1.897 FIXED) (2.079 FIXED) (0.001 FIXED)
$THETAPV BLOCK(3) ; make variance same as that of $OMEGA
0.07 FIX
0.0   0.02
0.0   0.0  0.6

$SIM (4442223) SUBPROB=1000 TRUE=PRIOR
$DESIGN NELDER FIMDIAG=1 GROUPSIZE=32 OFVTYPE=0 DESEL=TIME DESELSTRAT=TSTRAT DESELMIN=TMIN DESELMAX=TMAX
        MAXEVAL=4000 SIGL=10 nohabort PRINT=100 NOPRIOR=1
$TABLE ID LTVCL LTVV LTVKA TIME EVID MDV DV IPRED NOPRINT NOAPPEND FILE=priortrue2.tab
