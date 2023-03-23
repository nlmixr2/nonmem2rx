Mon 03/11/2019 
11:18 AM
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

$SIGMA 
0.01 ;[p]

$EST MAXEVAL=9999 NSIG=3 SIGL=12 PRINT=1 METHOD=CONDITIONAL INTERACTION NOABORT
$COV MATRIX=R UNCONDITIONAL

$TABLE ID V K BESTSUB FIRSTONLY NOPRINT NOAPPEND FILE=pmixture_foce.par
  
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
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      12
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     12
 NOPRIOR SETTING (NOPRIOR):                 OFF
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): pmixture_foce.ext
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

 
0ITERATION NO.:    0    OBJECTIVE VALUE:  -7355.30862598168        NO. OF FUNC. EVALS.:   8
 CUMULATIVE NO. OF FUNC. EVALS.:        8
 NPARAMETR:  4.3000E+00 -2.9000E+00  4.3000E+00 -6.7000E-01  5.0000E-01  4.0000E-02  1.0000E-02  2.7000E-02  5.0000E-02  1.0000E-02
             6.0000E-02  1.0000E-02
 PARAMETER:  1.0000E-01 -1.0000E-01  1.0000E-01 -1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01
             1.0000E-01  1.0000E-01
 GRADIENT:   8.5138E+04 -2.2195E+05  7.2959E+03  3.0074E+03 -7.7629E+01 -9.3055E+01  6.2941E+02 -3.8420E+03 -1.1000E+01 -7.9378E+01
            -5.4412E+02 -9.1671E+02
 
0ITERATION NO.:    1    OBJECTIVE VALUE:  -8225.18426708895        NO. OF FUNC. EVALS.:  12
 CUMULATIVE NO. OF FUNC. EVALS.:       20
 NPARAMETR:  4.2381E+00 -2.7913E+00  4.2947E+00 -6.7034E-01  5.0000E-01  4.0000E-02  9.9990E-03  2.7003E-02  5.0000E-02  1.0000E-02
             6.0001E-02  1.0000E-02
 PARAMETER:  9.8562E-02 -9.6250E-02  9.9877E-02 -1.0005E-01  1.0000E-01  1.0000E-01  9.9989E-02  1.0006E-01  1.0000E-01  1.0000E-01
             1.0001E-01  1.0002E-01
 GRADIENT:   5.1802E+04 -1.8625E+05  6.6398E+03  1.5756E+03 -8.7474E+01 -3.1375E+01 -1.3434E+02 -2.6650E+03 -1.4679E+01  1.6323E+00
            -2.7871E+02 -5.8561E+02
 
0ITERATION NO.:    2    OBJECTIVE VALUE:  -8863.26302124529        NO. OF FUNC. EVALS.:  12
 CUMULATIVE NO. OF FUNC. EVALS.:       32
 NPARAMETR:  4.1950E+00 -2.6866E+00  4.2892E+00 -6.7055E-01  5.0000E-01  4.0000E-02  9.9992E-03  2.7005E-02  5.0000E-02  1.0000E-02
             6.0002E-02  1.0001E-02
 PARAMETER:  9.7558E-02 -9.2641E-02  9.9748E-02 -1.0008E-01  1.0000E-01  1.0000E-01  9.9992E-02  1.0012E-01  1.0000E-01  1.0000E-01
             1.0001E-01  1.0003E-01
 GRADIENT:   2.2776E+04 -1.4532E+05  5.6471E+03  1.1936E+03 -9.0353E+01 -4.1868E+01 -3.8352E+02 -1.6319E+03 -1.5216E+01  2.8320E+01
            -2.0915E+02 -3.5813E+02
 
0ITERATION NO.:    3    OBJECTIVE VALUE:  -8978.49348809234        NO. OF FUNC. EVALS.:  13
 CUMULATIVE NO. OF FUNC. EVALS.:       45
 NPARAMETR:  4.2736E+00 -2.6490E+00  4.2847E+00 -6.7059E-01  5.0000E-01  4.0000E-02  1.0003E-02  2.7005E-02  5.0000E-02  9.9998E-03
             6.0002E-02  1.0000E-02
 PARAMETER:  9.9387E-02 -9.1345E-02  9.9644E-02 -1.0009E-01  1.0001E-01  1.0000E-01  1.0003E-01  1.0008E-01  1.0000E-01  9.9998E-02
             1.0002E-01  1.0002E-01
 GRADIENT:   5.1903E+04 -1.3705E+05  4.8448E+03  1.1891E+03 -9.0531E+01 -8.4521E+01  5.7704E+02 -1.4572E+03 -1.4126E+01  3.1111E+01
            -2.0554E+02 -3.7405E+02
 
