Mon 03/11/2019 
11:22 AM
;Model Desc: Population Mixture Problem in 1 Compartment model, with Volume and rate constant parameters
;            and their inter-subject variances modeled from two sub-populations
;Project Name: nm7examples
;Project ID: NO PROJECT DESCRIPTION

$PROB RUN#  pmixture.ctl
$INPUT C SET ID JID TIME CONC=DV DOSE=AMT RATE EVID MDV CMT VC1 K101 VC2 K102 SIGZ PROB
$DATA pmixture.csv IGNORE=C

$SUBROUTINES ADVAN1 TRANS1

; The mixture model uses THETA(5) as the mixture proportion parameter, defining the proportion
; of subjects in sub-population 1 (P(1), and in sub-population 2 (P(2)
$MIX
P(1)=THETA(5)
P(2)=1.0-THETA(5)
NSPOP=2

; Prior information setup for OMEGAS only

$PK
;  The MUs should always be unconditionally defined, that is, they should never be
; defined in IF?THEN blocks
; THETA(1) models the Volume of sub-population 1
MU_1=THETA(1)
; THETA(2) models the clearance of sub-population 1
MU_2=THETA(2)
; THETA(3) models the Volume of sub-population 2
MU_3=THETA(3)
; THETA(4) models the clearance of sub-population 2
MU_4=THETA(4)
VCM=DEXP(MU_1+ETA(1))
K10M=DEXP(MU_2+ETA(2))
VCF=DEXP(MU_3+ETA(3))
K10F=DEXP(MU_4+ETA(4))
Q=1
IF(MIXNUM.EQ.2) Q=0
V=Q*VCM+(1.0-Q)*VCF
K=Q*K10M+(1.0-Q)*K10F
S1=V
BESTSUB=MIXEST

$ERROR
Y = F + F*EPS(1)

; Initial THETAs
$THETA 4.3 -2.9 4.3 -0.67 (0.00001,0.5,0.99999)

;Initial OMEGA block 1, for sub-population 1
$OMEGA BLOCK(2)
 .04 ;[p]
 .01 ; [f]
.027; [p]

;Initial OMEGA block 2, for sub-population 2
$OMEGA BLOCK(2)
 .05; [p]
 .01; [f]
.06; [p]

$PRIOR NWPRI
; Degrees of Freedom defined for Priors. One for each OMEGA block defining each sub-popluation

; Prior OMEGA block 1.  Note that because the OMEGA is separated into blocks, so their priors
; should have the same block design.
$OMEGAP BLOCK(2)
 0.05 FIX
 0.0 0.05

; Prior OMEGA block 2
$OMEGAP BLOCK(2)
0.05 FIX
0.0 0.05
$OMEGAPD (2 FIX) (2 FIX)

$SIGMA 
0.01 ;[p]


$EST METHOD=ITS INTERACTION NITER=100 PRINT=1 NOABORT SIGL=8 CTYPE=3 CITER=10
     CALPHA=0.05 NOPRIOR=1
$EST METHOD=BAYES NITER=10000 AUTO=1 PRINT=100 FILE=pmixture_bayes.txt NOPRIOR=0
$COV MATRIX=R UNCONDITIONAL

$TABLE ID V K BESTSUB FIRSTONLY NOPRINT NOAPPEND FILE=pmixture_bayes.par
  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
  
License Registered to: IDS NONMEM 7 TEAM
Expiration Date:     2 JUN 2030
Current Date:       11 MAR 2019
Days until program expires :4096
1NONLINEAR MIXED EFFECTS MODEL PROGRAM (NONMEM) VERSION 7.4.3
 ORIGINALLY DEVELOPED BY STUART BEAL, LEWIS SHEINER, AND ALISON BOECKMANN
 CURRENT DEVELOPERS ARE ROBERT BAUER, ICON DEVELOPMENT SOLUTIONS,
 AND ALISON BOECKMANN. IMPLEMENTATION, EFFICIENCY, AND STANDARDIZATION
 PERFORMED BY NOUS INFOSYSTEMS.

 PROBLEM NO.:         1
 RUN#  pmixture.ctl
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:     2700
 NO. OF DATA ITEMS IN DATA SET:  17
 ID DATA ITEM IS DATA ITEM NO.:   3
 DEP VARIABLE IS DATA ITEM NO.:   6
 MDV DATA ITEM IS DATA ITEM NO.: 10
0INDICES PASSED TO SUBROUTINE PRED:
   9   5   7   8   0   0  11   0   0   0   0
0LABELS FOR DATA ITEMS:
 C SET ID JID TIME CONC DOSE RATE EVID MDV CMT VC1 K101 VC2 K102 SIGZ PROB
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 V K BESTSUB
0FORMAT FOR DATA:
 (2E1.0,3E3.0,E10.0,E3.0,4E1.0,E6.0,E8.0,E6.0,E7.0,E3.0,E5.0)

 TOT. NO. OF OBS RECS:     2400
 TOT. NO. OF INDIVIDUALS:      300
0LENGTH OF THETA:   7
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS BLOCK FORM:
  1
  1  1
  0  0  2
  0  0  2  2
  0  0  0  0  3
  0  0  0  0  3  3
  0  0  0  0  0  0  4
  0  0  0  0  0  0  4  4
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   1
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
 LOWER BOUND    INITIAL EST    UPPER BOUND
 -0.1000E+07     0.4300E+01     0.1000E+07
 -0.1000E+07    -0.2900E+01     0.1000E+07
 -0.1000E+07     0.4300E+01     0.1000E+07
 -0.1000E+07    -0.6700E+00     0.1000E+07
  0.1000E-04     0.5000E+00     0.1000E+01
  0.2000E+01     0.2000E+01     0.2000E+01
  0.2000E+01     0.2000E+01     0.2000E+01
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.4000E-01
                  0.1000E-01   0.2700E-01
        2                                                                                   NO
                  0.5000E-01
                  0.1000E-01   0.6000E-01
        3                                                                                  YES
                  0.5000E-01
                  0.0000E+00   0.5000E-01
        4                                                                                  YES
                  0.5000E-01
                  0.0000E+00   0.5000E-01
0INITIAL ESTIMATE OF SIGMA:
 0.1000E-01
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
0TABLES STEP OMITTED:    NO
 NO. OF TABLES:           1
 SEED NUMBER (SEED):    11456
 RANMETHOD:             3U
 MC SAMPLES (ESAMPLE):    300
 WRES SQUARE ROOT TYPE (WRESCHOL): EIGENVALUE
0-- TABLE   1 --
0RECORDS ONLY:    FIRSTONLY
04 COLUMNS APPENDED:    NO
 PRINTED:                NO
 HEADERS:               YES
 FILE TO BE FORWARDED:   NO
 FORMAT:                S1PE11.4
 LFORMAT:
 RFORMAT:
 FIXED_EFFECT_ETAS:
0USER-CHOSEN ITEMS:
 ID V K BESTSUB
0
 MIX SUBROUTINE USER-SUPPLIED
 PRIOR SUBROUTINE USER-SUPPLIED
1DOUBLE PRECISION PREDPP VERSION 7.4.3

 ONE COMPARTMENT MODEL (ADVAN1)
0MAXIMUM NO. OF BASIC PK PARAMETERS:   2
0BASIC PK PARAMETERS (AFTER TRANSLATION):
   ELIMINATION RATE (K) IS BASIC PK PARAMETER NO.:  1

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
   EVENT ID DATA ITEM IS DATA ITEM NO.:      9
   TIME DATA ITEM IS DATA ITEM NO.:          5
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   7
   DOSE RATE DATA ITEM IS DATA ITEM NO.:     8
   COMPT. NO. DATA ITEM IS DATA ITEM NO.:   11

0PK SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 PK SUBROUTINE NOT CALLED AT NONEVENT (ADDITIONAL OR LAGGED) DOSE TIMES.
0DURING SIMULATION, ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 OTHERWISE, ERROR SUBROUTINE CALLED ONCE IN THIS PROBLEM.
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
 NO. OF FUNCT. EVALS. ALLOWED:            1368
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
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      8
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     8
 NOPRIOR SETTING (NOPRIOR):                 ON
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): pmixture_bayes.ext
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
 CONVERGENCE TYPE (CTYPE):                  3
 CONVERGENCE INTERVAL (CINTERVAL):          1
 CONVERGENCE ITERATIONS (CITER):            10
 CONVERGENCE ALPHA ERROR (CALPHA):          5.000000000000000E-02
 ITERATIONS (NITER):                        100
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
   1   2   3   4
 THETAS THAT MODEL MIXTURE PROPORTIONS:
   5
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 iteration            0 OBJ=  -7355.30862651333
 iteration            1 OBJ=  -9620.67099710817
 iteration            2 OBJ=  -9852.69381840063
 iteration            3 OBJ=  -9925.50991994829
 iteration            4 OBJ=  -9949.92522421121
 iteration            5 OBJ=  -9957.45731079561
 iteration            6 OBJ=  -9959.96033371944
 iteration            7 OBJ=  -9960.92293067246
 iteration            8 OBJ=  -9961.33750043325
 iteration            9 OBJ=  -9961.52672001614
 iteration           10 OBJ=  -9961.61520226249
 iteration           11 OBJ=  -9961.65703515341
 iteration           12 OBJ=  -9961.67698989673
 iteration           13 OBJ=  -9961.68662276514
 iteration           14 OBJ=  -9961.69135465799
 iteration           15 OBJ=  -9961.69373499328
 iteration           16 OBJ=  -9961.69496896002
 iteration           17 OBJ=  -9961.69563140214
 iteration           18 OBJ=  -9961.69600072798
 iteration           19 OBJ=  -9961.69621441725
 iteration           20 OBJ=  -9961.69634234601
 iteration           21 OBJ=  -9961.69642126739
 iteration           22 OBJ=  -9961.69647111492
 iteration           23 OBJ=  -9961.69650305656
 iteration           24 OBJ=  -9961.69652394688
 iteration           25 OBJ=  -9961.69653769110
 iteration           26 OBJ=  -9961.69654675800
 iteration           27 OBJ=  -9961.69655292185
 iteration           28 OBJ=  -9961.69655689785
 iteration           29 OBJ=  -9961.69655957345
 Convergence achieved
 
 #TERM:
 OPTIMIZATION WAS COMPLETED


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND SE IS THE ASSOCIATED STANDARD ERROR.

 SUBMODEL    1
 
 ETABAR:        -2.3733E-07  1.4669E-06  0.0000E+00  0.0000E+00
 SE:             1.4891E-02  1.1044E-02  0.0000E+00  0.0000E+00
 N:                     200         200         200         200
 
 ETASHRINKSD(%)  1.9092E+00  5.0008E+00  1.0000E+02  1.0000E+02
 ETASHRINKVR(%)  3.7820E+00  9.7516E+00  1.0000E+02  1.0000E+02
 EBVSHRINKSD(%)  1.9912E+00  5.0815E+00  1.0000E+02  1.0000E+02
 EBVSHRINKVR(%)  3.9427E+00  9.9047E+00  1.0000E+02  1.0000E+02
 EPSSHRINKSD(%)  1.1410E+01
 EPSSHRINKVR(%)  2.1518E+01
 

 SUBMODEL    2
 
 ETABAR:         0.0000E+00  0.0000E+00  3.8813E-07  7.4580E-06
 SE:             0.0000E+00  0.0000E+00  2.1782E-02  2.4454E-02
 N:                     100         100         100         100
 
 ETASHRINKSD(%)  1.0000E+02  1.0000E+02  1.5775E+00  1.0000E-10
 ETASHRINKVR(%)  1.0000E+02  1.0000E+02  3.1301E+00  1.0000E-10
 EBVSHRINKSD(%)  1.0000E+02  1.0000E+02  1.9073E+00  1.0444E-01
 EBVSHRINKVR(%)  1.0000E+02  1.0000E+02  3.7781E+00  2.0877E-01
 EPSSHRINKSD(%)  1.4366E+01
 EPSSHRINKVR(%)  2.6669E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2400
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    4410.90495938243     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -9961.69655957345     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:      -5550.79160019102     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                          1200
  
 #TERE:
 Elapsed estimation  time in seconds:     8.84
 Elapsed covariance  time in seconds:     0.51
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************    -9961.697       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         4.24E+00 -2.29E+00  4.26E+00 -6.75E-01  6.67E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        4.63E-02
 
 ETA2
+       -8.56E-03  2.72E-02
 
 ETA3
+        0.00E+00  0.00E+00  4.95E-02
 
 ETA4
+        0.00E+00  0.00E+00 -1.10E-02  6.01E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        1.02E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        2.15E-01
 
 ETA2
+       -2.41E-01  1.65E-01
 
 ETA3
+        0.00E+00  0.00E+00  2.22E-01
 
 ETA4
+        0.00E+00  0.00E+00 -2.02E-01  2.45E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.01E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                          STANDARD ERROR OF ESTIMATE (S)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.57E-02  1.26E-02  2.27E-02  2.46E-02  2.72E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        5.41E-03
 
 ETA2
+        2.73E-03  2.51E-03
 
 ETA3
+        0.00E+00  0.00E+00  7.40E-03
 
 ETA4
+        0.00E+00  0.00E+00  5.80E-03  8.89E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        3.43E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        1.26E-02
 
 ETA2
+        6.75E-02  7.61E-03
 
 ETA3
+       ......... .........  1.66E-02
 
 ETA4
+       ......... .........  9.69E-02  1.81E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.70E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (S)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        2.48E-04
 
 TH 2
+       -5.26E-05  1.58E-04
 
 TH 3
+        1.71E-07 -4.40E-07  5.17E-04
 
 TH 4
+        1.44E-07 -3.55E-07 -1.13E-04  6.07E-04
 
 TH 5
+       -2.71E-07  7.07E-07 -8.96E-07 -7.27E-07  7.42E-04
 
 OM11
+       -8.31E-06  3.04E-06  3.16E-07  2.63E-07 -5.01E-07  2.93E-05
 
 OM12
+        3.48E-06  3.41E-06 -9.09E-08 -7.64E-08  1.43E-07 -7.69E-06  7.46E-06
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        3.17E-06 -5.21E-06 -4.79E-08 -3.49E-08  7.98E-08  1.02E-07 -2.28E-06  0.00E+00  0.00E+00  6.30E-06
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+       -1.33E-08  3.57E-08 -5.68E-06  4.20E-06  7.21E-08 -2.53E-08  7.28E-09  0.00E+00  0.00E+00  4.08E-09  0.00E+00  0.00E+00
          5.48E-05
 
 OM34
+       -5.19E-08  1.35E-07  4.24E-06 -4.39E-06  2.74E-07 -9.71E-08  2.80E-08  0.00E+00  0.00E+00  1.47E-08  0.00E+00  0.00E+00
         -1.48E-05  3.36E-05
 
 OM44
+       -1.09E-07  2.64E-07 -5.92E-06 -7.07E-06  5.42E-07 -1.97E-07  5.74E-08  0.00E+00  0.00E+00  2.52E-08  0.00E+00  0.00E+00
          3.59E-06 -2.06E-05  7.91E-05
 
 SG11
+        7.80E-08 -2.02E-07  2.59E-07  2.17E-07 -4.10E-07  1.44E-07 -4.13E-08  0.00E+00  0.00E+00 -2.22E-08  0.00E+00  0.00E+00
         -2.05E-08 -7.93E-08 -1.64E-07  1.18E-07
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (S)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        1.57E-02
 
 TH 2
+       -2.66E-01  1.26E-02
 
 TH 3
+        4.77E-04 -1.54E-03  2.27E-02
 
 TH 4
+        3.72E-04 -1.15E-03 -2.02E-01  2.46E-02
 
 TH 5
+       -6.32E-04  2.07E-03 -1.45E-03 -1.08E-03  2.72E-02
 
 OM11
+       -9.75E-02  4.47E-02  2.57E-03  1.97E-03 -3.40E-03  5.41E-03
 
 OM12
+        8.10E-02  9.94E-02 -1.46E-03 -1.14E-03  1.93E-03 -5.20E-01  2.73E-03
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        8.02E-02 -1.65E-01 -8.39E-04 -5.65E-04  1.17E-03  7.47E-03 -3.33E-01  0.00E+00  0.00E+00  2.51E-03
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+       -1.14E-04  3.84E-04 -3.38E-02  2.31E-02  3.58E-04 -6.32E-04  3.60E-04  0.00E+00  0.00E+00  2.20E-04  0.00E+00  0.00E+00
          7.40E-03
 
 OM34
+       -5.69E-04  1.86E-03  3.21E-02 -3.07E-02  1.73E-03 -3.09E-03  1.77E-03  0.00E+00  0.00E+00  1.01E-03  0.00E+00  0.00E+00
         -3.46E-01  5.80E-03
 
 OM44
+       -7.78E-04  2.37E-03 -2.93E-02 -3.23E-02  2.24E-03 -4.10E-03  2.36E-03  0.00E+00  0.00E+00  1.13E-03  0.00E+00  0.00E+00
          5.46E-02 -3.99E-01  8.89E-03
 
 SG11
+        1.44E-02 -4.68E-02  3.31E-02  2.57E-02 -4.38E-02  7.75E-02 -4.40E-02  0.00E+00  0.00E+00 -2.58E-02  0.00E+00  0.00E+00
         -8.07E-03 -3.98E-02 -5.35E-02  3.43E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        4.43E+03
 
 TH 2
+        1.47E+03  7.10E+03
 
 TH 3
+       -3.49E-03 -7.47E-02  2.02E+03
 
 TH 4
+       -1.98E-02 -2.18E-01  3.80E+02  1.73E+03
 
 TH 5
+       -7.75E-03 -8.34E-02 -1.74E-02 -5.74E-02  1.35E+03
 
 OM11
+        3.14E+02 -1.53E+03  2.24E-02  7.87E-02  3.00E-02  4.94E+04
 
 OM12
+       -3.08E+03 -4.33E+03 -4.36E-02 -2.82E-01 -1.12E-01  5.69E+04  2.20E+05
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+       -2.14E+03  3.63E+03 -5.91E-01 -1.74E+00 -6.69E-01  1.82E+04  7.66E+04  0.00E+00  0.00E+00  1.90E+05
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+       -1.79E-02  1.63E-01  1.54E+02 -2.55E+01  6.37E-02  1.63E-03 -3.33E-01  0.00E+00  0.00E+00  1.23E+00  0.00E+00  0.00E+00
          2.10E+04
 
 OM34
+        5.76E-02  1.43E+00 -5.48E+01  3.17E+02  4.36E-01 -4.14E-01  6.77E-01  0.00E+00  0.00E+00  1.13E+01  0.00E+00  0.00E+00
          1.04E+04  4.08E+04
 
 OM44
+        1.80E-01  2.04E+00  1.54E+02  2.59E+02  5.56E-01 -7.25E-01  2.54E+00  0.00E+00  0.00E+00  1.62E+01  0.00E+00  0.00E+00
          1.78E+03  1.03E+04  1.53E+04
 
 SG11
+       -2.29E+03  1.22E+04 -4.94E+03 -3.45E+03  4.69E+03 -3.98E+04  1.65E+04  0.00E+00  0.00E+00  4.81E+04  0.00E+00  0.00E+00
          1.28E+04  4.30E+04  2.76E+04  8.67E+06
 
1
 
 
 #TBLN:      2
 #METH: MCMC Bayesian Analysis
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            1368
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
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      8
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     8
 NOPRIOR SETTING (NOPRIOR):                 OFF
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): pmixture_bayes.txt
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
 SAMPLES FOR LOCAL SEARCH KERNEL (PSAMPLE_M2):           1
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
   1   2   3   4
 THETAS THAT MODEL MIXTURE PROPORTIONS:
   5
 THETAS THAT ARE GIBBS SAMPLED:
   1   2   3   4
 THETAS THAT ARE METROPOLIS-HASTINGS SAMPLED:
   5
 SIGMAS THAT ARE GIBBS SAMPLED:
   1
 SIGMAS THAT ARE METROPOLIS-HASTINGS SAMPLED:
 
 OMEGAS ARE GIBBS SAMPLED
 
 MONITORING OF SEARCH:

 Burn-in Mode
 iteration        -4000 MCMCOBJ=   -15266.8489042711     
 CINTERVAL IS           18
 iteration        -3900 MCMCOBJ=   -14820.8674772611     
 iteration        -3800 MCMCOBJ=   -14693.1389100082     
 Convergence achieved
 iteration        -3780 MCMCOBJ=   -14732.8024240824     
 Sampling Mode
 iteration            0 MCMCOBJ=   -14783.5854661427     
 iteration          100 MCMCOBJ=   -14738.8078955360     
 iteration          200 MCMCOBJ=   -14610.4725366520     
 iteration          300 MCMCOBJ=   -14705.2600447183     
 iteration          400 MCMCOBJ=   -14723.5329831743     
 iteration          500 MCMCOBJ=   -14613.7020269646     
 iteration          600 MCMCOBJ=   -14638.1711462026     
 iteration          700 MCMCOBJ=   -14617.1724595239     
 iteration          800 MCMCOBJ=   -14745.0470369321     
 iteration          900 MCMCOBJ=   -14665.3040926505     
 iteration         1000 MCMCOBJ=   -14663.2057950267     
 iteration         1100 MCMCOBJ=   -14769.7657661058     
 iteration         1200 MCMCOBJ=   -14609.2898135524     
 iteration         1300 MCMCOBJ=   -14734.6261315451     
 iteration         1400 MCMCOBJ=   -14693.6686127422     
 iteration         1500 MCMCOBJ=   -14695.8886425495     
 iteration         1600 MCMCOBJ=   -14674.0810943710     
 iteration         1700 MCMCOBJ=   -14630.0678827368     
 iteration         1800 MCMCOBJ=   -14575.3919174196     
 iteration         1900 MCMCOBJ=   -14598.2212069790     
 iteration         2000 MCMCOBJ=   -14625.1336215400     
 iteration         2100 MCMCOBJ=   -14619.0018263404     
 iteration         2200 MCMCOBJ=   -14559.4695388074     
 iteration         2300 MCMCOBJ=   -14734.7266350846     
 iteration         2400 MCMCOBJ=   -14675.2990176768     
 iteration         2500 MCMCOBJ=   -14595.6076134097     
 iteration         2600 MCMCOBJ=   -14688.2308713451     
 iteration         2700 MCMCOBJ=   -14585.1718500245     
 iteration         2800 MCMCOBJ=   -14615.6602933715     
 iteration         2900 MCMCOBJ=   -14702.8148300976     
 iteration         3000 MCMCOBJ=   -14642.9449457458     
 iteration         3100 MCMCOBJ=   -14790.8095850898     
 iteration         3200 MCMCOBJ=   -14674.5581292273     
 iteration         3300 MCMCOBJ=   -14529.0825600919     
 iteration         3400 MCMCOBJ=   -14739.2092138284     
 iteration         3500 MCMCOBJ=   -14580.4780385116     
 iteration         3600 MCMCOBJ=   -14662.9207231817     
 iteration         3700 MCMCOBJ=   -14676.5083800895     
 iteration         3800 MCMCOBJ=   -14688.0852342893     
 iteration         3900 MCMCOBJ=   -14755.7623488065     
 iteration         4000 MCMCOBJ=   -14718.0254694339     
 iteration         4100 MCMCOBJ=   -14688.8810413138     
 iteration         4200 MCMCOBJ=   -14656.0770193254     
 iteration         4300 MCMCOBJ=   -14610.7322189601     
 iteration         4400 MCMCOBJ=   -14724.6549434241     
 iteration         4500 MCMCOBJ=   -14715.5395295455     
 iteration         4600 MCMCOBJ=   -14606.8225094612     
 iteration         4700 MCMCOBJ=   -14597.3663219078     
 iteration         4800 MCMCOBJ=   -14683.6580524752     
 iteration         4900 MCMCOBJ=   -14584.3432133531     
 iteration         5000 MCMCOBJ=   -14750.4422042361     
 iteration         5100 MCMCOBJ=   -14524.5579030428     
 iteration         5200 MCMCOBJ=   -14753.7519423894     
 iteration         5300 MCMCOBJ=   -14641.4755544992     
 iteration         5400 MCMCOBJ=   -14663.6843685491     
 iteration         5500 MCMCOBJ=   -14591.8702086269     
 iteration         5600 MCMCOBJ=   -14639.0646976463     
 iteration         5700 MCMCOBJ=   -14659.3607042861     
 iteration         5800 MCMCOBJ=   -14560.8991870328     
 iteration         5900 MCMCOBJ=   -14568.0222958706     
 iteration         6000 MCMCOBJ=   -14660.5471974979     
 iteration         6100 MCMCOBJ=   -14736.0038856914     
 iteration         6200 MCMCOBJ=   -14707.1873102889     
 iteration         6300 MCMCOBJ=   -14621.3309847828     
 iteration         6400 MCMCOBJ=   -14696.1361428711     
 iteration         6500 MCMCOBJ=   -14706.1468069469     
 iteration         6600 MCMCOBJ=   -14703.0555082419     
 iteration         6700 MCMCOBJ=   -14723.1915599127     
 iteration         6800 MCMCOBJ=   -14766.9561080178     
 iteration         6900 MCMCOBJ=   -14672.4189556024     
 iteration         7000 MCMCOBJ=   -14595.9063224784     
 iteration         7100 MCMCOBJ=   -14657.1414124921     
 iteration         7200 MCMCOBJ=   -14659.1265350127     
 iteration         7300 MCMCOBJ=   -14589.8297302768     
 iteration         7400 MCMCOBJ=   -14748.9677825075     
 iteration         7500 MCMCOBJ=   -14608.3333252999     
 iteration         7600 MCMCOBJ=   -14649.3424204845     
 iteration         7700 MCMCOBJ=   -14595.2527806651     
 iteration         7800 MCMCOBJ=   -14743.5044855472     
 iteration         7900 MCMCOBJ=   -14497.3048903582     
 iteration         8000 MCMCOBJ=   -14727.7934955284     
 iteration         8100 MCMCOBJ=   -14578.6555808151     
 iteration         8200 MCMCOBJ=   -14576.4311620604     
 iteration         8300 MCMCOBJ=   -14686.9393318614     
 iteration         8400 MCMCOBJ=   -14706.2162680788     
 iteration         8500 MCMCOBJ=   -14628.0510105843     
 iteration         8600 MCMCOBJ=   -14660.5494401534     
 iteration         8700 MCMCOBJ=   -14655.2533955475     
 iteration         8800 MCMCOBJ=   -14675.5066419750     
 iteration         8900 MCMCOBJ=   -14609.7993233591     
 iteration         9000 MCMCOBJ=   -14641.1742090570     
 iteration         9100 MCMCOBJ=   -14530.6664406409     
 iteration         9200 MCMCOBJ=   -14628.1082284108     
 iteration         9300 MCMCOBJ=   -14563.9194496233     
 iteration         9400 MCMCOBJ=   -14686.7085654733     
 iteration         9500 MCMCOBJ=   -14677.5563342069     
 iteration         9600 MCMCOBJ=   -14702.7742781856     
 iteration         9700 MCMCOBJ=   -14631.9323584575     
 iteration         9800 MCMCOBJ=   -14608.2660107027     
 iteration         9900 MCMCOBJ=   -14716.3076975930     
 iteration        10000 MCMCOBJ=   -14694.2002503607     
 
 #TERM:
 BURN-IN WAS COMPLETED
 STATISTICAL PORTION WAS COMPLETED
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2400
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    4410.90495938243     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -14659.2819479338     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:      -10248.3769885514     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                          1200
 NIND*NETA*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    2205.45247969121     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -14659.2819479338     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:      -12453.8294682426     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 PRIOR CONSTANT TO OBJECTIVE FUNCTION:    28.5447777318297     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -14659.2819479338     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:      -14630.7371702020     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 #TERE:
 Elapsed estimation  time in seconds:   903.18
 Elapsed covariance  time in seconds:     0.00
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 #OBJT:**************                       AVERAGE VALUE OF LIKELIHOOD FUNCTION                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************   -14659.282       **************************************************
 #OBJS:********************************************       68.462 (STD) **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         4.24E+00 -2.30E+00  4.26E+00 -6.77E-01  6.66E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        4.71E-02
 
 ETA2
