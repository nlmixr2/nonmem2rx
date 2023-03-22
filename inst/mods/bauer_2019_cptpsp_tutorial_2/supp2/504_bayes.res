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

$EST METHOD=BAYES AUTO=1 PRINT=100 NITER=10000
$COV UNCONDITIONAL MATRIX=R PRINT=E
; Unless FNLETA=0, table items are evaluated at mode of posterior of each subject
$TABLE ID TIME DV IPRE CL V ETA1 ETA2 NOPRINT NOAPPEND ONEHEADER FORMAT=,1PE13.6 FILE=504_bayes.tab
  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
             
 (WARNING  121) INTERACTION IS IMPLIED WITH EM/BAYES ESTIMATION METHODS

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
 #METH: MCMC Bayesian Analysis
 
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
 RAW OUTPUT FILE (FILE): 504_bayes.ext
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
 SAMPLES FOR LOCAL SEARCH KERNEL (PSAMPLE_M2):           -1
 SAMPLES FOR LOCAL UNIVARIATE KERNEL (PSAMPLE_M3):       1
 METROPOLIS HASTINGS POPULATION SAMPLING FOR NON-GIBBS
 SAMPLED OMEGAS:
 SAMPLE ACCEPTANCE RATE (OACCEPT):                       0.500000000000000
 SAMPLES FOR GLOBAL SEARCH KERNEL (OSAMPLE_M1):          -1
 SAMPLES FOR LOCAL SEARCH KERNEL (OSAMPLE_M2):           3
 SAMPLES FOR LOCAL UNIVARIATE SEARCH KERNEL (OSAMPLE_M3):3
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
 iteration        -4000 MCMCOBJ=    2100.43402330502     
 CINTERVAL IS           18
 iteration        -3900 MCMCOBJ=    656.881073123527     
 iteration        -3800 MCMCOBJ=    656.072928659966     
 Convergence achieved
 iteration        -3780 MCMCOBJ=    668.866395287616     
 Sampling Mode
 iteration            0 MCMCOBJ=    671.412037474330     
 iteration          100 MCMCOBJ=    635.003468909454     
 iteration          200 MCMCOBJ=    631.765425668551     
 iteration          300 MCMCOBJ=    670.556610032913     
 iteration          400 MCMCOBJ=    655.503578991055     
 iteration          500 MCMCOBJ=    635.658394188179     
 iteration          600 MCMCOBJ=    636.142894858814     
 iteration          700 MCMCOBJ=    684.598282758425     
 iteration          800 MCMCOBJ=    677.576795700466     
 iteration          900 MCMCOBJ=    666.285393483004     
 iteration         1000 MCMCOBJ=    648.048505374811     
 iteration         1100 MCMCOBJ=    661.929714140695     
 iteration         1200 MCMCOBJ=    650.484841775611     
 iteration         1300 MCMCOBJ=    662.797557105432     
 iteration         1400 MCMCOBJ=    683.824558140597     
 iteration         1500 MCMCOBJ=    684.979781507188     
 iteration         1600 MCMCOBJ=    653.097918944010     
 iteration         1700 MCMCOBJ=    661.215774982812     
 iteration         1800 MCMCOBJ=    657.069021992138     
 iteration         1900 MCMCOBJ=    676.395382073536     
 iteration         2000 MCMCOBJ=    671.220745771329     
 iteration         2100 MCMCOBJ=    664.111968758979     
 iteration         2200 MCMCOBJ=    641.961051938004     
 iteration         2300 MCMCOBJ=    608.301085539029     
 iteration         2400 MCMCOBJ=    640.616716011302     
 iteration         2500 MCMCOBJ=    698.773789031335     
 iteration         2600 MCMCOBJ=    651.653449366273     
 iteration         2700 MCMCOBJ=    680.350703008426     
 iteration         2800 MCMCOBJ=    645.995437972893     
 iteration         2900 MCMCOBJ=    701.209364136934     
 iteration         3000 MCMCOBJ=    675.428274066289     
 iteration         3100 MCMCOBJ=    690.166285292186     
 iteration         3200 MCMCOBJ=    658.373434557551     
 iteration         3300 MCMCOBJ=    675.498199369477     
 iteration         3400 MCMCOBJ=    719.576145354003     
 iteration         3500 MCMCOBJ=    644.699468365220     
 iteration         3600 MCMCOBJ=    655.617933202887     
 iteration         3700 MCMCOBJ=    684.894302600079     
 iteration         3800 MCMCOBJ=    659.843000388329     
 iteration         3900 MCMCOBJ=    630.495771394000     
 iteration         4000 MCMCOBJ=    675.743430423754     
 iteration         4100 MCMCOBJ=    669.878656400278     
 iteration         4200 MCMCOBJ=    639.680907309181     
 iteration         4300 MCMCOBJ=    672.261546752832     
 iteration         4400 MCMCOBJ=    631.664135166854     
 iteration         4500 MCMCOBJ=    634.134497592080     
 iteration         4600 MCMCOBJ=    641.255741806707     
 iteration         4700 MCMCOBJ=    654.502078188792     
 iteration         4800 MCMCOBJ=    665.446613373465     
 iteration         4900 MCMCOBJ=    641.243301307049     
 iteration         5000 MCMCOBJ=    662.379715899065     
 iteration         5100 MCMCOBJ=    687.853722273282     
 iteration         5200 MCMCOBJ=    648.181222956693     
 iteration         5300 MCMCOBJ=    645.088048360976     
 iteration         5400 MCMCOBJ=    686.189834237819     
 iteration         5500 MCMCOBJ=    645.318015028485     
 iteration         5600 MCMCOBJ=    660.005865870510     
 iteration         5700 MCMCOBJ=    695.233630039472     
 iteration         5800 MCMCOBJ=    678.480484599330     
 iteration         5900 MCMCOBJ=    644.746058943459     
 iteration         6000 MCMCOBJ=    646.595776254934     
 iteration         6100 MCMCOBJ=    637.697369886240     
 iteration         6200 MCMCOBJ=    676.862335485902     
 iteration         6300 MCMCOBJ=    661.726068577640     
 iteration         6400 MCMCOBJ=    679.209982367394     
 iteration         6500 MCMCOBJ=    651.469791562824     
 iteration         6600 MCMCOBJ=    637.347115160974     
 iteration         6700 MCMCOBJ=    666.283800863873     
 iteration         6800 MCMCOBJ=    628.268037174648     
 iteration         6900 MCMCOBJ=    671.864760073480     
 iteration         7000 MCMCOBJ=    634.947748231145     
 iteration         7100 MCMCOBJ=    672.924767664529     
 iteration         7200 MCMCOBJ=    637.536539287802     
 iteration         7300 MCMCOBJ=    643.297878534068     
 iteration         7400 MCMCOBJ=    706.203063085269     
 iteration         7500 MCMCOBJ=    671.528270171511     
 iteration         7600 MCMCOBJ=    653.621284225319     
 iteration         7700 MCMCOBJ=    662.536586256450     
 iteration         7800 MCMCOBJ=    654.642141793325     
 iteration         7900 MCMCOBJ=    652.674573901082     
 iteration         8000 MCMCOBJ=    670.756460831749     
 iteration         8100 MCMCOBJ=    663.472798880187     
 iteration         8200 MCMCOBJ=    658.620418341133     
 iteration         8300 MCMCOBJ=    650.374048803744     
 iteration         8400 MCMCOBJ=    655.348800371456     
 iteration         8500 MCMCOBJ=    644.650872805923     
 iteration         8600 MCMCOBJ=    697.605199990737     
 iteration         8700 MCMCOBJ=    700.293846194430     
 iteration         8800 MCMCOBJ=    665.845950465464     
 iteration         8900 MCMCOBJ=    658.460271461741     
 iteration         9000 MCMCOBJ=    641.968645984272     
 iteration         9100 MCMCOBJ=    648.311630130301     
 iteration         9200 MCMCOBJ=    660.221788593631     
 iteration         9300 MCMCOBJ=    643.176881643374     
 iteration         9400 MCMCOBJ=    663.224653080962     
 iteration         9500 MCMCOBJ=    645.804311447978     
 iteration         9600 MCMCOBJ=    688.583746470786     
 iteration         9700 MCMCOBJ=    657.567480357417     
 iteration         9800 MCMCOBJ=    721.118322293627     
 iteration         9900 MCMCOBJ=    618.610734946431     
 iteration        10000 MCMCOBJ=    650.416193930182     
 
 #TERM:
 BURN-IN WAS COMPLETED
 STATISTICAL PORTION WAS COMPLETED
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):          240
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    441.090495938243     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    661.643356802072     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       1102.73385274032     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           120
 NIND*NETA*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    220.545247969121     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    661.643356802072     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       882.188604771194     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 PRIOR CONSTANT TO OBJECTIVE FUNCTION:    126.804992662172     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    661.643356802072     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       788.448349464244     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 #TERE:
 Elapsed estimation  time in seconds:    35.11
 Elapsed covariance  time in seconds:     0.00
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 #OBJT:**************                       AVERAGE VALUE OF LIKELIHOOD FUNCTION                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************      661.643       **************************************************
 #OBJS:********************************************       19.475 (STD) **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         1.07E+00  3.47E+00  6.41E-01  1.31E+00 -5.57E-01  5.55E-02 -1.03E-01 -5.18E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        2.85E-02
 
 ETA2
