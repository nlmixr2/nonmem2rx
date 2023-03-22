Tue 03/12/2019 
10:25 AM
$PROB  wexample10 (from F_FLAG04est2a.ctl)
$INPUT C ID DOSE=AMT TIME DV WT TYPE
$DATA wexample10.csv IGNORE=@

$SUBROUTINES  ADVAN2 TRANS2

$PK
   MU_1=THETA(1)
   KA=EXP(MU_1+ETA(1))
   MU_2=THETA(2)
   V=EXP(MU_2+ETA(2))
   MU_3=THETA(3)
   CL=EXP(MU_3+ETA(3))
   S2=V/1000

$THETA  
1.6 ; [LN(KA)]
2.3 ; [LN(V)]
0.7 ; [LN(CL)]
0.1 ; [INTRCEPT]
0.1 ; [SLOPE]

$OMEGA BLOCK(3) VALUES(0.5,0.01) ;[P]
; Priors to Omegas
$PRIOR NWPRI
$OMEGAP BLOCK(3) FIXED VALUES(0.09,0.0)
$OMEGAPD (3 FIX)

;Because THETA(4) and THETA(5) have no inter-subject variability associated with them, the
; algorithm must use a more computationally expensive gradient evaluation for these two parameters

$SIGMA
0.1; [P]

$ERROR
IPRED=A(2)/S2
    EXPP=THETA(4)+IPRED*THETA(5)
; Put a limit on this, as it will be exponentiated, to avoid floating overflow
    IF(EXPP.GT.40.0) EXPP=40.0
IF (TYPE.EQ.0) THEN
; PK Data
    F_FLAG=0
    Y=IPRED+IPRED*ERR(1) ; a prediction
 ELSE
; Categorical data
    F_FLAG=1
; IF EXPP>40, then A>1.0d+17, A/B=1, and Y=DV
    AA=EXP(EXPP)
    B=1+AA
    Y=DV*AA/B+(1-DV)/B      ; a likelihood
 ENDIF

; NOPRIOR=1 can turn off incorporation of prior information for a particular method, 
; and turned back on (NOPRIOR=0) for others.  Prior information is not needed for ITS, but is needed for BAYES
; Raw output content can be routed to specific files for each $EST record, with the FILE= option
$EST METHOD=ITS INTER LAP AUTO=1 PRINT=5 SIGL=6 NOPRIOR=1 FILE=wexample10_its.ext
$EST METHOD=BAYES AUTO=1 NOPRIOR=0 PRINT=100
     FILE=wexample10_bayes.ext

$COV UNCONDITIONAL PRINT=E MATRIX=R SIGL=10
$TABLE ID DOSE WT TIME TYPE DV AA NOPRINT FILE=wexample10_bayes.tab
  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
             
 (WARNING  3) THERE MAY BE AN ERROR IN THE ABBREVIATED CODE. THE FOLLOWING
 ONE OR MORE RANDOM VARIABLES ARE DEFINED WITH "IF" STATEMENTS THAT DO NOT
 PROVIDE DEFINITIONS FOR BOTH THE "THEN" AND "ELSE" CASES. IF ALL
 CONDITIONS FAIL, THE VALUES OF THESE VARIABLES WILL BE ZERO.
  
   AA B

             
 (WARNING  87) WITH "LAPLACIAN" AND "INTERACTION", "NUMERICAL" AND "SLOW"
 ARE ALSO REQUIRED ON $ESTIM RECORD, AND "SLOW" IS REQUIRED ON $COV
 RECORD. NM-TRAN HAS SUPPLIED THESE OPTIONS.
             
 (WARNING  87) WITH "LAPLACIAN" AND "INTERACTION", "NUMERICAL" AND "SLOW"
 ARE ALSO REQUIRED ON $ESTIM RECORD, AND "SLOW" IS REQUIRED ON $COV
 RECORD. NM-TRAN HAS SUPPLIED THESE OPTIONS.
  
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
 wexample10 (from F_FLAG04est2a.ctl)
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:     4608
 NO. OF DATA ITEMS IN DATA SET:   9
 ID DATA ITEM IS DATA ITEM NO.:   2
 DEP VARIABLE IS DATA ITEM NO.:   5
 MDV DATA ITEM IS DATA ITEM NO.:  9
0INDICES PASSED TO SUBROUTINE PRED:
   8   4   3   0   0   0   0   0   0   0   0
0LABELS FOR DATA ITEMS:
 C ID DOSE TIME DV WT TYPE EVID MDV
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 AA
0FORMAT FOR DATA:
 (7E9.0,2F2.0)

 TOT. NO. OF OBS RECS:     4320
 TOT. NO. OF INDIVIDUALS:      288
