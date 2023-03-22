Tue 03/12/2019 
10:42 AM
$PROB Urine DAta problem (urine2.ctl)

$INPUT ID TIME AMT RATE DV MDV EVID CMT UVOL

$DATA urine.dat IGNORE=@

$SUBROUTINE ADVAN13 TOL=6

$MODEL NCOMPARTMENTS=1

$PK
MU_1=THETA(1)
MU_2=THETA(2)
MU_3=THETA(3)
CL=EXP(MU_1+ETA(1))
V=EXP(MU_2+ETA(2))
CLR=EXP(MU_3+ETA(3))
F2=CLR/CL

$DES
DADT(1)=-CL/V*A(1)

$ERROR
CP=A(1)/V
UVL=UVOL
IF(UVL<=0.0) UVL=1.0
CU=A(2)/UVL

IF(CMT==1) THEN
IPRE=CP
W=IPRE+1.0E-10
Y=IPRE + W*EPS(1)
ELSE
IPRE=CU
W=IPRE+1.0E-10
Y=IPRE + W*EPS(2)
ENDIF

$THETA 
2 ; [LN(CL)]
4 ; [LN(V)]
1 ; [LN(CLR)]

$OMEGA BLOCK(3) VALUES(0.1,0.001) ;[P]

$SIGMA 
0.1 ;[P]
0.1 ;[P]

$EST METHOD=IMP PRINT=1 AUTO=1 SIGL=6
$COV UNCONDITIONAL MATRIX=R PRINT=E
$TABLE ID TIME AMT RATE DV IPRE MDV EVID CMT UVOL CL V CLR NOAPPEND ONEHEADER NOPRINT FILE=urine2.tab
  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
             
 (WARNING  121) INTERACTION IS IMPLIED WITH EM/BAYES ESTIMATION METHODS
  
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
 Urine DAta problem (urine2.ctl)
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:     1250
 NO. OF DATA ITEMS IN DATA SET:   9
 ID DATA ITEM IS DATA ITEM NO.:   1
 DEP VARIABLE IS DATA ITEM NO.:   5
 MDV DATA ITEM IS DATA ITEM NO.:  6
0INDICES PASSED TO SUBROUTINE PRED:
   7   2   3   4   0   0   8   0   0   0   0
0LABELS FOR DATA ITEMS:
 ID TIME AMT RATE DV MDV EVID CMT UVOL
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 CL V CLR IPRE
0FORMAT FOR DATA:
 (7E10.0/E11.0,E10.0)

 TOT. NO. OF OBS RECS:      800
 TOT. NO. OF INDIVIDUALS:       50
0LENGTH OF THETA:   3
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS BLOCK FORM:
  1
  1  1
  1  1  1
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   2
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
   0.2000E+01  0.4000E+01  0.1000E+01
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.1000E+00
                  0.1000E-02   0.1000E+00
                  0.1000E-02   0.1000E-02   0.1000E+00
0INITIAL ESTIMATE OF SIGMA:
 0.1000E+00
 0.0000E+00   0.1000E+00
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
 HEADERS:               ONE
 FILE TO BE FORWARDED:   NO
 FORMAT:                S1PE11.4
 LFORMAT:
 RFORMAT:
 FIXED_EFFECT_ETAS:
0USER-CHOSEN ITEMS:
 ID TIME AMT RATE DV IPRE MDV EVID CMT UVOL CL V CLR
1DOUBLE PRECISION PREDPP VERSION 7.4.3

 GENERAL NONLINEAR KINETICS MODEL WITH STIFF/NONSTIFF EQUATIONS (LSODA, ADVAN13)
