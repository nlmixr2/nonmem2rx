Mon 03/11/2019 
11:13 AM
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

$SIGMA 
0.01 ;[p]


$EST METHOD=ITS INTERACTION NITER=0
$EST METHOD=SAEM INTERACTION NITER=500 PRINT=10 SIGL=6 AUTO=1
$EST METHOD=IMP INTERACTION NITER=5 PRINT=1 EONLY=1 MAPITER=0 
$COV MATRIX=R UNCONDITIONAL

$TABLE ID V K BESTSUB FIRSTONLY NOPRINT NOAPPEND FILE=pmixture_saem.par
  
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
0LENGTH OF THETA:   5
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS BLOCK FORM:
  1
  1  1
  0  0  2
  0  0  2  2
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
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.4000E-01
                  0.1000E-01   0.2700E-01
        2                                                                                   NO
                  0.5000E-01
                  0.1000E-01   0.6000E-01
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
 #METH: Iterative Two Stage
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            624
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
 RAW OUTPUT FILE (FILE): pmixture_saem.ext
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
   1   2   3   4
 THETAS THAT MODEL MIXTURE PROPORTIONS:
   5
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 iteration            0 OBJ=  -7355.30862599272
 
 #TERM:
 OPTIMIZATION WAS NOT TESTED FOR CONVERGENCE


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND SE IS THE ASSOCIATED STANDARD ERROR.

 SUBMODEL    1
 
 ETABAR:        -7.7582E-03  4.9833E-01  0.0000E+00  0.0000E+00
 SE:             1.4793E-02  1.0360E-02  0.0000E+00  0.0000E+00
 N:                     189         189         189         189
 
 ETASHRINKSD(%)  1.0000E-10  1.3090E+01  1.0000E+02  1.0000E+02
 ETASHRINKVR(%)  1.0000E-10  2.4466E+01  1.0000E+02  1.0000E+02
 EBVSHRINKSD(%)  2.1271E+00  5.7430E+00  1.0000E+02  1.0000E+02
 EBVSHRINKVR(%)  4.2090E+00  1.1156E+01  1.0000E+02  1.0000E+02
 EPSSHRINKSD(%)  1.0000E-10
 EPSSHRINKVR(%)  1.0000E-10
 

 SUBMODEL    2
 
 ETABAR:         0.0000E+00  0.0000E+00 -5.9069E-02 -1.2596E-01
 SE:             0.0000E+00  0.0000E+00  2.1072E-02  4.0994E-02
 N:                     111         111         111         111
 
 ETASHRINKSD(%)  1.0000E+02  1.0000E+02  2.6667E-01  1.0000E-10
 ETASHRINKVR(%)  1.0000E+02  1.0000E+02  5.3263E-01  1.0000E-10
 EBVSHRINKSD(%)  1.0000E+02  1.0000E+02  1.8380E+00  1.9331E-01
 EBVSHRINKVR(%)  1.0000E+02  1.0000E+02  3.6421E+00  3.8625E-01
 EPSSHRINKSD(%)  1.3177E+01
 EPSSHRINKVR(%)  2.4617E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2400
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    4410.90495938243     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -7355.30862599272     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:      -2944.40366661029     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                          1200
  
 #TERE:
 Elapsed estimation  time in seconds:     0.35

 Number of Negative Eigenvalues in Matrix=           1
 Most negative value=  -187150915365.423
 Most positive value=   15973872.3695044
 Forcing positive definiteness
 Root mean square deviation of matrix from original=   7.286465024902573E-019

 Elapsed covariance  time in seconds:     0.15
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                               ITERATIVE TWO STAGE                              ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************    -7355.309       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                               ITERATIVE TWO STAGE                              ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         4.30E+00 -2.90E+00  4.30E+00 -6.70E-01  5.00E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        4.00E-02
 
 ETA2
+        1.00E-02  2.70E-02
 
 ETA3
+        0.00E+00  0.00E+00  5.00E-02
 
 ETA4
+        0.00E+00  0.00E+00  1.00E-02  6.00E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        1.00E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        2.00E-01
 
 ETA2
+        3.04E-01  1.64E-01
 
 ETA3
+        0.00E+00  0.00E+00  2.24E-01
 
 ETA4
+        0.00E+00  0.00E+00  1.83E-01  2.45E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.00E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                               ITERATIVE TWO STAGE                              ********************
 ********************                          STANDARD ERROR OF ESTIMATE (S)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         4.82E-02  2.04E-02  2.49E-02  2.57E-02  5.17E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        4.47E-03
 
 ETA2
+        2.84E-03  1.95E-03
 
 ETA3
+        0.00E+00  0.00E+00  7.12E-03
 
 ETA4
+        0.00E+00  0.00E+00  3.95E-03  2.98E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        7.94E+04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        1.12E-02
 
 ETA2
+        7.09E-02  5.93E-03
 
 ETA3