0LENGTH OF THETA:   6
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS BLOCK FORM:
  1
  1  1
  1  1  1
  0  0  0  2
  0  0  0  2  2
  0  0  0  2  2  2
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   1
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
 LOWER BOUND    INITIAL EST    UPPER BOUND
 -0.1000E+07     0.1600E+01     0.1000E+07
 -0.1000E+07     0.2300E+01     0.1000E+07
 -0.1000E+07     0.7000E+00     0.1000E+07
 -0.1000E+07     0.1000E+00     0.1000E+07
 -0.1000E+07     0.1000E+00     0.1000E+07
  0.3000E+01     0.3000E+01     0.3000E+01
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.5000E+00
                  0.1000E-01   0.5000E+00
                  0.1000E-01   0.1000E-01   0.5000E+00
        2                                                                                  YES
                  0.9000E-01
                  0.0000E+00   0.9000E-01
                  0.0000E+00   0.0000E+00   0.9000E-01
0INITIAL ESTIMATE OF SIGMA:
 0.1000E+00
0COVARIANCE STEP OMITTED:        NO
 R MATRIX SUBSTITUTED:          YES
 S MATRIX SUBSTITUTED:           NO
 EIGENVLS. PRINTED:             YES
 COMPRESSED FORMAT:              NO
 GRADIENT METHOD USED:       SLOW
 SIGDIGITS ETAHAT (SIGLO):                  -1
 SIGDIGITS GRADIENTS (SIGL):                10
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
04 COLUMNS APPENDED:    YES
 PRINTED:                NO
 HEADERS:               YES
 FILE TO BE FORWARDED:   NO
 FORMAT:                S1PE11.4
 LFORMAT:
 RFORMAT:
 FIXED_EFFECT_ETAS:
0USER-CHOSEN ITEMS:
 ID DOSE WT TIME TYPE DV AA
0
 PRIOR SUBROUTINE USER-SUPPLIED
1DOUBLE PRECISION PREDPP VERSION 7.4.3

 ONE COMPARTMENT MODEL WITH FIRST-ORDER ABSORPTION (ADVAN2)
0MAXIMUM NO. OF BASIC PK PARAMETERS:   3
0BASIC PK PARAMETERS (AFTER TRANSLATION):
   ELIMINATION RATE (K) IS BASIC PK PARAMETER NO.:  1
   ABSORPTION RATE (KA) IS BASIC PK PARAMETER NO.:  3

 TRANSLATOR WILL CONVERT PARAMETERS
 CLEARANCE (CL) AND VOLUME (V) TO K (TRANS2)
0COMPARTMENT ATTRIBUTES
 COMPT. NO.   FUNCTION   INITIAL    ON/OFF      DOSE      DEFAULT    DEFAULT
                         STATUS     ALLOWED    ALLOWED    FOR DOSE   FOR OBS.
    1         DEPOT        OFF        YES        YES        YES        NO
    2         CENTRAL      ON         NO         YES        NO         YES
    3         OUTPUT       OFF        YES        NO         NO         NO
1
 ADDITIONAL PK PARAMETERS - ASSIGNMENT OF ROWS IN GG
 COMPT. NO.                             INDICES
              SCALE      BIOAVAIL.   ZERO-ORDER  ZERO-ORDER  ABSORB
                         FRACTION    RATE        DURATION    LAG
    1            *           *           *           *           *
    2            4           *           *           *           *
    3            *           -           -           -           -
             - PARAMETER IS NOT ALLOWED FOR THIS MODEL
             * PARAMETER IS NOT SUPPLIED BY PK SUBROUTINE;
               WILL DEFAULT TO ONE IF APPLICABLE