0ITERATION NO.:    4    OBJECTIVE VALUE:  -8982.24646406384        NO. OF FUNC. EVALS.:  12
 CUMULATIVE NO. OF FUNC. EVALS.:       57
 NPARAMETR:  4.2745E+00 -2.6475E+00  4.2421E+00 -6.7063E-01  5.0003E-01  4.0019E-02  9.8651E-03  2.6808E-02  5.0002E-02  9.9844E-03
             5.9993E-02  9.9922E-03
 PARAMETER:  9.9407E-02 -9.1294E-02  9.8653E-02 -1.0009E-01  1.0014E-01  1.0023E-01  9.8627E-02  9.7470E-02  1.0002E-01  9.9842E-02
             9.9997E-02  9.9609E-02
 GRADIENT:   5.1607E+04 -1.3719E+05 -2.7653E+03  1.3825E+03 -9.0486E+01 -8.4529E+01  5.8486E+02 -1.4530E+03 -1.0466E+01  4.5402E+01
            -2.0871E+02 -3.7337E+02
 
0ITERATION NO.:    5    OBJECTIVE VALUE:  -9634.60206376364        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:       66
 NPARAMETR:  4.4548E+00 -2.3683E+00  4.2087E+00 -6.9383E-01  5.0376E-01  4.2130E-02 -5.9924E-03  1.4435E-02  5.0212E-02  8.2321E-03
             5.9116E-02  9.1153E-03
 PARAMETER:  1.0360E-01 -8.1667E-02  9.7877E-02 -1.0356E-01  1.1502E-01  1.2594E-01 -5.8390E-02 -1.9494E-01  1.0211E-01  8.2147E-02
             9.7982E-02  5.3682E-02
 GRADIENT:   7.6414E+04 -2.5032E+04 -7.8697E+03  1.4821E+02 -9.4514E+01 -3.8674E+02  4.3169E+02 -2.6426E+02 -1.9339E+01  8.7480E+01
            -7.8700E+01 -5.2990E+02
 
0ITERATION NO.:    6    OBJECTIVE VALUE:  -9694.72180231476        NO. OF FUNC. EVALS.:  10
 CUMULATIVE NO. OF FUNC. EVALS.:       76
 NPARAMETR:  4.3979E+00 -2.3247E+00  4.2309E+00 -5.6089E-01  5.0575E-01  4.4016E-02 -1.5908E-03  1.1646E-02  5.0385E-02  7.4060E-03
             5.8903E-02  9.2225E-03
 PARAMETER:  1.0228E-01 -8.0162E-02  9.8393E-02 -8.3715E-02  1.2299E-01  1.4784E-01 -1.5165E-02 -2.7431E-01  1.0384E-01  7.3776E-02
             9.8396E-02  5.9532E-02
 GRADIENT:   5.6981E+04 -1.5643E+04 -6.8436E+03  2.9862E+03 -9.4707E+01 -1.9719E+02  4.9782E+02 -3.3851E+02 -1.3143E+01  1.1115E+02
            -1.0770E+02 -4.9729E+02
 
0ITERATION NO.:    7    OBJECTIVE VALUE:  -9750.40324374613        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:       85
 NPARAMETR:  4.3411E+00 -2.2955E+00  4.2138E+00 -6.7234E-01  5.0781E-01  4.5895E-02  3.2488E-03  1.0225E-02  5.0560E-02  6.5273E-03
             5.8789E-02  9.3767E-03
 PARAMETER:  1.0096E-01 -7.9154E-02  9.7995E-02 -1.0035E-01  1.3124E-01  1.6874E-01  3.0330E-02 -3.4828E-01  1.0556E-01  6.4911E-02
             9.9541E-02  6.7822E-02
 GRADIENT:   3.5203E+04 -1.2982E+03 -7.2742E+03  7.0554E+02 -9.1250E+01 -7.3858E+01  5.9547E+02 -3.7322E+02 -1.4069E+01  7.4172E+01
            -9.3546E+01 -4.5833E+02
 
0ITERATION NO.:    8    OBJECTIVE VALUE:  -9757.85488475892        NO. OF FUNC. EVALS.:  10
 CUMULATIVE NO. OF FUNC. EVALS.:       95
 NPARAMETR:  4.3497E+00 -2.2918E+00  4.2122E+00 -6.7134E-01  5.1169E-01  4.6375E-02  2.7947E-03  9.9598E-03  5.0856E-02  5.4246E-03
             5.9784E-02  1.0230E-02
 PARAMETER:  1.0116E-01 -7.9028E-02  9.7959E-02 -1.0020E-01  1.4676E-01  1.7394E-01  2.5956E-02 -3.5859E-01  1.0848E-01  5.3788E-02
             1.1028E-01  1.1137E-01
 GRADIENT:   3.7326E+04  2.6282E+03 -7.5124E+03  6.9200E+02 -8.8967E+01 -7.6779E+01  5.1395E+02 -3.5978E+02 -1.1794E+01  6.5381E+01
            -8.4935E+01 -1.4107E+02
 
