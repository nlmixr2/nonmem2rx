Tue 03/12/2019 
09:23 AM
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

$THETA 
( 2.0) ;[LN(CL)]
(2.0) ;[LN(V1)]
( 2.0) ;[LN(Q)]
( 2.0) ;[LN(V2)]
 0.2
;INITIAL values of OMEGA
$OMEGA BLOCK(4)
0.15   ;[P]
0.01  ;[F]
0.15   ;[P]
0.01  ;[F]
0.01  ;[F]
0.15   ;[P]
0.01  ;[F]
0.01  ;[F]
0.01  ;[F]
0.15   ;[P]
;Initial value of SIGMA
$SIGMA 
1.0 FIXED   ;[P]

$EST METHOD=COND INTERACTION LAPLACE MAXEVAL=9999 NSIG=3 PRINT=5 NOABORT SIGL=10 MCETA=10
$COV MATRIX=S PRINT=E UNCONDITIONAL
$TABLE ID TIME DV IPRED TYPE PRED PREDV CWRES NPDE CIWRES NOAPPEND ONEHEADER ESAMPLE=1000
 FILE=ad3tr4_loqb_lap.tab NOPRINT
  
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
   0.2000E+01  0.2000E+01  0.2000E+01  0.2000E+01  0.2000E+00
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.1500E+00
                  0.1000E-01   0.1500E+00
                  0.1000E-01   0.1000E-01   0.1500E+00
                  0.1000E-01   0.1000E-01   0.1000E-01   0.1500E+00
0INITIAL ESTIMATE OF SIGMA:
 0.1000E+01
0SIGMA CONSTRAINED TO BE THIS INITIAL ESTIMATE
0COVARIANCE STEP OMITTED:        NO
 R MATRIX SUBSTITUTED:           NO
 S MATRIX SUBSTITUTED:          YES
 EIGENVLS. PRINTED:             YES
 SPECIAL COMPUTATION:            NO
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
 #METH: Laplacian Conditional Estimation with Interaction
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               SLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    YES
 NUMERICAL 2ND DERIVATIVES:               YES
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
 INITIAL ETA FOR MAP ESTIMATION (MCETA):    10
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      10
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     10
 NOPRIOR SETTING (NOPRIOR):                 OFF
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): ad3tr4_loqb_lap.ext
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

 
0ITERATION NO.:    0    OBJECTIVE VALUE:   617.564634184578        NO. OF FUNC. EVALS.:  16
 CUMULATIVE NO. OF FUNC. EVALS.:       16
 NPARAMETR:  2.0000E+00  2.0000E+00  2.0000E+00  2.0000E+00  2.0000E-01  1.5000E-01  1.0000E-02  1.0000E-02  1.0000E-02  1.5000E-01
             1.0000E-02  1.0000E-02  1.5000E-01  1.0000E-02  1.5000E-01
 PARAMETER:  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01
             1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01
 GRADIENT:   5.2093E+03  7.9837E+03  1.4713E+04 -8.3141E+03 -5.9463E+03 -1.2809E+02 -6.8289E+01 -1.2565E+02  1.1563E+02 -9.1186E+01
            -1.6095E+02  7.2879E+01 -4.7368E+02  1.8353E+02 -3.3196E+02
 
0ITERATION NO.:    5    OBJECTIVE VALUE:  -84.0669959967160        NO. OF FUNC. EVALS.:  94
 CUMULATIVE NO. OF FUNC. EVALS.:      110
 NPARAMETR:  1.6791E+00  1.6245E+00  1.1087E+00  2.3311E+00  2.6617E-01  1.5042E-01  1.0039E-02  1.0002E-02  9.9965E-03  1.4987E-01
             1.0040E-02  9.9670E-03  1.4960E-01  1.0035E-02  1.5019E-01
 PARAMETER:  8.3955E-02  8.1227E-02  5.5437E-02  1.1656E-01  1.3308E-01  1.0139E-01  1.0025E-01  9.9884E-02  9.9826E-02  9.9538E-02
             1.0047E-01  9.9687E-02  9.8650E-02  1.0055E-01  1.0063E-01
 GRADIENT:  -6.2572E+02  7.7105E+02  3.7439E+03 -2.1647E+03 -2.0271E+02 -3.9988E+01  1.3071E+00  8.7236E+00  1.8527E+01  2.3761E+01
            -8.5069E+00 -7.3161E-01 -2.4882E+01  9.6107E+00 -2.1554E+01
 
