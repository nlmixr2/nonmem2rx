Tue 03/05/2019 
02:19 PM
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
IPRED=A(1)/S1
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

$EST METHOD=ITS INTERACTION PRINT=1 NSIG=2 NITER=40 SIGL=10 FNLETA=0 NOHABORT CTYPE=3 NOPRIOR=1
$EST METHOD=1 INTERACTION PRINT=1 NSIG=2 SIGL=12 FNLETA=0 NOHABORT SLOW NONINFETA=1 MAXEVAL=9999 NOPRIOR=1 MCETA=20
$COV MATRIX=R UNCONDITIONAL

$TABLE ID SID OCC TIME IPRED ETAS(1:LAST) 
       FILE=superid30_1_foce.tab NOPRINT NOAPPEND ONEHEADER
  
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
Current Date:        5 MAR 2019
Days until program expires :4102
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
 GRADIENT METHOD USED:       SLOW
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
0ERROR SUBROUTINE INDICATES THAT DERIVATIVES OF COMPARTMENT AMOUNTS ARE USED.
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
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      10
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     10
 NOPRIOR SETTING (NOPRIOR):                 ON
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          OFF
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): superid30_1_foce.ext
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
 ITERATIONS (NITER):                        40
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

 iteration            0 OBJ=   10777.3343969507
 iteration            1 OBJ=   8290.33022657002
 iteration            2 OBJ=   7688.40263185892
 iteration            3 OBJ=   7219.25333701149
 iteration            4 OBJ=   6788.76790109352
 iteration            5 OBJ=   6370.49864108526
 iteration            6 OBJ=   5957.86375988699
 iteration            7 OBJ=   5549.01084298769
 iteration            8 OBJ=   5143.34200242024
 iteration            9 OBJ=   4740.69098457494
 iteration           10 OBJ=   4341.14966739730
 iteration           11 OBJ=   3945.09015343648
 iteration           12 OBJ=   3553.32632699097
 iteration           13 OBJ=   3167.53367628491
 iteration           14 OBJ=   2791.21664263196
 iteration           15 OBJ=   2432.05381909083
 iteration           16 OBJ=   2108.08993295482
 iteration           17 OBJ=   1864.32504219976
 iteration           18 OBJ=   1776.81666573853
 iteration           19 OBJ=   1773.24060753786
 iteration           20 OBJ=   1772.39483826296
 iteration           21 OBJ=   1772.14727487522
 iteration           22 OBJ=   1772.07719819781
 iteration           23 OBJ=   1772.05857766612
 iteration           24 OBJ=   1772.05431406401
 iteration           25 OBJ=   1772.05375712051
 iteration           26 OBJ=   1772.05398412033
 iteration           27 OBJ=   1772.05426733541
 iteration           28 OBJ=   1772.05446983987
 iteration           29 OBJ=   1772.05459484099
 iteration           30 OBJ=   1772.05466747648
 iteration           31 OBJ=   1772.05470849072
 Convergence achieved
 
 #TERM:
 OPTIMIZATION WAS COMPLETED


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -1.7013E-07 -1.5228E-07  7.4107E-17  7.2164E-17 -3.6869E-03 -3.8920E-03 -1.8991E-03 -4.9895E-03  5.5860E-03  8.8814E-03
 SE:             1.0680E-02  1.0695E-02  5.6431E-02  9.5683E-02  5.9674E-03  6.1618E-03  5.6444E-03  5.5760E-03  5.7886E-03  5.7026E-03
 N:                     200         200          20          20         200         200         200         200         200         200
 
 P VAL.:         9.9999E-01  9.9999E-01  1.0000E+00  1.0000E+00  5.3668E-01  5.2763E-01  7.3652E-01  3.7088E-01  3.3455E-01  1.1937E-01
 
 ETASHRINKSD(%)  6.1244E+00  6.3192E+00  1.0523E-04  5.9331E-05  1.7527E+01  1.5884E+01  2.1991E+01  2.3881E+01  1.9998E+01  2.2152E+01
 ETASHRINKVR(%)  1.1874E+01  1.2239E+01  2.1047E-04  1.1866E-04  3.1982E+01  2.9244E+01  3.9145E+01  4.2059E+01  3.5997E+01  3.9397E+01
 EBVSHRINKSD(%)  6.1242E+00  6.3190E+00  0.0000E+00  0.0000E+00  1.9717E+01  2.0333E+01  1.9717E+01  2.0333E+01  1.9734E+01  2.0334E+01
 EBVSHRINKVR(%)  1.1873E+01  1.2239E+01  0.0000E+00  0.0000E+00  3.5547E+01  3.6532E+01  3.5546E+01  3.6532E+01  3.5574E+01  3.6534E+01
 EPSSHRINKSD(%)  9.5776E+00
 EPSSHRINKVR(%)  1.8238E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         6000
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    11027.2623984561     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    1772.05470849072     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       12799.3171069468     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                          1598
  
 #TERE:
 Elapsed estimation  time in seconds:    43.58
 Elapsed covariance  time in seconds:     0.13
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
+         -5.86E-07  1.02E-06  1.26E-06  6.00E-06
 
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
+          4.34E-07 -4.60E-09 -3.83E-07 -1.01E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
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
+         -2.36E-02 -1.45E-01  2.42E-02 -8.08E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
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
+         -1.46E+03  4.26E+03  6.12E+01 -2.99E+04  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
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
 #METH: First Order Conditional Estimation with Interaction (No Prior)
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               SLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            9999
 NO. OF SIG. FIGURES REQUIRED:            2
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
 ABORT WITH PRED EXIT CODE 1:             NO
 IND. OBJ. FUNC. VALUES SORTED:           NO
 NUMERICAL DERIVATIVE
       FILE REQUEST (NUMDER):               NONE
 MAP (ETAHAT) ESTIMATION METHOD (OPTMAP):   0
 ETA HESSIAN EVALUATION METHOD (ETADER):    0
 INITIAL ETA FOR MAP ESTIMATION (MCETA):    20
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      12
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     12
 NOPRIOR SETTING (NOPRIOR):                 ON
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          OFF
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      ON
 RAW OUTPUT FILE (FILE): superid30_1_foce.ext
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
 ADDITIONAL CONVERGENCE TEST (CTYPE=4)?:    NO
 EM OR BAYESIAN METHOD USED:                 NONE

 
 THE FOLLOWING LABELS ARE EQUIVALENT
 PRED=PREDI
 RES=RESI
 WRES=WRESI
 IWRS=IWRESI
 IPRD=IPREDI
 IRS=IRESI
 
 MONITORING OF SEARCH:

 
