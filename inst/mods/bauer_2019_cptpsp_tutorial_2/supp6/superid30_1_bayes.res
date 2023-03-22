Mon 03/11/2019 
10:00 PM
$PROB Testing Inter-occasion with Inter-Site (example30_1.ctl)

$INPUT C SID ID OCC TIME AMT RATE EVID MDV CMT DV ROWNUM
$ABBR REPLACE ETA(OCC_CL)=ETA(5,7,9)
$ABBR REPLACE ETA(OCC_V)=ETA(6,8,10)
$DATA superid30.csv IGNORE=@

$SUBROUTINES ADVAN1 TRANS2

$PK
MU_1=THETA(1)
MU_2=THETA(2)
CL=EXP(MU_1+ETA(1)+ETA(3)+ETA(OCC_CL))
V=EXP(MU_2+ETA(2)+ETA(4)+ETA(OCC_V))
S1=V

$ERROR
IPRED=F
IF(IPRED==0.0) IPRED=0.00001
Y = IPRED+IPRED*EPS(1)


;Initial Thetas
$THETA
 2.0  ;[CL]
 3.0  ;[V]

;Individual omegas (1,2)
$OMEGA BLOCK(2)
 .1
 -.0001  .1

;SID OMEGAS (3,4)
$OMEGA BLOCK(2)
 .3
-.0001 .3

; inter-occasion omegas for occasion 1 (5,6)
$OMEGA BLOCK(2)
 .03 
 -.0001 .03

; inter-occasion omegas for occasion 2 and 3
; SAME(n) means repeat block structure n times;
; and omega parameters used for occasions 2 and 3 are shared 
; with those of occasion 1. 
$OMEGA BLOCK(2) SAME(2)

$SIGMA
 0.1

; PRIOR INFORMATION
$PRIOR NWPRI
;Individual omegas
$OMEGAP BLOCK(2)
 .03 FIXED
 0.0   .03
$OMEGAPD (2.0 FIXED)

;SID OMEGAS
$OMEGAP BLOCK(2)
 .1 FIXED
 0.0 .1
$OMEGAPD (2.0 FIXED)

; inter-occasion omegas
$OMEGAP BLOCK(2)
 .01 FIXED
 0.0 .01
$OMEGAP BLOCK(2) SAME(2)
$OMEGAPD (2.0 FIXED)

$LEVEL
SID=(3[1],4[2])

$EST METHOD=ITS INTERACTION PRINT=1 NSIG=2 NITER=500 SIGL=8 FNLETA=0 NOHABORT CTYPE=3 NOPRIOR=1
$EST METHOD=BAYES INTERACTION PRINT=10 NSIG=2 NBURN=1000 NITER=1000 SIGL=8 FNLETA=0 NOABORT CTYPE=3 NOPRIOR=0
     ISAMPLE_M1=1 ISAMPLE_M1B=0 ISAMPLE_M2=1 ISAMPLE_M3=1 ; set these low for speed
$COV MATRIX=R UNCONDITIONAL

$TABLE ID SID OCC TIME IPRED ETAS(1:LAST) 
       FILE=superid30_1_bayes.tab NOPRINT NOAPPEND ONEHEADER
  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  126) ONLY THE LAST FNLETA LISTED IN THE SERIES OF $EST RECORDS FOR
 THIS PROBLEM WILL BE USED
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
             
 (WARNING  3) THERE MAY BE AN ERROR IN THE ABBREVIATED CODE. THE FOLLOWING
 ONE OR MORE RANDOM VARIABLES ARE DEFINED WITH "IF" STATEMENTS THAT DO NOT
 PROVIDE DEFINITIONS FOR BOTH THE "THEN" AND "ELSE" CASES. IF ALL
 CONDITIONS FAIL, THE VALUES OF THESE VARIABLES WILL BE ZERO.
  
   ETA(OCC_CL) ETA(OCC_V)


 (MU_WARNING 12) MU_001: SHOULD NOT BE ASSOCIATED WITH ETA(003)

 (MU_WARNING 11) MU_001: SHOULD NOT BE ASSOCIATED WITH MORE THAN ONE ETA.

 (MU_WARNING 12) MU_002: SHOULD NOT BE ASSOCIATED WITH ETA(004)

 (MU_WARNING 11) MU_002: SHOULD NOT BE ASSOCIATED WITH MORE THAN ONE ETA.
  
License Registered to: IDS NONMEM 7 TEAM
Expiration Date:     2 JUN 2030
Current Date:       11 MAR 2019
Days until program expires :4096
1NONLINEAR MIXED EFFECTS MODEL PROGRAM (NONMEM) VERSION 7.4.3
 ORIGINALLY DEVELOPED BY STUART BEAL, LEWIS SHEINER, AND ALISON BOECKMANN
 CURRENT DEVELOPERS ARE ROBERT BAUER, ICON DEVELOPMENT SOLUTIONS,
 AND ALISON BOECKMANN. IMPLEMENTATION, EFFICIENCY, AND STANDARDIZATION
 PERFORMED BY NOUS INFOSYSTEMS.

 PROBLEM NO.:         1
 Testing Inter-occasion with Inter-Site (example30_1.ctl)
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:     6600
 NO. OF DATA ITEMS IN DATA SET:  12
 ID DATA ITEM IS DATA ITEM NO.:   3
 DEP VARIABLE IS DATA ITEM NO.:  11
 MDV DATA ITEM IS DATA ITEM NO.:  9
0INDICES PASSED TO SUBROUTINE PRED:
   8   5   6   7   0   0  10   0   0   0   0
0LABELS FOR DATA ITEMS:
 C SID ID OCC TIME AMT RATE EVID MDV CMT DV ROWNUM
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 IPRED
0FORMAT FOR DATA:
 (7E10.0/5E10.0)

 TOT. NO. OF OBS RECS:     6000
 TOT. NO. OF INDIVIDUALS:      200