+       -8.66E-03  2.82E-02
 
 ETA3
+        0.00E+00  0.00E+00  5.13E-02
 
 ETA4
+        0.00E+00  0.00E+00 -1.10E-02  6.25E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        1.02E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        2.17E-01
 
 ETA2
+       -2.37E-01  1.68E-01
 
 ETA3
+        0.00E+00  0.00E+00  2.26E-01
 
 ETA4
+        0.00E+00  0.00E+00 -1.93E-01  2.49E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.01E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************                STANDARD ERROR OF ESTIMATE (From Sample Variance)               ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.55E-02  1.25E-02  2.32E-02  2.51E-02  2.69E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        5.03E-03
 
 ETA2
+        2.89E-03  3.20E-03
 
 ETA3
+        0.00E+00  0.00E+00  7.59E-03
 
 ETA4
+        0.00E+00  0.00E+00  5.85E-03  8.94E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        3.42E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        1.15E-02
 
 ETA2
+        7.08E-02  9.48E-03
 
 ETA3
+        0.00E+00  0.00E+00  1.66E-02
 
 ETA4
+        0.00E+00  0.00E+00  9.65E-02  1.77E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.69E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************               COVARIANCE MATRIX OF ESTIMATE (From Sample Variance)             ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        2.41E-04
 
 TH 2