0ITERATION NO.:    0    OBJECTIVE VALUE:   1772.05470851424        NO. OF FUNC. EVALS.:  13
 CUMULATIVE NO. OF FUNC. EVALS.:       13
 NPARAMETR:  1.2273E+00  4.0057E+00  2.8765E-02  3.0075E-03  2.8965E-02  6.7042E-02  3.5576E-03  1.9274E-01  1.0523E-02 -3.5849E-04
             1.0786E-02  9.9019E-03
 PARAMETER:  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01 -1.0000E-01
             1.0000E-01  1.0000E-01
 GRADIENT:   1.5814E+01 -1.0331E+02 -1.6892E+00  2.8556E-01 -1.8921E+00  1.7264E+00  9.7962E-02  4.4460E+00  1.9492E+00 -7.6382E-02
             1.6709E+00 -7.0646E-01
 
0ITERATION NO.:    1    OBJECTIVE VALUE:   1772.05421132198        NO. OF FUNC. EVALS.:  21
 CUMULATIVE NO. OF FUNC. EVALS.:       34
 NPARAMETR:  1.2273E+00  4.0061E+00  2.8765E-02  3.0075E-03  2.8965E-02  6.7042E-02  3.5576E-03  1.9274E-01  1.0523E-02 -3.5849E-04
             1.0786E-02  9.9020E-03
 PARAMETER:  9.9999E-02  1.0001E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01 -1.0000E-01
             1.0000E-01  1.0000E-01
 GRADIENT:   1.0727E+01  1.5409E+00 -1.7813E+00  1.3296E-01 -2.0875E+00  1.6476E+00 -1.7180E-02  4.3743E+00  1.5072E+00 -1.1724E-01
             1.6370E+00 -1.3897E+00
 
0ITERATION NO.:    2    OBJECTIVE VALUE:   1772.05413711464        NO. OF FUNC. EVALS.:  21
 CUMULATIVE NO. OF FUNC. EVALS.:       55
 NPARAMETR:  1.2271E+00  4.0061E+00  2.8765E-02  3.0075E-03  2.8965E-02  6.7041E-02  3.5576E-03  1.9274E-01  1.0523E-02 -3.5849E-04
             1.0786E-02  9.9020E-03
 PARAMETER:  9.9988E-02  1.0001E-01  1.0000E-01  1.0000E-01  1.0000E-01  9.9998E-02  1.0000E-01  9.9995E-02  9.9998E-02 -1.0000E-01
             9.9998E-02  1.0000E-01
 GRADIENT:  -2.9510E+00 -6.4772E-01 -1.5926E+00  3.2989E-01 -1.9846E+00  1.5706E+00 -7.0024E-02  4.1208E+00  1.5361E+00 -1.4282E-01
             1.6749E+00 -1.3002E+00
 
0ITERATION NO.:    3    OBJECTIVE VALUE:   1772.04572559137        NO. OF FUNC. EVALS.:  17
 CUMULATIVE NO. OF FUNC. EVALS.:       72
 NPARAMETR:  1.2279E+00  4.0063E+00  2.8814E-02  3.0056E-03  2.9023E-02  6.6931E-02  3.5558E-03  1.9191E-01  1.0507E-02 -3.5795E-04
             1.0767E-02  9.9155E-03
 PARAMETER:  1.0005E-01  1.0001E-01  1.0085E-01  9.9850E-02  1.0104E-01  9.9176E-02  1.0003E-01  9.7832E-02  9.9206E-02 -9.9929E-02
             9.9134E-02  1.0069E-01
 GRADIENT:   7.1057E+01  2.4575E+01 -1.3328E+00  4.1272E-01 -1.9217E+00  1.7981E+00  3.1032E-02  3.6553E+00  8.5480E-01 -5.2030E-02
             6.2875E-01  1.1872E+01
 
0ITERATION NO.:    4    OBJECTIVE VALUE:   1772.03579023311        NO. OF FUNC. EVALS.:  17
 CUMULATIVE NO. OF FUNC. EVALS.:       89
 NPARAMETR:  1.2287E+00  4.0061E+00  2.8872E-02  2.9984E-03  2.9099E-02  6.6783E-02  3.5540E-03  1.9085E-01  1.0485E-02 -3.5721E-04
             1.0744E-02  9.9033E-03
 PARAMETER:  1.0012E-01  1.0001E-01  1.0186E-01  9.9512E-02  1.0240E-01  9.8067E-02  1.0009E-01  9.5069E-02  9.8170E-02 -9.9826E-02
             9.8042E-02  1.0007E-01
 GRADIENT:   1.5772E+02 -5.1461E+01 -1.1551E+00  4.4786E-01 -1.3843E+00  1.6701E+00  1.8594E-01  2.8788E+00 -8.5983E-01  1.1001E-01
            -6.3828E-01 -3.4898E-01
 
