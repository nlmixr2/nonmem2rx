Mon 02/22/2021 
04:25 PM
$PROBLEM WARFARIN PK/PD
$INPUT ID TIME AMT RATE EVID MDV DV CMT TSTRAT TMIN TMAX

$DATA warfarin_pkpd_eval2.csv ignore=C

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

$DESIGN GROUPSIZE=26 FIMTYPE=1 VARCROSS=1
  
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
 NO. OF DATA RECS IN DATA SET:       18
 NO. OF DATA ITEMS IN DATA SET:  11
 ID DATA ITEM IS DATA ITEM NO.:   1
 DEP VARIABLE IS DATA ITEM NO.:   7
 MDV DATA ITEM IS DATA ITEM NO.:  6
0INDICES PASSED TO SUBROUTINE PRED:
   5   2   3   4   0   0   8   0   0   0   0
0LABELS FOR DATA ITEMS:
 ID TIME AMT RATE EVID MDV DV CMT TSTRAT TMIN TMAX
0FORMAT FOR DATA:
 (11E6.0)

 TOT. NO. OF OBS RECS:       16
 TOT. NO. OF INDIVIDUALS:        2
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
 #METH: First Order (Evaluation): D-OPTIMALITY

 ESTIMATION STEP OMITTED:                 YES
 ANALYSIS TYPE:                           POPULATION
 POP. ETAS OBTAINED POST HOC:             YES
 DESIGN TYPE: D-OPTIMALITY, -LOG(DET(FIM))
 SIMULATE OBSERVED DATA FOR DESIGN:  NO
 BLOCK DIAGONALIZATION TYPE FOR DESIGN:  1
 RESIDUAL STANDARD DEVIATION MODELING (VAR_CROSS=1)
 DESIGN GROUPSIZE=  2.6000000000000000E+01
 OPTIMALITY RANDOM GENERATION SEED: 11456
 TOLERANCES FOR ESTIMATION/EVALUATION STEP:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:  12
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
 TOLERANCES FOR COVARIANCE STEP:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:  12
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12

 THE FOLLOWING LABELS ARE EQUIVALENT
 PRED=NPRED
 RES=NRES
 WRES=NWRES
 IWRS=NIWRES
 IPRD=NIPRED
 IRS=NIRES

 #TERM:

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.

 ETABAR:         0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00
 SE:             0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00  0.0000E+00
 N:                       2           2           2           2           2           2

 P VAL.:         1.0000E+00  1.0000E+00  1.0000E+00  1.0000E+00  1.0000E+00  1.0000E+00

 ETASHRINKSD(%)  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02
 ETASHRINKVR(%)  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02  1.0000E+02
 EBVSHRINKSD(%)  4.8006E+00  3.7992E+00  1.7727E+01  6.0792E-02  2.7757E+01  7.1474E-01
 EBVSHRINKVR(%)  9.3708E+00  7.4540E+00  3.2312E+01  1.2155E-01  4.7810E+01  1.4244E+00
 RELATIVEINF(%)  8.9557E+01  8.2766E+01  6.0846E+01  9.9857E+01  4.4255E+01  9.8334E+01
 EPSSHRINKSD(%)  5.0000E+01  5.0000E+01
 EPSSHRINKVR(%)  7.5000E+01  7.5000E+01

 #TERE:
 Elapsed opt. design time in seconds:     0.07
 Elapsed postprocess time in seconds:     0.02
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                      FIRST ORDER (EVALUATION): D-OPTIMALITY                    ********************
 #OBJT:**************                MINIMUM VALUE OF OBJECTIVE FUNCTION: D-OPTIMALITY               ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     -116.302       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                      FIRST ORDER (EVALUATION): D-OPTIMALITY                    ********************
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
 ********************                      FIRST ORDER (EVALUATION): D-OPTIMALITY                    ********************
 ********************                            STANDARD ERROR OF ESTIMATE                          ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6     
 
         1.97E-01  5.12E-03  2.03E-01  3.27E-01  2.91E-02  9.91E-04
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6     
 
 ETA1
+        1.53E-01
 
 ETA2
+       .........  1.34E-02
 
 ETA3
+       ......... .........  5.90E-03
 
 ETA4
+       ......... ......... .........  3.73E-02
 
 ETA5
