# Reads the NONMEM `.lst` file for final parameter information

Reads the NONMEM `.lst` file for final parameter information

## Usage

``` r
nmlst(file, strictLst = FALSE)
```

## Arguments

- file:

  File where the list is located

- strictLst:

  The list parsing needs to be correct for a successful load (default
  `FALSE`).

## Value

return a list with `$theta`, `$eta` and `$eps` and other information
about the control stream

## Author

Matthew L. Fidler

## Examples

``` r
nmlst(system.file("mods/DDMODEL00000322/HCQ1CMT.lst", package="nonmem2rx"))
#> $theta
#>  theta1  theta2  theta3  theta4  theta5 
#>  15.700 861.000   9.300   0.746   1.380 
#> 
#> $omega
#>       eta1  eta2
#> eta1 0.149 0.000
#> eta2 0.000 0.272
#> 
#> $sigma
#>        eps1
#> eps1 0.0286
#> 
#> $cov
#> NULL
#> 
#> $objf
#> [1] 865.901
#> 
#> $nobs
#> [1] 76
#> 
#> $nsub
#> [1] 48
#> 
#> $nmtran
#> [1] "WARNINGS AND ERRORS (IF ANY) FOR PROBLEM 1\n\n(WARNING 2) NM-TRAN INFERS THAT THE DATA ARE POPULATION."
#> 
#> $termInfo
#> [1] "0MINIMIZATION SUCCESSFUL\nNO. OF FUNCTION EVALUATIONS USED: 120\nNO. OF SIG. DIGITS IN FINAL EST.: 3.1"
#> 
#> $nonmem
#> [1] "7.3.0"
#> 
#> $time
#> [1] 68.17
#> 
#> $tere
#> [1] "Elapsed estimation time in seconds: 26.44\n0R MATRIX ALGORITHMICALLY SINGULAR\nAND ALGORITHMICALLY NON-POSITIVE-SEMIDEFINITE\n0R MATRIX IS OUTPUT\n0COVARIANCE STEP ABORTED\nElapsed covariance time in seconds: 41.73"
#> 
#> $control
#>  [1] ";; Description:"                                                   
#>  [2] ";; Author: user"                                                   
#>  [3] "$PROBLEM HCQ 1CMT ORAL PK MODEL (BASED ON CARMICHAEL ET AL (2003))"
#>  [4] "; ------------dataset------------"                                 
#>  [5] "$INPUT ID SEX WT AGE TIME AMT ADDL II CMT DV MDV EVID"             
#>  [6] "$DATA HCQdata5.csv IGNORE=@"                                       
#>  [7] ""                                                                  
#>  [8] "; ------------model------------"                                   
#>  [9] "$SUBROUTINE ADVAN2 TRANS2"                                         
#> [10] "$PK"                                                               
#> [11] ""                                                                  
#> [12] "TVCL=THETA(1)*((WT/80)**THETA(5));*((AGE/57)**THETA(5));"          
#> [13] "TVV=THETA(2)"                                                      
#> [14] "TVKA=THETA(3)"                                                     
#> [15] "TVF1=THETA(4)"                                                     
#> [16] "; TVALAG1=THETA(4)"                                                
#> [17] ""                                                                  
#> [18] ""                                                                  
#> [19] "CL=TVCL*EXP(ETA(1))"                                               
#> [20] "V=TVV*EXP(ETA(2))"                                                 
#> [21] "KA=TVKA;*EXP(ETA(3))"                                              
#> [22] "F1=TVF1;*EXP(ETA(4))"                                              
#> [23] "; ALAG1=TVALAG1;*EXP(ETA(3))"                                      
#> [24] ""                                                                  
#> [25] ""                                                                  
#> [26] "; scaling factor"                                                  
#> [27] "KE=CL/V"                                                           
#> [28] "S2=V/1000 ; dose [mg] and conc. [ng/mL]"                           
#> [29] ""                                                                  
#> [30] ""                                                                  
#> [31] "$ERROR"                                                            
#> [32] "Y=F*(1+EPS(1));+EPS(2)"                                            
#> [33] "W=F"                                                               
#> [34] ""                                                                  
#> [35] "IPRED=F ; prediction individuelle"                                 
#> [36] "IRES=DV-IPRED ; (individual-specific residual)"                    
#> [37] "IWRES=IRES/W ; (individual-specific weighted residual)"            
#> [38] ""                                                                  
#> [39] ""                                                                  
#> [40] ""                                                                  
#> [41] "$THETA (0,14.9207) ; CL"                                           
#> [42] "$THETA (0,861.385) ; V"                                            
#> [43] "$THETA (0,9.3023,10) ; KA"                                         
#> [44] "$THETA (0,0.746) FIX ; F1"                                         
#> [45] ";$THETA (0,0.00445) ; ALAG1"                                       
#> [46] "$THETA 1.20407 ; WTonCL"                                           
#> [47] "$OMEGA 0.163126 ; IIVCL"                                           
#> [48] "0.27101 ; IIVV"                                                    
#> [49] "; 0.94 ; IVVKA"                                                    
#> [50] "; 0.004 FIXED ; IIVF"                                              
#> [51] "; 0.02 ; IIVALAG"                                                  
#> [52] "$SIGMA 0.0290039 ; epsPROP1"                                       
#> [53] ";0.000365773 ; epsADD1"                                            
#> [54] "$ESTIMATION METHOD=1 INTER MAXEVAL=9999 PRINT=5 SIG=3 POSTHOC"     
#> [55] "; standard error of estimates :"                                   
#> [56] "$COVARIANCE"                                                       
#> [57] "$TABLE ID SEX WT AGE TIME DV PRED CPRED IPRED EVID RES WRES IRES"  
#> [58] "IWRES CWRES NPDE ESAMPLE=300 NOPRINT FILE=pred"                    
#> [59] "; population and individual predictions and residuals"             
#> [60] "$TABLE ID SEX WT AGE CL V KA ETA(1) ETA(2) NOPRINT NOAPPEND"       
#> [61] "FIRSTONLY FILE=param"                                              
#> [62] "; individual PK parameters (bayesiens,posthoc)"                    
#> [63] ""                                                                  
#> [64] ""                                                                  
#> 
nmlst(system.file("mods/DDMODEL00000302/run1.lst", package="nonmem2rx"))
#> $theta
#>  theta1  theta2  theta3  theta4  theta5 
#> -4.5300 -9.6900 -0.3270  0.0145  0.4340 
#> 
#> $omega
#>      eta1
#> eta1    0
#> 
#> $sigma
#> NULL
#> 
#> $cov
#>           theta1    theta2    theta3    theta4    theta5 eta1
#> theta1  0.199000 -0.219000  3.45e-02 -2.73e-04 -2.53e-03    0
#> theta2 -0.219000  0.262000 -3.84e-02  1.42e-04 -1.24e-02    0
#> theta3  0.034500 -0.038400  8.26e-03 -3.99e-05  9.20e-04    0
#> theta4 -0.000273  0.000142 -3.99e-05  1.76e-05  2.31e-05    0
#> theta5 -0.002530 -0.012400  9.20e-04  2.31e-05  2.36e-02    0
#> eta1    0.000000  0.000000  0.00e+00  0.00e+00  0.00e+00    0
#> 
#> $objf
#> [1] 2515.122
#> 
#> $nobs
#> [1] 693
#> 
#> $nsub
#> [1] 693
#> 
#> $nmtran
#> [1] "WARNINGS AND ERRORS (IF ANY) FOR PROBLEM 1\n\n(WARNING 2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.\n\n(WARNING 3) THERE MAY BE AN ERROR IN THE ABBREVIATED CODE. THE FOLLOWING\nONE OR MORE RANDOM VARIABLES ARE DEFINED WITH \"IF\" STATEMENTS THAT DO NOT\nPROVIDE DEFINITIONS FOR BOTH THE \"THEN\" AND \"ELSE\" CASES. IF ALL\nCONDITIONS FAIL, THE VALUES OF THESE VARIABLES WILL BE ZERO.\n\nY\n\n\n(WARNING 90) WITH \"NUMERICAL\", \"SLOW\" IS ALSO REQUIRED ON $ESTIM RECORD.\nNM-TRAN HAS SUPPLIED THIS OPTION.\n\n(WARNING 97) A RANDOM QUANTITY IS RAISED TO A POWER. IF THE RESULT AFFECTS\nTHE VALUE OF THE OBJECTIVE FUNCTION, THE USER SHOULD ENSURE THAT THE\nRANDOM QUANTITY IS NEVER 0 WHEN THE POWER IS < 1.\n\n(WARNING 48) DES-DEFINED ITEMS ARE COMPUTED ONLY WHEN EVENT TIME\nINCREASES. E.G., DISPLAYED VALUES ASSOCIATED WITH THE FIRST EVENT RECORD\nOF AN INDIVIDUAL RECORD ARE COMPUTED WITH (THE LAST ADVANCE TO) AN EVENT\nTIME OF THE PRIOR INDIVIDUAL RECORD.\n\n(WARNING 27) THE ABBREVIATED CODE CONTAINS A SIMULATION BLOCK BUT THERE IS\nNO $SIMULATION RECORD."
#> 
#> $termInfo
#> [1] "0MINIMIZATION SUCCESSFUL\nHOWEVER, PROBLEMS OCCURRED WITH THE MINIMIZATION.\nREGARD THE RESULTS OF THE ESTIMATION STEP CAREFULLY, AND ACCEPT THEM ONLY\nAFTER CHECKING THAT THE COVARIANCE STEP PRODUCES REASONABLE OUTPUT.\nNO. OF FUNCTION EVALUATIONS USED: 74\nNO. OF SIG. DIGITS IN FINAL EST.: 3.4"
#> 
#> $nonmem
#> [1] "7.3.0"
#> 
#> $time
#> [1] 4.43
#> 
#> $tere
#> [1] "Elapsed estimation time in seconds: 3.72\nElapsed covariance time in seconds: 0.71"
#> 
#> $control
#>   [1] ";; 1. Based on: run200"                                                                                           
#>   [2] ";; 2. Description: Final model, posthoc PK based on published unified model. Prityfied code"                      
#>   [3] ";; x1. Author: Matts"                                                                                             
#>   [4] "$SIZES NO=3000 LIM6=1000"                                                                                         
#>   [5] "$PROBLEM PN survival model With individual PK"                                                                    
#>   [6] "; Implemented flip comments using PsN (e.g. sim_start and sim_end to define code to be used for VPC simulations)."
#>   [7] ""                                                                                                                 
#>   [8] ";Sim_start"                                                                                                       
#>   [9] "$INPUT MID TIME DUR RATE AMT EVID CMT DV CENS CENSD STUD ADC NDOS"                                                
#>  [10] "NAMT_MAX PL_DOSE AV_DOSE CUMDOSE DFREQ ;18"                                                                       
#>  [11] "RITUX SEXX AGE BW BHT RACE BMI BSA CTYPE ALB BUN BSLD=DROP"                                                       
#>  [12] "PDUR=DROP PCPLAT PCTAX PCVINCA PCPROT ;34"                                                                        
#>  [13] "PPN DIAB ECOG1 DSBUILD=DROP PK ID ET1 ET2 ET3 ET4 ET5 ET6 ;48"                                                    
#>  [14] "$DATA nonmem_gr2_Nov13_2018.csv IGNORE=@ IGNORE(TIME.LT.0)"                                                       
#>  [15] "IGNORE(STUD.EQ.29006) IGNORE(ID.EQ.639)"                                                                          
#>  [16] "; 13 patients"                                                                                                    
#>  [17] "; Unrealistic PK"                                                                                                 
#>  [18] ""                                                                                                                 
#>  [19] ";$INPUT MID TIME DUR RATE AMT EVID CMT DV CENS CENSD STUD ADC NDOS NAMT_MAX PL_DOSE AV_DOSE CUMDOSE DFREQ"        
#>  [20] ""                                                                                                                 
#>  [21] "; RITUX SEXX AGE BW BHT RACE BMI BSA CTYPE ALB BUN BSLD=DROP PDUR=DROP PCPLAT PCTAX PCVINCA PCPROT"               
#>  [22] ""                                                                                                                 
#>  [23] "; PPN DIAB ECOG1 DSBUILD=DROP ET1 ET2 ET3 ET4 ET5 ET6 PK ID"                                                      
#>  [24] ""                                                                                                                 
#>  [25] ";"                                                                                                                
#>  [26] ""                                                                                                                 
#>  [27] "; $DATA ../data/nonmem_gr2_Nov13_2018_sim.csv IGNORE=@"                                                           
#>  [28] ""                                                                                                                 
#>  [29] "; IGNORE(TIME.LT.0)"                                                                                              
#>  [30] ""                                                                                                                 
#>  [31] "; IGNORE(STUD.EQ.29006) ; 13 patients"                                                                            
#>  [32] ""                                                                                                                 
#>  [33] "; IGNORE(ID.EQ.639) ; Unrealistic PK"                                                                             
#>  [34] ""                                                                                                                 
#>  [35] ";Sim_end"                                                                                                         
#>  [36] "$SUBROUTINE ADVAN13 TRANS1 TOL=6"                                                                                 
#>  [37] "$MODEL COMP=(central) COMP=(peri) COMP=(effcpt) COMP=(cumhaz)"                                                    
#>  [38] "COMP=(trcpt) COMP(AUC)"                                                                                           
#>  [39] "$PK"                                                                                                              
#>  [40] ";for simulation"                                                                                                  
#>  [41] "RTTE=0"                                                                                                           
#>  [42] ";end for simulation"                                                                                              
#>  [43] ""                                                                                                                 
#>  [44] "; Covariate imputations etc"                                                                                      
#>  [45] "ageRef = 65"                                                                                                      
#>  [46] "albref=4.0"                                                                                                       
#>  [47] "bunref=16"                                                                                                        
#>  [48] "bodyWeightRef=85 ; Male"                                                                                          
#>  [49] ""                                                                                                                 
#>  [50] "IF(SEXX.EQ.1) SEX=1 ; Male"                                                                                       
#>  [51] "IF(SEXX.EQ.2) THEN"                                                                                               
#>  [52] "SEX=0 ; Female"                                                                                                   
#>  [53] "bodyWeightRef=68"                                                                                                 
#>  [54] "ENDIF"                                                                                                            
#>  [55] ""                                                                                                                 
#>  [56] "BWT=BW"                                                                                                           
#>  [57] "IF(BW.EQ.-99) BWT=bodyWeightRef"                                                                                  
#>  [58] ""                                                                                                                 
#>  [59] "; PK parameters"                                                                                                  
#>  [60] ""                                                                                                                 
#>  [61] "THETA1=0.312;1 CL"                                                                                                
#>  [62] "THETA2=1.21;2 V1"                                                                                                 
#>  [63] "THETA3= 0.957;3 V2"                                                                                               
#>  [64] "THETA4= -1.02;4 Q"                                                                                                
#>  [65] "THETA5= 1.48;5 KDES"                                                                                              
#>  [66] "THETA6= 1.02;6 CLT"                                                                                               
#>  [67] "THETA7= 0.476;7 WT to CLinf"                                                                                      
#>  [68] "THETA8= 0.527;8 WT to V1"                                                                                         
#>  [69] "THETA9= 0.484;9 WT to 2"                                                                                          
#>  [70] "THETA10= 0.303;10 WT to Q"                                                                                        
#>  [71] "THETA11= 0.149;11 SEX to V1"                                                                                      
#>  [72] "THETA12= 0.223;12 SEX to V"                                                                                       
#>  [73] "THETA13= -0.212;13 power NDOS to CL"                                                                              
#>  [74] ""                                                                                                                 
#>  [75] "LWT75 = LOG(BWT/75)"                                                                                              
#>  [76] "MUX1 = THETA1+THETA7*LWT75 +THETA13*LOG(NDOS/2.4)"                                                                
#>  [77] "MUX2 = THETA2+THETA8*LWT75+THETA11*SEX"                                                                           
#>  [78] "MUX3 = THETA3+THETA9*LWT75+THETA12*SEX"                                                                           
#>  [79] "MUX4 = THETA4+THETA10*LWT75"                                                                                      
#>  [80] "MUX5 = THETA5"                                                                                                    
#>  [81] "MUX6 = THETA6"                                                                                                    
#>  [82] ""                                                                                                                 
#>  [83] "CLINF = EXP(MUX1+ET1)"                                                                                            
#>  [84] "V1 = EXP(MUX2+ET2)"                                                                                               
#>  [85] "V2 = EXP(MUX3+ET3)"                                                                                               
#>  [86] "Q = EXP(MUX4+ET4)"                                                                                                
#>  [87] "KDES = EXP(MUX5+ET5)"                                                                                             
#>  [88] "CLT = EXP(MUX6+ET6)"                                                                                              
#>  [89] ""                                                                                                                 
#>  [90] "S1 = V1/1000"                                                                                                     
#>  [91] ""                                                                                                                 
#>  [92] ";Reparameterization"                                                                                              
#>  [93] "K12 = Q/V1"                                                                                                       
#>  [94] "K21 = Q/V2"                                                                                                       
#>  [95] ""                                                                                                                 
#>  [96] "; PD parameters"                                                                                                  
#>  [97] "LOGKTR = THETA(1)+ETA(1) ; Eta1 Fixed to zero"                                                                    
#>  [98] "KTR = EXP(LOGKTR) ; first order transit rate to and from transit and effect compartment"                          
#>  [99] "ALPHA = EXP(THETA(2)) ; slope of drug effect"                                                                     
#> [100] "BETA = EXP(THETA(3)) ; weibul function parameter"                                                                 
#> [101] ""                                                                                                                 
#> [102] "covar = THETA(4) * (BWT - 75) + THETA(5) * PPN ; covariate effects on Hazard"                                     
#> [103] ""                                                                                                                 
#> [104] "$DES"                                                                                                             
#> [105] "; PK model"                                                                                                       
#> [106] "CL = CLT * EXP(-KDES * T) + CLINF"                                                                                
#> [107] "K10 = CL / V1"                                                                                                    
#> [108] ""                                                                                                                 
#> [109] "DADT(1) = K21 * A(2) - K12 * A(1) - K10 * A(1)"                                                                   
#> [110] "DADT(2) = -K21 * A(2) + K12 * A(1)"                                                                               
#> [111] "CPT = A(1) / S1"                                                                                                  
#> [112] ""                                                                                                                 
#> [113] "; PD model"                                                                                                       
#> [114] "DADT(5) = KTR * CPT - KTR * A(5) ; Transit compartment"                                                           
#> [115] "DADT(3) = KTR * A(5) - KTR * A(3) ; Effect compartment"                                                           
#> [116] "A5=A(5)"                                                                                                          
#> [117] "A3=A(3)"                                                                                                          
#> [118] ""                                                                                                                 
#> [119] "EDRUGT = ALPHA * A(3)"                                                                                            
#> [120] "HAZT = 0"                                                                                                         
#> [121] "IF(T > 0) HAZT = BETA * (EDRUGT**BETA) * (T**(BETA - 1)) * EXP(covar); WEIBULL (not defined at time zero)"        
#> [122] "DADT(4) = HAZT ; Cumulative Hazard"                                                                               
#> [123] "DADT(6) = CPT ; Cumulative AUC"                                                                                   
#> [124] "AUCT=A(6) ; AUC up to time T"                                                                                     
#> [125] "CAV=AUCT/T ; Average concentration up to time T"                                                                  
#> [126] ""                                                                                                                 
#> [127] "$ERROR"                                                                                                           
#> [128] "CP = A(1) / S1"                                                                                                   
#> [129] "EDRUG = ALPHA * A(3) ; Drug effect"                                                                               
#> [130] "HAZ = 0 ; redefine Hazard in $Error. Needed to compute pdf"                                                       
#> [131] "IF(TIME > 0) HAZ = BETA * (EDRUG**BETA) * (TIME**(BETA - 1)) * EXP(covar); WEIBULL"                               
#> [132] "SURV = EXP(-A(4)) ; Survival probability"                                                                         
#> [133] "PDF=SURV*HAZ"                                                                                                     
#> [134] ""                                                                                                                 
#> [135] ";Estimation (defined by sim start and end)"                                                                       
#> [136] ";Sim_start"                                                                                                       
#> [137] "IF(DV.EQ.0) THEN"                                                                                                 
#> [138] "Y=SURV"                                                                                                           
#> [139] "CHLAST=A(4)"                                                                                                      
#> [140] "ELSE"                                                                                                             
#> [141] "CHLAST=CHLAST ; Keep nmtran happy"                                                                                
#> [142] "ENDIF"                                                                                                            
#> [143] ""                                                                                                                 
#> [144] "IF(DV.EQ.1) THEN"                                                                                                 
#> [145] "Y=PDF ;pdf"                                                                                                       
#> [146] "ENDIF"                                                                                                            
#> [147] ";Sim_end"                                                                                                         
#> [148] ""                                                                                                                 
#> [149] ""                                                                                                                 
#> [150] ";Simulation"                                                                                                      
#> [151] "IF(ICALL.EQ.4) THEN"                                                                                              
#> [152] "IF (NEWIND.NE.2) CALL RANDOM (2,R) ; random uniform distribution"                                                 
#> [153] "DV=0 ; NO EVENT OCCURS"                                                                                           
#> [154] "RTTE=0 ; NO EVENT OCCURS"                                                                                         
#> [155] "IF(CENS.EQ.1) RTTE=1 ; RTTE set to 1 for censoring and event rows"                                                
#> [156] "IF(R.GT.SURV) THEN ; Event when R > SURV"                                                                         
#> [157] "DV=1 ; DV set to 1 at time of event"                                                                              
#> [158] "RTTE=1 ; RTTE set to 1 for censoring and event rows"                                                              
#> [159] "ENDIF"                                                                                                            
#> [160] "Y=DV"                                                                                                             
#> [161] "ENDIF"                                                                                                            
#> [162] ""                                                                                                                 
#> [163] ""                                                                                                                 
#> [164] "$THETA -4.53 ; 1 LOGKE0"                                                                                          
#> [165] "-9.69 ; 2 LOGALPHA"                                                                                               
#> [166] "-0.327 ; 3 LOGBETA"                                                                                               
#> [167] "0.0145 ; 4 BWT"                                                                                                   
#> [168] "0.434 ; 5 PPN 1/0"                                                                                                
#> [169] "$OMEGA 0 FIX"                                                                                                     
#> [170] ";Sim_start"                                                                                                       
#> [171] ";$SIGMA"                                                                                                          
#> [172] ";0 FIXED"                                                                                                         
#> [173] "$ESTIMATION MAXEVAL=9999 PRINT=1 LIKE METHOD=1 LAPLACE NUMERICAL"                                                 
#> [174] "NOABORT SIG=3"                                                                                                    
#> [175] ";$SIMULATION(123456) (23000 UNIFORM) ONLYSIM ; Uncomment this for VPC generation"                                 
#> [176] ""                                                                                                                 
#> [177] ";Sim_end"                                                                                                         
#> [178] "$COVARIANCE MATRIX=S UNCONDITIONAL"                                                                               
#> [179] "$TABLE TIME ID MID EVID AV_DOSE CAV AUCT CP A5 A3 HAZ SURV"                                                       
#> [180] "FORMAT=s1PE15.9 ONEHEADER NOPRINT FILE=HZtab202"                                                                  
#> [181] ""                                                                                                                 
#> [182] ""                                                                                                                 
#> 
nmlst(system.file("mods/DDMODEL00000301/run3.lst", package="nonmem2rx"))
#> $theta
#>  theta1  theta2  theta3  theta4  theta5  theta6  theta7  theta8  theta9 theta10 
#>   7.940   0.722  13.600   0.949   6.730   4.080   8.220  10.100   1.040 249.000 
#> 
#> $omega
#>       eta1 eta2 eta3  eta4
#> eta1 0.126 0.00 0.00 0.000
#> eta2 0.000 0.14 0.00 0.000
#> eta3 0.000 0.00 1.76 0.000
#> eta4 0.000 0.00 0.00 0.187
#> 
#> $sigma
#>       eps1  eps2  eps3
#> eps1 0.024 0.000 0.000
#> eps2 0.000 0.208 0.000
#> eps3 0.000 0.000 0.404
#> 
#> $cov
#> NULL
#> 
#> $objf
#> [1] 1488.719
#> 
#> $nobs
#> [1] 434
#> 
#> $nsub
#> [1] 60
#> 
#> $nmtran
#> [1] " WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1\n             \n (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION."
#> 
#> $termInfo
#> [1] "0MINIMIZATION SUCCESSFUL\n NO. OF FUNCTION EVALUATIONS USED:     1024\n NO. OF SIG. DIGITS IN FINAL EST.:  3.6"
#> 
#> $nonmem
#> [1] "7.3.0"
#> 
#> $time
#> [1] 41.6
#> 
#> $tere
#> [1] " Elapsed estimation time in seconds:    14.83\n Elapsed covariance time in seconds:    26.77"
#> 
#> $control
#>  [1] ";; 1. based on run1.mod "                                                                                        
#>  [2] ";; 2. Description: covariate model + WT on V2 + CPRED in pred3 ($TABLE)"                                         
#>  [3] ";; x1. Author: user"                                                                                             
#>  [4] "$PROBLEM    MEROPENEM IV INFUSION 3COMP DESCRIPTION PLASMA AND ELF"                                              
#>  [5] ";           CONCENTRATIONS FINAL COV MODEL"                                                                      
#>  [6] ""                                                                                                                
#>  [7] "; ------------dataset------------"                                                                               
#>  [8] "$INPUT      ID AGE WT GFRC GFR DV TIME MDV CMT AMT RATE SS II EVID GRP"                                          
#>  [9] "; WT [kg], GFRC [0: poor hepatic function, 1: good hepatic function], "                                          
#> [10] "; GFR [mL/min], DV [mg/L], TIME [h], CMT [1: plasma conc., 2: ELF conc],"                                        
#> [11] "; AMT (DOSE) [g], RATE (K) [g/h], II (T) [h], GRP=AMT/RATE (delta) [h]"                                          
#> [12] ""                                                                                                                
#> [13] "; CL [L/h], V1 V2 V3 [L], Q2 Q3 [L/h], S1 S2 [L]"                                                                
#> [14] "$DATA      promessePK1.csv IGNORE=@"                                                                             
#> [15] ""                                                                                                                
#> [16] "; ------------model------------"                                                                                 
#> [17] "$SUBROUTINE ADVAN11 TRANS4"                                                                                      
#> [18] "$PK    "                                                                                                         
#> [19] "    ; parmacokinetic parameters"                                                                                 
#> [20] "\tTVCL=THETA(1)*((GFR/65)**THETA(2)) ; CENTRAL"                                                                  
#> [21] "\tTVV1=THETA(3)*((WT/75)**THETA(4))"                                                                             
#> [22] "    TVQ2=THETA(5)                      ; ELF"                                                                    
#> [23] "\tTVV2=THETA(6)*((WT/75)**THETA(9))"                                                                             
#> [24] "\tTVQ3=THETA(7)                      ; PERIPHERAL"                                                               
#> [25] "\tTVV3=THETA(8)"                                                                                                 
#> [26] ""                                                                                                                
#> [27] "\t; interindividual variance model"                                                                              
#> [28] "\tCL=TVCL*EXP(ETA(1))"                                                                                           
#> [29] "\tV1=TVV1*EXP(ETA(2))"                                                                                           
#> [30] "\tQ2=TVQ2"                                                                                                       
#> [31] "\tV2=TVV2*EXP(ETA(3))"                                                                                           
#> [32] "\tQ3=TVQ3*EXP(ETA(4))"                                                                                           
#> [33] "\tV3=TVV3 "                                                                                                      
#> [34] ""                                                                                                                
#> [35] "\t; scaling factor"                                                                                              
#> [36] "\tS1=V1/1000 ; dose [g] and conc. [mg/L]"                                                                        
#> [37] "\tS2=V2/THETA(10)"                                                                                               
#> [38] ""                                                                                                                
#> [39] ""                                                                                                                
#> [40] ""                                                                                                                
#> [41] ""                                                                                                                
#> [42] "$ERROR  "                                                                                                        
#> [43] "; calcultate de result (i.e. model prediction) "                                                                 
#> [44] "\tH1=0"                                                                                                          
#> [45] "\tH2=0"                                                                                                          
#> [46] "\tIF(CMT.EQ.1) H1=1"                                                                                             
#> [47] "\tIF(CMT.EQ.2) H2=1"                                                                                             
#> [48] "\tY=H1*(F*(1+EPS(1))+EPS(2))+H2*(F*(1+EPS(3)))   ; +EPS(4)"                                                      
#> [49] "\tW=F"                                                                                                           
#> [50] "\t"                                                                                                              
#> [51] "\tIPRED=F ; prediction individuelle "                                                                            
#> [52] "\tIRES=DV-IPRED ; (individual-specific residual) "                                                               
#> [53] "\tIWRES=IRES/W ;  (individual-specific weighted residual)"                                                       
#> [54] "\t"                                                                                                              
#> [55] ""                                                                                                                
#> [56] ""                                                                                                                
#> [57] "; Initial estimates"                                                                                             
#> [58] "$THETA  (0,9.81355436018442) ; CL"                                                                               
#> [59] "$THETA  0.653109400662184    ; GFRCL"                                                                            
#> [60] "$THETA  (0,4.53480721643241) ; V1"                                                                               
#> [61] "$THETA  1.12475365584077     ; WTV1"                                                                             
#> [62] "$THETA  (0,11.7186301905937) ; Q2; ELF"                                                                          
#> [63] "$THETA  (0,9.69726252224871) ; V2"                                                                               
#> [64] "$THETA  (0,8.41511798967717) ; Q3; PERIPHERAL"                                                                   
#> [65] "$THETA  (0,10.8162112974179) ; V3"                                                                               
#> [66] "$THETA  0.805863122538834    ; WTV2"                                                                             
#> [67] "$THETA  231.229833848399     ; V2/S2"                                                                            
#> [68] "$OMEGA  BLOCK(4)"                                                                                                
#> [69] " 0.19808195049767  ;      IIVCL"                                                                                 
#> [70] " 0 0.195893036337555  ;      IIVV1"                                                                              
#> [71] " 0 0 0.184676645216004  ;      IIVV2"                                                                            
#> [72] " 0 0 0 0.181094660002612  ;      IIVQ3"                                                                          
#> [73] "$SIGMA  0.0198701414556805  ;   epsPROP1"                                                                        
#> [74] " 0.203004721167207  ;    epsADD1"                                                                                
#> [75] " 0.501989282726501  ;   epsPROP2"                                                                                
#> [76] "$ESTIMATION METHOD=1 INTER MAXEVAL=9999 SIGDIGITS=3 POSTHOC PRINT=5 ; PRINT=1 ; "                                
#> [77] ""                                                                                                                
#> [78] "; precision des estimation? standard error of estimates & matrice de correlation"                                
#> [79] "$COVARIANCE PRINT=E  "                                                                                           
#> [80] ""                                                                                                                
#> [81] ""                                                                                                                
#> [82] "$TABLE      ID AGE WT GFRC GFR TIME MDV CMT RATE PRED CPRED RES WRES"                                            
#> [83] "            IPRED IRES IWRES CWRES EVID NOPRINT FILE=pred3 ; population and individual predictions and residuals"
#> [84] "$TABLE      ID AGE WT GFRC GFR CL V1 Q2 V2 Q3 V3 ETA(1) ETA(2) ETA(3)"                                           
#> [85] "            ETA(4) TVCL TVV1 TVQ2 TVV2 TVQ3 TVV3 NOPRINT NOAPPEND"                                               
#> [86] "            FIRSTONLY FILE=param3 ; individual PK parameters (bayesiens,posthoc)"                                
#> [87] ""                                                                                                                
#> [88] ""                                                                                                                
#> 
nmlst(system.file("mods/cpt/runODE032.res", package="nonmem2rx"))
#> $theta
#> theta1 theta2 theta3 theta4 theta5 
#>  1.370  4.200  1.380  3.880  0.196 
#> 
#> $omega
#>       eta1   eta2  eta3  eta4
#> eta1 0.101 0.0000 0.000 0.000
#> eta2 0.000 0.0994 0.000 0.000
#> eta3 0.000 0.0000 0.101 0.000
#> eta4 0.000 0.0000 0.000 0.073
#> 
#> $sigma
#>      eps1
#> eps1    1
#> 
#> $cov
#>             theta1    theta2    theta3    theta4    theta5      eta1 omega1.2
#> theta1    8.88e-04 -1.06e-04  1.84e-04 -1.20e-04  5.28e-08 -4.71e-05        0
#> theta2   -1.06e-04  8.71e-04 -1.06e-04 -5.07e-05 -1.57e-05  4.70e-05        0
#> theta3    1.84e-04 -1.06e-04  2.99e-03  1.65e-04  5.99e-06 -3.64e-05        0
#> theta4   -1.20e-04 -5.07e-05  1.65e-04  1.21e-03 -2.54e-05  2.55e-05        0
#> theta5    5.28e-08 -1.57e-05  5.99e-06 -2.54e-05  9.94e-06 -8.17e-06        0
#> eta1     -4.71e-05  4.70e-05 -3.64e-05  2.55e-05 -8.17e-06  1.69e-04        0
#> omega1.2  0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00        0
#> omega1.3  0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00        0
#> omega1.4  0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00        0
#> eta2     -7.37e-05  2.57e-05 -8.08e-05  1.37e-05 -4.37e-06  8.75e-06        0
#> omega2.3  0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00        0
#> omega2.4  0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00        0
#> eta3      6.63e-05 -8.19e-05  5.49e-04  1.68e-04  1.59e-06  3.49e-05        0
#> omega3.4  0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00        0
#> eta4     -9.50e-06  1.10e-04 -3.07e-04 -9.13e-05  3.19e-06  1.37e-05        0
#> eps1      0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00  0.00e+00        0
#>          omega1.3 omega1.4      eta2 omega2.3 omega2.4      eta3 omega3.4
#> theta1          0        0 -7.37e-05        0        0  6.63e-05        0
#> theta2          0        0  2.57e-05        0        0 -8.19e-05        0
#> theta3          0        0 -8.08e-05        0        0  5.49e-04        0
#> theta4          0        0  1.37e-05        0        0  1.68e-04        0
#> theta5          0        0 -4.37e-06        0        0  1.59e-06        0
#> eta1            0        0  8.75e-06        0        0  3.49e-05        0
#> omega1.2        0        0  0.00e+00        0        0  0.00e+00        0
#> omega1.3        0        0  0.00e+00        0        0  0.00e+00        0
#> omega1.4        0        0  0.00e+00        0        0  0.00e+00        0
#> eta2            0        0  1.51e-04        0        0  4.32e-07        0
#> omega2.3        0        0  0.00e+00        0        0  0.00e+00        0
#> omega2.4        0        0  0.00e+00        0        0  0.00e+00        0
#> eta3            0        0  4.32e-07        0        0  9.59e-04        0
#> omega3.4        0        0  0.00e+00        0        0  0.00e+00        0
#> eta4            0        0 -1.95e-05        0        0 -1.30e-04        0
#> eps1            0        0  0.00e+00        0        0  0.00e+00        0
#>               eta4 eps1
#> theta1   -9.50e-06    0
#> theta2    1.10e-04    0
#> theta3   -3.07e-04    0
#> theta4   -9.13e-05    0
#> theta5    3.19e-06    0
#> eta1      1.37e-05    0
#> omega1.2  0.00e+00    0
#> omega1.3  0.00e+00    0
#> omega1.4  0.00e+00    0
#> eta2     -1.95e-05    0
#> omega2.3  0.00e+00    0
#> omega2.4  0.00e+00    0
#> eta3     -1.30e-04    0
#> omega3.4  0.00e+00    0
#> eta4      5.10e-04    0
#> eps1      0.00e+00    0
#> 
#> $objf
#> [1] 20167.64
#> 
#> $nobs
#> [1] 2280
#> 
#> $nsub
#> [1] 120
#> 
#> $nmtran
#> NULL
#> 
#> $termInfo
#> [1] "0MINIMIZATION SUCCESSFUL\n NO. OF FUNCTION EVALUATIONS USED:      320\n NO. OF SIG. DIGITS IN FINAL EST.:  2.5"
#> 
#> $nonmem
#> [1] "7.4.3"
#> 
#> $time
#> [1] 100.76
#> 
#> $tere
#> [1] " Elapsed estimation  time in seconds:    71.95\n Elapsed covariance  time in seconds:    28.38\n Elapsed postprocess time in seconds:     0.43"
#> 
#> $control
#> NULL
#> 
```
