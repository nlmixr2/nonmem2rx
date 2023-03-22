Mon 02/22/2021 
03:38 PM
$PROBLEM WARFARIN PK/PD
$INPUT ID TIME AMT RATE EVID MDV DV CMT TSTRAT TMIN TMAX

$DATA warfarin_pkpd.csv ignore=C

$SUBROUTINES ADVAN13 TRANS1 TOL=12 ATOL=12

$MODEL NCOMPARTMENTS=3

$PK
MU_1=LOG(THETA(1))
MU_2=LOG(THETA(2))
MU_3=LOG(THETA(3))
MU_4=LOG(THETA(4))
MU_5=LOG(THETA(5))
MU_6=LOG(THETA(6))

KA=EXP(MU_1+ETA(1))
CL=EXP(MU_2+ETA(2))
V=EXP(MU_3+ETA(3))
RIN=EXP(MU_4+ETA(4))
IC50=EXP(MU_5+ETA(5))
KOUT=EXP(MU_6+ETA(6))
IMAX=1.0

S2=V
F1=1.0
A_0(3)=RIN/KOUT

$DES
DADT(1)=-KA*A(1)
DADT(2)=KA*A(1)-(CL/V)*A(2)
DADT(3)=RIN*(1.0-((IMAX*A(2)/V)/((A(2)/V)+IC50)))-KOUT*A(3)

$ERROR
IF(CMT==2) THEN
IPRED=A(2)/V
W=IPRED
Y=IPRED + W*EPS(1)
ENDIF
IF(CMT==3) THEN
IPRED=A(3)
W=1.0
Y=IPRED + W*EPS(2)
ENDIF


$THETA
1.60 ;[KA]
0.133 ;[CL]
7.95 ;[V]
5.41 ;[RIN]
1.20 ;[IC50]
0.056 ;[KOUT]

$OMEGA 0.701 0.063 0.020 0.190 0.013 0.016
$SIGMA 0.04 0.00150544

$DESIGN GROUPSIZE=52 FIMTYPE=1 VARCROSS=1 APPROX=FO 
        SIGL=12 MAXEVAL=9999 PRINT=100 
        DESEL=TIME DESELSTRAT=TSTRAT DESELMIN=TMIN DESELMAX=TMAX 


$TABLE ID TIME CMT TSTRAT TMIN TMAX EVID MDV IPRED NOAPPEND NOPRINT FILE=warfarin_pkpd_opt.tab
  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
             
 (WARNING  3) THERE MAY BE AN ERROR IN THE ABBREVIATED CODE. THE FOLLOWING
 ONE OR MORE RANDOM VARIABLES ARE DEFINED WITH "IF" STATEMENTS THAT DO NOT
 PROVIDE DEFINITIONS FOR BOTH THE "THEN" AND "ELSE" CASES. IF ALL
 CONDITIONS FAIL, THE VALUES OF THESE VARIABLES WILL BE ZERO.
  
   IPRED W Y

  
License Registered to: NONMEM license (with RADAR5NM) for ICON Pharmacometrics Team
Expiration Date:    31 DEC 2030
Current Date:       22 FEB 2021
Days until program expires :3594
1NONLINEAR MIXED EFFECTS MODEL PROGRAM (NONMEM) VERSION 7.5.0
 ORIGINALLY DEVELOPED BY STUART BEAL, LEWIS SHEINER, AND ALISON BOECKMANN
 CURRENT DEVELOPERS ARE ROBERT BAUER, ICON DEVELOPMENT SOLUTIONS,
 AND ALISON BOECKMANN. IMPLEMENTATION, EFFICIENCY, AND STANDARDIZATION
 PERFORMED BY NOUS INFOSYSTEMS.

 PROBLEM NO.:         1
 WARFARIN PK/PD
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:        9
 NO. OF DATA ITEMS IN DATA SET:  11
 ID DATA ITEM IS DATA ITEM NO.:   1
 DEP VARIABLE IS DATA ITEM NO.:   7
 MDV DATA ITEM IS DATA ITEM NO.:  6