0ITERATION NO.:    9    OBJECTIVE VALUE:  -9782.84900141022        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:      104
 NPARAMETR:  4.3531E+00 -2.2961E+00  4.2005E+00 -6.4961E-01  5.7690E-01  4.8223E-02  2.6667E-03  1.0017E-02  5.5513E-02 -1.1335E-02
             8.8115E-02  1.0010E-02
 PARAMETER:  1.0123E-01 -7.9177E-02  9.7685E-02 -9.6957E-02  4.1006E-01  1.9347E-01  2.4287E-02 -3.5459E-01  1.5229E-01 -1.0758E-01
             2.9579E-01  1.0048E-01
 GRADIENT:   3.6623E+04  1.9060E+03 -7.0172E+03  8.1175E+02 -4.7461E+01 -6.4313E+01  4.7816E+02 -3.2304E+02  1.8291E+00 -3.0306E+01
            -3.3790E+01 -2.0475E+02
 
0ITERATION NO.:   10    OBJECTIVE VALUE:  -9794.08627866189        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:      113
 NPARAMETR:  4.3355E+00 -2.2963E+00  4.2129E+00 -6.5003E-01  6.4464E-01  4.2736E-02  3.8287E-03  9.8312E-03  5.7134E-02  5.7497E-03
             1.0626E-01  1.0132E-02
 PARAMETER:  1.0082E-01 -7.9181E-02  9.7975E-02 -9.7019E-02  6.9556E-01  1.3308E-01  3.7041E-02 -3.7431E-01  1.6669E-01  5.3788E-02
             3.9997E-01  1.0655E-01
 GRADIENT:   3.3317E+04  3.0221E+03 -6.1788E+03  1.0527E+03 -3.9929E+00 -8.8426E+01  5.4060E+02 -3.0115E+02  1.3961E+01  1.8705E+01
            -2.4449E+01 -1.7050E+02
 
0ITERATION NO.:   11    OBJECTIVE VALUE:  -9795.15141526342        NO. OF FUNC. EVALS.:  10
 CUMULATIVE NO. OF FUNC. EVALS.:      123
 NPARAMETR:  4.3446E+00 -2.2975E+00  4.2130E+00 -6.5553E-01  6.5100E-01  4.6247E-02  3.3808E-03  9.8529E-03  5.5585E-02  7.9880E-03
             1.0814E-01  1.0093E-02
 PARAMETER:  1.0104E-01 -7.9225E-02  9.7978E-02 -9.7840E-02  7.2343E-01  1.7256E-01  3.1442E-02 -3.6815E-01  1.5294E-01  7.5760E-02
             4.0614E-01  1.0463E-01
 GRADIENT:   3.4137E+04  2.6870E+03 -6.5268E+03  9.9142E+02 -1.2147E-01 -6.6433E+01  4.8245E+02 -2.9435E+02  8.1150E+00  2.5913E+01
            -2.1614E+01 -1.7593E+02
 
0ITERATION NO.:   12    OBJECTIVE VALUE:  -9796.12575666207        NO. OF FUNC. EVALS.:  10
 CUMULATIVE NO. OF FUNC. EVALS.:      133
 NPARAMETR:  4.3414E+00 -2.2982E+00  4.2118E+00 -6.5429E-01  6.5599E-01  4.5364E-02  3.5212E-03  9.9124E-03  4.8198E-02  6.2312E-03
             1.0387E-01  1.0125E-02
 PARAMETER:  1.0096E-01 -7.9248E-02  9.7949E-02 -9.7655E-02  7.4549E-01  1.6292E-01  3.3065E-02 -3.6642E-01  8.1646E-02  6.3466E-02
             3.8748E-01  1.0620E-01
 GRADIENT:   3.3736E+04  1.6213E+03 -7.5525E+03  1.0213E+03  2.6343E+00 -7.0502E+01  5.0812E+02 -2.9633E+02 -2.0234E+01  2.6926E+01
            -2.7254E+01 -1.6676E+02
 
0ITERATION NO.:   13    OBJECTIVE VALUE:  -9811.76526220091        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:      142
 NPARAMETR:  4.3346E+00 -2.3126E+00  4.2177E+00 -6.7417E-01  6.7724E-01  4.7368E-02  3.2755E-03  1.0883E-02  5.4492E-02  3.0589E-04
             6.4574E-02  1.0290E-02
 PARAMETER:  1.0080E-01 -7.9745E-02  9.8087E-02 -1.0062E-01  8.4112E-01  1.8453E-01  3.0100E-02 -3.1626E-01  1.4302E-01  2.9301E-03
             1.5367E-01  1.1431E-01
 GRADIENT:   3.2233E+04 -1.4900E+04 -5.7998E+03  4.9219E+02  1.0378E+01 -4.7041E+01  6.3510E+02 -3.3550E+02  6.0203E+00  2.6672E+01
            -5.7016E+01 -1.0298E+02
 
