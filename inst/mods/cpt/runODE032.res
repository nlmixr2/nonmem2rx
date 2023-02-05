Run Start Date:  29/08/2019 
Run Start Time: 16:40:01.41 
Run Stop Date:   29/08/2019 
Run Stop Time:  16:41:51.15 
  
************************************************************************************************************************ 
********************                            CONTROL STREAM                                      ******************** 
************************************************************************************************************************ 
  
$PROB    BOLUS_2CPT_CLV1QV2 SINGLE DOSE FOCEI (120 Ind/2280 Obs) runODE032
$INPUT   ID TIME DV LNDV MDV AMT EVID DOSE V1I CLI QI V2I SSX IIX SD CMT
$DATA    BOLUS_2CPT.csv IGNORE=@ IGNORE (SD.EQ.0)
$SUBR    ADVAN13 TOL=6
$MODEL
         COMP=(CENTRAL,DEFOBS,DEFDOSE)
         COMP=(PERI)
$PK
         CL=EXP(THETA(1)+ETA(1))
         V=EXP(THETA(2)+ETA(2))
         Q=EXP(THETA(3)+ETA(3))
         V2=EXP(THETA(4)+ETA(4))
         V1=V
         S1=V
		 K21=Q/V2
		 K12=Q/V
$DES
         DADT(1)= K21*A(2)-K12*A(1)-CL*A(1)/V1
         DADT(2)=-K21*A(2)+K12*A(1)  		 
$ERROR   
         IPRED = F     
         RESCV = THETA(5) 
         W     = IPRED*RESCV
         IRES  = DV-IPRED
         IWRES = IRES/W
         Y     = IPRED+W*EPS(1)
$THETA   1.6       ;log Cl
$THETA   4.5       ;log Vc
$THETA   1.6       ;log Q
$THETA   4         ;log Vp
$THETA   (0,0.3,1) ;RSV
$OMEGA   0.15 0.15 0.15 0.15
$SIGMA   1 FIX
$EST     NSIG=2 SIGL=6 PRINT=5 MAX=9999 NOABORT POSTHOC METHOD=COND INTER NOOBT
$COV
$TABLE  ID TIME LNDV MDV AMT EVID DOSE V1I CLI QI V2I CL V Q V2 ETA1 ETA2 ETA3 ETA4
        IPRED IRES IWRES CWRESI
        ONEHEADER NOPRINT FILE=runODE032.csv   
   
************************************************************************************************************************ 
********************                            SYSTEM INFORMATION                                  ******************** 
************************************************************************************************************************ 
   
Operating system: 

Microsoft Windows [Version 10.0.18362.295]
   
Compiler: Intel(R) Parallel Studio XE 2015 Update 3 Composer Edition (package 208)  
   
Compiler settings: /Gs /nologo /nbs /w /fp:strict   
   
************************************************************************************************************************ 
********************                            NMTRAN MESSAGES                                     ******************** 
************************************************************************************************************************ 
   
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
   
************************************************************************************************************************ 
********************                            NONMEM EXECUTION                                    ******************** 
************************************************************************************************************************ 
   
License Registered to: Occams Cooperatie U.A
Expiration Date:    14 JUN 2020
Current Date:       29 AUG 2019
Days until program expires : 290
1NONLINEAR MIXED EFFECTS MODEL PROGRAM (NONMEM) VERSION 7.4.3
 ORIGINALLY DEVELOPED BY STUART BEAL, LEWIS SHEINER, AND ALISON BOECKMANN
 CURRENT DEVELOPERS ARE ROBERT BAUER, ICON DEVELOPMENT SOLUTIONS,
 AND ALISON BOECKMANN. IMPLEMENTATION, EFFICIENCY, AND STANDARDIZATION
 PERFORMED BY NOUS INFOSYSTEMS.

 PROBLEM NO.:         1
 BOLUS_2CPT_CLV1QV2 SINGLE DOSE FOCEI (120 Ind/2280 Obs) runODE032
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:     2400
 NO. OF DATA ITEMS IN DATA SET:  16
 ID DATA ITEM IS DATA ITEM NO.:   1
 DEP VARIABLE IS DATA ITEM NO.:   3
 MDV DATA ITEM IS DATA ITEM NO.:  5
