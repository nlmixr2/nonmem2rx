Tue 03/12/2019 
09:24 AM
$PROB  AD3TR4_loqb
$INPUT  C SET ID JID TIME CONC AMT RATE EVID MDV CMT DV

$DATA  ad3tr4.csv IGNORE = C
$SUBROUTINES ADVAN3 TRANS4

$PK
MU_1 = THETA(1)
MU_2 = THETA(2)
MU_3 = THETA(3)
MU_4 = THETA(4)
CL = EXP(MU_1 + ETA(1))
V1 = EXP(MU_2 + ETA(2))
Q = EXP(MU_3 + ETA(3))
V2 = EXP(MU_4 + ETA(4))
S1=V1

$ERROR
IEPRED=A(1)/S1
LLOQ=-3.5
SD = THETA(5)
DEL=1.0E-30
; The following coding for LOG() prevents numerical errors from occuring when F<=0
; DEL can be 10E-10 or smaller
IPRED = LOG(ABS(IEPRED)+DEL)
IF(COMACT==1) PREDV=IPRED
DUM = (LLOQ - IPRED) / SD
; Adding DEL to CUMD prevents it from becoming 0, which is not good when NONMEM evaluates -2*LOG(CUMD)
CUMD = PHI(DUM)+DEL
TYPE=1
IF(DV<LLOQ) TYPE=2
IF(MDV==1) TYPE=0
IF(TYPE.EQ.2) DV_LOQ=LLOQ
IF (TYPE .NE. 2.OR.NPDE_MODE==1) THEN
      F_FLAG = 0
      Y = IPRED + SD * ERR(1)
ENDIF
IF (TYPE .EQ. 2.AND.NPDE_MODE==0) THEN
      F_FLAG = 1
      Y = CUMD
      MDVRES=1
ENDIF

$THETA (2.0)X4 0.5

;INITIAL values of OMEGA
$OMEGA BLOCK(4) VALUES(0.2,0.01)

;Initial value of SIGMA
$SIGMA 
1.0 FIXED   ;[P]

$EST METHOD=IMP LAPLACE INTERACTION AUTO=1 PRINT=5 RANMETHOD=S2
$COV MATRIX=R PRINT=E UNCONDITIONAL
$TABLE ID TIME DV IPRED TYPE PRED PREDV CWRES NPDE CIWRES NOAPPEND ONEHEADER ESAMPLE=1000
 FILE=ad3tr4_loqb_imp.tab NOPRINT
  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
             
 (WARNING  3) THERE MAY BE AN ERROR IN THE ABBREVIATED CODE. THE FOLLOWING
 ONE OR MORE RANDOM VARIABLES ARE DEFINED WITH "IF" STATEMENTS THAT DO NOT
 PROVIDE DEFINITIONS FOR BOTH THE "THEN" AND "ELSE" CASES. IF ALL
 CONDITIONS FAIL, THE VALUES OF THESE VARIABLES WILL BE ZERO.
  
   Y

             
 (WARNING  87) WITH "LAPLACIAN" AND "INTERACTION", "NUMERICAL" AND "SLOW"
 ARE ALSO REQUIRED ON $ESTIM RECORD, AND "SLOW" IS REQUIRED ON $COV
 RECORD. NM-TRAN HAS SUPPLIED THESE OPTIONS.
             
 (WARNING  26) THE DERIVATIVE OF THE ABSOLUTE VALUE OF A RANDOM VARIABLE IS
 BEING COMPUTED. IF THE ABSOLUTE VALUE AFFECTS THE VALUE OF THE OBJECTIVE
 FUNCTION, THE USER SHOULD ENSURE THAT THE RANDOM VARIABLE IS ALWAYS
 POSITIVE OR ALWAYS NEGATIVE.
  
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
 AD3TR4_loqb
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:      600
 NO. OF DATA ITEMS IN DATA SET:  12
 ID DATA ITEM IS DATA ITEM NO.:   3
 DEP VARIABLE IS DATA ITEM NO.:  12
 MDV DATA ITEM IS DATA ITEM NO.: 10