0ITERATION NO.:   14    OBJECTIVE VALUE:  -9820.85294442374        NO. OF FUNC. EVALS.:  11
 CUMULATIVE NO. OF FUNC. EVALS.:      153
 NPARAMETR:  4.3151E+00 -2.3306E+00  4.2257E+00 -6.7299E-01  6.3455E-01  4.7534E-02  4.5192E-03  1.1278E-02  5.0309E-02  7.3478E-03
             1.1940E-01  1.0474E-02
 PARAMETER:  1.0035E-01 -8.0365E-02  9.8273E-02 -1.0045E-01  6.5179E-01  1.8628E-01  4.1456E-02 -3.0734E-01  1.0308E-01  7.3252E-02
             4.5649E-01  1.2317E-01
 GRADIENT:   2.5046E+04 -2.2896E+04 -4.6389E+03  7.3676E+02 -9.0401E+00 -2.2009E+01  6.1792E+02 -2.5922E+02 -7.2241E+00  1.7244E+01
            -6.1140E+00 -2.6718E+01
 
0ITERATION NO.:   15    OBJECTIVE VALUE:  -9872.64618922394        NO. OF FUNC. EVALS.:  12
 CUMULATIVE NO. OF FUNC. EVALS.:      165
 NPARAMETR:  4.2788E+00 -2.3309E+00  4.2581E+00 -7.0120E-01  6.6615E-01  4.6852E-02  6.5880E-04  1.2849E-02  5.2323E-02 -9.3482E-03
             5.2891E-02  1.0446E-02
 PARAMETER:  9.9506E-02 -8.0376E-02  9.9026E-02 -1.0466E-01  7.9082E-01  1.7906E-01  6.0872E-03 -2.2308E-01  1.2271E-01 -9.1383E-02
             3.7853E-02  1.2183E-01
 GRADIENT:   1.2680E+04 -2.6917E+04 -1.2982E+03 -6.5023E+02 -7.5750E-02  5.5960E+00  5.1717E+02 -3.2531E+02  1.1478E+01  1.2375E+01
            -3.3080E+01 -8.5399E+00
 
0ITERATION NO.:   16    OBJECTIVE VALUE:  -9883.32374594332        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:      174
 NPARAMETR:  4.2729E+00 -2.3302E+00  4.2666E+00 -6.9623E-01  6.7328E-01  4.6813E-02 -7.1043E-04  1.3569E-02  5.2362E-02 -1.4967E-02
             4.5092E-02  1.0415E-02
 PARAMETER:  9.9370E-02 -8.0351E-02  9.9223E-02 -1.0391E-01  8.2310E-01  1.7864E-01 -6.5670E-03 -1.9582E-01  1.2308E-01 -1.4626E-01
            -7.5705E-02  1.2032E-01
 GRADIENT:   9.6950E+03 -2.4877E+04 -3.9932E+02 -6.3157E+02  3.9736E+00  1.0881E+01  4.2754E+02 -2.9549E+02  7.1499E+00 -2.6401E+01
            -8.3911E+01 -4.4660E+00
 
0ITERATION NO.:   17    OBJECTIVE VALUE:  -9913.68534623188        NO. OF FUNC. EVALS.:  10
 CUMULATIVE NO. OF FUNC. EVALS.:      184
 NPARAMETR:  4.2498E+00 -2.3250E+00  4.2982E+00 -6.8907E-01  6.7899E-01  4.5232E-02 -4.3751E-03  1.5310E-02  5.2544E-02 -1.1668E-02
             4.5976E-02  1.0246E-02
 PARAMETER:  9.8833E-02 -8.0171E-02  9.9959E-02 -1.0285E-01  8.4915E-01  1.6146E-01 -4.1143E-02 -1.4910E-01  1.2481E-01 -1.1382E-01
            -4.5168E-02  1.1215E-01
 GRADIENT:  -3.1364E+02 -1.9714E+04  5.5146E+03 -1.6811E+02  7.3948E+00  3.4742E+00  1.8783E+02 -2.3609E+02  7.0513E+00  2.7527E+00
            -6.4992E+01 -3.6480E+01
 
0ITERATION NO.:   18    OBJECTIVE VALUE:  -9942.90057277710        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:      193
 NPARAMETR:  4.2383E+00 -2.3051E+00  4.2759E+00 -7.0170E-01  6.7107E-01  5.0551E-02 -1.2561E-02  2.1035E-02  5.6155E-02 -1.8959E-02
             6.5366E-02  1.0054E-02
 PARAMETER:  9.8564E-02 -7.9486E-02  9.9439E-02 -1.0473E-01  8.1304E-01  2.1705E-01 -1.1173E-01 -5.6557E-02  1.5805E-01 -1.7890E-01
             1.0826E-01  1.0268E-01
 GRADIENT:  -3.2675E+03 -6.0441E+03  1.0757E+03 -4.7900E+02  2.6519E+00  1.4635E+01 -1.3304E+02 -1.4433E+02  1.6299E+01 -3.3099E+01
             1.2131E+00 -7.5338E+01
 