0ITERATION NO.:    5    OBJECTIVE VALUE:   1772.02082280686        NO. OF FUNC. EVALS.:  15
 CUMULATIVE NO. OF FUNC. EVALS.:      104
 NPARAMETR:  1.2283E+00  4.0058E+00  2.8779E-02  2.6870E-03  2.9254E-02  6.6158E-02  3.6069E-03  1.8909E-01  1.0517E-02 -3.5432E-04
             1.0722E-02  9.9070E-03
 PARAMETER:  1.0008E-01  1.0000E-01  1.0024E-01  8.9322E-02  1.0612E-01  9.3365E-02  1.0206E-01  9.0402E-02  9.9686E-02 -9.8867E-02
             9.7048E-02  1.0025E-01
 GRADIENT:   1.1580E+02 -1.2754E+02 -2.1990E+00 -1.4480E+00 -8.1867E-01  2.1573E-01  6.5081E-02  1.1993E+00  1.2138E+00 -1.0022E-01
            -2.0494E+00  2.8966E+00
 
0ITERATION NO.:    6    OBJECTIVE VALUE:   1772.01850143159        NO. OF FUNC. EVALS.:  16
 CUMULATIVE NO. OF FUNC. EVALS.:      120
 NPARAMETR:  1.2283E+00  4.0057E+00  2.8838E-02  2.6305E-03  2.9323E-02  6.6096E-02  3.6441E-03  1.8897E-01  1.0499E-02 -3.5154E-04
             1.0764E-02  9.9082E-03
 PARAMETER:  1.0009E-01  9.9999E-02  1.0128E-01  8.7352E-02  1.0750E-01  9.2898E-02  1.0316E-01  9.0087E-02  9.8832E-02 -9.8175E-02
             9.9001E-02  1.0032E-01
 GRADIENT:   1.2108E+02 -1.3694E+02 -1.4484E+00 -1.5703E+00 -1.8116E-01  3.0517E-01  8.9051E-02  1.5337E+00  2.9123E-01  2.4728E-01
             7.1589E-01  4.9286E+00
 
0ITERATION NO.:    7    OBJECTIVE VALUE:   1772.01811484981        NO. OF FUNC. EVALS.:  16
 CUMULATIVE NO. OF FUNC. EVALS.:      136
 NPARAMETR:  1.2282E+00  4.0058E+00  2.8882E-02  2.6142E-03  2.9338E-02  6.6137E-02  3.6867E-03  1.8911E-01  1.0495E-02 -3.5019E-04
             1.0755E-02  9.9082E-03
 PARAMETER:  1.0007E-01  1.0000E-01  1.0204E-01  8.6744E-02  1.0781E-01  9.3207E-02  1.0433E-01  9.0433E-02  9.8676E-02 -9.7814E-02
             9.8559E-02  1.0032E-01
 GRADIENT:   1.0583E+02 -1.2409E+02 -1.4652E+00 -1.7935E+00 -3.8512E-01  2.7933E-01 -1.0679E-01  1.5296E+00 -3.4205E-01  3.5850E-02
            -1.8931E-01  4.5754E+00
 
0ITERATION NO.:    8    OBJECTIVE VALUE:   1772.01791595527        NO. OF FUNC. EVALS.:  16
 CUMULATIVE NO. OF FUNC. EVALS.:      152
 NPARAMETR:  1.2281E+00  4.0059E+00  2.8927E-02  2.6028E-03  2.9356E-02  6.6174E-02  3.7311E-03  1.8920E-01  1.0499E-02 -3.4880E-04
             1.0747E-02  9.9079E-03
 PARAMETER:  1.0007E-01  1.0000E-01  1.0281E-01  8.6300E-02  1.0817E-01  9.3490E-02  1.0556E-01  9.0656E-02  9.8834E-02 -9.7412E-02
             9.8231E-02  1.0030E-01
 GRADIENT:   9.7475E+01 -9.1706E+01 -1.4156E+00 -2.1085E+00 -2.8872E-01  2.3950E-01 -6.1786E-02  1.4653E+00 -1.9622E-01 -2.5595E-02
            -9.3344E-01  3.8063E+00
 
0ITERATION NO.:    9    OBJECTIVE VALUE:   1772.01754153930        NO. OF FUNC. EVALS.:  15
 CUMULATIVE NO. OF FUNC. EVALS.:      167
 NPARAMETR:  1.2280E+00  4.0058E+00  2.8928E-02  2.5994E-03  2.9305E-02  6.6162E-02  3.8078E-03  1.8905E-01  1.0491E-02 -3.4629E-04
             1.0748E-02  9.9082E-03
 PARAMETER:  1.0006E-01  1.0000E-01  1.0283E-01  8.6184E-02  1.0729E-01  9.3396E-02  1.0774E-01  9.0242E-02  9.8456E-02 -9.6747E-02
             9.8249E-02  1.0031E-01
 GRADIENT:   8.5420E+01 -1.0428E+02 -1.3100E+00 -1.7352E+00 -3.4841E-01  4.3320E-01  6.8925E-03  1.1762E+00 -2.5135E-01  2.0126E-01
            -4.2127E-01  4.7290E+00
 