0INDICES PASSED TO SUBROUTINE PRED:
   9   5   7   8   0   0  11   0   0   0   0
0LABELS FOR DATA ITEMS:
 C SET ID JID TIME CONC AMT RATE EVID MDV CMT DV
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 PREDV IPRED TYPE
0FORMAT FOR DATA:
 (2E2.0,3E4.0,E11.0,E4.0,4E2.0,E13.0)

 TOT. NO. OF OBS RECS:      500
 TOT. NO. OF INDIVIDUALS:      100
0LENGTH OF THETA:   5
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS BLOCK FORM:
  1
  1  1
  1  1  1
  1  1  1  1
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   1
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
   0.2000E+01  0.2000E+01  0.2000E+01  0.2000E+01  0.5000E+00
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.2000E+00
                  0.1000E-01   0.2000E+00
                  0.1000E-01   0.1000E-01   0.2000E+00
                  0.1000E-01   0.1000E-01   0.1000E-01   0.2000E+00
0INITIAL ESTIMATE OF SIGMA:
 0.1000E+01
0SIGMA CONSTRAINED TO BE THIS INITIAL ESTIMATE
0COVARIANCE STEP OMITTED:        NO
 R MATRIX SUBSTITUTED:          YES
 S MATRIX SUBSTITUTED:           NO
 EIGENVLS. PRINTED:             YES
 COMPRESSED FORMAT:              NO
 GRADIENT METHOD USED:       SLOW
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
 MC SAMPLES (ESAMPLE):    1000
 WRES SQUARE ROOT TYPE (WRESCHOL): EIGENVALUE
0-- TABLE   1 --
0RECORDS ONLY:    ALL
04 COLUMNS APPENDED:    NO
 PRINTED:                NO
 HEADER:                YES
 FILE TO BE FORWARDED:   NO
 FORMAT:                S1PE11.4
 LFORMAT:
 RFORMAT:
 FIXED_EFFECT_ETAS:
0USER-CHOSEN ITEMS:
 ID TIME DV IPRED TYPE PRED PREDV CWRES NPDE CIWRES