+       -5.09E-05  1.57E-04
 
 TH 3
+       -6.96E-06 -3.90E-06  5.36E-04
 
 TH 4
+       -2.06E-06  2.37E-06 -1.25E-04  6.30E-04
 
 TH 5
+       -2.32E-06  2.17E-06 -2.19E-06 -1.12E-06  7.23E-04
 
 OM11
+        1.17E-06 -9.52E-07  1.12E-06 -1.89E-06 -1.49E-06  2.53E-05
 
 OM12
+        1.84E-07  7.11E-07 -4.99E-08  3.06E-07  6.79E-07 -5.46E-06  8.34E-06
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        1.02E-06 -1.62E-06  2.30E-07  5.29E-07 -5.61E-07  1.57E-06 -3.36E-06  0.00E+00  0.00E+00  1.03E-05
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+        4.64E-07  4.75E-07 -4.42E-07  8.66E-07  3.45E-06  4.84E-08 -4.30E-07  0.00E+00  0.00E+00  3.52E-07  0.00E+00  0.00E+00
          5.77E-05
 
 OM34
+       -3.22E-07 -6.30E-07  9.48E-07 -6.72E-06 -1.25E-08 -3.54E-07  4.99E-07  0.00E+00  0.00E+00 -6.52E-08  0.00E+00  0.00E+00
         -1.26E-05  3.42E-05
 
 OM44