0ITERATION NO.:   10    OBJECTIVE VALUE:  -122.563281994920        NO. OF FUNC. EVALS.:  88
 CUMULATIVE NO. OF FUNC. EVALS.:      198
 NPARAMETR:  1.7056E+00  1.6836E+00  7.7360E-01  2.4371E+00  2.8696E-01  2.1004E-01  6.1954E-03 -1.7194E-04 -4.3672E-03  9.2693E-02
            -9.2585E-03  1.8042E-02  3.6585E-02  1.1532E-02  1.3450E-01
 PARAMETER:  8.5278E-02  8.4178E-02  3.8680E-02  1.2186E-01  1.4348E-01  2.6832E-01  5.2356E-02 -1.4531E-03 -3.6906E-02 -1.3943E-01
            -1.2596E-01  2.4735E-01 -6.1413E-01  3.1152E-01  1.8125E-02
 GRADIENT:   1.6267E+02  9.9917E+02 -1.6155E+02  1.9195E+02 -2.3981E+02  3.3999E+01  6.4703E-03  2.2476E+00  9.4894E-01 -6.7885E+00
             6.7645E-02  5.2736E+00 -8.6525E+00  2.6935E+00 -1.0973E+01
 
0ITERATION NO.:   15    OBJECTIVE VALUE:  -124.638816710408        NO. OF FUNC. EVALS.: 145
 CUMULATIVE NO. OF FUNC. EVALS.:      343
 NPARAMETR:  1.6846E+00  1.6639E+00  7.7139E-01  2.4368E+00  2.8925E-01  2.0120E-01 -1.3104E-02 -1.5453E-02 -1.6955E-03  9.0176E-02
            -2.7550E-02  1.1457E-02  4.9067E-02  1.3224E-02  1.5443E-01
 PARAMETER:  8.4228E-02  8.3193E-02  3.8570E-02  1.2184E-01  1.4462E-01  2.4683E-01 -1.1314E-01 -1.3343E-01 -1.4640E-02 -1.5696E-01
            -3.9561E-01  1.5718E-01 -5.7257E-01  3.7442E-01  9.1566E-02
 GRADIENT:  -5.1484E+02  4.2779E+03 -5.5011E+03  2.3173E+03 -9.3556E+02  2.2573E+01  1.3731E+01 -5.0173E+01  2.1509E+01  1.7468E+02
            -2.7952E+01  1.1284E+01 -4.8909E+01  2.3991E+01 -4.4194E+01
 
0ITERATION NO.:   20    OBJECTIVE VALUE:  -128.084830390680        NO. OF FUNC. EVALS.: 140
 CUMULATIVE NO. OF FUNC. EVALS.:      483
 NPARAMETR:  1.7002E+00  1.6518E+00  8.0925E-01  2.4526E+00  2.8445E-01  1.8468E-01 -4.5074E-03 -2.0675E-02 -1.9024E-02  9.7620E-02
            -2.4414E-02  1.1603E-02  6.4012E-02  3.8994E-02  1.7922E-01
 PARAMETER:  8.5012E-02  8.2590E-02  4.0462E-02  1.2263E-01  1.4223E-01  2.0399E-01 -4.0622E-02 -1.8633E-01 -1.7145E-01 -1.1311E-01
            -3.3040E-01  1.4768E-01 -3.9448E-01  7.4414E-01  9.7459E-02
 GRADIENT:  -5.0511E+03  3.8649E+04 -4.7026E+04  1.5940E+04 -5.8378E+03 -1.0816E+02  2.9204E+02 -4.7630E+02  1.6333E+02  1.7072E+03
             7.8587E+01 -1.1126E+02 -6.1680E+02  2.4282E+02 -3.5933E+02
 
0ITERATION NO.:   25    OBJECTIVE VALUE:  -131.093869350157        NO. OF FUNC. EVALS.: 123
 CUMULATIVE NO. OF FUNC. EVALS.:      606
 NPARAMETR:  1.6994E+00  1.6516E+00  8.0910E-01  2.4530E+00  2.9170E-01  1.7023E-01 -4.4647E-03 -1.9738E-02 -7.2329E-03  9.7695E-02
            -2.5167E-02  1.1915E-02  6.4544E-02  3.7320E-02  1.7786E-01
 PARAMETER:  8.4969E-02  8.2581E-02  4.0455E-02  1.2265E-01  1.4585E-01  1.6325E-01 -4.1911E-02 -1.8528E-01 -6.7896E-02 -1.1277E-01
            -3.4044E-01  1.5542E-01 -3.9299E-01  7.4034E-01  9.8991E-02
 GRADIENT:  -6.2200E+02  1.0010E+02 -2.1602E+02  1.3173E+03 -1.1455E+03  8.9735E+03  4.6506E+03 -1.6198E+03 -7.6705E+03  1.6922E+03
             6.6837E+02  5.8057E+03 -3.5154E+02  2.6358E+02 -4.6382E+03
 