0MODEL SUBROUTINE USER-SUPPLIED - ID NO. 9999
0MAXIMUM NO. OF BASIC PK PARAMETERS:   2
0COMPARTMENT ATTRIBUTES
 COMPT. NO.   FUNCTION   INITIAL    ON/OFF      DOSE      DEFAULT    DEFAULT
                         STATUS     ALLOWED    ALLOWED    FOR DOSE   FOR OBS.
    1         COMP 1       ON         YES        YES        YES        YES
    2         OUTPUT       OFF        YES        NO         NO         NO
 INITIAL (BASE) TOLERANCE SETTINGS:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:   6
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
1
 ADDITIONAL PK PARAMETERS - ASSIGNMENT OF ROWS IN GG
 COMPT. NO.                             INDICES
              SCALE      BIOAVAIL.   ZERO-ORDER  ZERO-ORDER  ABSORB
                         FRACTION    RATE        DURATION    LAG
    1            *           *           *           *           *
    2            *           -           -           -           -
             - PARAMETER IS NOT ALLOWED FOR THIS MODEL
             * PARAMETER IS NOT SUPPLIED BY PK SUBROUTINE;
               WILL DEFAULT TO ONE IF APPLICABLE
0OUTPUT FRACTION PARAMETER ASSIGNED TO ROW NO.:  3
0DATA ITEM INDICES USED BY PRED ARE:
   EVENT ID DATA ITEM IS DATA ITEM NO.:      7
   TIME DATA ITEM IS DATA ITEM NO.:          2
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   3
   DOSE RATE DATA ITEM IS DATA ITEM NO.:     4
   COMPT. NO. DATA ITEM IS DATA ITEM NO.:    8

0PK SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 PK SUBROUTINE NOT CALLED AT NONEVENT (ADDITIONAL OR LAGGED) DOSE TIMES.
0ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
0ERROR SUBROUTINE INDICATES THAT DERIVATIVES OF COMPARTMENT AMOUNTS ARE USED.
0DES SUBROUTINE USES COMPACT STORAGE MODE.
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
 NO. OF FUNCT. EVALS. ALLOWED:            440
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
 RAW OUTPUT FILE (FILE): urine2.ext
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
 RANDOM SAMPLING METHOD (RANMETHOD):        3U
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

 TOLERANCES FOR ESTIMATION/EVALUATION STEP:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:   6
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
 TOLERANCES FOR COVARIANCE STEP:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:   6
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
 TOLERANCES FOR TABLE/SCATTER STEP:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:   6
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
 
 THE FOLLOWING LABELS ARE EQUIVALENT
 PRED=PREDI
 RES=RESI
 WRES=WRESI
 IWRS=IWRESI
 IPRD=IPREDI
 IRS=IRESI
 
 EM/BAYES SETUP:
 THETAS THAT ARE MU MODELED:
   1   2   3
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 iteration            0 OBJ=   879.636712890567 eff.=     271. Smpl.=     300. Fit.= 0.96123
 iteration            1 OBJ=   618.235876442210 eff.=      85. Smpl.=     300. Fit.= 0.84637
 iteration            2 OBJ=   494.323468446552 eff.=      95. Smpl.=     300. Fit.= 0.82813
 iteration            3 OBJ=   386.564172311529 eff.=     117. Smpl.=     300. Fit.= 0.85242
 iteration            4 OBJ=   286.286503630543 eff.=     120. Smpl.=     300. Fit.= 0.85366
 iteration            5 OBJ=   191.100769226797 eff.=     121. Smpl.=     300. Fit.= 0.85560
 iteration            6 OBJ=   110.625151065633 eff.=     126. Smpl.=     300. Fit.= 0.86020
 iteration            7 OBJ=   61.6457556155237 eff.=     131. Smpl.=     300. Fit.= 0.86388
 iteration            8 OBJ=   54.3043093047232 eff.=     163. Smpl.=     300. Fit.= 0.89699
 iteration            9 OBJ=   54.4083977209781 eff.=     161. Smpl.=     300. Fit.= 0.89685
 iteration           10 OBJ=   55.4375870447107 eff.=     125. Smpl.=     300. Fit.= 0.86286
 iteration           11 OBJ=   54.4885064666312 eff.=     132. Smpl.=     300. Fit.= 0.86774
 iteration           12 OBJ=   54.2887083808787 eff.=     174. Smpl.=     377. Fit.= 0.87474
 iteration           13 OBJ=   54.3718338864676 eff.=     156. Smpl.=     336. Fit.= 0.87544
 iteration           14 OBJ=   55.0602808541073 eff.=     140. Smpl.=     300. Fit.= 0.87712
 iteration           15 OBJ=   55.3424786705707 eff.=     141. Smpl.=     300. Fit.= 0.87936
 iteration           16 OBJ=   55.0226419663324 eff.=     146. Smpl.=     300. Fit.= 0.88264
 Convergence achieved
 iteration           16 OBJ=   54.1250899913754 eff.=     145. Smpl.=     300. Fit.= 0.88089
 
 #TERM:
 OPTIMIZATION WAS COMPLETED


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:         5.1847E-04  4.9093E-04  7.8172E-04
 SE:             2.3441E-02  2.6727E-02  2.6764E-02
 N:                      50          50          50
 
 P VAL.:         9.8235E-01  9.8535E-01  9.7670E-01
 
 ETASHRINKSD(%)  1.3274E+00  1.7273E+00  5.8876E+00
 ETASHRINKVR(%)  2.6371E+00  3.4249E+00  1.1429E+01
 EBVSHRINKSD(%)  1.7162E+00  2.1535E+00  5.9707E+00
 EBVSHRINKVR(%)  3.4030E+00  4.2606E+00  1.1585E+01
 EPSSHRINKSD(%)  1.0383E+01  7.7595E+00
 EPSSHRINKVR(%)  1.9689E+01  1.4917E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):          800
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    1470.30165312748     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    54.1250899913754     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       1524.42674311885     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           150
  
 #TERE:
 Elapsed estimation  time in seconds:    15.76
 Elapsed covariance  time in seconds:     1.14
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************       54.125       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3     
 
         1.58E+00  3.70E+00  6.95E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        2.88E-02
 
 ETA2