0DATA ITEM INDICES USED BY PRED ARE:
   EVENT ID DATA ITEM IS DATA ITEM NO.:      8
   TIME DATA ITEM IS DATA ITEM NO.:          4
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   3

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
 GRADIENT METHOD USED:               SLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    YES
 NUMERICAL 2ND DERIVATIVES:               YES
 NO. OF FUNCT. EVALS. ALLOWED:            960
 NO. OF SIG. FIGURES REQUIRED:            3
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
 IND. OBJ. FUNC. VALUES SORTED:           NO
 NUMERICAL DERIVATIVE
       FILE REQUEST (NUMDER):               NONE
 MAP (ETAHAT) ESTIMATION METHOD (OPTMAP):   0
 ETA HESSIAN EVALUATION METHOD (ETADER):    0
 INITIAL ETA FOR MAP ESTIMATION (MCETA):    3
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
 RAW OUTPUT FILE (FILE): wexample10_its.ext
 EXCLUDE TITLE (NOTITLE):                   NO
 EXCLUDE COLUMN LABELS (NOLABEL):           NO
 FORMAT FOR ADDITIONAL FILES (FORMAT):      S1PE12.5
 PARAMETER ORDER FOR OUTPUTS (ORDER):       TSOL
 WISHART PRIOR DF INTERPRETATION (WISHTYPE):0
 KNUTHSUMOFF:                               0
 INCLUDE LNTWOPI:                           NO
 INCLUDE CONSTANT TERM TO PRIOR (PRIORC):   NO
 INCLUDE CONSTANT TERM TO OMEGA (ETA) (OLNTWOPI):NO
 EM OR BAYESIAN METHOD USED:                ITERATIVE TWO STAGE (ITS)
 MU MODELING PATTERN (MUM):
 GRADIENT/GIBBS PATTERN (GRD):
 AUTOMATIC SETTING FEATURE (AUTO):          ON
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
   1   2   3
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 iteration            0 OBJ=   14961.5911441353
 iteration            5 OBJ=   10120.5371227598
 iteration           10 OBJ=   10043.5589739003
 iteration           15 OBJ=   10043.1919606305
 iteration           20 OBJ=   10043.2075523527
 iteration           25 OBJ=   10043.2086441518
 Convergence achieved
 iteration           28 OBJ=   10043.2087039223
 iteration           28 OBJ=   10043.2087212924
 
 #TERM:
 OPTIMIZATION WAS COMPLETED


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -3.4376E-08 -5.0083E-09 -1.2078E-09
 SE:             1.4404E-02  1.5600E-02  1.6953E-02
 N:                     288         288         288
 
 P VAL.:         1.0000E+00  1.0000E+00  1.0000E+00
 
 ETASHRINKSD(%)  1.6449E+01  2.8186E+00  1.6152E+00
 ETASHRINKVR(%)  3.0192E+01  5.5577E+00  3.2044E+00
 EBVSHRINKSD(%)  1.6449E+01  2.8186E+00  1.6152E+00
 EBVSHRINKVR(%)  3.0192E+01  5.5577E+00  3.2044E+00
 EPSSHRINKSD(%)  1.2870E+01
 EPSSHRINKVR(%)  2.4084E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2880
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    5293.08595125891     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    10043.2087212924     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       15336.2946725513     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           864
  
 #TERE:
 Elapsed estimation  time in seconds:     7.51
 Elapsed covariance  time in seconds:     0.39
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************    10043.209       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.07E+00  3.39E+00  2.44E+00 -6.48E-01  8.06E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        8.59E-02
 
 ETA2
+        3.65E-03  7.45E-02
 
 ETA3
+        3.60E-02  3.00E-02  8.58E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        2.27E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        2.93E-01
 
 ETA2
+        4.56E-02  2.73E-01
 
 ETA3
+        4.19E-01  3.75E-01  2.93E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.51E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                          STANDARD ERROR OF ESTIMATE (S)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         2.29E-02  1.67E-02  1.76E-02  9.97E-02  7.19E-03
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        9.97E-03
 
 ETA2
+        6.30E-03  6.41E-03
 
 ETA3
+        7.19E-03  5.17E-03  7.29E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        7.78E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        1.70E-02
 
 ETA2
+        7.81E-02  1.17E-02
 
 ETA3
+        6.10E-02  5.31E-02  1.24E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.58E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (S)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        5.26E-04
 
 TH 2
+        3.37E-05  2.79E-04
 
 TH 3
+        1.35E-04  1.19E-04  3.11E-04
 
 TH 4
+       -2.76E-05 -9.00E-05 -9.68E-05  9.94E-03
 
 TH 5
+        7.78E-06  6.39E-06  5.64E-06 -4.92E-04  5.17E-05
 
 OM11
+        7.32E-05  3.29E-06 -1.95E-06  6.66E-05 -2.51E-06  9.94E-05
 
 OM12
+        1.38E-05  5.85E-06  6.41E-06 -9.14E-05  4.18E-06  1.18E-05  3.97E-05
 
 OM13
+        2.21E-05  4.62E-06  1.94E-06 -2.00E-05  7.48E-07  5.52E-05  1.80E-05  5.17E-05
 
 OM22
+        8.30E-06 -2.27E-06  1.23E-06  3.14E-06  1.75E-06  6.14E-06  4.22E-06  5.04E-06  4.11E-05
 
 OM23
+        5.44E-06  1.45E-06  2.20E-06 -3.02E-05  3.42E-06  5.11E-06  1.49E-05  9.55E-06  1.49E-05  2.68E-05
 
 OM33
+        2.55E-06  3.29E-06  4.45E-06 -5.95E-05  1.44E-06  6.35E-06  1.21E-05  2.00E-05  3.80E-06  1.80E-05  5.31E-05
 
 SG11
+        2.42E-07  1.00E-06  2.51E-07  9.46E-07  2.87E-07 -5.20E-08 -2.84E-07  1.63E-07 -6.56E-07 -6.68E-07  3.15E-07  6.05E-07
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (S)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        2.29E-02
 
 TH 2