0INDICES PASSED TO SUBROUTINE PRED:
   5   2   3   4   0   0   8   0   0   0   0
0LABELS FOR DATA ITEMS:
 ID TIME AMT RATE EVID MDV DV CMT TSTRAT TMIN TMAX
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 IPRED
0FORMAT FOR DATA:
 (11E6.0)

 TOT. NO. OF OBS RECS:        8
 TOT. NO. OF INDIVIDUALS:        1
0LENGTH OF THETA:   6
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   6
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   2
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
   0.1600E+01  0.1330E+00  0.7950E+01  0.5410E+01  0.1200E+01  0.5600E-01
0INITIAL ESTIMATE OF OMEGA:
 0.7010E+00
 0.0000E+00   0.6300E-01
 0.0000E+00   0.0000E+00   0.2000E-01
 0.0000E+00   0.0000E+00   0.0000E+00   0.1900E+00
 0.0000E+00   0.0000E+00   0.0000E+00   0.0000E+00   0.1300E-01
 0.0000E+00   0.0000E+00   0.0000E+00   0.0000E+00   0.0000E+00   0.1600E-01
0INITIAL ESTIMATE OF SIGMA:
 0.4000E-01
 0.0000E+00   0.1505E-02
0COVARIANCE STEP OMITTED:        NO
 R MATRIX SUBSTITUTED:          YES
 S MATRIX SUBSTITUTED:           NO
 EIGENVLS. PRINTED:              NO
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
04 COLUMNS APPENDED:    NO
 PRINTED:                NO
 HEADER:                YES
 FILE TO BE FORWARDED:   NO
 FORMAT:                S1PE11.4
 IDFORMAT:
 LFORMAT:
 RFORMAT:
 FIXED_EFFECT_ETAS:
0USER-CHOSEN ITEMS:
 ID TIME CMT TSTRAT TMIN TMAX EVID MDV IPRED
0WARNING: THE NUMBER OF PARAMETERS TO BE ESTIMATED
 EXCEEDS THE NUMBER OF INDIVIDUALS WITH DATA.
1DOUBLE PRECISION PREDPP VERSION 7.5.0

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
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:  12
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
1
 ADDITIONAL PK PARAMETERS - ASSIGNMENT OF ROWS IN GG
 COMPT. NO.                             INDICES
              SCALE      BIOAVAIL.   ZERO-ORDER  ZERO-ORDER  ABSORB
                         FRACTION    RATE        DURATION    LAG
    1            *           9           *           *           *
    2            8           *           *           *           *
    3            *           *           *           *           *
    4            *           -           -           -           -
             - PARAMETER IS NOT ALLOWED FOR THIS MODEL
             * PARAMETER IS NOT SUPPLIED BY PK SUBROUTINE;
               WILL DEFAULT TO ONE IF APPLICABLE
0DATA ITEM INDICES USED BY PRED ARE:
   EVENT ID DATA ITEM IS DATA ITEM NO.:      5
   TIME DATA ITEM IS DATA ITEM NO.:          2
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   3
   DOSE RATE DATA ITEM IS DATA ITEM NO.:     4
   COMPT. NO. DATA ITEM IS DATA ITEM NO.:    8

