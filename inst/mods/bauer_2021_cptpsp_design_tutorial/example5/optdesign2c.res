Sat 08/07/2021 
01:49 AM

$PROB RUN# Example 1 (from samp5l)
$INPUT C SET ID JID TIME  DV=CONC AMT=DOSE RATE EVID MDV CMT TSTRAT TMIN TMAX
$DATA optdesign2.csv IGNORE=C

$SUBROUTINES ADVAN3 TRANS4

$PK
; The thetas are MU modeled.  
; Best that there is a linear relationship between THETAs and Mus
; The linear MU modeling of THETAS allows them to be efficiently 
; Gibbs sampled.

MU_1=THETA(1)
MU_2=THETA(2)
MU_3=THETA(3)
MU_4=THETA(4)
CL=DEXP(MU_1+ETA(1))
V1=DEXP(MU_2+ETA(2))
Q=DEXP(MU_3+ETA(3))
V2=DEXP(MU_4+ETA(4))
S1=V1

$ERROR
IPRED=F
Y = F + F*EPS(1)+EPS(2)

; Initial values of THETA
$THETA 
 1.68338E+00  1.58812E+00  8.12710E-01  2.37436E+00 


;INITIAL values of OMEGA
;$OMEGA BLOCK(4) VALUES(0.0225,0.001)
$OMEGA (0.0225)X4

;Initial value of SIGMA
$SIGMA 
( 0.0225)
( 0.0001)

$DESIGN NELDER FIMDIAG=1 OFVTYPE=1 APPROX=FO groupsize=100
           DESEL=TIME DESELSTRAT=TSTRAT DESELMIN=TMIN DESELMAX=TMAX
           MAXEVAL=9999 NOHABORT PRINT=20 SIGL=10 POSTHOC VARCROSS=1
$TABLE ID TSTRAT TIME EVID MDV DV IPRED NOPRINT NOAPPEND FILE=optdesign2c.tab 
  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
  
License Registered to: IDS NONMEM 7 TEAM
Expiration Date:     2 JUN 2030
Current Date:        7 AUG 2021
Days until program expires :3220
1NONLINEAR MIXED EFFECTS MODEL PROGRAM (NONMEM) VERSION 7.5.0
 ORIGINALLY DEVELOPED BY STUART BEAL, LEWIS SHEINER, AND ALISON BOECKMANN
 CURRENT DEVELOPERS ARE ROBERT BAUER, ICON DEVELOPMENT SOLUTIONS,
 AND ALISON BOECKMANN. IMPLEMENTATION, EFFICIENCY, AND STANDARDIZATION
 PERFORMED BY NOUS INFOSYSTEMS.

 PROBLEM NO.:         1
 RUN# Example 1 (from samp5l)
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:        6
 NO. OF DATA ITEMS IN DATA SET:  14
 ID DATA ITEM IS DATA ITEM NO.:   3
 DEP VARIABLE IS DATA ITEM NO.:   6
 MDV DATA ITEM IS DATA ITEM NO.: 10
0INDICES PASSED TO SUBROUTINE PRED:
   9   5   7   8   0   0  11   0   0   0   0
0LABELS FOR DATA ITEMS:
 C SET ID JID TIME CONC DOSE RATE EVID MDV CMT TSTRAT TMIN TMAX
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 IPRED
0FORMAT FOR DATA:
 (14E5.0)

 TOT. NO. OF OBS RECS:        5
 TOT. NO. OF INDIVIDUALS:        1
0LENGTH OF THETA:   4
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   4
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   2
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
   0.1683E+01  0.1588E+01  0.8127E+00  0.2374E+01
0INITIAL ESTIMATE OF OMEGA:
 0.2250E-01
 0.0000E+00   0.2250E-01
 0.0000E+00   0.0000E+00   0.2250E-01
 0.0000E+00   0.0000E+00   0.0000E+00   0.2250E-01
0INITIAL ESTIMATE OF SIGMA:
 0.2250E-01
 0.0000E+00   0.1000E-03
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
 ID TSTRAT TIME EVID MDV CONC IPRED
0WARNING: THE NUMBER OF PARAMETERS TO BE ESTIMATED
 EXCEEDS THE NUMBER OF INDIVIDUALS WITH DATA.
1DOUBLE PRECISION PREDPP VERSION 7.5.0

 TWO COMPARTMENT MODEL (ADVAN3)
0MAXIMUM NO. OF BASIC PK PARAMETERS:   4
0BASIC PK PARAMETERS (AFTER TRANSLATION):
   BASIC PK PARAMETER NO.  1: ELIMINATION RATE (K)
   BASIC PK PARAMETER NO.  2: CENTRAL-TO-PERIPH. RATE (K12)
   BASIC PK PARAMETER NO.  3: PERIPH.-TO-CENTRAL RATE (K21)
 TRANSLATOR WILL CONVERT PARAMETERS
 CL, V1, Q, V2 TO K, K12, K21 (TRANS4)