0INDICES PASSED TO SUBROUTINE PRED:
   7   2   6   0   0   0  16   0   0   0   0
0LABELS FOR DATA ITEMS:
 ID TIME DV LNDV MDV AMT EVID DOSE V1I CLI QI V2I SSX IIX SD CMT
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 CL V Q V2 IPRED IRES IWRES
0FORMAT FOR DATA:
 (E4.0,3E7.0,E2.0,E7.0,E2.0,E7.0,E6.0,2E5.0,E6.0,2E3.0,2E2.0)

 TOT. NO. OF OBS RECS:     2280
 TOT. NO. OF INDIVIDUALS:      120
0LENGTH OF THETA:   5
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   4
0DEFAULT OMEGA BOUNDARY TEST OMITTED:   YES
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   1
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
 LOWER BOUND    INITIAL EST    UPPER BOUND
 -0.1000E+07     0.1600E+01     0.1000E+07
 -0.1000E+07     0.4500E+01     0.1000E+07
 -0.1000E+07     0.1600E+01     0.1000E+07
 -0.1000E+07     0.4000E+01     0.1000E+07
  0.0000E+00     0.3000E+00     0.1000E+01
0INITIAL ESTIMATE OF OMEGA:
 0.1500E+00
 0.0000E+00   0.1500E+00
 0.0000E+00   0.0000E+00   0.1500E+00
 0.0000E+00   0.0000E+00   0.0000E+00   0.1500E+00
0INITIAL ESTIMATE OF SIGMA:
 0.1000E+01
0SIGMA CONSTRAINED TO BE THIS INITIAL ESTIMATE
0COVARIANCE STEP OMITTED:        NO
 EIGENVLS. PRINTED:              NO
 SPECIAL COMPUTATION:            NO
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
04 COLUMNS APPENDED:    YES
 PRINTED:                NO
 HEADERS:               ONE
 FILE TO BE FORWARDED:   NO
 FORMAT:                S1PE11.4
 LFORMAT:
 RFORMAT:
 FIXED_EFFECT_ETAS:
0USER-CHOSEN ITEMS:
 ID TIME LNDV MDV AMT EVID DOSE V1I CLI QI V2I CL V Q V2 ETA1 ETA2 ETA3 ETA4 IPRED IRES IWRES CWRESI
1DOUBLE PRECISION PREDPP VERSION 7.4.3

 GENERAL NONLINEAR KINETICS MODEL WITH STIFF/NONSTIFF EQUATIONS (LSODA, ADVAN13)
0MODEL SUBROUTINE USER-SUPPLIED - ID NO. 9999
0MAXIMUM NO. OF BASIC PK PARAMETERS:   4
0COMPARTMENT ATTRIBUTES
 COMPT. NO.   FUNCTION   INITIAL    ON/OFF      DOSE      DEFAULT    DEFAULT
                         STATUS     ALLOWED    ALLOWED    FOR DOSE   FOR OBS.
    1         CENTRAL      ON         YES        YES        YES        YES
    2         PERI         ON         YES        YES        NO         NO
    3         OUTPUT       OFF        YES        NO         NO         NO
 INITIAL (BASE) TOLERANCE SETTINGS:
 NRD (RELATIVE) VALUE(S) OF TOLERANCE:   6
 ANRD (ABSOLUTE) VALUE(S) OF TOLERANCE:  12
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
   EVENT ID DATA ITEM IS DATA ITEM NO.:      7
   TIME DATA ITEM IS DATA ITEM NO.:          2
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   6
   COMPT. NO. DATA ITEM IS DATA ITEM NO.:   16

