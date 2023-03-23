Tue 03/12/2019 
10:54 AM
$PROB RUN# r2compl Indirect Response Model (r2complb.ctl)
$INPUT C SET ID JID TIME DV=CONC DOSE=AMT RATE EVID MDV CMT
$DATA r2comp.csv IGNORE=C

$SUBROUTINES ADVAN13 TRANS1 TOL=6
$MODEL NCOMPARTMENTS=3

$PK
MU_1=THETA(1)
MU_2=THETA(2)
MU_3=THETA(3)
MU_4=THETA(4)
MU_5=THETA(5)
MU_6=THETA(6)
MU_7=THETA(7)
MU_8=THETA(8)
VC=EXP(MU_1+ETA(1))
K10=EXP(MU_2+ETA(2))
K12=EXP(MU_3+ETA(3))
K21=EXP(MU_4+ETA(4))
VM=EXP(MU_5+ETA(5))
KMC=EXP(MU_6+ETA(6))
K03=EXP(MU_7+ETA(7))
K30=EXP(MU_8+ETA(8))
S3=VC
S1=VC
KM=KMC*S1
A_0(3)=K03/K30

$DES
DADT(1) = -(K10+K12)*A(1) + K21*A(2) - VM*A(1)*A(3)/(A(1)+KM)
DADT(2) = K12*A(1) - K21*A(2)
DADT(3) =  -(VM-K30)*A(1)*A(3)/(A(1)+KM) - K30*A(3) + K03

$ERROR
ETYPE=1
IF(CMT.NE.1) ETYPE=0
IF(ETYPE==1) THEN
IPRED=A(1)/S1
Y = IPRED + IPRED*EPS(1)
ELSE
IPRED=A(3)/S3
Y = IPRED + IPRED*EPS(2)
ENDIF


$THETA (1.5)X8

$OMEGA BLOCK(8) VALUES(2.0,0.01) ;[P]

$SIGMA
0.1 ;[p]
0.1 ;[p]


$EST METHOD=IMP INTERACTION AUTO=1 PRINT=1 SIGL=6 MCETA=100
$COV MATRIX=R UNCONDITIONAL
  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
  
License Registered to: IDS NONMEM 7 TEAM
Expiration Date:     2 JUN 2030
Current Date:       12 MAR 2019
Days until program expires :4095
1NONLINEAR MIXED EFFECTS MODEL PROGRAM (NONMEM) VERSION 7.4.3
 ORIGINALLY DEVELOPED BY STUART BEAL, LEWIS SHEINER, AND ALISON BOECKMANN
 CURRENT DEVELOPERS ARE ROBERT BAUER, ICON DEVELOPMENT SOLUTIONS,
 AND ALISON BOECKMANN. IMPLEMENTATION, EFFICIENCY, AND STANDARDIZATION
 PERFORMED BY NOUS INFOSYSTEMS.

 PROBLEM NO.:         1
 RUN# r2compl Indirect Response Model (r2complb.ctl)
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:     1700
 NO. OF DATA ITEMS IN DATA SET:  11
 ID DATA ITEM IS DATA ITEM NO.:   3
 DEP VARIABLE IS DATA ITEM NO.:   6
 MDV DATA ITEM IS DATA ITEM NO.: 10
0INDICES PASSED TO SUBROUTINE PRED:
   9   5   7   8   0   0  11   0   0   0   0
0LABELS FOR DATA ITEMS:
 C SET ID JID TIME CONC DOSE RATE EVID MDV CMT
0FORMAT FOR DATA:
 (2E2.0,2E3.0,E5.0,E10.0,2E5.0,3E2.0)

 TOT. NO. OF OBS RECS:     1568
 TOT. NO. OF INDIVIDUALS:       50
0LENGTH OF THETA:   8
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS BLOCK FORM:
  1
  1  1
  1  1  1
  1  1  1  1
  1  1  1  1  1
  1  1  1  1  1  1
  1  1  1  1  1  1  1
  1  1  1  1  1  1  1  1
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   2
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
   0.1500E+01  0.1500E+01  0.1500E+01  0.1500E+01  0.1500E+01  0.1500E+01  0.1500E+01  0.1500E+01
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.2000E+01
                  0.1000E-01   0.2000E+01
                  0.1000E-01   0.1000E-01   0.2000E+01
                  0.1000E-01   0.1000E-01   0.1000E-01   0.2000E+01
                  0.1000E-01   0.1000E-01   0.1000E-01   0.1000E-01   0.2000E+01
                  0.1000E-01   0.1000E-01   0.1000E-01   0.1000E-01   0.1000E-01   0.2000E+01
                  0.1000E-01   0.1000E-01   0.1000E-01   0.1000E-01   0.1000E-01   0.1000E-01   0.2000E+01
                  0.1000E-01   0.1000E-01   0.1000E-01   0.1000E-01   0.1000E-01   0.1000E-01   0.1000E-01   0.2000E+01
0INITIAL ESTIMATE OF SIGMA:
 0.1000E+00
 0.0000E+00   0.1000E+00
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
1DOUBLE PRECISION PREDPP VERSION 7.4.3

 GENERAL NONLINEAR KINETICS MODEL WITH STIFF/NONSTIFF EQUATIONS (LSODA, ADVAN13)
0MODEL SUBROUTINE USER-SUPPLIED - ID NO. 9999
0MAXIMUM NO. OF BASIC PK PARAMETERS:   7
0COMPARTMENT ATTRIBUTES
 COMPT. NO.   FUNCTION   INITIAL    ON/OFF      DOSE      DEFAULT    DEFAULT
                         STATUS     ALLOWED    ALLOWED    FOR DOSE   FOR OBS.
    1         COMP 1       ON         YES        YES        YES        YES
    2         COMP 2       ON         YES        YES        NO         NO
    3         COMP 3       ON         YES        YES        NO         NO
    4         OUTPUT       OFF        YES        NO         NO         NO
 INITIAL (BASE) TOLERANCE SETTINGS:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:   6
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
1
 ADDITIONAL PK PARAMETERS - ASSIGNMENT OF ROWS IN GG
 COMPT. NO.                             INDICES
              SCALE      BIOAVAIL.   ZERO-ORDER  ZERO-ORDER  ABSORB
                         FRACTION    RATE        DURATION    LAG
    1            9           *           *           *           *
    2            *           *           *           *           *
    3            8           *           *           *           *
    4            *           -           -           -           -
             - PARAMETER IS NOT ALLOWED FOR THIS MODEL
             * PARAMETER IS NOT SUPPLIED BY PK SUBROUTINE;
               WILL DEFAULT TO ONE IF APPLICABLE
0DATA ITEM INDICES USED BY PRED ARE:
   EVENT ID DATA ITEM IS DATA ITEM NO.:      9
   TIME DATA ITEM IS DATA ITEM NO.:          5
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   7
   DOSE RATE DATA ITEM IS DATA ITEM NO.:     8
   COMPT. NO. DATA ITEM IS DATA ITEM NO.:   11