+       -1.80E-03  4.63E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        5.45E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        1.67E-01
 
 ETA2
+       -6.10E-02  2.13E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.33E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************                STANDARD ERROR OF ESTIMATE (From Sample Variance)               ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         3.91E-02  4.98E-02  1.65E-01  2.04E-01  1.06E-01  1.32E-01  5.89E-02  7.34E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        9.36E-03
 
 ETA2
+        7.72E-03  1.43E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        7.61E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        2.72E-02
 
 ETA2
+        2.10E-01  3.29E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.61E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************               COVARIANCE MATRIX OF ESTIMATE (From Sample Variance)             ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        1.53E-03
 
 TH 2
+        2.08E-04  2.48E-03
 
 TH 3
+       -8.62E-04 -2.29E-04  2.71E-02
 
 TH 4
+       -4.27E-04 -1.69E-03  2.43E-03  4.17E-02
 
 TH 5
+        8.69E-05 -1.18E-04 -5.90E-04  1.78E-04  1.12E-02
 
 TH 6
+       -1.60E-04 -4.44E-05  7.26E-05 -2.25E-03  1.50E-03  1.75E-02
 
 TH 7
+       -1.40E-03 -1.97E-04 -2.23E-03 -2.41E-04  8.40E-04 -5.97E-05  3.47E-03
 
 TH 8