+       ......... .........  1.59E-02
 
 ETA4
+       ......... .........  6.68E-02  6.08E-03
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        3.97E+05
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                               ITERATIVE TWO STAGE                              ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (S)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        2.33E-03
 
 TH 2
+        4.61E-04  4.15E-04
 
 TH 3
+        1.20E-05  6.17E-05  6.22E-04
 
 TH 4
+       -5.01E-06  3.56E-05  3.20E-04  6.58E-04
 
 TH 5
+       -1.02E-04 -5.18E-04 -2.97E-04 -2.04E-04  2.67E-03
 
 OM11
+       -4.70E-05 -1.44E-05  1.26E-07  2.16E-07 -2.17E-06  1.99E-05
 
 OM12
+       -1.20E-04 -2.78E-05 -5.37E-07  5.64E-07  3.46E-06  7.48E-06  8.09E-06
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+       -5.02E-05 -3.63E-05 -3.24E-06 -1.35E-06  2.48E-05  2.85E-06  3.67E-06  0.00E+00  0.00E+00  3.79E-06
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+       -2.54E-06  5.93E-07  4.99E-05  2.05E-05 -1.97E-05 -1.50E-08  2.30E-07  0.00E+00  0.00E+00  2.14E-07  0.00E+00  0.00E+00
          5.07E-05
 
 OM34
+       -6.24E-06  3.60E-06  3.29E-05  3.60E-05 -4.77E-05  1.06E-07  5.41E-07  0.00E+00  0.00E+00  2.71E-07  0.00E+00  0.00E+00
          1.24E-05  1.56E-05
 
 OM44
+       -2.56E-06  1.85E-06  3.01E-05  6.15E-05  6.98E-06 -3.08E-08  5.56E-08  0.00E+00  0.00E+00 -3.03E-07  0.00E+00  0.00E+00
          1.75E-06  2.23E-06  8.88E-06
 
 SG11
+       -1.19E-04 -3.05E-05 -3.12E-05 -2.01E-05  8.93E-05  2.02E-06  5.93E-06  0.00E+00  0.00E+00  2.45E-06  0.00E+00  0.00E+00
          1.49E-06 -1.47E-06 -9.45E-07  6.31E+09
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                               ITERATIVE TWO STAGE                              ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (S)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        4.82E-02
 
 TH 2
+        4.70E-01  2.04E-02
 
 TH 3
+        9.95E-03  1.21E-01  2.49E-02
 
 TH 4
+       -4.05E-03  6.82E-02  5.01E-01  2.57E-02
 
 TH 5
+       -4.11E-02 -4.92E-01 -2.31E-01 -1.54E-01  5.17E-02
 
 OM11
+       -2.18E-01 -1.59E-01  1.14E-03  1.88E-03 -9.41E-03  4.47E-03
 
 OM12
+       -8.74E-01 -4.79E-01 -7.57E-03  7.73E-03  2.35E-02  5.89E-01  2.84E-03
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+       -5.35E-01 -9.14E-01 -6.67E-02 -2.71E-02  2.47E-01  3.27E-01  6.62E-01  0.00E+00  0.00E+00  1.95E-03
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+       -7.39E-03  4.09E-03  2.81E-01  1.12E-01 -5.34E-02 -4.71E-04  1.13E-02  0.00E+00  0.00E+00  1.54E-02  0.00E+00  0.00E+00
          7.12E-03
 
 OM34
+       -3.27E-02  4.47E-02  3.34E-01  3.55E-01 -2.34E-01  5.98E-03  4.81E-02  0.00E+00  0.00E+00  3.53E-02  0.00E+00  0.00E+00
          4.39E-01  3.95E-03
 
 OM44
+       -1.78E-02  3.05E-02  4.05E-01  8.05E-01  4.53E-02 -2.31E-03  6.56E-03  0.00E+00  0.00E+00 -5.21E-02  0.00E+00  0.00E+00
          8.23E-02  1.90E-01  2.98E-03
 
 SG11
+       -3.12E-08 -1.88E-08 -1.57E-08 -9.86E-09  2.18E-08  5.70E-09  2.63E-08  0.00E+00  0.00E+00  1.58E-08  0.00E+00  0.00E+00
          2.64E-09 -4.67E-09 -3.99E-09  7.94E+04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                               ITERATIVE TWO STAGE                              ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        1.15E+04
 
 TH 2
+       -2.39E+04  8.40E+04
 
 TH 3
+       -1.86E+00  1.09E+02  2.40E+03
 
 TH 4
+        3.94E+02 -1.36E+03 -8.15E+02  5.66E+03
 
 TH 5
+       -1.93E+03  7.44E+03  1.83E+02  2.73E+02  1.17E+03
 
 OM11
+       -4.86E+04  8.64E+04 -1.45E+02 -1.77E+03  6.68E+03  2.88E+05
 
 OM12
