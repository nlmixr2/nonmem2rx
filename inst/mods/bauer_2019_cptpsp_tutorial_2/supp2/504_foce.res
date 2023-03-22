Tue 03/12/2019 
10:08 AM
$PROB Phase IIa Study, One Compartment Model 504m.ctl
; Place column names of data file here:
$INPUT C ID TIME DV AMT RATE WT AGE SEX 
$DATA 501.csv IGNORE=C ; Ignore records beginning with letter C
; Select One compartment model ADVAN1, Parameterization TRANS2 (CL, V)
$SUBROUTINE ADVAN1 TRANS2 
; Section to define PK parameters, relationship to fixed effects THETA
; and inter-subject random effects ETA.
$PK 
; Define typical values
  LTVCL=THETA(1)+LOG(WT/70)*THETA(3)+LOG(AGE/50)*THETA(5)+SEX*THETA(7)
  LTVV=THETA(2)+LOG(WT/70)*THETA(4)+LOG(AGE/50)*THETA(6)+SEX*THETA(8)
  MU_1=LTVCL
  MU_2=LTVV
  CL=EXP(MU_1+ETA(1))
  V=EXP(MU_2+ETA(2))
  S1=V

$THETA ; Enter initial starting values for THETAS
  0.7    ;[LCL]
  3.0    ;[LV]
  0.8    ;[CL~WT]
  0.8    ;[V~WT]
  -0.1   ;[CL~AGE]
  0.1    ;[V~AGE]
  0.7    ;[CL~SEX]
  0.7    ;[V~SEX]

; Section to relate predicted function F and residual error
; relationship to data DV.  EPS are random error coefficients
$ERROR 
  IPRE=A(1)/V
  Y=IPRE*(1+EPS(1))
$OMEGA BLOCK(2) ; Initial OMEGA values in lower triangular format
  0.1         ;[P]
  0.001 0.1   ;[P]
$SIGMA ; Initial SIGMA
  0.04        ;[P]

