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