0PK SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 PK SUBROUTINE NOT CALLED AT NONEVENT (ADDITIONAL OR LAGGED) DOSE TIMES.
0PK SUBROUTINE INDICATES THAT COMPARTMENT AMOUNTS ARE INITIALIZED.
0ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
0ERROR SUBROUTINE INDICATES THAT DERIVATIVES OF COMPARTMENT AMOUNTS ARE USED.
0DES SUBROUTINE USES COMPACT STORAGE MODE.
1


 #TBLN:      1
 #METH: First Order: D-OPTIMALITY

 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 EPS-ETA INTERACTION:                     NO
 POP. ETAS OBTAINED POST HOC:             YES
 NO. OF FUNCT. EVALS. ALLOWED:            9999
 NO. OF SIG. FIGURES REQUIRED:            3
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
 IND. OBJ. FUNC. VALUES SORTED:           NO
 NUMERICAL DERIVATIVE
       FILE REQUEST (NUMDER):               NONE
 MAP (ETAHAT) ESTIMATION METHOD (OPTMAP):   0
 ETA HESSIAN EVALUATION METHOD (ETADER):    0
 INITIAL ETA FOR MAP ESTIMATION (MCETA):    0
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      12
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     12
 NOPRIOR SETTING (NOPRIOR):                 0
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          1
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      0
 RAW OUTPUT FILE (FILE): warfarin_pkpd_opt.ext
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

 DESIGN TYPE: D-OPTIMALITY, -LOG(DET(FIM))
 SIMULATE OBSERVED DATA FOR DESIGN:  NO
 BLOCK DIAGONALIZATION TYPE FOR DESIGN:  1
 RESIDUAL STANDARD DEVIATION MODELING (VAR_CROSS=1)
 DESIGN GROUPSIZE=  5.2000000000000000E+01
 OPTIMALITY RANDOM GENERATION SEED: 11456
 DESIGN OPTIMIZATION: NELDER
 OPTIMAL DESIGN ELEMENT, STRAT, MIN, MAX COLUMNS: TIME,TSTRAT,TMIN,TMAX
 TOLERANCES FOR ESTIMATION/EVALUATION STEP:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:  12
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
 TOLERANCES FOR COVARIANCE STEP:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:  12
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
 TOLERANCES FOR TABLE/SCATTER STEP:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:  12
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12

 THE FOLLOWING LABELS ARE EQUIVALENT
 PRED=NPRED
 RES=NRES
 WRES=NWRES
 IWRS=NIWRES
 IPRD=NIPRED
 IRS=NIRES

 MONITORING OF SEARCH:

 ITERATION NO.:          0    OBJECTIVE VALUE:  -109.835179058906        NO. OF FUNC. EVALS.:           1
 ITERATION NO.:        100    OBJECTIVE VALUE:  -117.557568360112        NO. OF FUNC. EVALS.:         332
 ITERATION NO.:        200    OBJECTIVE VALUE:  -117.700323317269        NO. OF FUNC. EVALS.:         591
 ITERATION NO.:        300    OBJECTIVE VALUE:  -117.842025758829        NO. OF FUNC. EVALS.:         830
 ITERATION NO.:        400    OBJECTIVE VALUE:  -117.987074751813        NO. OF FUNC. EVALS.:        1086
 ITERATION NO.:        500    OBJECTIVE VALUE:  -118.103989466726        NO. OF FUNC. EVALS.:        1350
 ITERATION NO.:        600    OBJECTIVE VALUE:  -118.182328920248        NO. OF FUNC. EVALS.:        1603
 ITERATION NO.:        700    OBJECTIVE VALUE:  -118.226355945742        NO. OF FUNC. EVALS.:        1855
 ITERATION NO.:        800    OBJECTIVE VALUE:  -118.242180639216        NO. OF FUNC. EVALS.:        2155
 ITERATION NO.:        900    OBJECTIVE VALUE:  -118.243358943584        NO. OF FUNC. EVALS.:        2438
 ITERATION NO.:       1000    OBJECTIVE VALUE:  -118.244163953701        NO. OF FUNC. EVALS.:        2702
 ITERATION NO.:       1100    OBJECTIVE VALUE:  -118.245451067276        NO. OF FUNC. EVALS.:        2943
 ITERATION NO.:       1200    OBJECTIVE VALUE:  -118.247399113159        NO. OF FUNC. EVALS.:        3160
 ITERATION NO.:       1300    OBJECTIVE VALUE:  -118.250488643249        NO. OF FUNC. EVALS.:        3373
 ITERATION NO.:       1400    OBJECTIVE VALUE:  -118.254532051738        NO. OF FUNC. EVALS.:        3573
 ITERATION NO.:       1500    OBJECTIVE VALUE:  -118.259588526447        NO. OF FUNC. EVALS.:        3776
 ITERATION NO.:       1600    OBJECTIVE VALUE:  -118.264955006770        NO. OF FUNC. EVALS.:        3990
 ITERATION NO.:       1700    OBJECTIVE VALUE:  -118.269241366406        NO. OF FUNC. EVALS.:        4203
 ITERATION NO.:       1800    OBJECTIVE VALUE:  -118.271909860928        NO. OF FUNC. EVALS.:        4441
 ITERATION NO.:       1829    OBJECTIVE VALUE:  -118.272123976862        NO. OF FUNC. EVALS.:        4550

 #TERM:
 NO. OF FUNCTION EVALUATIONS USED:     4550
