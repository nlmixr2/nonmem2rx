Tue 03/12/2019 
10:18 AM
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

$OMEGA BLOCK(3) VALUES(0.3,0.01) ; [P]

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

; Although SAEM does not use Laplace method, this opption is required so NMTRAN can prepare for all methods
$EST METHOD=ITS INTER LAP NITER=0 NOABORT
$EST METHOD=SAEM INTER LAP AUTO=1 NITER=300 PRINT=10 
; Because of categorical data, which can make conditional density highly non-normal, select a t-distribution
; with 4 degrees of freedom for importance sampling proposal density
$EST METHOD=IMP EONLY=1 NITER=5 ISAMPLE=1000 PRINT=1 DF=4 IACCEPT=1.0

$COV UNCONDITIONAL PRINT=E MATRIX=R SIGL=10
$TABLE ID DOSE WT TIME TYPE DV AA NOPRINT FILE=wexample10_saem.tab
  
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
0LENGTH OF THETA:   5
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS BLOCK FORM:
  1
  1  1
  1  1  1
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   1
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
   0.1600E+01  0.2300E+01  0.7000E+00  0.1000E+00  0.1000E+00
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.3000E+00
                  0.1000E-01   0.3000E+00
                  0.1000E-01   0.1000E-01   0.3000E+00
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
 #METH: Iterative Two Stage
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               SLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    YES
 NUMERICAL 2ND DERIVATIVES:               YES
 NO. OF FUNCT. EVALS. ALLOWED:            528
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
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      100
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     100
 NOPRIOR SETTING (NOPRIOR):                 OFF
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): wexample10_saem.ext
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
 AUTOMATIC SETTING FEATURE (AUTO):          OFF
 CONVERGENCE TYPE (CTYPE):                  0
 ITERATIONS (NITER):                        0
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

 iteration            0 OBJ=   16156.8362013043
 
 #TERM:
 OPTIMIZATION WAS NOT TESTED FOR CONVERGENCE


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -2.9656E-01  1.0461E+00  1.7074E+00
 SE:             1.6002E-02  1.5740E-02  1.5956E-02
 N:                     288         288         288
 
 P VAL.:         1.1936E-76  0.0000E+00  0.0000E+00
 
 ETASHRINKSD(%)  5.0335E+01  5.1146E+01  5.0476E+01
 ETASHRINKVR(%)  7.5334E+01  7.6133E+01  7.5473E+01
 EBVSHRINKSD(%)  4.4118E+01  3.0978E+00  2.1545E+00
 EBVSHRINKVR(%)  6.8772E+01  6.0996E+00  4.2626E+00
 EPSSHRINKSD(%)  5.2933E+01
 EPSSHRINKVR(%)  7.7847E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2880
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    5293.08595125891     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    16156.8362013043     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       21449.9221525632     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           864
  
 #TERE:
 Elapsed estimation  time in seconds:     0.83
 Elapsed covariance  time in seconds:     0.16
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                               ITERATIVE TWO STAGE                              ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************    16156.836       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                               ITERATIVE TWO STAGE                              ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.60E+00  2.30E+00  7.00E-01  1.00E-01  1.00E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        3.00E-01
 
 ETA2
+        1.00E-02  3.00E-01
 
 ETA3
+        1.00E-02  1.00E-02  3.00E-01
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        1.00E-01
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        5.48E-01
 
 ETA2
+        3.33E-02  5.48E-01
 
 ETA3
+        3.33E-02  3.33E-02  5.48E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        3.16E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                               ITERATIVE TWO STAGE                              ********************
 ********************                          STANDARD ERROR OF ESTIMATE (S)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         4.01E-01  5.29E-01  3.11E-01  1.01E-01  7.36E-03
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        8.89E-02
 
 ETA2
+        9.02E-02  1.18E-01
 
 ETA3
+        7.30E-02  9.18E-02  8.95E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        1.43E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        8.12E-02
 
 ETA2
+        2.98E-01  1.08E-01
 
 ETA3
+        2.45E-01  3.13E-01  8.17E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.26E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                               ITERATIVE TWO STAGE                              ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (S)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        1.61E-01
 
 TH 2
+        5.37E-02  2.80E-01
 
 TH 3
+        9.05E-03 -1.27E-01  9.64E-02
 
 TH 4
+        5.05E-03 -3.72E-03  4.78E-03  1.02E-02
 
 TH 5
+       -2.24E-04 -1.87E-04  4.85E-05 -5.10E-04  5.41E-05
 
 OM11