+        2.62E+05 -5.67E+05 -3.27E+01  1.27E+04 -4.40E+04 -1.17E+06  6.27E+06
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+       -2.80E+05  9.23E+05  1.73E+03 -2.17E+04  7.55E+04  1.06E+06 -6.86E+06  0.00E+00  0.00E+00  1.08E+07
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+        8.36E+01 -1.10E+02 -1.63E+03  1.40E+03 -2.44E+02 -5.71E+02  2.76E+03  0.00E+00  0.00E+00 -1.81E+03  0.00E+00  0.00E+00
          2.57E+04
 
 OM34
+       -8.90E+00 -2.27E+03 -1.09E+03 -6.04E+03  8.26E+02  3.47E+03 -8.88E+02  0.00E+00  0.00E+00 -3.59E+04  0.00E+00  0.00E+00
         -2.03E+04  9.65E+04
 
 OM44
+       -4.25E+03  1.47E+04 -2.00E+03 -3.58E+04 -2.83E+03  1.91E+04 -1.37E+05  0.00E+00  0.00E+00  2.34E+05  0.00E+00  0.00E+00
         -3.94E+03  2.38E+04  3.69E+05
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... .........
 
1
 
 
 #TBLN:      2
 #METH: Stochastic Approximation Expectation-Maximization (No Prior)
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            624
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
 NOPRIOR SETTING (NOPRIOR):                 ON
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): pmixture_saem.ext
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
   1   2   3   4
 THETAS THAT MODEL MIXTURE PROPORTIONS:
   5
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 ISAMPLE PreProcessing
 iteration         -200 SAEMOBJ=  -13389.3622433969
 iteration         -190 SAEMOBJ=  -14714.4529123771
 iteration         -180 SAEMOBJ=  -14998.1333308597
 iteration         -170 SAEMOBJ=  -14912.2830710283
 iteration         -160 SAEMOBJ=  -14965.8472929381
 iteration         -150 SAEMOBJ=  -14921.3609123462
 iteration         -140 SAEMOBJ=  -14990.9765428361
 iteration         -130 SAEMOBJ=  -15012.4227378416
 iteration         -120 SAEMOBJ=  -14971.4256748435
 iteration         -110 SAEMOBJ=  -14929.7716989763
 iteration         -100 SAEMOBJ=  -14944.4384482320
 iteration          -90 SAEMOBJ=  -14988.4317032248
 iteration          -80 SAEMOBJ=  -14975.4004461652
 iteration          -70 SAEMOBJ=  -14910.7093580465
 iteration          -60 SAEMOBJ=  -14937.5076254175
 iteration          -50 SAEMOBJ=  -14954.5908360478
 iteration          -40 SAEMOBJ=  -14910.4591560697
 iteration          -30 SAEMOBJ=  -14959.6307041053
 iteration          -20 SAEMOBJ=  -14920.1737442535
 iteration          -10 SAEMOBJ=  -14973.1320868083
 Stochastic/Burn-in Mode
 iteration        -4000 SAEMOBJ=  -14718.3704500755
 iteration        -3990 SAEMOBJ=  -14773.4644838442
 iteration        -3980 SAEMOBJ=  -14792.6039383909
 iteration        -3970 SAEMOBJ=  -14853.9291847404
 CINTERVAL IS           24
 iteration        -3960 SAEMOBJ=  -14957.8817031951
 iteration        -3950 SAEMOBJ=  -14954.5319809152
 iteration        -3940 SAEMOBJ=  -14965.6604753764
 iteration        -3930 SAEMOBJ=  -14947.4446141053
 iteration        -3920 SAEMOBJ=  -14916.2831750293
 iteration        -3910 SAEMOBJ=  -14908.3027037680
 iteration        -3900 SAEMOBJ=  -14940.2008404251
 iteration        -3890 SAEMOBJ=  -14910.6652756960
 iteration        -3880 SAEMOBJ=  -14865.7264682579
 iteration        -3870 SAEMOBJ=  -14919.0186982634
 iteration        -3860 SAEMOBJ=  -14962.9717246601
 iteration        -3850 SAEMOBJ=  -14941.0641466683
 iteration        -3840 SAEMOBJ=  -14965.7048951495
 iteration        -3830 SAEMOBJ=  -14862.5417253592
 iteration        -3820 SAEMOBJ=  -14933.4724818317
 iteration        -3810 SAEMOBJ=  -14906.7373472268
 iteration        -3800 SAEMOBJ=  -14873.3220272871
 iteration        -3790 SAEMOBJ=  -14923.9368161915
 iteration        -3780 SAEMOBJ=  -14955.3536967054
 iteration        -3770 SAEMOBJ=  -14924.4629108057
 iteration        -3760 SAEMOBJ=  -14930.8734053069
 iteration        -3750 SAEMOBJ=  -14907.6883978292
 iteration        -3740 SAEMOBJ=  -14921.8233456584
 iteration        -3730 SAEMOBJ=  -14959.4296678681
 iteration        -3720 SAEMOBJ=  -14880.3518122544
 Convergence achieved
 Reduced Stochastic/Accumulation Mode
 iteration            0 SAEMOBJ=  -14954.4249028555
 iteration           10 SAEMOBJ=  -15085.5535137568
 iteration           20 SAEMOBJ=  -15090.8542256686
 iteration           30 SAEMOBJ=  -15090.7007380395
 iteration           40 SAEMOBJ=  -15089.9795202772
 iteration           50 SAEMOBJ=  -15091.7139790549
 iteration           60 SAEMOBJ=  -15091.1045949977
 iteration           70 SAEMOBJ=  -15091.7593993444
 iteration           80 SAEMOBJ=  -15090.9089759302
 iteration           90 SAEMOBJ=  -15090.9298819211
 iteration          100 SAEMOBJ=  -15090.5852625834
 iteration          110 SAEMOBJ=  -15089.9368675864
 iteration          120 SAEMOBJ=  -15089.9026738648
 iteration          130 SAEMOBJ=  -15091.1198410608
 iteration          140 SAEMOBJ=  -15091.2424618499
 iteration          150 SAEMOBJ=  -15090.6188423379
 iteration          160 SAEMOBJ=  -15089.8919711852
 iteration          170 SAEMOBJ=  -15090.3390878295
 iteration          180 SAEMOBJ=  -15090.2867395027
 iteration          190 SAEMOBJ=  -15090.7182771808
 iteration          200 SAEMOBJ=  -15090.6876432384
 iteration          210 SAEMOBJ=  -15090.7861088165
 iteration          220 SAEMOBJ=  -15090.8552733604
 iteration          230 SAEMOBJ=  -15090.4881040416
 iteration          240 SAEMOBJ=  -15090.3905052811
 iteration          250 SAEMOBJ=  -15089.8403524292
 iteration          260 SAEMOBJ=  -15090.0972825817
 iteration          270 SAEMOBJ=  -15089.9529821065
 iteration          280 SAEMOBJ=  -15089.6691928506
 iteration          290 SAEMOBJ=  -15089.6536398561
 iteration          300 SAEMOBJ=  -15089.6463299717
 iteration          310 SAEMOBJ=  -15090.0719244089
 iteration          320 SAEMOBJ=  -15089.7149683029
 iteration          330 SAEMOBJ=  -15089.7015021728
 iteration          340 SAEMOBJ=  -15089.4174868269
 iteration          350 SAEMOBJ=  -15089.2472102423
 iteration          360 SAEMOBJ=  -15089.0172133682
 iteration          370 SAEMOBJ=  -15089.0027662981
 iteration          380 SAEMOBJ=  -15088.6433238044
 iteration          390 SAEMOBJ=  -15088.8979253551
 iteration          400 SAEMOBJ=  -15088.8707359662
 iteration          410 SAEMOBJ=  -15088.8167981673
 iteration          420 SAEMOBJ=  -15088.7005180178
 iteration          430 SAEMOBJ=  -15088.7247405761
 iteration          440 SAEMOBJ=  -15089.0665293725
 iteration          450 SAEMOBJ=  -15089.1392867051
 iteration          460 SAEMOBJ=  -15088.9928832781
 iteration          470 SAEMOBJ=  -15088.8337612380
 iteration          480 SAEMOBJ=  -15088.8063692534
 iteration          490 SAEMOBJ=  -15089.0721218812
 iteration          500 SAEMOBJ=  -15088.9733024992
 
 #TERM:
 STOCHASTIC PORTION WAS COMPLETED
 REDUCED STOCHASTIC PORTION WAS COMPLETED

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND SE IS THE ASSOCIATED STANDARD ERROR.

 SUBMODEL    1
 
 ETABAR:        -3.9714E-04  5.0573E-05 -2.7131E-04  1.8479E-03
 SE:             1.4890E-02  1.1138E-02  5.0283E-04  6.0308E-04
 N:                     200         200         200         200
 
 ETASHRINKSD(%)  1.9543E+00  5.2058E+00  9.6756E+01  9.6534E+01
 ETASHRINKVR(%)  3.8703E+00  1.0141E+01  9.9895E+01  9.9880E+01
 EBVSHRINKSD(%)  2.0071E+00  5.1478E+00  8.9180E+01  1.0000E+02
 EBVSHRINKVR(%)  3.9739E+00  1.0031E+01  9.8829E+01  1.0000E+02
 EPSSHRINKSD(%)  1.1616E+01
 EPSSHRINKVR(%)  2.1882E+01
 

 SUBMODEL    2
 
 ETABAR:         7.7429E-04 -9.2654E-05  5.2589E-04 -3.6117E-03
 SE:             6.7173E-04  5.5687E-04  2.1749E-02  2.4486E-02
 N:                     100         100         100         100
 
 ETASHRINKSD(%)  9.6865E+01  9.6640E+01  5.3475E-01  2.2866E-01
 ETASHRINKVR(%)  9.9902E+01  9.9887E+01  1.0667E+00  4.5680E-01
 EBVSHRINKSD(%)  9.8346E+01  1.0000E+02  1.9423E+00  1.0688E-01
 EBVSHRINKVR(%)  9.9973E+01  1.0000E+02  3.8468E+00  2.1365E-01
 EPSSHRINKSD(%)  1.4539E+01
 EPSSHRINKVR(%)  2.6965E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2400
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    4410.90495938243     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -15088.9733024992     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:      -10678.0683431168     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                          1200
 NIND*NETA*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    2205.45247969121     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -15088.9733024992     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:      -12883.5208228080     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 #TERE:
 Elapsed estimation  time in seconds:   124.93
 Elapsed covariance  time in seconds:     0.21
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 #OBJT:**************                        FINAL VALUE OF LIKELIHOOD FUNCTION                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************   -15088.973       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         4.24E+00 -2.30E+00  4.26E+00 -6.73E-01  6.67E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        4.64E-02
 
 ETA2