$EST METHOD=COND INTERACTION MAXEVAL=9999 PRINT=5 NOABORT 
$COV UNCONDITIONAL MATRIX=R PRINT=E
; Print out individual predicted results 
; Various parameters and built in diagnostics may be printed.
; DV=DEPENDENT VARIABLE
; CIPRED=individual predicted function, f(eta_hat), at mode of
; posterior density, because FOCE performs estimations at mode
; CIRES=DV-F(ETA_HAT)
; CIWRES=conditional individual residual
; (DV-F(ETA_HAT)/SQRT(SIGMA(1,1)*F(ETA_HAT))
; PRED=Population Predicted value F(ETA=0)
; CWRES=conditional Population weighted Residual
; Note numerical Format may be specified for table outputs
$TABLE ID TIME DV IPRE CIPRED CIRES CIWRES PRED RES CWRES CL V ETA1 ETA2
       NOPRINT NOAPPEND ONEHEADER FORMAT=,1PE13.6 FILE=504_foce.tab

  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.

 (MU_WARNING 26) DATA ITEM(S) USED IN DEFINITION OF MU_(S) SHOULD BE CONSTANT FOR INDIV. REC.:
  WT AGE SEX
  
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
 Phase IIa Study, One Compartment Model 504m.ctl
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
0LENGTH OF THETA:   8
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS BLOCK FORM:
  1
  1  1
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   1
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
   0.7000E+00  0.3000E+01  0.8000E+00  0.8000E+00 -0.1000E+00  0.1000E+00  0.7000E+00  0.7000E+00
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.1000E+00
                  0.1000E-02   0.1000E+00
0INITIAL ESTIMATE OF SIGMA:
 0.4000E-01
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
 ID TIME DV IPRE CIPRED CIRES CIWRES PRED RES CWRES CL V ETA1 ETA2
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
 RAW OUTPUT FILE (FILE): 504_foce.ext
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

 
0ITERATION NO.:    0    OBJECTIVE VALUE:   1251.46390432319        NO. OF FUNC. EVALS.:  11
 CUMULATIVE NO. OF FUNC. EVALS.:       11
 NPARAMETR:  7.0000E-01  3.0000E+00  8.0000E-01  8.0000E-01 -1.0000E-01  1.0000E-01  7.0000E-01  7.0000E-01  1.0000E-01  1.0000E-03
             1.0000E-01  4.0000E-02
 PARAMETER:  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01 -1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01
             1.0000E-01  1.0000E-01
 GRADIENT:   3.0489E+00 -4.3161E+03  1.8073E+02 -1.2308E+02  2.7425E+01 -4.4916E+00  1.4031E+03  6.6577E+02 -8.7819E+01 -1.1539E+01
            -8.1436E+01 -7.8847E+01
 
0ITERATION NO.:    5    OBJECTIVE VALUE:   1147.53151323152        NO. OF FUNC. EVALS.:  66
 CUMULATIVE NO. OF FUNC. EVALS.:       77
 NPARAMETR:  1.2002E+00  3.6950E+00  5.9111E-01  9.9712E-01 -1.0947E-01  1.0126E-01 -5.6755E-01 -4.0366E-01  1.0322E-01  1.0430E-03
             1.0288E-01  4.1617E-02
 PARAMETER:  1.7145E-01  1.2317E-01  7.3889E-02  1.2464E-01 -1.0947E-01  1.0126E-01 -8.1079E-02 -5.7666E-02  1.1586E-01  1.0265E-01
             1.1418E-01  1.1982E-01
 GRADIENT:  -8.3291E+02  1.3230E+03 -1.4039E+02 -1.1618E+02  4.0803E+01  3.5082E-01 -1.2431E+03 -4.8538E+02 -2.0118E+01 -3.2623E+00
             1.1639E+01 -3.4068E+01
 
0ITERATION NO.:   10    OBJECTIVE VALUE:   1131.20909782917        NO. OF FUNC. EVALS.:  63
 CUMULATIVE NO. OF FUNC. EVALS.:      140
 NPARAMETR:  1.1925E+00  3.7906E+00  6.9560E-01  1.2576E+00 -8.3702E-01  5.4261E-02 -4.1318E-01 -6.3487E-01  6.4855E-02  3.0604E-03
             1.3965E-01  5.0279E-02
 PARAMETER:  1.7035E-01  1.2635E-01  8.6950E-02  1.5720E-01 -8.3702E-01  5.4261E-02 -5.9025E-02 -9.0695E-02 -1.1651E-01  3.8002E-01
             2.6653E-01  2.1435E-01
 GRADIENT:  -3.8743E+02  1.0013E+03 -8.8716E+01 -6.5652E+01 -2.3675E+01  4.5694E+00 -8.7131E+02 -6.3889E+02  5.6155E+00 -2.7013E+00
             7.0663E+00  1.0501E+01
 
0ITERATION NO.:   15    OBJECTIVE VALUE:   1062.62480938451        NO. OF FUNC. EVALS.:  61
 CUMULATIVE NO. OF FUNC. EVALS.:      201
 NPARAMETR:  1.0800E+00  3.4709E+00  7.3933E-01  1.2795E+00 -5.2951E-01  1.2520E-01 -5.4804E-02 -4.7802E-02  4.3920E-02  1.3557E-02
             5.3251E-02  4.9532E-02
 PARAMETER:  1.5428E-01  1.1570E-01  9.2416E-02  1.5993E-01 -5.2951E-01  1.2520E-01 -7.8292E-03 -6.8289E-03 -3.1140E-01  2.0457E+00
            -2.5595E-01  2.0687E-01
 GRADIENT:   2.4409E+01 -6.8611E+01  6.2134E+01 -3.7281E+01 -4.1437E+00  1.0172E+01  2.1459E+02 -9.2007E+01  1.4425E+01  1.6131E+00
            -2.3758E+00  4.5858E+00
 
0ITERATION NO.:   20    OBJECTIVE VALUE:   1058.41591687709        NO. OF FUNC. EVALS.:  62
 CUMULATIVE NO. OF FUNC. EVALS.:      263
 NPARAMETR:  1.1028E+00  3.4628E+00  6.6663E-01  1.3369E+00 -5.3081E-01  5.1576E-02 -9.7980E-02 -4.3605E-02  3.0780E-02  1.2485E-03
             4.6165E-02  4.9968E-02
 PARAMETER:  1.5755E-01  1.1543E-01  8.3329E-02  1.6711E-01 -5.3081E-01  5.1576E-02 -1.3997E-02 -6.2293E-03 -4.8915E-01  2.2503E-01
            -2.8698E-01  2.1125E-01
 GRADIENT:  -9.6446E+00  3.8514E+00  2.7645E-01  1.8680E+00  1.0917E+00 -7.2998E-02 -4.1837E+00  2.0692E+00  1.6607E-01 -3.1171E-02
            -2.0664E-01 -5.4672E-02
 
0ITERATION NO.:   25    OBJECTIVE VALUE:   1058.30593899783        NO. OF FUNC. EVALS.: 111
 CUMULATIVE NO. OF FUNC. EVALS.:      374
 NPARAMETR:  1.1088E+00  3.4772E+00  6.6094E-01  1.3248E+00 -5.3472E-01  5.2639E-02 -1.0122E-01 -5.3855E-02  3.0516E-02  1.6364E-03
             4.6936E-02  5.0243E-02
 PARAMETER:  1.5841E-01  1.1591E-01  8.2617E-02  1.6559E-01 -5.3472E-01  5.2639E-02 -1.4461E-02 -7.6936E-03 -4.9346E-01  2.9623E-01
            -2.7908E-01  2.1400E-01
 GRADIENT:  -2.1550E+00  7.9834E+00  2.7213E-01  1.7281E+00 -7.6259E-02  5.4688E-02 -1.5717E+00  4.4098E+00 -3.7984E-01  3.0643E-02
             2.8775E-01 -1.1807E-01
 
0ITERATION NO.:   30    OBJECTIVE VALUE:   1058.30371167602        NO. OF FUNC. EVALS.: 130
 CUMULATIVE NO. OF FUNC. EVALS.:      504
 NPARAMETR:  1.1090E+00  3.4777E+00  6.5976E-01  1.3215E+00 -5.3404E-01  5.2291E-02 -1.0106E-01 -5.4776E-02  3.0724E-02  1.4787E-03
             4.6610E-02  5.0258E-02
 PARAMETER:  1.5843E-01  1.1592E-01  8.2470E-02  1.6519E-01 -5.3404E-01  5.2291E-02 -1.4437E-02 -7.8251E-03 -4.9007E-01  2.6678E-01
            -2.8240E-01  2.1414E-01
 GRADIENT:  -7.1694E-02 -2.9947E-01 -7.6843E-03  5.2073E-03  1.4272E-03 -1.8813E-03 -7.0522E-02 -1.0376E-01  1.9846E-03  2.6300E-05
            -1.1254E-03  3.9706E-03
 
 #TERM:
0MINIMIZATION SUCCESSFUL
 NO. OF FUNCTION EVALUATIONS USED:      504
 NO. OF SIG. DIGITS IN FINAL EST.:  3.7

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:         4.1243E-03 -9.3904E-03
 SE:             1.8818E-02  2.2907E-02
 N:                      60          60
 
 P VAL.:         8.2651E-01  6.8186E-01
 
 ETASHRINKSD(%)  1.6140E+01  1.7118E+01
 ETASHRINKVR(%)  2.9675E+01  3.1306E+01
 EBVSHRINKSD(%)  1.7123E+01  1.7497E+01
 EBVSHRINKVR(%)  3.1314E+01  3.1933E+01
 EPSSHRINKSD(%)  1.7013E+01
 EPSSHRINKVR(%)  3.1132E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):          240
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    441.090495938243     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    1058.30371167602     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       1499.39420761427     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           120
  
 #TERE:
 Elapsed estimation  time in seconds:     1.53
 Elapsed covariance  time in seconds:     1.41
 Elapsed postprocess time in seconds:     0.02
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 #OBJT:**************                       MINIMUM VALUE OF OBJECTIVE FUNCTION                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************     1058.304       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         1.11E+00  3.48E+00  6.60E-01  1.32E+00 -5.34E-01  5.23E-02 -1.01E-01 -5.48E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        3.07E-02
 
 ETA2