0ITERATION NO.:   26    OBJECTIVE VALUE:  -131.093869350157        NO. OF FUNC. EVALS.:  27
 CUMULATIVE NO. OF FUNC. EVALS.:      633
 NPARAMETR:  1.6994E+00  1.6516E+00  8.0910E-01  2.4530E+00  2.9170E-01  1.7023E-01 -4.4647E-03 -1.9738E-02 -7.2328E-03  9.7695E-02
            -2.5167E-02  1.1915E-02  6.4544E-02  3.7320E-02  1.7786E-01
 PARAMETER:  8.4969E-02  8.2581E-02  4.0455E-02  1.2265E-01  1.4585E-01  1.6325E-01 -4.1911E-02 -1.8528E-01 -6.7896E-02 -1.1277E-01
            -3.4044E-01  1.5542E-01 -3.9299E-01  7.4034E-01  9.8991E-02
 GRADIENT:  -6.2200E+02  1.0010E+02 -2.1602E+02  1.3173E+03 -1.1455E+03  1.3357E+04  4.6506E+03 -1.6198E+03 -9.8989E+03  1.6922E+03
             6.6837E+02  7.6991E+03 -3.5154E+02  2.6358E+02 -4.6382E+03
 
 #TERM:
0MINIMIZATION TERMINATED
 DUE TO ROUNDING ERRORS (ERROR=134)
 NO. OF FUNCTION EVALUATIONS USED:      633
 NO. OF SIG. DIGITS UNREPORTABLE

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -1.8936E-03  1.5013E-03 -1.3674E-02 -9.4456E-03
 SE:             3.8757E-02  2.2878E-02  1.2884E-02  2.5121E-02
 N:                     100         100         100         100
 
 P VAL.:         9.6103E-01  9.4768E-01  2.8852E-01  7.0691E-01
 
 ETASHRINKSD(%)  5.5906E+00  2.6436E+01  4.9033E+01  4.0135E+01
 ETASHRINKVR(%)  1.0869E+01  4.5884E+01  7.4023E+01  6.4162E+01
 EBVSHRINKSD(%)  5.0974E+00  1.0000E+02  1.0000E+02  5.7211E+01
 EBVSHRINKVR(%)  9.9350E+00  1.0000E+02  1.0000E+02  8.1691E+01
 EPSSHRINKSD(%)  2.6385E+01
 EPSSHRINKVR(%)  4.5808E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):          396
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    727.799318298101     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -131.093869350157     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       596.705448947944     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           400
  
 #TERE:
 Elapsed estimation  time in seconds:    10.36
 Elapsed covariance  time in seconds:     0.73
 Elapsed postprocess time in seconds:     0.63
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 #OBJT:**************                       MINIMUM VALUE OF OBJECTIVE FUNCTION                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     -131.094       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.70E+00  1.65E+00  8.09E-01  2.45E+00  2.92E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        1.70E-01
 
 ETA2
+       -4.46E-03  9.77E-02
 
 ETA3
+       -1.97E-02 -2.52E-02  6.45E-02
 
 ETA4
+       -7.23E-03  1.19E-02  3.73E-02  1.78E-01
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        1.00E+00
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        4.13E-01
 
 ETA2
+       -3.46E-02  3.13E-01
 
 ETA3
+       -1.88E-01 -3.17E-01  2.54E-01
 
 ETA4
+       -4.16E-02  9.04E-02  3.48E-01  4.22E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.00E+00
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 ********************                            STANDARD ERROR OF ESTIMATE                          ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         4.90E-02  5.06E-02  7.02E-02  8.00E-02  2.21E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        3.10E-02
 
 ETA2
+        2.29E-02  1.30E-02
 
 ETA3
+        2.90E-02  3.49E-02  4.95E-02
 
 ETA4