+       -8.51E-03  2.77E-02
 
 ETA3
+        0.00E+00  0.00E+00  4.83E-02
 
 ETA4
+        0.00E+00  0.00E+00 -1.07E-02  6.08E-02
 


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
+       -2.37E-01  1.67E-01
 
 ETA3
+        0.00E+00  0.00E+00  2.20E-01
 
 ETA4
+        0.00E+00  0.00E+00 -1.98E-01  2.47E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.01E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                          STANDARD ERROR OF ESTIMATE (S)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.57E-02  1.27E-02  2.22E-02  2.49E-02  2.73E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        5.42E-03
 
 ETA2
+        2.76E-03  2.59E-03
 
 ETA3
+        0.00E+00  0.00E+00  7.08E-03
 
 ETA4
+        0.00E+00  0.00E+00  5.70E-03  9.05E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        3.42E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        1.26E-02
 
 ETA2
+        6.78E-02  7.77E-03
 
 ETA3
+       ......... .........  1.61E-02
 
 ETA4
+       ......... .........  9.64E-02  1.83E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.69E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (S)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        2.48E-04
 
 TH 2
+       -5.19E-05  1.62E-04
 
 TH 3
+        7.91E-07 -1.84E-06  4.94E-04
 
 TH 4
+        1.21E-06 -2.09E-06 -1.08E-04  6.18E-04
 
 TH 5