0LENGTH OF THETA:   5
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS BLOCK FORM:
  1
  1  1
  0  0  2
  0  0  2  2
  0  0  0  0  3
  0  0  0  0  3  3
  0  0  0  0  0  0  3
  0  0  0  0  0  0  3  3
  0  0  0  0  0  0  0  0  3
  0  0  0  0  0  0  0  0  3  3
  0  0  0  0  0  0  0  0  0  0  4
  0  0  0  0  0  0  0  0  0  0  4  4
  0  0  0  0  0  0  0  0  0  0  0  0  5
  0  0  0  0  0  0  0  0  0  0  0  0  5  5
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  6
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  6  6
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  6
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  6  6
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  6
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  6  6
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   1
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
 LOWER BOUND    INITIAL EST    UPPER BOUND
 -0.1000E+07     0.2000E+01     0.1000E+07
 -0.1000E+07     0.3000E+01     0.1000E+07
  0.2000E+01     0.2000E+01     0.2000E+01
  0.2000E+01     0.2000E+01     0.2000E+01
  0.2000E+01     0.2000E+01     0.2000E+01
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.1000E+00
                 -0.1000E-03   0.1000E+00
        2                                                                                   NO
                  0.3000E+00
                 -0.1000E-03   0.3000E+00
        3                                                                                   NO
                  0.3000E-01
                 -0.1000E-03   0.3000E-01
        4                                                                                  YES
                  0.3000E-01
                  0.0000E+00   0.3000E-01
        5                                                                                  YES
                  0.1000E+00
                  0.0000E+00   0.1000E+00
        6                                                                                  YES
                  0.1000E-01
                  0.0000E+00   0.1000E-01
0INITIAL ESTIMATE OF SIGMA:
 0.1000E+00
0COVARIANCE STEP OMITTED:        NO
 R MATRIX SUBSTITUTED:          YES
 S MATRIX SUBSTITUTED:           NO
 EIGENVLS. PRINTED:              NO
 COMPRESSED FORMAT:              NO
 GRADIENT METHOD USED:     NOSLOW
 SIGDIGITS ETAHAT (SIGLO):                  -1
 SIGDIGITS GRADIENTS (SIGL):                -1
 EXCLUDE COV FOR FOCE (NOFCOV):              NO
 TURN OFF Cholesky Transposition of R Matrix (CHOLROFF): NO
 KNUTHSUMOFF:                                -1
 RESUME COV ANALYSIS (RESUME):               NO
 SIR SAMPLE SIZE (SIRSAMPLE):              -1
 NON-LINEARLY TRANSFORM THETAS DURING COV (THBND): 1
 PRECONDTIONING CYCLES (PRECOND):        0
 PRECONDTIONING TYPES (PRECONDS):        TOS
 FORCED PRECONDTIONING CYCLES (PFCOND):0
 PRECONDTIONING TYPE (PRETYPE):        0
 FORCED POS. DEFINITE SETTING: (FPOSDEF):0
0TABLES STEP OMITTED:    NO
 NO. OF TABLES:           1
 SEED NUMBER (SEED):    11456
 RANMETHOD:             3U
 MC SAMPLES (ESAMPLE):    300
 WRES SQUARE ROOT TYPE (WRESCHOL): EIGENVALUE
0-- TABLE   1 --
0RECORDS ONLY:    ALL
04 COLUMNS APPENDED:    NO
 PRINTED:                NO
 HEADERS:               ONE
 FILE TO BE FORWARDED:   NO
 FORMAT:                S1PE11.4
 LFORMAT:
 RFORMAT:
 FIXED_EFFECT_ETAS:
0USER-CHOSEN ITEMS:
 ID SID OCC TIME IPRED ETA1 ETA2 ETA3 ETA4 ETA5 ETA6 ETA7 ETA8 ETA9 ET10
0
 PRIOR SUBROUTINE USER-SUPPLIED
1DOUBLE PRECISION PREDPP VERSION 7.4.3

 ONE COMPARTMENT MODEL (ADVAN1)
0MAXIMUM NO. OF BASIC PK PARAMETERS:   2
0BASIC PK PARAMETERS (AFTER TRANSLATION):
   ELIMINATION RATE (K) IS BASIC PK PARAMETER NO.:  1

 TRANSLATOR WILL CONVERT PARAMETERS
 CLEARANCE (CL) AND VOLUME (V) TO K (TRANS2)
0COMPARTMENT ATTRIBUTES
 COMPT. NO.   FUNCTION   INITIAL    ON/OFF      DOSE      DEFAULT    DEFAULT
                         STATUS     ALLOWED    ALLOWED    FOR DOSE   FOR OBS.
    1         CENTRAL      ON         NO         YES        YES        YES
    2         OUTPUT       OFF        YES        NO         NO         NO
1
 ADDITIONAL PK PARAMETERS - ASSIGNMENT OF ROWS IN GG
 COMPT. NO.                             INDICES
              SCALE      BIOAVAIL.   ZERO-ORDER  ZERO-ORDER  ABSORB
                         FRACTION    RATE        DURATION    LAG
    1            3           *           *           *           *
    2            *           -           -           -           -
             - PARAMETER IS NOT ALLOWED FOR THIS MODEL
             * PARAMETER IS NOT SUPPLIED BY PK SUBROUTINE;
               WILL DEFAULT TO ONE IF APPLICABLE
0DATA ITEM INDICES USED BY PRED ARE:
   EVENT ID DATA ITEM IS DATA ITEM NO.:      8
   TIME DATA ITEM IS DATA ITEM NO.:          5
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   6
   DOSE RATE DATA ITEM IS DATA ITEM NO.:     7
   COMPT. NO. DATA ITEM IS DATA ITEM NO.:   10