0ITERATION NO.:   10    OBJECTIVE VALUE:   1772.01698854683        NO. OF FUNC. EVALS.:  15
 CUMULATIVE NO. OF FUNC. EVALS.:      182
 NPARAMETR:  1.2280E+00  4.0058E+00  2.8959E-02  2.6054E-03  2.9247E-02  6.5951E-02  3.8975E-03  1.8914E-01  1.0484E-02 -3.4756E-04
             1.0748E-02  9.9085E-03
 PARAMETER:  1.0005E-01  1.0000E-01  1.0336E-01  8.6337E-02  1.0628E-01  9.1800E-02  1.1046E-01  9.0458E-02  9.8117E-02 -9.7135E-02
             9.8268E-02  1.0033E-01
 GRADIENT:   8.0665E+01 -1.1292E+02 -1.1143E+00 -1.7239E+00 -6.3136E-01  2.8410E-01  1.1719E-01  1.4573E+00 -1.0028E+00  2.5566E-01
            -4.0724E-01  4.6569E+00
 
0ITERATION NO.:   11    OBJECTIVE VALUE:   1772.01628604495        NO. OF FUNC. EVALS.:  14
 CUMULATIVE NO. OF FUNC. EVALS.:      196
 NPARAMETR:  1.2279E+00  4.0058E+00  2.8920E-02  2.6055E-03  2.9253E-02  6.6109E-02  4.0729E-03  1.8875E-01  1.0473E-02 -3.6729E-04
             1.0765E-02  9.9084E-03
 PARAMETER:  1.0005E-01  1.0000E-01  1.0269E-01  8.6399E-02  1.0639E-01  9.2993E-02  1.1529E-01  8.9347E-02  9.7592E-02 -1.0270E-01
             9.8968E-02  1.0033E-01
 GRADIENT:   7.3933E+01 -9.8278E+01 -1.3988E+00 -1.7853E+00 -6.3413E-01  4.8486E-01  1.4998E-01  7.8703E-01 -1.4232E+00 -2.7530E-01
             5.1065E-01  4.6397E+00
 
0ITERATION NO.:   12    OBJECTIVE VALUE:   1772.01605620071        NO. OF FUNC. EVALS.:  14
 CUMULATIVE NO. OF FUNC. EVALS.:      210
 NPARAMETR:  1.2278E+00  4.0059E+00  2.8889E-02  2.6233E-03  2.9301E-02  6.6081E-02  4.0875E-03  1.8889E-01  1.0469E-02 -3.6724E-04
             1.0761E-02  9.9086E-03
 PARAMETER:  1.0004E-01  1.0000E-01  1.0215E-01  8.7036E-02  1.0715E-01  9.2785E-02  1.1573E-01  8.9715E-02  9.7420E-02 -1.0270E-01
             9.8818E-02  1.0033E-01
 GRADIENT:   6.7546E+01 -7.6753E+01 -1.6448E+00 -1.7197E+00 -7.1335E-01  7.5615E-02  1.5832E-01  1.1255E+00 -1.9696E+00 -2.1676E-01
             5.0866E-02  4.4852E+00
 
0ITERATION NO.:   13    OBJECTIVE VALUE:   1772.01099435134        NO. OF FUNC. EVALS.:  15
 CUMULATIVE NO. OF FUNC. EVALS.:      225
 NPARAMETR:  1.2279E+00  4.0063E+00  2.8976E-02  2.6876E-03  2.9308E-02  6.6040E-02  4.0957E-03  1.8920E-01  1.0484E-02 -3.7027E-04
             1.0752E-02  9.9061E-03
 PARAMETER:  1.0005E-01  1.0001E-01  1.0367E-01  8.9035E-02  1.0708E-01  9.2472E-02  1.1599E-01  9.0555E-02  9.8142E-02 -1.0348E-01
             9.8376E-02  1.0021E-01
 GRADIENT:   7.0006E+01  3.0880E+01 -8.7128E-01 -1.0911E+00 -2.0277E-01  7.9558E-01  4.6530E-01  1.7531E+00 -3.2512E-01  1.3262E-01
             2.5585E-01  3.0348E+00
 
0ITERATION NO.:   14    OBJECTIVE VALUE:   1772.00793894405        NO. OF FUNC. EVALS.:  14
 CUMULATIVE NO. OF FUNC. EVALS.:      239
 NPARAMETR:  1.2280E+00  4.0064E+00  2.9081E-02  2.7279E-03  2.9203E-02  6.5765E-02  4.0401E-03  1.8906E-01  1.0503E-02 -3.7074E-04
             1.0750E-02  9.9033E-03
 PARAMETER:  1.0006E-01  1.0002E-01  1.0547E-01  9.0206E-02  1.0516E-01  9.0387E-02  1.1466E-01  9.0186E-02  9.9032E-02 -1.0352E-01
             9.8277E-02  1.0007E-01
 GRADIENT:   8.3506E+01  6.7044E+01 -7.0451E-01 -1.4773E+00 -1.2479E+00  9.6952E-02  7.0927E-02  1.1258E+00 -5.3765E-01 -4.5098E-01
            -1.2672E+00  2.5182E-01
 
0ITERATION NO.:   15    OBJECTIVE VALUE:   1772.00242210840        NO. OF FUNC. EVALS.:  15
 CUMULATIVE NO. OF FUNC. EVALS.:      254
 NPARAMETR:  1.2278E+00  4.0067E+00  2.9134E-02  2.8510E-03  2.9362E-02  6.5442E-02  3.8608E-03  1.8888E-01  1.0519E-02 -3.6300E-04
             1.0736E-02  9.8960E-03
 PARAMETER:  1.0004E-01  1.0002E-01  1.0638E-01  9.4192E-02  1.0750E-01  8.7923E-02  1.0984E-01  8.9775E-02  9.9809E-02 -1.0128E-01
             9.7656E-02  9.9698E-02
 GRADIENT:   6.3563E+01  1.3807E+02 -4.3622E-01 -4.3874E-01 -1.8076E-01  1.0928E-02  3.0221E-01  1.2890E+00  1.3512E+00 -7.7123E-02
            -9.0424E-01 -7.1034E+00
 