+        1.41E-06  8.57E-07  5.24E-07 -1.28E-05  7.43E-04
 
 OM11
+       -8.18E-06  3.06E-06  7.90E-07  4.51E-07 -7.61E-07  2.94E-05
 
 OM12
+        3.53E-06  3.53E-06  3.62E-08 -1.17E-07  6.07E-07 -7.68E-06  7.64E-06
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        3.22E-06 -5.53E-06 -4.46E-08  2.61E-07  2.66E-07  6.58E-08 -2.34E-06  0.00E+00  0.00E+00  6.69E-06
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+        4.98E-08 -4.92E-07 -5.96E-06  4.06E-06  3.71E-06 -2.11E-07  6.70E-08  0.00E+00  0.00E+00  7.38E-08  0.00E+00  0.00E+00
          5.01E-05
 
 OM34
+        8.45E-08  6.50E-07  5.86E-06 -5.64E-06 -6.14E-07  1.97E-08  4.52E-08  0.00E+00  0.00E+00 -5.28E-08  0.00E+00  0.00E+00
         -1.36E-05  3.25E-05
 
 OM44
+       -6.88E-08 -3.88E-07 -7.11E-06 -2.24E-06 -1.13E-06 -1.90E-07 -1.60E-07  0.00E+00  0.00E+00  2.19E-07  0.00E+00  0.00E+00
          3.24E-06 -2.00E-05  8.19E-05
 
 SG11
+        8.47E-08 -2.57E-07  2.49E-07  2.65E-07 -4.41E-07  1.38E-07 -3.56E-08  0.00E+00  0.00E+00 -2.18E-08  0.00E+00  0.00E+00
         -2.11E-08 -8.27E-08 -1.70E-07  1.17E-07
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (S)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        1.57E-02
 
 TH 2
+       -2.59E-01  1.27E-02
 
 TH 3
+        2.26E-03 -6.51E-03  2.22E-02
 
 TH 4
+        3.10E-03 -6.60E-03 -1.95E-01  2.49E-02
 
 TH 5
+        3.30E-03  2.47E-03  8.65E-04 -1.89E-02  2.73E-02
 
 OM11