0COMPARTMENT ATTRIBUTES
 COMPT. NO.   FUNCTION   INITIAL    ON/OFF      DOSE      DEFAULT    DEFAULT
                         STATUS     ALLOWED    ALLOWED    FOR DOSE   FOR OBS.
    1         CENTRAL      ON         NO         YES        YES        YES
    2         PERIPH.      ON         NO         YES        NO         NO
    3         OUTPUT       OFF        YES        NO         NO         NO
1
 ADDITIONAL PK PARAMETERS - ASSIGNMENT OF ROWS IN GG
 COMPT. NO.                             INDICES
              SCALE      BIOAVAIL.   ZERO-ORDER  ZERO-ORDER  ABSORB
                         FRACTION    RATE        DURATION    LAG
    1            5           *           *           *           *
    2            *           *           *           *           *
    3            *           -           -           -           -
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
0ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
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
 NOPRIOR SETTING (NOPRIOR):                 0
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          1
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      0
 RAW OUTPUT FILE (FILE): optdesign2c.ext
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
 DESIGN GROUPSIZE=  1.0000000000000000E+02
 OPTIMALITY RANDOM GENERATION SEED: 11456
 DESIGN OPTIMIZATION: NELDER
 OPTIMAL DESIGN ELEMENT, STRAT, MIN, MAX COLUMNS: TIME,TSTRAT,TMIN,TMAX
 
 THE FOLLOWING LABELS ARE EQUIVALENT
 PRED=NPRED
 RES=NRES
 WRES=NWRES
 IWRS=NIWRES
 IPRD=NIPRED
 IRS=NIRES
 
 MONITORING OF SEARCH:

 ITERATION NO.:          0    OBJECTIVE VALUE:  -101.424107517291        NO. OF FUNC. EVALS.:           1
 ITERATION NO.:         20    OBJECTIVE VALUE:  -103.691550158313        NO. OF FUNC. EVALS.:         104
 ITERATION NO.:         40    OBJECTIVE VALUE:  -103.691879283945        NO. OF FUNC. EVALS.:         168
 ITERATION NO.:         60    OBJECTIVE VALUE:  -103.692092446800        NO. OF FUNC. EVALS.:         222
 ITERATION NO.:         80    OBJECTIVE VALUE:  -103.692315216718        NO. OF FUNC. EVALS.:         282
 ITERATION NO.:        100    OBJECTIVE VALUE:  -103.692498495407        NO. OF FUNC. EVALS.:         336
 ITERATION NO.:        120    OBJECTIVE VALUE:  -103.692642287502        NO. OF FUNC. EVALS.:         385
 ITERATION NO.:        140    OBJECTIVE VALUE:  -103.692779646288        NO. OF FUNC. EVALS.:         433
 ITERATION NO.:        160    OBJECTIVE VALUE:  -103.692899182980        NO. OF FUNC. EVALS.:         480
 ITERATION NO.:        180    OBJECTIVE VALUE:  -103.693009450598        NO. OF FUNC. EVALS.:         528
 ITERATION NO.:        200    OBJECTIVE VALUE:  -103.693154864301        NO. OF FUNC. EVALS.:         587
 ITERATION NO.:        220    OBJECTIVE VALUE:  -103.693248913992        NO. OF FUNC. EVALS.:         638
 ITERATION NO.:        240    OBJECTIVE VALUE:  -103.693343220598        NO. OF FUNC. EVALS.:         689
 ITERATION NO.:        260    OBJECTIVE VALUE:  -103.693452128661        NO. OF FUNC. EVALS.:         749
 ITERATION NO.:        280    OBJECTIVE VALUE:  -103.693541109476        NO. OF FUNC. EVALS.:         804
 ITERATION NO.:        299    OBJECTIVE VALUE:  -103.693606320682        NO. OF FUNC. EVALS.:         852
 
 #TERM:
 NO. OF FUNCTION EVALUATIONS USED:      852