+        5.16E-06 -3.74E-06 -3.43E-06 -2.66E-06  1.99E-06 -2.42E-07  2.49E-07  0.00E+00  0.00E+00 -1.46E-07  0.00E+00  0.00E+00
          1.29E-06 -1.26E-05  7.98E-05
 
 SG11
+       -5.39E-08 -1.86E-08  4.17E-08 -8.48E-08 -5.48E-08 -1.79E-08  1.28E-08  0.00E+00  0.00E+00 -2.68E-08  0.00E+00  0.00E+00
         -4.24E-08  5.74E-08 -1.85E-08  1.17E-07
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************              CORRELATION MATRIX OF ESTIMATE (From Sample Variance)             ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        1.55E-02
 
 TH 2
+       -2.62E-01  1.25E-02
 
 TH 3
+       -1.94E-02 -1.34E-02  2.32E-02
 
 TH 4
+       -5.28E-03  7.54E-03 -2.15E-01  2.51E-02
 
 TH 5
+       -5.56E-03  6.45E-03 -3.51E-03 -1.67E-03  2.69E-02
 
 OM11
+        1.50E-02 -1.51E-02  9.65E-03 -1.49E-02 -1.10E-02  5.03E-03
 
 OM12
+        4.10E-03  1.96E-02 -7.46E-04  4.22E-03  8.74E-03 -3.76E-01  2.89E-03
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        2.05E-02 -4.03E-02  3.10E-03  6.59E-03 -6.51E-03  9.75E-02 -3.63E-01  0.00E+00  0.00E+00  3.20E-03
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+        3.93E-03  4.99E-03 -2.51E-03  4.54E-03  1.69E-02  1.27E-03 -1.96E-02  0.00E+00  0.00E+00  1.45E-02  0.00E+00  0.00E+00
          7.59E-03
 
 OM34
