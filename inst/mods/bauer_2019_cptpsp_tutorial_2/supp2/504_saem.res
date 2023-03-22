Tue 03/12/2019 
10:07 AM
$PROB Phase IIa Study, One Compartment Model 504m.ctl
; Place column names of data file here:
$INPUT C ID TIME DV AMT RATE WT AGE SEX 
$DATA 501.csv IGNORE=C ; Ignore records beginning with letter C
; Select One compartment model ADVAN1, Parameterization TRANS2 (CL, V)
$SUBROUTINE ADVAN1 TRANS2 
; Section to define PK parameters, relationship to fixed effects THETA
; and inter-subject random effects ETA.
$PK 
; Define typical values
  LTVCL=THETA(1)+LOG(WT/70)*THETA(3)+LOG(AGE/50)*THETA(5)+SEX*THETA(7)
  LTVV=THETA(2)+LOG(WT/70)*THETA(4)+LOG(AGE/50)*THETA(6)+SEX*THETA(8)
  MU_1=LTVCL
  MU_2=LTVV
  CL=EXP(MU_1+ETA(1))
  V=EXP(MU_2+ETA(2))
  S1=V

$THETA ; Enter initial starting values for THETAS
  0.7    ;[LCL]
  3.0    ;[LV]
  0.8    ;[CL~WT]
  0.8    ;[V~WT]
  -0.1   ;[CL~AGE]
  0.1    ;[V~AGE]
  0.7    ;[CL~SEX]
  0.7    ;[V~SEX]

; Section to relate predicted function F and residual error
; relationship to data DV.  EPS are random error coefficients
$ERROR 
  IPRE=A(1)/V
  Y=IPRE*(1+EPS(1))

$OMEGA BLOCK(2) ; Initial OMEGA values in lower triangular format
  0.1         ;[P]
  0.001 0.1   ;[P]
$SIGMA ; Initial SIGMA
  0.04        ;[P]