+        8.72E-03 -6.82E-05  5.09E-03  1.16E-03 -5.26E-05  7.90E-03
 
 OM12
+       -8.20E-03  1.78E-02 -9.77E-03 -1.23E-03  5.35E-05  1.92E-03  8.13E-03
 
 OM13
+       -2.04E-02 -1.96E-02  7.11E-03  2.01E-04  1.45E-06 -4.50E-04 -2.87E-03  5.33E-03
 
 OM22
+       -7.04E-03 -1.66E-02  1.44E-02  1.28E-04  7.40E-06  8.21E-04  2.83E-03 -2.55E-04  1.40E-02
 
 OM23
+       -6.83E-03 -3.49E-02  1.15E-02  1.17E-04  6.10E-05 -5.41E-06 -3.03E-03  3.00E-03 -4.81E-03  8.43E-03
 
 OM33
+       -2.62E-03  3.88E-02 -2.36E-02 -7.81E-04 -5.31E-05 -1.27E-03  2.98E-03 -1.98E-03  3.27E-04 -6.45E-03  8.01E-03
 
 SG11
+        1.83E-04  1.30E-03  1.44E-03  4.69E-05  3.36E-06  8.25E-05 -3.13E-05  1.32E-04 -6.37E-05 -1.66E-04 -1.77E-04  2.04E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                               ITERATIVE TWO STAGE                              ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (S)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        4.01E-01
 
 TH 2
+        2.53E-01  5.29E-01
 
 TH 3
+        7.28E-02 -7.73E-01  3.11E-01
 
 TH 4
+        1.25E-01 -6.96E-02  1.52E-01  1.01E-01
 
 TH 5
+       -7.60E-02 -4.81E-02  2.12E-02 -6.87E-01  7.36E-03
 
 OM11
+        2.45E-01 -1.45E-03  1.85E-01  1.29E-01 -8.03E-02  8.89E-02
 
 OM12
+       -2.27E-01  3.73E-01 -3.49E-01 -1.35E-01  8.07E-02  2.40E-01  9.02E-02
 
 OM13
+       -6.98E-01 -5.06E-01  3.14E-01  2.73E-02  2.69E-03 -6.93E-02 -4.36E-01  7.30E-02
 
 OM22
+       -1.49E-01 -2.66E-01  3.93E-01  1.08E-02  8.51E-03  7.81E-02  2.66E-01 -2.96E-02  1.18E-01
 
 OM23
+       -1.86E-01 -7.18E-01  4.02E-01  1.26E-02  9.02E-02 -6.62E-04 -3.66E-01  4.47E-01 -4.43E-01  9.18E-02
 
 OM33
+       -7.30E-02  8.18E-01 -8.49E-01 -8.64E-02 -8.07E-02 -1.60E-01  3.69E-01 -3.03E-01  3.09E-02 -7.84E-01  8.95E-02
 
 SG11
+        3.21E-02  1.73E-01  3.24E-01  3.26E-02  3.20E-02  6.50E-02 -2.43E-02  1.26E-01 -3.78E-02 -1.27E-01 -1.39E-01  1.43E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                               ITERATIVE TWO STAGE                              ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        7.09E+02
 
 TH 2
+       -1.27E+03  3.44E+03
 
 TH 3
+       -2.00E+03  5.47E+03  9.33E+03
 
 TH 4
+        1.71E+02 -5.02E+02 -8.73E+02  2.79E+02
 
 TH 5
+        1.64E+03 -5.12E+03 -8.13E+03  2.61E+03  4.45E+04
 
 OM11
+       -6.06E+02  7.35E+02  1.08E+03 -9.42E+01 -6.82E+02  8.01E+02
 
 OM12
+        2.41E+03 -4.55E+03 -6.83E+03  5.98E+02  5.95E+03 -2.12E+03  8.71E+03
 
 OM13
+        3.79E+03 -6.93E+03 -1.11E+04  9.67E+02  9.20E+03 -3.25E+03  1.30E+04  2.08E+04
 
 OM22
+       -1.74E+03  5.02E+03  7.35E+03 -6.70E+02 -7.71E+03  1.07E+03 -6.85E+03 -9.71E+03  8.32E+03
 
 OM23
+       -7.07E+03  2.00E+04  3.23E+04 -2.99E+03 -3.04E+04  3.98E+03 -2.57E+04 -3.96E+04  2.96E+04  1.19E+05
 
 OM33
