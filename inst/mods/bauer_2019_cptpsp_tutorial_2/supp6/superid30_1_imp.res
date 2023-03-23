Mon 03/11/2019 
02:55 PM
$PROB Testing Inter-occasion with Inter-Site (example30_1.ctl)

$INPUT C SID ID OCC TIME AMT RATE EVID MDV CMT DV ROWNUM
$ABBR REPLACE ETA(OCC_CL)=ETA(5,7,9)
$ABBR REPLACE ETA(OCC_V)=ETA(6,8,10)
$DATA superid30.csv IGNORE=@

$SUBROUTINES ADVAN1 TRANS2

$PK
MU_1=THETA(1)
MU_2=THETA(2)
CL=EXP(MU_1+ETA(1)+ETA(3)+ETA(OCC_CL))
V=EXP(MU_2+ETA(2)+ETA(4)+ETA(OCC_V))
S1=V

$ERROR
IPRED=F
IF(IPRED==0.0) IPRED=0.00001
Y = IPRED+IPRED*EPS(1)


;Initial Thetas
$THETA
 2.0  ;[CL]
 3.0  ;[V]

;Individual omegas (1,2)
$OMEGA BLOCK(2)
 .1
 -.0001  .1

;SID OMEGAS (3,4)
$OMEGA BLOCK(2)
 .3
-.0001 .3

; inter-occasion omegas for occasion 1 (5,6)
$OMEGA BLOCK(2)
 .03 
 -.0001 .03

; inter-occasion omegas for occasion 2 and 3
; SAME(n) means repeat block structure n times;
; and omega parameters used for occasions 2 and 3 are shared 
; with those of occasion 1. 
$OMEGA BLOCK(2) SAME(2)

$SIGMA
 0.1

; PRIOR INFORMATION
$PRIOR NWPRI
;Individual omegas
$OMEGAP BLOCK(2)
 .03 FIXED
 0.0   .03
$OMEGAPD (2.0 FIXED)

;SID OMEGAS
$OMEGAP BLOCK(2)
 .1 FIXED
 0.0 .1
$OMEGAPD (2.0 FIXED)

; inter-occasion omegas
$OMEGAP BLOCK(2)
 .01 FIXED
 0.0 .01
$OMEGAP BLOCK(2) SAME(2)
$OMEGAPD (2.0 FIXED)

$LEVEL
SID=(3[1],4[2])

$EST METHOD=IMP INTERACTION PRINT=1 SIGL=8 FNLETA=0 NOABORT CTYPE=3 NOPRIOR=1
$COV MATRIX=R UNCONDITIONAL

$TABLE ID SID OCC TIME IPRED ETAS(1:LAST) 
       FILE=superid30_1_imp.tab NOPRINT NOAPPEND ONEHEADER
  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
             
 (WARNING  3) THERE MAY BE AN ERROR IN THE ABBREVIATED CODE. THE FOLLOWING
 ONE OR MORE RANDOM VARIABLES ARE DEFINED WITH "IF" STATEMENTS THAT DO NOT
 PROVIDE DEFINITIONS FOR BOTH THE "THEN" AND "ELSE" CASES. IF ALL
 CONDITIONS FAIL, THE VALUES OF THESE VARIABLES WILL BE ZERO.
  
   ETA(OCC_CL) ETA(OCC_V)


 (MU_WARNING 12) MU_001: SHOULD NOT BE ASSOCIATED WITH ETA(003)

 (MU_WARNING 11) MU_001: SHOULD NOT BE ASSOCIATED WITH MORE THAN ONE ETA.

 (MU_WARNING 12) MU_002: SHOULD NOT BE ASSOCIATED WITH ETA(004)

 (MU_WARNING 11) MU_002: SHOULD NOT BE ASSOCIATED WITH MORE THAN ONE ETA.
  
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
 Testing Inter-occasion with Inter-Site (example30_1.ctl)
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:     6600
 NO. OF DATA ITEMS IN DATA SET:  12
 ID DATA ITEM IS DATA ITEM NO.:   3
 DEP VARIABLE IS DATA ITEM NO.:  11
 MDV DATA ITEM IS DATA ITEM NO.:  9