0MINIMIZATION SUCCESSFUL

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:         0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00
 SE:             0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00
 N:                       1           1           1           1
 
 P VAL.:         1.0000E+00  1.0000E+00  1.0000E+00  1.0000E+00
 
 ETASHRINKSD(%)  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02
 ETASHRINKVR(%)  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02
 EBVSHRINKSD(%)  9.3128E+00  2.3684E+01  3.9386E+01  3.1527E+01
 EBVSHRINKVR(%)  1.7758E+01  4.1758E+01  6.3260E+01  5.3115E+01
 RELATIVEINF(%)  7.3981E+01  5.0559E+01  2.4837E+01  3.2315E+01
 EPSSHRINKSD(%)  5.5279E+01  5.5279E+01
 EPSSHRINKVR(%)  8.0000E+01  8.0000E+01
 
 #TERE:
 Elapsed opt. design time in seconds:     0.41
 Elapsed postprocess time in seconds:     0.00
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                            FIRST ORDER: D-OPTIMALITY                           ********************
 #OBJT:**************                MINIMUM VALUE OF OBJECTIVE FUNCTION: D-OPTIMALITY               ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     -103.694       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                            FIRST ORDER: D-OPTIMALITY                           ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4     
 
         1.68E+00  1.59E+00  8.13E-01  2.37E+00
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        2.25E-02
 
 ETA2
+        0.00E+00  2.25E-02
 
 ETA3
+        0.00E+00  0.00E+00  2.25E-02
 
 ETA4
+        0.00E+00  0.00E+00  0.00E+00  2.25E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1      EPS2     
 
 EPS1
+        2.25E-02
 
 EPS2
+        0.00E+00  1.00E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        1.50E-01
 
 ETA2
+        0.00E+00  1.50E-01
 
 ETA3
+        0.00E+00  0.00E+00  1.50E-01
 
 ETA4
+        0.00E+00  0.00E+00  0.00E+00  1.50E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1      EPS2     
 
 EPS1
+        1.50E-01
 
 EPS2
+        0.00E+00  1.00E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                            FIRST ORDER: D-OPTIMALITY                           ********************
 ********************                            STANDARD ERROR OF ESTIMATE                          ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4     
 
         1.75E-02  2.13E-02  3.06E-02  2.68E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        3.93E-03
 
 ETA2
+       .........  6.29E-03
 
 ETA3
+       ......... .........  1.05E-02
 
 ETA4
+       ......... ......... .........  7.50E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1      EPS2     
 
 EPS1
+        4.67E-03
 
 EPS2
+       .........  2.34E-05
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        1.31E-02
 
 ETA2
+       .........  2.10E-02
 
 ETA3
+       ......... .........  3.50E-02
 
 ETA4
+       ......... ......... .........  2.50E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1      EPS2     
 
 EPS1
+        1.56E-02
 
 EPS2