0PK SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 PK SUBROUTINE NOT CALLED AT NONEVENT (ADDITIONAL OR LAGGED) DOSE TIMES.
0ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
1
 
 
 #TBLN:      1
 #METH: Iterative Two Stage (No Prior)
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            3248
 NO. OF SIG. FIGURES REQUIRED:            2
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
 ABORT WITH PRED EXIT CODE 1:             NO
 IND. OBJ. FUNC. VALUES SORTED:           NO
 NUMERICAL DERIVATIVE
       FILE REQUEST (NUMDER):               NONE
 MAP (ETAHAT) ESTIMATION METHOD (OPTMAP):   0
 ETA HESSIAN EVALUATION METHOD (ETADER):    0
 INITIAL ETA FOR MAP ESTIMATION (MCETA):    0
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      8
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     8
 NOPRIOR SETTING (NOPRIOR):                 ON
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          OFF
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): superid30_1_bayes.ext
 EXCLUDE TITLE (NOTITLE):                   NO
 EXCLUDE COLUMN LABELS (NOLABEL):           NO
 FORMAT FOR ADDITIONAL FILES (FORMAT):      S1PE12.5
 PARAMETER ORDER FOR OUTPUTS (ORDER):       TSOL
 WISHART PRIOR DF INTERPRETATION (WISHTYPE):0
 KNUTHSUMOFF:                               0
 INCLUDE LNTWOPI:                           NO
 INCLUDE CONSTANT TERM TO PRIOR (PRIORC):   NO
 INCLUDE CONSTANT TERM TO OMEGA (ETA) (OLNTWOPI):NO
 NESTED LEVEL MAPS:
  SID=(3[1],4[2])
 Level Weighting Type (LEVWT):0
 EM OR BAYESIAN METHOD USED:                ITERATIVE TWO STAGE (ITS)
 MU MODELING PATTERN (MUM):
 GRADIENT/GIBBS PATTERN (GRD):
 AUTOMATIC SETTING FEATURE (AUTO):          OFF
 CONVERGENCE TYPE (CTYPE):                  3
 CONVERGENCE INTERVAL (CINTERVAL):          1
 CONVERGENCE ITERATIONS (CITER):            10
 CONVERGENCE ALPHA ERROR (CALPHA):          5.000000000000000E-02
 ITERATIONS (NITER):                        500
 ANEAL SETTING (CONSTRAIN):                 1

 
 THE FOLLOWING LABELS ARE EQUIVALENT
 PRED=PREDI
 RES=RESI
 WRES=WRESI
 IWRS=IWRESI
 IPRD=IPREDI
 IRS=IRESI
 
 EM/BAYES SETUP:
 THETAS THAT ARE MU MODELED:
   1   2
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 iteration            0 OBJ=   10777.3343969778
 iteration            1 OBJ=   8290.31610784498
 iteration            2 OBJ=   7688.37371044716
 iteration            3 OBJ=   7219.21101853080
 iteration            4 OBJ=   6788.71171183154
 iteration            5 OBJ=   6370.42905615658
 iteration            6 OBJ=   5957.78157846601
 iteration            7 OBJ=   5548.91755960557
 iteration            8 OBJ=   5143.23841384729
 iteration            9 OBJ=   4740.57906883317
 iteration           10 OBJ=   4341.03186098920
 iteration           11 OBJ=   3944.96788561875
 iteration           12 OBJ=   3553.20264704010
 iteration           13 OBJ=   3167.41191456711
 iteration           14 OBJ=   2791.10139401375
 iteration           15 OBJ=   2431.95119747950
 iteration           16 OBJ=   2108.00839060779
 iteration           17 OBJ=   1864.27520677671
 iteration           18 OBJ=   1776.80788048372
 iteration           19 OBJ=   1773.23970804671
 iteration           20 OBJ=   1772.39427596157
 iteration           21 OBJ=   1772.14700818411
 iteration           22 OBJ=   1772.07707763657
 iteration           23 OBJ=   1772.05853147003
 iteration           24 OBJ=   1772.05430633985
 iteration           25 OBJ=   1772.05376975889
 iteration           26 OBJ=   1772.05400755054
 iteration           27 OBJ=   1772.05429660039
 iteration           28 OBJ=   1772.05450230372
 iteration           29 OBJ=   1772.05462896442
 iteration           30 OBJ=   1772.05470257418
 iteration           31 OBJ=   1772.05474404150
 Convergence achieved
 
 #TERM:
 OPTIMIZATION WAS COMPLETED


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -1.7390E-06 -1.5843E-06  1.6931E-17 -1.4100E-16 -3.6871E-03 -3.8922E-03 -1.8994E-03 -4.9897E-03  5.5859E-03  8.8814E-03
 SE:             1.0680E-02  1.0695E-02  5.6431E-02  9.5683E-02  5.9674E-03  6.1619E-03  5.6445E-03  5.5760E-03  5.7886E-03  5.7027E-03
 N:                     200         200          20          20         200         200         200         200         200         200
 
 P VAL.:         9.9987E-01  9.9988E-01  1.0000E+00  1.0000E+00  5.3666E-01  5.2761E-01  7.3649E-01  3.7087E-01  3.3456E-01  1.1937E-01
 
 ETASHRINKSD(%)  6.1244E+00  6.3192E+00  1.0535E-04  5.9389E-05  1.7527E+01  1.5883E+01  2.1990E+01  2.3881E+01  1.9998E+01  2.2152E+01
 ETASHRINKVR(%)  1.1874E+01  1.2239E+01  2.1070E-04  1.1878E-04  3.1982E+01  2.9244E+01  3.9145E+01  4.2059E+01  3.5996E+01  3.9396E+01
 EBVSHRINKSD(%)  6.1242E+00  6.3190E+00  0.0000E+00  0.0000E+00  1.9717E+01  2.0333E+01  1.9716E+01  2.0333E+01  1.9734E+01  2.0334E+01
 EBVSHRINKVR(%)  1.1873E+01  1.2239E+01  0.0000E+00  0.0000E+00  3.5546E+01  3.6532E+01  3.5545E+01  3.6531E+01  3.5573E+01  3.6533E+01
 EPSSHRINKSD(%)  9.5738E+00
 EPSSHRINKVR(%)  1.8231E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         6000
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    11027.2623984561     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    1772.05474404150     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       12799.3171424976     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                          1598
  
 #TERE:
 Elapsed estimation  time in seconds:    34.44
 Elapsed covariance  time in seconds:     0.27
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     1772.055       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2     
 
         1.23E+00  4.01E+00
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        2.88E-02
 
 ETA2
+        3.01E-03  2.90E-02
 
 ETA3
+        0.00E+00  0.00E+00  6.70E-02
 
 ETA4
+        0.00E+00  0.00E+00  3.56E-03  1.93E-01
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.05E-02
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.58E-04  1.08E-02
 
 ETA7
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.05E-02
 
 ETA8
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.58E-04  1.08E-02
 
 ETA9
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.05E-02
 
 ET10
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.58E-04  1.08E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        9.90E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        1.70E-01
 
 ETA2
+        1.04E-01  1.70E-01
 
 ETA3
+        0.00E+00  0.00E+00  2.59E-01
 
 ETA4
