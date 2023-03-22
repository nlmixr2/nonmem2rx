Wed 02/20/2019 
04:49 PM
$PROB Phase IIa Study, One Compartment Model 504f.ctl
; Place column names of data file here:
$INPUT C ID TIME DV AMT RATE WT AGE SEX 
$DATA 501.csv IGNORE=C ; Ignore records beginning with letter C
; Select One compartment model ADVAN1, Parameterization TRANS2 (CL, V)
$SUBROUTINE ADVAN1 TRANS2 
; Section to define PK parameters, relationship to fixed effects THETA
; and inter-subject random effects ETA.
$PK 
; Define typical values
  TVCL=THETA(1)*(WT/70)**THETA(3)*(AGE/50)**THETA(5)*THETA(7)**SEX
  TVV= THETA(2)*(WT/70)**THETA(4)*(AGE/50)**THETA(6)*THETA(8)**SEX
  CL=TVCL*EXP(ETA(1))
  V=TVV*EXP(ETA(2))
  S1=V

$THETA ; Enter initial starting values for THETAS
  (0.0,4)            ;[CL]
  (0.0,30)            ;[V]
  (0.75 FIXED)   ;[CL~WT]
  (1.0 FIXED)    ;[V~WT]
  -0.1           ;[CL~AGE]
  (0.0 FIXED)    ;[V~AGE]
  (1.0 FIXED)    ;[CL~SEX]
  (1.0 FIXED)    ;[V~SEX]

; Section to relate predicted function F and residual error
; relationship to data DV.  EPS are random error coefficients
$ERROR 
  Y=F*(1+EPS(1))
$OMEGA BLOCK(2) ; Initial OMEGA values in lower triangular format
  0.1         ;[P]
  0.001 0.1   ;[P]
$SIGMA ; Initial SIGMA
  0.04        ;[P]