+       -4.98E+03  1.44E+04  2.50E+04 -2.33E+03 -2.14E+04  2.58E+03 -1.73E+04 -2.84E+04  1.97E+04  8.75E+04  6.90E+04
 
 SG11
+        9.09E+03 -2.54E+04 -4.26E+04  3.94E+03  3.68E+04 -4.45E+03  3.06E+04  4.88E+04 -3.35E+04 -1.46E+05 -1.11E+05  2.07E+05
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                               ITERATIVE TWO STAGE                              ********************
 ********************                    EIGENVALUES OF COR MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12

 
         2.72E-04  8.49E-03  1.46E-02  4.99E-02  2.94E-01  6.17E-01  1.02E+00  1.17E+00  1.53E+00  1.64E+00  1.91E+00  3.74E+00
 
1
 
 
 #TBLN:      2
 #METH: Stochastic Approximation Expectation-Maximization (No Prior)
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               SLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            528
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
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      100
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     100
 NOPRIOR SETTING (NOPRIOR):                 ON
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): wexample10_saem.ext
 EXCLUDE TITLE (NOTITLE):                   NO
 EXCLUDE COLUMN LABELS (NOLABEL):           NO
 FORMAT FOR ADDITIONAL FILES (FORMAT):      S1PE12.5
 PARAMETER ORDER FOR OUTPUTS (ORDER):       TSOL
 WISHART PRIOR DF INTERPRETATION (WISHTYPE):0
 KNUTHSUMOFF:                               0
 INCLUDE LNTWOPI:                           NO
 INCLUDE CONSTANT TERM TO PRIOR (PRIORC):   NO
 INCLUDE CONSTANT TERM TO OMEGA (ETA) (OLNTWOPI):NO
 EM OR BAYESIAN METHOD USED:                STOCHASTIC APPROXIMATION EXPECTATION MAXIMIZATION (SAEM)
 MU MODELING PATTERN (MUM):
 GRADIENT/GIBBS PATTERN (GRD):
 AUTOMATIC SETTING FEATURE (AUTO):          ON
 CONVERGENCE TYPE (CTYPE):                  3
 CONVERGENCE INTERVAL (CINTERVAL):          0
 CONVERGENCE ITERATIONS (CITER):            10
 CONVERGENCE ALPHA ERROR (CALPHA):          5.000000000000000E-02
 BURN-IN ITERATIONS (NBURN):                4000
 ITERATIONS (NITER):                        300
 ANEAL SETTING (CONSTRAIN):                 1
 STARTING SEED FOR MC METHODS (SEED):       11456
 MC SAMPLES PER SUBJECT (ISAMPLE):          2
 MAXIMUM SAMPLES PER SUBJECT FOR AUTOMATIC
 ISAMPLE ADJUSTMENT (ISAMPEND):             10
 RANDOM SAMPLING METHOD (RANMETHOD):        3U
 EXPECTATION ONLY (EONLY):                  0
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

 ISAMPLE PreProcessing
 iteration         -200 SAEMOBJ=   11549.8836430711
 iteration         -190 SAEMOBJ=   5723.33434326522
 iteration         -180 SAEMOBJ=   5596.46227068900
 iteration         -170 SAEMOBJ=   5559.63545208285
 iteration         -160 SAEMOBJ=   5579.04033893557
 iteration         -150 SAEMOBJ=   5597.42204981750
 iteration         -140 SAEMOBJ=   5613.01684154957
 iteration         -130 SAEMOBJ=   5591.65898492606
 iteration         -120 SAEMOBJ=   5547.21004835527
 iteration         -110 SAEMOBJ=   5597.44719663524
 iteration         -100 SAEMOBJ=   5632.10318784485
 iteration          -90 SAEMOBJ=   5570.31369609516
 iteration          -80 SAEMOBJ=   5608.31911900583
 iteration          -70 SAEMOBJ=   5622.50211086544
 iteration          -60 SAEMOBJ=   5620.75712089344
 iteration          -50 SAEMOBJ=   5625.76259511052
 iteration          -40 SAEMOBJ=   5584.89755317050
 iteration          -30 SAEMOBJ=   5607.80583247065
 iteration          -20 SAEMOBJ=   5616.42475108664
 iteration          -10 SAEMOBJ=   5607.70242427331
 Stochastic/Burn-in Mode
 iteration        -4000 SAEMOBJ=   5715.05842058399
 iteration        -3990 SAEMOBJ=   5585.52111491218
 iteration        -3980 SAEMOBJ=   5582.36610205447
 iteration        -3970 SAEMOBJ=   5579.20790534561
 iteration        -3960 SAEMOBJ=   5614.26965996968
 CINTERVAL IS           20
 iteration        -3950 SAEMOBJ=   5587.04984292739
 iteration        -3940 SAEMOBJ=   5614.66782003754
 iteration        -3930 SAEMOBJ=   5553.93653190956
 iteration        -3920 SAEMOBJ=   5589.01277405506
 iteration        -3910 SAEMOBJ=   5591.39217087467
 iteration        -3900 SAEMOBJ=   5632.19455886575
 iteration        -3890 SAEMOBJ=   5563.30759602706
 iteration        -3880 SAEMOBJ=   5588.18220531039
 iteration        -3870 SAEMOBJ=   5578.70239305172
 iteration        -3860 SAEMOBJ=   5549.16402716661
 iteration        -3850 SAEMOBJ=   5605.24575021910
 iteration        -3840 SAEMOBJ=   5573.42096073929
 iteration        -3830 SAEMOBJ=   5593.20982633327
 iteration        -3820 SAEMOBJ=   5584.50943308497
 iteration        -3810 SAEMOBJ=   5577.67236921442
 iteration        -3800 SAEMOBJ=   5612.34814848007
 iteration        -3790 SAEMOBJ=   5598.39166374751
 iteration        -3780 SAEMOBJ=   5572.13179838574
 iteration        -3770 SAEMOBJ=   5621.16920154792
 iteration        -3760 SAEMOBJ=   5598.27746459559
 iteration        -3750 SAEMOBJ=   5572.38382318619
 iteration        -3740 SAEMOBJ=   5566.96875233500
 Convergence achieved
 Reduced Stochastic/Accumulation Mode
 iteration            0 SAEMOBJ=   5548.16097597286
 iteration           10 SAEMOBJ=   5482.41119482265
 iteration           20 SAEMOBJ=   5477.85161747334
 iteration           30 SAEMOBJ=   5476.78505300040
 iteration           40 SAEMOBJ=   5477.55646154402
 iteration           50 SAEMOBJ=   5478.48123390410
 iteration           60 SAEMOBJ=   5479.42401932147
 iteration           70 SAEMOBJ=   5480.84622824101
 iteration           80 SAEMOBJ=   5482.04690508498
 iteration           90 SAEMOBJ=   5483.31740728289
 iteration          100 SAEMOBJ=   5483.33018650023
 iteration          110 SAEMOBJ=   5484.02287041224
 iteration          120 SAEMOBJ=   5484.34860347371
 iteration          130 SAEMOBJ=   5484.26085541788
 iteration          140 SAEMOBJ=   5484.10003477171
 iteration          150 SAEMOBJ=   5484.47385480931
 iteration          160 SAEMOBJ=   5484.67560366689
 iteration          170 SAEMOBJ=   5484.60816456905
 iteration          180 SAEMOBJ=   5485.00113796013
 iteration          190 SAEMOBJ=   5484.59830294697
 iteration          200 SAEMOBJ=   5484.67425031486
 iteration          210 SAEMOBJ=   5484.58279907142
 iteration          220 SAEMOBJ=   5485.02978580447
 iteration          230 SAEMOBJ=   5484.90784613461
 iteration          240 SAEMOBJ=   5485.22863736717
 iteration          250 SAEMOBJ=   5485.48823440362
 iteration          260 SAEMOBJ=   5485.41541689280
 iteration          270 SAEMOBJ=   5485.41677775041
 iteration          280 SAEMOBJ=   5485.68796016736
 iteration          290 SAEMOBJ=   5485.84329115693
 iteration          300 SAEMOBJ=   5485.93481243597
 
 #TERM:
 STOCHASTIC PORTION WAS COMPLETED
 REDUCED STOCHASTIC PORTION WAS COMPLETED

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:         1.5027E-05  1.8180E-06  2.3704E-06
 SE:             1.4836E-02  1.5634E-02  1.6929E-02
 N:                     288         288         288
 
 P VAL.:         9.9919E-01  9.9991E-01  9.9989E-01
 
 ETASHRINKSD(%)  1.7182E+01  2.8397E+00  1.6315E+00
 ETASHRINKVR(%)  3.1412E+01  5.5988E+00  3.2364E+00
 EBVSHRINKSD(%)  1.7174E+01  2.8410E+00  1.6331E+00
 EBVSHRINKVR(%)  3.1398E+01  5.6012E+00  3.2395E+00
 EPSSHRINKSD(%)  1.3538E+01
 EPSSHRINKVR(%)  2.5243E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2880
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    5293.08595125891     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    5485.93481243597     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       10779.0207636949     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           864
 NIND*NETA*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    1587.92578537767     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    5485.93481243597     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       7073.86059781365     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 #TERE:
 Elapsed estimation  time in seconds:    91.56
 Elapsed covariance  time in seconds:     0.13
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 #OBJT:**************                        FINAL VALUE OF LIKELIHOOD FUNCTION                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     5485.935       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.12E+00  3.39E+00  2.44E+00 -6.48E-01  8.08E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        9.27E-02
 
 ETA2