+        0.00E+00  0.00E+00  3.13E-02  4.39E-01
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.03E-01
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.36E-02  1.04E-01
 
 ETA7
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.03E-01
 
 ETA8
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.36E-02  1.04E-01
 
 ETA9
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.03E-01
 
 ET10
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.36E-02  1.04E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        9.95E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                          STANDARD ERROR OF ESTIMATE (S)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2     
 
         1.38E-02  1.46E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        3.54E-03
 
 ETA2
+        2.45E-03  3.59E-03
 
 ETA3
+        0.00E+00  0.00E+00  2.03E-02
 
 ETA4
+        0.00E+00  0.00E+00  2.88E-02  1.09E-01
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  8.01E-04
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  7.84E-04  9.72E-04
 
 ETA7
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  8.01E-04
 
 ETA8
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  7.84E-04  9.72E-04
 
 ETA9
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  8.01E-04
 
 ET10
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  7.84E-04  9.72E-04
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        2.08E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        1.05E-02
 
 ETA2
+        8.30E-02  1.06E-02
 
 ETA3
+       ......... .........  3.93E-02
 
 ETA4
+       ......... .........  2.57E-01  1.25E-01
 
 ETA5
+       ......... ......... ......... .........  3.91E-03
 
 ETA6
+       ......... ......... ......... .........  7.41E-02  4.68E-03
 
 ETA7
+       ......... ......... ......... ......... ......... ......... .........
 
 ETA8
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 ETA9
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 ET10
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.05E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (S)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
  TH 1
+          1.89E-04
 
  TH 2
+          1.25E-05  2.13E-04
 
 OM0101
+          7.86E-06 -2.52E-06  1.26E-05
 
 OM0102
+         -5.85E-07  1.02E-06  1.26E-06  6.00E-06
 
 OM0103
+         ......... ......... ......... ......... .........
 
 OM0104
+         ......... ......... ......... ......... ......... .........
 
 OM0105
+         ......... ......... ......... ......... ......... ......... .........
 
 OM0106
+         ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0107
+         ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0108
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0109
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0110
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0202
+          1.58E-06 -6.16E-06  4.72E-07  1.97E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.29E-05
 
 OM0203
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... .........
 
 OM0204
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0205
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0206
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
 OM0207
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0208
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... .........
 
 OM0209
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0210
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0303
+         -6.49E-06 -1.19E-06 -3.19E-06  1.55E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            6.55E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.13E-04
 
 OM0304
+          7.73E-06  1.60E-05  3.85E-06 -4.26E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            9.28E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.21E-04  8.27E-04
 
 OM0305
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0306
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0307
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
 OM0308
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0309
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0310
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0404
+          5.56E-05  1.82E-05  2.65E-05 -1.63E-05  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -3.53E-05  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  2.39E-04 -6.48E-04  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.20E-02
 
 OM0405
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0406
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0407
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0408
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0409
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0410
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0505
+          4.34E-07 -4.61E-09 -3.83E-07 -1.01E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -1.55E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  2.14E-06 -1.04E-06  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  5.91E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            6.42E-07
 
 OM0506
+         -2.55E-07 -1.66E-06  6.72E-08 -1.55E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -1.32E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  9.60E-07 -1.26E-06  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.04E-05  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.17E-07  6.15E-07
 
 OM0507
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0508
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0509
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0510
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
 OM0606
+          4.96E-07 -3.94E-06  6.71E-08  7.27E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -5.66E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -6.32E-07 -1.50E-06  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.09E-05  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.44E-07  1.02E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  9.45E-07
 
 OM0607
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0608
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0609
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0610
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0707
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0708
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0709
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0710
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0808
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0809
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0810
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... .........
 
 OM0909
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
 OM0910
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM1010
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG0101
+         -2.44E-07  3.85E-07 -5.36E-08 -3.53E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -1.80E-09  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  7.53E-08  3.33E-07  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.70E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            3.29E-09  8.07E-09  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.91E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.33E-08
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (S)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
  TH 1
+          1.38E-02
 
  TH 2
+          6.24E-02  1.46E-02
 
 OM0101
+          1.61E-01 -4.87E-02  3.54E-03
 
 OM0102
+         -1.74E-02  2.85E-02  1.45E-01  2.45E-03
 
 OM0103
+         ......... ......... ......... ......... .........
 
 OM0104
+         ......... ......... ......... ......... ......... .........
 
 OM0105
+         ......... ......... ......... ......... ......... ......... .........
 
 OM0106
+         ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0107
+         ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0108
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0109
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0110
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0202
+          3.20E-02 -1.17E-01  3.70E-02  2.23E-01  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            3.59E-03
 
 OM0203
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... .........
 
 OM0204
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0205
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0206
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
 OM0207
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0208
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... .........
 
 OM0209
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0210
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0303
+         -2.32E-02 -4.01E-03 -4.43E-02  3.11E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            8.96E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  2.03E-02
 
 OM0304
+          1.95E-02  3.81E-02  3.77E-02 -6.04E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            8.98E-03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.78E-01  2.88E-02
 
 OM0305
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0306
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0307
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
 OM0308
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0309
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0310
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0404
+          3.70E-02  1.14E-02  6.83E-02 -6.09E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -8.98E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.07E-01 -2.06E-01  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.09E-01
 
 OM0405
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0406
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0407
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0408
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0409
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0410
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0505
+          3.94E-02 -3.94E-04 -1.35E-01 -5.15E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -5.39E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.31E-01 -4.53E-02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  6.74E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            8.01E-04
 
 OM0506
+         -2.37E-02 -1.45E-01  2.42E-02 -8.08E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -4.69E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  6.02E-02 -5.58E-02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.21E-01  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.86E-01  7.84E-04
 
 OM0507
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0508
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0509
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0510
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
 OM0606
+          3.71E-02 -2.78E-01  1.95E-02  3.05E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -1.62E-01  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.20E-02 -5.38E-02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.03E-01  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.85E-01  1.33E-01  0.00E+00  0.00E+00  0.00E+00  0.00E+00  9.72E-04
 
 OM0607
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0608
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0609
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0610
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0707
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0708
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0709
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0710
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0808
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0809
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0810
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... .........
 
 OM0909
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
 OM0910
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM1010
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG0101
+         -8.52E-02  1.27E-01 -7.27E-02 -6.93E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -2.41E-03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.78E-02  5.57E-02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -7.47E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.97E-02  4.94E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -9.46E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  2.08E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
  TH 1
+          5.57E+03
 
  TH 2