+       ......... ......... ......... .........  4.96E-03
 
 ETA6
+       ......... ......... ......... ......... .........  3.18E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1      EPS2     
 
 EPS1
+        5.42E-03
 
 EPS2
+       .........  8.87E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4      ETA5      ETA6     
 
 ETA1
+        9.13E-02
 
 ETA2
+       .........  2.67E-02
 
 ETA3
+       ......... .........  2.09E-02
 
 ETA4
+       ......... ......... .........  4.28E-02
 
 ETA5
+       ......... ......... ......... .........  2.17E-02
 
 ETA6
+       ......... ......... ......... ......... .........  1.26E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1      EPS2     
 
 EPS1
+        1.35E-02
 
 EPS2
+       .........  1.14E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                      FIRST ORDER (EVALUATION): D-OPTIMALITY                    ********************
 ********************                          COVARIANCE MATRIX OF ESTIMATE                         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

     TH 1 | TH 1      TH 2 | TH 1      TH 2 | TH 2      TH 3 | TH 1      TH 3 | TH 2      TH 3 | TH 3      TH 4 | TH 1  
     3.88E-02         5.36E-05         2.62E-05         3.58E-03         2.15E-04         4.11E-02         4.50E-05

     TH 4 | TH 2      TH 4 | TH 3      TH 4 | TH 4      TH 5 | TH 1      TH 5 | TH 2      TH 5 | TH 3      TH 5 | TH 4  
    -6.57E-06         4.21E-04         1.07E-01        -5.15E-04        -4.74E-05        -1.79E-03         9.77E-05

     TH 5 | TH 5      TH 6 | TH 1      TH 6 | TH 2      TH 6 | TH 3      TH 6 | TH 4      TH 6 | TH 5      TH 6 | TH 6  
     8.46E-04        -1.70E-07        -7.79E-08         3.90E-06         1.61E-06         1.12E-06         9.82E-07

   OM11 | TH 1      OM11 | TH 2      OM11 | TH 3      OM11 | TH 4      OM11 | TH 5      OM11 | TH 6      OM11 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         2.33E-02

   OM22 | TH 1      OM22 | TH 2      OM22 | TH 3      OM22 | TH 4      OM22 | TH 5      OM22 | TH 6      OM22 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         1.59E-07

   OM22 | OM22      OM33 | TH 1      OM33 | TH 2      OM33 | TH 3      OM33 | TH 4      OM33 | TH 5      OM33 | TH 6    
     1.80E-04         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM33 | OM11      OM33 | OM22      OM33 | OM33      OM44 | TH 1      OM44 | TH 2      OM44 | TH 3      OM44 | TH 4    
     4.31E-06        -5.97E-07         3.48E-05         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM44 | TH 5      OM44 | TH 6      OM44 | OM11      OM44 | OM22      OM44 | OM33      OM44 | OM44      OM55 | TH 1    
     0.00E+00         0.00E+00         6.57E-07         5.71E-09        -1.67E-09         1.39E-03         0.00E+00

   OM55 | TH 2      OM55 | TH 3      OM55 | TH 4      OM55 | TH 5      OM55 | TH 6      OM55 | OM11      OM55 | OM22    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         1.33E-06        -4.67E-06

   OM55 | OM33      OM55 | OM44      OM55 | OM55      OM66 | TH 1      OM66 | TH 2      OM66 | TH 3      OM66 | TH 4    
    -2.56E-06        -6.08E-08         2.46E-05         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM66 | TH 5      OM66 | TH 6      OM66 | OM11      OM66 | OM22      OM66 | OM33      OM66 | OM44      OM66 | OM55    
     0.00E+00         0.00E+00         6.52E-07         6.19E-09        -1.82E-09         4.43E-09        -6.46E-08

   OM66 | OM66      SG11 | TH 1      SG11 | TH 2      SG11 | TH 3      SG11 | TH 4      SG11 | TH 5      SG11 | TH 6    
     1.01E-05         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   SG11 | OM11      SG11 | OM22      SG11 | OM33      SG11 | OM44      SG11 | OM55      SG11 | OM66      SG11 | SG11    
    -3.12E-05        -2.02E-07        -3.53E-06         6.14E-08        -4.86E-06         5.76E-08         2.93E-05

   SG22 | TH 1      SG22 | TH 2      SG22 | TH 3      SG22 | TH 4      SG22 | TH 5      SG22 | TH 6      SG22 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00        -6.89E-06

   SG22 | OM22      SG22 | OM33      SG22 | OM44      SG22 | OM55      SG22 | OM66      SG22 | SG11      SG22 | SG22      
     9.74E-09        -2.48E-07        -7.23E-08         1.69E-07        -7.05E-08        -8.44E-07         7.87E-07
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                      FIRST ORDER (EVALUATION): D-OPTIMALITY                    ********************
 ********************                          CORRELATION MATRIX OF ESTIMATE                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

     TH 1 | TH 1      TH 2 | TH 1      TH 2 | TH 2      TH 3 | TH 1      TH 3 | TH 2      TH 3 | TH 3      TH 4 | TH 1  
     1.97E-01         5.31E-02         5.12E-03         8.98E-02         2.07E-01         2.03E-01         6.98E-04

     TH 4 | TH 2      TH 4 | TH 3      TH 4 | TH 4      TH 5 | TH 1      TH 5 | TH 2      TH 5 | TH 3      TH 5 | TH 4  
    -3.92E-03         6.35E-03         3.27E-01        -9.00E-02        -3.19E-01        -3.04E-01         1.03E-02

     TH 5 | TH 5      TH 6 | TH 1      TH 6 | TH 2      TH 6 | TH 3      TH 6 | TH 4      TH 6 | TH 5      TH 6 | TH 6  
     2.91E-02        -8.72E-04        -1.54E-02         1.94E-02         4.97E-03         3.87E-02         9.91E-04

   OM11 | TH 1      OM11 | TH 2      OM11 | TH 3      OM11 | TH 4      OM11 | TH 5      OM11 | TH 6      OM11 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         1.53E-01

   OM22 | TH 1      OM22 | TH 2      OM22 | TH 3      OM22 | TH 4      OM22 | TH 5      OM22 | TH 6      OM22 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         7.76E-05

   OM22 | OM22      OM33 | TH 1      OM33 | TH 2      OM33 | TH 3      OM33 | TH 4      OM33 | TH 5      OM33 | TH 6    
     1.34E-02         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM33 | OM11      OM33 | OM22      OM33 | OM33      OM44 | TH 1      OM44 | TH 2      OM44 | TH 3      OM44 | TH 4    
     4.78E-03        -7.55E-03         5.90E-03         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM44 | TH 5      OM44 | TH 6      OM44 | OM11      OM44 | OM22      OM44 | OM33      OM44 | OM44      OM55 | TH 1    
     0.00E+00         0.00E+00         1.15E-04         1.14E-05        -7.58E-06         3.73E-02         0.00E+00

   OM55 | TH 2      OM55 | TH 3      OM55 | TH 4      OM55 | TH 5      OM55 | TH 6      OM55 | OM11      OM55 | OM22    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         1.76E-03        -7.02E-02

   OM55 | OM33      OM55 | OM44      OM55 | OM55      OM66 | TH 1      OM66 | TH 2      OM66 | TH 3      OM66 | TH 4    
    -8.76E-02        -3.29E-04         4.96E-03         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM66 | TH 5      OM66 | TH 6      OM66 | OM11      OM66 | OM22      OM66 | OM33      OM66 | OM44      OM66 | OM55    
     0.00E+00         0.00E+00         1.34E-03         1.45E-04        -9.68E-05         3.73E-05        -4.09E-03

   OM66 | OM66      SG11 | TH 1      SG11 | TH 2      SG11 | TH 3      SG11 | TH 4      SG11 | TH 5      SG11 | TH 6    
     3.18E-03         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   SG11 | OM11      SG11 | OM22      SG11 | OM33      SG11 | OM44      SG11 | OM55      SG11 | OM66      SG11 | SG11    
    -3.77E-02        -2.79E-03        -1.11E-01         3.04E-04        -1.81E-01         3.34E-03         5.42E-03

   SG22 | TH 1      SG22 | TH 2      SG22 | TH 3      SG22 | TH 4      SG22 | TH 5      SG22 | TH 6      SG22 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00        -5.08E-02

   SG22 | OM22      SG22 | OM33      SG22 | OM44      SG22 | OM55      SG22 | OM66      SG22 | SG11      SG22 | SG22      
     8.18E-04        -4.74E-02        -2.18E-03         3.85E-02        -2.50E-02        -1.76E-01         8.87E-04
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                      FIRST ORDER (EVALUATION): D-OPTIMALITY                    ********************
 ********************                      INVERSE COVARIANCE MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

     TH 1 | TH 1      TH 2 | TH 1      TH 2 | TH 2      TH 3 | TH 1      TH 3 | TH 2      TH 3 | TH 3      TH 4 | TH 1  
     2.61E+01        -1.92E+01         4.31E+04        -1.69E+00        -1.32E+02         2.74E+01        -1.57E-02

     TH 4 | TH 2      TH 4 | TH 3      TH 4 | TH 4      TH 5 | TH 1      TH 5 | TH 2      TH 5 | TH 3      TH 5 | TH 4  
     1.21E+00        -1.58E-01         9.34E+00         1.13E+01         2.12E+03         4.99E+01        -1.34E+00

     TH 5 | TH 5      TH 6 | TH 1      TH 6 | TH 2      TH 6 | TH 3      TH 6 | TH 4      TH 6 | TH 5      TH 6 | TH 6  
     1.42E+03        -3.07E+00         1.52E+03        -1.76E+02        -1.31E+01        -1.64E+03         1.02E+06

   OM11 | TH 1      OM11 | TH 2      OM11 | TH 3      OM11 | TH 4      OM11 | TH 5      OM11 | TH 6      OM11 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         4.30E+01

   OM22 | TH 1      OM22 | TH 2      OM22 | TH 3      OM22 | TH 4      OM22 | TH 5      OM22 | TH 6      OM22 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         2.03E-01

   OM22 | OM22      OM33 | TH 1      OM33 | TH 2      OM33 | TH 3      OM33 | TH 4      OM33 | TH 5      OM33 | TH 6    
     5.59E+03         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM33 | OM11      OM33 | OM22      OM33 | OM33      OM44 | TH 1      OM44 | TH 2      OM44 | TH 3      OM44 | TH 4    
     4.44E+00         2.05E+02         2.96E+04         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM44 | TH 5      OM44 | TH 6      OM44 | OM11      OM44 | OM22      OM44 | OM33      OM44 | OM44      OM55 | TH 1    
     0.00E+00         0.00E+00         2.39E-04         1.68E-02         7.00E-01         7.18E+02         0.00E+00

   OM55 | TH 2      OM55 | TH 3      OM55 | TH 4      OM55 | TH 5      OM55 | TH 6      OM55 | OM11      OM55 | OM22    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         7.05E+00         1.13E+03

   OM55 | OM33      OM55 | OM44      OM55 | OM55      OM66 | TH 1      OM66 | TH 2      OM66 | TH 3      OM66 | TH 4    
     3.94E+03         1.54E+00         4.28E+04         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   OM66 | TH 5      OM66 | TH 6      OM66 | OM11      OM66 | OM22      OM66 | OM33      OM66 | OM44      OM66 | OM55    
     0.00E+00         0.00E+00         3.31E-03         2.56E+00         9.74E+01         1.55E-01         2.31E+02

   OM66 | OM66      SG11 | TH 1      SG11 | TH 2      SG11 | TH 3      SG11 | TH 4      SG11 | TH 5      SG11 | TH 6    
     9.86E+04         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00

   SG11 | OM11      SG11 | OM22      SG11 | OM33      SG11 | OM44      SG11 | OM55      SG11 | OM66      SG11 | SG11    
     6.02E+01         2.52E+02         4.61E+03         7.55E-01         7.60E+03         1.14E+02         3.71E+04

   SG22 | TH 1      SG22 | TH 2      SG22 | TH 3      SG22 | TH 4      SG22 | TH 5      SG22 | TH 6      SG22 | OM11    
     0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         0.00E+00         4.41E+02

   SG22 | OM22      SG22 | OM33      SG22 | OM44      SG22 | OM55      SG22 | OM66      SG22 | SG11      SG22 | SG22      
     2.40E+01         1.35E+04         6.67E+01         2.49E+02         8.94E+03         4.02E+04         1.32E+06
 Elapsed finaloutput time in seconds:     0.18
 #CPUT: Total CPU Time in Seconds,        0.375
Stop Time: 
Mon 02/22/2021 
04:25 PM