+        3.47E-03  7.48E-02
 
 ETA3
+        3.74E-02  2.96E-02  8.56E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        2.28E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        3.05E-01
 
 ETA2
+        4.16E-02  2.74E-01
 
 ETA3
+        4.20E-01  3.70E-01  2.93E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.51E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                          STANDARD ERROR OF ESTIMATE (S)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         2.42E-02  1.67E-02  1.76E-02  9.98E-02  7.21E-03
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        1.09E-02
 
 ETA2
+        6.66E-03  6.44E-03
 
 ETA3
+        7.55E-03  5.18E-03  7.26E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        7.78E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        1.79E-02
 
 ETA2
+        7.94E-02  1.18E-02
 
 ETA3
+        6.18E-02  5.34E-02  1.24E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.58E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (S)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        5.84E-04
 
 TH 2
+        3.38E-05  2.80E-04
 
 TH 3
+        1.39E-04  1.18E-04  3.11E-04
 
 TH 4
+       -3.07E-05 -9.30E-05 -1.02E-04  9.96E-03
 
 TH 5
+        8.69E-06  6.71E-06  5.97E-06 -4.94E-04  5.20E-05
 
 OM11
+        8.49E-05  3.76E-06 -3.00E-06  7.61E-05 -2.82E-06  1.19E-04
 
 OM12