0MINIMIZATION SUCCESSFUL

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.

 ETABAR:         0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00
 SE:             0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00
 N:                       1           1           1           1           1           1

 P VAL.:         1.0000E+00  1.0000E+00  1.0000E+00  1.0000E+00  1.0000E+00  1.0000E+00

 ETASHRINKSD(%)  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02
 ETASHRINKVR(%)  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02
 EBVSHRINKSD(%)  6.3293E+00  4.7247E+00  1.8743E+01  1.3585E-02  1.9879E+01  1.5940E-01
 EBVSHRINKVR(%)  1.2258E+01  9.2262E+00  3.3973E+01  2.7169E-02  3.5806E+01  3.1854E-01
 RELATIVEINF(%)  8.4573E+01  8.3693E+01  5.0902E+01  9.9970E+01  4.7747E+01  9.9645E+01
 EPSSHRINKSD(%)  5.0000E+01  5.0000E+01
 EPSSHRINKVR(%)  7.5000E+01  7.5000E+01

 #TERE:
 Elapsed opt. design time in seconds:    15.79
 Elapsed postprocess time in seconds:     0.03
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                            FIRST ORDER: D-OPTIMALITY                           ********************
 #OBJT:**************                MINIMUM VALUE OF OBJECTIVE FUNCTION: D-OPTIMALITY               ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     -118.272       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                            FIRST ORDER: D-OPTIMALITY                           ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6     
 
         1.60E+00  1.33E-01  7.95E+00  5.41E+00  1.20E+00  5.60E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6     
 
 ETA1
+        7.01E-01
 
 ETA2
+        0.00E+00  6.30E-02
 
 ETA3
+        0.00E+00  0.00E+00  2.00E-02
 
 ETA4
+        0.00E+00  0.00E+00  0.00E+00  1.90E-01
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.30E-02
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.60E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1      EPS2     
 
 EPS1
+        4.00E-02
 
 EPS2
+        0.00E+00  1.51E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6     
 
 ETA1
+        8.37E-01
 
 ETA2
+        0.00E+00  2.51E-01
 
 ETA3
+        0.00E+00  0.00E+00  1.41E-01
 
 ETA4
+        0.00E+00  0.00E+00  0.00E+00  4.36E-01
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.14E-01
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.26E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1      EPS2     
 
 EPS1
+        2.00E-01
 
 EPS2
+        0.00E+00  3.88E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                            FIRST ORDER: D-OPTIMALITY                           ********************
 ********************                            STANDARD ERROR OF ESTIMATE                          ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6     
 
         2.03E-01  5.09E-03  2.23E-01  3.27E-01  2.80E-02  9.84E-04
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6     
 
 ETA1
+        1.59E-01
 
 ETA2
+       .........  1.37E-02
 
 ETA3
+       ......... .........  6.22E-03
 
 ETA4
+       ......... ......... .........  3.73E-02
 
 ETA5
+       ......... ......... ......... .........  4.14E-03
 
 ETA6
+       ......... ......... ......... ......... .........  3.15E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1      EPS2     
 
 EPS1
+        6.55E-03
 
 EPS2
+       .........  2.95E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6     
 
 ETA1
+        9.48E-02
 
 ETA2
+       .........  2.73E-02
 
 ETA3
+       ......... .........  2.20E-02
 
 ETA4
+       ......... ......... .........  4.28E-02
 
 ETA5
+       ......... ......... ......... .........  1.82E-02
 
 ETA6
+       ......... ......... ......... ......... .........  1.24E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1      EPS2     
 
 EPS1