+       -9.59E-02  4.44E-02  6.55E-03  3.34E-03 -5.15E-03  5.42E-03
 
 OM12
+        8.12E-02  1.00E-01  5.89E-04 -1.71E-03  8.05E-03 -5.12E-01  2.76E-03
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        7.90E-02 -1.68E-01 -7.76E-04  4.06E-03  3.77E-03  4.69E-03 -3.27E-01  0.00E+00  0.00E+00  2.59E-03
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+        4.47E-04 -5.46E-03 -3.79E-02  2.31E-02  1.92E-02 -5.50E-03  3.42E-03  0.00E+00  0.00E+00  4.03E-03  0.00E+00  0.00E+00
          7.08E-03
 
 OM34
+        9.41E-04  8.96E-03  4.62E-02 -3.98E-02 -3.95E-03  6.37E-04  2.87E-03  0.00E+00  0.00E+00 -3.58E-03  0.00E+00  0.00E+00
         -3.36E-01  5.70E-03
 
 OM44
+       -4.83E-04 -3.37E-03 -3.53E-02 -9.96E-03 -4.56E-03 -3.88E-03 -6.39E-03  0.00E+00  0.00E+00  9.37E-03  0.00E+00  0.00E+00
          5.07E-02 -3.87E-01  9.05E-03
 
 SG11
+        1.57E-02 -5.91E-02  3.28E-02  3.11E-02 -4.74E-02  7.42E-02 -3.77E-02  0.00E+00  0.00E+00 -2.46E-02  0.00E+00  0.00E+00
         -8.72E-03 -4.24E-02 -5.49E-02  3.42E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************           STOCHASTIC APPROXIMATION EXPECTATION-MAXIMIZATION (NO PRIOR)         ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        4.41E+03
 
 TH 2
+        1.40E+03  6.89E+03
 
 TH 3
+       -1.71E+00  2.40E+01  2.11E+03
 
 TH 4
+       -4.00E+00  1.63E+01  3.68E+02  1.69E+03
 
 TH 5
+       -7.75E+00 -9.95E-01  1.06E+00  2.71E+01  1.35E+03
 
 OM11
+        3.11E+02 -1.49E+03 -7.07E+01 -3.43E+01 -2.47E+01  4.86E+04
 
 OM12
+       -3.00E+03 -4.14E+03 -1.21E+02 -6.17E+01 -1.27E+02  5.44E+04  2.11E+05
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+       -2.02E+03  3.63E+03 -4.57E+01 -8.55E+01 -7.94E+01  1.71E+04  7.12E+04  0.00E+00  0.00E+00  1.78E+05
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+        5.92E+00  5.27E+01  1.62E+02 -2.67E+01 -9.46E+01  4.11E+01 -2.06E+02  0.00E+00  0.00E+00 -2.06E+02  0.00E+00  0.00E+00
          2.27E+04
 
 OM34
+       -4.43E+01 -4.98E+01 -1.81E+02  2.93E+02  2.85E+01 -9.86E+01  3.04E+01  0.00E+00  0.00E+00  1.52E+01  0.00E+00  0.00E+00
          1.05E+04  4.13E+04
 
 OM44
+       -4.58E+00  3.25E+01  1.32E+02  1.43E+02  4.05E+01  4.89E+01  3.41E+02  0.00E+00  0.00E+00 -1.87E+02  0.00E+00  0.00E+00
          1.71E+03  9.76E+03  1.46E+04
 
 SG11
+       -1.83E+03  1.52E+04 -5.15E+03 -4.05E+03  5.08E+03 -4.08E+04  6.85E+03  0.00E+00  0.00E+00  4.40E+04  0.00E+00  0.00E+00
          1.33E+04  4.52E+04  2.81E+04  8.76E+06
 