+        8.79E-02  1.67E-02
 
 TH 3
+        3.34E-01  4.03E-01  1.76E-02
 
 TH 4
+       -1.21E-02 -5.41E-02 -5.50E-02  9.97E-02
 
 TH 5
+        4.72E-02  5.32E-02  4.44E-02 -6.86E-01  7.19E-03
 
 OM11
+        3.20E-01  1.97E-02 -1.11E-02  6.70E-02 -3.50E-02  9.97E-03
 
 OM12
+        9.53E-02  5.56E-02  5.76E-02 -1.46E-01  9.22E-02  1.87E-01  6.30E-03
 
 OM13
+        1.34E-01  3.85E-02  1.53E-02 -2.78E-02  1.45E-02  7.70E-01  3.97E-01  7.19E-03
 
 OM22
+        5.64E-02 -2.12E-02  1.09E-02  4.91E-03  3.79E-02  9.60E-02  1.05E-01  1.09E-01  6.41E-03
 
 OM23
+        4.59E-02  1.67E-02  2.40E-02 -5.86E-02  9.18E-02  9.90E-02  4.57E-01  2.57E-01  4.50E-01  5.17E-03
 
 OM33
+        1.53E-02  2.70E-02  3.46E-02 -8.19E-02  2.75E-02  8.75E-02  2.64E-01  3.82E-01  8.12E-02  4.78E-01  7.29E-03
 
 SG11
+        1.36E-02  7.73E-02  1.83E-02  1.22E-02  5.12E-02 -6.70E-03 -5.79E-02  2.91E-02 -1.31E-01 -1.66E-01  5.55E-02  7.78E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        2.62E+03
 
 TH 2
+        2.38E+02  4.34E+03
 
 TH 3
+       -1.24E+03 -1.74E+03  4.43E+03
 
 TH 4
+       -6.84E+00  1.27E+01  1.84E+01  1.99E+02
 
 TH 5
+       -4.80E+02 -2.16E+02  1.81E+02  1.88E+03  3.76E+04
 
 OM11
+       -3.82E+03 -4.58E+02  1.97E+03 -1.88E+02  1.52E+02  3.51E+04
 
 OM12
+       -1.08E+03 -3.46E+02  9.47E+01  3.18E+02  1.82E+03  6.88E+03  3.87E+04
 
 OM13
+        3.65E+03  2.15E+02 -1.69E+03  1.37E+02 -3.36E+02 -4.21E+04 -1.85E+04  7.67E+04
 
 OM22
+       -2.79E+02  3.16E+02 -1.34E+02 -2.54E+01 -3.62E+02 -2.41E+02  4.84E+03 -2.29E+03  3.23E+04
 
 OM23
+        2.50E+02 -2.71E+02  2.01E+02 -3.72E+02 -6.05E+03 -1.73E+03 -2.17E+04  5.61E+03 -2.30E+04  7.75E+04
 
 OM33
+       -7.55E+02  4.79E+01  1.21E+02  2.05E+02  3.04E+03  1.05E+04  4.69E+03 -2.12E+04  5.23E+03 -2.22E+04  3.20E+04
 
 SG11
+       -2.15E+03 -6.74E+03  2.12E+03 -1.67E+03 -2.80E+04  1.16E+04  2.21E+03 -1.94E+04  9.53E+03  6.39E+04 -2.83E+04  1.78E+06
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                    EIGENVALUES OF COR MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12

 
         1.33E-01  2.74E-01  3.50E-01  5.03E-01  6.95E-01  8.08E-01  8.82E-01  1.11E+00  1.33E+00  1.59E+00  1.75E+00  2.57E+00
 