0PK SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 PK SUBROUTINE NOT CALLED AT NONEVENT (ADDITIONAL OR LAGGED) DOSE TIMES.
0PK SUBROUTINE INDICATES THAT COMPARTMENT AMOUNTS ARE INITIALIZED.
0ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
0ERROR SUBROUTINE INDICATES THAT DERIVATIVES OF COMPARTMENT AMOUNTS ARE USED.
0DES SUBROUTINE USES COMPACT STORAGE MODE.
1
 
 
 #TBLN:      1
 #METH: Importance Sampling (No Prior)
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            1680
 NO. OF SIG. FIGURES REQUIRED:            3
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
 IND. OBJ. FUNC. VALUES SORTED:           NO
 NUMERICAL DERIVATIVE
       FILE REQUEST (NUMDER):               NONE
 MAP (ETAHAT) ESTIMATION METHOD (OPTMAP):   0
 ETA HESSIAN EVALUATION METHOD (ETADER):    0
 INITIAL ETA FOR MAP ESTIMATION (MCETA):    100
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      6
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     6
 NOPRIOR SETTING (NOPRIOR):                 ON
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): r2complb_imp.ext
 EXCLUDE TITLE (NOTITLE):                   NO
 EXCLUDE COLUMN LABELS (NOLABEL):           NO
 FORMAT FOR ADDITIONAL FILES (FORMAT):      S1PE12.5
 PARAMETER ORDER FOR OUTPUTS (ORDER):       TSOL
 WISHART PRIOR DF INTERPRETATION (WISHTYPE):0
 KNUTHSUMOFF:                               0
 INCLUDE LNTWOPI:                           NO
 INCLUDE CONSTANT TERM TO PRIOR (PRIORC):   NO
 INCLUDE CONSTANT TERM TO OMEGA (ETA) (OLNTWOPI):NO
 EM OR BAYESIAN METHOD USED:                IMPORTANCE SAMPLING (IMP)
 MU MODELING PATTERN (MUM):
 GRADIENT/GIBBS PATTERN (GRD):
 AUTOMATIC SETTING FEATURE (AUTO):          ON
 CONVERGENCE TYPE (CTYPE):                  3
 CONVERGENCE INTERVAL (CINTERVAL):          1
 CONVERGENCE ITERATIONS (CITER):            10
 CONVERGENCE ALPHA ERROR (CALPHA):          5.000000000000000E-02
 ITERATIONS (NITER):                        500
 ANEAL SETTING (CONSTRAIN):                 1
 STARTING SEED FOR MC METHODS (SEED):       11456
 MC SAMPLES PER SUBJECT (ISAMPLE):          300
 MAXIMUM SAMPLES PER SUBJECT FOR AUTOMATIC
 ISAMPLE ADJUSTMENT (ISAMPEND):             10000
 RANDOM SAMPLING METHOD (RANMETHOD):        3U
 EXPECTATION ONLY (EONLY):                  0
 PROPOSAL DENSITY SCALING RANGE
              (ISCALE_MIN, ISCALE_MAX):     0.100000000000000       ,10.0000000000000
 SAMPLE ACCEPTANCE RATE (IACCEPT):          0.00000000000000
 LONG TAIL SAMPLE ACCEPT. RATE (IACCEPTL):   0.00000000000000
 T-DIST. PROPOSAL DENSITY (DF):             0
 NO. ITERATIONS FOR MAP (MAPITER):          1
 INTERVAL ITER. FOR MAP (MAPINTER):         0
 MAP COVARIANCE/MODE SETTING (MAPCOV):      1
 Gradient Quick Value (GRDQ):               0.00000000000000
 STOCHASTIC OBJ VARIATION TOLERANCE FOR
 AUTOMATIC ISAMPLE ADJUSTMENT (STDOBJ):     1.00000000000000

 TOLERANCES FOR ESTIMATION/EVALUATION STEP:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:   6
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
 TOLERANCES FOR COVARIANCE STEP:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:   6
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
 
 THE FOLLOWING LABELS ARE EQUIVALENT
 PRED=PREDI
 RES=RESI
 WRES=WRESI
 IWRS=IWRESI
 IPRD=IPREDI
 IRS=IRESI
 
 EM/BAYES SETUP:
 THETAS THAT ARE MU MODELED:
   1   2   3   4   5   6   7   8
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 iteration            0 OBJ=  -2083.27457055654 eff.=     319. Smpl.=     300. Fit.= 0.97602
 iteration            1 OBJ=  -3501.48350751275 eff.=     142. Smpl.=     300. Fit.= 0.96145
 iteration            2 OBJ=  -3675.38139602258 eff.=      73. Smpl.=     300. Fit.= 0.95833
 iteration            3 OBJ=  -3801.11266520897 eff.=      94. Smpl.=     300. Fit.= 0.96189
 iteration            4 OBJ=  -3916.15127550522 eff.=      91. Smpl.=     300. Fit.= 0.96443
 iteration            5 OBJ=  -4019.54161721735 eff.=      83. Smpl.=     300. Fit.= 0.96537
 iteration            6 OBJ=  -4123.86604886753 eff.=      69. Smpl.=     300. Fit.= 0.96295
 iteration            7 OBJ=  -4223.82604728485 eff.=      72. Smpl.=     300. Fit.= 0.96489
 iteration            8 OBJ=  -4320.06313977161 eff.=      65. Smpl.=     300. Fit.= 0.96239
 iteration            9 OBJ=  -4416.87578513493 eff.=      61. Smpl.=     300. Fit.= 0.96196
 iteration           10 OBJ=  -4506.91092291823 eff.=      63. Smpl.=     300. Fit.= 0.96255
 iteration           11 OBJ=  -4589.87173922602 eff.=      57. Smpl.=     300. Fit.= 0.96213
 iteration           12 OBJ=  -4655.72971656070 eff.=      58. Smpl.=     300. Fit.= 0.96194
 iteration           13 OBJ=  -4696.40437291431 eff.=      63. Smpl.=     300. Fit.= 0.96252
 iteration           14 OBJ=  -4703.02045923981 eff.=      75. Smpl.=     300. Fit.= 0.96565
 iteration           15 OBJ=  -4704.42453831595 eff.=      68. Smpl.=     300. Fit.= 0.96396
 iteration           16 OBJ=  -4704.81949796632 eff.=      55. Smpl.=     300. Fit.= 0.96156
 iteration           17 OBJ=  -4705.44099900221 eff.=      57. Smpl.=     300. Fit.= 0.96220
 iteration           18 OBJ=  -4704.53533790181 eff.=      72. Smpl.=     377. Fit.= 0.96307
 iteration           19 OBJ=  -4706.32404319360 eff.=      65. Smpl.=     336. Fit.= 0.96233
 iteration           20 OBJ=  -4705.26809025277 eff.=      63. Smpl.=     300. Fit.= 0.96395
 iteration           21 OBJ=  -4706.32789965352 eff.=      70. Smpl.=     300. Fit.= 0.96418
 iteration           22 OBJ=  -4705.92649425897 eff.=      62. Smpl.=     300. Fit.= 0.96351
 iteration           23 OBJ=  -4705.57021005780 eff.=      68. Smpl.=     300. Fit.= 0.96407
 iteration           24 OBJ=  -4706.28011145736 eff.=      65. Smpl.=     300. Fit.= 0.96372
 iteration           25 OBJ=  -4706.92242777285 eff.=      65. Smpl.=     300. Fit.= 0.96333
 iteration           26 OBJ=  -4705.73881617059 eff.=      68. Smpl.=     300. Fit.= 0.96570
 iteration           27 OBJ=  -4705.25031238642 eff.=      68. Smpl.=     300. Fit.= 0.96504
 iteration           28 OBJ=  -4707.14782863818 eff.=      72. Smpl.=     300. Fit.= 0.96525
 iteration           29 OBJ=  -4705.92054822975 eff.=      67. Smpl.=     300. Fit.= 0.96485
 iteration           30 OBJ=  -4705.58358262150 eff.=      71. Smpl.=     300. Fit.= 0.96587
 iteration           31 OBJ=  -4704.74410264623 eff.=      68. Smpl.=     300. Fit.= 0.96591
 iteration           32 OBJ=  -4707.45217166880 eff.=      71. Smpl.=     300. Fit.= 0.96510
 iteration           33 OBJ=  -4706.33342892179 eff.=      92. Smpl.=     377. Fit.= 0.96664
 iteration           34 OBJ=  -4705.71639568060 eff.=      91. Smpl.=     392. Fit.= 0.96657
 iteration           35 OBJ=  -4705.62532572606 eff.=     105. Smpl.=     435. Fit.= 0.96686
 iteration           36 OBJ=  -4706.63643488970 eff.=     120. Smpl.=     503. Fit.= 0.96602
 iteration           37 OBJ=  -4705.61462477197 eff.=     110. Smpl.=     448. Fit.= 0.96808
 iteration           38 OBJ=  -4705.76133395272 eff.=      98. Smpl.=     399. Fit.= 0.96761
 iteration           39 OBJ=  -4705.91765067501 eff.=      83. Smpl.=     355. Fit.= 0.96639
 iteration           40 OBJ=  -4707.56968920855 eff.=      78. Smpl.=     316. Fit.= 0.96598
 iteration           41 OBJ=  -4708.01499292495 eff.=      81. Smpl.=     300. Fit.= 0.96582
 iteration           42 OBJ=  -4704.72684183923 eff.=      70. Smpl.=     300. Fit.= 0.96704
 iteration           43 OBJ=  -4706.92211926410 eff.=      91. Smpl.=     377. Fit.= 0.96546
 Convergence achieved
 iteration           43 OBJ=  -4706.23274334490 eff.=      91. Smpl.=     377. Fit.= 0.96692
 
 #TERM:
 OPTIMIZATION WAS COMPLETED


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -1.1361E-03 -2.4037E-03  5.3893E-03  3.5547E-03  1.1040E-03  7.1996E-05  7.6031E-04  2.6171E-03
 SE:             6.9055E-02  5.7687E-02  3.8095E-02  6.7346E-02  5.5078E-02  5.7198E-02  6.4853E-02  5.8797E-02
 N:                      50          50          50          50          50          50          50          50
 
 P VAL.:         9.8687E-01  9.6676E-01  8.8750E-01  9.5791E-01  9.8401E-01  9.9900E-01  9.9065E-01  9.6450E-01
 
 ETASHRINKSD(%)  9.3583E-01  3.4684E+00  1.0850E+01  1.7183E+00  1.5152E+00  6.1224E+00  4.2109E-01  2.0263E+00
 ETASHRINKVR(%)  1.8629E+00  6.8165E+00  2.0522E+01  3.4070E+00  3.0074E+00  1.1870E+01  8.4040E-01  4.0115E+00
 EBVSHRINKSD(%)  6.7427E-01  4.1328E+00  1.0072E+01  2.1806E+00  1.5922E+00  5.8291E+00  3.5321E-01  1.8304E+00
 EBVSHRINKVR(%)  1.3440E+00  8.0948E+00  1.9129E+01  4.3137E+00  3.1590E+00  1.1318E+01  7.0517E-01  3.6272E+00
 EPSSHRINKSD(%)  1.6298E+01  7.2334E+00
 EPSSHRINKVR(%)  2.9941E+01  1.3944E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         1568
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    2881.79124012985     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -4706.23274334490     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:      -1824.44150321505     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           400
  
 #TERE:
 Elapsed estimation  time in seconds:   238.73
 Elapsed covariance  time in seconds:     6.56
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************    -4706.233       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         3.89E+00 -2.23E+00  5.88E-01 -1.68E-01  2.31E+00  2.71E-01  3.66E+00 -7.25E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8     
 
 ETA1
+        2.48E-01
 
 ETA2
+       -4.25E-02  1.82E-01
 
 ETA3
+        4.95E-02 -1.98E-02  9.32E-02
 
 ETA4
+        3.01E-02  6.64E-02 -3.38E-03  2.40E-01
 
 ETA5
+        3.30E-02  2.78E-02 -4.46E-03 -3.34E-02  1.60E-01
 
 ETA6
+       -2.50E-02  8.51E-03  2.55E-02  1.85E-02 -8.24E-02  1.89E-01
 
 ETA7
+        2.87E-02 -5.70E-02  2.39E-02 -8.21E-02  3.33E-02  7.21E-03  2.16E-01
 
 ETA8
+        9.27E-02  8.25E-02  4.37E-02  4.36E-02  1.22E-02 -4.82E-02  4.67E-02  1.84E-01
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1      EPS2     
 
 EPS1
+        9.51E-03
 
 EPS2
+        0.00E+00  2.26E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8     
 
 ETA1
+        4.98E-01
 
 ETA2
+       -2.00E-01  4.27E-01
 
 ETA3
+        3.26E-01 -1.52E-01  3.05E-01
 
 ETA4
+        1.24E-01  3.18E-01 -2.26E-02  4.89E-01
 
 ETA5
+        1.66E-01  1.63E-01 -3.66E-02 -1.71E-01  3.99E-01
 
 ETA6
+       -1.16E-01  4.58E-02  1.92E-01  8.70E-02 -4.74E-01  4.35E-01
 
 ETA7
+        1.24E-01 -2.87E-01  1.68E-01 -3.60E-01  1.79E-01  3.56E-02  4.65E-01
 
 ETA8
+        4.34E-01  4.51E-01  3.34E-01  2.08E-01  7.12E-02 -2.58E-01  2.34E-01  4.29E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1      EPS2     
 
 EPS1
+        9.75E-02
 
 EPS2
+        0.00E+00  1.50E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                          STANDARD ERROR OF ESTIMATE (R)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         7.13E-02  7.21E-02  5.14E-02  7.15E-02  5.85E-02  6.96E-02  6.65E-02  6.24E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8     
 
 ETA1
+        5.08E-02
 
 ETA2
+        3.44E-02  4.64E-02
 
 ETA3
+        2.58E-02  2.48E-02  2.70E-02
 
 ETA4
+        3.59E-02  3.52E-02  2.73E-02  5.24E-02
 
 ETA5
+        2.94E-02  2.69E-02  2.11E-02  2.95E-02  3.39E-02
 
 ETA6
+        3.48E-02  3.21E-02  2.43E-02  3.49E-02  3.11E-02  4.86E-02
 
 ETA7
+        3.38E-02  3.49E-02  2.34E-02  3.52E-02  2.78E-02  3.28E-02  4.38E-02
 
 ETA8
+        3.40E-02  3.09E-02  2.38E-02  3.21E-02  2.59E-02  3.14E-02  3.05E-02  3.97E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1      EPS2     
 
 EPS1
+        6.56E-04
 
 EPS2
+        0.00E+00  1.20E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8     
 
 ETA1
+        5.10E-02
 
 ETA2
+        1.50E-01  5.44E-02
 
 ETA3
+        1.51E-01  1.88E-01  4.42E-02
 
 ETA4
+        1.44E-01  1.44E-01  1.83E-01  5.36E-02
 
 ETA5
+        1.43E-01  1.53E-01  1.73E-01  1.45E-01  4.24E-02
 
 ETA6
+        1.60E-01  1.74E-01  1.81E-01  1.62E-01  1.40E-01  5.58E-02
 
 ETA7
+        1.43E-01  1.52E-01  1.60E-01  1.28E-01  1.43E-01  1.61E-01  4.71E-02
 
 ETA8
+        1.23E-01  1.35E-01  1.52E-01  1.43E-01  1.50E-01  1.57E-01  1.40E-01  4.63E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1      EPS2     
 
 EPS1
+        3.37E-03
 
 EPS2