+        3.53E-02  3.31E-02  5.43E-02  6.99E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+       .........
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        3.76E-02
 
 ETA2
+        1.78E-01  2.07E-02
 
 ETA3
+        3.11E-01  4.81E-01  9.75E-02
 
 ETA4
+        2.03E-01  2.47E-01  3.72E-01  8.29E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+       .........
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 ********************                          COVARIANCE MATRIX OF ESTIMATE                         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        2.40E-03
 
 TH 2
+        3.62E-04  2.56E-03
 
 TH 3
+       -5.48E-05 -9.33E-04  4.93E-03
 
 TH 4
+        2.07E-04  7.23E-04  2.54E-03  6.40E-03
 
 TH 5
+       -9.71E-05  1.60E-04 -3.41E-04 -2.70E-04  4.88E-04
 
 OM11
+       -1.60E-04  1.07E-04  2.35E-04 -9.59E-06 -7.72E-05  9.63E-04
 
 OM12
+        1.86E-04  1.35E-04  1.81E-04  2.68E-04 -1.62E-04  2.71E-04  5.24E-04
 
 OM13
+        3.73E-05  4.15E-05 -3.98E-04 -1.50E-04 -1.29E-04 -3.57E-05  1.41E-04  8.40E-04
 
 OM14
+       -4.53E-05  1.38E-04 -6.63E-05  8.94E-04 -1.52E-04  1.63E-04  3.41E-04  5.07E-04  1.24E-03
 
 OM22
+        1.57E-06 -1.20E-04 -1.94E-05 -2.29E-04  1.59E-05 -3.46E-05 -7.29E-05  1.22E-04 -9.79E-06  1.68E-04
 
 OM23
+       -8.10E-05 -3.47E-04  7.63E-04  4.14E-04 -1.99E-04  2.00E-04  1.29E-05 -1.00E-04 -4.53E-05 -5.44E-05  1.22E-03
 
 OM24
+       -1.94E-04 -2.82E-04  8.00E-04  2.38E-04 -6.75E-05  1.78E-04  4.03E-05  3.96E-05 -2.48E-05  4.96E-05  6.46E-04  1.10E-03
 
 OM33
+       -3.45E-04 -5.26E-04  8.39E-04  8.68E-06 -4.40E-04  6.36E-06  6.41E-05  5.38E-04  1.36E-05 -9.23E-05  4.31E-04  2.41E-04
          2.45E-03
 
 OM34
+       -2.38E-04 -1.22E-04  3.45E-04  1.25E-04 -3.31E-04  1.78E-05 -2.41E-05  2.72E-04 -1.79E-04 -4.27E-04  6.89E-04  1.17E-04
          2.09E-03  2.95E-03
 
 OM44
+       -1.56E-04 -4.16E-04  7.44E-04 -3.53E-04 -4.08E-04  4.92E-05 -9.72E-05  2.26E-04 -4.79E-05 -1.92E-04  7.00E-04  5.43E-04
          1.77E-03  2.45E-03  4.89E-03
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... .........
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 ********************                          CORRELATION MATRIX OF ESTIMATE                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        4.90E-02
 
 TH 2
+        1.46E-01  5.06E-02
 
 TH 3
+       -1.59E-02 -2.63E-01  7.02E-02
 
 TH 4
+        5.29E-02  1.78E-01  4.52E-01  8.00E-02
 
 TH 5
+       -8.97E-02  1.44E-01 -2.19E-01 -1.53E-01  2.21E-02
 
 OM11
+       -1.05E-01  6.80E-02  1.08E-01 -3.86E-03 -1.13E-01  3.10E-02
 
 OM12
+        1.66E-01  1.16E-01  1.13E-01  1.46E-01 -3.20E-01  3.81E-01  2.29E-02
 
 OM13
+        2.62E-02  2.83E-02 -1.95E-01 -6.46E-02 -2.02E-01 -3.96E-02  2.12E-01  2.90E-02
 
 OM14
+       -2.62E-02  7.74E-02 -2.68E-02  3.17E-01 -1.96E-01  1.49E-01  4.22E-01  4.96E-01  3.53E-02
 
 OM22
+        2.46E-03 -1.82E-01 -2.13E-02 -2.21E-01  5.56E-02 -8.60E-02 -2.46E-01  3.25E-01 -2.14E-02  1.30E-02
 
 OM23
+       -4.74E-02 -1.97E-01  3.11E-01  1.48E-01 -2.59E-01  1.85E-01  1.61E-02 -9.90E-02 -3.69E-02 -1.20E-01  3.49E-02
 
 OM24