1
 
 
 #TBLN:      2
 #METH: MCMC Bayesian Analysis
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               SLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            960
 NO. OF SIG. FIGURES REQUIRED:            3
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
 IND. OBJ. FUNC. VALUES SORTED:           NO
 NUMERICAL DERIVATIVE
       FILE REQUEST (NUMDER):               NONE
 MAP (ETAHAT) ESTIMATION METHOD (OPTMAP):   0
 ETA HESSIAN EVALUATION METHOD (ETADER):    0
 INITIAL ETA FOR MAP ESTIMATION (MCETA):    0
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      6
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     6
 NOPRIOR SETTING (NOPRIOR):                 OFF
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): wexample10_bayes.ext
 EXCLUDE TITLE (NOTITLE):                   NO
 EXCLUDE COLUMN LABELS (NOLABEL):           NO
 FORMAT FOR ADDITIONAL FILES (FORMAT):      S1PE12.5
 PARAMETER ORDER FOR OUTPUTS (ORDER):       TSOL
 WISHART PRIOR DF INTERPRETATION (WISHTYPE):0
 KNUTHSUMOFF:                               0
 INCLUDE LNTWOPI:                           NO
 INCLUDE CONSTANT TERM TO PRIOR (PRIORC):   NO
 INCLUDE CONSTANT TERM TO OMEGA (ETA) (OLNTWOPI):NO
 EM OR BAYESIAN METHOD USED:                MCMC BAYESIAN (BAYES)
 MU MODELING PATTERN (MUM):
 GRADIENT/GIBBS PATTERN (GRD):
 AUTOMATIC SETTING FEATURE (AUTO):          ON
 CONVERGENCE TYPE (CTYPE):                  3
 KEEP ITERATIONS (THIN):            1
 CONVERGENCE INTERVAL (CINTERVAL):          0
 CONVERGENCE ITERATIONS (CITER):            10
 CONVERGENCE ALPHA ERROR (CALPHA):          5.000000000000000E-02
 BURN-IN ITERATIONS (NBURN):                4000
 ITERATIONS (NITER):                        10000
 ANEAL SETTING (CONSTRAIN):                 1
 STARTING SEED FOR MC METHODS (SEED):       11456
 MC SAMPLES PER SUBJECT (ISAMPLE):          1
 RANDOM SAMPLING METHOD (RANMETHOD):        3U
 PROPOSAL DENSITY SCALING RANGE
              (ISCALE_MIN, ISCALE_MAX):     1.000000000000000E-06   ,1000000.00000000
 SAMPLE ACCEPTANCE RATE (IACCEPT):          0.400000000000000
 METROPOLIS HASTINGS SAMPLING FOR INDIVIDUAL ETAS:
 SAMPLES FOR GLOBAL SEARCH KERNEL (ISAMPLE_M1):          2
 SAMPLES FOR NEIGHBOR SEARCH KERNEL (ISAMPLE_M1A):       0
 SAMPLES FOR MASS/IMP/POST. MATRIX SEARCH (ISAMPLE_M1B): 2
 SAMPLES FOR LOCAL SEARCH KERNEL (ISAMPLE_M2):           2
 SAMPLES FOR LOCAL UNIVARIATE KERNEL (ISAMPLE_M3):       2
 PWR. WT. MASS/IMP/POST MATRIX ACCUM. FOR ETAS (IKAPPA): 1.00000000000000
 MASS/IMP./POST. MATRIX REFRESH SETTING (MASSREST):      -1
 METROPOLIS HASTINGS POPULATION SAMPLING FOR NON-GIBBS
 SAMPLED THETAS AND SIGMAS:
 PROPOSAL DENSITY SCALING RANGE
              (PSCALE_MIN, PSCALE_MAX):   1.000000000000000E-02   ,1000.00000000000
 SAMPLE ACCEPTANCE RATE (PACCEPT):                       0.500000000000000
 SAMPLES FOR GLOBAL SEARCH KERNEL (PSAMPLE_M1):          1
 SAMPLES FOR LOCAL SEARCH KERNEL (PSAMPLE_M2):           2
 SAMPLES FOR LOCAL UNIVARIATE KERNEL (PSAMPLE_M3):       1
 METROPOLIS HASTINGS POPULATION SAMPLING FOR NON-GIBBS
 SAMPLED OMEGAS:
 SAMPLE ACCEPTANCE RATE (OACCEPT):                       0.500000000000000
 SAMPLES FOR GLOBAL SEARCH KERNEL (OSAMPLE_M1):          -1
 SAMPLES FOR LOCAL SEARCH KERNEL (OSAMPLE_M2):           6
 SAMPLES FOR LOCAL UNIVARIATE SEARCH KERNEL (OSAMPLE_M3):6
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
   1   2   3
 THETAS THAT ARE GIBBS SAMPLED:
   1   2   3
 THETAS THAT ARE METROPOLIS-HASTINGS SAMPLED:
   4   5
 SIGMAS THAT ARE GIBBS SAMPLED:
   1
 SIGMAS THAT ARE METROPOLIS-HASTINGS SAMPLED:
 
 OMEGAS ARE GIBBS SAMPLED
 
 MONITORING OF SEARCH:

 Burn-in Mode
 iteration        -4000 MCMCOBJ=    5184.91566444632     
 CINTERVAL IS           14
 iteration        -3900 MCMCOBJ=    5736.07948788310     
 iteration        -3800 MCMCOBJ=    5741.24421630474     
 Convergence achieved
 iteration        -3794 MCMCOBJ=    5744.03566436459     
 Sampling Mode
 iteration            0 MCMCOBJ=    5860.48646261899     
 iteration          100 MCMCOBJ=    5768.51362848209     
 iteration          200 MCMCOBJ=    5748.87853456909     
 iteration          300 MCMCOBJ=    5867.43395529244     
 iteration          400 MCMCOBJ=    5847.84248347931     
 iteration          500 MCMCOBJ=    5863.92457021880     
 iteration          600 MCMCOBJ=    5771.04222213071     
 iteration          700 MCMCOBJ=    5773.87261402686     
 iteration          800 MCMCOBJ=    5820.35948111551     
 iteration          900 MCMCOBJ=    5780.49362268306     
 iteration         1000 MCMCOBJ=    5874.09149046328     
 iteration         1100 MCMCOBJ=    5815.23193289617     
 iteration         1200 MCMCOBJ=    5796.71332176335     
 iteration         1300 MCMCOBJ=    5771.29620653712     
 iteration         1400 MCMCOBJ=    5789.76662427704     
 iteration         1500 MCMCOBJ=    5739.74238858916     
 iteration         1600 MCMCOBJ=    5885.99773186325     
 iteration         1700 MCMCOBJ=    5788.04917086541     
 iteration         1800 MCMCOBJ=    5824.32929838116     
 iteration         1900 MCMCOBJ=    5801.08721028952     
 iteration         2000 MCMCOBJ=    5779.96231343159     
 iteration         2100 MCMCOBJ=    5839.76769812373     
 iteration         2200 MCMCOBJ=    5799.46629575300     
 iteration         2300 MCMCOBJ=    5780.53317785220     
 iteration         2400 MCMCOBJ=    5787.45049860061     
 iteration         2500 MCMCOBJ=    5803.04557567426     
 iteration         2600 MCMCOBJ=    5678.72391271643     
 iteration         2700 MCMCOBJ=    5780.55178513051     
 iteration         2800 MCMCOBJ=    5815.66713539030     
 iteration         2900 MCMCOBJ=    5803.48236960761     
 iteration         3000 MCMCOBJ=    5848.98843075710     
 iteration         3100 MCMCOBJ=    5787.79513046770     
 iteration         3200 MCMCOBJ=    5772.00240463359     
 iteration         3300 MCMCOBJ=    5805.75126965139     
 iteration         3400 MCMCOBJ=    5840.38056133381     
 iteration         3500 MCMCOBJ=    5864.54893632951     
 iteration         3600 MCMCOBJ=    5748.49843625747     
 iteration         3700 MCMCOBJ=    5830.12800896624     
 iteration         3800 MCMCOBJ=    5884.23645098666     
 iteration         3900 MCMCOBJ=    5824.35340394667     
 iteration         4000 MCMCOBJ=    5764.90977488297     
 iteration         4100 MCMCOBJ=    5824.97790702258     
 iteration         4200 MCMCOBJ=    5797.00621817668     
 iteration         4300 MCMCOBJ=    5775.88572031641     
 iteration         4400 MCMCOBJ=    5801.62534179431     
 iteration         4500 MCMCOBJ=    5723.53911445988     
 iteration         4600 MCMCOBJ=    5889.49671135840     
 iteration         4700 MCMCOBJ=    5760.54441460289     
 iteration         4800 MCMCOBJ=    5758.90409412655     
 iteration         4900 MCMCOBJ=    5757.73556276785     
 iteration         5000 MCMCOBJ=    5762.48130643202     
 iteration         5100 MCMCOBJ=    5780.99097913354     
 iteration         5200 MCMCOBJ=    5850.02774812144     
 iteration         5300 MCMCOBJ=    5783.98496765014     
 iteration         5400 MCMCOBJ=    5723.88932998941     
 iteration         5500 MCMCOBJ=    5915.07982200007     
 iteration         5600 MCMCOBJ=    5808.65862770091     
 iteration         5700 MCMCOBJ=    5826.94843937516     
 iteration         5800 MCMCOBJ=    5782.17621140240     
 iteration         5900 MCMCOBJ=    5811.74637828586     
 iteration         6000 MCMCOBJ=    5818.30514498730     
 iteration         6100 MCMCOBJ=    5862.89290622476     
 iteration         6200 MCMCOBJ=    5790.44295466273     
 iteration         6300 MCMCOBJ=    5925.19594993298     
 iteration         6400 MCMCOBJ=    5792.16434395990     
 iteration         6500 MCMCOBJ=    5765.68882027814     
 iteration         6600 MCMCOBJ=    5818.11214876260     
 iteration         6700 MCMCOBJ=    5797.36061557720     
 iteration         6800 MCMCOBJ=    5852.91511099352     
 iteration         6900 MCMCOBJ=    5805.66755082566     
 iteration         7000 MCMCOBJ=    5726.98712418613     
 iteration         7100 MCMCOBJ=    5833.10823784867     
 iteration         7200 MCMCOBJ=    5801.35599695741     
 iteration         7300 MCMCOBJ=    5851.28392171618     
 iteration         7400 MCMCOBJ=    5797.64450351411     
 iteration         7500 MCMCOBJ=    5838.54566874658     
 iteration         7600 MCMCOBJ=    5758.42534682279     
 iteration         7700 MCMCOBJ=    5754.75897120948     
 iteration         7800 MCMCOBJ=    5846.27674146862     
 iteration         7900 MCMCOBJ=    5779.17819089891     
 iteration         8000 MCMCOBJ=    5758.59649981849     
 iteration         8100 MCMCOBJ=    5766.64282353884     
 iteration         8200 MCMCOBJ=    5790.90075171084     
 iteration         8300 MCMCOBJ=    5805.18529738453     
 iteration         8400 MCMCOBJ=    5898.85842029953     
 iteration         8500 MCMCOBJ=    5795.60501624067     
 iteration         8600 MCMCOBJ=    5855.41533070596     
 iteration         8700 MCMCOBJ=    5830.16667788689     
 iteration         8800 MCMCOBJ=    5834.66761405020     
 iteration         8900 MCMCOBJ=    5797.42526419366     
 iteration         9000 MCMCOBJ=    5841.85575206629     
 iteration         9100 MCMCOBJ=    5775.27113222205     
 iteration         9200 MCMCOBJ=    5823.45149911523     
 iteration         9300 MCMCOBJ=    5805.08398230003     
 iteration         9400 MCMCOBJ=    5854.16974312191     
 iteration         9500 MCMCOBJ=    5830.24813936886     
 iteration         9600 MCMCOBJ=    5746.89884789003     
 iteration         9700 MCMCOBJ=    5851.38134278802     
 iteration         9800 MCMCOBJ=    5833.10882134180     
 iteration         9900 MCMCOBJ=    5875.85457460051     
 iteration        10000 MCMCOBJ=    5872.37764682877     
 
 #TERM:
 BURN-IN WAS COMPLETED
 STATISTICAL PORTION WAS COMPLETED
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2880
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    5293.08595125891     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    5800.60572178871     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       11093.6916730476     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           864
 NIND*NETA*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    1587.92578537767     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    5800.60572178871     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       7388.53150716639     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 PRIOR CONSTANT TO OBJECTIVE FUNCTION:    22.3596795730206     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    5800.60572178871     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       5822.96540136173     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 #TERE:
 Elapsed estimation  time in seconds:   701.37
 Elapsed covariance  time in seconds:     0.00
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 #OBJT:**************                       AVERAGE VALUE OF LIKELIHOOD FUNCTION                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     5800.606       **************************************************
 #OBJS:********************************************       49.898 (STD) **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.12E+00  3.39E+00  2.44E+00 -6.54E-01  8.13E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        9.45E-02
 
 ETA2