$EST METHOD=SAEM AUTO=1 NITER=500 PRINT=20
$EST METHOD=IMP EONLY=1 PRINT=1 NITER=5 ISAMPLE=1000 MAPITER=0
$COV UNCONDITIONAL MATRIX=R PRINT=E
; Print out individual predicted results 
; Various parameters and built in diagnostics may be printed.
; DV=DEPENDENT VARIABLE
; IPRE=individual predicted function, at mode of posterior
; CIPRED=individual predicted function at mean of posterior 
; (because Monte Carlo EM was last estimation performed)
; CIRES=DV-CIPRED
; CIWRES=conditional individual residual
; (CIRES/SQRT(SIGMA(1,1)*CIPRED)
; PRED=Population Predicted value F(ETA=0)
; CWRES=Conditional population weighted Residual
; Note numerical Format may be specified for table outputs
$TABLE ID TIME DV IPRE CIPRED CIRES CIWRES PRED RES CWRES CL V ETA1 ETA2
       NOPRINT NOAPPEND ONEHEADER FORMAT=,1PE13.6 FILE=504_saem.tab

  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
             
 (WARNING  121) INTERACTION IS IMPLIED WITH EM/BAYES ESTIMATION METHODS

 (MU_WARNING 26) DATA ITEM(S) USED IN DEFINITION OF MU_(S) SHOULD BE CONSTANT FOR INDIV. REC.:
  WT AGE SEX
  
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
 Phase IIa Study, One Compartment Model 504m.ctl
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:      300
 NO. OF DATA ITEMS IN DATA SET:  11
 ID DATA ITEM IS DATA ITEM NO.:   2
 DEP VARIABLE IS DATA ITEM NO.:   4
 MDV DATA ITEM IS DATA ITEM NO.: 11
0INDICES PASSED TO SUBROUTINE PRED:
  10   3   5   6   0   0   0   0   0   0   0
0LABELS FOR DATA ITEMS:
 C ID TIME DV AMT RATE WT AGE SEX EVID MDV
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 CL V IPRE
0FORMAT FOR DATA:
 (9E7.0,2F2.0)

 TOT. NO. OF OBS RECS:      240
 TOT. NO. OF INDIVIDUALS:       60
0LENGTH OF THETA:   8
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS BLOCK FORM:
  1
  1  1
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   1
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
   0.7000E+00  0.3000E+01  0.8000E+00  0.8000E+00 -0.1000E+00  0.1000E+00  0.7000E+00  0.7000E+00
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.1000E+00
                  0.1000E-02   0.1000E+00
0INITIAL ESTIMATE OF SIGMA:
 0.4000E-01
0COVARIANCE STEP OMITTED:        NO
 R MATRIX SUBSTITUTED:          YES
 S MATRIX SUBSTITUTED:           NO
 EIGENVLS. PRINTED:             YES
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
 HEADER:                YES
 FILE TO BE FORWARDED:   NO
 FORMAT:                ,1PE13.6
 LFORMAT:
 RFORMAT:
 FIXED_EFFECT_ETAS:
0USER-CHOSEN ITEMS:
 ID TIME DV IPRE CIPRED CIRES CIWRES PRED RES CWRES CL V ETA1 ETA2
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
   EVENT ID DATA ITEM IS DATA ITEM NO.:     10
   TIME DATA ITEM IS DATA ITEM NO.:          3
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   5
   DOSE RATE DATA ITEM IS DATA ITEM NO.:     6

0PK SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 PK SUBROUTINE NOT CALLED AT NONEVENT (ADDITIONAL OR LAGGED) DOSE TIMES.
0ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
0ERROR SUBROUTINE INDICATES THAT DERIVATIVES OF COMPARTMENT AMOUNTS ARE USED.
1
 
 
 #TBLN:      1
 #METH: Stochastic Approximation Expectation-Maximization (No Prior)
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            728
 NO. OF SIG. FIGURES REQUIRED:            3
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
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
 RAW OUTPUT FILE (FILE): 504_saem.ext
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
 ITERATIONS (NITER):                        500
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
   1   2   3   4   5   6   7   8
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 ISAMPLE PreProcessing
 iteration         -200 SAEMOBJ=   1194.90938119594
 iteration         -180 SAEMOBJ=   619.252332131612
 iteration         -160 SAEMOBJ=   619.357969048837
 iteration         -140 SAEMOBJ=   598.890741653527
 iteration         -120 SAEMOBJ=   613.514265882579
 iteration         -100 SAEMOBJ=   610.272825847206
 iteration          -80 SAEMOBJ=   618.170875324060
 iteration          -60 SAEMOBJ=   599.386251369353
 iteration          -40 SAEMOBJ=   623.467530540747
 iteration          -20 SAEMOBJ=   620.646491258508
 Stochastic/Burn-in Mode
 iteration        -4000 SAEMOBJ=   634.418949162971
 iteration        -3980 SAEMOBJ=   617.072127949831
 iteration        -3960 SAEMOBJ=   617.014538330162
 CINTERVAL IS           30
 iteration        -3940 SAEMOBJ=   620.371068480838
 iteration        -3920 SAEMOBJ=   616.970949933415
 iteration        -3900 SAEMOBJ=   590.969084517894
 iteration        -3880 SAEMOBJ=   602.861661220261
 iteration        -3860 SAEMOBJ=   615.304259658480
 iteration        -3840 SAEMOBJ=   603.814734673470
 iteration        -3820 SAEMOBJ=   609.567220625788
 iteration        -3800 SAEMOBJ=   616.845890879655
 iteration        -3780 SAEMOBJ=   620.339179833797
 iteration        -3760 SAEMOBJ=   611.334469229204
 iteration        -3740 SAEMOBJ=   603.720431370418
 iteration        -3720 SAEMOBJ=   604.002213327200
 iteration        -3700 SAEMOBJ=   620.676330507602
 iteration        -3680 SAEMOBJ=   619.934217315172
 iteration        -3660 SAEMOBJ=   610.446493956243
 iteration        -3640 SAEMOBJ=   598.900394815818
 Convergence achieved
 iteration        -3630 SAEMOBJ=   613.515164991287
 Reduced Stochastic/Accumulation Mode
 iteration            0 SAEMOBJ=   605.262007292092
 iteration           20 SAEMOBJ=   597.662576404380
 iteration           40 SAEMOBJ=   597.034781662330
 iteration           60 SAEMOBJ=   596.893754342296
 iteration           80 SAEMOBJ=   597.166455624146
 iteration          100 SAEMOBJ=   597.165588313947
 iteration          120 SAEMOBJ=   597.599012017365
 iteration          140 SAEMOBJ=   597.603262375546
 iteration          160 SAEMOBJ=   597.778355893528
 iteration          180 SAEMOBJ=   598.080413428887
 iteration          200 SAEMOBJ=   598.082144505339
 iteration          220 SAEMOBJ=   598.184198030282
 iteration          240 SAEMOBJ=   598.126404592652
 iteration          260 SAEMOBJ=   598.232586151603
 iteration          280 SAEMOBJ=   598.266964302002
 iteration          300 SAEMOBJ=   598.310208778955
 iteration          320 SAEMOBJ=   598.394719667777
 iteration          340 SAEMOBJ=   598.379112245604
 iteration          360 SAEMOBJ=   598.420941435635
 iteration          380 SAEMOBJ=   598.466870587540
 iteration          400 SAEMOBJ=   598.559107481164
 iteration          420 SAEMOBJ=   598.513292918404
 iteration          440 SAEMOBJ=   598.531128884980
 iteration          460 SAEMOBJ=   598.550552656684
 iteration          480 SAEMOBJ=   598.510542135676
 iteration          500 SAEMOBJ=   598.612465409674
 
 #TERM:
 STOCHASTIC PORTION WAS COMPLETED
 REDUCED STOCHASTIC PORTION WAS COMPLETED

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -3.5237E-06  1.2085E-05
 SE:             1.7702E-02  2.3465E-02
 N:                      60          60
 
 P VAL.:         9.9984E-01  9.9959E-01
 
 ETASHRINKSD(%)  1.9564E+01  1.7915E+01
 ETASHRINKVR(%)  3.5301E+01  3.2621E+01
 EBVSHRINKSD(%)  1.9558E+01  1.7902E+01
 EBVSHRINKVR(%)  3.5291E+01  3.2599E+01
 EPSSHRINKSD(%)  1.7464E+01
 EPSSHRINKVR(%)  3.1878E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):          240
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    441.090495938243     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    598.612465409674     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       1039.70296134792     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           120
 NIND*NETA*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    220.545247969121     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    598.612465409674     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       819.157713378796     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 #TERE:
 Elapsed estimation  time in seconds:     8.19
 Elapsed covariance  time in seconds:     0.27
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 #OBJT:**************                        FINAL VALUE OF LIKELIHOOD FUNCTION                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************      598.612       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         1.07E+00  3.47E+00  6.44E-01  1.31E+00 -5.44E-01  6.01E-02 -1.01E-01 -5.67E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        2.96E-02
 
 ETA2