+        1.64E-02
 
 EPS2
+       .........  3.80E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                            FIRST ORDER: D-OPTIMALITY                           ********************
 ********************                          COVARIANCE MATRIX OF ESTIMATE                         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

     TH 1 | TH 1      TH 2 | TH 1      TH 2 | TH 2      TH 3 | TH 1      TH 3 | TH 2      TH 3 | TH 3      TH 4 | TH 1  
     4.13E-02         6.86E-05         2.59E-05         7.56E-03         2.35E-04         4.96E-02        -1.10E-04

     TH 4 | TH 2      TH 4 | TH 3      TH 4 | TH 4      TH 5 | TH 1      TH 5 | TH 2      TH 5 | TH 3      TH 5 | TH 4  
    -4.58E-06         2.48E-04         1.07E-01        -9.94E-04        -4.00E-05        -3.02E-03         1.26E-05

     TH 5 | TH 5      TH 6 | TH 1      TH 6 | TH 2      TH 6 | TH 3      TH 6 | TH 4      TH 6 | TH 5      TH 6 | TH 6  
     7.85E-04        -1.14E-06        -4.74E-08         2.57E-06         3.57E-07         1.30E-07         9.69E-07

   OM11 | TH 1      OM11 | TH 2      OM11 | TH 3      OM11 | TH 4      OM11 | TH 5      OM11 | TH 6      OM11 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         2.52E-02

   OM22 | TH 1      OM22 | TH 2      OM22 | TH 3      OM22 | TH 4      OM22 | TH 5      OM22 | TH 6      OM22 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         1.05E-05

   OM22 | OM22      OM33 | TH 1      OM33 | TH 2      OM33 | TH 3      OM33 | TH 4      OM33 | TH 5      OM33 | TH 6    
     1.88E-04         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM33 | OM11      OM33 | OM22      OM33 | OM33      OM44 | TH 1      OM44 | TH 2      OM44 | TH 3      OM44 | TH 4    
     7.07E-06         7.01E-07         3.87E-05         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM44 | TH 5      OM44 | TH 6      OM44 | OM11      OM44 | OM22      OM44 | OM33      OM44 | OM44      OM55 | TH 1    
     0.00E+00         0.00E+00         8.10E-08         2.94E-10         5.48E-10         1.39E-03         0.00E+00

   OM55 | TH 2      OM55 | TH 3      OM55 | TH 4      OM55 | TH 5      OM55 | TH 6      OM55 | OM11      OM55 | OM22    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         1.63E-06        -2.08E-06

   OM55 | OM33      OM55 | OM44      OM55 | OM55      OM66 | TH 1      OM66 | TH 2      OM66 | TH 3      OM66 | TH 4    
    -4.38E-06         3.21E-09         1.72E-05         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM66 | TH 5      OM66 | TH 6      OM66 | OM11      OM66 | OM22      OM66 | OM33      OM66 | OM44      OM66 | OM55    
     0.00E+00         0.00E+00         8.15E-08         2.94E-10         5.55E-10        -6.73E-11         3.23E-09

   OM66 | OM66      SG11 | TH 1      SG11 | TH 2      SG11 | TH 3      SG11 | TH 4      SG11 | TH 5      SG11 | TH 6    
     9.91E-06         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   SG11 | OM11      SG11 | OM22      SG11 | OM33      SG11 | OM44      SG11 | OM55      SG11 | OM66      SG11 | SG11    
    -9.85E-05        -4.22E-06        -6.04E-06        -4.35E-08        -3.34E-06        -4.38E-08         4.28E-05

   SG22 | TH 1      SG22 | TH 2      SG22 | TH 3      SG22 | TH 4      SG22 | TH 5      SG22 | TH 6      SG22 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00        -4.61E-12

   SG22 | OM22      SG22 | OM33      SG22 | OM44      SG22 | OM55      SG22 | OM66      SG22 | SG11      SG22 | SG22      
    -1.91E-11         3.02E-11        -3.99E-10        -3.83E-09        -3.63E-10        -3.63E-11         8.72E-08
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                            FIRST ORDER: D-OPTIMALITY                           ********************
 ********************                          CORRELATION MATRIX OF ESTIMATE                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

     TH 1 | TH 1      TH 2 | TH 1      TH 2 | TH 2      TH 3 | TH 1      TH 3 | TH 2      TH 3 | TH 3      TH 4 | TH 1  
     2.03E-01         6.63E-02         5.09E-03         1.67E-01         2.07E-01         2.23E-01        -1.66E-03

     TH 4 | TH 2      TH 4 | TH 3      TH 4 | TH 4      TH 5 | TH 1      TH 5 | TH 2      TH 5 | TH 3      TH 5 | TH 4  
    -2.75E-03         3.41E-03         3.27E-01        -1.75E-01        -2.80E-01        -4.83E-01         1.37E-03

     TH 5 | TH 5      TH 6 | TH 1      TH 6 | TH 2      TH 6 | TH 3      TH 6 | TH 4      TH 6 | TH 5      TH 6 | TH 6  
     2.80E-02        -5.71E-03        -9.45E-03         1.17E-02         1.11E-03         4.72E-03         9.84E-04

   OM11 | TH 1      OM11 | TH 2      OM11 | TH 3      OM11 | TH 4      OM11 | TH 5      OM11 | TH 6      OM11 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         1.59E-01

   OM22 | TH 1      OM22 | TH 2      OM22 | TH 3      OM22 | TH 4      OM22 | TH 5      OM22 | TH 6      OM22 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         4.81E-03

   OM22 | OM22      OM33 | TH 1      OM33 | TH 2      OM33 | TH 3      OM33 | TH 4      OM33 | TH 5      OM33 | TH 6    
     1.37E-02         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM33 | OM11      OM33 | OM22      OM33 | OM33      OM44 | TH 1      OM44 | TH 2      OM44 | TH 3      OM44 | TH 4    
     7.15E-03         8.22E-03         6.22E-03         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM44 | TH 5      OM44 | TH 6      OM44 | OM11      OM44 | OM22      OM44 | OM33      OM44 | OM44      OM55 | TH 1    
     0.00E+00         0.00E+00         1.37E-05         5.75E-07         2.36E-06         3.73E-02         0.00E+00

   OM55 | TH 2      OM55 | TH 3      OM55 | TH 4      OM55 | TH 5      OM55 | TH 6      OM55 | OM11      OM55 | OM22    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         2.48E-03        -3.66E-02

   OM55 | OM33      OM55 | OM44      OM55 | OM55      OM66 | TH 1      OM66 | TH 2      OM66 | TH 3      OM66 | TH 4    
    -1.70E-01         2.08E-05         4.14E-03         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM66 | TH 5      OM66 | TH 6      OM66 | OM11      OM66 | OM22      OM66 | OM33      OM66 | OM44      OM66 | OM55    
     0.00E+00         0.00E+00         1.63E-04         6.81E-06         2.83E-05        -5.74E-07         2.47E-04

   OM66 | OM66      SG11 | TH 1      SG11 | TH 2      SG11 | TH 3      SG11 | TH 4      SG11 | TH 5      SG11 | TH 6    
     3.15E-03         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   SG11 | OM11      SG11 | OM22      SG11 | OM33      SG11 | OM44      SG11 | OM55      SG11 | OM66      SG11 | SG11    
    -9.47E-02        -4.70E-02        -1.48E-01        -1.78E-04        -1.23E-01        -2.12E-03         6.55E-03

   SG22 | TH 1      SG22 | TH 2      SG22 | TH 3      SG22 | TH 4      SG22 | TH 5      SG22 | TH 6      SG22 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00        -9.82E-08

   SG22 | OM22      SG22 | OM33      SG22 | OM44      SG22 | OM55      SG22 | OM66      SG22 | SG11      SG22 | SG22      
    -4.71E-06         1.64E-05        -3.63E-05        -3.14E-03        -3.91E-04        -1.88E-05         2.95E-04
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                            FIRST ORDER: D-OPTIMALITY                           ********************
 ********************                      INVERSE COVARIANCE MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

     TH 1 | TH 1      TH 2 | TH 1      TH 2 | TH 2      TH 3 | TH 1      TH 3 | TH 2      TH 3 | TH 3      TH 4 | TH 1  
     2.52E+01        -1.05E+01         4.22E+04        -2.46E+00        -8.93E+01         2.67E+01         2.85E-02

     TH 4 | TH 2      TH 4 | TH 3      TH 4 | TH 4      TH 5 | TH 1      TH 5 | TH 2      TH 5 | TH 3      TH 5 | TH 4  
     1.78E+00        -7.93E-02         9.35E+00         2.19E+01         1.79E+03         9.50E+01        -3.27E-01

     TH 5 | TH 5      TH 6 | TH 1      TH 6 | TH 2      TH 6 | TH 3      TH 6 | TH 4      TH 6 | TH 5      TH 6 | TH 6  
     1.76E+03         3.28E+01         2.04E+03        -9.09E+01        -3.07E+00        -3.75E+02         1.03E+06

   OM11 | TH 1      OM11 | TH 2      OM11 | TH 3      OM11 | TH 4      OM11 | TH 5      OM11 | TH 6      OM11 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         4.00E+01

   OM22 | TH 1      OM22 | TH 2      OM22 | TH 3      OM22 | TH 4      OM22 | TH 5      OM22 | TH 6      OM22 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         4.81E-02

   OM22 | OM22      OM33 | TH 1      OM33 | TH 2      OM33 | TH 3      OM33 | TH 4      OM33 | TH 5      OM33 | TH 6    
     5.35E+03         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM33 | OM11      OM33 | OM22      OM33 | OM33      OM44 | TH 1      OM44 | TH 2      OM44 | TH 3      OM44 | TH 4    
     9.39E+00         8.57E+01         2.74E+04         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM44 | TH 5      OM44 | TH 6      OM44 | OM11      OM44 | OM22      OM44 | OM33      OM44 | OM44      OM55 | TH 1    
     0.00E+00         0.00E+00         5.87E-04         1.58E-02         1.12E-01         7.20E+02         0.00E+00

   OM55 | TH 2      OM55 | TH 3      OM55 | TH 4      OM55 | TH 5      OM55 | TH 6      OM55 | OM11      OM55 | OM22    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         1.70E+01         7.85E+02

   OM55 | OM33      OM55 | OM44      OM55 | OM55      OM66 | TH 1      OM66 | TH 2      OM66 | TH 3      OM66 | TH 4    
     7.90E+03         4.33E-02         6.16E+04         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM66 | TH 5      OM66 | TH 6      OM66 | OM11      OM66 | OM22      OM66 | OM33      OM66 | OM44      OM66 | OM55    
     0.00E+00         0.00E+00         8.28E-02         2.23E+00         1.58E+01         8.31E-03         6.10E+00

   OM66 | OM66      SG11 | TH 1      SG11 | TH 2      SG11 | TH 3      SG11 | TH 4      SG11 | TH 5      SG11 | TH 6    
     1.01E+05         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   SG11 | OM11      SG11 | OM22      SG11 | OM33      SG11 | OM44      SG11 | OM55      SG11 | OM66      SG11 | SG11    
     9.47E+01         6.00E+02         4.51E+03         7.53E-01         6.03E+03         1.06E+02         2.47E+04

   SG22 | TH 1      SG22 | TH 2      SG22 | TH 3      SG22 | TH 4      SG22 | TH 5      SG22 | TH 6      SG22 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         7.88E-01

   SG22 | OM22      SG22 | OM33      SG22 | OM44      SG22 | OM55      SG22 | OM66      SG22 | SG11      SG22 | SG22      
     3.59E+01         3.40E+02         3.30E+00         2.71E+03         4.21E+02         2.75E+02         1.15E+07
 Elapsed finaloutput time in seconds:     0.21
 #CPUT: Total CPU Time in Seconds,       16.063
Stop Time: 
Mon 02/22/2021 
03:39 PM
