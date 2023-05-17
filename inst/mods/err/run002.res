Run Start Date:  16/05/2023 
Run Start Time: 15:09:00.71 
Run Stop Date:   16/05/2023 
Run Stop Time:  15:09:28.66 
  
************************************************************************************************************************ 
********************                            CONTROL STREAM                                      ******************** 
************************************************************************************************************************ 
  
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
   
   
************************************************************************************************************************ 
********************                            SYSTEM INFORMATION                                  ******************** 
************************************************************************************************************************ 
   
Operating system: 

Microsoft Windows [Version 10.0.22621.1702]
   
Compiler: Intel(R) Parallel Studio XE 2015 Update 3 Composer Edition (package 208)  
   
Compiler settings: /Gs /nologo /nbs /w /fp:strict   
   
************************************************************************************************************************ 
********************                            NMTRAN MESSAGES                                     ******************** 
************************************************************************************************************************ 
   
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
   
************************************************************************************************************************ 
********************                            NONMEM EXECUTION                                    ******************** 
************************************************************************************************************************ 
   
License Registered to: Occams Cooperatie UA
Expiration Date:    14 JUN 2024
Current Date:       16 MAY 2023
Days until program expires : 393
1NONLINEAR MIXED EFFECTS MODEL PROGRAM (NONMEM) VERSION 7.5.0
 ORIGINALLY DEVELOPED BY STUART BEAL, LEWIS SHEINER, AND ALISON BOECKMANN
 CURRENT DEVELOPERS ARE ROBERT BAUER, ICON DEVELOPMENT SOLUTIONS,
 AND ALISON BOECKMANN. IMPLEMENTATION, EFFICIENCY, AND STANDARDIZATION
 PERFORMED BY NOUS INFOSYSTEMS.

 PROBLEM NO.:         1
 Warfarin PKPD; run002
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:      283
 NO. OF DATA ITEMS IN DATA SET:  10
 ID DATA ITEM IS DATA ITEM NO.:   1
 DEP VARIABLE IS DATA ITEM NO.:   4
 MDV DATA ITEM IS DATA ITEM NO.: 10
0INDICES PASSED TO SUBROUTINE PRED:
   5   2   3   0   0   0   0   0   0   0   0
0LABELS FOR DATA ITEMS:
 id time amt dv evid wt age sex sparse MDV
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 ka cl v ALAG1 conc IPRED IRES IWRES Y
0FORMAT FOR DATA:
 (9E5.0,1F2.0)

 TOT. NO. OF OBS RECS:      251
 TOT. NO. OF INDIVIDUALS:       32
0LENGTH OF THETA:   6
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   4
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   2
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
 LOWER BOUND    INITIAL EST    UPPER BOUND
 -0.1000E+07     0.2000E+00     0.1000E+07
 -0.1000E+07    -0.2000E+01     0.1000E+07
 -0.1000E+07     0.2000E+01     0.1000E+07
 -0.1000E+07    -0.2000E+00     0.1000E+07
  0.1000E-02     0.2000E+00     0.1000E+07
  0.1000E-02     0.5000E+00     0.1000E+07
0INITIAL ESTIMATE OF OMEGA:
 0.7000E+00
 0.0000E+00   0.2000E+00
 0.0000E+00   0.0000E+00   0.2000E+00
 0.0000E+00   0.0000E+00   0.0000E+00   0.6000E+00
0INITIAL ESTIMATE OF SIGMA:
 0.1000E+01
 0.0000E+00   0.1000E+01
0SIGMA CONSTRAINED TO BE THIS INITIAL ESTIMATE
0COVARIANCE STEP OMITTED:        NO
 EIGENVLS. PRINTED:              NO
 SPECIAL COMPUTATION:            NO
 COMPRESSED FORMAT:              NO
 GRADIENT METHOD USED:     NOSLOW
 SIGDIGITS ETAHAT (SIGLO):                  -1
 SIGDIGITS GRADIENTS (SIGL):                -1
 EXCLUDE COV FOR FOCE (NOFCOV):              NO
 Cholesky Transposition of R Matrix (CHOLROFF):0
 KNUTHSUMOFF:                                -1
 RESUME COV ANALYSIS (RESUME):               NO
 SIR SAMPLE SIZE (SIRSAMPLE):
 NON-LINEARLY TRANSFORM THETAS DURING COV (THBND): 1
 PRECONDTIONING CYCLES (PRECOND):        0
 PRECONDTIONING TYPES (PRECONDS):        TOS
 FORCED PRECONDTIONING CYCLES (PFCOND):0
 PRECONDTIONING TYPE (PRETYPE):        0
 FORCED POS. DEFINITE SETTING DURING PRECONDITIONING: (FPOSDEF):0
 SIMPLE POS. DEFINITE SETTING: (POSDEF):-1