+        1.56E-05  5.72E-06  7.02E-06 -9.78E-05  4.61E-06  1.35E-05  4.43E-05
 
 OM13
+        2.42E-05  5.08E-06  2.27E-06 -1.96E-05  7.57E-07  6.31E-05  1.99E-05  5.70E-05
 
 OM22
+        7.87E-06 -2.48E-06  1.05E-06  3.75E-06  1.71E-06  6.42E-06  4.13E-06  5.05E-06  4.15E-05
 
 OM23
+        5.70E-06  1.28E-06  2.25E-06 -2.93E-05  3.39E-06  5.51E-06  1.55E-05  9.81E-06  1.48E-05  2.68E-05
 
 OM33
+        3.77E-06  3.34E-06  5.12E-06 -5.94E-05  1.48E-06  7.47E-06  1.26E-05  2.11E-05  3.72E-06  1.78E-05  5.27E-05
 
 SG11
+        6.76E-07  1.03E-06  2.47E-07  7.82E-07  3.05E-07  4.51E-08 -3.20E-07  1.91E-07 -6.50E-07 -6.71E-07  3.36E-07  6.06E-07
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (S)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        2.42E-02
 
 TH 2
+        8.35E-02  1.67E-02
 
 TH 3
+        3.25E-01  3.98E-01  1.76E-02
 
 TH 4
+       -1.27E-02 -5.57E-02 -5.81E-02  9.98E-02
 
 TH 5
+        4.99E-02  5.56E-02  4.69E-02 -6.87E-01  7.21E-03
 
 OM11
+        3.23E-01  2.06E-02 -1.56E-02  7.01E-02 -3.59E-02  1.09E-02
 
 OM12
+        9.72E-02  5.13E-02  5.97E-02 -1.47E-01  9.60E-02  1.86E-01  6.66E-03
 
 OM13
+        1.33E-01  4.02E-02  1.70E-02 -2.60E-02  1.39E-02  7.68E-01  3.97E-01  7.55E-03
 
 OM22
+        5.06E-02 -2.30E-02  9.24E-03  5.83E-03  3.69E-02  9.15E-02  9.63E-02  1.04E-01  6.44E-03
 
 OM23
+        4.56E-02  1.48E-02  2.47E-02 -5.67E-02  9.08E-02  9.77E-02  4.49E-01  2.51E-01  4.44E-01  5.18E-03
 
 OM33