+       .........  4.01E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (R)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM13      OM14  
             OM15      OM16      OM17      OM18      OM22      OM23      OM24      OM25      OM26      OM27      OM28      OM33  
            OM34      OM35      OM36      OM37      OM38      OM44      OM45      OM46      OM47      OM48      OM55      OM56  
             OM57      OM58      OM66      OM67      OM68      OM77      OM78      OM88      SG11      SG12      SG22  
 
 TH 1
+        5.08E-03
 
 TH 2
+       -9.96E-04  5.20E-03
 
 TH 3
+        7.75E-04 -2.02E-04  2.64E-03
 
 TH 4
+        5.69E-04  1.19E-03  2.72E-04  5.11E-03
 
 TH 5
+        6.32E-04  3.72E-04 -5.50E-06 -6.17E-04  3.43E-03
 
 TH 6
+       -3.85E-04 -2.73E-04  3.00E-04  4.15E-04 -1.31E-03  4.85E-03
 
 TH 7
+        5.96E-04 -1.37E-03  4.63E-04 -1.63E-03  7.47E-04  2.79E-04  4.43E-03
 
 TH 8
+        1.82E-03  1.36E-03  1.01E-03  9.21E-04  3.29E-04 -9.47E-04  1.04E-03  3.90E-03
 
 OM11
+        1.66E-05 -2.06E-05 -1.71E-05 -2.25E-06  1.12E-05 -5.26E-09  1.38E-06 -1.32E-05  2.58E-03
 
 OM12
+        4.75E-05  1.25E-04 -1.33E-05 -3.18E-05 -1.02E-05  3.36E-05  2.92E-06 -1.62E-06 -4.98E-04  1.18E-03
 
 OM13
+       -4.18E-05  1.85E-05  4.06E-05  1.27E-05 -1.15E-05 -6.91E-06 -1.33E-05 -1.16E-05  3.94E-04 -1.08E-04  6.67E-04
 
 OM14
+       -1.05E-05 -1.89E-05 -4.16E-05 -1.47E-05 -7.61E-06  6.66E-06  8.05E-06 -1.85E-05  3.00E-04  3.14E-04  7.04E-05  1.29E-03
 
 OM15
+       -1.67E-05  1.20E-05  3.33E-06 -6.31E-08  3.85E-05  4.28E-05  7.38E-06 -4.33E-06  3.21E-04  8.92E-05  1.74E-05 -1.40E-04
          8.63E-04
 
 OM16
+       -2.81E-05 -6.57E-06 -1.66E-05 -1.26E-05  4.13E-05  1.30E-05  3.48E-06 -1.20E-05 -1.92E-04 -2.10E-05  5.68E-05  6.59E-05
         -3.52E-04  1.21E-03
 
 OM17
+       -2.26E-05 -5.62E-06  4.52E-07  8.26E-06  1.79E-05  9.19E-06  7.89E-06  3.61E-06  2.78E-04 -3.67E-04  1.23E-04 -4.08E-04
          2.00E-04  8.56E-05  1.14E-03
 
 OM18
+       -3.35E-05  1.25E-06 -1.48E-05 -1.56E-05 -1.07E-05 -3.21E-06  8.54E-06 -1.45E-05  9.07E-04  2.73E-04  3.30E-04  2.90E-04
          1.29E-04 -2.84E-04  2.95E-04  1.15E-03
 
 OM22
+       -5.07E-05 -5.27E-04  6.69E-05  9.35E-05  1.83E-05 -3.39E-05 -6.67E-06  9.62E-05  8.34E-05 -5.49E-04  5.58E-05 -1.38E-04
         -5.78E-05  2.62E-05  1.39E-04 -1.33E-04  2.16E-03
 
 OM23
+       -3.63E-05  2.15E-04  1.40E-04  2.32E-05 -1.73E-05 -7.07E-05 -2.18E-05 -3.55E-05 -9.39E-05  1.96E-04 -8.32E-05  5.71E-05
          2.30E-05 -4.03E-05 -8.14E-05  6.71E-06 -2.11E-04  6.16E-04
 
1

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM13      OM14  
             OM15      OM16      OM17      OM18      OM22      OM23      OM24      OM25      OM26      OM27      OM28      OM33  
            OM34      OM35      OM36      OM37      OM38      OM44      OM45      OM46      OM47      OM48      OM55      OM56  
             OM57      OM58      OM66      OM67      OM68      OM77      OM78      OM88      SG11      SG12      SG22  
 
 OM24
+       -4.10E-05 -3.50E-04  1.18E-04  9.93E-05  2.30E-05  7.15E-06  3.11E-06  5.43E-05 -6.26E-05 -2.20E-05  2.15E-05 -1.94E-04
          3.44E-05 -4.20E-06  4.59E-05 -5.41E-06  7.61E-04  1.85E-05  1.24E-03
 
 OM25
+        7.85E-06 -3.35E-05 -6.88E-06 -1.13E-05  3.22E-05  4.89E-06  4.12E-05  2.86E-05 -7.44E-05  9.45E-05 -1.01E-06  7.05E-05
         -1.51E-04  7.17E-05 -6.77E-05  3.86E-05  2.14E-04 -1.01E-05 -9.19E-05  7.23E-04
 
 OM26
+        1.14E-05  2.88E-05 -1.29E-06 -5.97E-06  7.03E-07  1.23E-04  1.27E-05 -8.33E-06  4.05E-05 -4.37E-05 -1.97E-05 -1.75E-05
          7.63E-05 -2.44E-04 -1.02E-06  1.61E-05 -1.05E-04  9.78E-05  4.61E-05 -3.10E-04  1.03E-03
 
 OM27
+        2.44E-05  5.00E-04 -5.71E-05 -8.05E-05 -3.75E-05 -5.35E-05  9.70E-06 -6.50E-05 -5.72E-05  2.56E-04 -3.02E-05  1.29E-04
         -6.56E-06 -3.40E-05 -2.58E-04  1.28E-06 -7.41E-04  1.58E-04 -6.03E-04  1.29E-04  9.27E-05  1.22E-03
 
 OM28
+        8.70E-06  2.44E-05  9.34E-06 -3.01E-06  1.37E-05  9.45E-06  2.20E-05  3.35E-05 -1.87E-04  3.13E-04 -5.40E-05  7.40E-05
          3.78E-05  3.19E-05 -1.64E-04 -6.24E-05  6.62E-04  1.61E-04  2.55E-04  1.18E-04 -2.13E-04  1.50E-04  9.57E-04
 
 OM33
+       -6.11E-06  6.93E-05 -1.63E-04 -9.47E-05 -2.78E-05  1.95E-06 -2.31E-05 -2.32E-05  3.90E-05 -1.66E-05  2.58E-04  4.41E-05
         -9.16E-06  2.94E-05  3.48E-05  7.58E-05  2.61E-05 -3.61E-05  3.77E-06  4.95E-06 -1.20E-05  4.67E-06 -4.00E-06  7.27E-04
 
 OM34
+       -7.22E-05  6.72E-05  2.38E-04  8.57E-05  2.93E-05 -2.65E-05 -3.50E-06  6.28E-06  2.80E-05  5.23E-05  1.42E-04  2.12E-04
         -1.35E-05  2.19E-05 -5.81E-05  7.06E-05  1.07E-05  1.98E-04 -5.75E-06 -3.99E-06  9.90E-06  3.01E-05  7.17E-05  3.18E-05
         7.43E-04
 
 OM35
+        6.47E-06  3.11E-06 -8.07E-05 -3.10E-05 -2.73E-05  1.42E-05 -1.19E-05 -2.82E-05  5.09E-05  9.16E-06  6.23E-05 -1.66E-05
          1.34E-04 -4.22E-05  3.80E-05  3.36E-05 -1.32E-05  7.37E-05  6.03E-06 -3.53E-05  3.41E-05  2.77E-05  3.42E-05  8.83E-06
        -1.18E-04  4.47E-04
 
 OM36
+       -5.33E-06 -2.27E-05  2.88E-05  2.03E-05  1.84E-05 -6.09E-05  3.97E-06  1.61E-05 -4.36E-05 -1.16E-05 -6.19E-06  1.81E-05
         -5.93E-05  1.72E-04  7.22E-06 -3.95E-05  1.63E-05 -2.89E-05  3.98E-06  2.99E-05 -6.04E-05 -1.36E-05  9.17E-06  5.06E-05
         7.40E-05 -1.96E-04  5.92E-04
 
 OM37
+        1.64E-05 -4.80E-05 -1.12E-04 -5.14E-05 -2.57E-05  6.47E-06 -1.99E-05 -3.62E-06  3.54E-05 -6.02E-05  6.07E-05 -7.45E-05
          1.30E-05  2.06E-05  2.02E-04  8.42E-05  3.35E-05 -1.78E-04 -8.01E-06  7.38E-06 -3.35E-05 -8.89E-05 -8.68E-05  9.60E-05
        -2.17E-04  7.54E-05  3.39E-05  5.47E-04
 
 OM38
+       -4.13E-05  2.26E-06  1.41E-06 -1.67E-05  3.54E-06  2.35E-05 -6.53E-06 -1.87E-05  1.33E-04  4.39E-05  2.92E-04  6.77E-05
          2.16E-06  4.51E-06  9.70E-05  2.63E-04 -1.94E-05  1.85E-04  1.92E-05  9.81E-06  3.90E-05  1.11E-05  3.60E-05  3.09E-04
         1.60E-04  2.58E-05 -1.11E-04  1.15E-04  5.67E-04
 
 OM44
+       -6.41E-05 -1.25E-05  3.16E-04  1.90E-04  4.70E-05  2.88E-05  1.30E-05  1.15E-05  2.52E-05  7.83E-05  5.04E-05  3.22E-04
         -3.12E-05  1.76E-05 -9.59E-05  5.40E-05  2.09E-04  6.08E-05  6.93E-04 -8.80E-05  5.02E-05 -2.39E-04  1.31E-04 -4.55E-05
         2.12E-04 -4.92E-05  1.92E-05 -6.80E-05  4.20E-05  2.75E-03
 
 OM45
+       -9.36E-06 -9.08E-07 -7.63E-07 -1.76E-05  2.94E-06  3.92E-05  1.52E-05  7.79E-06  4.23E-05  4.48E-05  1.08E-05  1.36E-04
          8.24E-05 -2.29E-05 -2.44E-05  4.51E-05  7.72E-05 -4.35E-06  7.52E-05  2.14E-04 -6.39E-05  1.71E-05  5.10E-05 -4.82E-06
        -1.79E-05  4.46E-05 -1.20E-05  8.68E-06 -1.08E-06 -3.33E-04  8.70E-04
 
 OM46
+        5.27E-06 -3.16E-05 -2.23E-05 -1.24E-05  4.79E-05  1.13E-04  4.27E-05  3.00E-05 -4.75E-05 -1.70E-06  1.38E-05 -6.93E-05
         -1.84E-05  1.15E-04  4.93E-05 -3.09E-05 -3.57E-05 -1.77E-06 -1.67E-05 -6.46E-05  3.24E-04  3.36E-05 -5.73E-05  6.39E-06
         7.23E-05 -2.70E-05  4.09E-05 -2.71E-05  2.28E-05  2.49E-04 -3.58E-04  1.22E-03
 
1

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM13      OM14  
             OM15      OM16      OM17      OM18      OM22      OM23      OM24      OM25      OM26      OM27      OM28      OM33  
            OM34      OM35      OM36      OM37      OM38      OM44      OM45      OM46      OM47      OM48      OM55      OM56  
             OM57      OM58      OM66      OM67      OM68      OM77      OM78      OM88      SG11      SG12      SG22  
 
 OM47
