$PROB Phase IIa Study, One Compartment Model 504.ctl
; Place column names of data file here:
$INPUT C ID TIME DV AMT RATE WT AGE SEX 
$DATA 501.csv IGNORE=C ; Ignore records beginning with letter C
; Select One compartment model ADVAN1, Parameterization TRANS2 (CL, V)
$SUBROUTINE ADVAN1 TRANS2 
; Section to define PK parameters, relationship to fixed effects THETA
; and inter-subject random effects ETA.
$PK 
; Define typical values
  TVCL=THETA(1)*(WT/70)**THETA(3)*(AGE/50)**THETA(5)*THETA(7)**SEX
  TVV= THETA(2)*(WT/70)**THETA(4)*(AGE/50)**THETA(6)*THETA(8)**SEX
  CL=TVCL*EXP(ETA(1))
  V=TVV*EXP(ETA(2))
  S1=V
$THETA ; Enter initial starting values for THETAS
  (0,4)  ;[CL]
  (0,30) ;[V]
  0.8    ;[CL~WT]
  0.8    ;[V~WT]
  -0.1   ;[CL~AGE]
  0.1    ;[V~AGE]
  0.7    ;[CL~SEX]
  0.7    ;[V~SEX]

; Section to relate predicted function F and residual error
; relationship to data DV.  EPS are random error coefficients
$ERROR 
  Y=F*(1+EPS(1))
$OMEGA BLOCK(2) ; Initial OMEGA values in lower triangular format
  0.1         ;[P]
  0.001 0.1   ;[P]
$SIGMA ; Initial SIGMA
  0.04        ;[P]

;FOCEI is selected
$EST METHOD=COND INTERACTION MAXEVAL=9999 PRINT=5 NOABORT 
; Evaluate variance-covariance of estimates
$COV UNCONDITIONAL MATRIX=R PRINT=E
; Print out individual predicted results and diagnostics
; to file 504.tab
; Various parameters and built in diagnostics may be printed.
; DV=DEPENDENT VARIABLE
; CIPRED=individual predicted function, f(eta_hat), at mode of
; posterior density
; CIRES=DV-F(ETA_HAT)
; CIWRES=conditional individual residual
; (DV-F(ETA_HAT)/SQRT(SIGMA(1,1)*F(ETA_HAT))
; PRED=Population Predicted value F(ETA=0)
; CWRES=Population weighted Residual
; Note numerical Format may be specified for table outputs
$TABLE ID TIME DV CIPRED CIRES CIWRES PRED RES CWRES CL V ETA1 ETA2
       NOPRINT NOAPPEND ONEHEADER FORMAT=,1PE13.6 FILE=504.tab