+       -1.55E-04 -2.27E-03 -5.53E-04 -3.61E-03 -2.81E-04  1.17E-03  3.53E-04  5.39E-03
 
 OM11
+       -1.85E-06  1.76E-05  6.43E-05  7.41E-05  4.28E-05 -2.52E-05  1.18E-05 -3.28E-05  8.75E-05
 
 OM12
+        3.64E-05 -1.18E-05  5.51E-05  3.38E-05  1.85E-05 -1.62E-05 -2.82E-05 -1.29E-05  5.55E-06  5.95E-05
 
 OM22
+       -2.28E-05  4.98E-05 -2.04E-06  7.27E-05 -6.20E-05 -1.73E-05 -8.58E-07 -7.27E-05  1.13E-05  1.55E-05  2.06E-04
 
 SG11
+        1.49E-05  2.04E-05 -4.45E-05 -6.71E-05 -1.33E-05  3.04E-05 -4.05E-06  3.34E-05 -2.19E-05 -6.10E-06 -3.04E-05  5.79E-05
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************              CORRELATION MATRIX OF ESTIMATE (From Sample Variance)             ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        3.91E-02
 
 TH 2
+        1.07E-01  4.98E-02
 
 TH 3
+       -1.34E-01 -2.79E-02  1.65E-01
 
 TH 4