+       -1.20E-01 -1.68E-01  3.44E-01  9.00E-02 -9.23E-02  1.73E-01  5.32E-02  4.13E-02 -2.13E-02  1.16E-01  5.60E-01  3.31E-02
 
 OM33
+       -1.42E-01 -2.10E-01  2.41E-01  2.19E-03 -4.02E-01  4.14E-03  5.66E-02  3.75E-01  7.77E-03 -1.44E-01  2.49E-01  1.47E-01
          4.95E-02
 
 OM34
+       -8.94E-02 -4.43E-02  9.05E-02  2.88E-02 -2.76E-01  1.05E-02 -1.94E-02  1.73E-01 -9.37E-02 -6.06E-01  3.64E-01  6.53E-02
          7.79E-01  5.43E-02
 
 OM44
+       -4.56E-02 -1.18E-01  1.52E-01 -6.32E-02 -2.64E-01  2.26E-02 -6.07E-02  1.12E-01 -1.94E-02 -2.11E-01  2.87E-01  2.35E-01
          5.10E-01  6.44E-01  6.99E-02
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... .........
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 ********************                      INVERSE COVARIANCE MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        5.01E+03
 
 TH 2
+        8.89E+02  7.39E+02
 
 TH 3
+        2.57E+03  6.71E+02  1.92E+03
 
 TH 4
+       -3.98E+03 -9.58E+02 -2.46E+03  3.78E+03
 
 TH 5
+        4.28E+04  8.78E+03  2.45E+04 -3.73E+04  4.06E+05
 
 OM11
+        2.93E+05  6.10E+04  1.68E+05 -2.57E+05  2.77E+06  1.90E+07
 
 OM12
+       -1.55E+06 -3.24E+05 -8.92E+05  1.36E+06 -1.47E+07 -1.01E+08  5.34E+08
 
 OM13
+        2.37E+06  4.95E+05  1.36E+06 -2.08E+06  2.24E+07  1.54E+08 -8.15E+08  1.24E+09
 
 OM14
+       -1.10E+06 -2.30E+05 -6.34E+05  9.68E+05 -1.04E+07 -7.16E+07  3.79E+08 -5.79E+08  2.70E+08
 
 OM22
+       -9.06E+06 -1.89E+06 -5.21E+06  7.95E+06 -8.56E+07 -5.88E+08  3.12E+09 -4.76E+09  2.22E+09  1.82E+10
 
 OM23
+        1.10E+06  2.30E+05  6.32E+05 -9.66E+05  1.04E+07  7.14E+07 -3.78E+08  5.78E+08 -2.69E+08 -2.21E+09  2.68E+08
 
 OM24
+       -5.85E+05 -1.22E+05 -3.37E+05  5.14E+05 -5.54E+06 -3.80E+07  2.01E+08 -3.08E+08  1.43E+08  1.18E+09 -1.43E+08  7.60E+07
 
 OM33
+        1.58E+06  3.31E+05  9.10E+05 -1.39E+06  1.50E+07  1.03E+08 -5.44E+08  8.31E+08 -3.87E+08 -3.18E+09  3.86E+08 -2.05E+08
          5.55E+08
 
 OM34
+       -3.41E+06 -7.12E+05 -1.96E+06  2.99E+06 -3.23E+07 -2.21E+08  1.17E+09 -1.79E+09  8.34E+08  6.85E+09 -8.32E+08  4.43E+08
         -1.20E+09  2.58E+09
 
 OM44
+        5.36E+05  1.12E+05  3.08E+05 -4.70E+05  5.06E+06  3.48E+07 -1.84E+08  2.81E+08 -1.31E+08 -1.08E+09  1.31E+08 -6.95E+07
          1.88E+08 -4.05E+08  6.36E+07
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... .........
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 ********************                      EIGENVALUES OF COR MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12
             13        14        15
 
         6.93E-08  1.70E-01  2.32E-01  2.95E-01  4.88E-01  5.42E-01  6.13E-01  6.75E-01  9.49E-01  1.05E+00  1.21E+00  1.67E+00
          1.82E+00  2.07E+00  3.22E+00
 
 Elapsed finaloutput time in seconds:     0.05
 #CPUT: Total CPU Time in Seconds,       11.045
Stop Time: 
Tue 03/12/2019 
09:23 AM
