Fri 03/08/2019 
10:34 AM
;Model Desc: Full model
;Project Name: chapter6
;Project ID: NO PROJECT DESCRIPTION

$PROB 
$INPUT C ID TIME DV AMT RATE WT AGE SEX
$DATA 501.csv IGNORE=C
$SUBROUTINE ADVAN1 TRANS2
$PK 
include \nonmem\nonmem_reserved_general
MUFIRSTREC=1
OBJQUICK=1
  LTVCL=THETA(1)+LOG(WT/70)*THETA(3)+LOG(AGE/50)*THETA(5)+SEX*THETA(7)
  LTVV=THETA(2)+LOG(WT/70)*THETA(4)+LOG(AGE/50)*THETA(6)+SEX*THETA(8)
  MU_1=LTVCL
  MU_2=LTVV
  CL=EXP(MU_1+ETA(1))
  V=EXP(MU_2+ETA(2))
  S1=V
$THETA
  0.7  ;[LCL]
  3.0 ;[LV]
  0.8    ;[CL~WT]
  0.8    ;[V~WT]
  -0.1   ;[CL~AGE]
  0.1    ;[V~AGE]
  0.7    ;[CL~SEX]
  0.7    ;[V~SEX]

$ERROR
  IPRE=A(1)/V
  Y=IPRE*(1+EPS(1))

$OMEGA BLOCK(2)
  0.1 ;[p]
  0.001 ;[f]
  0.1 ;[p]
$SIGMA 
  0.04 ;[p]

$PRIOR NWPRI
$THETAP (0.01 FIXED)X8
$THETAPV BLOCK(8) VALUES(100000.0,0.0) FIXED 
$OMEGAP  BLOCK(2) VALUES(0.04,0.0) FIXED
$OMEGAPD (2 FIXED)
$SIGMAP BLOCK(1) (0.05 FIXED)
$SIGMAPD (1 FIXED)

$EST METHOD=NUTS AUTO=1 PRINT=50 NITER=2000
$COV UNCONDITIONAL MATRIX=R PRINT=E
; Unless FNLETA=0, table items are evaluated at mode of posterior of each subject
$TABLE ID TIME DV IPRE CL V ETA1 ETA2 NOPRINT NOAPPEND ONEHEADER FORMAT=,1PE13.6 FILE=504_nuts.tab
  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
             
 (WARNING  121) INTERACTION IS IMPLIED WITH EM/BAYES ESTIMATION METHODS

 (MU_WARNING 20) MU_001: MU_ VARIABLE SHOULD NOT BE DEFINED AFTER VERBATIM CODE.

 (MU_WARNING 26) DATA ITEM(S) USED IN DEFINITION OF MU_(S) SHOULD BE CONSTANT FOR INDIV. REC.:
  WT AGE SEX
  