0INDICES PASSED TO SUBROUTINE PRED:
   8   5   6   7   0   0  10   0   0   0   0
0LABELS FOR DATA ITEMS:
 C SID ID OCC TIME AMT RATE EVID MDV CMT DV ROWNUM
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 IPRED
0FORMAT FOR DATA:
 (7E10.0/5E10.0)

 TOT. NO. OF OBS RECS:     6000
 TOT. NO. OF INDIVIDUALS:      200
0LENGTH OF THETA:   5
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS BLOCK FORM:
  1
  1  1
  0  0  2
  0  0  2  2
  0  0  0  0  3
  0  0  0  0  3  3
  0  0  0  0  0  0  3
  0  0  0  0  0  0  3  3
  0  0  0  0  0  0  0  0  3
  0  0  0  0  0  0  0  0  3  3
  0  0  0  0  0  0  0  0  0  0  4
  0  0  0  0  0  0  0  0  0  0  4  4
  0  0  0  0  0  0  0  0  0  0  0  0  5
  0  0  0  0  0  0  0  0  0  0  0  0  5  5
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  6
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  6  6
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  6
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  6  6
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  6
  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  6  6
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   1
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
 LOWER BOUND    INITIAL EST    UPPER BOUND
 -0.1000E+07     0.2000E+01     0.1000E+07
 -0.1000E+07     0.3000E+01     0.1000E+07
  0.2000E+01     0.2000E+01     0.2000E+01
  0.2000E+01     0.2000E+01     0.2000E+01
  0.2000E+01     0.2000E+01     0.2000E+01
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.1000E+00
                 -0.1000E-03   0.1000E+00
        2                                                                                   NO
                  0.3000E+00
                 -0.1000E-03   0.3000E+00
        3                                                                                   NO
                  0.3000E-01
                 -0.1000E-03   0.3000E-01
        4                                                                                  YES
                  0.3000E-01
                  0.0000E+00   0.3000E-01
        5                                                                                  YES
                  0.1000E+00
                  0.0000E+00   0.1000E+00
        6                                                                                  YES
                  0.1000E-01
                  0.0000E+00   0.1000E-01
0INITIAL ESTIMATE OF SIGMA:
 0.1000E+00
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
0RECORDS ONLY:    ALL
04 COLUMNS APPENDED:    NO
 PRINTED:                NO
 HEADERS:               ONE
 FILE TO BE FORWARDED:   NO
 FORMAT:                S1PE11.4
 LFORMAT:
 RFORMAT:
 FIXED_EFFECT_ETAS:
0USER-CHOSEN ITEMS:
 ID SID OCC TIME IPRED ETA1 ETA2 ETA3 ETA4 ETA5 ETA6 ETA7 ETA8 ETA9 ET10
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
   EVENT ID DATA ITEM IS DATA ITEM NO.:      8
   TIME DATA ITEM IS DATA ITEM NO.:          5
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   6
   DOSE RATE DATA ITEM IS DATA ITEM NO.:     7
   COMPT. NO. DATA ITEM IS DATA ITEM NO.:   10