+         -5.42E+02  5.51E+03
 
 OM0101
+         -3.70E+03  1.01E+03  8.69E+04
 
 OM0102
+          2.01E+03 -2.95E+03 -1.91E+04  1.85E+05
 
 OM0103
+         ......... ......... ......... ......... .........
 
 OM0104
+         ......... ......... ......... ......... ......... .........
 
 OM0105
+         ......... ......... ......... ......... ......... ......... .........
 
 OM0106
+         ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0107
+         ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0108
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0109
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0110
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0202
+         -1.46E+03  4.26E+03  6.13E+01 -2.99E+04  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            8.91E+04
 
 OM0203
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... .........
 
 OM0204
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0205
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0206
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
 OM0207
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0208
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... .........
 
 OM0209
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0210
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0303
+          7.73E+01 -2.60E+01  2.32E+02 -5.81E+01  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -1.58E+03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  2.92E+03
 
 OM0304
+         -3.27E+01 -5.47E+01 -6.16E+02  1.20E+03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -3.61E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  7.66E+02  1.49E+03
 
 OM0305
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0306
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0307
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
 OM0308
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0309
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0310
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0404
+         -2.20E+01  6.71E+00 -2.50E+02  2.10E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            2.93E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.45E+01  6.96E+01  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  9.33E+01
 
 OM0405
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0406
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0407
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0408
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0409
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0410
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0505
+         -1.90E+03 -2.01E+03  1.91E+04  3.81E+03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            6.71E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.01E+03 -6.14E+02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.95E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.94E+05
 
 OM0506
+          1.05E+03  4.06E+03 -6.93E+03  1.24E+04  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            2.28E+03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -6.30E+02  2.41E+02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -4.79E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -3.11E+04  1.98E+05
 
 OM0507
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0508
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0509
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0510
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
 OM0606
+         -1.69E+03  8.21E+03 -2.55E+03 -1.43E+04  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            2.48E+04  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.11E+03  1.08E+03  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  5.88E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -3.15E+04 -1.38E+04  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.45E+05
 
 OM0607
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0608
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0609
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0610
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0707
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0708
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0709
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0710
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0808
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0809
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0810
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... .........
 
 OM0909
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
 OM0910
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM1010
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG0101
+          3.01E+04 -4.32E+04  5.28E+04  1.36E+05  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -1.83E+04  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -8.21E+03 -8.11E+03  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  3.96E+03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -3.65E+04 -1.70E+05  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.23E+05  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  2.43E+07
 