License Registered to: IDS NONMEM 7 TEAM
Expiration Date:     2 JUN 2030
Current Date:        8 MAR 2019
Days until program expires :4099
1NONLINEAR MIXED EFFECTS MODEL PROGRAM (NONMEM) VERSION 7.4.3
 ORIGINALLY DEVELOPED BY STUART BEAL, LEWIS SHEINER, AND ALISON BOECKMANN
 CURRENT DEVELOPERS ARE ROBERT BAUER, ICON DEVELOPMENT SOLUTIONS,
 AND ALISON BOECKMANN. IMPLEMENTATION, EFFICIENCY, AND STANDARDIZATION
 PERFORMED BY NOUS INFOSYSTEMS.

 PROBLEM NO.:         1

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
0LENGTH OF THETA:  18
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS BLOCK FORM:
  1
  1  1
  0  0  2
  0  0  2  2
  0  0  2  2  2
  0  0  2  2  2  2
  0  0  2  2  2  2  2
  0  0  2  2  2  2  2  2
  0  0  2  2  2  2  2  2  2
  0  0  2  2  2  2  2  2  2  2
  0  0  0  0  0  0  0  0  0  0  3
  0  0  0  0  0  0  0  0  0  0  3  3
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS BLOCK FORM:
  1
  0  2
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
 LOWER BOUND    INITIAL EST    UPPER BOUND
 -0.1000E+07     0.7000E+00     0.1000E+07
 -0.1000E+07     0.3000E+01     0.1000E+07
 -0.1000E+07     0.8000E+00     0.1000E+07
 -0.1000E+07     0.8000E+00     0.1000E+07
 -0.1000E+07    -0.1000E+00     0.1000E+07
 -0.1000E+07     0.1000E+00     0.1000E+07
 -0.1000E+07     0.7000E+00     0.1000E+07
 -0.1000E+07     0.7000E+00     0.1000E+07
  0.1000E-01     0.1000E-01     0.1000E-01
  0.1000E-01     0.1000E-01     0.1000E-01
  0.1000E-01     0.1000E-01     0.1000E-01
  0.1000E-01     0.1000E-01     0.1000E-01
  0.1000E-01     0.1000E-01     0.1000E-01
  0.1000E-01     0.1000E-01     0.1000E-01
  0.1000E-01     0.1000E-01     0.1000E-01
  0.1000E-01     0.1000E-01     0.1000E-01
  0.2000E+01     0.2000E+01     0.2000E+01
  0.1000E+01     0.1000E+01     0.1000E+01
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.1000E+00
                  0.1000E-02   0.1000E+00
        2                                                                                  YES
                  0.1000E+06
                  0.0000E+00   0.1000E+06
                  0.0000E+00   0.0000E+00   0.1000E+06
                  0.0000E+00   0.0000E+00   0.0000E+00   0.1000E+06
                  0.0000E+00   0.0000E+00   0.0000E+00   0.0000E+00   0.1000E+06
                  0.0000E+00   0.0000E+00   0.0000E+00   0.0000E+00   0.0000E+00   0.1000E+06
                  0.0000E+00   0.0000E+00   0.0000E+00   0.0000E+00   0.0000E+00   0.0000E+00   0.1000E+06
                  0.0000E+00   0.0000E+00   0.0000E+00   0.0000E+00   0.0000E+00   0.0000E+00   0.0000E+00   0.1000E+06
        3                                                                                  YES
                  0.4000E-01
                  0.0000E+00   0.4000E-01