1DOUBLE PRECISION PREDPP VERSION 7.4.3

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
0ERROR SUBROUTINE INDICATES THAT DERIVATIVES OF COMPARTMENT AMOUNTS ARE USED.
1
 
 
 #TBLN:      1
 #METH: Importance Sampling (No Prior)
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               SLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    YES
 NUMERICAL 2ND DERIVATIVES:               YES
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
 RAW OUTPUT FILE (FILE): ad3tr4_loqb_imp.ext
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
 ITERATIONS (NITER):                        500
 ANEAL SETTING (CONSTRAIN):                 1
 STARTING SEED FOR MC METHODS (SEED):       11456
 MC SAMPLES PER SUBJECT (ISAMPLE):          300
 MAXIMUM SAMPLES PER SUBJECT FOR AUTOMATIC
 ISAMPLE ADJUSTMENT (ISAMPEND):             10000
 RANDOM SAMPLING METHOD (RANMETHOD):        3US2
 EXPECTATION ONLY (EONLY):                  0
 PROPOSAL DENSITY SCALING RANGE
              (ISCALE_MIN, ISCALE_MAX):     0.100000000000000       ,10.0000000000000
 SAMPLE ACCEPTANCE RATE (IACCEPT):          0.00000000000000
 LONG TAIL SAMPLE ACCEPT. RATE (IACCEPTL):   0.00000000000000
 T-DIST. PROPOSAL DENSITY (DF):             0
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
   1   2   3   4
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 iteration            0 OBJ=   259.760632008061 eff.=     307. Smpl.=     300. Fit.= 0.97988
 iteration            5 OBJ=  -108.162902556834 eff.=     165. Smpl.=     300. Fit.= 0.92610
 iteration           10 OBJ=  -122.045148995805 eff.=     116. Smpl.=     300. Fit.= 0.89901
 iteration           15 OBJ=  -124.224651113596 eff.=     118. Smpl.=     300. Fit.= 0.90008
 iteration           20 OBJ=  -125.158937859401 eff.=     117. Smpl.=     300. Fit.= 0.89942
 iteration           25 OBJ=  -125.237964091845 eff.=     118. Smpl.=     300. Fit.= 0.89915
 iteration           30 OBJ=  -125.337735621845 eff.=     119. Smpl.=     300. Fit.= 0.90013
 iteration           35 OBJ=  -125.249812405160 eff.=     119. Smpl.=     300. Fit.= 0.90093
 iteration           40 OBJ=  -124.831983325047 eff.=     118. Smpl.=     300. Fit.= 0.89999
 iteration           45 OBJ=  -125.494518703780 eff.=     120. Smpl.=     300. Fit.= 0.90110
 iteration           50 OBJ=  -125.223765503891 eff.=     118. Smpl.=     300. Fit.= 0.89981
 iteration           55 OBJ=  -125.236394311829 eff.=     117. Smpl.=     300. Fit.= 0.89922
 iteration           60 OBJ=  -125.273514097540 eff.=     116. Smpl.=     300. Fit.= 0.89795
 iteration           65 OBJ=  -125.043112441339 eff.=     116. Smpl.=     300. Fit.= 0.89833
 Convergence achieved
 iteration           68 OBJ=  -125.128685504271 eff.=     118. Smpl.=     300. Fit.= 0.89991
 iteration           68 OBJ=  -125.344698213817 eff.=     116. Smpl.=     300. Fit.= 0.89801
 
 #TERM:
 OPTIMIZATION WAS COMPLETED


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -1.2435E-04 -2.6906E-04  5.6191E-04  2.0752E-04
 SE:             3.8717E-02  2.7384E-02  1.8108E-02  2.4490E-02
 N:                     100         100         100         100
 
 P VAL.:         9.9744E-01  9.9216E-01  9.7525E-01  9.9324E-01
 
 ETASHRINKSD(%)  4.6829E+00  2.5953E+01  4.5712E+01  3.5978E+01
 ETASHRINKVR(%)  9.1466E+00  4.5170E+01  7.0529E+01  5.9012E+01
 EBVSHRINKSD(%)  4.5230E+00  2.5810E+01  4.5672E+01  3.6067E+01
 EBVSHRINKVR(%)  8.8414E+00  4.4958E+01  7.0484E+01  5.9126E+01
 EPSSHRINKSD(%)  2.7699E+01
 EPSSHRINKVR(%)  4.7725E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):          396
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    727.799318298101     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -125.344698213817     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       602.454620084284     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           400
  
 #TERE:
 Elapsed estimation  time in seconds:    29.16
 Elapsed covariance  time in seconds:     1.28
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     -125.345       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.68E+00  1.61E+00  7.38E-01  2.37E+00  2.74E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        1.67E-01
 
 ETA2
+       -8.99E-04  1.38E-01
 
 ETA3
+       -2.64E-03 -1.34E-02  1.12E-01
 
 ETA4
+       -3.31E-02  9.65E-03  4.02E-02  1.48E-01
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        1.00E+00
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        4.08E-01
 
 ETA2
+       -5.92E-03  3.72E-01
 
 ETA3
+       -1.93E-02 -1.07E-01  3.35E-01
 
 ETA4
+       -2.11E-01  6.75E-02  3.12E-01  3.84E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.00E+00
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                          STANDARD ERROR OF ESTIMATE (R)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         4.42E-02  5.41E-02  7.19E-02  7.14E-02  2.40E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        2.82E-02
 
 ETA2
+        2.38E-02  4.06E-02
 
 ETA3
+        2.98E-02  3.43E-02  7.22E-02
 
 ETA4
+        3.16E-02  3.29E-02  5.16E-02  5.56E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        0.00E+00
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        3.46E-02
 
 ETA2
+        1.57E-01  5.46E-02
 
 ETA3
+        2.21E-01  2.83E-01  1.08E-01
 
 ETA4
+        2.13E-01  2.25E-01  3.04E-01  7.23E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+       .........
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (R)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        1.95E-03
 
 TH 2
+        3.64E-04  2.93E-03
 
 TH 3
+        5.26E-04 -5.35E-05  5.17E-03
 
 TH 4