+        2.15E-02  2.75E-02  4.00E-02 -8.19E-02  2.83E-02  9.44E-02  2.60E-01  3.86E-01  7.96E-02  4.74E-01  7.26E-03
 
 SG11
+        3.59E-02  7.90E-02  1.80E-02  1.01E-02  5.44E-02  5.32E-03 -6.16E-02  3.26E-02 -1.30E-01 -1.66E-01  5.95E-02  7.78E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        2.37E+03
 
 TH 2
+        2.31E+02  4.30E+03
 
 TH 3
+       -1.16E+03 -1.71E+03  4.40E+03
 
 TH 4
+       -6.12E+00  1.30E+01  1.85E+01  1.99E+02
 
 TH 5
+       -4.59E+02 -2.29E+02  1.74E+02  1.87E+03  3.75E+04
 
 OM11
+       -3.38E+03 -4.34E+02  1.87E+03 -1.73E+02  1.28E+02  2.91E+04
 
 OM12
+       -1.01E+03 -2.61E+02  7.36E+01  2.97E+02  1.54E+03  6.04E+03  3.45E+04
 
 OM13
+        3.39E+03  1.85E+02 -1.69E+03  1.26E+02 -3.02E+02 -3.63E+04 -1.69E+04  6.90E+04
 
 OM22
+       -2.37E+02  3.26E+02 -1.44E+02 -2.44E+01 -3.89E+02 -2.00E+02  4.61E+03 -2.18E+03  3.18E+04
 
 OM23
+        2.12E+02 -2.95E+02  2.41E+02 -3.70E+02 -5.90E+03 -1.74E+03 -2.01E+04  5.69E+03 -2.24E+04  7.61E+04
 
 OM33
+       -7.38E+02  6.86E+01  8.75E+01  2.09E+02  3.02E+03  9.41E+03  4.50E+03 -2.01E+04  5.08E+03 -2.21E+04  3.21E+04
 
 SG11
+       -3.28E+03 -6.95E+03  2.79E+03 -1.65E+03 -2.82E+04  9.00E+03  3.65E+03 -1.63E+04  9.54E+03  6.38E+04 -2.99E+04  1.78E+06
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                    EIGENVALUES OF COR MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12

 
         1.34E-01  2.75E-01  3.53E-01  5.10E-01  6.96E-01  8.14E-01  8.95E-01  1.10E+00  1.33E+00  1.58E+00  1.75E+00  2.56E+00
 