0INITIAL ESTIMATE OF SIGMA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.4000E-01
        2                                                                                  YES
                  0.5000E-01
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
 ID TIME DV IPRE CL V ETA1 ETA2
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
 #METH: NUTS Bayesian Analysis
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            4760
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
 NOPRIOR SETTING (NOPRIOR):                 OFF
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): 504_nuts.ext
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
 CONVERGENCE TYPE (CTYPE):                  0
 KEEP ITERATIONS (THIN):            1
 BURN-IN ITERATIONS (NBURN):                10000
 ITERATIONS (NITER):                        2000
 ANEAL SETTING (CONSTRAIN):                 1
 STARTING SEED FOR MC METHODS (SEED):       11456
 MC SAMPLES PER SUBJECT (ISAMPLE):          1
 RANDOM SAMPLING METHOD (RANMETHOD):        3U
 PROPOSAL DENSITY SCALING RANGE
              (ISCALE_MIN, ISCALE_MAX):     1.000000000000000E-06   ,1000000.00000000
 SAMPLE ACCEPTANCE RATE (IACCEPT):          0.400000000000000
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
 SAMPLES FOR LOCAL SEARCH KERNEL (OSAMPLE_M2):           -1
 SAMPLES FOR LOCAL UNIVARIATE SEARCH KERNEL (OSAMPLE_M3):-1
 MASS/IMP./POST. MATRIX REFRESH SETTING (MASSREST):      -1
 MASS MATRIX ACCUMULATION ITERATIONS (MADAPT):          -1
 MASS MATRIX BLOCKING TYPE (NUTS_MASS):                 B
 MODEL PARAMETERS TRASNFORMED BY MASS MATRIX (NUTS_TRANSFORM=0)
 POWER TERM WEIGHTING FOR MASS MATRIX ACCUM. (KAPPA):   1.00000000000000
 NUTS SAMPLE ACCEPTANCE RATE (NUTS_DELTA):                   0.800000000000000
 NUTS GAMMA SETTING (NUTS_GAMMA):                            5.000000000000000E-02
 DEG. FR. FOR T DIST.  PRIOR FOR THETAS (TTDF):        0.00000000000000
 DEG. FR. FOR LKJ CORRELATION PRIOR FOR OMEGAS (OLKJDF): 0.00000000000000
 WEIGHT FACTOR FOR STD PRIOR FOR OMEGAS (OVARF): 1.00000000000000
 DEG. FR. FOR LKJ CORRELATION PRIOR FOR SIGMAS (SLKJDF): 0.00000000000000
 WEIGHT FACTOR FOR STD PRIOR FOR SIGMAS (SVARF): 1.00000000000000
 NUTS WARMUP METHOD (NUTS_TEST):       0
 NUTS MAXIMAL DEPTH SEARCH (NUTS_MAXDEPTH):       10
 NUTS STAGE I WARMUP ITERATIONS (NUTS_INIT):       75.0000000000000
 NUTS STAGE II base WARMUP ITERATIONS (NUTS_BASE): -3.00000000000000
 NUTS STAGE III FINAL ITERATIONS (NUTS_TERM): 50.0000000000000
 INITIAL ITERATIONS FOR STEP NUTS SIZE ASSESSMENT (NUTS_STEPITER): 1
 INTERVAL ITERATIONS FOR STEP NUTS SIZE ASSESSMENT (NUTS_STEPINTER):0
 ETA PARAMETERIZATION (NUTS_EPARAM):0
 OMEGA PARAMETERIZATION (NUTS_OPARAM):1
 SIGMA PARAMETERIZATION (NUTS_SPARAM):1
 NUTS REGULARIZING METHOD (NUTS_REG): 0.00000000000000

 
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
 THETAS THAT ARE GIBBS SAMPLED:
   1   2   3   4   5   6   7   8
 THETAS THAT ARE METROPOLIS-HASTINGS SAMPLED:
 
 SIGMAS THAT ARE GIBBS SAMPLED:
   1
 SIGMAS THAT ARE METROPOLIS-HASTINGS SAMPLED:
 
 OMEGAS ARE GIBBS SAMPLED
 
 MONITORING OF SEARCH:

 Burn-in Mode
 iteration         -279 MCMCOBJ=    2211.24944084305     
 iteration         -250 MCMCOBJ=    603.134252507333     
 iteration         -200 MCMCOBJ=    626.881400822849     
 iteration         -150 MCMCOBJ=    677.079957380939     
 iteration         -100 MCMCOBJ=    629.973749993790     
 iteration          -50 MCMCOBJ=    664.959610283189     
 Sampling Mode
 iteration            0 MCMCOBJ=    652.093782248772     
 iteration           50 MCMCOBJ=    668.186593851010     
 iteration          100 MCMCOBJ=    617.807878814427     
 iteration          150 MCMCOBJ=    614.296645765689     
 iteration          200 MCMCOBJ=    625.528039095176     
 iteration          250 MCMCOBJ=    642.391599814772     
 iteration          300 MCMCOBJ=    653.443483067929     
 iteration          350 MCMCOBJ=    655.975437939440     
 iteration          400 MCMCOBJ=    636.393149853218     
 iteration          450 MCMCOBJ=    653.871741226264     
 iteration          500 MCMCOBJ=    645.673031694226     
 iteration          550 MCMCOBJ=    640.638126492408     
 iteration          600 MCMCOBJ=    643.871808830434     
 iteration          650 MCMCOBJ=    618.841386718776     
 iteration          700 MCMCOBJ=    615.194323293650     
 iteration          750 MCMCOBJ=    642.111471651361     
 iteration          800 MCMCOBJ=    626.866408309013     
 iteration          850 MCMCOBJ=    656.570162511211     
 iteration          900 MCMCOBJ=    633.300949348020     
 iteration          950 MCMCOBJ=    660.259600937667     
 iteration         1000 MCMCOBJ=    612.338319541232     
 iteration         1050 MCMCOBJ=    656.339168582450     
 iteration         1100 MCMCOBJ=    633.801309940526     
 iteration         1150 MCMCOBJ=    675.653602802848     
 iteration         1200 MCMCOBJ=    645.581566611426     
 iteration         1250 MCMCOBJ=    644.235692446348     
 iteration         1300 MCMCOBJ=    626.473663850671     
 iteration         1350 MCMCOBJ=    647.953949321022     
 iteration         1400 MCMCOBJ=    665.649177151044     
 iteration         1450 MCMCOBJ=    653.859412312259     
 iteration         1500 MCMCOBJ=    665.490823479307     
 iteration         1550 MCMCOBJ=    603.205785264658     
 iteration         1600 MCMCOBJ=    656.801661294838     
 iteration         1650 MCMCOBJ=    620.088297420039     
 iteration         1700 MCMCOBJ=    616.764637879259     
 iteration         1750 MCMCOBJ=    678.513191609083     
 iteration         1800 MCMCOBJ=    634.344667717074     
 iteration         1850 MCMCOBJ=    636.616210655089     
 iteration         1900 MCMCOBJ=    651.498498789115     
 iteration         1950 MCMCOBJ=    647.819989700964     
 iteration         2000 MCMCOBJ=    660.386740053442     
 
 #TERM:
 BURN-IN WAS NOT TESTED FOR CONVERGENCE
 STATISTICAL PORTION WAS COMPLETED
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):          240
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    441.090495938243     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    638.217042339171     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       1079.30753827741     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           120
 NIND*NETA*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    220.545247969121     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    638.217042339171     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       858.762290308292     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 PRIOR CONSTANT TO OBJECTIVE FUNCTION:    126.804992662172     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    638.217042339171     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       765.022035001342     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 #TERE:
 Elapsed estimation  time in seconds:    26.01
 Elapsed covariance  time in seconds:     0.00
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              NUTS BAYESIAN ANALYSIS                            ********************
 #OBJT:**************                       AVERAGE VALUE OF LIKELIHOOD FUNCTION                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************      638.217       **************************************************
 #OBJS:********************************************       20.762 (STD) **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              NUTS BAYESIAN ANALYSIS                            ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         1.07E+00  3.46E+00  6.44E-01  1.32E+00 -5.57E-01  5.95E-02 -1.04E-01 -4.96E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        3.40E-02
 
 ETA2