0ITERATION NO.:   19    OBJECTIVE VALUE:  -9951.61890113248        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:      202
 NPARAMETR:  4.2394E+00 -2.3005E+00  4.2812E+00 -6.7976E-01  6.6545E-01  5.4475E-02 -1.4365E-02  2.4513E-02  5.0918E-02 -9.2655E-03
             5.7158E-02  1.0390E-02
 PARAMETER:  9.8592E-02 -7.9328E-02  9.9562E-02 -1.0146E-01  7.8769E-01  2.5443E-01 -1.2309E-01  1.6340E-02  1.0910E-01 -9.1816E-02
             7.7720E-02  1.1911E-01
 GRADIENT:  -1.7159E+03 -2.6406E+03  3.1038E+03 -1.3815E+01 -7.2777E-01  3.8600E+01 -1.3104E+02 -8.2951E+01  5.9046E+00  1.4209E+01
            -7.6555E+00  4.8109E+01
 
0ITERATION NO.:   20    OBJECTIVE VALUE:  -9955.85661753422        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:      211
 NPARAMETR:  4.2223E+00 -2.3005E+00  4.2512E+00 -6.5673E-01  6.6309E-01  4.7648E-02 -1.2638E-02  2.7511E-02  4.5914E-02 -9.9788E-03
             5.8265E-02  1.0367E-02
 PARAMETER:  9.8194E-02 -7.9326E-02  9.8865E-02 -9.8019E-02  7.7710E-01  1.8748E-01 -1.1579E-01  9.2993E-02  5.7370E-02 -1.0413E-01
             8.3312E-02  1.1804E-01
 GRADIENT:  -8.4424E+03 -4.1800E+03 -1.3853E+03  3.9780E+02 -2.1458E+00 -8.4490E+00 -1.2869E+02 -2.7613E+01 -1.3574E+01  3.5195E+00
            -5.8815E+00  4.9828E+01
 
0ITERATION NO.:   21    OBJECTIVE VALUE:  -9959.49936397984        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:      220
 NPARAMETR:  4.2440E+00 -2.2960E+00  4.2501E+00 -6.6786E-01  6.6873E-01  5.0789E-02 -1.1440E-02  2.6587E-02  4.7643E-02 -1.0346E-02
             5.8430E-02  1.0117E-02
 PARAMETER:  9.8698E-02 -7.9172E-02  9.8841E-02 -9.9680E-02  8.0246E-01  2.1940E-01 -1.0153E-01  8.9894E-02  7.5853E-02 -1.0599E-01
             8.4091E-02  1.0582E-01
 GRADIENT:   1.0270E+03  4.2507E+02 -1.8317E+03  1.2830E+02  1.2391E+00  2.6575E+01 -5.8089E+01 -2.4619E+01 -6.7684E+00  2.6655E+00
            -4.7277E+00 -4.1418E+01
 
0ITERATION NO.:   22    OBJECTIVE VALUE:  -9961.49450026743        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:      229
 NPARAMETR:  4.2405E+00 -2.2972E+00  4.2602E+00 -6.7348E-01  6.6553E-01  4.5505E-02 -8.6935E-03  2.6117E-02  4.9330E-02 -1.1007E-02
             6.0077E-02  1.0247E-02
 PARAMETER:  9.8616E-02 -7.9214E-02  9.9075E-02 -1.0052E-01  7.8804E-01  1.6447E-01 -8.1507E-02  9.9098E-02  9.3253E-02 -1.1081E-01
             9.6726E-02  1.1221E-01
 GRADIENT:  -5.1698E+02 -5.0710E+02 -2.1550E+02  4.4176E+01 -6.8221E-01 -6.5030E+00 -1.0208E+01 -1.6298E+01  1.0190E-01  1.7445E-01
             4.2241E-01  3.3608E+00
 
0ITERATION NO.:   23    OBJECTIVE VALUE:  -9961.71658147040        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:      238
 NPARAMETR:  4.2414E+00 -2.2969E+00  4.2607E+00 -6.7410E-01  6.6591E-01  4.5920E-02 -8.5867E-03  2.6902E-02  4.9031E-02 -1.0829E-02
             5.9906E-02  1.0236E-02
 PARAMETER:  9.8637E-02 -7.9203E-02  9.9086E-02 -1.0061E-01  7.8976E-01  1.6901E-01 -8.0141E-02  1.1600E-01  9.0213E-02 -1.0936E-01
             9.5793E-02  1.1166E-01
 GRADIENT:  -1.0988E+02 -2.3201E+02 -1.4617E+02  3.2505E+01 -4.5234E-01 -2.3541E+00 -2.5099E+00 -4.6753E+00 -9.4845E-01  9.2367E-01
             5.5043E-02  2.1320E-01
 