+        2.04E-05  1.90E-05 -8.91E-05 -7.20E-05  6.41E-06  3.99E-05  1.04E-05  1.16E-05  3.18E-05  8.29E-06 -1.98E-06  9.66E-05
          4.94E-06  2.54E-05  9.62E-05  7.02E-05 -2.06E-04 -2.38E-06 -4.46E-04  9.44E-05 -1.46E-05  4.12E-04  6.59E-06  1.62E-05
         7.03E-05 -6.05E-06  5.02E-06  1.11E-05  2.14E-05 -8.40E-04  2.39E-04  4.08E-05  1.24E-03
 
 OM48
+       -3.66E-05  6.58E-05  2.14E-05 -3.93E-05  2.30E-05  3.18E-05  2.59E-05 -9.35E-06  1.08E-04  1.65E-04  7.22E-05  4.84E-04
         -3.95E-05  2.26E-05 -1.05E-04  2.15E-04  1.80E-04  9.46E-05  4.23E-04 -2.21E-05 -3.17E-05 -4.15E-05  3.25E-04  5.71E-05
         3.04E-04 -4.27E-05  1.98E-05 -8.37E-05  1.07E-04  4.59E-04  5.06E-05 -2.18E-04  1.75E-04  1.03E-03
 
 OM55
+        8.69E-06 -1.57E-05 -1.94E-05 -3.54E-06 -6.21E-05 -4.41E-05 -6.43E-06 -1.45E-05  2.03E-05  2.29E-05  3.05E-06 -4.33E-05
          1.91E-04 -7.49E-05  5.31E-05  2.73E-05  5.93E-05 -9.37E-06 -2.54E-05  1.77E-04 -1.01E-04  1.22E-05 -2.40E-06  1.93E-05
        -2.66E-06 -1.40E-05  2.14E-05  1.20E-05  1.52E-05  2.84E-05 -2.22E-04  9.09E-05 -4.57E-05 -2.05E-05  1.15E-03
 
 OM56
+        7.00E-06 -1.43E-05 -1.42E-05  1.96E-06 -2.72E-05 -2.07E-05 -1.73E-05 -2.36E-06 -6.06E-06  2.70E-06  1.27E-05  3.10E-05
         -8.42E-05  1.60E-04 -2.07E-05 -4.38E-05 -1.30E-05  1.39E-05  1.87E-05 -8.49E-05  1.59E-04  1.39E-05 -7.95E-06 -2.21E-06
        -1.07E-05  7.68E-05 -5.64E-05 -4.28E-06 -1.14E-05 -3.17E-05  1.18E-04 -2.04E-04 -7.24E-06  3.02E-05 -4.99E-04  9.66E-04
 
 OM57
+        8.94E-06 -1.49E-05 -2.74E-05  4.73E-06 -1.24E-05 -1.17E-05 -3.13E-05 -2.33E-05  3.60E-05 -1.22E-05 -6.77E-07 -7.29E-05
          1.30E-04 -4.61E-05  1.49E-04  2.68E-05 -6.53E-05  1.74E-05  1.56E-06 -2.12E-04  1.08E-04  5.11E-05  3.98E-06 -2.13E-05
        -2.12E-05  8.72E-05 -4.69E-05  4.47E-06 -2.06E-05  9.98E-05 -3.00E-04  8.57E-05 -2.06E-04 -7.15E-05  2.36E-04  1.51E-05
          7.75E-04
 
 OM58
+       -1.06E-05 -8.21E-06 -2.42E-05 -5.15E-06 -2.46E-06  4.20E-05 -6.31E-06 -1.46E-05  1.07E-04  9.44E-05  1.83E-05 -2.92E-05
          3.19E-04 -1.60E-04  9.19E-05  1.38E-04  7.07E-05  2.88E-05 -2.68E-05  2.58E-04 -1.05E-04  8.27E-05  1.23E-04 -1.73E-06
        -4.68E-05  1.90E-04 -8.73E-05  2.04E-05  2.72E-06 -6.26E-05  1.49E-04 -2.95E-05 -1.02E-06 -1.14E-04  8.71E-05 -1.66E-04
          1.89E-04  6.73E-04
 
 OM66
+        1.52E-05 -3.24E-05 -4.21E-05 -7.44E-06  1.06E-04 -4.30E-05  1.16E-05  1.51E-05  1.48E-05 -3.63E-06 -3.52E-05 -3.42E-05
          3.98E-05 -1.23E-04  1.44E-05  2.68E-05  5.75E-06 -2.33E-05  1.32E-05  4.06E-05 -9.38E-05 -2.28E-05  7.49E-06 -6.71E-06
        -7.78E-06 -5.27E-05  1.67E-04  2.32E-06 -4.20E-05 -2.06E-05 -5.92E-05  1.72E-04  1.62E-05 -5.02E-05  1.90E-04 -7.41E-04
         -4.51E-05  1.09E-04  2.36E-03
 
 OM67
+       -2.20E-06 -1.23E-04  7.18E-06  3.67E-05 -4.23E-06 -8.73E-05 -1.12E-05  1.00E-05 -3.79E-06 -3.63E-06 -4.48E-06  3.71E-05
         -7.01E-05  1.74E-04 -7.05E-05 -6.02E-05  5.43E-05 -3.16E-05  9.04E-06  8.88E-05 -3.31E-04 -7.43E-05  4.47E-05  1.04E-05
        -1.60E-05 -3.67E-05  1.02E-04  7.73E-05 -1.57E-06 -7.23E-05  1.06E-04 -3.94E-04  6.84E-05  8.99E-05 -8.22E-05  1.68E-04
         -3.03E-04 -1.30E-04  1.19E-04  1.07E-03
 
 OM68
+       -9.87E-06 -9.52E-05  4.32E-05  2.88E-05  4.00E-05  2.44E-06  2.60E-05  1.71E-05 -7.34E-05 -6.54E-05  2.02E-05  2.41E-05
         -1.42E-04  4.41E-04  1.02E-05 -1.52E-04 -3.01E-06  2.97E-05  5.14E-05 -8.25E-05  3.42E-04 -1.72E-05 -1.13E-04  7.11E-07
         4.99E-05 -8.65E-05  2.41E-04  4.10E-05  3.31E-05  4.49E-05 -5.89E-05  1.86E-04  2.78E-05  4.29E-05 -2.24E-05  9.99E-05
         -9.31E-05 -3.10E-04 -4.48E-04  2.39E-04  9.85E-04
 
 OM77
+       -6.76E-06 -1.36E-04  2.65E-05  4.09E-05  1.13E-06  1.58E-05 -4.38E-05 -1.36E-05  2.70E-05 -8.47E-05  3.18E-05 -9.56E-05
          2.85E-05  1.71E-05  2.48E-04  3.57E-05  1.95E-04 -5.35E-05  2.52E-04 -1.03E-04 -2.89E-05 -6.15E-04 -1.40E-04  7.21E-06
        -5.97E-05  1.84E-05  1.20E-05  2.07E-04  4.62E-05  2.75E-04 -1.25E-04 -4.68E-05 -7.13E-04 -1.77E-04  5.81E-05  1.18E-05
          3.14E-04  5.68E-05  7.54E-06  1.13E-04  5.18E-05  1.92E-03
 
1

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM13      OM14  
             OM15      OM16      OM17      OM18      OM22      OM23      OM24      OM25      OM26      OM27      OM28      OM33  
            OM34      OM35      OM36      OM37      OM38      OM44      OM45      OM46      OM47      OM48      OM55      OM56  
             OM57      OM58      OM66      OM67      OM68      OM77      OM78      OM88      SG11      SG12      SG22  
 
 OM78
+       -1.09E-06 -1.20E-04  1.13E-05  3.29E-05  8.25E-06  2.65E-05 -2.61E-05 -7.95E-06  8.04E-05 -8.22E-05  7.33E-05 -1.19E-04
          5.60E-05 -9.36E-06  4.10E-04  1.89E-04 -1.86E-04 -2.93E-05 -1.53E-04  3.94E-05  8.50E-05  2.19E-04 -1.92E-04  2.86E-05
        -5.73E-05  2.33E-05  3.91E-06  2.55E-04  1.28E-04 -1.45E-04  2.46E-06  8.64E-05  1.10E-04 -2.76E-04  3.00E-05 -5.63E-05
          8.64E-05  1.30E-04 -1.89E-05 -1.79E-04  4.66E-05  4.69E-04  9.31E-04
 
 OM88
+       -5.02E-05 -4.40E-05  3.63E-05  5.32E-06  4.86E-05  5.64E-05  1.90E-05 -1.24E-05  3.10E-04  2.51E-04  2.03E-04  1.70E-04
          4.20E-05 -1.60E-04  1.72E-04  6.92E-04  2.02E-04  1.75E-04  1.53E-04  6.76E-05 -1.32E-04  1.34E-04  5.66E-04  1.23E-04
         1.17E-04  1.35E-05 -8.15E-05  9.19E-05  4.09E-04  9.35E-05  2.87E-05 -8.00E-05  9.37E-05  3.77E-04  1.01E-05 -7.15E-05
         -1.27E-05  9.90E-05  8.69E-05 -8.50E-05 -3.07E-04  1.02E-04  4.16E-04  1.58E-03
 
 SG11
+        1.94E-07 -1.06E-06 -5.73E-08 -1.73E-07  5.83E-07  1.10E-06  4.20E-07  3.34E-07 -6.55E-08  4.76E-07 -4.74E-07 -1.80E-07
          3.56E-08  2.55E-07 -4.99E-08 -1.35E-07 -1.48E-06 -9.35E-07 -5.56E-08 -7.53E-12  2.73E-07  1.38E-07 -5.81E-08 -1.30E-06
        -8.79E-07 -5.85E-08  4.72E-08  6.81E-08 -3.95E-07 -1.36E-06  1.03E-07  2.60E-07  6.68E-09 -5.42E-07 -2.61E-07  1.94E-07
          1.13E-07  1.05E-07 -9.34E-09 -1.07E-07  7.54E-08 -3.10E-07 -9.81E-08 -5.52E-07  4.31E-07
 
 SG12
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
        ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG22
+        1.08E-06 -2.88E-07 -1.70E-06 -4.40E-07 -6.02E-07 -4.41E-07 -1.45E-08  1.16E-07 -4.72E-07 -3.15E-07  4.81E-07 -2.05E-08
          1.63E-07 -8.17E-07  2.09E-07  4.80E-07 -8.76E-08 -4.35E-07 -4.15E-07  9.98E-08  1.41E-07  4.24E-07 -7.07E-08 -3.74E-07
         6.14E-08 -6.59E-07  8.72E-07  3.40E-07 -3.85E-07 -2.58E-08 -7.43E-08  7.54E-07  3.31E-07  1.78E-07 -1.26E-07 -3.19E-07
         -4.22E-08 -2.73E-07 -2.38E-06 -5.75E-07  1.55E-07 -5.88E-08  3.62E-08 -5.69E-07 -1.83E-08  0.00E+00  1.45E-06
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (R)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM13      OM14  
             OM15      OM16      OM17      OM18      OM22      OM23      OM24      OM25      OM26      OM27      OM28      OM33  
            OM34      OM35      OM36      OM37      OM38      OM44      OM45      OM46      OM47      OM48      OM55      OM56  
             OM57      OM58      OM66      OM67      OM68      OM77      OM78      OM88      SG11      SG12      SG22  
 
 TH 1