+        1.48E-03  4.66E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        5.03E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        1.75E-01
 
 ETA2
+        3.91E-02  2.16E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.24E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                            STANDARD ERROR OF ESTIMATE                          ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         3.83E-02  4.87E-02  1.60E-01  2.02E-01  1.03E-01  1.29E-01  5.68E-02  7.13E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2     
 
 ETA1
+        9.16E-03
 
 ETA2
+        7.59E-03  1.39E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        6.76E-03
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2     
 
 ETA1
+        2.61E-02
 
 ETA2
+        1.99E-01  3.21E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.51E-02
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                          COVARIANCE MATRIX OF ESTIMATE                         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        1.47E-03
 
 TH 2
+        2.96E-04  2.38E-03
 
 TH 3
+       -9.16E-04 -3.49E-04  2.56E-02
 
 TH 4
+       -3.42E-04 -1.73E-03  4.29E-03  4.07E-02
 
 TH 5
+        1.12E-04 -7.55E-05 -1.29E-03 -3.59E-04  1.06E-02
 
 TH 6
+       -5.35E-05  1.04E-04 -4.06E-04 -2.65E-03  2.27E-03  1.68E-02
 
 TH 7
+       -1.32E-03 -2.39E-04 -2.02E-03 -3.91E-04  6.94E-04 -1.05E-04  3.23E-03
 
 TH 8
+       -2.20E-04 -2.13E-03 -3.90E-04 -3.24E-03 -1.03E-04  9.45E-04  5.27E-04  5.08E-03
 
 OM11
+       -8.61E-06  1.49E-05  1.04E-05  4.33E-05  2.79E-05 -1.54E-05  9.96E-06 -1.67E-05  8.39E-05
 
 OM12