0PK SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 PK SUBROUTINE NOT CALLED AT NONEVENT (ADDITIONAL OR LAGGED) DOSE TIMES.
0ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
1
 
 
 #TBLN:      1
 #METH: Importance Sampling (No Prior)
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            3248
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
 FINAL ETA RE-EVALUATION (FNLETA):          OFF
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): superid30_1_imp.ext
 EXCLUDE TITLE (NOTITLE):                   NO
 EXCLUDE COLUMN LABELS (NOLABEL):           NO
 FORMAT FOR ADDITIONAL FILES (FORMAT):      S1PE12.5
 PARAMETER ORDER FOR OUTPUTS (ORDER):       TSOL
 WISHART PRIOR DF INTERPRETATION (WISHTYPE):0
 KNUTHSUMOFF:                               0
 INCLUDE LNTWOPI:                           NO
 INCLUDE CONSTANT TERM TO PRIOR (PRIORC):   NO
 INCLUDE CONSTANT TERM TO OMEGA (ETA) (OLNTWOPI):NO
 NESTED LEVEL MAPS:
  SID=(3[1],4[2])
 Level Weighting Type (LEVWT):0
 EM OR BAYESIAN METHOD USED:                IMPORTANCE SAMPLING (IMP)
 MU MODELING PATTERN (MUM):
 GRADIENT/GIBBS PATTERN (GRD):
 AUTOMATIC SETTING FEATURE (AUTO):          OFF
 CONVERGENCE TYPE (CTYPE):                  3
 CONVERGENCE INTERVAL (CINTERVAL):          1
 CONVERGENCE ITERATIONS (CITER):            10
 CONVERGENCE ALPHA ERROR (CALPHA):          5.000000000000000E-02
 ITERATIONS (NITER):                        50
 ANEAL SETTING (CONSTRAIN):                 1
 STARTING SEED FOR MC METHODS (SEED):       11456
 MC SAMPLES PER SUBJECT (ISAMPLE):          300
 RANDOM SAMPLING METHOD (RANMETHOD):        3U
 EXPECTATION ONLY (EONLY):                  0
 PROPOSAL DENSITY SCALING RANGE
              (ISCALE_MIN, ISCALE_MAX):     0.100000000000000       ,10.0000000000000
 SAMPLE ACCEPTANCE RATE (IACCEPT):          0.400000000000000
 LONG TAIL SAMPLE ACCEPT. RATE (IACCEPTL):   0.00000000000000
 T-DIST. PROPOSAL DENSITY (DF):             0
 NO. ITERATIONS FOR MAP (MAPITER):          1
 INTERVAL ITER. FOR MAP (MAPINTER):         0
 MAP COVARIANCE/MODE SETTING (MAPCOV):      1
 Gradient Quick Value (GRDQ):               0.00000000000000

 
 THE FOLLOWING LABELS ARE EQUIVALENT
 PRED=PREDI
 RES=RESI
 WRES=WRESI
 IWRS=IWRESI
 IPRD=IPREDI
 IRS=IRESI
 
 EM/BAYES SETUP:
 THETAS THAT ARE MU MODELED:
   1   2
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 iteration            0 OBJ=   10809.6288565148 eff.=     274. Smpl.=     300. Fit.= 0.98785
 iteration            1 OBJ=   8522.90494381102 eff.=     274. Smpl.=     300. Fit.= 0.96387
 iteration            2 OBJ=   8290.07365848060 eff.=     167. Smpl.=     300. Fit.= 0.96278
 iteration            3 OBJ=   8064.53027845356 eff.=     419. Smpl.=     300. Fit.= 0.95964
 iteration            4 OBJ=   7527.67918693584 eff.=     264. Smpl.=     300. Fit.= 0.96294
 iteration            5 OBJ=   6883.54631147010 eff.=     204. Smpl.=     300. Fit.= 0.96293
 iteration            6 OBJ=   6372.95368147705 eff.=     193. Smpl.=     300. Fit.= 0.96298
 iteration            7 OBJ=   5851.90575595709 eff.=     141. Smpl.=     300. Fit.= 0.96370
 iteration            8 OBJ=   5413.56147146607 eff.=     166. Smpl.=     300. Fit.= 0.96552
 iteration            9 OBJ=   4920.83476948695 eff.=     149. Smpl.=     300. Fit.= 0.96426
 iteration           10 OBJ=   4518.10180945649 eff.=     111. Smpl.=     300. Fit.= 0.96484
 iteration           11 OBJ=   4061.87222473958 eff.=     143. Smpl.=     300. Fit.= 0.96488
 iteration           12 OBJ=   3647.39141022781 eff.=     119. Smpl.=     300. Fit.= 0.96798
 iteration           13 OBJ=   3252.57636172126 eff.=     157. Smpl.=     300. Fit.= 0.96582
 iteration           14 OBJ=   2860.35619786715 eff.=     162. Smpl.=     300. Fit.= 0.96649
 iteration           15 OBJ=   2483.94018277457 eff.=     109. Smpl.=     300. Fit.= 0.96685
 iteration           16 OBJ=   2141.24937719529 eff.=     113. Smpl.=     300. Fit.= 0.96850
 iteration           17 OBJ=   1888.48842104682 eff.=     125. Smpl.=     300. Fit.= 0.96837
 iteration           18 OBJ=   1785.37791268115 eff.=     143. Smpl.=     300. Fit.= 0.96691
 iteration           19 OBJ=   1777.06805374879 eff.=     168. Smpl.=     300. Fit.= 0.97403
 iteration           20 OBJ=   1772.27519407816 eff.=     120. Smpl.=     300. Fit.= 0.97113
 iteration           21 OBJ=   1770.24375530404 eff.=     129. Smpl.=     300. Fit.= 0.97139
 iteration           22 OBJ=   1769.96162735266 eff.=     123. Smpl.=     300. Fit.= 0.97142
 iteration           23 OBJ=   1766.71973454529 eff.=     112. Smpl.=     300. Fit.= 0.97223
 iteration           24 OBJ=   1767.60413404921 eff.=     128. Smpl.=     300. Fit.= 0.97266
 iteration           25 OBJ=   1765.86755406985 eff.=     121. Smpl.=     300. Fit.= 0.97260
 iteration           26 OBJ=   1766.70328160311 eff.=     120. Smpl.=     300. Fit.= 0.97300
 iteration           27 OBJ=   1767.44451322114 eff.=     126. Smpl.=     300. Fit.= 0.97314
 iteration           28 OBJ=   1766.36365356042 eff.=     123. Smpl.=     300. Fit.= 0.97338
 iteration           29 OBJ=   1766.96860448765 eff.=     129. Smpl.=     300. Fit.= 0.97287
 iteration           30 OBJ=   1767.19731091039 eff.=     118. Smpl.=     300. Fit.= 0.97284
 Convergence achieved
 iteration           30 OBJ=   1767.41620197819 eff.=     124. Smpl.=     300. Fit.= 0.97317
 
 #TERM:
 OPTIMIZATION WAS COMPLETED


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -2.4590E-04  1.1793E-04 -1.2212E-17  2.3315E-17 -3.8993E-03 -4.2940E-03 -2.1242E-03 -5.3632E-03  5.2828E-03  8.4730E-03
 SE:             1.0725E-02  1.0708E-02  5.6551E-02  9.5771E-02  5.9836E-03  6.1878E-03  5.6360E-03  5.5856E-03  5.8047E-03  5.7032E-03
 N:                     200         200          20          20         200         200         200         200         200         200
 
 P VAL.:         9.8171E-01  9.9121E-01  1.0000E+00  1.0000E+00  5.1462E-01  4.8772E-01  7.0625E-01  3.3697E-01  3.6278E-01  1.3737E-01
 
 ETASHRINKSD(%)  5.8639E+00  6.1506E+00  1.0000E-10  1.0000E-10  1.7500E+01  1.5447E+01  2.2293E+01  2.3676E+01  1.9967E+01  2.2070E+01
 ETASHRINKVR(%)  1.1384E+01  1.1923E+01  1.0000E-10  1.0000E-10  3.1938E+01  2.8507E+01  3.9616E+01  4.1746E+01  3.5947E+01  3.9269E+01
 EBVSHRINKSD(%)  6.0565E+00  6.2982E+00  0.0000E+00  0.0000E+00  1.9536E+01  2.0214E+01  1.9561E+01  2.0287E+01  1.9624E+01  2.0355E+01
 EBVSHRINKVR(%)  1.1746E+01  1.2200E+01  0.0000E+00  0.0000E+00  3.5256E+01  3.6342E+01  3.5296E+01  3.6459E+01  3.5397E+01  3.6567E+01
 EPSSHRINKSD(%)  9.7738E+00
 EPSSHRINKVR(%)  1.8592E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         6000
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    11027.2623984561     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    1767.41620197819     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       12794.6786004343     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                          1598
  
 #TERE:
 Elapsed estimation  time in seconds:   120.47
 Elapsed covariance  time in seconds:     4.60
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     1767.416       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2     
 
         1.22E+00  4.01E+00
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        2.88E-02
 
 ETA2