+        7.13E-02
 
 TH 2
+       -1.94E-01  7.21E-02
 
 TH 3
+        2.12E-01 -5.47E-02  5.14E-02
 
 TH 4
+        1.12E-01  2.32E-01  7.40E-02  7.15E-02
 
 TH 5
+        1.51E-01  8.80E-02 -1.83E-03 -1.47E-01  5.85E-02
 
 TH 6
+       -7.76E-02 -5.44E-02  8.40E-02  8.33E-02 -3.22E-01  6.96E-02
 
 TH 7
+        1.26E-01 -2.86E-01  1.36E-01 -3.42E-01  1.92E-01  6.02E-02  6.65E-02
 
 TH 8
+        4.09E-01  3.02E-01  3.14E-01  2.06E-01  8.99E-02 -2.18E-01  2.50E-01  6.24E-02
 
 OM11
+        4.58E-03 -5.63E-03 -6.55E-03 -6.18E-04  3.77E-03 -1.49E-06  4.07E-04 -4.17E-03  5.08E-02
 
 OM12
+        1.94E-02  5.02E-02 -7.52E-03 -1.29E-02 -5.07E-03  1.40E-02  1.28E-03 -7.55E-04 -2.85E-01  3.44E-02
 
 OM13
+       -2.27E-02  9.93E-03  3.06E-02  6.90E-03 -7.60E-03 -3.85E-03 -7.73E-03 -7.21E-03  3.01E-01 -1.22E-01  2.58E-02
 
 OM14
+       -4.12E-03 -7.29E-03 -2.26E-02 -5.74E-03 -3.62E-03  2.66E-03  3.37E-03 -8.27E-03  1.64E-01  2.54E-01  7.60E-02  3.59E-02
 
 OM15
+       -8.00E-03  5.67E-03  2.20E-03 -3.00E-05  2.24E-02  2.09E-02  3.78E-03 -2.36E-03  2.15E-01  8.82E-02  2.29E-02 -1.33E-01
          2.94E-02
 
 OM16
+       -1.13E-02 -2.61E-03 -9.26E-03 -5.06E-03  2.02E-02  5.36E-03  1.50E-03 -5.51E-03 -1.09E-01 -1.75E-02  6.31E-02  5.27E-02
         -3.44E-01  3.48E-02
 
 OM17
+       -9.37E-03 -2.31E-03  2.61E-04  3.42E-03  9.07E-03  3.90E-03  3.51E-03  1.71E-03  1.62E-01 -3.15E-01  1.41E-01 -3.37E-01
          2.02E-01  7.28E-02  3.38E-02
 
 OM18
+       -1.38E-02  5.10E-04 -8.51E-03 -6.43E-03 -5.39E-03 -1.36E-03  3.78E-03 -6.82E-03  5.25E-01  2.33E-01  3.76E-01  2.38E-01
          1.30E-01 -2.40E-01  2.57E-01  3.40E-02
 
 OM22
+       -1.53E-02 -1.57E-01  2.81E-02  2.81E-02  6.73E-03 -1.05E-02 -2.16E-03  3.32E-02  3.54E-02 -3.43E-01  4.65E-02 -8.29E-02
         -4.24E-02  1.62E-02  8.88E-02 -8.41E-02  4.64E-02
 
 OM23
+       -2.05E-02  1.20E-01  1.10E-01  1.31E-02 -1.19E-02 -4.09E-02 -1.32E-02 -2.29E-02 -7.45E-02  2.30E-01 -1.30E-01  6.42E-02
          3.16E-02 -4.66E-02 -9.71E-02  7.96E-03 -1.83E-01  2.48E-02
 
1

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM13      OM14  
             OM15      OM16      OM17      OM18      OM22      OM23      OM24      OM25      OM26      OM27      OM28      OM33  
            OM34      OM35      OM36      OM37      OM38      OM44      OM45      OM46      OM47      OM48      OM55      OM56  
             OM57      OM58      OM66      OM67      OM68      OM77      OM78      OM88      SG11      SG12      SG22  
 
 OM24
+       -1.64E-02 -1.38E-01  6.52E-02  3.95E-02  1.12E-02  2.92E-03  1.33E-03  2.47E-02 -3.51E-02 -1.81E-02  2.36E-02 -1.53E-01
          3.33E-02 -3.43E-03  3.86E-02 -4.53E-03  4.66E-01  2.12E-02  3.52E-02
 
 OM25
+        4.10E-03 -1.73E-02 -4.99E-03 -5.87E-03  2.05E-02  2.61E-03  2.30E-02  1.70E-02 -5.45E-02  1.02E-01 -1.46E-03  7.31E-02
         -1.92E-01  7.66E-02 -7.45E-02  4.22E-02  1.72E-01 -1.51E-02 -9.71E-02  2.69E-02
 
 OM26
+        4.98E-03  1.24E-02 -7.84E-04 -2.60E-03  3.74E-04  5.48E-02  5.93E-03 -4.15E-03  2.48E-02 -3.95E-02 -2.38E-02 -1.52E-02
          8.08E-02 -2.18E-01 -9.43E-04  1.47E-02 -7.06E-02  1.23E-01  4.08E-02 -3.58E-01  3.21E-02
 
 OM27
+        9.83E-03  1.99E-01 -3.19E-02 -3.23E-02 -1.83E-02 -2.20E-02  4.18E-03 -2.98E-02 -3.23E-02  2.13E-01 -3.36E-02  1.03E-01
         -6.40E-03 -2.79E-02 -2.19E-01  1.08E-03 -4.58E-01  1.83E-01 -4.91E-01  1.37E-01  8.27E-02  3.49E-02
 
 OM28
+        3.95E-03  1.09E-02  5.88E-03 -1.36E-03  7.55E-03  4.39E-03  1.07E-02  1.74E-02 -1.19E-01  2.94E-01 -6.76E-02  6.67E-02
          4.16E-02  2.96E-02 -1.57E-01 -5.94E-02  4.61E-01  2.09E-01  2.34E-01  1.41E-01 -2.14E-01  1.39E-01  3.09E-02
 
 OM33
+       -3.18E-03  3.56E-02 -1.18E-01 -4.91E-02 -1.76E-02  1.04E-03 -1.29E-02 -1.38E-02  2.85E-02 -1.78E-02  3.71E-01  4.56E-02
         -1.16E-02  3.14E-02  3.82E-02  8.28E-02  2.08E-02 -5.40E-02  3.97E-03  6.83E-03 -1.38E-02  4.96E-03 -4.80E-03  2.70E-02
 
 OM34
+       -3.71E-02  3.42E-02  1.70E-01  4.40E-02  1.83E-02 -1.40E-02 -1.93E-03  3.69E-03  2.02E-02  5.58E-02  2.01E-01  2.16E-01
         -1.69E-02  2.31E-02 -6.31E-02  7.62E-02  8.44E-03  2.93E-01 -6.00E-03 -5.44E-03  1.13E-02  3.17E-02  8.51E-02  4.32E-02
         2.73E-02
 
 OM35
+        4.30E-03  2.04E-03 -7.43E-02 -2.05E-02 -2.20E-02  9.67E-03 -8.48E-03 -2.14E-02  4.74E-02  1.26E-02  1.14E-01 -2.18E-02
          2.16E-01 -5.73E-02  5.33E-02  4.69E-02 -1.34E-02  1.40E-01  8.11E-03 -6.22E-02  5.02E-02  3.76E-02  5.24E-02  1.55E-02
        -2.04E-01  2.11E-02
 
 OM36
+       -3.07E-03 -1.29E-02  2.30E-02  1.16E-02  1.29E-02 -3.60E-02  2.45E-03  1.06E-02 -3.53E-02 -1.38E-02 -9.85E-03  2.07E-02
         -8.30E-02  2.03E-01  8.79E-03 -4.78E-02  1.44E-02 -4.78E-02  4.65E-03  4.57E-02 -7.73E-02 -1.61E-02  1.22E-02  7.72E-02
         1.12E-01 -3.82E-01  2.43E-02
 
 OM37
+        9.83E-03 -2.85E-02 -9.35E-02 -3.07E-02 -1.88E-02  3.97E-03 -1.28E-02 -2.48E-03  2.98E-02 -7.48E-02  1.01E-01 -8.88E-02
          1.89E-02  2.53E-02  2.55E-01  1.06E-01  3.08E-02 -3.06E-01 -9.74E-03  1.17E-02 -4.46E-02 -1.09E-01 -1.20E-01  1.52E-01
        -3.40E-01  1.52E-01  5.95E-02  2.34E-02
 
 OM38
+       -2.43E-02  1.32E-03  1.16E-03 -9.79E-03  2.54E-03  1.42E-02 -4.12E-03 -1.26E-02  1.10E-01  5.36E-02  4.75E-01  7.93E-02
          3.08E-03  5.44E-03  1.21E-01  3.25E-01 -1.76E-02  3.13E-01  2.29E-02  1.53E-02  5.09E-02  1.34E-02  4.88E-02  4.82E-01
         2.46E-01  5.14E-02 -1.92E-01  2.06E-01  2.38E-02
 
 OM44
+       -1.72E-02 -3.30E-03  1.17E-01  5.06E-02  1.53E-02  7.87E-03  3.73E-03  3.51E-03  9.48E-03  4.34E-02  3.73E-02  1.71E-01
         -2.03E-02  9.64E-03 -5.41E-02  3.03E-02  8.58E-02  4.68E-02  3.76E-01 -6.24E-02  2.98E-02 -1.31E-01  8.06E-02 -3.22E-02
         1.49E-01 -4.44E-02  1.50E-02 -5.54E-02  3.36E-02  5.24E-02
 
 OM45
+       -4.45E-03 -4.26E-04 -5.04E-04 -8.36E-03  1.70E-03  1.91E-02  7.77E-03  4.23E-03  2.82E-02  4.41E-02  1.42E-02  1.29E-01
          9.51E-02 -2.23E-02 -2.45E-02  4.50E-02  5.63E-02 -5.94E-03  7.25E-02  2.70E-01 -6.74E-02  1.66E-02  5.59E-02 -6.06E-03
        -2.23E-02  7.15E-02 -1.67E-02  1.26E-02 -1.53E-03 -2.15E-01  2.95E-02
 
 OM46
+        2.12E-03 -1.26E-02 -1.24E-02 -4.96E-03  2.35E-02  4.65E-02  1.84E-02  1.38E-02 -2.68E-02 -1.41E-03  1.54E-02 -5.54E-02
         -1.80E-02  9.47E-02  4.18E-02 -2.61E-02 -2.20E-02 -2.05E-03 -1.36E-02 -6.88E-02  2.89E-01  2.76E-02 -5.31E-02  6.79E-03
         7.60E-02 -3.66E-02  4.81E-02 -3.32E-02  2.75E-02  1.36E-01 -3.48E-01  3.49E-02
 
1

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM13      OM14  
             OM15      OM16      OM17      OM18      OM22      OM23      OM24      OM25      OM26      OM27      OM28      OM33  
            OM34      OM35      OM36      OM37      OM38      OM44      OM45      OM46      OM47      OM48      OM55      OM56  
             OM57      OM58      OM66      OM67      OM68      OM77      OM78      OM88      SG11      SG12      SG22  
 
 OM47
