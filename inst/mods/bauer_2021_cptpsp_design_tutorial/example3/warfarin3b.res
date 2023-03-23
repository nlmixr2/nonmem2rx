Sat 08/07/2021 
02:03 AM
$PROBLEM WARFARIN
$INPUT ID TIME AMT RATE EVID MDV DV TSTRAT TMIN TMAX
$DATA warfarin3b.csv ignore=C

$SUBROUTINES ADVAN2 TRANS2

$PK
MU_1=LOG(THETA(1))
MU_2=LOG(THETA(2))
MU_3=LOG(THETA(3))
CL=EXP(MU_1+ETA(1))
V=EXP(MU_2+ETA(2))
KA=EXP(MU_3+ETA(3))
S2=V
F1=1.0

$ERROR
IPRED=A(2)/V
Y=IPRED + IPRED*EPS(1) + EPS(2)

$THETA
0.15 ;[CL]
8.0  ;[V]
1.0  ;[KA]

$OMEGA (0.07) (0.02) (0.6)
$SIGMA 0.01 (0.001 FIXED)

$DESIGN GROUPSIZE=32 FIMDIAG=1 


$TABLE ID TIME TSTRAT TMIN TMAX EVID MDV IPRED NOAPPEND NOPRINT FILE=warfarin3b.tab
  
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
 WARFARIN
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:        6
 NO. OF DATA ITEMS IN DATA SET:  10
 ID DATA ITEM IS DATA ITEM NO.:   1
 DEP VARIABLE IS DATA ITEM NO.:   7
 MDV DATA ITEM IS DATA ITEM NO.:  6
0INDICES PASSED TO SUBROUTINE PRED:
   5   2   3   4   0   0   0   0   0   0   0
0LABELS FOR DATA ITEMS:
 ID TIME AMT RATE EVID MDV DV TSTRAT TMIN TMAX
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 IPRED
0FORMAT FOR DATA:
 (10E6.0)

 TOT. NO. OF OBS RECS:        5
 TOT. NO. OF INDIVIDUALS:        1
0LENGTH OF THETA:   3
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   3
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS BLOCK FORM:
  1
  0  2
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
   0.1500E+00  0.8000E+01  0.1000E+01
0INITIAL ESTIMATE OF OMEGA:
 0.7000E-01
 0.0000E+00   0.2000E-01
 0.0000E+00   0.0000E+00   0.6000E+00
0INITIAL ESTIMATE OF SIGMA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.1000E-01
        2                                                                                  YES
                  0.1000E-02
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
 ID TIME TSTRAT TMIN TMAX EVID MDV IPRED
1DOUBLE PRECISION PREDPP VERSION 7.5.0

 ONE COMPARTMENT MODEL WITH FIRST-ORDER ABSORPTION (ADVAN2)
0MAXIMUM NO. OF BASIC PK PARAMETERS:   3
0BASIC PK PARAMETERS (AFTER TRANSLATION):
   ELIMINATION RATE (K) IS BASIC PK PARAMETER NO.:  1
   ABSORPTION RATE (KA) IS BASIC PK PARAMETER NO.:  3

 TRANSLATOR WILL CONVERT PARAMETERS
 CLEARANCE (CL) AND VOLUME (V) TO K (TRANS2)
0COMPARTMENT ATTRIBUTES
 COMPT. NO.   FUNCTION   INITIAL    ON/OFF      DOSE      DEFAULT    DEFAULT
                         STATUS     ALLOWED    ALLOWED    FOR DOSE   FOR OBS.
    1         DEPOT        OFF        YES        YES        YES        NO
    2         CENTRAL      ON         NO         YES        NO         YES
    3         OUTPUT       OFF        YES        NO         NO         NO
1
 ADDITIONAL PK PARAMETERS - ASSIGNMENT OF ROWS IN GG
 COMPT. NO.                             INDICES
              SCALE      BIOAVAIL.   ZERO-ORDER  ZERO-ORDER  ABSORB
                         FRACTION    RATE        DURATION    LAG
    1            *           5           *           *           *
    2            4           *           *           *           *
    3            *           -           -           -           -
             - PARAMETER IS NOT ALLOWED FOR THIS MODEL
             * PARAMETER IS NOT SUPPLIED BY PK SUBROUTINE;
               WILL DEFAULT TO ONE IF APPLICABLE