0TABLES STEP OMITTED:    NO
 NO. OF TABLES:           1
 SEED NUMBER (SEED):    11456
 RANMETHOD:             3U
 MC SAMPLES (ESAMPLE):    300
 WRES SQUARE ROOT TYPE (WRESCHOL): EIGENVALUE
0-- TABLE   1 --
0RECORDS ONLY:    ALL
04 COLUMNS APPENDED:    YES
 PRINTED:                NO
 HEADER:                YES
 FILE TO BE FORWARDED:   NO
 FORMAT:                S1PE11.4
 IDFORMAT:
 LFORMAT:
 RFORMAT:
 FIXED_EFFECT_ETAS:
0USER-CHOSEN ITEMS:
 id time conc sparse Y ka cl v ALAG1 IRES IWRES IPRED ETA1 ETA2 ETA3 ETA4
1DOUBLE PRECISION PREDPP VERSION 7.5.0

 GENERAL NONLINEAR KINETICS MODEL WITH STIFF/NONSTIFF EQUATIONS (LSODA, ADVAN13)
0MODEL SUBROUTINE USER-SUPPLIED - ID NO. 9999
0MAXIMUM NO. OF BASIC PK PARAMETERS:   3
0COMPARTMENT ATTRIBUTES
 COMPT. NO.   FUNCTION   INITIAL    ON/OFF      DOSE      DEFAULT    DEFAULT
                         STATUS     ALLOWED    ALLOWED    FOR DOSE   FOR OBS.
    1         GUT          ON         YES        YES        YES        NO
    2         CENTRAL      ON         YES        YES        NO         YES
    3         OUTPUT       OFF        YES        NO         NO         NO
 INITIAL (BASE) TOLERANCE SETTINGS:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:   9
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
1
 ADDITIONAL PK PARAMETERS - ASSIGNMENT OF ROWS IN GG
 COMPT. NO.                             INDICES
              SCALE      BIOAVAIL.   ZERO-ORDER  ZERO-ORDER  ABSORB
                         FRACTION    RATE        DURATION    LAG
    1            *           *           *           *           4
    2            *           *           *           *           *
    3            *           -           -           -           -
             - PARAMETER IS NOT ALLOWED FOR THIS MODEL
             * PARAMETER IS NOT SUPPLIED BY PK SUBROUTINE;
               WILL DEFAULT TO ONE IF APPLICABLE
0DATA ITEM INDICES USED BY PRED ARE:
   EVENT ID DATA ITEM IS DATA ITEM NO.:      5
   TIME DATA ITEM IS DATA ITEM NO.:          2
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   3

0PK SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 PK SUBROUTINE NOT CALLED AT NONEVENT (ADDITIONAL OR LAGGED) DOSE TIMES.
0ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
0ERROR SUBROUTINE INDICATES THAT DERIVATIVES OF COMPARTMENT AMOUNTS ARE USED.
0DES SUBROUTINE USES COMPACT STORAGE MODE.
1
 
 
 #TBLN:      1
 #METH: First Order Conditional Estimation with Interaction
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            9999
 NO. OF SIG. FIGURES REQUIRED:            3
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
 ABORT WITH PRED EXIT CODE 1:             NO
 IND. OBJ. FUNC. VALUES SORTED:           NO
 NUMERICAL DERIVATIVE
       FILE REQUEST (NUMDER):               NONE
 MAP (ETAHAT) ESTIMATION METHOD (OPTMAP):   0
 ETA HESSIAN EVALUATION METHOD (ETADER):    0
 INITIAL ETA FOR MAP ESTIMATION (MCETA):    0
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      5
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     5
 NOPRIOR SETTING (NOPRIOR):                 0
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          1
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      0
 RAW OUTPUT FILE (FILE): run002.ext
 EXCLUDE TITLE (NOTITLE):                   NO
 EXCLUDE COLUMN LABELS (NOLABEL):           NO
 FORMAT FOR ADDITIONAL FILES (FORMAT):      S1PE12.5
 PARAMETER ORDER FOR OUTPUTS (ORDER):       TSOL
 KNUTHSUMOFF:                               0
 INCLUDE LNTWOPI:                           NO
 INCLUDE CONSTANT TERM TO PRIOR (PRIORC):   NO
 INCLUDE CONSTANT TERM TO OMEGA (ETA) (OLNTWOPI):NO
 ADDITIONAL CONVERGENCE TEST (CTYPE=4)?:    NO
 EM OR BAYESIAN METHOD USED:                 NONE

 TOLERANCES FOR ESTIMATION/EVALUATION STEP:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:   9
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
 TOLERANCES FOR COVARIANCE STEP:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:   9
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
 TOLERANCES FOR TABLE/SCATTER STEP:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:   9
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
 
 THE FOLLOWING LABELS ARE EQUIVALENT
 PRED=PREDI
 RES=RESI
 WRES=WRESI
 IWRS=IWRESI
 IPRD=IPREDI
 IRS=IRESI
 
 MONITORING OF SEARCH:

 