+        8.14E-03  7.50E-03 -4.94E-02 -2.86E-02  3.12E-03  1.63E-02  4.47E-03  5.28E-03  1.78E-02  6.85E-03 -2.18E-03  7.66E-02
          4.78E-03  2.08E-02  8.10E-02  5.88E-02 -1.26E-01 -2.72E-03 -3.60E-01  9.99E-02 -1.29E-02  3.36E-01  6.07E-03  1.71E-02
         7.34E-02 -8.14E-03  5.87E-03  1.35E-02  2.56E-02 -4.56E-01  2.30E-01  3.33E-02  3.52E-02
 
 OM48
+       -1.60E-02  2.84E-02  1.30E-02 -1.72E-02  1.22E-02  1.42E-02  1.21E-02 -4.67E-03  6.65E-02  1.49E-01  8.72E-02  4.21E-01
         -4.19E-02  2.02E-02 -9.68E-02  1.97E-01  1.21E-01  1.19E-01  3.75E-01 -2.56E-02 -3.08E-02 -3.71E-02  3.27E-01  6.61E-02
         3.48E-01 -6.29E-02  2.54E-02 -1.12E-01  1.40E-01  2.73E-01  5.35E-02 -1.95E-01  1.56E-01  3.21E-02
 
 OM55
+        3.60E-03 -6.40E-03 -1.11E-02 -1.46E-03 -3.13E-02 -1.87E-02 -2.85E-03 -6.87E-03  1.18E-02  1.97E-02  3.49E-03 -3.56E-02
          1.92E-01 -6.34E-02  4.64E-02  2.37E-02  3.77E-02 -1.11E-02 -2.13E-02  1.95E-01 -9.25E-02  1.03E-02 -2.29E-03  2.11E-02
        -2.88E-03 -1.95E-02  2.60E-02  1.51E-02  1.88E-02  1.60E-02 -2.22E-01  7.68E-02 -3.83E-02 -1.89E-02  3.39E-02
 
 OM56
+        3.16E-03 -6.40E-03 -8.91E-03  8.84E-04 -1.49E-02 -9.55E-03 -8.36E-03 -1.21E-03 -3.84E-03  2.52E-03  1.58E-02  2.78E-02
         -9.22E-02  1.48E-01 -1.98E-02 -4.15E-02 -8.98E-03  1.80E-02  1.71E-02 -1.02E-01  1.59E-01  1.29E-02 -8.27E-03 -2.64E-03
        -1.26E-02  1.17E-01 -7.46E-02 -5.89E-03 -1.53E-02 -1.94E-02  1.29E-01 -1.88E-01 -6.63E-03  3.03E-02 -4.73E-01  3.11E-02
 
 OM57
+        4.51E-03 -7.41E-03 -1.92E-02  2.37E-03 -7.59E-03 -6.02E-03 -1.69E-02 -1.34E-02  2.55E-02 -1.28E-02 -9.42E-04 -7.30E-02
          1.59E-01 -4.76E-02  1.58E-01  2.84E-02 -5.06E-02  2.53E-02  1.59E-03 -2.83E-01  1.21E-01  5.27E-02  4.63E-03 -2.84E-02
        -2.80E-02  1.48E-01 -6.92E-02  6.87E-03 -3.11E-02  6.84E-02 -3.65E-01  8.83E-02 -2.11E-01 -8.01E-02  2.50E-01  1.75E-02
          2.78E-02
 
 OM58
+       -5.76E-03 -4.39E-03 -1.81E-02 -2.77E-03 -1.62E-03  2.32E-02 -3.66E-03 -9.03E-03  8.12E-02  1.06E-01  2.73E-02 -3.14E-02
          4.18E-01 -1.77E-01  1.05E-01  1.57E-01  5.87E-02  4.47E-02 -2.94E-02  3.70E-01 -1.26E-01  9.13E-02  1.53E-01 -2.48E-03
        -6.61E-02  3.46E-01 -1.38E-01  3.36E-02  4.41E-03 -4.60E-02  1.95E-01 -3.26E-02 -1.12E-03 -1.36E-01  9.90E-02 -2.06E-01
          2.61E-01  2.59E-02
 
 OM66
+        4.39E-03 -9.25E-03 -1.69E-02 -2.14E-03  3.71E-02 -1.27E-02  3.59E-03  4.98E-03  6.01E-03 -2.17E-03 -2.80E-02 -1.96E-02
          2.79E-02 -7.25E-02  8.75E-03  1.62E-02  2.55E-03 -1.93E-02  7.75E-03  3.11E-02 -6.01E-02 -1.35E-02  4.98E-03 -5.12E-03
        -5.87E-03 -5.13E-02  1.41E-01  2.04E-03 -3.63E-02 -8.11E-03 -4.13E-02  1.02E-01  9.51E-03 -3.23E-02  1.15E-01 -4.91E-01
         -3.34E-02  8.67E-02  4.86E-02
 
 OM67
+       -9.41E-04 -5.21E-02  4.26E-03  1.56E-02 -2.21E-03 -3.83E-02 -5.13E-03  4.90E-03 -2.28E-03 -3.22E-03 -5.30E-03  3.16E-02
         -7.28E-02  1.53E-01 -6.37E-02 -5.41E-02  3.57E-02 -3.89E-02  7.84E-03  1.01E-01 -3.15E-01 -6.51E-02  4.41E-02  1.17E-02
        -1.79E-02 -5.30E-02  1.28E-01  1.01E-01 -2.02E-03 -4.21E-02  1.09E-01 -3.44E-01  5.94E-02  8.55E-02 -7.40E-02  1.65E-01
         -3.32E-01 -1.53E-01  7.47E-02  3.28E-02
 
 OM68
+       -4.41E-03 -4.20E-02  2.68E-02  1.28E-02  2.18E-02  1.12E-03  1.25E-02  8.74E-03 -4.60E-02 -6.05E-02  2.49E-02  2.14E-02
         -1.54E-01  4.03E-01  9.61E-03 -1.43E-01 -2.07E-03  3.81E-02  4.66E-02 -9.78E-02  3.39E-01 -1.57E-02 -1.16E-01  8.41E-04
         5.83E-02 -1.31E-01  3.15E-01  5.58E-02  4.43E-02  2.73E-02 -6.36E-02  1.70E-01  2.52E-02  4.26E-02 -2.11E-02  1.02E-01
         -1.07E-01 -3.81E-01 -2.94E-01  2.32E-01  3.14E-02
 
 OM77
+       -2.16E-03 -4.30E-02  1.18E-02  1.31E-02  4.39E-04  5.18E-03 -1.50E-02 -4.97E-03  1.22E-02 -5.61E-02  2.81E-02 -6.08E-02
          2.22E-02  1.12E-02  1.67E-01  2.40E-02  9.58E-02 -4.92E-02  1.63E-01 -8.75E-02 -2.05E-02 -4.03E-01 -1.03E-01  6.10E-03
        -5.00E-02  1.98E-02  1.13E-02  2.02E-01  4.43E-02  1.20E-01 -9.65E-02 -3.06E-02 -4.63E-01 -1.26E-01  3.91E-02  8.68E-03
          2.58E-01  4.99E-02  3.54E-03  7.90E-02  3.77E-02  4.38E-02
 
1

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM13      OM14  
             OM15      OM16      OM17      OM18      OM22      OM23      OM24      OM25      OM26      OM27      OM28      OM33  
            OM34      OM35      OM36      OM37      OM38      OM44      OM45      OM46      OM47      OM48      OM55      OM56  
             OM57      OM58      OM66      OM67      OM68      OM77      OM78      OM88      SG11      SG12      SG22  
 
 OM78
+       -5.02E-04 -5.47E-02  7.18E-03  1.51E-02  4.62E-03  1.24E-02 -1.28E-02 -4.17E-03  5.19E-02 -7.83E-02  9.30E-02 -1.08E-01
          6.24E-02 -8.80E-03  3.97E-01  1.82E-01 -1.31E-01 -3.87E-02 -1.43E-01  4.80E-02  8.66E-02  2.06E-01 -2.04E-01  3.48E-02
        -6.89E-02  3.61E-02  5.27E-03  3.56E-01  1.76E-01 -9.04E-02  2.73E-03  8.12E-02  1.03E-01 -2.82E-01  2.90E-02 -5.93E-02
          1.02E-01  1.64E-01 -1.27E-02 -1.79E-01  4.86E-02  3.50E-01  3.05E-02
 
 OM88
+       -1.77E-02 -1.54E-02  1.78E-02  1.87E-03  2.09E-02  2.04E-02  7.21E-03 -5.00E-03  1.54E-01  1.84E-01  1.98E-01  1.19E-01
          3.60E-02 -1.16E-01  1.28E-01  5.13E-01  1.10E-01  1.77E-01  1.10E-01  6.33E-02 -1.03E-01  9.68E-02  4.60E-01  1.15E-01
         1.08E-01  1.60E-02 -8.44E-02  9.90E-02  4.32E-01  4.49E-02  2.45E-02 -5.78E-02  6.71E-02  2.96E-01  7.52E-03 -5.79E-02
         -1.15E-02  9.61E-02  4.51E-02 -6.53E-02 -2.46E-01  5.88E-02  3.43E-01  3.97E-02
 
 SG11
+        4.15E-03 -2.23E-02 -1.70E-03 -3.69E-03  1.52E-02  2.40E-02  9.63E-03  8.14E-03 -1.96E-03  2.11E-02 -2.79E-02 -7.65E-03
          1.84E-03  1.12E-02 -2.25E-03 -6.05E-03 -4.85E-02 -5.74E-02 -2.41E-03 -4.27E-07  1.29E-02  6.01E-03 -2.86E-03 -7.35E-02
        -4.91E-02 -4.22E-03  2.96E-03  4.43E-03 -2.53E-02 -3.95E-02  5.29E-03  1.14E-02  2.90E-04 -2.57E-02 -1.17E-02  9.49E-03
          6.18E-03  6.17E-03 -2.93E-04 -4.96E-03  3.66E-03 -1.08E-02 -4.90E-03 -2.12E-02  6.56E-04
 
 SG12
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
        ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG22
+        1.26E-02 -3.32E-03 -2.74E-02 -5.11E-03 -8.54E-03 -5.25E-03 -1.81E-04  1.55E-03 -7.71E-03 -7.61E-03  1.55E-02 -4.75E-04
          4.60E-03 -1.95E-02  5.13E-03  1.17E-02 -1.57E-03 -1.45E-02 -9.79E-03  3.08E-03  3.64E-03  1.01E-02 -1.90E-03 -1.15E-02
         1.87E-03 -2.59E-02  2.98E-02  1.21E-02 -1.34E-02 -4.08E-04 -2.09E-03  1.79E-02  7.82E-03  4.60E-03 -3.10E-03 -8.53E-03
         -1.26E-03 -8.75E-03 -4.07E-02 -1.46E-02  4.11E-03 -1.11E-03  9.84E-04 -1.19E-02 -2.32E-02  0.00E+00  1.20E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (R)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM13      OM14  
             OM15      OM16      OM17      OM18      OM22      OM23      OM24      OM25      OM26      OM27      OM28      OM33  
            OM34      OM35      OM36      OM37      OM38      OM44      OM45      OM46      OM47      OM48      OM55      OM56  
             OM57      OM58      OM66      OM67      OM68      OM77      OM78      OM88      SG11      SG12      SG22  
 
 TH 1