+        2.86E-03  2.89E-02
 
 ETA3
+        0.00E+00  0.00E+00  6.72E-02
 
 ETA4
+        0.00E+00  0.00E+00  3.40E-03  1.93E-01
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.06E-02
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00 -4.12E-04  1.08E-02
 
 ETA7
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.06E-02
 
 ETA8
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -4.12E-04  1.08E-02
 
 ETA9
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.06E-02
 
 ET10
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -4.12E-04  1.08E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        9.91E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        1.70E-01
 
 ETA2
+        9.88E-02  1.70E-01
 
 ETA3
+        0.00E+00  0.00E+00  2.59E-01
 
 ETA4
+        0.00E+00  0.00E+00  2.98E-02  4.39E-01
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.03E-01
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.86E-02  1.04E-01
 
 ETA7
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.03E-01
 
 ETA8
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.86E-02  1.04E-01
 
 ETA9
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.03E-01
 
 ET10
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.86E-02  1.04E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        9.95E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                          STANDARD ERROR OF ESTIMATE (R)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2     
 
         1.28E-02  1.28E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        2.99E-03
 
 ETA2
+        2.14E-03  3.11E-03
 
 ETA3
+        0.00E+00  0.00E+00  1.95E-02
 
 ETA4
+        0.00E+00  0.00E+00  2.76E-02  9.90E-02
 
 ETA5
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  8.48E-04
 
 ETA6
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  6.00E-04  8.64E-04
 
 ETA7
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  8.48E-04
 
 ETA8
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  6.00E-04  8.64E-04
 
 ETA9
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  8.48E-04
 
 ET10