$EST METHOD=COND INTERACTION MAXEVAL=9999 PRINT=5 NOABORT 
$COV UNCONDITIONAL MATRIX=R PRINT=E
; Print out individual predicted results diagnostics
; to file 504.tab
; Various parameters and built in diagnostics may be printed.
; DV=DEPENDENT VARIABLE
; CIPRED=individual predicted function, f(eta_hat), at mode of
; posterior density
; CIRES=DV-F(ETA_HAT)
; CIWRES=conditional individual residual
; (DV-F(ETA_HAT)/SQRT(SIGMA(1,1)*F(ETA_HAT))
; PRED=Population Predicted value F(ETA=0)
; CWRES=Population weighted Residual
; Note numerical Format may be specified for table outputs
$TABLE ID TIME DV CIPRED CIRES CIWRES PRED RES CWRES CL V ETA1 ETA2
       NOPRINT NOAPPEND ONEHEADER FORMAT=,1PE13.6 FILE=504f.tab

  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
  
License Registered to: IDS NONMEM 7 TEAM
Expiration Date:     2 JUN 2030
Current Date:       20 FEB 2019
Days until program expires :4117
1NONLINEAR MIXED EFFECTS MODEL PROGRAM (NONMEM) VERSION 7.5.0 alpha version 7
 ORIGINALLY DEVELOPED BY STUART BEAL, LEWIS SHEINER, AND ALISON BOECKMANN
 CURRENT DEVELOPERS ARE ROBERT BAUER, ICON DEVELOPMENT SOLUTIONS,
 AND ALISON BOECKMANN. IMPLEMENTATION, EFFICIENCY, AND STANDARDIZATION
 PERFORMED BY NOUS INFOSYSTEMS.

 PROBLEM NO.:         1
 Phase IIa Study, One Compartment Model 504f.ctl
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
 CL V
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
 LOWER BOUND    INITIAL EST    UPPER BOUND
  0.0000E+00     0.4000E+01     0.1000E+07
  0.0000E+00     0.3000E+02     0.1000E+07
  0.7500E+00     0.7500E+00     0.7500E+00
  0.1000E+01     0.1000E+01     0.1000E+01
 -0.1000E+07    -0.1000E+00     0.1000E+07
  0.0000E+00     0.0000E+00     0.0000E+00
  0.1000E+01     0.1000E+01     0.1000E+01
  0.1000E+01     0.1000E+01     0.1000E+01
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
04 COLUMNS APPENDED:    NO
 PRINTED:                NO
 HEADER:                YES
 FILE TO BE FORWARDED:   NO
 FORMAT:                ,1PE13.6
 IDFORMAT:
 LFORMAT:
 RFORMAT:
 FIXED_EFFECT_ETAS:
0USER-CHOSEN ITEMS:
 ID TIME DV CIPRED CIRES CIWRES PRED RES CWRES CL V ETA1 ETA2
1DOUBLE PRECISION PREDPP VERSION 7.5.0 alpha version 7

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
0ERROR IN LOG Y IS MODELED
0DATA ITEM INDICES USED BY PRED ARE:
   EVENT ID DATA ITEM IS DATA ITEM NO.:     10
   TIME DATA ITEM IS DATA ITEM NO.:          3
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   5
   DOSE RATE DATA ITEM IS DATA ITEM NO.:     6

0PK SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 PK SUBROUTINE NOT CALLED AT NONEVENT (ADDITIONAL OR LAGGED) DOSE TIMES.
0DURING SIMULATION, ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 OTHERWISE, ERROR SUBROUTINE CALLED ONCE IN THIS PROBLEM.
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
 RAW OUTPUT FILE (FILE): 504f.ext
 EXCLUDE TITLE (NOTITLE):                   NO
 EXCLUDE COLUMN LABELS (NOLABEL):           NO
 FORMAT FOR ADDITIONAL FILES (FORMAT):      S1PE12.5
 PARAMETER ORDER FOR OUTPUTS (ORDER):       TSOL
 WISHART PRIOR DF INTERPRETATION (WISHTYPE):0
 KNUTHSUMOFF:                               0
 INCLUDE LNTWOPI:                           NO
 INCLUDE CONSTANT TERM TO PRIOR (PRIORC):   NO
 INCLUDE CONSTANT TERM TO OMEGA (ETA) (OLNTWOPI):NO
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

 
0ITERATION NO.:    0    OBJECTIVE VALUE:   1161.60514748294        NO. OF FUNC. EVALS.:   6
 CUMULATIVE NO. OF FUNC. EVALS.:        6
 NPARAMETR:  4.0000E+00  3.0000E+01 -1.0000E-01  1.0000E-01  1.0000E-03  1.0000E-01  4.0000E-02
 PARAMETER:  1.0000E-01  1.0000E-01 -1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01
 GRADIENT:   3.6866E+02 -9.7362E+01  2.6628E+01 -6.4106E+01  2.3816E+00  3.1189E+01 -7.3257E+01
 
0ITERATION NO.:    5    OBJECTIVE VALUE:   1074.60533534245        NO. OF FUNC. EVALS.:  39
 CUMULATIVE NO. OF FUNC. EVALS.:       45
 NPARAMETR:  2.6544E+00  3.2730E+01 -5.6648E-01  5.5442E-02  6.6512E-04  4.6351E-02  5.0224E-02
 PARAMETER: -3.1009E-01  1.8709E-01 -5.6648E-01 -1.9492E-01  8.9326E-02 -2.8450E-01  2.1381E-01
 GRADIENT:  -1.3584E+02  2.6955E+01  3.0517E-01  1.7719E+01  3.3738E-01 -7.3568E+00  1.6102E+01
 
0ITERATION NO.:   10    OBJECTIVE VALUE:   1065.36549486555        NO. OF FUNC. EVALS.:  40
 CUMULATIVE NO. OF FUNC. EVALS.:       85
 NPARAMETR:  2.8738E+00  3.2328E+01 -5.3143E-01  3.4024E-02  1.1002E-03  5.0656E-02  4.9839E-02
 PARAMETER: -2.3066E-01  1.7475E-01 -5.3143E-01 -4.3905E-01  1.8862E-01 -2.4036E-01  2.0995E-01
 GRADIENT:  -1.8051E+00  8.6704E-01  6.7801E-02 -2.2649E-01 -2.1390E-03  6.4816E-02 -2.6550E-01
 
0ITERATION NO.:   15    OBJECTIVE VALUE:   1065.36236765098        NO. OF FUNC. EVALS.:  56
 CUMULATIVE NO. OF FUNC. EVALS.:      141
 NPARAMETR:  2.8781E+00  3.2332E+01 -5.2947E-01  3.4119E-02  1.1427E-03  5.0512E-02  4.9965E-02
 PARAMETER: -2.2917E-01  1.7485E-01 -5.2947E-01 -4.3766E-01  1.9562E-01 -2.4180E-01  2.1122E-01
 GRADIENT:   1.7816E-03 -1.4010E-02  1.2665E-03 -1.6090E-03 -8.5483E-04  4.5599E-03  5.8232E-03
 
0ITERATION NO.:   17    OBJECTIVE VALUE:   1065.36236713360        NO. OF FUNC. EVALS.:  21
 CUMULATIVE NO. OF FUNC. EVALS.:      162
 NPARAMETR:  2.8781E+00  3.2332E+01 -5.2947E-01  3.4120E-02  1.1465E-03  5.0511E-02  4.9964E-02
 PARAMETER: -2.2917E-01  1.7486E-01 -5.2947E-01 -4.3764E-01  1.9627E-01 -2.4182E-01  2.1121E-01
 GRADIENT:  -6.5300E-05 -2.8600E-03  1.2338E-03 -6.1375E-04 -1.4664E-04  6.5105E-04  1.2472E-03
 
 #TERM:
0MINIMIZATION SUCCESSFUL
 NO. OF FUNCTION EVALUATIONS USED:      162
 NO. OF SIG. DIGITS IN FINAL EST.:  3.1

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:         4.2047E-03 -9.8313E-03
 SE:             2.0094E-02  2.4121E-02
 N:                      60          60
 
 P VAL.:         8.3425E-01  6.8358E-01
 
 ETASHRINKSD(%)  1.5028E+01  1.6163E+01
 ETASHRINKVR(%)  2.7797E+01  2.9714E+01
 EBVSHRINKSD(%)  1.5715E+01  1.6432E+01
 EBVSHRINKVR(%)  2.8960E+01  3.0165E+01
 EPSSHRINKSD(%)  1.7460E+01
 EPSSHRINKVR(%)  3.1872E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):          240
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    441.090495938243     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    1065.36236713360     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       1506.45286307184     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           120
  
 #TERE:
 Elapsed estimation  time in seconds:     1.18
 Elapsed covariance  time in seconds:     0.64
 Elapsed postprocess time in seconds:     0.02
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 #OBJT:**************                       MINIMUM VALUE OF OBJECTIVE FUNCTION                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     1065.362       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         2.88E+00  3.23E+01  7.50E-01  1.00E+00 -5.29E-01  0.00E+00  1.00E+00  1.00E+00
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        3.41E-02
 
 ETA2