+       .........  1.17E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                            FIRST ORDER: D-OPTIMALITY                           ********************
 ********************                          COVARIANCE MATRIX OF ESTIMATE                         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

     TH 1 | TH 1      TH 2 | TH 1      TH 2 | TH 2      TH 3 | TH 1      TH 3 | TH 2      TH 3 | TH 3      TH 4 | TH 1  
     3.08E-04         9.56E-05         4.55E-04         1.34E-04         1.93E-04         9.37E-04         1.05E-04

     TH 4 | TH 2      TH 4 | TH 3      TH 4 | TH 4    OM11 | TH 1      OM11 | TH 2      OM11 | TH 3      OM11 | TH 4    
     1.59E-04         4.48E-04         7.17E-04         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM11 | OM11      OM22 | TH 1      OM22 | TH 2      OM22 | TH 3      OM22 | TH 4      OM22 | OM11      OM22 | OM22    
     1.55E-05         0.00E+00         0.00E+00         0.00E+00         0.00E+00         6.98E-07         3.96E-05

   OM33 | TH 1      OM33 | TH 2      OM33 | TH 3      OM33 | TH 4      OM33 | OM11      OM33 | OM22      OM33 | OM33    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         2.05E-06         1.44E-05         1.11E-04

   OM44 | TH 1      OM44 | TH 2      OM44 | TH 3      OM44 | TH 4      OM44 | OM11      OM44 | OM22      OM44 | OM33    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         2.74E-07        -9.16E-07        -1.63E-05

   OM44 | OM44      SG11 | TH 1      SG11 | TH 2      SG11 | TH 3      SG11 | TH 4      SG11 | OM11      SG11 | OM22    
     5.63E-05         0.00E+00         0.00E+00         0.00E+00         0.00E+00        -2.25E-06        -1.38E-05

   SG11 | OM33      SG11 | OM44      SG11 | SG11      SG22 | TH 1      SG22 | TH 2      SG22 | TH 3      SG22 | TH 4    
    -2.44E-05         8.34E-07         2.18E-05         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   SG22 | OM11      SG22 | OM22      SG22 | OM33      SG22 | OM44      SG22 | SG11      SG22 | SG22      
     1.36E-09         3.18E-08         5.49E-08        -5.02E-08        -5.10E-08         5.49E-10
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                            FIRST ORDER: D-OPTIMALITY                           ********************
 ********************                          CORRELATION MATRIX OF ESTIMATE                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

     TH 1 | TH 1      TH 2 | TH 1      TH 2 | TH 2      TH 3 | TH 1      TH 3 | TH 2      TH 3 | TH 3      TH 4 | TH 1  
     1.75E-02         2.56E-01         2.13E-02         2.50E-01         2.95E-01         3.06E-02         2.24E-01

     TH 4 | TH 2      TH 4 | TH 3      TH 4 | TH 4    OM11 | TH 1      OM11 | TH 2      OM11 | TH 3      OM11 | TH 4    
     2.77E-01         5.47E-01         2.68E-02         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM11 | OM11      OM22 | TH 1      OM22 | TH 2      OM22 | TH 3      OM22 | TH 4      OM22 | OM11      OM22 | OM22    
     3.93E-03         0.00E+00         0.00E+00         0.00E+00         0.00E+00         2.82E-02         6.29E-03

   OM33 | TH 1      OM33 | TH 2      OM33 | TH 3      OM33 | TH 4      OM33 | OM11      OM33 | OM22      OM33 | OM33    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         4.96E-02         2.18E-01         1.05E-02

   OM44 | TH 1      OM44 | TH 2      OM44 | TH 3      OM44 | TH 4      OM44 | OM11      OM44 | OM22      OM44 | OM33    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         9.30E-03        -1.94E-02        -2.07E-01

   OM44 | OM44      SG11 | TH 1      SG11 | TH 2      SG11 | TH 3      SG11 | TH 4      SG11 | OM11      SG11 | OM22    
     7.50E-03         0.00E+00         0.00E+00         0.00E+00         0.00E+00        -1.22E-01        -4.68E-01

   SG11 | OM33      SG11 | OM44      SG11 | SG11      SG22 | TH 1      SG22 | TH 2      SG22 | TH 3      SG22 | TH 4    
    -4.97E-01         2.38E-02         4.67E-03         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   SG22 | OM11      SG22 | OM22      SG22 | OM33      SG22 | OM44      SG22 | SG11      SG22 | SG22      
     1.48E-02         2.15E-01         2.23E-01        -2.86E-01        -4.66E-01         2.34E-05
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                            FIRST ORDER: D-OPTIMALITY                           ********************
 ********************                      INVERSE COVARIANCE MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

     TH 1 | TH 1      TH 2 | TH 1      TH 2 | TH 2      TH 3 | TH 1      TH 3 | TH 2      TH 3 | TH 3      TH 4 | TH 1  
     3.63E+03        -5.59E+02         2.55E+03        -2.99E+02        -3.04E+02         1.60E+03        -2.23E+02

     TH 4 | TH 2      TH 4 | TH 3      TH 4 | TH 4    OM11 | TH 1      OM11 | TH 2      OM11 | TH 3      OM11 | TH 4    
    -2.90E+02        -8.86E+02         2.04E+03         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM11 | OM11      OM22 | TH 1      OM22 | TH 2      OM22 | TH 3      OM22 | TH 4      OM22 | OM11      OM22 | OM22    
     6.59E+04         0.00E+00         0.00E+00         0.00E+00         0.00E+00         1.56E+03         3.24E+04

   OM33 | TH 1      OM33 | TH 2      OM33 | TH 3      OM33 | TH 4      OM33 | OM11      OM33 | OM22      OM33 | OM33    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         4.47E+02         4.64E+02         1.28E+04

   OM44 | TH 1      OM44 | TH 2      OM44 | TH 3      OM44 | TH 4      OM44 | OM11      OM44 | OM22      OM44 | OM33    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         2.50E+02         4.21E+02         3.93E+03

   OM44 | OM44      SG11 | TH 1      SG11 | TH 2      SG11 | TH 3      SG11 | TH 4      SG11 | OM11      SG11 | OM22    
     2.09E+04         0.00E+00         0.00E+00         0.00E+00         0.00E+00         9.73E+03         2.13E+04

   SG11 | OM33      SG11 | OM44      SG11 | SG11      SG22 | TH 1      SG22 | TH 2      SG22 | TH 3      SG22 | TH 4    
     1.56E+04         9.41E+03         9.30E+04         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   SG22 | OM11      SG22 | OM22      SG22 | OM33      SG22 | OM44      SG22 | SG11      SG22 | SG22      
     6.27E+05         9.29E+04         5.09E+05         2.37E+06         6.67E+06         2.60E+09
 Elapsed finaloutput time in seconds:     0.05
 #CPUT: Total CPU Time in Seconds,        0.484
Stop Time: 
Sat 08/07/2021 
01:49 AM
