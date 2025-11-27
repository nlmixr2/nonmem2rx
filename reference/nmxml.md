# Read a nonmem xml and create output similar to the `nmlst()`

Read a nonmem xml and create output similar to the [`nmlst()`](nmlst.md)

## Usage

``` r
nmxml(xml)
```

## Arguments

- xml:

  xml file

## Value

list of nonmem information

## Author

Matthew L. Fidler

## Examples

``` r
nmxml(system.file("mods/cpt/runODE032.xml", package="nonmem2rx"))
#> $theta
#>    theta1    theta2    theta3    theta4    theta5 
#> 1.3703404 4.1981491 1.3800349 3.8765734 0.1964461 
#> 
#> $omega
#>           eta1       eta2      eta3       eta4
#> eta1 0.1012514 0.00000000 0.0000000 0.00000000
#> eta2 0.0000000 0.09938724 0.0000000 0.00000000
#> eta3 0.0000000 0.00000000 0.1013027 0.00000000
#> eta4 0.0000000 0.00000000 0.0000000 0.07304975
#> 
#> $sigma
#> NULL
#> 
#> $cov
#>                  theta1        theta2        theta3        theta4        theta5
#> theta1     8.876810e-04 -1.055098e-04  1.844162e-04 -1.202337e-04  5.278300e-08
#> theta2    -1.055098e-04  8.714095e-04 -1.061946e-04 -5.066632e-05 -1.565618e-05
#> theta3     1.844162e-04 -1.061946e-04  2.993363e-03  1.652516e-04  5.993313e-06
#> theta4    -1.202337e-04 -5.066632e-05  1.652516e-04  1.213465e-03 -2.539912e-05
#> theta5     5.278300e-08 -1.565618e-05  5.993313e-06 -2.539912e-05  9.942182e-06
#> eta1      -4.712728e-05  4.696667e-05 -3.642709e-05  2.547962e-05 -8.168847e-06
#> omega.1.2  0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00
#> omega.1.3  0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00
#> omega.1.4  0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00
#> eta2      -7.371560e-05  2.566338e-05 -8.083493e-05  1.369999e-05 -4.365635e-06
#> omega.2.3  0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00
#> omega.2.4  0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00
#> eta3       6.633832e-05 -8.190016e-05  5.489848e-04  1.683555e-04  1.591222e-06
#> omega.3.4  0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00
#> eta4      -9.496613e-06  1.101079e-04 -3.065372e-04 -9.128974e-05  3.187703e-06
#> eps1       0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00  0.000000e+00
#>                    eta1 omega.1.2 omega.1.3 omega.1.4          eta2 omega.2.3
#> theta1    -4.712728e-05         0         0         0 -7.371560e-05         0
#> theta2     4.696667e-05         0         0         0  2.566338e-05         0
#> theta3    -3.642709e-05         0         0         0 -8.083493e-05         0
#> theta4     2.547962e-05         0         0         0  1.369999e-05         0
#> theta5    -8.168847e-06         0         0         0 -4.365635e-06         0
#> eta1       1.692964e-04         0         0         0  8.751806e-06         0
#> omega.1.2  0.000000e+00         0         0         0  0.000000e+00         0
#> omega.1.3  0.000000e+00         0         0         0  0.000000e+00         0
#> omega.1.4  0.000000e+00         0         0         0  0.000000e+00         0
#> eta2       8.751806e-06         0         0         0  1.512503e-04         0
#> omega.2.3  0.000000e+00         0         0         0  0.000000e+00         0
#> omega.2.4  0.000000e+00         0         0         0  0.000000e+00         0
#> eta3       3.487139e-05         0         0         0  4.315929e-07         0
#> omega.3.4  0.000000e+00         0         0         0  0.000000e+00         0
#> eta4       1.366281e-05         0         0         0 -1.950959e-05         0
#> eps1       0.000000e+00         0         0         0  0.000000e+00         0
#>           omega.2.4          eta3 omega.3.4          eta4 eps1
#> theta1            0  6.633832e-05         0 -9.496613e-06    0
#> theta2            0 -8.190016e-05         0  1.101079e-04    0
#> theta3            0  5.489848e-04         0 -3.065372e-04    0
#> theta4            0  1.683555e-04         0 -9.128974e-05    0
#> theta5            0  1.591222e-06         0  3.187703e-06    0
#> eta1              0  3.487139e-05         0  1.366281e-05    0
#> omega.1.2         0  0.000000e+00         0  0.000000e+00    0
#> omega.1.3         0  0.000000e+00         0  0.000000e+00    0
#> omega.1.4         0  0.000000e+00         0  0.000000e+00    0
#> eta2              0  4.315929e-07         0 -1.950959e-05    0
#> omega.2.3         0  0.000000e+00         0  0.000000e+00    0
#> omega.2.4         0  0.000000e+00         0  0.000000e+00    0
#> eta3              0  9.590290e-04         0 -1.297699e-04    0
#> omega.3.4         0  0.000000e+00         0  0.000000e+00    0
#> eta4              0 -1.297699e-04         0  5.101895e-04    0
#> eps1              0  0.000000e+00         0  0.000000e+00    0
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
#> [1] "\n\n WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1\n\n (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.\n"
#> 
#> $nonmem
#> [1] "7.4.3"
#> 
#> $termInfo
#> [1] "\n0MINIMIZATION SUCCESSFUL\n NO. OF FUNCTION EVALUATIONS USED:      320\n NO. OF SIG. DIGITS IN FINAL EST.:  2.5\n"
#> 
#> $time
#> [1] 100.95
#> 
#> $control
#>  [1] ""                                                                                   
#>  [2] "$PROB    BOLUS_2CPT_CLV1QV2 SINGLE DOSE FOCEI (120 Ind/2280 Obs) runODE032"         
#>  [3] "$INPUT   ID TIME DV LNDV MDV AMT EVID DOSE V1I CLI QI V2I SSX IIX SD CMT"           
#>  [4] "$DATA    BOLUS_2CPT.csv IGNORE=@ IGNORE (SD.EQ.0)"                                  
#>  [5] "$SUBR    ADVAN13 TOL=6"                                                             
#>  [6] "$MODEL"                                                                             
#>  [7] "         COMP=(CENTRAL,DEFOBS,DEFDOSE)"                                             
#>  [8] "         COMP=(PERI)"                                                               
#>  [9] "$PK"                                                                                
#> [10] "         CL=EXP(THETA(1)+ETA(1))"                                                   
#> [11] "         V=EXP(THETA(2)+ETA(2))"                                                    
#> [12] "         Q=EXP(THETA(3)+ETA(3))"                                                    
#> [13] "         V2=EXP(THETA(4)+ETA(4))"                                                   
#> [14] "         V1=V"                                                                      
#> [15] "         S1=V"                                                                      
#> [16] "\t\t K21=Q/V2"                                                                      
#> [17] "\t\t K12=Q/V"                                                                       
#> [18] "$DES"                                                                               
#> [19] "         DADT(1)= K21*A(2)-K12*A(1)-CL*A(1)/V1"                                     
#> [20] "         DADT(2)=-K21*A(2)+K12*A(1)  \t\t"                                          
#> [21] "$ERROR"                                                                             
#> [22] "         IPRED = F"                                                                 
#> [23] "         RESCV = THETA(5)"                                                          
#> [24] "         W     = IPRED*RESCV"                                                       
#> [25] "         IRES  = DV-IPRED"                                                          
#> [26] "         IWRES = IRES/W"                                                            
#> [27] "         Y     = IPRED+W*EPS(1)"                                                    
#> [28] "$THETA   1.6       ;log Cl"                                                         
#> [29] "$THETA   4.5       ;log Vc"                                                         
#> [30] "$THETA   1.6       ;log Q"                                                          
#> [31] "$THETA   4         ;log Vp"                                                         
#> [32] "$THETA   (0,0.3,1) ;RSV"                                                            
#> [33] "$OMEGA   0.15 0.15 0.15 0.15"                                                       
#> [34] "$SIGMA   1 FIX"                                                                     
#> [35] "$EST     NSIG=2 SIGL=6 PRINT=5 MAX=9999 NOABORT POSTHOC METHOD=COND INTER NOOBT"    
#> [36] "$COV"                                                                               
#> [37] "$TABLE  ID TIME LNDV MDV AMT EVID DOSE V1I CLI QI V2I CL V Q V2 ETA1 ETA2 ETA3 ETA4"
#> [38] "        IPRED IRES IWRES CWRESI"                                                    
#> [39] "        ONEHEADER NOPRINT FILE=runODE032.csv"                                       
#> 
```