1
 
 
 #TBLN:      2
 #METH: MCMC Bayesian Analysis
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            3248
 NO. OF SIG. FIGURES REQUIRED:            2
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
 ABORT WITH PRED EXIT CODE 1:             NO
 IND. OBJ. FUNC. VALUES SORTED:           NO
 NUMERICAL DERIVATIVE
       FILE REQUEST (NUMDER):               NONE
 MAP (ETAHAT) ESTIMATION METHOD (OPTMAP):   0
 ETA HESSIAN EVALUATION METHOD (ETADER):    0
 INITIAL ETA FOR MAP ESTIMATION (MCETA):    0
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      8
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     8
 NOPRIOR SETTING (NOPRIOR):                 OFF
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          OFF
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): superid30_1_bayes.ext
 EXCLUDE TITLE (NOTITLE):                   NO
 EXCLUDE COLUMN LABELS (NOLABEL):           NO
 FORMAT FOR ADDITIONAL FILES (FORMAT):      S1PE12.5
 PARAMETER ORDER FOR OUTPUTS (ORDER):       TSOL
 WISHART PRIOR DF INTERPRETATION (WISHTYPE):0
 KNUTHSUMOFF:                               0
 INCLUDE LNTWOPI:                           NO
 INCLUDE CONSTANT TERM TO PRIOR (PRIORC):   NO
 INCLUDE CONSTANT TERM TO OMEGA (ETA) (OLNTWOPI):NO
 NESTED LEVEL MAPS:
  SID=(3[1],4[2])
 Level Weighting Type (LEVWT):0
 EM OR BAYESIAN METHOD USED:                MCMC BAYESIAN (BAYES)
 MU MODELING PATTERN (MUM):
 GRADIENT/GIBBS PATTERN (GRD):
 AUTOMATIC SETTING FEATURE (AUTO):          OFF
 CONVERGENCE TYPE (CTYPE):                  3
 KEEP ITERATIONS (THIN):            1
 CONVERGENCE INTERVAL (CINTERVAL):          10
 CONVERGENCE ITERATIONS (CITER):            10
 CONVERGENCE ALPHA ERROR (CALPHA):          5.000000000000000E-02
 BURN-IN ITERATIONS (NBURN):                1000
 ITERATIONS (NITER):                        1000
 ANEAL SETTING (CONSTRAIN):                 1
 STARTING SEED FOR MC METHODS (SEED):       11456
 MC SAMPLES PER SUBJECT (ISAMPLE):          1
 RANDOM SAMPLING METHOD (RANMETHOD):        3U
 PROPOSAL DENSITY SCALING RANGE
              (ISCALE_MIN, ISCALE_MAX):     1.000000000000000E-06   ,1000000.00000000
 SAMPLE ACCEPTANCE RATE (IACCEPT):          0.400000000000000
 METROPOLIS HASTINGS SAMPLING FOR INDIVIDUAL ETAS:
 SAMPLES FOR GLOBAL SEARCH KERNEL (ISAMPLE_M1):          1
 SAMPLES FOR NEIGHBOR SEARCH KERNEL (ISAMPLE_M1A):       0
 SAMPLES FOR MASS/IMP/POST. MATRIX SEARCH (ISAMPLE_M1B): 0
 SAMPLES FOR LOCAL SEARCH KERNEL (ISAMPLE_M2):           1
 SAMPLES FOR LOCAL UNIVARIATE KERNEL (ISAMPLE_M3):       1
 PWR. WT. MASS/IMP/POST MATRIX ACCUM. FOR ETAS (IKAPPA): 1.00000000000000
 MASS/IMP./POST. MATRIX REFRESH SETTING (MASSREST):      -1
 METROPOLIS HASTINGS POPULATION SAMPLING FOR NON-GIBBS
 SAMPLED THETAS AND SIGMAS:
 PROPOSAL DENSITY SCALING RANGE
              (PSCALE_MIN, PSCALE_MAX):   1.000000000000000E-02   ,1000.00000000000
 SAMPLE ACCEPTANCE RATE (PACCEPT):                       0.500000000000000
 SAMPLES FOR GLOBAL SEARCH KERNEL (PSAMPLE_M1):          1
 SAMPLES FOR LOCAL SEARCH KERNEL (PSAMPLE_M2):           -1
 SAMPLES FOR LOCAL UNIVARIATE KERNEL (PSAMPLE_M3):       1
 METROPOLIS HASTINGS POPULATION SAMPLING FOR NON-GIBBS
 SAMPLED OMEGAS:
 SAMPLE ACCEPTANCE RATE (OACCEPT):                       0.500000000000000
 SAMPLES FOR GLOBAL SEARCH KERNEL (OSAMPLE_M1):          -1
 SAMPLES FOR LOCAL SEARCH KERNEL (OSAMPLE_M2):           15
 SAMPLES FOR LOCAL UNIVARIATE SEARCH KERNEL (OSAMPLE_M3):15
 DEG. FR. FOR T DIST.  PRIOR FOR THETAS (TTDF):        0.00000000000000
 DEG. FR. FOR LKJ CORRELATION PRIOR FOR OMEGAS (OLKJDF): 0.00000000000000
 WEIGHT FACTOR FOR STD PRIOR FOR OMEGAS (OVARF): 1.00000000000000
 DEG. FR. FOR LKJ CORRELATION PRIOR FOR SIGMAS (SLKJDF): 0.00000000000000
 WEIGHT FACTOR FOR STD PRIOR FOR SIGMAS (SVARF): 1.00000000000000

 
 THE FOLLOWING LABELS ARE EQUIVALENT
 PRED=PREDI
 RES=RESI
 WRES=WRESI
 IWRS=IWRESI
 IPRD=IPREDI
 IRS=IRESI
 
 EM/BAYES SETUP:
 THETAS THAT ARE MU MODELED:
   1   2
 THETAS THAT ARE GIBBS SAMPLED:
   1   2
 THETAS THAT ARE METROPOLIS-HASTINGS SAMPLED:
 
 SIGMAS THAT ARE GIBBS SAMPLED:
   1
 SIGMAS THAT ARE METROPOLIS-HASTINGS SAMPLED:
 
 OMEGAS ARE GIBBS SAMPLED
 
 MONITORING OF SEARCH:

 Burn-in Mode
 iteration        -1000 MCMCOBJ=   -9656.28167187030     
 iteration         -990 MCMCOBJ=   -9023.92093331477     
 iteration         -980 MCMCOBJ=   -8992.95425389729     
 iteration         -970 MCMCOBJ=   -8694.97056615261     
 iteration         -960 MCMCOBJ=   -8696.69547868606     
 iteration         -950 MCMCOBJ=   -8573.16916522813     
 iteration         -940 MCMCOBJ=   -8501.40943324090     
 iteration         -930 MCMCOBJ=   -8643.36853641208     
 iteration         -920 MCMCOBJ=   -8600.65490759479     
 iteration         -910 MCMCOBJ=   -8512.10140900844     
 iteration         -900 MCMCOBJ=   -8466.93320931739     
 iteration         -890 MCMCOBJ=   -8562.52439584213     
 iteration         -880 MCMCOBJ=   -8376.22139099698     
 iteration         -870 MCMCOBJ=   -8328.72058174119     
 iteration         -860 MCMCOBJ=   -8381.65379379547     
 iteration         -850 MCMCOBJ=   -8410.38640280636     
 iteration         -840 MCMCOBJ=   -8348.05505814722     
 iteration         -830 MCMCOBJ=   -8393.29606813020     
 iteration         -820 MCMCOBJ=   -8388.70746560907     
 Convergence achieved
 Sampling Mode
 iteration            0 MCMCOBJ=   -8386.18686243731     
 iteration           10 MCMCOBJ=   -8382.76242698846     
 iteration           20 MCMCOBJ=   -8313.61922764051     
 iteration           30 MCMCOBJ=   -8378.34875028625     
 iteration           40 MCMCOBJ=   -8547.55422812235     
 iteration           50 MCMCOBJ=   -8443.79940682326     
 iteration           60 MCMCOBJ=   -8362.29682796794     
 iteration           70 MCMCOBJ=   -8346.54811029682     
 iteration           80 MCMCOBJ=   -8359.33911018918     
 iteration           90 MCMCOBJ=   -8325.49916968227     
 iteration          100 MCMCOBJ=   -8356.66843623974     
 iteration          110 MCMCOBJ=   -8342.20173397264     
 iteration          120 MCMCOBJ=   -8375.45452892454     
 iteration          130 MCMCOBJ=   -8446.31836553821     
 iteration          140 MCMCOBJ=   -8384.24024535769     
 iteration          150 MCMCOBJ=   -8351.17406028996     
 iteration          160 MCMCOBJ=   -8297.58957291269     
 iteration          170 MCMCOBJ=   -8430.93129482571     
 iteration          180 MCMCOBJ=   -8327.10699086278     
 iteration          190 MCMCOBJ=   -8262.09916439747     
 iteration          200 MCMCOBJ=   -8373.20002945967     
 iteration          210 MCMCOBJ=   -8388.45587749865     
 iteration          220 MCMCOBJ=   -8383.04816854600     
 iteration          230 MCMCOBJ=   -8349.14580288045     
 iteration          240 MCMCOBJ=   -8353.25929832630     
 iteration          250 MCMCOBJ=   -8267.01148306614     
 iteration          260 MCMCOBJ=   -8286.96786214950     
 iteration          270 MCMCOBJ=   -8201.44435714484     
 iteration          280 MCMCOBJ=   -8258.82032865067     
 iteration          290 MCMCOBJ=   -8142.85776957809     
 iteration          300 MCMCOBJ=   -8205.83302086666     
 iteration          310 MCMCOBJ=   -8256.21711756910     
 iteration          320 MCMCOBJ=   -8198.53192146340     
 iteration          330 MCMCOBJ=   -8191.99225250224     
 iteration          340 MCMCOBJ=   -8284.95279795582     
 iteration          350 MCMCOBJ=   -8290.67065929214     
 iteration          360 MCMCOBJ=   -8241.06903738125     
 iteration          370 MCMCOBJ=   -8333.09597996656     
 iteration          380 MCMCOBJ=   -8196.30382066979     
 iteration          390 MCMCOBJ=   -8224.99122314824     
 iteration          400 MCMCOBJ=   -8298.32838893035     
 iteration          410 MCMCOBJ=   -8291.53783907736     
 iteration          420 MCMCOBJ=   -8319.79783859237     
 iteration          430 MCMCOBJ=   -8321.63823765633     
 iteration          440 MCMCOBJ=   -8342.16336587083     
 iteration          450 MCMCOBJ=   -8273.82702246611     
 iteration          460 MCMCOBJ=   -8254.95704705354     
 iteration          470 MCMCOBJ=   -8243.38856739665     
 iteration          480 MCMCOBJ=   -8268.84095719027     
 iteration          490 MCMCOBJ=   -8326.87117114502     
 iteration          500 MCMCOBJ=   -8320.67231704545     
 iteration          510 MCMCOBJ=   -8249.53554958854     
 iteration          520 MCMCOBJ=   -8273.08150794671     
 iteration          530 MCMCOBJ=   -8199.32577646331     
 iteration          540 MCMCOBJ=   -8200.18616588979     
 iteration          550 MCMCOBJ=   -8229.22948273174     
 iteration          560 MCMCOBJ=   -8211.74794884511     
 iteration          570 MCMCOBJ=   -8296.69761873854     
 iteration          580 MCMCOBJ=   -8291.13231425827     
 iteration          590 MCMCOBJ=   -8267.03392283220     
 iteration          600 MCMCOBJ=   -8310.46031481948     
 iteration          610 MCMCOBJ=   -8156.90468388693     
 iteration          620 MCMCOBJ=   -8191.95447936453     
 iteration          630 MCMCOBJ=   -8143.06637908995     
 iteration          640 MCMCOBJ=   -8155.59460291789     
 iteration          650 MCMCOBJ=   -8123.99806977686     
 iteration          660 MCMCOBJ=   -8095.66133064400     
 iteration          670 MCMCOBJ=   -8189.24993110157     
 iteration          680 MCMCOBJ=   -8254.74114825884     
 iteration          690 MCMCOBJ=   -8133.14262158433     
 iteration          700 MCMCOBJ=   -8138.71024911109     
 iteration          710 MCMCOBJ=   -8184.59329355415     
 iteration          720 MCMCOBJ=   -8177.29463175921     
 iteration          730 MCMCOBJ=   -8245.29428272737     
 iteration          740 MCMCOBJ=   -8226.95687708785     
 iteration          750 MCMCOBJ=   -8129.03945042415     
 iteration          760 MCMCOBJ=   -8232.69286581231     
 iteration          770 MCMCOBJ=   -8195.74584739171     
 iteration          780 MCMCOBJ=   -8119.31530025086     
 iteration          790 MCMCOBJ=   -8205.56926397232     
 iteration          800 MCMCOBJ=   -8270.83194024154     
 iteration          810 MCMCOBJ=   -8115.92966293939     
 iteration          820 MCMCOBJ=   -8039.24830447225     
 iteration          830 MCMCOBJ=   -8184.86654270007     
 iteration          840 MCMCOBJ=   -8104.94742347469     
 iteration          850 MCMCOBJ=   -8214.76089330527     
 iteration          860 MCMCOBJ=   -8277.50695538969     
 iteration          870 MCMCOBJ=   -8407.84782329756     
 iteration          880 MCMCOBJ=   -8186.36612305581     
 iteration          890 MCMCOBJ=   -8200.12368796455     
 iteration          900 MCMCOBJ=   -8332.43050816792     
 iteration          910 MCMCOBJ=   -8165.91452009091     
 iteration          920 MCMCOBJ=   -8173.24769051948     
 iteration          930 MCMCOBJ=   -8249.71665703283     
 iteration          940 MCMCOBJ=   -8283.47587564609     
 iteration          950 MCMCOBJ=   -8176.76455745578     
 iteration          960 MCMCOBJ=   -8188.41931962900     
 iteration          970 MCMCOBJ=   -8157.44611060063     
 iteration          980 MCMCOBJ=   -8385.46442372595     
 iteration          990 MCMCOBJ=   -8267.92811747442     
 iteration         1000 MCMCOBJ=   -8243.62093568489     
 
 #TERM:
 BURN-IN WAS COMPLETED
 STATISTICAL PORTION WAS COMPLETED
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         6000
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    11027.2623984561     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -8259.93791866365     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       2767.32447979243     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                          1598
 NIND*NETA*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    2936.92755212214     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -8259.93791866365     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:      -5323.01036654151     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 PRIOR CONSTANT TO OBJECTIVE FUNCTION:    48.5256320203051     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -8259.93791866365     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:      -8211.41228664334     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 #TERE:
 Elapsed estimation  time in seconds:   201.01
 Elapsed covariance  time in seconds:     0.00
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 #OBJT:**************                       AVERAGE VALUE OF LIKELIHOOD FUNCTION                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************    -8259.938       **************************************************
 #OBJS:********************************************       85.040 (STD) **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2     
 
         1.22E+00  4.00E+00
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        3.16E-02
 
 ETA2