+       -5.36E-02 -1.66E-01  7.23E-02  2.04E-01
 
 TH 5
+        2.10E-02 -2.24E-02 -3.38E-02  8.25E-03  1.06E-01
 
 TH 6
+       -3.09E-02 -6.74E-03  3.33E-03 -8.35E-02  1.07E-01  1.32E-01
 
 TH 7
+       -6.08E-01 -6.71E-02 -2.30E-01 -2.00E-02  1.35E-01 -7.67E-03  5.89E-02
 
 TH 8
+       -5.40E-02 -6.20E-01 -4.57E-02 -2.41E-01 -3.61E-02  1.21E-01  8.17E-02  7.34E-02
 
 OM11
+       -5.07E-03  3.78E-02  4.17E-02  3.88E-02  4.32E-02 -2.04E-02  2.14E-02 -4.77E-02  9.36E-03
 
 OM12
+        1.21E-01 -3.08E-02  4.33E-02  2.14E-02  2.26E-02 -1.59E-02 -6.20E-02 -2.28E-02  7.68E-02  7.72E-03
 
 OM22
+       -4.07E-02  6.97E-02 -8.63E-04  2.48E-02 -4.08E-02 -9.13E-03 -1.02E-03 -6.90E-02  8.41E-02  1.40E-01  1.43E-02
 
 SG11
+        5.01E-02  5.38E-02 -3.55E-02 -4.32E-02 -1.66E-02  3.02E-02 -9.03E-03  5.98E-02 -3.07E-01 -1.04E-01 -2.78E-01  7.61E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************           INVERSE COVARIANCE MATRIX OF ESTIMATE (From Sample Variance)         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        1.26E+03
 
 TH 2
+       -7.55E+01  8.24E+02
 
 TH 3
+        8.49E+01  4.77E+00  4.51E+01
 
 TH 4
+        7.38E+00  6.49E+01 -7.26E-01  3.09E+01
 
 TH 5
+       -4.99E+01  2.11E+01 -2.62E+00  8.96E-01  9.52E+01
 
 TH 6
+        1.96E+01 -1.79E+01  5.86E-01  9.78E-01 -9.87E+00  5.98E+01
 
 TH 7
+        5.68E+02 -1.97E+01  6.33E+01  3.39E+00 -4.56E+01  1.28E+01  5.70E+02
 
 TH 8
+       -2.47E+01  3.95E+02  4.03E+00  4.77E+01  1.79E+01 -2.04E+01 -2.55E+01  3.92E+02
 
 OM11
+       -1.17E+02 -2.23E+02 -3.54E+01 -2.85E+01 -3.93E+01  1.20E+01 -1.11E+02 -7.03E+01  1.28E+04
 
 OM12
+       -6.35E+02  2.43E+02 -6.14E+01  5.91E+00 -1.54E+01  2.22E+00 -1.41E+02  1.05E+02 -6.90E+02  1.77E+04
 
 OM22
+        1.58E+02 -1.75E+02  1.65E+01 -1.25E+01  2.87E+01 -1.89E+00  5.31E+01 -2.40E+01  8.43E+01 -1.27E+03  5.43E+03
 
 SG11
+       -2.19E+02 -5.58E+02  3.30E-01 -3.38E+01  1.67E+01 -1.44E+01 -7.82E+01 -3.16E+02  4.86E+03  9.05E+02  2.79E+03  2.11E+04
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************           EIGENVALUES OF COR MATRIX OF ESTIMATE (From Sample Variance)         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12

 
         2.48E-01  2.81E-01  6.21E-01  7.98E-01  8.87E-01  9.60E-01  1.05E+00  1.08E+00  1.21E+00  1.46E+00  1.60E+00  1.81E+00
 
 Elapsed postprocess time in seconds:     0.01
 Elapsed finaloutput time in seconds:     0.16
 #CPUT: Total CPU Time in Seconds,       31.871
Stop Time: 
Fri 03/08/2019 
10:34 AM