+        2.99E-04  4.99E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        4.99E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        1.72E-01
 
 ETA2
+        7.78E-03  2.23E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.23E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                          STANDARD ERROR OF ESTIMATE (S)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         4.88E-02  4.56E-02  1.96E-01  2.63E-01  1.33E-01  1.55E-01  6.26E-02  8.44E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        8.67E-03
 
 ETA2
+        1.05E-02  1.65E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        6.71E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        2.52E-02
 
 ETA2
+        2.73E-01  3.69E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.50E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (S)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        2.38E-03
 
 TH 2
+        5.05E-04  2.08E-03
 
 TH 3
+       -4.22E-03 -2.24E-03  3.84E-02
 
 TH 4
+       -3.93E-03 -3.02E-03  6.91E-03  6.90E-02
 
 TH 5
+        1.21E-03  1.20E-03 -7.19E-03 -7.85E-03  1.76E-02
 
 TH 6
+        8.36E-04  5.60E-04 -5.47E-03  5.32E-03  2.28E-03  2.41E-02
 
 TH 7
+       -1.91E-03 -3.45E-04 -9.50E-04  4.91E-03 -2.20E-03  9.89E-05  3.91E-03
 
 TH 8
+       -1.67E-04 -1.82E-03  1.93E-03 -1.99E-03 -5.07E-04  7.46E-04  5.17E-04  7.12E-03
 
 OM11
+       -6.07E-05 -8.56E-05  2.55E-04  3.03E-04 -3.85E-04 -1.09E-04  9.03E-05  2.40E-05  7.52E-05
 
 OM12
+       -4.56E-05 -2.40E-05 -2.61E-05  1.59E-05 -5.36E-05  4.39E-04  4.71E-05  7.31E-05  2.06E-05  1.10E-04
 
 OM22