0PK SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 PK SUBROUTINE NOT CALLED AT NONEVENT (ADDITIONAL OR LAGGED) DOSE TIMES.
0ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
0DES SUBROUTINE USES COMPACT STORAGE MODE.
1
 
 
 #TBLN:      1
 #METH: First Order Conditional Estimation with Interaction
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               NOSLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    NO
 NO. OF FUNCT. EVALS. ALLOWED:            9999
 NO. OF SIG. FIGURES REQUIRED:            2
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
 ABORT WITH PRED EXIT CODE 1:             NO
 IND. OBJ. FUNC. VALUES SORTED:           NO
 NUMERICAL DERIVATIVE
       FILE REQUEST (NUMDER):               NONE
 MAP (ETAHAT) ESTIMATION METHOD (OPTMAP):   0
 ETA HESSIAN EVALUATION METHOD (ETADER):    0
 INITIAL ETA FOR MAP ESTIMATION (MCETA):    0
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      6
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     6
 NOPRIOR SETTING (NOPRIOR):                 OFF
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): runODE032.ext
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
 
 MONITORING OF SEARCH:

 
0ITERATION NO.:    0    OBJECTIVE VALUE:   20783.3929181773        NO. OF FUNC. EVALS.:   7
 CUMULATIVE NO. OF FUNC. EVALS.:        7
 NPARAMETR:  1.6000E+00  4.5000E+00  1.6000E+00  4.0000E+00  3.0000E-01  1.5000E-01  1.5000E-01  1.5000E-01  1.5000E-01
 PARAMETER:  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01
 GRADIENT:   5.1063E+03  2.0352E+04  1.8672E+03  3.1085E+03  1.3181E+03  2.8368E+01 -1.7751E+01  1.3305E+01  6.0639E+01
 
0ITERATION NO.:    5    OBJECTIVE VALUE:   20652.1934245269        NO. OF FUNC. EVALS.:  51
 CUMULATIVE NO. OF FUNC. EVALS.:       58
 NPARAMETR:  1.3270E+00  4.2920E+00  1.1060E+00  3.8526E+00  2.9099E-01  1.4950E-01  1.4929E-01  1.4979E-01  1.4941E-01
 PARAMETER:  8.2936E-02  9.5377E-02  6.9124E-02  9.6314E-02  5.6715E-02  9.8322E-02  9.7619E-02  9.9316E-02  9.8018E-02
 GRADIENT:  -1.0221E+03  4.3607E+03 -1.5969E+03 -8.4636E+02  1.3708E+03  6.5528E+01  7.7815E+01  2.9356E+01  4.4667E+01
 
0ITERATION NO.:   10    OBJECTIVE VALUE:   20194.3797986446        NO. OF FUNC. EVALS.:  42
 CUMULATIVE NO. OF FUNC. EVALS.:      100
 NPARAMETR:  1.2761E+00  4.1570E+00  1.3116E+00  3.8698E+00  1.8883E-01  1.0911E-01  1.0264E-01  3.2758E-02  1.0874E-01
 PARAMETER:  7.9759E-02  9.2378E-02  8.1976E-02  9.6745E-02 -5.1031E-01 -5.9125E-02 -8.9693E-02 -6.6074E-01 -6.0855E-02
 GRADIENT:  -1.4217E+03  1.0549E+03 -3.2133E+02  6.4146E+02 -2.5210E+02 -2.7575E+00  9.9692E-01 -2.0038E+01  1.5949E+01
 
0ITERATION NO.:   15    OBJECTIVE VALUE:   20172.5924602994        NO. OF FUNC. EVALS.:  40
 CUMULATIVE NO. OF FUNC. EVALS.:      140
 NPARAMETR:  1.3296E+00  4.1458E+00  1.3821E+00  3.8718E+00  1.9593E-01  1.0315E-01  1.0239E-01  1.0264E-01  7.2680E-02
 PARAMETER:  8.3101E-02  9.2130E-02  8.6383E-02  9.6794E-02 -4.6461E-01 -8.7209E-02 -9.0917E-02 -8.9686E-02 -2.6228E-01
 GRADIENT:   2.7265E+00 -3.8175E+00 -2.1538E+00 -2.1094E+00 -1.0385E-01 -6.1260E-02 -1.6872E-04  7.5619E-02  1.2781E-02
 