+       -2.22E-03  3.77E-02
 
 ETA3
+        5.74E-03 -9.04E-03  4.13E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1      EPS2     
 
 EPS1
+        8.68E-03
 
 EPS2
+        0.00E+00  3.27E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        1.70E-01
 
 ETA2
+       -6.73E-02  1.94E-01
 
 ETA3
+        1.67E-01 -2.29E-01  2.03E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1      EPS2     
 
 EPS1
+        9.31E-02
 
 EPS2
+        0.00E+00  1.81E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                          STANDARD ERROR OF ESTIMATE (R)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3     
 
         2.44E-02  2.81E-02  3.06E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        5.94E-03
 
 ETA2
+        4.84E-03  7.84E-03
 
 ETA3
+        5.34E-03  6.17E-03  9.29E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1      EPS2     
 
 EPS1
+        6.59E-04
 
 EPS2
+        0.00E+00  2.80E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        1.75E-02
 
 ETA2
+        1.46E-01  2.02E-02
 
 ETA3
+        1.48E-01  1.46E-01  2.29E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1      EPS2     
 
 EPS1
+        3.54E-03
 
 EPS2
+       .........  7.74E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (R)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      OM11      OM12      OM13      OM22      OM23      OM33      SG11      SG12      SG22  

 
 TH 1
+        5.98E-04
 
 TH 2
+       -1.96E-05  7.90E-04
 
 TH 3
+        1.32E-04 -1.67E-04  9.39E-04
 
 OM11
+       -1.06E-06  8.31E-07  1.55E-07  3.53E-05
 
 OM12
+       -1.11E-07 -2.11E-07  3.28E-07 -1.44E-06  2.34E-05
 
 OM13
+       -2.77E-07  4.97E-07  3.63E-07  8.05E-06 -5.31E-06  2.85E-05
 
 OM22
+       -3.50E-07 -1.37E-06  1.37E-06  2.84E-07 -2.19E-06  5.48E-07  6.14E-05
 
 OM23
+        3.53E-07  5.04E-07 -6.12E-07 -4.33E-07  5.61E-06 -2.35E-06 -1.40E-05  3.81E-05
 
 OM33
+        5.92E-07  4.01E-07 -3.30E-06  1.74E-06 -2.40E-06  1.25E-05  2.98E-06 -1.59E-05  8.63E-05
 
 SG11