+        3.52E-03  3.11E-02
 
 ETA3
+        0.00E+00  0.00E+00  8.11E-02
 
 ETA4
+        0.00E+00  0.00E+00  2.37E-03  2.10E-01
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.07E-02
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.79E-04  1.12E-02
 
 ETA7
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.07E-02
 
 ETA8
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.79E-04  1.12E-02
 
 ETA9
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.07E-02
 
 ET10
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.79E-04  1.12E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        9.97E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        1.77E-01
 
 ETA2
+        1.12E-01  1.76E-01
 
 ETA3
+        0.00E+00  0.00E+00  2.81E-01
 
 ETA4
+        0.00E+00  0.00E+00  2.06E-02  4.53E-01
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.03E-01
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.61E-02  1.06E-01
 
 ETA7
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.03E-01
 
 ETA8
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.61E-02  1.06E-01
 
 ETA9
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.03E-01
 
 ET10
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.61E-02  1.06E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        9.99E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************                STANDARD ERROR OF ESTIMATE (From Sample Variance)               ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2     
 
         1.30E-02  1.35E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        3.66E-03
 
 ETA2
+        2.34E-03  3.48E-03
 
 ETA3
+        0.00E+00  0.00E+00  2.77E-02
 
 ETA4
+        0.00E+00  0.00E+00  3.10E-02  6.82E-02
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  8.70E-04
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  5.07E-04  7.70E-04
 
 ETA7
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  8.70E-04
 
 ETA8
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  5.07E-04  7.70E-04
 
 ETA9
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  8.70E-04
 
 ET10
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  5.07E-04  7.70E-04
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        2.04E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        1.02E-02
 
 ETA2