0DATA ITEM INDICES USED BY PRED ARE:
   EVENT ID DATA ITEM IS DATA ITEM NO.:      5
   TIME DATA ITEM IS DATA ITEM NO.:          2
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   3
   DOSE RATE DATA ITEM IS DATA ITEM NO.:     4

0PK SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 PK SUBROUTINE NOT CALLED AT NONEVENT (ADDITIONAL OR LAGGED) DOSE TIMES.
0ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
0ERROR SUBROUTINE INDICATES THAT DERIVATIVES OF COMPARTMENT AMOUNTS ARE USED.
1
 
 
 #TBLN:      1
 #METH: First Order (Evaluation): D-OPTIMALITY
 
 ESTIMATION STEP OMITTED:                 YES
 ANALYSIS TYPE:                           POPULATION
 POP. ETAS OBTAINED POST HOC:             YES
 DESIGN TYPE: D-OPTIMALITY, -LOG(DET(FIM))
 SIMULATE OBSERVED DATA FOR DESIGN:  NO
 BLOCK DIAGONALIZATION TYPE FOR DESIGN:  1
 STANDARD NONMEM RESIDUAL VARIANCE MODELING (VAR_CROSS=0)
 DESIGN GROUPSIZE=  3.2000000000000000E+01
 OPTIMALITY RANDOM GENERATION SEED: 11456
 
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
 
 ETABAR:         0.0000E+00  0.0000E+00  0.0000E+00
 SE:             0.0000E+00  0.0000E+00  0.0000E+00
 N:                       1           1           1
 
 P VAL.:         1.0000E+00  1.0000E+00  1.0000E+00
 
 ETASHRINKSD(%)  1.0000E+02  1.0000E+02  1.0000E+02
 ETASHRINKVR(%)  1.0000E+02  1.0000E+02  1.0000E+02
 EBVSHRINKSD(%)  1.9159E+00  7.9278E+00  1.2956E+00
 EBVSHRINKVR(%)  3.7950E+00  1.5227E+01  2.5745E+00
 RELATIVEINF(%)  9.5927E+01  8.4443E+01  9.7307E+01
 EPSSHRINKSD(%)  3.6754E+01  3.6754E+01
 EPSSHRINKVR(%)  6.0000E+01  6.0000E+01
 
 #TERE:
 Elapsed opt. design time in seconds:     0.01
 Elapsed postprocess time in seconds:     0.00
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                      FIRST ORDER (EVALUATION): D-OPTIMALITY                    ********************
 #OBJT:**************                MINIMUM VALUE OF OBJECTIVE FUNCTION: D-OPTIMALITY               ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************      -51.567       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                      FIRST ORDER (EVALUATION): D-OPTIMALITY                    ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3     
 
         1.50E-01  8.00E+00  1.00E+00
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        7.00E-02
 
 ETA2
+        0.00E+00  2.00E-02
 
 ETA3
+        0.00E+00  0.00E+00  6.00E-01
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1      EPS2     
 
 EPS1
+        1.00E-02
 
 EPS2
+        0.00E+00  1.00E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        2.65E-01
 
 ETA2
+        0.00E+00  1.41E-01
 
 ETA3
+        0.00E+00  0.00E+00  7.75E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1      EPS2     
 
 EPS1
+        1.00E-01
 
 EPS2
+        0.00E+00  3.16E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                      FIRST ORDER (EVALUATION): D-OPTIMALITY                    ********************
 ********************                            STANDARD ERROR OF ESTIMATE                          ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3     
 
         7.17E-03  2.18E-01  1.39E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        1.82E-02
 
 ETA2
+       .........  5.95E-03
 
 ETA3
+       ......... .........  1.54E-01
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1      EPS2     
 
 EPS1
+        1.77E-03
 
 EPS2
+       ......... .........
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        3.44E-02
 
 ETA2
+       .........  2.10E-02
 
 ETA3
+       ......... .........  9.94E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1      EPS2     
 
 EPS1
+        8.84E-03
 
 EPS2
