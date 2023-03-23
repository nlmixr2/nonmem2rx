Tue 03/12/2019 
10:08 AM
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

$EST METHOD=ITS INTERACTION AUTO=1 PRINT=20 NOABORT
$COV UNCONDITIONAL PRINT=E
; Print out individual predicted results 
; Various parameters and built in diagnostics may be printed.
; DV=DEPENDENT VARIABLE
; CIPRED=individual predicted function, f(eta_hat), at mode of
; posterior density, because ITS performs estimations at mode
; CIRES=DV-F(ETA_HAT)
; CIWRES=conditional individual residual
; (DV-F(ETA_HAT)/SQRT(SIGMA(1,1)*F(ETA_HAT))
; PRED=Population Predicted value F(ETA=0)
; CWRES=conditional Population weighted Residual
; Note numerical Format may be specified for table outputs
$TABLE ID TIME DV IPRE CIPRED CIRES CIWRES PRED RES CWRES CL V ETA1 ETA2
       NOPRINT NOAPPEND ONEHEADER FORMAT=,1PE13.6 FILE=504_its.tab

  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.

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
 EIGENVLS. PRINTED:             YES
 SPECIAL COMPUTATION:            NO
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
 #METH: Iterative Two Stage (No Prior)
 
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
 RAW OUTPUT FILE (FILE): 504_its.ext
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
   1   2   3   4   5   6   7   8
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 iteration            0 OBJ=   1251.46390423190
 iteration           20 OBJ=   1058.54245116462
 Convergence achieved
 iteration           32 OBJ=   1058.54248297433
 
 #TERM:
 OPTIMIZATION WAS COMPLETED


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -1.3995E-06 -7.2749E-07
 SE:             1.9016E-02  2.2831E-02
 N:                      60          60
 
 P VAL.:         9.9994E-01  9.9997E-01
 
 ETASHRINKSD(%)  1.6577E+01  1.7423E+01
 ETASHRINKVR(%)  3.0406E+01  3.1811E+01
 EBVSHRINKSD(%)  1.6578E+01  1.7424E+01
 EBVSHRINKVR(%)  3.0407E+01  3.1812E+01
 EPSSHRINKSD(%)  1.7046E+01
 EPSSHRINKVR(%)  3.1186E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):          240
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    441.090495938243     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    1058.54248297433     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       1499.63297891257     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           120
  
 #TERE:
 Elapsed estimation  time in seconds:     0.32
 Elapsed covariance  time in seconds:     0.18
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     1058.542       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         1.11E+00  3.46E+00  6.71E-01  1.32E+00 -5.23E-01  4.75E-02 -9.96E-02 -5.40E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        3.17E-02
 
 ETA2
+        1.34E-03  4.66E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        5.00E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        1.78E-01
 
 ETA2
+        3.49E-02  2.16E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.24E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                          STANDARD ERROR OF ESTIMATE (S)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         5.03E-02  4.38E-02  2.00E-01  2.50E-01  1.35E-01  1.49E-01  6.27E-02  8.09E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        8.27E-03
 
 ETA2
+        1.04E-02  1.54E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        6.53E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        2.32E-02
 
 ETA2
+        2.68E-01  3.55E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.46E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (S)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        2.53E-03
 
 TH 2
+        5.48E-04  1.92E-03
 
 TH 3
+       -4.63E-03 -2.30E-03  4.00E-02
 
 TH 4
+       -3.94E-03 -2.79E-03  9.21E-03  6.25E-02
 
 TH 5
+        1.46E-03  1.21E-03 -7.71E-03 -7.81E-03  1.83E-02
 
 TH 6
+        7.11E-04  5.39E-04 -5.14E-03  4.92E-03  2.58E-03  2.21E-02
 
 TH 7
+       -1.98E-03 -3.68E-04 -7.31E-04  4.59E-03 -2.46E-03  2.70E-04  3.93E-03
 
 TH 8
+       -2.24E-04 -1.69E-03  1.92E-03 -1.61E-03 -4.40E-04  6.42E-04  6.93E-04  6.55E-03
 
 OM11
+       -5.53E-05 -6.83E-05  2.44E-04  2.44E-04 -3.88E-04 -5.58E-05  6.96E-05  3.19E-05  6.84E-05
 
 OM12
+       -4.91E-05 -4.99E-06 -3.92E-05  1.37E-05 -7.21E-05  3.92E-04  5.07E-05  7.51E-05  2.87E-05  1.08E-04
 
 OM22