1
 
 
 #TBLN:      3
 #METH: Objective Function Evaluation by Importance Sampling (No Prior)
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            624
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
 RAW OUTPUT FILE (FILE): pmixture_saem.ext
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
 MC SAMPLES PER SUBJECT (ISAMPLE):          300
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
   1   2   3   4
 THETAS THAT MODEL MIXTURE PROPORTIONS:
   5
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 iteration            0 OBJ=  -9966.87731195678 eff.=     303. Smpl.=     300. Fit.= 0.97920
 iteration            1 OBJ=  -9967.42022720977 eff.=     108. Smpl.=     300. Fit.= 0.88988
 iteration            2 OBJ=  -9966.07173180649 eff.=     107. Smpl.=     300. Fit.= 0.88863
 iteration            3 OBJ=  -9966.79754228041 eff.=     111. Smpl.=     300. Fit.= 0.89233
 iteration            4 OBJ=  -9966.86453895791 eff.=     113. Smpl.=     300. Fit.= 0.89357
 iteration            5 OBJ=  -9966.39135262185 eff.=     115. Smpl.=     300. Fit.= 0.89555
 
 #TERM:
 EXPECTATION ONLY PROCESS COMPLETED


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND SE IS THE ASSOCIATED STANDARD ERROR.

 SUBMODEL    1
 
 ETABAR:        -5.8329E-04  1.1055E-04  1.5392E-04  4.4570E-04
 SE:             1.4882E-02  1.1117E-02  9.0707E-04  1.0478E-03
 N:                     200         200         200         200
 
 ETASHRINKSD(%)  2.0067E+00  5.3784E+00  9.4148E+01  9.3977E+01
 ETASHRINKVR(%)  3.9732E+00  1.0468E+01  9.9658E+01  9.9637E+01
 EBVSHRINKSD(%)  1.9749E+00  5.1550E+00  9.6274E+01  9.7214E+01
 EBVSHRINKVR(%)  3.9108E+00  1.0044E+01  9.9861E+01  9.9922E+01
 EPSSHRINKSD(%)  1.1563E+01
 EPSSHRINKVR(%)  2.1790E+01
 

 SUBMODEL    2
 
 ETABAR:         2.1030E-03 -1.2055E-03  5.0791E-04 -3.5603E-03
 SE:             1.0923E-03  1.0032E-03  2.1780E-02  2.4483E-02
 N:                     100         100         100         100
 
 ETASHRINKSD(%)  9.4901E+01  9.3947E+01  3.9398E-01  2.3995E-01
 ETASHRINKVR(%)  9.9740E+01  9.9634E+01  7.8640E-01  4.7932E-01
 EBVSHRINKSD(%)  1.0000E+02  9.8135E+01  1.9639E+00  1.0788E-01
 EBVSHRINKVR(%)  1.0000E+02  9.9965E+01  3.8892E+00  2.1564E-01
 EPSSHRINKSD(%)  1.4526E+01
 EPSSHRINKVR(%)  2.6941E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2400
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    4410.90495938243     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -9966.39135262185     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:      -5555.48639323942     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                          1200
  
 #TERE:
 Elapsed estimation  time in seconds:     6.14
 Elapsed covariance  time in seconds:     1.55
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************    -9966.391       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         4.24E+00 -2.30E+00  4.26E+00 -6.73E-01  6.67E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        4.64E-02
 
 ETA2
+       -8.51E-03  2.77E-02
 
 ETA3
+        0.00E+00  0.00E+00  4.83E-02
 
 ETA4
+        0.00E+00  0.00E+00 -1.07E-02  6.08E-02
 


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
+       -2.37E-01  1.67E-01
 
 ETA3
+        0.00E+00  0.00E+00  2.20E-01
 
 ETA4
+        0.00E+00  0.00E+00 -1.98E-01  2.47E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.01E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                          STANDARD ERROR OF ESTIMATE (R)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.56E-02  1.24E-02  2.24E-02  2.47E-02  2.73E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        4.81E-03
 
 ETA2
+        2.83E-03  3.12E-03
 
 ETA3
+        0.00E+00  0.00E+00  6.88E-03
 
 ETA4
+        0.00E+00  0.00E+00  5.56E-03  8.61E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        3.42E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        1.12E-02
 
 ETA2
+        7.19E-02  9.37E-03
 
 ETA3
+       ......... .........  1.57E-02
 
 ETA4
+       ......... .........  9.71E-02  1.75E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.69E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (R)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        2.43E-04
 
 TH 2
+       -4.97E-05  1.54E-04
 
 TH 3
+        4.78E-08  7.66E-08  5.01E-04
 
 TH 4
+       -2.64E-07  4.46E-07 -1.13E-04  6.09E-04
 
 TH 5
+        2.84E-06 -1.58E-06  4.05E-07 -9.08E-06  7.43E-04
 
 OM11
+        2.51E-07 -1.35E-07  1.63E-07  4.37E-08  8.59E-07  2.31E-05
 
 OM12
+       -6.67E-08  6.24E-07 -9.60E-08 -9.16E-08  1.10E-07 -4.71E-06  8.00E-06
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        4.25E-07 -1.54E-06  2.15E-07  4.78E-08  4.71E-07  9.53E-07 -3.04E-06  0.00E+00  0.00E+00  9.75E-06
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+        1.76E-07 -1.22E-07 -3.20E-06 -1.99E-07  2.49E-06  9.02E-09  4.53E-09  0.00E+00  0.00E+00 -7.69E-09  0.00E+00  0.00E+00
          4.73E-05
 
 OM34
+       -1.52E-08  5.79E-08  1.28E-06 -8.71E-07 -3.19E-07 -2.77E-08  1.58E-09  0.00E+00  0.00E+00 -3.88E-08  0.00E+00  0.00E+00
         -1.03E-05  3.09E-05
 
 OM44
+        3.41E-09 -5.99E-08 -6.97E-07  5.50E-06 -1.76E-06 -2.19E-08  1.14E-08  0.00E+00  0.00E+00  2.90E-08  0.00E+00  0.00E+00
          2.14E-06 -1.24E-05  7.41E-05
 
 SG11