0ITERATION NO.:   16    OBJECTIVE VALUE:   1771.99756470160        NO. OF FUNC. EVALS.:  14
 CUMULATIVE NO. OF FUNC. EVALS.:      268
 NPARAMETR:  1.2274E+00  4.0063E+00  2.9183E-02  2.8689E-03  2.9520E-02  6.5357E-02  3.6396E-03  1.8825E-01  1.0505E-02 -3.4504E-04
             1.0727E-02  9.8994E-03
 PARAMETER:  1.0001E-01  1.0001E-01  1.0722E-01  9.4704E-02  1.1016E-01  8.7275E-02  1.0361E-01  8.8173E-02  9.9122E-02 -9.6333E-02
             9.7298E-02  9.9871E-02
 GRADIENT:   1.9029E+01  3.8567E+01 -2.1744E-01 -4.7610E-01  5.8161E-01 -2.8846E-01  1.0309E-01  1.0716E+00  6.3390E-01  4.8806E-01
            -1.4676E+00 -3.8511E+00
 
0ITERATION NO.:   17    OBJECTIVE VALUE:   1771.99453324620        NO. OF FUNC. EVALS.:  14
 CUMULATIVE NO. OF FUNC. EVALS.:      282
 NPARAMETR:  1.2269E+00  4.0060E+00  2.9196E-02  2.9318E-03  2.9535E-02  6.5429E-02  3.7761E-03  1.8755E-01  1.0479E-02 -3.6389E-04
             1.0743E-02  9.9069E-03
 PARAMETER:  9.9965E-02  1.0001E-01  1.0744E-01  9.6760E-02  1.1020E-01  8.7829E-02  1.0744E-01  8.6247E-02  9.7884E-02 -1.0172E-01
             9.8000E-02  1.0025E-01
 GRADIENT:  -2.9102E+01 -1.1252E+01 -1.1939E-01 -9.3360E-03  4.5373E-01 -9.0813E-03  2.7901E-01  4.9211E-01 -5.9774E-01  1.4575E-01
            -2.2335E-01  3.5417E+00
 
0ITERATION NO.:   18    OBJECTIVE VALUE:   1771.99108577306        NO. OF FUNC. EVALS.:  14
 CUMULATIVE NO. OF FUNC. EVALS.:      296
 NPARAMETR:  1.2272E+00  4.0061E+00  2.9247E-02  2.9640E-03  2.9405E-02  6.5347E-02  3.5536E-03  1.8730E-01  1.0500E-02 -3.5790E-04
             1.0753E-02  9.9016E-03
 PARAMETER:  9.9994E-02  1.0001E-01  1.0831E-01  9.7737E-02  1.0786E-01  8.7196E-02  1.0117E-01  8.5662E-02  9.8915E-02 -9.9943E-02
             9.8440E-02  9.9980E-02
 GRADIENT:   5.2559E+00  5.3622E+00  3.6946E-04 -3.2194E-01 -3.2440E-01 -5.1424E-01  6.2003E-02 -9.4378E-02  4.1056E-01 -8.4226E-02
            -3.7939E-01 -1.9463E+00
 
0ITERATION NO.:   19    OBJECTIVE VALUE:   1771.99071739334        NO. OF FUNC. EVALS.:  14
 CUMULATIVE NO. OF FUNC. EVALS.:      310
 NPARAMETR:  1.2272E+00  4.0061E+00  2.9219E-02  2.9948E-03  2.9458E-02  6.5483E-02  3.4476E-03  1.8722E-01  1.0493E-02 -3.5759E-04
             1.0753E-02  9.9022E-03
 PARAMETER:  9.9996E-02  1.0001E-01  1.0783E-01  9.8798E-02  1.0867E-01  8.8241E-02  9.8054E-02  8.5467E-02  9.8572E-02 -9.9892E-02
             9.8454E-02  1.0001E-01
 GRADIENT:   6.5560E+00 -1.9929E+00 -1.0187E+00 -6.3606E-01 -1.0428E+00 -1.0361E+00 -6.4140E-01 -7.8440E-01 -1.8786E+00 -6.2419E-01
            -1.9411E+00 -1.1258E+00
 
0ITERATION NO.:   20    OBJECTIVE VALUE:   1771.99071739334        NO. OF FUNC. EVALS.:  24
 CUMULATIVE NO. OF FUNC. EVALS.:      334
 NPARAMETR:  1.2272E+00  4.0061E+00  2.9219E-02  2.9948E-03  2.9458E-02  6.5483E-02  3.4476E-03  1.8722E-01  1.0493E-02 -3.5759E-04
             1.0753E-02  9.9022E-03
 PARAMETER:  9.9996E-02  1.0001E-01  1.0783E-01  9.8798E-02  1.0867E-01  8.8241E-02  9.8054E-02  8.5467E-02  9.8572E-02 -9.9892E-02
             9.8454E-02  1.0001E-01
 GRADIENT:   7.4898E+00 -1.4515E+00 -1.2405E-01  1.3796E-01 -1.4753E-01  8.8889E-02  1.1795E-01  1.9772E-01 -8.2491E-01  2.4616E-01
            -8.4798E-01 -2.4327E-01
 
0ITERATION NO.:   21    OBJECTIVE VALUE:   1771.98977323026        NO. OF FUNC. EVALS.:  27
 CUMULATIVE NO. OF FUNC. EVALS.:      361
 NPARAMETR:  1.2272E+00  4.0061E+00  2.9248E-02  3.0015E-03  2.9460E-02  6.5395E-02  3.3772E-03  1.8724E-01  1.0502E-02 -3.6211E-04
             1.0765E-02  9.9027E-03
 PARAMETER:  9.9991E-02  1.0001E-01  1.0834E-01  9.8970E-02  1.0868E-01  8.7565E-02  9.6116E-02  8.5554E-02  9.8976E-02 -1.0111E-01
             9.9021E-02  1.0004E-01
 GRADIENT:   1.0798E+00  1.3700E-04 -3.2635E-03  1.2797E-01 -1.1509E-01 -8.1603E-03  9.0262E-02  2.3018E-01 -2.3019E-01  1.2229E-01
            -6.4922E-02  3.7481E-01
 