+       -3.55E-03 -8.59E-03  6.99E-03 -4.58E-02 -7.97E-05 -1.20E-02  2.95E-02  0.00E+00  0.00E+00 -3.48E-03  0.00E+00  0.00E+00
         -2.85E-01  5.85E-03
 
 OM44
+        3.72E-02 -3.34E-02 -1.66E-02 -1.19E-02  8.28E-03 -5.38E-03  9.66E-03  0.00E+00  0.00E+00 -5.11E-03  0.00E+00  0.00E+00
          1.89E-02 -2.41E-01  8.94E-03
 
 SG11
+       -1.01E-02 -4.32E-03  5.25E-03 -9.87E-03 -5.95E-03 -1.04E-02  1.30E-02  0.00E+00  0.00E+00 -2.45E-02  0.00E+00  0.00E+00
         -1.63E-02  2.87E-02 -6.03E-03  3.42E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                              MCMC BAYESIAN ANALYSIS                            ********************
 ********************           INVERSE COVARIANCE MATRIX OF ESTIMATE (From Sample Variance)         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        4.46E+03
 
 TH 2
+        1.44E+03  6.85E+03
 
 TH 3
+        7.27E+01  6.81E+01  1.96E+03
 
 TH 4
+        2.26E+01 -4.05E+00  3.90E+02  1.67E+03
 
 TH 5