+        1.06E-07 -3.64E-08  8.54E-08  1.01E-08 -4.05E-07 -1.65E-08  1.47E-08  0.00E+00  0.00E+00 -2.90E-08  0.00E+00  0.00E+00
         -1.01E-08  1.57E-09  1.49E-08  1.17E-07
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (R)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        1.56E-02
 
 TH 2
+       -2.57E-01  1.24E-02
 
 TH 3
+        1.37E-04  2.75E-04  2.24E-02
 
 TH 4
+       -6.87E-04  1.45E-03 -2.04E-01  2.47E-02
 
 TH 5
+        6.68E-03 -4.66E-03  6.64E-04 -1.35E-02  2.73E-02
 
 OM11
+        3.35E-03 -2.26E-03  1.52E-03  3.69E-04  6.56E-03  4.81E-03
 
 OM12
+       -1.51E-03  1.78E-02 -1.52E-03 -1.31E-03  1.43E-03 -3.47E-01  2.83E-03
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        8.73E-03 -3.97E-02  3.08E-03  6.20E-04  5.54E-03  6.35E-02 -3.44E-01  0.00E+00  0.00E+00  3.12E-03
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+        1.64E-03 -1.43E-03 -2.08E-02 -1.17E-03  1.33E-02  2.73E-04  2.33E-04  0.00E+00  0.00E+00 -3.58E-04  0.00E+00  0.00E+00
          6.88E-03
 
 OM34
+       -1.76E-04  8.37E-04  1.03E-02 -6.35E-03 -2.10E-03 -1.04E-03  1.01E-04  0.00E+00  0.00E+00 -2.23E-03  0.00E+00  0.00E+00
         -2.68E-01  5.56E-03
 
 OM44
+        2.54E-05 -5.60E-04 -3.62E-03  2.59E-02 -7.52E-03 -5.29E-04  4.68E-04  0.00E+00  0.00E+00  1.08E-03  0.00E+00  0.00E+00
          3.61E-02 -2.60E-01  8.61E-03
 
 SG11
+        1.99E-02 -8.55E-03  1.11E-02  1.19E-03 -4.34E-02 -1.00E-02  1.52E-02  0.00E+00  0.00E+00 -2.71E-02  0.00E+00  0.00E+00
         -4.28E-03  8.24E-04  5.05E-03  3.42E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************         OBJECTIVE FUNCTION EVALUATION BY IMPORTANCE SAMPLING (NO PRIOR)        ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (R)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        4.41E+03
 
 TH 2
+        1.42E+03  6.94E+03
 
 TH 3
+        7.11E-02 -2.88E+00  2.08E+03
 
 TH 4
+        6.85E-01 -5.02E+00  3.86E+02  1.71E+03
 
 TH 5
+       -1.57E+01  9.33E+00  2.27E+00  2.01E+01  1.35E+03
 
 OM11
+       -6.31E+01 -5.36E+01 -1.36E+01 -2.83E+00 -6.25E+01  4.94E+04
 
 OM12
+       -1.06E+02 -1.89E+02  5.40E+00  1.84E+01 -9.20E+01  3.10E+04  1.61E+05
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+       -4.76E+00  9.85E+02 -5.00E+01 -1.33E+01 -7.21E+01  4.84E+03  4.72E+04  0.00E+00  0.00E+00  1.17E+05
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+       -1.37E+01  1.09E+01  1.35E+02  3.66E+01 -7.02E+01  3.07E+00  7.03E+00  0.00E+00  0.00E+00  5.59E+01  0.00E+00  0.00E+00
          2.28E+04
 
 OM34
+       -4.72E+00 -5.76E+00 -3.83E+01 -5.57E+00  3.72E+00  5.55E+01  7.08E+01  0.00E+00  0.00E+00  1.52E+02  0.00E+00  0.00E+00
          7.81E+03  3.73E+04
 
 OM44
+        8.47E-01  4.22E+00 -1.90E+01 -1.25E+02  3.24E+01  1.49E+01 -2.52E+01  0.00E+00  0.00E+00 -3.30E+01  0.00E+00  0.00E+00
          6.49E+02  6.04E+03  1.45E+04
 
 SG11
+       -3.60E+03  1.17E+03 -1.55E+03 -3.48E+02  4.66E+03  4.09E+03 -4.50E+03  0.00E+00  0.00E+00  2.38E+04  0.00E+00  0.00E+00
          1.46E+03 -5.15E+02 -1.73E+03  8.57E+06
 
 Elapsed postprocess time in seconds:     0.11
 Elapsed finaloutput time in seconds:     0.04
 #CPUT: Total CPU Time in Seconds,      124.146
Stop Time: 
Mon 03/11/2019 
11:15 AM