+        2.13E-05  6.45E-06  3.37E-05  2.98E-05  7.52E-06 -2.65E-05 -1.11E-05 -6.00E-06  1.01E-05  5.76E-05
 
 OM22
+       -2.38E-05  6.79E-05 -8.98E-06  2.85E-05 -3.98E-05 -4.30E-05  5.46E-06 -6.77E-05  1.40E-05  2.45E-05  1.92E-04
 
 SG11
+        3.92E-05  1.64E-05 -5.75E-06 -1.96E-05 -6.26E-06  1.68E-05 -7.28E-06  2.19E-05 -1.73E-05 -3.41E-06 -2.38E-05  4.57E-05
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                          CORRELATION MATRIX OF ESTIMATE                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        3.83E-02
 
 TH 2
+        1.58E-01  4.87E-02
 
 TH 3
+       -1.49E-01 -4.47E-02  1.60E-01
 
 TH 4
+       -4.43E-02 -1.76E-01  1.33E-01  2.02E-01
 
 TH 5
+        2.83E-02 -1.50E-02 -7.79E-02 -1.72E-02  1.03E-01
 
 TH 6
+       -1.08E-02  1.64E-02 -1.96E-02 -1.01E-01  1.70E-01  1.29E-01
 
 TH 7
+       -6.07E-01 -8.63E-02 -2.22E-01 -3.41E-02  1.18E-01 -1.43E-02  5.68E-02
 
 TH 8
+       -8.05E-02 -6.14E-01 -3.41E-02 -2.25E-01 -1.40E-02  1.02E-01  1.30E-01  7.13E-02
 
 OM11
+       -2.45E-02  3.33E-02  7.08E-03  2.34E-02  2.96E-02 -1.30E-02  1.91E-02 -2.55E-02  9.16E-03
 
 OM12
+        7.34E-02  1.74E-02  2.77E-02  1.95E-02  9.60E-03 -2.70E-02 -2.57E-02 -1.11E-02  1.45E-01  7.59E-03
 
 OM22
+       -4.49E-02  1.01E-01 -4.05E-03  1.02E-02 -2.79E-02 -2.40E-02  6.93E-03 -6.86E-02  1.11E-01  2.33E-01  1.39E-02
 
 SG11
+        1.51E-01  4.98E-02 -5.32E-03 -1.44E-02 -8.97E-03  1.92E-02 -1.89E-02  4.54E-02 -2.79E-01 -6.64E-02 -2.54E-01  6.76E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                      INVERSE COVARIANCE MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        1.36E+03
 
 TH 2
+       -1.49E+02  8.59E+02
 
 TH 3
+        9.32E+01 -2.95E+00  4.83E+01
 
 TH 4
+       -2.94E+00  6.61E+01 -3.91E+00  3.17E+01
 
 TH 5
+       -4.93E+01  2.14E+01  1.61E-02  1.40E+00  1.01E+02
 
 TH 6
+        2.16E+01 -2.17E+01  1.46E+00  1.58E+00 -1.50E+01  6.35E+01
 
 TH 7
+        6.19E+02 -6.27E+01  6.80E+01 -2.97E+00 -4.33E+01  1.70E+01  6.19E+02
 
 TH 8
+       -6.27E+01  4.05E+02 -2.96E+00  4.75E+01  1.71E+01 -2.07E+01 -6.27E+01  4.05E+02
 
 OM11
+       -7.29E+01 -2.02E+02 -1.11E+01 -2.51E+01 -3.17E+01  9.12E+00 -7.06E+01 -8.11E+01  1.32E+04
 
 OM12
+       -5.10E+02  5.21E+01 -5.42E+01 -7.88E+00 -1.20E+01  1.90E+01 -1.60E+02 -1.14E+01 -1.94E+03  1.89E+04
 
 OM22
+        1.29E+02 -2.47E+02  1.25E+01 -1.44E+01  1.93E+01  8.80E+00  3.31E+01 -4.72E+01 -7.10E+01 -2.37E+03  5.97E+03
 
 SG11
+       -9.83E+02 -5.47E+02 -6.45E+01 -4.93E+01  3.66E+01 -1.32E+01 -4.06E+02 -3.22E+02  4.97E+03 -1.79E+02  2.90E+03  2.64E+04
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                      EIGENVALUES OF COR MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12

 
         2.36E-01  2.95E-01  6.22E-01  7.68E-01  8.43E-01  9.63E-01  1.00E+00  1.09E+00  1.32E+00  1.37E+00  1.63E+00  1.86E+00
 
 Elapsed finaloutput time in seconds:     0.19
 #CPUT: Total CPU Time in Seconds,        2.590
Stop Time: 
Tue 03/12/2019 
10:08 AM