0ITERATION NO.:   24    OBJECTIVE VALUE:  -9961.74575329529        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:      247
 NPARAMETR:  4.2417E+00 -2.2966E+00  4.2617E+00 -6.7545E-01  6.6651E-01  4.6173E-02 -8.5636E-03  2.7224E-02  4.9248E-02 -1.0987E-02
             5.9966E-02  1.0234E-02
 PARAMETER:  9.8644E-02 -7.9194E-02  9.9108E-02 -1.0081E-01  7.9247E-01  1.7175E-01 -7.9707E-02  1.2266E-01  9.2418E-02 -1.1071E-01
             9.5797E-02  1.1154E-01
 GRADIENT:   5.6112E+01 -7.1780E+01 -2.2774E+01  5.7932E+00 -9.1569E-02 -4.5876E-02  3.0671E-01 -1.5823E-01 -2.0855E-01  1.6951E-01
             6.1780E-02 -2.8526E-01
 
0ITERATION NO.:   25    OBJECTIVE VALUE:  -9961.74616551647        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:      256
 NPARAMETR:  4.2416E+00 -2.2965E+00  4.2618E+00 -6.7570E-01  6.6665E-01  4.6181E-02 -8.5719E-03  2.7244E-02  4.9300E-02 -1.1016E-02
             5.9967E-02  1.0234E-02
 PARAMETER:  9.8641E-02 -7.9190E-02  9.9112E-02 -1.0085E-01  7.9310E-01  1.7184E-01 -7.9777E-02  1.2299E-01  9.2955E-02 -1.1094E-01
             9.5717E-02  1.1157E-01
 GRADIENT:   2.2667E+01 -3.1437E+01 -4.8968E+00  8.6483E-01 -7.4104E-03  2.9860E-03  1.0522E-01  6.8495E-02 -2.2099E-02  5.2390E-02
             2.9372E-02 -2.2091E-02
 
0ITERATION NO.:   26    OBJECTIVE VALUE:  -9961.74617897560        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:      265
 NPARAMETR:  4.2415E+00 -2.2964E+00  4.2619E+00 -6.7576E-01  6.6668E-01  4.6182E-02 -8.5763E-03  2.7242E-02  4.9310E-02 -1.1028E-02
             5.9966E-02  1.0234E-02
 PARAMETER:  9.8640E-02 -7.9187E-02  9.9113E-02 -1.0086E-01  7.9322E-01  1.7185E-01 -7.9817E-02  1.2292E-01  9.3055E-02 -1.1105E-01
             9.5664E-02  1.1158E-01
 GRADIENT:   2.4833E+00 -7.0557E+00  8.8738E-01 -2.3352E-01  8.7187E-03 -4.9290E-03 -3.8553E-02  2.9971E-02  7.9018E-03 -1.2887E-02
             8.4518E-03  3.2621E-02
 
0ITERATION NO.:   27    OBJECTIVE VALUE:  -9961.74617897560        NO. OF FUNC. EVALS.:  17
 CUMULATIVE NO. OF FUNC. EVALS.:      282
 NPARAMETR:  4.2415E+00 -2.2964E+00  4.2619E+00 -6.7576E-01  6.6668E-01  4.6182E-02 -8.5763E-03  2.7242E-02  4.9310E-02 -1.1028E-02
             5.9966E-02  1.0234E-02
 PARAMETER:  9.8640E-02 -7.9187E-02  9.9113E-02 -1.0086E-01  7.9322E-01  1.7185E-01 -7.9817E-02  1.2292E-01  9.3055E-02 -1.1105E-01
             9.5664E-02  1.1158E-01
 GRADIENT:  -2.5816E+01 -1.5626E+01 -1.3270E+01 -6.6213E+00  8.7168E-03 -4.9290E-03 -3.8553E-02  2.9971E-02  7.9018E-03 -1.2887E-02
             8.4518E-03  3.2070E-02
 
0ITERATION NO.:   28    OBJECTIVE VALUE:  -9961.74617897560        NO. OF FUNC. EVALS.:  12
 CUMULATIVE NO. OF FUNC. EVALS.:      294
 NPARAMETR:  4.2415E+00 -2.2964E+00  4.2619E+00 -6.7576E-01  6.6668E-01  4.6182E-02 -8.5763E-03  2.7242E-02  4.9310E-02 -1.1028E-02
             5.9966E-02  1.0234E-02
 PARAMETER:  9.8640E-02 -7.9187E-02  9.9113E-02 -1.0086E-01  7.9322E-01  1.7185E-01 -7.9817E-02  1.2292E-01  9.3055E-02 -1.1105E-01
             9.5664E-02  1.1158E-01
 GRADIENT:  -2.5816E+01 -1.5626E+01 -1.3270E+01 -6.6213E+00  8.7168E-03 -4.9290E-03 -3.8553E-02  2.9971E-02  7.9018E-03 -1.2887E-02
             8.4518E-03  3.2070E-02
 
 #TERM:
0MINIMIZATION SUCCESSFUL
 NO. OF FUNCTION EVALUATIONS USED:      294
 NO. OF SIG. DIGITS IN FINAL EST.:  3.2

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND SE IS THE ASSOCIATED STANDARD ERROR.

 SUBMODEL    1
 
 ETABAR:        -1.0847E-03  2.4070E-03  0.0000E+00  0.0000E+00
 SE:             1.4890E-02  1.1050E-02  0.0000E+00  0.0000E+00
 N:                     200         200           0           0
 
 ETASHRINKSD(%)  1.7675E+00  5.0797E+00  1.0000E+02  1.0000E+02
 ETASHRINKVR(%)  3.5037E+00  9.9015E+00  1.0000E+02  1.0000E+02
 EBVSHRINKSD(%)  1.9974E+00  5.0713E+00  1.0000E+02  1.0000E+02
 EBVSHRINKVR(%)  3.9549E+00  9.8854E+00  1.0000E+02  1.0000E+02
 EPSSHRINKSD(%)  1.1419E+01
 EPSSHRINKVR(%)  2.1535E+01
 

 SUBMODEL    2
 
 ETABAR:         0.0000E+00  0.0000E+00 -2.6046E-04  4.3527E-04
 SE:             0.0000E+00  0.0000E+00  2.1779E-02  2.4454E-02
 N:                       0           0         100         100
 
 ETASHRINKSD(%)  1.0000E+02  1.0000E+02  1.4286E+00  1.0000E-10
 ETASHRINKVR(%)  1.0000E+02  1.0000E+02  2.8368E+00  1.0000E-10
 EBVSHRINKSD(%)  1.0000E+02  1.0000E+02  1.9135E+00  1.0474E-01
 EBVSHRINKVR(%)  1.0000E+02  1.0000E+02  3.7904E+00  2.0936E-01
 EPSSHRINKSD(%)  1.4368E+01
 EPSSHRINKVR(%)  2.6672E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2400
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    4410.90495938243     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:   -9961.74617897560     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:      -5550.84121959317     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           600
  
 #TERE:
 Elapsed estimation  time in seconds:    27.43
 Elapsed covariance  time in seconds:    19.45
 Elapsed postprocess time in seconds:     0.32
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 #OBJT:**************                       MINIMUM VALUE OF OBJECTIVE FUNCTION                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************    -9961.746       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         4.24E+00 -2.30E+00  4.26E+00 -6.76E-01  6.67E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        4.62E-02
 
 ETA2
+       -8.58E-03  2.72E-02
 
 ETA3
+        0.00E+00  0.00E+00  4.93E-02
 
 ETA4
+        0.00E+00  0.00E+00 -1.10E-02  6.00E-02
 


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
+       -2.42E-01  1.65E-01
 
 ETA3
+        0.00E+00  0.00E+00  2.22E-01
 
 ETA4
+        0.00E+00  0.00E+00 -2.03E-01  2.45E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.01E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                            STANDARD ERROR OF ESTIMATE                          ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.55E-02  1.23E-02  2.26E-02  2.45E-02  2.72E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        4.81E-03
 
 ETA2
+        2.79E-03  3.02E-03
 
 ETA3
+       ......... .........  7.25E-03
 
 ETA4
+       ......... .........  5.67E-03  8.51E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        3.43E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3      ETA4     
 
 ETA1
+        1.12E-02
 
 ETA2
+        7.13E-02  9.15E-03
 
 ETA3
+       ......... .........  1.63E-02
 
 ETA4
+       ......... .........  9.79E-02  1.74E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.70E-03
 
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
+        2.41E-04
 
 TH 2
+       -5.01E-05  1.51E-04
 
 TH 3
+        1.10E-07  1.88E-08  5.13E-04
 
 TH 4
+       -1.66E-09  1.74E-08 -1.13E-04  6.01E-04
 
 TH 5
+       -9.36E-10  5.13E-09  2.49E-09  2.33E-08  7.41E-04
 
 OM11
+        3.68E-08 -1.47E-07 -1.98E-08 -1.17E-09 -2.72E-10  2.32E-05
 
 OM12
+       -8.02E-08  3.88E-07  1.48E-08 -1.21E-09 -4.24E-10 -4.83E-06  7.79E-06
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        3.23E-07 -1.28E-06 -2.78E-08  8.02E-09  2.52E-09  9.95E-07 -3.00E-06 ......... .........  9.13E-06
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+       -2.24E-08 -3.10E-09  1.06E-07 -6.77E-08  4.69E-10  3.90E-09 -2.99E-09 ......... .........  5.99E-09 ......... .........
          5.26E-05
 
 OM34