+       -8.45E-05 -1.78E-04 -9.57E-05  6.23E-04  1.73E-04 -2.97E-04  8.78E-05  1.41E-04  3.10E-05  4.42E-05  2.72E-04
 
 SG11
+        6.72E-05  5.12E-05  1.88E-05 -4.43E-04  2.53E-04  3.43E-05 -1.13E-04  3.19E-05 -2.35E-05 -6.33E-06 -1.36E-05  4.50E-05
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (S)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        4.88E-02
 
 TH 2
+        2.27E-01  4.56E-02
 
 TH 3
+       -4.41E-01 -2.51E-01  1.96E-01
 
 TH 4
+       -3.07E-01 -2.52E-01  1.34E-01  2.63E-01
 
 TH 5
+        1.87E-01  1.98E-01 -2.76E-01 -2.25E-01  1.33E-01
 
 TH 6
+        1.10E-01  7.90E-02 -1.80E-01  1.31E-01  1.11E-01  1.55E-01
 
 TH 7
+       -6.24E-01 -1.21E-01 -7.75E-02  2.99E-01 -2.65E-01  1.02E-02  6.26E-02
 
 TH 8
+       -4.05E-02 -4.74E-01  1.17E-01 -8.97E-02 -4.53E-02  5.69E-02  9.79E-02  8.44E-02
 
 OM11
+       -1.44E-01 -2.16E-01  1.50E-01  1.33E-01 -3.35E-01 -8.07E-02  1.67E-01  3.28E-02  8.67E-03
 
 OM12
+       -8.90E-02 -5.01E-02 -1.27E-02  5.78E-03 -3.85E-02  2.69E-01  7.17E-02  8.24E-02  2.27E-01  1.05E-02
 
 OM22
+       -1.05E-01 -2.37E-01 -2.96E-02  1.44E-01  7.90E-02 -1.16E-01  8.51E-02  1.01E-01  2.17E-01  2.55E-01  1.65E-02
 
 SG11
+        2.05E-01  1.67E-01  1.43E-02 -2.51E-01  2.84E-01  3.29E-02 -2.69E-01  5.64E-02 -4.04E-01 -8.99E-02 -1.23E-01  6.71E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        1.29E+03
 
 TH 2
+       -1.12E+02  7.99E+02
 
 TH 3
+        1.71E+02  7.90E+00  5.52E+01
 
 TH 4
+        7.90E+00  3.21E+01 -2.89E+00  2.04E+01
 
 TH 5
+        7.82E+01 -2.16E+01  2.14E+01  4.74E+00  8.39E+01
 
 TH 6
+       -2.16E+01 -1.59E+01  4.74E+00 -8.77E+00 -7.90E+00  5.34E+01
 
 TH 7
+        6.95E+02 -8.72E+01  1.11E+02 -1.68E+01  7.31E+01 -4.61E+00  6.95E+02
 
 TH 8
+       -8.72E+01  2.11E+02 -1.68E+01  1.72E+01 -4.61E+00 -1.37E+01 -8.72E+01  2.11E+02
 
 OM11
+       -4.67E+02  3.53E+02 -1.32E+02  2.80E+01  2.38E+02  5.44E+01 -3.03E+02  1.15E+02  1.90E+04
 
 OM12
+        4.62E+02 -1.32E+02  3.52E+01  5.88E+01  6.84E+01 -2.72E+02  1.68E+02 -6.49E+01 -2.75E+03  1.16E+04
 
 OM22
+        6.78E+01  2.93E+02  4.82E+01 -4.87E+01 -1.26E+02  1.14E+02  1.90E+01 -4.16E+01 -1.42E+03 -2.00E+03  4.73E+03
 
 SG11
+       -5.73E+02 -4.10E+02 -1.99E+02  8.74E+01 -2.38E+02 -1.13E+01  1.20E+02 -2.28E+02  7.50E+03 -9.28E+01  1.75E+02  3.02E+04
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                    EIGENVALUES OF COR MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12

 
         1.54E-01  3.68E-01  4.41E-01  5.15E-01  6.30E-01  9.09E-01  9.87E-01  1.07E+00  1.23E+00  1.45E+00  1.47E+00  2.77E+00
 