+        1.10E+01 -1.52E+01  6.02E+00  3.47E+00  1.38E+03
 
 OM11
+       -2.46E+02  9.00E+01 -7.25E+01  1.07E+02  6.61E+01  4.62E+04
 
 OM12
+       -5.21E+02 -2.36E+02 -9.61E+01 -6.77E+01 -5.02E+01  3.16E+04  1.60E+05
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+       -3.49E+02  8.56E+02 -8.03E+01 -1.32E+02  4.93E+01  3.32E+03  4.76E+04  0.00E+00  0.00E+00  1.13E+05
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+       -4.93E+01 -2.80E+01  2.06E+01  6.07E+01 -9.26E+01  2.05E+02  4.62E+02  0.00E+00  0.00E+00 -4.70E+02  0.00E+00  0.00E+00
          1.89E+04
 
 OM34
+       -2.74E+01  2.29E+02  7.21E+01  3.88E+02 -4.80E+01  1.47E+02 -1.99E+03  0.00E+00  0.00E+00 -6.53E+02  0.00E+00  0.00E+00
          7.31E+03  3.40E+04
 
 OM44
+       -2.20E+02  2.70E+02  1.06E+02  1.31E+02 -4.10E+01  8.73E+01 -6.20E+02  0.00E+00  0.00E+00  3.15E+01  0.00E+00  0.00E+00
          8.53E+02  5.27E+03  1.34E+04
 
 SG11
+        2.18E+03  1.87E+03 -3.97E+02  9.28E+02  6.61E+02  4.41E+03 -1.09E+03  0.00E+00  0.00E+00  2.12E+04  0.00E+00  0.00E+00
          3.25E+03 -1.28E+04 -9.76E+01  8.55E+06
 
 Elapsed postprocess time in seconds:     0.29
 Elapsed finaloutput time in seconds:     0.03
 #CPUT: Total CPU Time in Seconds,      869.674
Stop Time: 
Mon 03/11/2019 
11:37 AM