+        3.25E+02
 
 TH 2
+        1.90E+02  4.63E+02
 
 TH 3
+       -8.07E-01  9.57E+01  5.09E+02
 
 TH 4
+       -2.58E+01 -2.47E+01  7.86E+00  2.65E+02
 
 TH 5
+       -1.06E+02 -1.54E+02 -3.21E+01  2.39E+01  4.13E+02
 
 TH 6
+       -4.78E+01 -9.98E+01 -8.64E+01 -4.42E+01  1.41E+02  3.00E+02
 
 TH 7
+        8.17E+01  2.10E+02  3.37E+01  1.11E+02 -1.31E+02 -1.15E+02  4.11E+02
 
 TH 8
+       -2.43E+02 -3.51E+02 -1.97E+02 -8.49E+01  1.47E+02  1.87E+02 -2.79E+02  6.83E+02
 
 OM11
+       -4.64E+01 -6.70E+01 -3.06E+01  5.09E+00  3.61E+01  2.89E+01 -2.62E+01  7.02E+01  1.11E+03
 
 OM12
+       -1.37E+02 -2.66E+02 -1.52E+02  1.12E+01  1.55E+02  1.44E+02 -1.14E+02  2.79E+02  1.58E+03  5.34E+03
 
 OM13
+       -5.55E+01 -1.65E+02 -1.62E+02 -1.16E+01  8.57E+01  9.21E+01 -7.72E+01  1.78E+02  1.02E+02  1.04E+03  3.15E+03
 
 OM14
+        3.66E+01  7.88E+01  3.34E+01 -2.12E+01 -2.04E+01 -2.34E+00  2.11E+01 -5.85E+01 -2.38E+02 -5.11E+02 -3.06E+01  1.86E+03
 
 OM15
+        1.20E+02  2.13E+02  8.97E+01 -9.91E+00 -1.78E+02 -1.35E+02  1.02E+02 -2.25E+02 -8.70E+02 -2.15E+03 -4.30E+02  3.59E+02
          3.59E+03
 
 OM16
+        6.13E+01  1.15E+02  7.82E+01  8.90E+00 -9.25E+01 -1.01E+02  6.69E+01 -1.34E+02 -5.36E+02 -1.64E+03 -5.62E+02 -1.10E+02
          1.57E+03  2.46E+03
 
 OM17
+       -1.29E+02 -2.93E+02 -1.16E+02  2.73E+00  1.46E+02  1.34E+02 -1.54E+02  2.80E+02  6.62E+02  2.34E+03  5.17E+02  6.74E+02
         -1.44E+03 -1.29E+03  3.11E+03
 
 OM18
+        1.25E+02  2.53E+02  1.66E+02  3.51E+00 -1.20E+02 -1.25E+02  1.17E+02 -2.77E+02 -1.81E+03 -4.52E+03 -1.41E+03 -1.68E+02
          2.15E+03  2.13E+03 -2.78E+03  6.48E+03
 
 OM22
+       -9.22E+01 -2.36E+02 -1.65E+02  5.51E-01  1.54E+02  1.71E+02 -1.09E+02  2.63E+02  7.71E+02  3.44E+03  7.02E+02 -3.95E+02
         -1.33E+03 -1.09E+03  1.50E+03 -2.79E+03  3.83E+03
 
 OM23
+       -1.33E+02 -3.60E+02 -2.49E+02  7.33E+00  1.94E+02  2.04E+02 -1.62E+02  3.67E+02  1.20E+02  8.36E+02  1.45E+03 -2.60E+02
         -3.96E+02 -2.88E+02  3.49E+02 -6.24E+02  1.44E+03  4.16E+03
 
1

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM13      OM14  
             OM15      OM16      OM17      OM18      OM22      OM23      OM24      OM25      OM26      OM27      OM28      OM33  
            OM34      OM35      OM36      OM37      OM38      OM44      OM45      OM46      OM47      OM48      OM55      OM56  
             OM57      OM58      OM66      OM67      OM68      OM77      OM78      OM88      SG11      SG12      SG22  
 
 OM24
+        7.59E+01  1.42E+02 -4.08E+00 -4.22E+01 -4.54E+01 -4.38E+00  4.47E+01 -1.02E+02 -1.94E+02 -8.47E+02 -3.34E+02  1.28E+03
          4.26E+02  1.56E+02  3.21E+02  3.47E+02 -9.78E+02 -7.11E+02  3.15E+03
 
 OM25
+        1.91E+02  4.27E+02  2.08E+02 -1.43E+01 -3.01E+02 -2.61E+02  1.97E+02 -4.48E+02 -7.49E+02 -3.05E+03 -7.45E+02  3.61E+02
          3.20E+03  1.78E+03 -1.76E+03  2.72E+03 -3.02E+03 -1.32E+03  8.71E+02  7.08E+03
 
 OM26
+        1.08E+02  2.68E+02  1.63E+02  6.20E+00 -1.72E+02 -2.14E+02  1.41E+02 -2.97E+02 -5.56E+02 -2.24E+03 -5.45E+02  6.90E+01
          1.66E+03  2.12E+03 -1.42E+03  2.31E+03 -2.25E+03 -1.18E+03  2.35E+02  3.65E+03  4.68E+03
 
 OM27
+       -2.60E+02 -6.23E+02 -2.43E+02  1.85E+01  3.23E+02  3.05E+02 -3.15E+02  6.00E+02  6.65E+02  2.98E+03  5.92E+02  3.51E+02
         -1.58E+03 -1.37E+03  2.66E+03 -3.01E+03  3.32E+03  1.04E+03  8.66E+02 -3.59E+03 -2.92E+03  6.31E+03
 
 OM28
+        2.10E+02  5.38E+02  3.46E+02  4.80E+00 -2.90E+02 -3.30E+02  2.63E+02 -5.93E+02 -1.55E+03 -6.33E+03 -1.38E+03  3.11E+02
          2.60E+03  2.40E+03 -3.33E+03  6.44E+03 -6.03E+03 -2.38E+03  5.87E+02  5.22E+03  4.64E+03 -6.63E+03  1.31E+04
 
 OM33
+       -4.94E+01 -7.64E+01  8.96E+01  4.50E+01  4.17E+01  6.61E+00 -1.44E+01  2.72E+01 -4.39E+01 -2.04E+02 -2.92E+02 -9.89E+01
          8.28E+01  8.70E+01 -1.23E+02  4.23E+02 -8.55E+01  6.66E+02 -9.11E+01  8.54E+01 -6.58E+01 -1.49E+02  1.41E+02  2.31E+03
 
 OM34
+        3.70E+01  2.02E+00 -1.42E+02 -3.94E+01 -1.41E+01  2.88E+01 -8.06E+00  2.94E+01 -2.58E+01 -2.94E+02 -5.32E+02  1.84E+02
          6.70E+01  1.38E+02  7.30E+01  2.73E+02 -3.87E+02 -5.47E+02  7.95E+02  3.39E+02  2.07E+02  2.07E+02  3.38E+02  2.49E+02
         2.54E+03
 
 OM35
+        6.08E+01  1.88E+02  1.51E+02 -1.26E+00 -8.81E+01 -9.48E+01  8.28E+01 -1.80E+02 -2.46E+01 -4.00E+02 -1.08E+03 -2.15E+01
          4.55E+02  3.68E+02 -3.50E+02  4.99E+02 -6.28E+02 -1.65E+03  1.94E+02  1.71E+03  1.05E+03 -8.84E+02  1.15E+03 -2.87E+02
         4.77E+02  4.39E+03
 
 OM36
+        4.40E+01  1.17E+02  5.49E+01 -1.14E+01 -4.36E+01 -3.87E+01  4.81E+01 -1.01E+02  6.53E+01 -5.00E+01 -5.21E+02 -1.51E+01
          1.82E+02  2.34E+02 -1.62E+02 -2.10E+01 -2.17E+02 -1.01E+03  4.64E+01  6.96E+02  1.04E+03 -4.54E+02  5.04E+02 -8.08E+02
        -3.93E+02  1.73E+03  3.38E+03
 
 OM37
+       -1.07E+02 -2.55E+02 -9.34E+01  3.12E+01  1.39E+02  1.15E+02 -1.06E+02  2.22E+02  9.23E+01  3.83E+02  6.16E+02  1.02E+02
         -2.85E+02 -2.01E+02  3.47E+02 -5.00E+02  5.77E+02  1.66E+03  2.25E+02 -8.49E+02 -7.14E+02  1.32E+03 -1.37E+03  3.17E+02
         9.52E+02 -1.29E+03 -1.13E+03  3.84E+03
 
 OM38
+        1.27E+02  3.20E+02  1.80E+02 -9.17E+00 -1.57E+02 -1.58E+02  1.46E+02 -3.06E+02 -3.27E+01 -7.21E+02 -1.86E+03  9.35E+01
          3.99E+02  3.33E+02 -5.35E+02  5.94E+02 -9.19E+02 -2.85E+03  2.63E+02  1.01E+03  9.99E+02 -1.08E+03  2.22E+03 -1.82E+03
        -7.09E+02  1.53E+03  2.16E+03 -2.24E+03  6.43E+03
 
 OM44
+        6.02E+00 -9.89E+00 -6.08E+01 -1.84E+01 -7.42E+00  4.93E+00 -7.57E+00  2.34E+01  1.73E+01  5.81E+01  1.19E+01 -1.91E+02
         -3.52E+01  1.28E+01 -6.93E+01  1.35E+01  6.63E+01  6.85E+01 -2.35E+02 -5.27E+01 -4.33E+00 -6.39E+01 -5.29E+01  8.59E+01
        -4.66E+01 -6.38E-01 -2.73E+01  1.75E+00 -8.08E+01  6.65E+02
 
 OM45
+       -2.53E+01 -5.53E+01 -1.47E+01  1.59E+01  2.20E+01 -2.51E+00 -1.87E+01  3.98E+01  1.42E+02  4.35E+02  1.04E+02 -7.03E+02
         -5.04E+02 -1.76E+02 -1.24E+02 -2.28E+02  4.22E+02  3.41E+02 -1.12E+03 -7.44E+02 -3.11E+02 -1.85E+02 -4.51E+02  8.65E+01
        -2.89E+02 -1.19E+02 -5.60E+01 -6.40E+01 -1.58E+02  1.55E+02  2.42E+03
 
 OM46
+       -1.06E+01 -9.70E+00  4.57E+01  2.23E+01  1.56E+00 -2.37E+01  1.37E+00 -1.50E+01  1.13E+02  3.62E+02  1.43E+02 -3.46E+02
         -2.93E+02 -3.19E+02 -1.34E+01 -3.43E+02  4.04E+02  3.38E+02 -7.08E+02 -5.18E+02 -5.03E+02 -1.43E+01 -5.95E+02 -3.56E+01
        -4.68E+02 -1.31E+02  3.45E+01 -8.97E+01 -7.07E+01 -2.10E+02  8.98E+02  1.72E+03
 
1

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM13      OM14  
             OM15      OM16      OM17      OM18      OM22      OM23      OM24      OM25      OM26      OM27      OM28      OM33  
            OM34      OM35      OM36      OM37      OM38      OM44      OM45      OM46      OM47      OM48      OM55      OM56  
             OM57      OM58      OM66      OM67      OM68      OM77      OM78      OM88      SG11      SG12      SG22  
 
 OM47