+        0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  6.00E-04  8.64E-04
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        2.05E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6      ETA7      ETA8      ETA9      ET10     
 
 ETA1
+        8.80E-03
 
 ETA2
+        7.34E-02  9.14E-03
 
 ETA3
+       ......... .........  3.76E-02
 
 ETA4
+       ......... .........  2.45E-01  1.13E-01
 
 ETA5
+       ......... ......... ......... .........  4.12E-03
 
 ETA6
+       ......... ......... ......... .........  5.65E-02  4.16E-03
 
 ETA7
+       ......... ......... ......... ......... ......... ......... .........
 
 ETA8
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 ETA9
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 ET10
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.03E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (R)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
  TH 1
+          1.64E-04
 
  TH 2
+          1.51E-05  1.65E-04
 
 OM0101
+          6.77E-07  1.18E-08  8.93E-06
 
 OM0102
+         -1.87E-07  1.12E-07  6.96E-07  4.59E-06
 
 OM0103
+         ......... ......... ......... ......... .........
 
 OM0104
+         ......... ......... ......... ......... ......... .........
 
 OM0105
+         ......... ......... ......... ......... ......... ......... .........
 
 OM0106
+         ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0107
+         ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0108
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0109
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0110
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0202
+         -1.45E-07 -5.66E-07 -6.21E-07  7.14E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            9.68E-06
 
 OM0203
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... .........
 
 OM0204
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0205
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0206
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
 OM0207
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0208
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... .........
 
 OM0209
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0210
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0303
+         -5.91E-06 -5.56E-07 -4.39E-06  1.11E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            2.00E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  3.79E-04
 
 OM0304