0ITERATION NO.:   22    OBJECTIVE VALUE:   1771.98954396937        NO. OF FUNC. EVALS.:  26
 CUMULATIVE NO. OF FUNC. EVALS.:      387
 NPARAMETR:  1.2272E+00  4.0061E+00  2.9259E-02  3.0032E-03  2.9487E-02  6.5389E-02  3.3183E-03  1.8717E-01  1.0505E-02 -3.6347E-04
             1.0771E-02  9.9025E-03
 PARAMETER:  9.9990E-02  1.0001E-01  1.0853E-01  9.9007E-02  1.0914E-01  8.7521E-02  9.4445E-02  8.5369E-02  9.9122E-02 -1.0148E-01
             9.9265E-02  1.0003E-01
 GRADIENT:  -4.0399E-01  6.8664E-01  5.9640E-02  1.1769E-01  8.7886E-03  1.8041E-03  7.1926E-02  1.9512E-01 -1.8707E-02  7.9315E-02
             2.6688E-01  1.7032E-01
 
0ITERATION NO.:   23    OBJECTIVE VALUE:   1771.98954396937        NO. OF FUNC. EVALS.:   0
 CUMULATIVE NO. OF FUNC. EVALS.:      387
 NPARAMETR:  1.2272E+00  4.0061E+00  2.9259E-02  3.0032E-03  2.9487E-02  6.5389E-02  3.3183E-03  1.8717E-01  1.0505E-02 -3.6347E-04
             1.0771E-02  9.9025E-03
 PARAMETER:  9.9990E-02  1.0001E-01  1.0853E-01  9.9007E-02  1.0914E-01  8.7521E-02  9.4445E-02  8.5369E-02  9.9122E-02 -1.0148E-01
             9.9265E-02  1.0003E-01
 GRADIENT:  -4.0399E-01  6.8664E-01  5.9640E-02  1.1769E-01  8.7886E-03  1.8041E-03  7.1926E-02  1.9512E-01 -1.8707E-02  7.9315E-02
             2.6688E-01  1.7032E-01
 
 #TERM:
0MINIMIZATION SUCCESSFUL
 NO. OF FUNCTION EVALUATIONS USED:      387
 NO. OF SIG. DIGITS IN FINAL EST.:  2.0

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:         1.0734E-04 -3.1578E-04 -6.5226E-17  3.4417E-17 -3.6674E-03 -3.9310E-03 -1.8796E-03 -5.0287E-03  5.6016E-03  8.8373E-03
 SE:             1.0704E-02  1.0721E-02  5.6408E-02  9.5645E-02  5.9608E-03  6.1547E-03  5.6405E-03  5.5712E-03  5.7814E-03  5.6961E-03
 N:                     200         200          20          20         200         200         200         200         200         200
 
 P VAL.:         9.9200E-01  9.7650E-01  1.0000E+00  1.0000E+00  5.3839E-01  5.2302E-01  7.3896E-01  3.6673E-01  3.3259E-01  1.2079E-01
 
 ETASHRINKSD(%)  6.7119E+00  6.9312E+00  1.0000E-10  1.0000E-10  1.7546E+01  1.5920E+01  2.1976E+01  2.3892E+01  2.0028E+01  2.2186E+01
 ETASHRINKVR(%)  1.2973E+01  1.3382E+01  1.0000E-10  1.0000E-10  3.2013E+01  2.9306E+01  3.9122E+01  4.2075E+01  3.6045E+01  3.9450E+01
 EBVSHRINKSD(%)  6.0213E+00  6.2102E+00  0.0000E+00  0.0000E+00  1.9761E+01  2.0378E+01  1.9760E+01  2.0378E+01  1.9777E+01  2.0379E+01
 EBVSHRINKVR(%)  1.1680E+01  1.2035E+01  0.0000E+00  0.0000E+00  3.5616E+01  3.6603E+01  3.5616E+01  3.6603E+01  3.5643E+01  3.6605E+01
 EPSSHRINKSD(%)  9.5785E+00
 EPSSHRINKVR(%)  1.8240E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         6000
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    11027.2623984561     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    1771.98954396937     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       12799.2519424254     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                          1598
  
 #TERE:
 Elapsed estimation  time in seconds:   153.54
 Elapsed covariance  time in seconds:   113.36
 SKIPPING EXECUTION OF SLOW FNLMOD/FNLETA BY USER REQUEST
 Elapsed postprocess time in seconds:     0.02
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************          FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION (NO PRIOR)        ********************
 #OBJT:**************                       MINIMUM VALUE OF OBJECTIVE FUNCTION                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     1771.990       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************          FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION (NO PRIOR)        ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2     
 
         1.23E+00  4.01E+00
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        2.93E-02
 
 ETA2
+        3.00E-03  2.95E-02
 
 ETA3
+        0.00E+00  0.00E+00  6.54E-02
 
 ETA4
+        0.00E+00  0.00E+00  3.32E-03  1.87E-01
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.05E-02
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.63E-04  1.08E-02
 
 ETA7
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.05E-02
 
 ETA8
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.63E-04  1.08E-02
 
 ETA9
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.05E-02
 
 ET10
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.63E-04  1.08E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        9.90E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        1.71E-01
 
 ETA2