+        4.12E-03  7.60E-02
 
 ETA3
+        3.78E-02  2.96E-02  8.68E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        2.28E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        3.07E-01
 
 ETA2
+        4.82E-02  2.75E-01
 
 ETA3
+        4.17E-01  3.64E-01  2.94E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.51E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************                STANDARD ERROR OF ESTIMATE (From Sample Variance)               ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         2.23E-02  1.67E-02  1.76E-02  9.52E-02  6.17E-03
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        1.21E-02
 
 ETA2
+        6.29E-03  6.80E-03
 
 ETA3
+        7.17E-03  5.39E-03  7.54E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        7.24E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        1.96E-02
 
 ETA2
+        7.34E-02  1.23E-02
 
 ETA3
+        6.22E-02  5.30E-02  1.27E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.40E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************               COVARIANCE MATRIX OF ESTIMATE (From Sample Variance)             ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        4.96E-04
 
 TH 2
+        3.13E-05  2.80E-04
 
 TH 3
+        1.38E-04  1.17E-04  3.09E-04
 
 TH 4
+       -1.58E-06  2.73E-05  1.25E-05  9.06E-03
 
 TH 5
+        1.64E-06  9.20E-08  1.72E-07 -3.62E-04  3.81E-05
 
 OM11
+        3.93E-05  1.23E-07 -4.85E-07  2.40E-06 -1.68E-07  1.47E-04
 
 OM12