0ITERATION NO.:   20    OBJECTIVE VALUE:   20167.6693234483        NO. OF FUNC. EVALS.:  92
 CUMULATIVE NO. OF FUNC. EVALS.:      232
 NPARAMETR:  1.3736E+00  4.1950E+00  1.3810E+00  3.8767E+00  1.9632E-01  1.0190E-01  9.9574E-02  1.0198E-01  7.3151E-02
 PARAMETER:  8.5852E-02  9.3223E-02  8.6313E-02  9.6918E-02 -4.6214E-01 -9.3338E-02 -1.0487E-01 -9.2944E-02 -2.5905E-01
 GRADIENT:   1.5759E+03  4.8603E+03  5.5384E+01  5.6523E+02 -2.4288E+00  1.2105E+00  4.2693E-01  1.4010E-01  7.6500E-02
 
0ITERATION NO.:   25    OBJECTIVE VALUE:   20167.6410936279        NO. OF FUNC. EVALS.:  88
 CUMULATIVE NO. OF FUNC. EVALS.:      320
 NPARAMETR:  1.3703E+00  4.1981E+00  1.3800E+00  3.8766E+00  1.9645E-01  1.0125E-01  9.9387E-02  1.0130E-01  7.3050E-02
 PARAMETER:  8.5646E-02  9.3292E-02  8.6252E-02  9.6914E-02 -4.6136E-01 -9.6514E-02 -1.0581E-01 -9.6261E-02 -2.5975E-01
 GRADIENT:   5.6005E+02  1.6940E+03  1.3095E+01 -1.1500E+02 -5.0779E-01 -2.4180E-01  7.6566E-02 -2.8228E-02 -1.1727E-01
 
 #TERM:
0MINIMIZATION SUCCESSFUL
 NO. OF FUNCTION EVALUATIONS USED:      320
 NO. OF SIG. DIGITS IN FINAL EST.:  2.5

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:         3.3330E-03 -5.8764E-03  1.1658E-02 -3.0329E-03
 SE:             2.8366E-02  2.7952E-02  1.7215E-02  1.7598E-02
 N:                     120         120         120         120
 
 P VAL.:         9.0646E-01  8.3349E-01  4.9829E-01  8.6317E-01
 
 ETASHRINKSD(%)  1.9353E+00  2.4648E+00  4.0500E+01  2.8374E+01
 ETASHRINKVR(%)  3.8332E+00  4.8688E+00  6.4598E+01  4.8697E+01
 EBVSHRINKSD(%)  1.8422E+00  3.1298E+00  4.0410E+01  2.8268E+01
 EBVSHRINKVR(%)  3.6504E+00  6.1616E+00  6.4490E+01  4.8545E+01
 EPSSHRINKSD(%)  6.9857E+00
 EPSSHRINKVR(%)  1.3483E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2280
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    4190.35971141331     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    20167.6410936279     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       24358.0008050412     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           480
  
 #TERE:
 Elapsed estimation  time in seconds:    71.95
 Elapsed covariance  time in seconds:    28.38
 Elapsed postprocess time in seconds:     0.43
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 #OBJT:**************                       MINIMUM VALUE OF OBJECTIVE FUNCTION                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************    20167.641       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.37E+00  4.20E+00  1.38E+00  3.88E+00  1.96E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        1.01E-01
 
 ETA2
+        0.00E+00  9.94E-02
 
 ETA3
+        0.00E+00  0.00E+00  1.01E-01
 
 ETA4
+        0.00E+00  0.00E+00  0.00E+00  7.30E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        1.00E+00
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        3.18E-01
 
 ETA2
+        0.00E+00  3.15E-01
 
 ETA3
+        0.00E+00  0.00E+00  3.18E-01
 
 ETA4
+        0.00E+00  0.00E+00  0.00E+00  2.70E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.00E+00
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                            STANDARD ERROR OF ESTIMATE                          ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         2.98E-02  2.95E-02  5.47E-02  3.48E-02  3.15E-03
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        1.30E-02
 
 ETA2
+       .........  1.23E-02
 
 ETA3
+       ......... .........  3.10E-02
 
 ETA4
+       ......... ......... .........  2.26E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+       .........
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        2.04E-02
 
 ETA2
+       .........  1.95E-02
 
 ETA3
+       ......... .........  4.86E-02
 
 ETA4