+       -8.98E-04  5.25E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        5.22E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        1.82E-01
 
 ETA2
+       -2.94E-02  2.27E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.28E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              NUTS BAYESIAN ANALYSIS                            ********************
 ********************                STANDARD ERROR OF ESTIMATE (From Sample Variance)               ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         4.07E-02  5.11E-02  1.66E-01  2.10E-01  1.11E-01  1.38E-01  5.99E-02  7.46E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        1.07E-02
 
 ETA2
+        8.61E-03  1.53E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        7.02E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        2.86E-02
 
 ETA2
+        2.02E-01  3.28E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.52E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              NUTS BAYESIAN ANALYSIS                            ********************
 ********************               COVARIANCE MATRIX OF ESTIMATE (From Sample Variance)             ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        1.66E-03
 
 TH 2
+        2.97E-04  2.61E-03
 
 TH 3
+       -9.54E-04 -1.10E-05  2.76E-02
 
 TH 4
+       -2.24E-04 -2.15E-03  3.30E-03  4.39E-02
 
 TH 5
+        3.56E-04  2.59E-04 -2.46E-03 -1.05E-03  1.23E-02
 
 TH 6
+       -8.81E-05  5.39E-05 -2.98E-04 -3.84E-03  1.43E-03  1.91E-02
 
 TH 7
+       -1.47E-03 -1.60E-04 -2.21E-03 -1.93E-04  9.77E-04  2.31E-05  3.59E-03
 
 TH 8
+       -1.36E-04 -2.33E-03 -9.08E-04 -3.55E-03 -2.78E-04  1.13E-03  1.49E-04  5.56E-03
 
 OM11
+       -2.24E-05 -1.15E-05 -2.57E-05  1.26E-04  9.08E-05  1.90E-05  4.67E-05 -2.05E-05  1.15E-04
 
 OM12
+        3.07E-05  3.26E-06  9.36E-05  6.54E-05  6.31E-05 -3.42E-05 -1.20E-05 -2.77E-05  8.20E-06  7.41E-05
 
 OM22
+       -3.01E-05  4.56E-06 -6.37E-05  1.20E-04 -2.66E-05 -3.39E-05  4.37E-05 -6.16E-05  4.64E-06  1.63E-05  2.35E-04
 
 SG11
+        2.76E-05  2.34E-05 -3.48E-06 -3.06E-05 -4.09E-05  3.27E-05 -2.66E-05  2.89E-05 -2.01E-05 -5.29E-06 -2.20E-05  4.93E-05
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              NUTS BAYESIAN ANALYSIS                            ********************
 ********************              CORRELATION MATRIX OF ESTIMATE (From Sample Variance)             ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        4.07E-02
 
 TH 2