+        4.51E-06 -3.33E-07  1.88E-06 -2.29E-06 -1.58E-07  9.03E-06  3.95E-05
 
 OM13
+        6.71E-06 -1.79E-07  1.33E-06  1.07E-05 -4.73E-07  4.45E-05  1.82E-05  5.15E-05
 
 OM22
+        1.58E-06  5.83E-07 -9.90E-07 -4.90E-06  2.84E-07  2.29E-06  5.11E-06  2.72E-06  4.62E-05
 
 OM23
+       -1.26E-06 -1.49E-06 -5.90E-07 -5.80E-06  2.75E-07  3.66E-06  1.20E-05  7.69E-06  1.89E-05  2.91E-05
 
 OM33
+       -2.19E-06  3.05E-07  2.27E-06 -2.94E-06  4.44E-07  1.23E-05  9.72E-06  2.59E-05  8.31E-06  2.07E-05  5.68E-05
 
 SG11
+        1.14E-07  3.38E-07  2.29E-07  1.06E-06 -2.52E-08 -7.68E-07 -7.06E-08 -2.44E-08 -2.63E-08 -6.42E-08 -4.77E-08  5.24E-07
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************              CORRELATION MATRIX OF ESTIMATE (From Sample Variance)             ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        2.23E-02
 
 TH 2