+       ......... ......... .........  4.18E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+       .........
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                          COVARIANCE MATRIX OF ESTIMATE                         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        8.88E-04
 
 TH 2
+       -1.06E-04  8.71E-04
 
 TH 3
+        1.84E-04 -1.06E-04  2.99E-03
 
 TH 4
+       -1.20E-04 -5.07E-05  1.65E-04  1.21E-03
 
 TH 5
+        5.28E-08 -1.57E-05  5.99E-06 -2.54E-05  9.94E-06
 
 OM11
+       -4.71E-05  4.70E-05 -3.64E-05  2.55E-05 -8.17E-06  1.69E-04
 
 OM12
+       ......... ......... ......... ......... ......... ......... .........
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+       -7.37E-05  2.57E-05 -8.08E-05  1.37E-05 -4.37E-06  8.75E-06 ......... ......... .........  1.51E-04
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+        6.63E-05 -8.19E-05  5.49E-04  1.68E-04  1.59E-06  3.49E-05 ......... ......... .........  4.32E-07 ......... .........
          9.59E-04
 
 OM34
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... .........
 
 OM44
+       -9.50E-06  1.10E-04 -3.07E-04 -9.13E-05  3.19E-06  1.37E-05 ......... ......... ......... -1.95E-05 ......... .........
         -1.30E-04 .........  5.10E-04
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... .........
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                          CORRELATION MATRIX OF ESTIMATE                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        2.98E-02
 
 TH 2
+       -1.20E-01  2.95E-02
 
 TH 3
+        1.13E-01 -6.58E-02  5.47E-02
 
 TH 4
+       -1.16E-01 -4.93E-02  8.67E-02  3.48E-02
 
 TH 5
+        5.62E-04 -1.68E-01  3.47E-02 -2.31E-01  3.15E-03
 
 OM11
+       -1.22E-01  1.22E-01 -5.12E-02  5.62E-02 -1.99E-01  1.30E-02
 
 OM12
+       ......... ......... ......... ......... ......... ......... .........
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+       -2.01E-01  7.07E-02 -1.20E-01  3.20E-02 -1.13E-01  5.47E-02 ......... ......... .........  1.23E-02
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+        7.19E-02 -8.96E-02  3.24E-01  1.56E-01  1.63E-02  8.65E-02 ......... ......... .........  1.13E-03 ......... .........
          3.10E-02
 
 OM34
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... .........
 
 OM44
+       -1.41E-02  1.65E-01 -2.48E-01 -1.16E-01  4.48E-02  4.65E-02 ......... ......... ......... -7.02E-02 ......... .........
         -1.86E-01 .........  2.26E-02
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... .........
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                      INVERSE COVARIANCE MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM14      OM22      OM23      OM24  
             OM33      OM34      OM44      SG11  
 
 TH 1
+        1.24E+03
 
 TH 2
+        1.36E+02  1.26E+03
 
 TH 3
+       -4.99E+01 -1.66E+01  4.02E+02
 
 TH 4
+        1.58E+02  8.93E+01 -2.64E+01  9.26E+02
 
 TH 5
+        1.17E+03  2.06E+03 -2.03E+02  2.55E+03  1.16E+05
 
 OM11
+        3.23E+02 -2.14E+02  8.58E+01  1.81E+01  5.03E+03  6.40E+03
 
 OM12
+       ......... ......... ......... ......... ......... ......... .........
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        5.54E+02 -1.26E+02  2.11E+02  4.75E+01  2.82E+03 -1.07E+01 ......... ......... .........  7.14E+03
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+       -9.10E+01  6.12E+01 -2.00E+02 -1.45E+02 -7.54E+02 -3.60E+02 ......... ......... ......... -1.32E+02 ......... .........
          1.23E+03
 
 OM34
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... .........
 
 OM44
+       -2.58E+01 -2.59E+02  1.96E+02  8.21E+01 -1.03E+03 -1.88E+02 ......... ......... .........  3.95E+02 ......... .........
          1.61E+02 .........  2.22E+03
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
         ......... ......... ......... .........
 
 Elapsed finaloutput time in seconds:     0.19
 #CPUT: Total CPU Time in Seconds,      101.438