+          5.90E-06  7.04E-06  5.14E-06 -3.32E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            3.00E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.87E-04  7.59E-04
 
 OM0305
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0306
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0307
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
 OM0308
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0309
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0310
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0404
+          3.25E-05 -1.11E-05  7.48E-07 -8.91E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -4.84E-05  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.11E-04 -4.59E-04  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  9.80E-03
 
 OM0405
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0406
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0407
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0408
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0409
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0410
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0505
+         -2.11E-08  3.61E-08 -2.24E-07 -4.52E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -2.14E-07  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.73E-06 -1.92E-07  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  3.35E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            7.19E-07
 
 OM0506
+          5.82E-08 -2.41E-08 -7.94E-08 -7.36E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -8.09E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  3.45E-07 -6.17E-07  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  5.47E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            3.73E-08  3.61E-07
 
 OM0507
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0508
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0509
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0510
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
 OM0606
+         -7.79E-08  1.13E-08 -1.24E-07 -3.69E-09  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -7.86E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.05E-06 -6.26E-07  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.42E-05  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -4.18E-10  1.14E-08  0.00E+00  0.00E+00  0.00E+00  0.00E+00  7.46E-07
 
 OM0607
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0608
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0609
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0610
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0707
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0708
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0709
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0710
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0808
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0809
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0810
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... .........
 
 OM0909
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
 OM0910
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM1010
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG0101
+          2.53E-08  4.03E-08  1.59E-09 -3.24E-09  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            9.96E-09  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.73E-08  3.45E-07  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.95E-06  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -5.87E-09 -4.82E-09  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -4.48E-09  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.20E-08
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (R)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
  TH 1
+          1.28E-02
 
  TH 2
+          9.22E-02  1.28E-02
 
 OM0101
+          1.77E-02  3.07E-04  2.99E-03
 
 OM0102
+         -6.81E-03  4.08E-03  1.09E-01  2.14E-03
 
 OM0103
+         ......... ......... ......... ......... .........
 
 OM0104
+         ......... ......... ......... ......... ......... .........
 
 OM0105
+         ......... ......... ......... ......... ......... ......... .........
 
 OM0106
+         ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0107
+         ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0108
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0109
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0110
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0202
+         -3.65E-03 -1.42E-02 -6.69E-02  1.07E-01  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            3.11E-03
 
 OM0203
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... .........
 
 OM0204
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0205
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0206
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
 OM0207
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0208
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... .........
 
 OM0209
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0210
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0303
+         -2.37E-02 -2.22E-03 -7.55E-02  2.65E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            3.30E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.95E-02
 
 OM0304
+          1.67E-02  1.99E-02  6.24E-02 -5.62E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            3.50E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -3.48E-01  2.76E-02
 
 OM0305
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0306
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0307
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
 OM0308
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0309
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0310
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0404
+          2.56E-02 -8.71E-03  2.53E-03 -4.20E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -1.57E-01  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  5.74E-02 -1.68E-01  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  9.90E-02
 
 OM0405
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0406
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0407
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0408
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0409
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0410
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0505
+         -1.94E-03  3.31E-03 -8.83E-02 -2.48E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -8.13E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.05E-01 -8.22E-03  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  3.99E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            8.48E-04
 
 OM0506
+          7.57E-03 -3.13E-03 -4.43E-02 -5.72E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -4.33E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  2.95E-02 -3.73E-02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  9.21E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            7.33E-02  6.00E-04
 
 OM0507
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0508
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0509
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0510
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
 OM0606
+         -7.05E-03  1.02E-03 -4.80E-02 -2.00E-03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -2.93E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -6.24E-02 -2.63E-02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -1.66E-01  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -5.70E-04  2.19E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  8.64E-04
 
 OM0607
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0608
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0609
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0610
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0707
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0708
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0709
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0710
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0808
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0809
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0810
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... .........
 
 OM0909
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
 OM0910
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM1010
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG0101
+          9.65E-03  1.53E-02  2.59E-03 -7.37E-03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.56E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -4.34E-03  6.10E-02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -9.59E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -3.38E-02 -3.92E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.53E-02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  2.05E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (R)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
  TH 1