+        2.93E-07  3.23E-07  2.54E-07 -6.01E-08 -5.44E-08 -4.55E-08 -4.87E-08 -3.14E-08 -6.18E-08  4.34E-07
 
 SG12
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG22
+        4.47E-08 -8.90E-08 -5.26E-06 -8.95E-08 -7.06E-09  3.31E-09 -3.16E-07  1.92E-07 -1.22E-06 -3.55E-08  0.00E+00  7.83E-06
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (R)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      OM11      OM12      OM13      OM22      OM23      OM33      SG11      SG12      SG22  

 
 TH 1
+        2.44E-02
 
 TH 2
+       -2.85E-02  2.81E-02
 
 TH 3
+        1.77E-01 -1.94E-01  3.06E-02
 
 OM11
+       -7.33E-03  4.98E-03  8.50E-04  5.94E-03
 
 OM12
+       -9.36E-04 -1.55E-03  2.22E-03 -5.00E-02  4.84E-03
 
 OM13
+       -2.12E-03  3.32E-03  2.22E-03  2.54E-01 -2.06E-01  5.34E-03
 
 OM22
+       -1.83E-03 -6.20E-03  5.71E-03  6.10E-03 -5.78E-02  1.31E-02  7.84E-03
 
 OM23
+        2.34E-03  2.90E-03 -3.23E-03 -1.18E-02  1.88E-01 -7.12E-02 -2.90E-01  6.17E-03
 
 OM33
+        2.61E-03  1.54E-03 -1.16E-02  3.16E-02 -5.33E-02  2.52E-01  4.09E-02 -2.76E-01  9.29E-03
 
 SG11
+        1.82E-02  1.75E-02  1.26E-02 -1.53E-02 -1.71E-02 -1.29E-02 -9.43E-03 -7.73E-03 -1.01E-02  6.59E-04
 
 SG12
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG22
+        6.53E-04 -1.13E-03 -6.14E-02 -5.39E-03 -5.22E-04  2.22E-04 -1.44E-02  1.11E-02 -4.68E-02 -1.93E-02  0.00E+00  2.80E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (R)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      OM11      OM12      OM13      OM22      OM23      OM33      SG11      SG12      SG22  

 
 TH 1
+        1.73E+03
 
 TH 2
+       -8.87E+00  1.32E+03
 
 TH 3
+       -2.46E+02  2.37E+02  1.15E+03
 
 OM11
+        4.85E+01 -2.90E+01 -9.24E+00  3.03E+04
 
 OM12
+        2.19E+01  3.35E+00 -3.22E+01 -9.78E+01  4.62E+04
 
 OM13
+        2.11E+01 -2.30E+01 -5.27E+01 -8.89E+03  8.63E+03  4.17E+04
 
 OM22
+        8.02E+00  2.26E+01 -1.34E+01 -7.64E+01  9.99E+01 -2.48E+01  1.78E+04
 
 OM23
+       -3.24E+01 -6.42E+00  3.85E+01  7.41E+01 -6.74E+03 -1.25E+03  6.81E+03  3.20E+04
 
 OM33
+       -3.42E+01  6.66E+00  6.95E+01  6.97E+02 -1.20E+03 -5.87E+03  6.53E+02  5.65E+03  1.34E+04
 
 SG11
+       -1.03E+03 -1.10E+03 -6.17E+02  3.38E+03  6.04E+03  3.25E+03  2.62E+03  2.96E+03  1.87E+03  2.31E+06
 
 SG12
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 SG22
+       -1.84E+02  1.71E+02  7.81E+02  4.63E+02  2.45E+01 -1.02E+03  6.58E+02  4.04E+02  2.04E+03  1.04E+04  0.00E+00  1.29E+05
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          IMPORTANCE SAMPLING (NO PRIOR)                        ********************
 ********************                    EIGENVALUES OF COR MATRIX OF ESTIMATE (R)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11
 
         5.43E-01  6.99E-01  7.43E-01  9.15E-01  9.48E-01  9.64E-01  1.01E+00  1.03E+00  1.22E+00  1.29E+00  1.64E+00
 
 Elapsed postprocess time in seconds:     0.09
 Elapsed finaloutput time in seconds:     0.10
 #CPUT: Total CPU Time in Seconds,       16.224
Stop Time: 
Tue 03/12/2019 
10:42 AM