+        7.23E-02  9.77E-03
 
 ETA3
+        0.00E+00  0.00E+00  4.60E-02
 
 ETA4
+        0.00E+00  0.00E+00  2.19E-01  7.12E-02
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.23E-03
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.65E-02  3.62E-03
 
 ETA7
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.23E-03
 
 ETA8
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.65E-02  3.62E-03
 
 ETA9
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.23E-03
 
 ET10
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.65E-02  3.62E-03
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.02E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************               COVARIANCE MATRIX OF ESTIMATE (From Sample Variance)             ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
  TH 1
+          1.69E-04
 
  TH 2
+          2.45E-05  1.82E-04
 
 OM0101
+         -2.74E-06  3.61E-06  1.34E-05
 
 OM0102
+         -1.10E-06 -7.01E-07  1.60E-06  5.48E-06
 
 OM0103
+         ......... ......... ......... ......... .........
 
 OM0104
+         ......... ......... ......... ......... ......... .........
 
 OM0105
+         ......... ......... ......... ......... ......... ......... .........
 
 OM0106
+         ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0107
+         ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0108
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0109
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0110
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0202
+         -1.11E-06 -5.07E-07  3.12E-07  1.00E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.21E-05
 
 OM0203
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... .........
 
 OM0204
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0205
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0206
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
 OM0207
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0208
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... .........
 
 OM0209
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0210
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0303
+          4.38E-06 -2.13E-06  4.46E-06  3.30E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -1.66E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  7.67E-04
 
 OM0304
+         -1.83E-05 -1.34E-05 -6.14E-06  7.40E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            9.39E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.43E-05  9.60E-04
 
 OM0305
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0306
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0307
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
 OM0308
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0309
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0310
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0404
+         -2.64E-05  5.59E-06  3.06E-06 -3.49E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            3.35E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.87E-04 -7.31E-05  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.65E-03
 
 OM0405
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0406
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0407
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0408
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0409
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0410
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0505
+         -3.41E-07 -3.18E-07  2.62E-07  8.20E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            4.07E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -5.25E-08 -8.64E-07  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.46E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            7.57E-07
 
 OM0506
+          3.57E-08 -2.64E-07  1.50E-07  4.89E-09  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            9.15E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  5.65E-07  9.62E-07  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.65E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.05E-07  2.57E-07
 
 OM0507
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0508
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0509
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0510
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
 OM0606
+         -7.12E-07 -1.54E-07 -1.22E-08  5.10E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.70E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  9.85E-08  1.19E-06  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.26E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.70E-07  3.46E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  5.92E-07
 
 OM0607
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0608
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0609
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0610
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0707
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0708
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0709
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0710
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0808
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0809
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0810
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... .........
 
 OM0909
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
 OM0910
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM1010
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG0101
+          9.96E-08  5.02E-08 -2.24E-08 -2.69E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            2.78E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.03E-07 -1.70E-07  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.16E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -3.46E-09 -5.40E-09  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.24E-09  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.16E-08
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************              CORRELATION MATRIX OF ESTIMATE (From Sample Variance)             ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
  TH 1
+          1.30E-02
 
  TH 2
+          1.40E-01  1.35E-02
 
 OM0101
+         -5.75E-02  7.30E-02  3.66E-03
 
 OM0102
+         -3.61E-02 -2.22E-02  1.87E-01  2.34E-03
 
 OM0103
+         ......... ......... ......... ......... .........
 
 OM0104
+         ......... ......... ......... ......... ......... .........
 
 OM0105
+         ......... ......... ......... ......... ......... ......... .........
 
 OM0106
+         ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0107
+         ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0108
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0109
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0110
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0202
+         -2.45E-02 -1.08E-02  2.45E-02  1.23E-01  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            3.48E-03
 
 OM0203
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... .........
 
 OM0204
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0205
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0206
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
 OM0207
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0208
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... .........
 
 OM0209
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0210
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0303
+          1.22E-02 -5.70E-03  4.40E-02  5.09E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -1.72E-03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  2.77E-02
 
 OM0304
+         -4.53E-02 -3.22E-02 -5.41E-02  1.02E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            8.71E-03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.84E-02  3.10E-02
 
 OM0305
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0306
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0307
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
 OM0308
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0309
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0310
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0404
+         -2.98E-02  6.08E-03  1.23E-02 -2.19E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.41E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  9.92E-02 -3.46E-02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  6.82E-02
 
 OM0405
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0406
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0407
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0408
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0409
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0410
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0505
+         -3.01E-02 -2.71E-02  8.22E-02  4.02E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.34E-01  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.18E-03 -3.20E-02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.46E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            8.70E-04
 
 OM0506
+          5.41E-03 -3.86E-02  8.05E-02  4.11E-03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            5.18E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.02E-02  6.12E-02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.06E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            2.38E-01  5.07E-04
 
 OM0507
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0508
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0509
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0510
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
 OM0606
+         -7.11E-02 -1.48E-02 -4.31E-03  2.83E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            6.35E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.62E-03  5.00E-02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.40E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            2.53E-01  8.85E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  7.70E-04
 
 OM0607
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0608
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0609
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0610
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0707
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0708
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0709
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0710
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0808
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0809
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0810
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... .........
 
 OM0909
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
 OM0910
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM1010
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG0101
+          3.75E-02  1.82E-02 -2.99E-02 -5.64E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            3.91E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -5.37E-02 -2.70E-02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -8.34E-03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -1.95E-02 -5.22E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.43E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  2.04E-04
 
 SKIPPING EXECUTION OF SLOW FNLMOD/FNLETA BY USER REQUEST
 Elapsed postprocess time in seconds:     0.02
 Elapsed finaloutput time in seconds:     0.98
 #CPUT: Total CPU Time in Seconds,      222.145
Stop Time: 
Mon 03/11/2019 
10:04 PM