+        1.43E-01  5.11E-02
 
 TH 3
+       -1.41E-01 -1.30E-03  1.66E-01
 
 TH 4
+       -2.62E-02 -2.01E-01  9.47E-02  2.10E-01
 
 TH 5
+        7.89E-02  4.56E-02 -1.33E-01 -4.53E-02  1.11E-01
 
 TH 6
+       -1.56E-02  7.63E-03 -1.30E-02 -1.32E-01  9.29E-02  1.38E-01
 
 TH 7
+       -6.01E-01 -5.22E-02 -2.22E-01 -1.54E-02  1.47E-01  2.79E-03  5.99E-02
 
 TH 8
+       -4.48E-02 -6.12E-01 -7.33E-02 -2.27E-01 -3.36E-02  1.10E-01  3.33E-02  7.46E-02
 
 OM11
+       -5.13E-02 -2.11E-02 -1.45E-02  5.59E-02  7.63E-02  1.28E-02  7.27E-02 -2.57E-02  1.07E-02
 
 OM12
+        8.77E-02  7.41E-03  6.55E-02  3.62E-02  6.60E-02 -2.87E-02 -2.33E-02 -4.32E-02  8.89E-02  8.61E-03
 
 OM22
+       -4.83E-02  5.83E-03 -2.50E-02  3.73E-02 -1.57E-02 -1.60E-02  4.77E-02 -5.40E-02  2.82E-02  1.24E-01  1.53E-02
 
 SG11
+        9.66E-02  6.52E-02 -2.98E-03 -2.08E-02 -5.24E-02  3.36E-02 -6.33E-02  5.51E-02 -2.67E-01 -8.75E-02 -2.04E-01  7.02E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              NUTS BAYESIAN ANALYSIS                            ********************
 ********************           INVERSE COVARIANCE MATRIX OF ESTIMATE (From Sample Variance)         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        1.17E+03
 
 TH 2
+       -1.29E+02  7.94E+02
 
 TH 3
+        7.93E+01 -2.73E+00  4.46E+01
 
 TH 4
+       -7.12E+00  6.78E+01 -2.32E+00  3.04E+01
 
 TH 5
+       -5.89E+01  3.07E+00  2.38E+00  1.84E+00  8.90E+01
 
 TH 6
+        1.13E+01 -1.09E+01 -4.97E-02  3.02E+00 -7.05E+00  5.44E+01
 
 TH 7
+        5.32E+02 -3.47E+01  5.81E+01 -2.07E+00 -4.63E+01  6.45E+00  5.43E+02
 
 TH 8
+       -3.63E+01  3.79E+02  5.05E+00  4.68E+01  7.98E+00 -1.38E+01 -1.24E+01  3.74E+02
 
 OM11
+        3.37E+01 -3.10E+01  6.83E+00 -3.00E+01 -4.67E+01 -1.83E+01 -7.29E+01 -1.28E+01  9.52E+03
 
 OM12
+       -4.88E+02  6.08E+01 -8.34E+01 -5.50E+00 -5.90E+01  2.01E+01 -1.58E+02  4.67E+01 -8.16E+02  1.42E+04
 
 OM22
+        6.44E+01 -1.36E+01  1.92E+01 -9.28E+00  2.31E+01 -2.06E+00 -1.76E+01  3.14E+01  2.51E+02 -9.38E+02  4.54E+03
 
 SG11
+       -3.49E+02 -5.05E+02 -8.57E+00 -5.54E+01  6.66E+01 -3.57E+01 -7.50E+01 -3.26E+02  3.82E+03  8.33E+02  1.98E+03  2.34E+04
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              NUTS BAYESIAN ANALYSIS                            ********************
 ********************           EIGENVALUES OF COR MATRIX OF ESTIMATE (From Sample Variance)         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12

 
         2.44E-01  2.89E-01  6.58E-01  7.82E-01  8.89E-01  9.61E-01  1.01E+00  1.07E+00  1.32E+00  1.39E+00  1.60E+00  1.79E+00
 
 Elapsed postprocess time in seconds:     0.02
 Elapsed finaloutput time in seconds:     0.20
 #CPUT: Total CPU Time in Seconds,       24.009
Stop Time: 
Fri 03/08/2019 
10:35 AM