0ITERATION NO.:    0    OBJECTIVE VALUE:   398.938919899468        NO. OF FUNC. EVALS.:   8
 CUMULATIVE NO. OF FUNC. EVALS.:        8
 NPARAMETR:  2.0000E-01 -2.0000E+00  2.0000E+00 -2.0000E-01  2.0000E-01  5.0000E-01  7.0000E-01  2.0000E-01  2.0000E-01  6.0000E-01

 PARAMETER:  1.0000E-01 -1.0000E-01  1.0000E-01 -1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01

 GRADIENT:   9.5246E+00  1.0529E+02 -6.0565E+02  1.0559E+01  1.9888E+02  6.3568E+01 -1.8440E+00  3.6139E+01  3.9069E+01  8.6370E+00

 
0ITERATION NO.:   10    OBJECTIVE VALUE:   231.497071015238        NO. OF FUNC. EVALS.: 154
 CUMULATIVE NO. OF FUNC. EVALS.:      162
 NPARAMETR:  2.7872E-01 -2.0694E+00  2.0487E+00 -1.7326E-02  7.7868E-02  3.0198E-01  5.0704E-01  7.3895E-02  6.8283E-02  2.1266E-01

 PARAMETER:  1.3936E-01 -1.0347E-01  1.0244E-01 -8.6629E-03 -8.5122E-01 -4.0556E-01 -6.1242E-02 -3.9783E-01 -4.3733E-01 -4.1862E-01

 GRADIENT:  -1.0120E-01 -8.1529E+02 -5.0717E+02  1.8011E+01 -1.9599E+01  3.5934E-01 -4.4551E+00 -1.0775E+01  1.5348E+01 -5.4141E+00

 
0ITERATION NO.:   20    OBJECTIVE VALUE:   225.932863900636        NO. OF FUNC. EVALS.: 209
 CUMULATIVE NO. OF FUNC. EVALS.:      371
 NPARAMETR:  2.2906E-01 -2.0226E+00  2.0759E+00 -2.3071E-01  8.4293E-02  2.8137E-01  6.4355E-01  8.3869E-02  4.8497E-02  3.8888E-01

 PARAMETER:  1.1453E-01 -1.0113E-01  1.0379E-01 -1.1536E-01 -7.7093E-01 -4.7649E-01  5.7963E-02 -3.3453E-01 -6.0840E-01 -1.1682E-01

 GRADIENT:  -1.2241E-04  8.8742E-01  3.4649E+00  5.7878E-03 -7.1304E-03 -9.6201E-03 -7.1201E-03  3.5951E-02  1.0864E-03  2.8325E-03

 
0ITERATION NO.:   21    OBJECTIVE VALUE:   225.932863900636        NO. OF FUNC. EVALS.:  23
 CUMULATIVE NO. OF FUNC. EVALS.:      394
 NPARAMETR:  2.2906E-01 -2.0226E+00  2.0759E+00 -2.3071E-01  8.4293E-02  2.8137E-01  6.4355E-01  8.3869E-02  4.8497E-02  3.8888E-01

 PARAMETER:  1.1453E-01 -1.0113E-01  1.0379E-01 -1.1536E-01 -7.7093E-01 -4.7649E-01  5.7963E-02 -3.3453E-01 -6.0840E-01 -1.1682E-01

 GRADIENT:   2.4058E-01 -3.6619E-01  2.8783E+00 -4.5932E-01 -1.6937E-02  1.6295E-01  8.9327E-02 -1.3567E-01 -3.9468E-02 -3.4968E-02

 
 #TERM:
0MINIMIZATION SUCCESSFUL
 HOWEVER, PROBLEMS OCCURRED WITH THE MINIMIZATION.
 REGARD THE RESULTS OF THE ESTIMATION STEP CAREFULLY, AND ACCEPT THEM ONLY
 AFTER CHECKING THAT THE COVARIANCE STEP PRODUCES REASONABLE OUTPUT.
 NO. OF FUNCTION EVALUATIONS USED:      394
 NO. OF SIG. DIGITS IN FINAL EST.:  3.3

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -1.5832E-02  5.6481E-04 -4.7105E-03  2.3729E-02
 SE:             6.8979E-02  5.0426E-02  3.6759E-02  4.6526E-02
 N:                      32          32          32          32
 
 P VAL.:         8.1847E-01  9.9106E-01  8.9804E-01  6.1003E-01
 
 ETASHRINKSD(%)  5.0581E+01  1.0000E-10  4.0645E+00  5.7120E+01
 ETASHRINKVR(%)  7.5578E+01  1.0000E-10  7.9638E+00  8.1613E+01
 EBVSHRINKSD(%)  5.0189E+01  1.3826E+00  5.4733E+00  5.5771E+01
 EBVSHRINKVR(%)  7.5189E+01  2.7461E+00  1.0647E+01  8.0438E+01
 RELATIVEINF(%)  2.2728E+01  9.6960E+01  8.9052E+01  1.7867E+01
 EPSSHRINKSD(%)  1.5925E+01  1.5685E+01
 EPSSHRINKVR(%)  2.9314E+01  2.8910E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):          251
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    461.307143668746     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    225.932863900636     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       687.240007569381     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           128
  
 #TERE:
 Elapsed estimation  time in seconds:    13.26
0R MATRIX ALGORITHMICALLY NON-POSITIVE-SEMIDEFINITE
 BUT NONSINGULAR
0R MATRIX IS OUTPUT
0COVARIANCE STEP ABORTED
 Elapsed covariance  time in seconds:     5.58
 Elapsed postprocess time in seconds:     0.06
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 #OBJT:**************                       MINIMUM VALUE OF OBJECTIVE FUNCTION                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************      225.933       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6     
 
         2.29E-01 -2.02E+00  2.08E+00 -2.31E-01  8.43E-02  2.81E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        6.44E-01
 
 ETA2
+        0.00E+00  8.39E-02
 
 ETA3
+        0.00E+00  0.00E+00  4.85E-02
 
 ETA4
+        0.00E+00  0.00E+00  0.00E+00  3.89E-01
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1      EPS2     
 
 EPS1
+        1.00E+00
 
 EPS2
+        0.00E+00  1.00E+00
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        8.02E-01
 
 ETA2
+        0.00E+00  2.90E-01
 
 ETA3
+        0.00E+00  0.00E+00  2.20E-01
 
 ETA4
+        0.00E+00  0.00E+00  0.00E+00  6.24E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1      EPS2     
 
 EPS1
+        1.00E+00
 
 EPS2
+        0.00E+00  1.00E+00
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                                     R MATRIX                                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      OM11      OM12      OM13      OM14      OM22      OM23  
             OM24      OM33      OM34      OM44      SG11      SG12      SG22  
 
 TH 1
+        1.41E+01
 
 TH 2
+        1.86E+01  3.71E+02
 
 TH 3
+        1.90E+00 -1.28E+03  5.90E+02
 
 TH 4
+       -2.53E+00  1.20E+01 -5.51E+00  1.96E+01
 
 TH 5
+        1.47E+00  4.00E+04 -1.19E+02 -3.51E+05  1.24E+06
 
 TH 6
+        1.20E+00 -1.50E+02  5.75E+00 -1.25E+00  2.10E+03  8.19E+02
 
 OM11
+       -3.46E+00 -2.22E+01  1.34E-01 -1.23E+00  5.72E-01  4.53E+00  8.21E+00
 
 OM12
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+       -3.75E-01 -4.12E-01 -5.54E+00 -6.98E-02  2.07E+02 -2.13E+01  7.74E-01 ......... ......... .........  2.14E+03
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         .........
 
 OM33
+        9.65E+00 -4.06E+01 -5.89E+01 -1.81E+00  4.20E+02  5.96E+01  2.53E+00 ......... ......... ......... -2.54E+01 .........
         .........  5.54E+03
 
 OM34
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... .........
 
 OM44
+        2.11E+00  3.57E+01  6.91E-01  8.29E+00 -1.34E-01  2.70E+00 -5.65E-01 ......... ......... .........  8.25E-01 .........
         ......... -1.60E-01 .........  1.88E+01
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... ......... .........
 
 SG12
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... ......... ......... .........
 
 SG22
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... ......... ......... ......... .........
 
 Elapsed finaloutput time in seconds:     0.04
 #CPUT: Total CPU Time in Seconds,       14.172