+        1.02E-01  1.72E-01
 
 ETA3
+        0.00E+00  0.00E+00  2.56E-01
 
 ETA4
+        0.00E+00  0.00E+00  3.00E-02  4.33E-01
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.02E-01
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.42E-02  1.04E-01
 
 ETA7
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.02E-01
 
 ETA8
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.42E-02  1.04E-01
 
 ETA9
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.02E-01
 
 ET10
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.42E-02  1.04E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        9.95E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************          FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION (NO PRIOR)        ********************
 ********************                            STANDARD ERROR OF ESTIMATE                          ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2     
 
         1.29E-02  1.29E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        3.51E-03
 
 ETA2
+        2.57E-03  3.56E-03
 
 ETA3
+       ......... .........  2.33E-02
 
 ETA4
+       ......... .........  2.49E-02  6.80E-02
 
 ETA5
+       ......... ......... ......... .........  8.17E-04
 
 ETA6
+       ......... ......... ......... .........  6.24E-04  8.54E-04
 
 ETA7
+       ......... ......... ......... ......... ......... ......... .........
 
 ETA8
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 ETA9
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 ET10
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        2.04E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        1.03E-02
 
 ETA2
+        8.64E-02  1.04E-02
 
 ETA3
+       ......... .........  4.55E-02
 
 ETA4
+       ......... .........  2.24E-01  7.86E-02
 
 ETA5
+       ......... ......... ......... .........  3.99E-03
 
 ETA6
+       ......... ......... ......... .........  5.88E-02  4.12E-03
 
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
+        1.02E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************          FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION (NO PRIOR)        ********************
 ********************                          COVARIANCE MATRIX OF ESTIMATE                         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
  TH 1
+          1.66E-04
 
  TH 2
+          1.61E-05  1.68E-04
 
 OM0101
+         -3.34E-08  3.53E-08  1.23E-05
 
 OM0102
+          5.97E-08 -1.94E-08  1.14E-06  6.62E-06
 
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
+         -2.51E-08  4.47E-09  8.66E-08  1.24E-06 ......... ......... ......... ......... ......... ......... ......... .........
            1.27E-05
 
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
+         -1.73E-07  3.53E-08  1.22E-06 -1.67E-06 ......... ......... ......... ......... ......... ......... ......... .........
           -3.03E-06 ......... ......... ......... ......... ......... ......... ......... .........  5.41E-04
 
 OM0304
+         -1.11E-06 -1.09E-07 -4.24E-07 -8.14E-06 ......... ......... ......... ......... ......... ......... ......... .........
           -3.87E-06 ......... ......... ......... ......... ......... ......... ......... .........  4.23E-05  6.21E-04
 
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
+         -4.40E-07  5.05E-08 -8.22E-06 -5.07E-06 ......... ......... ......... ......... ......... ......... ......... .........
           -9.27E-06 ......... ......... ......... ......... ......... ......... ......... .........  3.56E-05  2.91E-04 .........
          ......... ......... ......... ......... .........  4.62E-03
 
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
+          2.99E-09  1.81E-08 -1.77E-07 -1.55E-10 ......... ......... ......... ......... ......... ......... ......... .........
           -2.72E-08 ......... ......... ......... ......... ......... ......... ......... ......... -1.52E-07 -1.26E-07 .........
          ......... ......... ......... ......... .........  5.64E-07 ......... ......... ......... ......... ......... .........
            6.68E-07
 
 OM0506
+          2.17E-08  3.07E-09 -6.44E-08 -1.08E-07 ......... ......... ......... ......... ......... ......... ......... .........
           -4.60E-08 ......... ......... ......... ......... ......... ......... ......... ......... -1.64E-07 -1.77E-07 .........
          ......... ......... ......... ......... .........  2.07E-06 ......... ......... ......... ......... ......... .........
            3.34E-08  3.89E-07
 
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
+         -6.49E-09  1.13E-08 -4.61E-09 -8.26E-09 ......... ......... ......... ......... ......... ......... ......... .........
           -1.91E-07 ......... ......... ......... ......... ......... ......... ......... .........  2.50E-07  3.29E-07 .........
          ......... ......... ......... ......... .........  5.81E-07 ......... ......... ......... ......... ......... .........
            1.04E-09  3.73E-08 ......... ......... ......... .........  7.30E-07
 
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
+          4.06E-08  3.89E-08  1.37E-09  4.84E-10 ......... ......... ......... ......... ......... ......... ......... .........
            6.79E-12 ......... ......... ......... ......... ......... ......... ......... ......... -8.71E-09  1.48E-08 .........
          ......... ......... ......... ......... ......... -3.71E-08 ......... ......... ......... ......... ......... .........
           -4.20E-09 -3.92E-09 ......... ......... ......... ......... -5.34E-09 ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........  4.14E-08
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************          FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION (NO PRIOR)        ********************
 ********************                          CORRELATION MATRIX OF ESTIMATE                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
  TH 1
+          1.29E-02
 
  TH 2
+          9.64E-02  1.29E-02
 
 OM0101
+         -7.39E-04  7.77E-04  3.51E-03
 
 OM0102
+          1.80E-03 -5.83E-04  1.26E-01  2.57E-03
 
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
+         -5.47E-04  9.70E-05  6.92E-03  1.36E-01 ......... ......... ......... ......... ......... ......... ......... .........
            3.56E-03
 
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
+         -5.77E-04  1.17E-04  1.49E-02 -2.78E-02 ......... ......... ......... ......... ......... ......... ......... .........
           -3.66E-02 ......... ......... ......... ......... ......... ......... ......... .........  2.33E-02
 
 OM0304