1
 
 
 #TBLN:      3
 #METH: Objective Function Evaluation by Importance Sampling (No Prior)
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               SLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    YES
 NUMERICAL 2ND DERIVATIVES:               YES
 NO. OF FUNCT. EVALS. ALLOWED:            528
 NO. OF SIG. FIGURES REQUIRED:            3
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
 ABORT WITH PRED EXIT CODE 1:             NO
 IND. OBJ. FUNC. VALUES SORTED:           NO
 NUMERICAL DERIVATIVE
       FILE REQUEST (NUMDER):               NONE
 MAP (ETAHAT) ESTIMATION METHOD (OPTMAP):   0
 ETA HESSIAN EVALUATION METHOD (ETADER):    0
 INITIAL ETA FOR MAP ESTIMATION (MCETA):    3
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      100
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     100
 NOPRIOR SETTING (NOPRIOR):                 ON
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): wexample10_saem.ext
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
 ITERATIONS (NITER):                        5
 ANEAL SETTING (CONSTRAIN):                 1
 STARTING SEED FOR MC METHODS (SEED):       11456
 MC SAMPLES PER SUBJECT (ISAMPLE):          1000
 MAXIMUM SAMPLES PER SUBJECT FOR AUTOMATIC
 ISAMPLE ADJUSTMENT (ISAMPEND):             10000
 RANDOM SAMPLING METHOD (RANMETHOD):        3U
 EXPECTATION ONLY (EONLY):                  1
 PROPOSAL DENSITY SCALING RANGE
              (ISCALE_MIN, ISCALE_MAX):     0.100000000000000       ,10.0000000000000
 SAMPLE ACCEPTANCE RATE (IACCEPT):          1.00000000000000
 LONG TAIL SAMPLE ACCEPT. RATE (IACCEPTL):   0.00000000000000
 T-DIST. PROPOSAL DENSITY (DF):             4
 NO. ITERATIONS FOR MAP (MAPITER):          1
 INTERVAL ITER. FOR MAP (MAPINTER):         0
 MAP COVARIANCE/MODE SETTING (MAPCOV):      1
 Gradient Quick Value (GRDQ):               0.00000000000000
 STOCHASTIC OBJ VARIATION TOLERANCE FOR
 AUTOMATIC ISAMPLE ADJUSTMENT (STDOBJ):     1.00000000000000

 
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

 iteration            0 OBJ=   10021.6668988477 eff.=     853. Smpl.=    1000. Fit.= 0.96856
 iteration            1 OBJ=   10020.8878664836 eff.=     938. Smpl.=    1000. Fit.= 0.95423
 iteration            2 OBJ=   10021.4379642190 eff.=     976. Smpl.=    1000. Fit.= 0.95090
 iteration            3 OBJ=   10022.1796139042 eff.=     974. Smpl.=    1000. Fit.= 0.95079
 iteration            4 OBJ=   10021.5916384028 eff.=     973. Smpl.=    1000. Fit.= 0.95080
 iteration            5 OBJ=   10022.2416102336 eff.=     975. Smpl.=    1000. Fit.= 0.95075
 
 #TERM:
 EXPECTATION ONLY PROCESS COMPLETED


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:         8.3154E-04 -9.3510E-05 -9.0099E-05
 SE:             1.4807E-02  1.5613E-02  1.6923E-02
 N:                     288         288         288
 
 P VAL.:         9.5522E-01  9.9522E-01  9.9575E-01
 
 ETASHRINKSD(%)  1.7342E+01  2.9675E+00  1.6644E+00
 ETASHRINKVR(%)  3.1676E+01  5.8469E+00  3.3011E+00
 EBVSHRINKSD(%)  1.7354E+01  2.8540E+00  1.6420E+00
 EBVSHRINKVR(%)  3.1697E+01  5.6265E+00  3.2570E+00
 EPSSHRINKSD(%)  1.3500E+01
 EPSSHRINKVR(%)  2.5178E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2880
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    5293.08595125891     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    10022.2416102336     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       15315.3275614925     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           864
  
 #TERE:
 Elapsed estimation  time in seconds:    14.51
 Elapsed covariance  time in seconds:    71.88
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************    10022.242       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.12E+00  3.39E+00  2.44E+00 -6.48E-01  8.08E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        9.27E-02
 
 ETA2
+        3.47E-03  7.48E-02
 
 ETA3
+        3.74E-02  2.96E-02  8.56E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        2.28E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        3.05E-01
 
 ETA2
+        4.16E-02  2.74E-01
 
 ETA3
+        4.20E-01  3.70E-01  2.93E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.51E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                          STANDARD ERROR OF ESTIMATE (R)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         2.24E-02  1.66E-02  1.75E-02  9.50E-02  6.17E-03
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        1.17E-02
 
 ETA2
+        6.27E-03  6.65E-03
 
 ETA3
+        7.02E-03  5.34E-03  7.39E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        7.19E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        1.92E-02
 
 ETA2
+        7.49E-02  1.22E-02
 
 ETA3
+        6.33E-02  5.30E-02  1.26E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.38E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (R)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        5.02E-04
 
 TH 2
+        3.00E-05  2.76E-04
 
 TH 3
+        1.39E-04  1.16E-04  3.08E-04
 
 TH 4
+        2.03E-06 -1.19E-06 -5.97E-07  9.03E-03
 
 TH 5
+        1.73E-06  1.05E-06  8.65E-07 -3.61E-04  3.81E-05
 
 OM11
+        3.91E-05 -1.07E-06 -9.47E-07  6.35E-07  3.86E-08  1.37E-04
 
 OM12
+        4.05E-06  4.21E-07  5.05E-07 -6.35E-08  1.83E-08  6.87E-06  3.93E-05
 
 OM13
+        6.47E-06 -1.34E-06 -1.11E-06  1.24E-06 -1.39E-07  3.98E-05  1.79E-05  4.93E-05
 
 OM22
+        2.23E-06  3.68E-07 -1.44E-08 -8.41E-07  1.84E-07  7.31E-07  4.54E-06  2.04E-06  4.42E-05
 
 OM23
+       -4.91E-07 -2.49E-07 -6.21E-09 -1.01E-07  5.09E-08  2.30E-06  1.19E-05  7.06E-06  1.86E-05  2.85E-05
 
 OM33