1
 
 
 #TBLN:      2
 #METH: Objective Function Evaluation by Importance Sampling (No Prior)
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            728
 NO. OF SIG. FIGURES REQUIRED:            3
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
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
 RAW OUTPUT FILE (FILE): 504_saem.ext
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
 SAMPLE ACCEPTANCE RATE (IACCEPT):          0.00000000000000
 LONG TAIL SAMPLE ACCEPT. RATE (IACCEPTL):   0.00000000000000
 T-DIST. PROPOSAL DENSITY (DF):             0
 NO. ITERATIONS FOR MAP (MAPITER):          0
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
   1   2   3   4   5   6   7   8
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 iteration            0 OBJ=   1051.65693334396 eff.=     956. Smpl.=    1000. Fit.= 0.93660
 iteration            1 OBJ=   1051.59415043032 eff.=     337. Smpl.=    1000. Fit.= 0.77186
 iteration            2 OBJ=   1051.73067295632 eff.=     369. Smpl.=    1000. Fit.= 0.78933
 iteration            3 OBJ=   1051.86111235517 eff.=     423. Smpl.=    1000. Fit.= 0.81778
 iteration            4 OBJ=   1051.68910386920 eff.=     469. Smpl.=    1000. Fit.= 0.83575
 iteration            5 OBJ=   1051.79039544044 eff.=     493. Smpl.=    1000. Fit.= 0.84692
 
 #TERM:
 EXPECTATION ONLY PROCESS COMPLETED


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -4.5219E-04  4.8053E-04
 SE:             1.7746E-02  2.3341E-02
 N:                      60          60
 
 P VAL.:         9.7967E-01  9.8357E-01
 
 ETASHRINKSD(%)  1.9364E+01  1.8350E+01
 ETASHRINKVR(%)  3.4978E+01  3.3333E+01
 EBVSHRINKSD(%)  1.9869E+01  1.7983E+01
 EBVSHRINKVR(%)  3.5790E+01  3.2732E+01
 EPSSHRINKSD(%)  1.7372E+01
 EPSSHRINKVR(%)  3.1726E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):          240
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    441.090495938243     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    1051.79039544044     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       1492.88089137869     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           120
  
 #TERE:
 Elapsed estimation  time in seconds:     1.32
 Elapsed covariance  time in seconds:     0.52
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     1051.790       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         1.07E+00  3.47E+00  6.44E-01  1.31E+00 -5.44E-01  6.01E-02 -1.01E-01 -5.67E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        2.96E-02
 
 ETA2
+        2.99E-04  4.99E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        4.99E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        1.72E-01
 
 ETA2
+        7.78E-03  2.23E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.23E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                          STANDARD ERROR OF ESTIMATE (R)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         3.87E-02  4.98E-02  1.63E-01  2.08E-01  1.05E-01  1.33E-01  5.78E-02  7.31E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        9.26E-03
 
 ETA2
+        7.83E-03  1.42E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        6.52E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        2.69E-02
 
 ETA2
+        2.04E-01  3.18E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.46E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (R)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        1.50E-03
 
 TH 2
+        2.30E-04  2.48E-03
 
 TH 3
+       -9.01E-04 -3.30E-04  2.64E-02
 
 TH 4
+       -3.12E-04 -1.85E-03  3.55E-03  4.31E-02
 
 TH 5
+        1.32E-04 -8.30E-05 -1.34E-03 -2.99E-04  1.10E-02
 
 TH 6
+       -5.79E-05  1.15E-04 -3.36E-04 -2.86E-03  1.93E-03  1.76E-02
 
 TH 7
+       -1.37E-03 -1.94E-04 -2.09E-03 -3.21E-04  7.88E-04 -1.42E-04  3.35E-03
 
 TH 8
+       -1.82E-04 -2.23E-03 -3.24E-04 -3.41E-03 -1.37E-04  1.03E-03  4.23E-04  5.34E-03
 
 OM11
+       -1.42E-05  1.22E-05  1.77E-05  4.60E-05  4.04E-05 -9.03E-06  1.74E-05 -1.30E-05  8.58E-05
 
 OM12
+        3.03E-05 -9.43E-06  5.35E-05  3.72E-05  2.56E-05 -1.45E-05 -1.66E-05 -3.81E-06  9.31E-06  6.13E-05
 
 OM22
+       -3.30E-05  3.70E-05 -1.72E-06  3.26E-05 -2.93E-05 -3.18E-05  8.88E-06 -6.20E-05  9.25E-06  1.99E-05  2.01E-04
 
 SG11