+         -3.47E-03 -3.38E-04 -4.85E-03 -1.27E-01 ......... ......... ......... ......... ......... ......... ......... .........
           -4.36E-02 ......... ......... ......... ......... ......... ......... ......... .........  7.29E-02  2.49E-02
 
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
+         -5.03E-04  5.73E-05 -3.44E-02 -2.90E-02 ......... ......... ......... ......... ......... ......... ......... .........
           -3.83E-02 ......... ......... ......... ......... ......... ......... ......... .........  2.25E-02  1.72E-01 .........
          ......... ......... ......... ......... .........  6.80E-02
 
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
+          2.84E-04  1.71E-03 -6.16E-02 -7.36E-05 ......... ......... ......... ......... ......... ......... ......... .........
           -9.34E-03 ......... ......... ......... ......... ......... ......... ......... ......... -8.02E-03 -6.21E-03 .........
          ......... ......... ......... ......... .........  1.02E-02 ......... ......... ......... ......... ......... .........
            8.17E-04
 
 OM0506
+          2.70E-03  3.80E-04 -2.94E-02 -6.76E-02 ......... ......... ......... ......... ......... ......... ......... .........
           -2.07E-02 ......... ......... ......... ......... ......... ......... ......... ......... -1.13E-02 -1.14E-02 .........
          ......... ......... ......... ......... .........  4.89E-02 ......... ......... ......... ......... ......... .........
            6.56E-02  6.24E-04
 
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
+         -5.90E-04  1.02E-03 -1.53E-03 -3.76E-03 ......... ......... ......... ......... ......... ......... ......... .........
           -6.27E-02 ......... ......... ......... ......... ......... ......... ......... .........  1.26E-02  1.55E-02 .........
          ......... ......... ......... ......... .........  1.00E-02 ......... ......... ......... ......... ......... .........
            1.49E-03  7.01E-02 ......... ......... ......... .........  8.54E-04
 
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
+          1.55E-02  1.47E-02  1.92E-03  9.23E-04 ......... ......... ......... ......... ......... ......... ......... .........
            9.36E-06 ......... ......... ......... ......... ......... ......... ......... ......... -1.84E-03  2.91E-03 .........
          ......... ......... ......... ......... ......... -2.68E-03 ......... ......... ......... ......... ......... .........
           -2.53E-02 -3.08E-02 ......... ......... ......... ......... -3.07E-02 ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........  2.04E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************          FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION (NO PRIOR)        ********************
 ********************                      INVERSE COVARIANCE MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
  TH 1
+          6.09E+03
 
  TH 2
+         -5.83E+02  6.02E+03
 
 OM0101
+          2.20E+01 -2.40E+01  8.29E+04
 
 OM0102
+         -5.76E+01  2.88E+01 -1.45E+04  1.59E+05
 
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
+          2.03E+01 -8.61E+00  9.33E+02 -1.48E+04 ......... ......... ......... ......... ......... ......... ......... .........
            8.09E+04
 
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
+          8.42E-01 -6.04E-01 -2.13E+02  3.00E+02 ......... ......... ......... ......... ......... ......... ......... .........
            3.72E+02 ......... ......... ......... ......... ......... ......... ......... .........  1.86E+03
 
 OM0304
+          1.01E+01  5.83E-01 -1.73E+02  2.00E+03 ......... ......... ......... ......... ......... ......... ......... .........
            2.16E+02 ......... ......... ......... ......... ......... ......... ......... ......... -1.17E+02  1.70E+03
 
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
+          9.25E-02 -1.67E-01  1.40E+02 -2.61E+01 ......... ......... ......... ......... ......... ......... ......... .........
            1.27E+02 ......... ......... ......... ......... ......... ......... ......... ......... -6.65E+00 -1.04E+02 .........
          ......... ......... ......... ......... .........  2.24E+02
 
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
+         -1.73E+01 -1.98E+02  2.14E+04 -6.06E+03 ......... ......... ......... ......... ......... ......... ......... .........
            3.40E+03 ......... ......... ......... ......... ......... ......... ......... .........  3.27E+02  2.50E+02 .........
          ......... ......... ......... ......... ......... -1.08E+02 ......... ......... ......... ......... ......... .........
            1.51E+06
 
 OM0506
+         -3.98E+02 -3.26E+01  7.00E+03  4.25E+04 ......... ......... ......... ......... ......... ......... ......... .........
            2.94E+03 ......... ......... ......... ......... ......... ......... ......... .........  8.87E+02  1.87E+03 .........
          ......... ......... ......... ......... ......... -1.20E+03 ......... ......... ......... ......... ......... .........
           -1.26E+05  2.62E+06
 
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
+          4.36E+01 -1.36E+02  2.57E+02 -5.31E+03 ......... ......... ......... ......... ......... ......... ......... .........
            2.05E+04 ......... ......... ......... ......... ......... ......... ......... ......... -5.21E+02 -6.65E+02 .........
          ......... ......... ......... ......... ......... -3.28E+01 ......... ......... ......... ......... ......... .........
            6.14E+03 -1.31E+05 ......... ......... ......... .........  1.38E+06
 
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
+         -5.46E+03 -5.12E+03  4.38E+02  7.01E+02 ......... ......... ......... ......... ......... ......... ......... .........
            3.50E+03 ......... ......... ......... ......... ......... ......... ......... .........  4.80E+02 -6.34E+02 .........
          ......... ......... ......... ......... .........  1.03E+02 ......... ......... ......... ......... ......... .........
            1.42E+05  2.16E+05 ......... ......... ......... .........  1.67E+05 ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........  2.42E+07
 
 Elapsed finaloutput time in seconds:     0.57
 #CPUT: Total CPU Time in Seconds,      305.138
Stop Time: 
Tue 03/05/2019 
02:25 PM