+       -1.59E-06  9.29E-08  2.70E-07  1.59E-07 -4.72E-08  1.06E-05  9.22E-06  2.42E-05  7.86E-06  2.05E-05  5.46E-05
 
 SG11
+        2.36E-07  4.34E-07  3.73E-07 -6.48E-10  3.00E-08 -7.26E-07 -7.90E-08 -3.64E-08 -9.05E-08 -7.79E-08 -5.44E-08  5.17E-07
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (R)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        2.24E-02
 
 TH 2
+        8.05E-02  1.66E-02
 
 TH 3
+        3.55E-01  3.96E-01  1.75E-02
 
 TH 4
+        9.54E-04 -7.52E-04 -3.58E-04  9.50E-02
 
 TH 5
+        1.25E-02  1.02E-02  7.99E-03 -6.17E-01  6.17E-03
 
 OM11
+        1.49E-01 -5.48E-03 -4.61E-03  5.71E-04  5.34E-04  1.17E-02
 
 OM12
+        2.88E-02  4.04E-03  4.59E-03 -1.06E-04  4.72E-04  9.34E-02  6.27E-03
 
 OM13
+        4.11E-02 -1.14E-02 -9.01E-03  1.86E-03 -3.20E-03  4.84E-01  4.05E-01  7.02E-03
 
 OM22
+        1.50E-02  3.32E-03 -1.24E-04 -1.33E-03  4.49E-03  9.39E-03  1.09E-01  4.36E-02  6.65E-03
 
 OM23
+       -4.11E-03 -2.80E-03 -6.63E-05 -1.99E-04  1.54E-03  3.67E-02  3.56E-01  1.88E-01  5.23E-01  5.34E-03
 
 OM33
+       -9.64E-03  7.57E-04  2.08E-03  2.27E-04 -1.04E-03  1.22E-01  1.99E-01  4.66E-01  1.60E-01  5.21E-01  7.39E-03
 
 SG11
+        1.46E-02  3.63E-02  2.96E-02 -9.48E-06  6.77E-03 -8.61E-02 -1.75E-02 -7.21E-03 -1.89E-02 -2.03E-02 -1.02E-02  7.19E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (R)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        2.36E+03
 
 TH 2
+        2.29E+02  4.32E+03
 
 TH 3
+       -1.15E+03 -1.72E+03  4.42E+03
 
 TH 4
+       -6.34E+00 -5.02E+00  4.47E-01  1.79E+02
 
 TH 5
+       -1.44E+02 -1.35E+02  3.15E+00  1.70E+03  4.24E+04
 
 OM11
+       -7.85E+02 -1.07E+02  3.66E+02 -2.94E-01 -2.86E+01  1.02E+04
 
 OM12
+       -3.25E+02 -1.56E+02  8.26E+01  4.89E-01 -4.61E+01  2.75E+03  3.59E+04
 
 OM13
+        3.66E+02  2.14E+02 -6.94E+01  5.82E-01  1.36E+02 -1.02E+04 -1.61E+04  4.13E+04
 
 OM22
+       -2.06E+02 -1.11E+02  1.17E+02 -2.81E+00 -1.42E+02  2.29E+02  3.62E+03 -1.62E+03  3.23E+04
 
 OM23
+        2.40E+02  2.01E+02 -9.51E+01 -2.57E+00  2.42E+00 -1.42E+03 -1.86E+04  1.09E+04 -2.58E+04  7.60E+04
 
 OM33
+        5.65E+01 -1.03E+02 -8.84E+01  1.76E+00 -1.95E+00  2.56E+03  7.01E+03 -1.75E+04  5.13E+03 -2.63E+04  3.36E+04
 
 SG11
+       -1.55E+03 -2.64E+03 -6.98E+02 -9.25E+01 -2.35E+03  1.43E+04  6.99E+03 -1.46E+04  3.16E+03 -1.05E+02  4.02E+03  1.96E+06
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                    EIGENVALUES OF COR MATRIX OF ESTIMATE (R)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12

 
         2.32E-01  3.83E-01  4.19E-01  5.01E-01  7.64E-01  8.35E-01  9.34E-01  1.02E+00  1.39E+00  1.58E+00  1.62E+00  2.32E+00
 
 Elapsed postprocess time in seconds:     0.05
 Elapsed finaloutput time in seconds:     0.37
 #CPUT: Total CPU Time in Seconds,      171.211
Stop Time: 
Tue 03/12/2019 
10:22 AM