+        1.15E-03  5.05E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        5.00E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        1.85E-01
 
 ETA2
+        2.76E-02  2.25E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.24E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                            STANDARD ERROR OF ESTIMATE                          ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         8.43E-02  1.16E+00 ......... .........  1.04E-01 ......... ......... .........
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        9.31E-03
 
 ETA2
+        8.13E-03  1.47E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        6.59E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        2.52E-02
 
 ETA2
+        1.95E-01  3.26E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.47E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                          COVARIANCE MATRIX OF ESTIMATE                         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        7.11E-03
 
 TH 2
+        1.30E-02  1.35E+00
 
 TH 3
+       ......... ......... .........
 
 TH 4
+       ......... ......... ......... .........
 
 TH 5
+        9.23E-04 -5.47E-03 ......... .........  1.07E-02
 
 TH 6
+       ......... ......... ......... ......... ......... .........
 
 TH 7
+       ......... ......... ......... ......... ......... ......... .........
 
 TH 8
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM11
+       -2.37E-05  5.78E-04 ......... ......... -1.72E-05 ......... ......... .........  8.67E-05
 
 OM12
+        6.49E-05  1.95E-04 ......... ......... -3.43E-05 ......... ......... .........  1.17E-05  6.62E-05
 
 OM22
+       -8.84E-05  1.35E-03 ......... ......... -3.50E-05 ......... ......... .........  1.36E-05  2.48E-05  2.15E-04
 
 SG11
+        1.14E-04  7.36E-04 ......... .........  5.09E-06 ......... ......... ......... -1.33E-05 -2.58E-06 -2.34E-05  4.34E-05
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                          CORRELATION MATRIX OF ESTIMATE                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        8.43E-02
 
 TH 2
+        1.32E-01  1.16E+00
 
 TH 3
+       ......... ......... .........
 
 TH 4
+       ......... ......... ......... .........
 
 TH 5
+        1.06E-01 -4.55E-02 ......... .........  1.04E-01
 
 TH 6
+       ......... ......... ......... ......... ......... .........
 
 TH 7
+       ......... ......... ......... ......... ......... ......... .........
 
 TH 8
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM11
+       -3.02E-02  5.35E-02 ......... ......... -1.78E-02 ......... ......... .........  9.31E-03
 
 OM12
+        9.46E-02  2.07E-02 ......... ......... -4.07E-02 ......... ......... .........  1.55E-01  8.13E-03
 
 OM22
+       -7.15E-02  7.92E-02 ......... ......... -2.31E-02 ......... ......... .........  9.94E-02  2.08E-01  1.47E-02
 
 SG11
+        2.05E-01  9.63E-02 ......... .........  7.45E-03 ......... ......... ......... -2.17E-01 -4.82E-02 -2.42E-01  6.59E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                      INVERSE COVARIANCE MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        1.53E+02
 
 TH 2
+       -1.36E+00  7.76E-01
 
 TH 3
+       ......... ......... .........
 
 TH 4
+       ......... ......... ......... .........
 
 TH 5
+       -1.41E+01  4.94E-01 ......... .........  9.48E+01
 
 TH 6
+       ......... ......... ......... ......... ......... .........
 
 TH 7
+       ......... ......... ......... ......... ......... ......... .........
 
 TH 8
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM11
+        1.08E+01 -7.08E+00 ......... .........  6.91E+00 ......... ......... .........  1.24E+04
 
 OM12
+       -1.88E+02  2.53E+00 ......... .........  6.05E+01 ......... ......... ......... -2.01E+03  1.64E+04
 
 OM22
+        5.15E+01 -6.86E+00 ......... .........  1.76E+00 ......... ......... ......... -9.76E+01 -1.87E+03  5.23E+03
 
 SG11
+       -3.56E+02 -1.54E+01 ......... .........  2.41E+01 ......... ......... .........  3.74E+03 -2.05E+02  2.66E+03  2.68E+04
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                      EIGENVALUES OF COR MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7
 
         6.20E-01  7.16E-01  9.05E-01  9.30E-01  1.04E+00  1.26E+00  1.53E+00
 
 Elapsed finaloutput time in seconds:     0.09
 #CPUT: Total CPU Time in Seconds,        1.763
Stop Time: 
Wed 02/20/2019 
04:49 PM