+        3.54E-05  7.64E-04  2.38E-03  5.10E-03
 
 TH 5
+        7.41E-05  2.21E-04  3.28E-05  4.53E-05  5.76E-04
 
 OM11
+        4.28E-05  1.17E-04  1.05E-04  9.20E-05 -1.01E-04  7.97E-04
 
 OM12
+        4.88E-05  9.39E-05  1.59E-04  1.90E-04 -1.16E-04  1.64E-04  5.68E-04
 
 OM13
+        1.94E-05  2.14E-05  4.01E-05  1.78E-04 -2.47E-04  2.43E-04  8.54E-05  8.89E-04
 
 OM14
+        2.26E-05  1.42E-04  3.02E-04  6.95E-04 -1.98E-04  7.27E-05  1.99E-04  4.85E-04  1.00E-03
 
 OM22
+       -1.91E-04 -4.54E-04 -6.97E-04 -5.16E-04 -3.45E-04 -8.48E-06  1.27E-04  2.37E-05 -1.81E-05  1.65E-03
 
 OM23
+        5.42E-05  6.96E-05  7.37E-04  2.38E-04 -1.19E-04  8.36E-05  2.27E-04  1.38E-04  2.10E-04 -1.14E-04  1.18E-03
 
 OM24
+       -4.99E-05 -2.01E-04  2.31E-04  2.55E-04 -1.47E-04 -4.76E-06  2.74E-05  1.20E-04  2.14E-04  3.39E-04  4.37E-04  1.08E-03
 
 OM33
+       -1.26E-04 -6.33E-04  4.75E-04  5.79E-05 -1.05E-03  2.75E-04  2.36E-04  8.87E-04  5.86E-04  2.06E-04  4.51E-04  3.06E-04
          5.22E-03
 
 OM34
+       -7.43E-05 -1.39E-04 -5.16E-04 -7.46E-04 -5.61E-04  1.80E-04  1.57E-04  3.65E-04  2.09E-04  2.24E-04  2.93E-04  1.58E-04
          2.50E-03  2.66E-03
 
 OM44
+       -9.91E-05 -1.63E-04 -2.77E-04 -6.63E-04 -5.51E-04  1.37E-04  1.20E-04  3.20E-04  2.33E-04  3.65E-04  2.85E-04  4.96E-04
          1.58E-03  1.96E-03  3.09E-03
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... .........
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (R)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        4.42E-02
 
 TH 2
+        1.52E-01  5.41E-02
 
 TH 3
+        1.66E-01 -1.38E-02  7.19E-02
 
 TH 4
+        1.12E-02  1.98E-01  4.64E-01  7.14E-02
 
 TH 5
+        6.98E-02  1.70E-01  1.90E-02  2.64E-02  2.40E-02
 
 OM11
+        3.43E-02  7.65E-02  5.18E-02  4.56E-02 -1.49E-01  2.82E-02
 
 OM12
+        4.64E-02  7.28E-02  9.28E-02  1.12E-01 -2.02E-01  2.44E-01  2.38E-02
 
 OM13
+        1.47E-02  1.33E-02  1.87E-02  8.36E-02 -3.45E-01  2.88E-01  1.20E-01  2.98E-02
 
 OM14
+        1.62E-02  8.31E-02  1.33E-01  3.07E-01 -2.60E-01  8.14E-02  2.64E-01  5.14E-01  3.16E-02
 
 OM22
+       -1.07E-01 -2.07E-01 -2.39E-01 -1.78E-01 -3.54E-01 -7.39E-03  1.32E-01  1.96E-02 -1.40E-02  4.06E-02
 
 OM23
+        3.57E-02  3.74E-02  2.99E-01  9.69E-02 -1.45E-01  8.62E-02  2.77E-01  1.34E-01  1.94E-01 -8.16E-02  3.43E-02
 
 OM24
+       -3.43E-02 -1.13E-01  9.76E-02  1.09E-01 -1.86E-01 -5.12E-03  3.49E-02  1.22E-01  2.05E-01  2.53E-01  3.86E-01  3.29E-02
 
 OM33