+        1.97E-05  1.77E-05 -1.36E-05 -2.49E-05 -1.94E-05  1.48E-05 -9.96E-06  1.60E-05 -1.71E-05 -4.23E-06 -1.86E-05  4.25E-05
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (R)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        3.87E-02
 
 TH 2
+        1.20E-01  4.98E-02
 
 TH 3
+       -1.43E-01 -4.08E-02  1.63E-01
 
 TH 4
+       -3.88E-02 -1.79E-01  1.05E-01  2.08E-01
 
 TH 5
+        3.25E-02 -1.59E-02 -7.85E-02 -1.37E-02  1.05E-01
 
 TH 6
+       -1.13E-02  1.74E-02 -1.56E-02 -1.04E-01  1.39E-01  1.33E-01
 
 TH 7
+       -6.11E-01 -6.72E-02 -2.23E-01 -2.67E-02  1.30E-01 -1.85E-02  5.78E-02
 
 TH 8
+       -6.43E-02 -6.14E-01 -2.73E-02 -2.25E-01 -1.79E-02  1.06E-01  1.00E-01  7.31E-02
 
 OM11
+       -3.96E-02  2.64E-02  1.18E-02  2.39E-02  4.16E-02 -7.34E-03  3.24E-02 -1.92E-02  9.26E-03
 
 OM12
+        1.00E-01 -2.42E-02  4.21E-02  2.29E-02  3.11E-02 -1.39E-02 -3.66E-02 -6.66E-03  1.28E-01  7.83E-03
 
 OM22
+       -6.01E-02  5.25E-02 -7.45E-04  1.11E-02 -1.97E-02 -1.69E-02  1.08E-02 -5.99E-02  7.04E-02  1.79E-01  1.42E-02
 
 SG11
+        7.80E-02  5.47E-02 -1.28E-02 -1.84E-02 -2.83E-02  1.71E-02 -2.64E-02  3.37E-02 -2.82E-01 -8.28E-02 -2.01E-01  6.52E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (R)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        1.31E+03
 
 TH 2
+       -1.12E+02  8.11E+02
 
 TH 3
+        8.88E+01 -8.74E-01  4.65E+01
 
 TH 4
+       -8.74E-01  6.27E+01 -2.73E+00  2.98E+01
 
 TH 5
+       -5.14E+01  1.99E+01 -1.99E-01  1.36E+00  9.77E+01
 
 TH 6
+        1.99E+01 -2.01E+01  1.36E+00  1.61E+00 -1.21E+01  5.99E+01
 
 TH 7
+        5.97E+02 -4.68E+01  6.50E+01 -1.49E+00 -4.52E+01  1.58E+01  5.97E+02
 
 TH 8
+       -4.68E+01  3.83E+02 -1.49E+00  4.49E+01  1.58E+01 -1.96E+01 -4.68E+01  3.83E+02
 
 OM11
+        9.43E+01 -2.19E+02 -3.22E+00 -2.48E+01 -3.96E+01  8.13E+00 -1.79E+01 -8.96E+01  1.29E+04
 
 OM12
+       -6.64E+02  1.76E+02 -7.15E+01 -8.00E-01 -2.31E+01  3.31E+00 -2.05E+02  4.79E+01 -1.69E+03  1.75E+04
 
 OM22
+        2.21E+02 -1.12E+02  1.85E+01 -4.51E+00  1.43E+01  6.21E+00  7.43E+01  7.28E+00  7.05E+01 -1.74E+03  5.40E+03
 
 SG11
+       -3.34E+02 -5.08E+02 -1.26E+01 -3.84E+01  3.64E+01 -8.49E+00 -1.01E+02 -2.82E+02  5.08E+03  4.43E+02  2.18E+03  2.70E+04
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                    EIGENVALUES OF COR MATRIX OF ESTIMATE (R)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12

 
         2.43E-01  2.94E-01  6.57E-01  7.89E-01  8.62E-01  9.76E-01  1.03E+00  1.06E+00  1.30E+00  1.42E+00  1.56E+00  1.81E+00
 
 Elapsed postprocess time in seconds:     0.02
 Elapsed finaloutput time in seconds:     0.14
 #CPUT: Total CPU Time in Seconds,        9.142
Stop Time: 
Tue 03/12/2019 
10:07 AM