+       -5.12E-05 -1.37E-04 -6.42E-05  4.92E-04  1.17E-04 -2.79E-04  6.27E-05  1.40E-04  3.05E-05  4.71E-05  2.36E-04
 
 SG11
+        7.92E-05  4.52E-05  2.11E-05 -3.82E-04  2.71E-04  8.58E-06 -1.00E-04  3.24E-05 -1.77E-05 -6.05E-06 -8.98E-06  4.27E-05
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (S)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        5.03E-02
 
 TH 2
+        2.49E-01  4.38E-02
 
 TH 3
+       -4.60E-01 -2.62E-01  2.00E-01
 
 TH 4
+       -3.14E-01 -2.55E-01  1.84E-01  2.50E-01
 
 TH 5
+        2.15E-01  2.04E-01 -2.85E-01 -2.31E-01  1.35E-01
 
 TH 6
+        9.51E-02  8.28E-02 -1.73E-01  1.32E-01  1.28E-01  1.49E-01
 
 TH 7
+       -6.26E-01 -1.34E-01 -5.82E-02  2.92E-01 -2.90E-01  2.89E-02  6.27E-02
 
 TH 8
+       -5.50E-02 -4.77E-01  1.18E-01 -7.97E-02 -4.02E-02  5.33E-02  1.37E-01  8.09E-02
 
 OM11
+       -1.33E-01 -1.89E-01  1.47E-01  1.18E-01 -3.47E-01 -4.54E-02  1.34E-01  4.76E-02  8.27E-03
 
 OM12
+       -9.38E-02 -1.10E-02 -1.88E-02  5.25E-03 -5.12E-02  2.53E-01  7.77E-02  8.91E-02  3.33E-01  1.04E-02
 
 OM22
+       -6.63E-02 -2.04E-01 -2.09E-02  1.28E-01  5.65E-02 -1.22E-01  6.51E-02  1.12E-01  2.40E-01  2.94E-01  1.54E-02
 
 SG11
+        2.41E-01  1.58E-01  1.61E-02 -2.34E-01  3.07E-01  8.83E-03 -2.44E-01  6.12E-02 -3.28E-01 -8.88E-02 -8.95E-02  6.53E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        1.31E+03
 
 TH 2
+       -1.60E+02  8.71E+02
 
 TH 3
+        1.79E+02  1.24E+00  5.62E+01
 
 TH 4
+        1.24E+00  3.46E+01 -5.11E+00  2.26E+01
 
 TH 5
+        9.09E+01 -2.59E+01  2.37E+01  3.87E+00  8.61E+01
 
 TH 6
+       -2.59E+01 -1.48E+01  3.87E+00 -9.50E+00 -1.06E+01  5.82E+01
 
 TH 7
+        7.21E+02 -1.13E+02  1.18E+02 -2.19E+01  8.65E+01 -9.50E+00  7.21E+02
 
 TH 8
+       -1.13E+02  2.37E+02 -2.19E+01  1.96E+01 -9.50E+00 -1.38E+01 -1.13E+02  2.37E+02
 
 OM11
+       -4.91E+02  3.66E+02 -1.29E+02  2.51E+01  2.83E+02  5.27E+01 -2.44E+02  1.18E+02  2.11E+04
 
 OM12
+        6.36E+02 -3.59E+02  6.73E+01  5.41E+01  7.35E+01 -2.87E+02  2.66E+02 -1.40E+02 -4.76E+03  1.29E+04
 
 OM22
+       -7.50E+01  2.92E+02  3.17E+01 -5.80E+01 -1.34E+02  1.43E+02 -4.38E+01 -5.13E+01 -1.61E+03 -2.51E+03  5.52E+03
 
 SG11
+       -1.26E+03 -4.30E+02 -3.02E+02  8.23E+01 -3.54E+02  3.22E+01 -3.16E+02 -2.19E+02  6.09E+03 -7.16E+02  1.96E+02  3.12E+04
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                    EIGENVALUES OF COR MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12

 
         1.40E-01  3.69E-01  4.28E-01  4.99E-01  6.46E-01  9.21E-01  9.84E-01  1.02E+00  1.24E+00  1.44E+00  1.52E+00  2.79E+00
 
 Elapsed postprocess time in seconds:     0.02
 Elapsed finaloutput time in seconds:     0.09
 #CPUT: Total CPU Time in Seconds,        0.686
Stop Time: 
Tue 03/12/2019 
10:08 AM