+       -3.95E-02 -1.62E-01  9.16E-02  1.12E-02 -6.08E-01  1.35E-01  1.37E-01  4.12E-01  2.57E-01  7.03E-02  1.82E-01  1.28E-01
          7.22E-02
 
 OM34
+       -3.26E-02 -5.00E-02 -1.39E-01 -2.03E-01 -4.53E-01  1.24E-01  1.27E-01  2.38E-01  1.28E-01  1.07E-01  1.65E-01  9.30E-02
          6.71E-01  5.16E-02
 
 OM44
+       -4.04E-02 -5.42E-02 -6.94E-02 -1.67E-01 -4.13E-01  8.74E-02  9.07E-02  1.93E-01  1.32E-01  1.62E-01  1.49E-01  2.71E-01
          3.93E-01  6.86E-01  5.56E-02
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... .........
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (R)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        5.52E+02
 
 TH 2
+       -7.29E+01  4.14E+02
 
 TH 3
+       -8.10E+01  5.69E+01  3.13E+02
 
 TH 4
+        4.95E+01 -8.40E+01 -1.30E+02  3.14E+02
 
 TH 5
+       -1.89E+01 -7.18E+01 -4.37E+01  2.92E+01  3.58E+03
 
 OM11
+       -3.10E+00 -4.64E+01 -3.08E+01 -1.32E+01  1.38E+02  1.49E+03
 
 OM12
+       -4.99E+01 -4.34E+01 -2.19E+00 -4.75E+01  1.48E+02 -4.16E+02  2.30E+03
 
 OM13
+       -3.43E+01 -2.37E+01  6.58E+01  3.78E+01  1.47E+02 -4.81E+02  2.35E+02  1.93E+03
 
 OM14
+       -3.43E+00 -3.67E+01  1.50E+01 -1.75E+02  2.13E+02  2.38E+02 -4.36E+02 -8.21E+02  1.67E+03
 
 OM22
+        2.65E+01  7.36E+01  7.37E+01  4.26E+01  6.19E+02  4.93E+01 -2.79E+02  1.71E+01  9.19E+01  8.95E+02
 
 OM23
+        3.32E+01 -5.69E+01 -1.75E+02  8.28E+01  1.36E+02  2.52E+01 -4.60E+02 -5.52E+01 -6.01E+00  2.09E+02  1.29E+03
 
 OM24
+       -1.25E+01  7.57E+01  3.07E+01 -9.37E+01 -1.36E+02  9.94E+00  2.99E+02  2.48E+01 -1.89E+02 -3.38E+02 -5.62E+02  1.40E+03
 
 OM33
+        1.80E+01  7.21E+01 -7.97E+01 -2.47E+01  6.18E+02  4.64E+01  1.97E+00 -2.57E+02  1.66E+01  9.17E+01  3.76E+01 -5.56E+01
          5.69E+02
 
 OM34
+       -2.42E+01 -5.98E+01  1.36E+02  5.98E+01 -1.93E+02 -7.05E+01 -3.62E+01  1.59E+02 -1.23E+01 -1.77E+01 -1.76E+02  2.14E+02
         -5.19E+02  1.30E+03
 
 OM44
+        2.18E+01 -1.16E+01 -5.70E+01  4.67E+01  3.38E+02  9.83E+00 -7.68E-01 -5.85E+01 -1.54E+01  2.46E+01  8.69E+01 -2.80E+02
          1.59E+02 -6.05E+02  7.33E+02
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... .........
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                    EIGENVALUES OF COR MATRIX OF ESTIMATE (R)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12
             13        14        15
 
         1.53E-01  3.37E-01  3.47E-01  3.87E-01  4.47E-01  5.89E-01  7.74E-01  8.55E-01  9.24E-01  9.88E-01  1.12E+00  1.20E+00
          1.37E+00  2.15E+00  3.35E+00
 
 Elapsed postprocess time in seconds:     0.63
 Elapsed finaloutput time in seconds:     0.06
 #CPUT: Total CPU Time in Seconds,       30.202
Stop Time: 
Tue 03/12/2019 
09:24 AM