+       ......... .........
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                      FIRST ORDER (EVALUATION): D-OPTIMALITY                    ********************
 ********************                          COVARIANCE MATRIX OF ESTIMATE                         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

     TH 1 | TH 1      TH 2 | TH 1      TH 2 | TH 2      TH 3 | TH 1      TH 3 | TH 2      TH 3 | TH 3    OM11 | TH 1    
     5.13E-05         8.42E-05         4.75E-02         1.12E-05         1.04E-03         1.93E-02         0.00E+00

   OM11 | TH 2      OM11 | TH 3      OM11 | OM11      OM22 | TH 1      OM22 | TH 2      OM22 | TH 3      OM22 | OM11    
     0.00E+00         0.00E+00         3.31E-04         0.00E+00         0.00E+00         0.00E+00        -7.61E-08

   OM22 | OM22      OM33 | TH 1      OM33 | TH 2      OM33 | TH 3      OM33 | OM11      OM33 | OM22      OM33 | OM33    
     3.54E-05         0.00E+00         0.00E+00         0.00E+00         7.00E-07         5.58E-07         2.37E-02

   SG11 | TH 1      SG11 | TH 2      SG11 | TH 3      SG11 | OM11      SG11 | OM22      SG11 | OM33      SG11 | SG11      
     0.00E+00         0.00E+00         0.00E+00        -6.56E-07        -1.11E-06        -4.49E-06         3.13E-06
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                      FIRST ORDER (EVALUATION): D-OPTIMALITY                    ********************
 ********************                          CORRELATION MATRIX OF ESTIMATE                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

     TH 1 | TH 1      TH 2 | TH 1      TH 2 | TH 2      TH 3 | TH 1      TH 3 | TH 2      TH 3 | TH 3    OM11 | TH 1    
     7.17E-03         5.39E-02         2.18E-01         1.13E-02         3.42E-02         1.39E-01         0.00E+00

   OM11 | TH 2      OM11 | TH 3      OM11 | OM11      OM22 | TH 1      OM22 | TH 2      OM22 | TH 3      OM22 | OM11    
     0.00E+00         0.00E+00         1.82E-02         0.00E+00         0.00E+00         0.00E+00        -7.02E-04

   OM22 | OM22      OM33 | TH 1      OM33 | TH 2      OM33 | TH 3      OM33 | OM11      OM33 | OM22      OM33 | OM33    
     5.95E-03         0.00E+00         0.00E+00         0.00E+00         2.50E-04         6.09E-04         1.54E-01

   SG11 | TH 1      SG11 | TH 2      SG11 | TH 3      SG11 | OM11      SG11 | OM22      SG11 | OM33      SG11 | SG11      
     0.00E+00         0.00E+00         0.00E+00        -2.04E-02        -1.05E-01        -1.65E-02         1.77E-03
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                      FIRST ORDER (EVALUATION): D-OPTIMALITY                    ********************
 ********************                      INVERSE COVARIANCE MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

     TH 1 | TH 1      TH 2 | TH 1      TH 2 | TH 2      TH 3 | TH 1      TH 3 | TH 2      TH 3 | TH 3    OM11 | TH 1    
     1.95E+04        -3.44E+01         2.11E+01        -9.54E+00        -1.12E+00         5.19E+01         0.00E+00

   OM11 | TH 2      OM11 | TH 3      OM11 | OM11      OM22 | TH 1      OM22 | TH 2      OM22 | TH 3      OM22 | OM11    
     0.00E+00         0.00E+00         3.02E+03         0.00E+00         0.00E+00         0.00E+00         2.66E+01

   OM22 | OM22      OM33 | TH 1      OM33 | TH 2      OM33 | TH 3      OM33 | OM11      OM33 | OM22      OM33 | OM33    
     2.86E+04         0.00E+00         0.00E+00         0.00E+00         3.20E-02         1.25E+00         4.21E+01

   SG11 | TH 1      SG11 | TH 2      SG11 | TH 3      SG11 | OM11      SG11 | OM22      SG11 | OM33      SG11 | SG11      
     0.00E+00         0.00E+00         0.00E+00         6.43E+02         1.01E+04         6.10E+01         3.24E+05
 Elapsed finaloutput time in seconds:     0.02
 #CPUT: Total CPU Time in Seconds,        0.078
Stop Time: 
Sat 08/07/2021 
02:03 AM