+          6.17E+03
 
  TH 2
+         -5.67E+02  6.12E+03
 
 OM0101
+         -4.39E+02  1.02E+02  1.16E+05
 
 OM0102
+          2.43E+02 -2.76E+02 -1.93E+04  2.25E+05
 
 OM0103
+         ......... ......... ......... ......... .........
 
 OM0104
+         ......... ......... ......... ......... ......... .........
 
 OM0105
+         ......... ......... ......... ......... ......... ......... .........
 
 OM0106
+         ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0107
+         ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0108
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0109
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0110
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0202
+         -1.16E+02  4.39E+02  9.95E+03 -1.71E+04  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.09E+05
 
 OM0203
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... .........
 
 OM0204
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0205
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0206
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
 OM0207
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0208
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... .........
 
 OM0209
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0210
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0303
+          8.33E+01 -3.00E+01  9.09E+02 -2.69E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -8.88E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  3.07E+03
 
 OM0304
+         -3.09E+01 -5.66E+01 -6.51E+02  1.23E+03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -4.44E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  7.58E+02  1.56E+03
 
 OM0305
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0306
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0307
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
 OM0308
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0309
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0310
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0404
+         -2.38E+01  7.19E+00 -7.19E+00  1.64E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            5.28E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  5.33E+00  6.70E+01  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.13E+02
 
 OM0405
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0406
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0407
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0408
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0409
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0410
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0505
+         -9.44E+00 -7.10E+01  1.16E+04  5.09E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.12E+04  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -2.39E+03 -6.96E+02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -8.11E+01  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            1.60E+05
 
 OM0506
+         -3.12E+02  1.16E+02  5.99E+03  1.26E+04  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            3.77E+03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -4.28E+02  3.11E+02  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -4.80E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -1.37E+04  3.15E+05
 
 OM0507
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... .........
 
 OM0508
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... .........
 
 OM0509
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0510
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... .........
 
 OM0606
+          6.59E+01 -2.59E+01  6.87E+03 -1.68E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            7.13E+03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.70E+03  1.14E+03  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  7.73E+02  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           -3.75E+02 -7.33E+03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  1.56E+05
 
 OM0607
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0608
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0609
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0610
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0707
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM0708
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          .........
 
 OM0709
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... .........
 
1

             TH 1      TH 2     OM0101    OM0102    OM0103    OM0104    OM0105    OM0106    OM0107    OM0108    OM0109    OM0110  
             OM0202    OM0203    OM0204    OM0205    OM0206    OM0207    OM0208    OM0209    OM0210    OM0303    OM0304    OM0305  
            OM0306    OM0307    OM0308    OM0309    OM0310    OM0404    OM0405    OM0406    OM0407    OM0408    OM0409    OM0410  
             OM0505    OM0506    OM0507    OM0508    OM0509    OM0510    OM0606    OM0607    OM0608    OM0609    OM0610    OM0707  
            OM0708    OM0709    OM0710    OM0808    OM0809    OM0810    OM0909    OM0910    OM1010    SG0101  
 
 OM0710
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... .........
 
 OM0808
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... .........
 
 OM0809
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... .........
 
 OM0810
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... .........
 
 OM0909
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... .........
 
 OM0910
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... .........
 
 OM1010
+         ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
           ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
          ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG0101
+         -4.01E+03 -4.87E+03  6.42E+03  2.41E+04  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            8.06E+03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00 -5.18E+03 -8.93E+03  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  4.63E+03  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
            6.00E+04  7.52E+04  0.00E+00  0.00E+00  0.00E+00  0.00E+00  7.22E+04  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00
           0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  0.00E+00  2.42E+07
 
 SKIPPING EXECUTION OF SLOW FNLMOD/FNLETA BY USER REQUEST
 Elapsed postprocess time in seconds:     0.02
 Elapsed finaloutput time in seconds:     0.36
 #CPUT: Total CPU Time in Seconds,      123.038
Stop Time: 
Mon 03/11/2019 
02:57 PM