+        4.74E-09 -1.72E-09 -1.87E-07  2.12E-07 -3.08E-09 -7.81E-10  9.56E-10 ......... ......... -2.16E-09 ......... .........
         -1.16E-05  3.21E-05
 
 OM44
+        3.80E-10 -1.83E-08  4.06E-07 -7.49E-07 -2.44E-08  1.46E-09  1.07E-09 ......... ......... -8.01E-09 ......... .........
          2.59E-06 -1.36E-05  7.24E-05
 
 SG11
+        1.15E-07  1.75E-08  1.14E-07  1.46E-09 -4.32E-12 -2.06E-08  1.57E-08 ......... ......... -2.98E-08 ......... .........
         -2.31E-08  3.97E-09 -2.88E-09  1.18E-07
 
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
+        1.55E-02
 
 TH 2
+       -2.62E-01  1.23E-02
 
 TH 3
+        3.14E-04  6.74E-05  2.26E-02
 
 TH 4
+       -4.37E-06  5.76E-05 -2.04E-01  2.45E-02
 
 TH 5
+       -2.22E-06  1.53E-05  4.04E-06  3.49E-05  2.72E-02
 
 OM11
+        4.92E-04 -2.48E-03 -1.82E-04 -9.91E-06 -2.07E-06  4.81E-03
 
 OM12
+       -1.85E-03  1.13E-02  2.34E-04 -1.77E-05 -5.59E-06 -3.60E-01  2.79E-03
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        6.90E-03 -3.46E-02 -4.06E-04  1.08E-04  3.06E-05  6.84E-02 -3.56E-01 ......... .........  3.02E-03
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+       -1.99E-04 -3.47E-05  6.46E-04 -3.81E-04  2.38E-06  1.12E-04 -1.48E-04 ......... .........  2.73E-04 ......... .........
          7.25E-03
 
 OM34
+        5.39E-05 -2.47E-05 -1.46E-03  1.53E-03 -1.99E-05 -2.86E-05  6.05E-05 ......... ......... -1.26E-04 ......... .........
         -2.83E-01  5.67E-03
 
 OM44
+        2.88E-06 -1.75E-04  2.11E-03 -3.59E-03 -1.05E-04  3.57E-05  4.50E-05 ......... ......... -3.12E-04 ......... .........
          4.19E-02 -2.83E-01  8.51E-03
 
 SG11
+        2.16E-02  4.15E-03  1.46E-02  1.73E-04 -4.63E-07 -1.25E-02  1.64E-02 ......... ......... -2.87E-02 ......... .........
         -9.27E-03  2.04E-03 -9.86E-04  3.43E-04
 
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
+        4.46E+03
 
 TH 2
+        1.48E+03  7.11E+03
 
 TH 3
+       -3.61E-03 -7.55E-02  2.04E+03
 
 TH 4
+       -2.02E-02 -2.21E-01  3.83E+02  1.74E+03
 
 TH 5
+       -4.74E-03 -5.05E-02 -1.91E-02 -5.54E-02  1.35E+03
 
 OM11
+       -5.03E+00  7.77E+00  2.28E-02  8.01E-02  1.86E-02  4.98E+04
 
 OM12
+       -8.88E+00  3.83E+01 -4.50E-02 -2.88E-01 -6.81E-02  3.30E+04  1.69E+05
 
 OM13
+       ......... ......... ......... ......... ......... ......... ......... .........
 
 OM14
+       ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        3.26E+01  9.52E+02 -5.96E-01 -1.76E+00 -4.03E-01  5.44E+03  5.20E+04 ......... .........  1.26E+05
 
 OM23
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM24
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM33
+       -1.80E-02  1.65E-01 -2.88E+00 -7.01E-02  4.33E-02  1.23E-03 -3.33E-01 ......... .........  1.24E+00 ......... .........
          2.07E+04
 
 OM34
+        5.99E-02  1.45E+00  5.80E+00 -2.75E+00  3.66E-01 -4.23E-01  7.07E-01 ......... .........  1.14E+01 ......... .........
          7.81E+03  3.68E+04
 
 OM44
+        1.85E-01  2.07E+00 -6.34E+00  1.53E+01  5.21E-01 -7.40E-01  2.60E+00 ......... .........  1.65E+01 ......... .........
          7.30E+02  6.65E+03  1.50E+04
 
 SG11
+       -4.57E+03 -2.27E+03 -1.97E+03 -3.91E+02  4.34E-18  5.70E+03 -3.63E+03 ......... .........  2.58E+04 ......... .........
          3.81E+03  4.48E+02  2.96E+02  8.51E+06
 
 Elapsed finaloutput time in seconds:     0.12
 #CPUT: Total CPU Time in Seconds,       45.069
Stop Time: 
Mon 03/11/2019 
11:19 AM