+        8.42E-02  1.67E-02
 
 TH 3
+        3.53E-01  3.99E-01  1.76E-02
 
 TH 4
+       -7.43E-04  1.72E-02  7.50E-03  9.52E-02
 
 TH 5
+        1.19E-02  8.91E-04  1.58E-03 -6.16E-01  6.17E-03
 
 OM11
+        1.46E-01  6.09E-04 -2.28E-03  2.08E-03 -2.25E-03  1.21E-02
 
 OM12
+        3.22E-02 -3.16E-03  1.70E-02 -3.83E-03 -4.08E-03  1.18E-01  6.29E-03
 
 OM13
+        4.20E-02 -1.49E-03  1.06E-02  1.57E-02 -1.07E-02  5.11E-01  4.04E-01  7.17E-03
 
 OM22
+        1.04E-02  5.13E-03 -8.29E-03 -7.57E-03  6.77E-03  2.78E-02  1.20E-01  5.58E-02  6.80E-03
 
 OM23
+       -1.05E-02 -1.66E-02 -6.22E-03 -1.13E-02  8.25E-03  5.60E-02  3.53E-01  1.99E-01  5.14E-01  5.39E-03
 
 OM33
+       -1.30E-02  2.42E-03  1.71E-02 -4.10E-03  9.55E-03  1.35E-01  2.05E-01  4.79E-01  1.62E-01  5.09E-01  7.54E-03
 
 SG11
+        7.05E-03  2.79E-02  1.80E-02  1.54E-02 -5.64E-03 -8.74E-02 -1.55E-02 -4.70E-03 -5.34E-03 -1.64E-02 -8.74E-03  7.24E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************           INVERSE COVARIANCE MATRIX OF ESTIMATE (From Sample Variance)         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        2.38E+03
 
 TH 2
+        2.19E+02  4.28E+03
 
 TH 3
+       -1.15E+03 -1.72E+03  4.41E+03
 
 TH 4
+       -4.45E+00 -1.74E+01  6.13E-01  1.78E+02
 
 TH 5
+       -1.42E+02 -1.77E+02  3.98E+01  1.69E+03  4.23E+04
 
 OM11
+       -7.65E+02 -1.19E+02  4.00E+02  9.81E+00  3.66E+01  9.91E+03
 
 OM12
+       -3.10E+02 -1.62E+01 -7.33E+01  3.04E+01  3.04E+02  2.42E+03  3.50E+04
 
 OM13
+        4.11E+02  1.40E+02 -1.84E+02 -4.43E+01  9.17E+01 -1.05E+04 -1.52E+04  4.11E+04
 
 OM22
+       -1.81E+02 -2.47E+02  1.85E+02  1.95E+00 -8.20E+01 -2.16E+01  2.67E+03 -1.09E+03  3.02E+04
 
 OM23
+        2.47E+02  3.97E+02  2.98E+01  1.18E+01  8.37E+01 -1.36E+03 -1.68E+04  9.62E+03 -2.34E+04  7.09E+04
 
 OM33
+        1.05E+02 -9.09E+01 -2.40E+02  3.94E+00 -3.71E+02  2.68E+03  6.12E+03 -1.72E+04  4.12E+03 -2.36E+04  3.18E+04
 
 SG11
+       -1.27E+03 -2.17E+03 -4.83E+00 -2.50E+02 -1.20E+03  1.45E+04  6.25E+03 -1.59E+04 -5.85E+02  1.21E+03  4.27E+03  1.93E+06
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************           EIGENVALUES OF COR MATRIX OF ESTIMATE (From Sample Variance)         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12

 
         2.39E-01  3.83E-01  4.13E-01  4.98E-01  7.70E-01  8.30E-01  9.31E-01  1.01E+00  1.36E+00  1.59E+00  1.62E+00  2.36E+00
 
 Elapsed postprocess time in seconds:     0.15
 Elapsed finaloutput time in seconds:     0.54
 #CPUT: Total CPU Time in Seconds,      696.685
Stop Time: 
Tue 03/12/2019 
10:37 AM