+        4.45E+01  9.01E+01 -2.33E+00 -1.50E+01 -4.39E+01 -2.63E+01  4.52E+01 -7.67E+01 -7.42E+01 -3.13E+02 -6.16E+01  4.14E+02
          2.30E+02  1.16E+02 -8.68E+01  1.80E+02 -3.53E+02 -2.27E+02  1.20E+03  4.29E+02  1.66E+02  1.43E+02  2.49E+02  2.41E+01
         2.53E+02  6.74E+01  2.83E+01  9.18E+01  6.77E+01  5.18E+02 -7.65E+02 -7.84E+02  2.43E+03
 
 OM48
+       -7.19E+01 -1.19E+02  6.20E+01  6.39E+01  4.01E+01 -1.69E+01 -3.11E+01  6.62E+01  2.45E+02  7.93E+02  3.00E+02 -1.47E+03
         -4.64E+02 -1.87E+02 -3.97E+02 -4.69E+02  8.27E+02  5.81E+02 -2.33E+03 -7.67E+02 -3.46E+02 -5.30E+02 -8.46E+02 -1.26E+02
        -1.27E+03 -1.67E+02  1.62E+02 -4.61E+02  1.60E+02 -3.12E+02  1.01E+03  1.24E+03 -1.72E+03  4.17E+03
 
 OM55
+       -7.97E+01 -1.52E+02 -5.65E+01  6.57E+00  1.39E+02  1.05E+02 -7.95E+01  1.62E+02  2.23E+02  7.09E+02  2.24E+02 -9.78E+01
         -1.38E+03 -6.79E+02  5.66E+02 -7.62E+02  6.16E+02  3.54E+02 -1.98E+02 -2.30E+03 -1.15E+03  9.78E+02 -1.22E+03 -2.46E+01
        -4.79E+01 -6.52E+02 -3.32E+02  3.17E+02 -3.80E+02  3.11E+01  3.27E+02  1.53E+02 -1.08E+02  1.64E+02  2.18E+03
 
 OM56
+       -8.68E+01 -1.83E+02 -8.06E+01  2.55E+00  1.36E+02  1.41E+02 -9.43E+01  1.97E+02  3.32E+02  1.24E+03  3.95E+02 -3.61E+01
         -1.56E+03 -1.56E+03  9.50E+02 -1.48E+03  1.18E+03  6.36E+02 -2.09E+02 -2.94E+03 -2.71E+03  1.72E+03 -2.58E+03  1.85E+01
        -1.33E+02 -1.34E+03 -8.28E+02  6.09E+02 -6.82E+02  1.93E+01 -6.99E+01  2.49E+02 -4.27E+01  2.11E+02  1.92E+03  4.20E+03
 
 OM57
+        1.53E+02  3.62E+02  1.42E+02 -1.56E+01 -2.08E+02 -1.70E+02  1.83E+02 -3.42E+02 -3.31E+02 -1.34E+03 -3.62E+02 -1.96E+02
          1.58E+03  9.74E+02 -1.51E+03  1.46E+03 -1.30E+03 -5.52E+02 -2.21E+02  3.49E+03  1.94E+03 -2.76E+03  2.70E+03  9.41E+01
        -8.20E+01  8.86E+02  4.75E+02 -7.22E+02  6.76E+02  4.15E+01  8.18E+02  2.28E+02 -5.90E+01  1.96E+02 -1.69E+03 -2.31E+03
          4.59E+03
 
 OM58
+       -1.63E+02 -3.82E+02 -1.95E+02  6.79E+00  2.44E+02  2.17E+02 -1.84E+02  4.03E+02  8.03E+02  2.80E+03  8.61E+02 -1.42E+02
         -3.55E+03 -2.09E+03  1.99E+03 -3.32E+03  2.49E+03  1.11E+03 -4.00E+02 -5.92E+03 -3.52E+03  3.44E+03 -5.52E+03 -6.92E+01
        -2.00E+02 -2.46E+03 -1.03E+03  1.09E+03 -1.27E+03  6.00E+00 -2.24E+02  2.02E+02 -1.27E+02  5.33E+02  2.26E+03  3.71E+03
         -4.01E+03  8.51E+03
 
 OM66
+       -2.52E+01 -5.89E+01 -2.72E+01 -2.07E+00  2.25E+01  4.85E+01 -3.09E+01  6.47E+01  1.14E+02  4.75E+02  1.72E+02 -7.56E+00
         -5.05E+02 -6.40E+02  3.53E+02 -5.39E+02  4.55E+02  2.63E+02 -8.36E+01 -9.95E+02 -1.19E+03  6.63E+02 -1.00E+03  9.96E+01
         1.44E+01 -5.01E+02 -6.83E+02  2.96E+02 -4.24E+02  4.11E+01 -2.66E+01 -1.11E+02  3.21E+01 -1.77E+01  5.33E+02  1.48E+03
         -7.43E+02  1.30E+03  1.12E+03
 
 OM67
+        1.10E+02  2.70E+02  1.07E+02 -1.58E+01 -1.23E+02 -1.22E+02  1.32E+02 -2.50E+02 -2.73E+02 -1.05E+03 -2.62E+02 -1.64E+02
          8.81E+02  1.03E+03 -1.02E+03  1.23E+03 -1.03E+03 -4.88E+02 -2.91E+02  1.93E+03  2.34E+03 -2.11E+03  2.43E+03 -5.76E+01
        -1.66E+02  7.21E+02  6.80E+02 -8.98E+02  6.92E+02 -1.01E+02  4.01E+02  6.35E+02 -5.30E+02  5.52E+02 -8.64E+02 -2.04E+03
          2.15E+03 -2.38E+03 -1.03E+03  3.22E+03
 
 OM68
+       -8.08E+01 -2.20E+02 -1.58E+02 -1.93E+01  1.07E+02  1.64E+02 -1.27E+02  2.51E+02  5.23E+02  2.03E+03  6.02E+02  9.30E+01
         -1.78E+03 -2.41E+03  1.57E+03 -2.43E+03  1.79E+03  7.98E+02 -6.31E+01 -3.23E+03 -3.96E+03  2.67E+03 -4.28E+03  3.40E+02
         1.50E+02 -1.31E+03 -1.85E+03  9.51E+02 -1.73E+03  1.16E+02 -4.55E+01 -2.55E+02  1.89E+02 -4.23E+02  1.21E+03  3.01E+03
         -2.15E+03  4.41E+03  1.71E+03 -2.90E+03  6.08E+03
 
 OM77
+       -9.36E+01 -2.23E+02 -7.36E+01  1.42E+01  1.02E+02  8.59E+01 -1.07E+02  2.02E+02  1.42E+02  6.66E+02  1.53E+02  1.94E+02
         -4.22E+02 -3.80E+02  8.39E+02 -7.75E+02  7.62E+02  2.08E+02  5.20E+02 -9.97E+02 -8.48E+02  2.14E+03 -1.80E+03 -3.30E+01
         1.27E+02 -2.73E+02 -1.55E+02  4.14E+02 -3.28E+02  1.03E+02 -3.26E+02 -2.57E+02  8.93E+02 -6.39E+02  3.63E+02  6.47E+02
         -1.37E+03  1.19E+03  2.61E+02 -1.17E+03  9.97E+02  1.81E+03
 
1

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM13      OM14  
             OM15      OM16      OM17      OM18      OM22      OM23      OM24      OM25      OM26      OM27      OM28      OM33  
            OM34      OM35      OM36      OM37      OM38      OM44      OM45      OM46      OM47      OM48      OM55      OM56  
             OM57      OM58      OM66      OM67      OM68      OM77      OM78      OM88      SG11      SG12      SG22  
 
 OM78
+        2.35E+02  5.92E+02  2.37E+02 -1.84E+01 -2.72E+02 -2.61E+02  3.03E+02 -5.57E+02 -6.64E+02 -2.80E+03 -7.29E+02 -6.62E+02
          1.62E+03  1.57E+03 -3.09E+03  3.52E+03 -2.64E+03 -9.80E+02 -1.06E+03  3.08E+03  2.82E+03 -5.47E+03  6.82E+03  4.35E+01
        -5.90E+02  1.06E+03  7.15E+02 -2.08E+03  1.66E+03 -1.62E+02  4.76E+02  4.66E+02 -1.17E+03  1.90E+03 -9.86E+02 -1.97E+03
          2.82E+03 -4.07E+03 -8.59E+02  2.88E+03 -3.73E+03 -2.65E+03  8.32E+03
 
 OM88
+       -8.47E+01 -2.45E+02 -1.80E+02 -1.64E+01  9.57E+01  1.32E+02 -1.30E+02  2.75E+02  7.90E+02  2.79E+03  7.97E+02  1.92E+02
         -1.30E+03 -1.37E+03  1.91E+03 -3.87E+03  2.36E+03  8.19E+02  8.41E+01 -2.32E+03 -2.20E+03  3.12E+03 -6.20E+03  1.08E+02
         2.28E+02 -6.17E+02 -5.45E+02  9.72E+02 -1.99E+03  1.04E+02  5.29E+01  2.19E+01  2.48E+02 -6.76E+02  6.69E+02  1.47E+03
         -1.41E+03  3.04E+03  6.40E+02 -1.51E+03  3.01E+03  1.07E+03 -4.60E+03  4.78E+03
 
 SG11
+        1.08E+02 -8.38E+01 -5.13E+02  1.05E+02 -2.91E+02 -1.96E+02  6.39E+01  1.29E+01  1.60E+03  8.45E+03  4.03E+03 -2.02E+03
         -3.64E+03 -3.80E+03  3.22E+03 -7.25E+03  1.23E+04  1.20E+04 -4.45E+03 -9.57E+03 -8.73E+03  8.78E+03 -1.95E+04  6.93E+03
         1.28E+03 -3.70E+03 -4.68E+03  4.87E+03 -1.16E+04  2.18E+03  1.79E+03  5.84E+02  3.28E+02  2.27E+03  2.46E+03  4.15E+03
         -4.11E+03  7.77E+03  2.18E+03 -3.91E+03  7.94E+03  2.62E+03 -8.07E+03  8.93E+03  2.42E+06
 
 SG12
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
        ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG22
+       -2.74E+02 -2.82E+01  5.47E+02  9.04E+01  2.38E+02  1.11E+02 -1.47E+01 -2.69E+00  1.29E+03  2.83E+03 -7.48E+02 -1.17E+00
         -2.10E+03 -1.02E+03  1.30E+03 -3.32E+03  1.80E+03  2.97E+02 -1.81E+00 -2.98E+03 -2.52E+03  1.59E+03 -4.27E+03  9.73E+02
         1.42E+02  1.64E+02 -1.93E+03 -1.74E+02 -4.56E+02  8.70E+01 -1.01E+02 -6.15E+02  4.60E+01 -4.50E+02  1.54E+03  3.11E+03
         -1.70E+03  3.82E+03  2.15E+03 -1.63E+03  3.69E+03  3.75E+02 -2.32E+03  2.93E+03  3.75E+04  0.00E+00  7.00E+05
 
 Elapsed postprocess time in seconds:     0.00
 Elapsed finaloutput time in seconds:     0.00
 #CPUT: Total CPU Time in Seconds,      241.209
Stop Time: 
Tue 03/12/2019 
10:58 AM
