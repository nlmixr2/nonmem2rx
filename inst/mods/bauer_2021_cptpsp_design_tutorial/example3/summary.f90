      PROGRAM summary
      IMPLICIT REAL*8 (A-H,O,R,T-Z)
      IMPLICIT CHARACTER*2048 (S)
      INTEGER, PARAMETER :: MAXROWS=20, MAXCOLS=20, MAXSAMPLES=3000
      character*20 sform,SHEAD(30)
      character*80 sform2
      character*40 sitem(MAXCOLS)
      character*20 sname(MAXCOLS)
      real*8 ditem(MAXROWS,MAXCOLS),ditem2(MAXROWS,MAXCOLS),dlow(MAXROWS,MAXCOLS), &
             dhigh(MAXROWS,MAXCOLS),dnn(MAXROWS,MAXCOLS),DQUANT(30),DQVAL(30)
             REAL*8 DDITEM(MAXSAMPLES,MAXROWS,MAXCOLS)
      integer jo(MAXSAMPLES),ko(MAXSAMPLES)
      integer nform
      DQUANT(1)=0.001D+00
      DQUANT(2)=0.0025D+00
      DQUANT(3)=0.005D+00
      DQUANT(4)=0.0075D+00
      DQUANT(5)=0.01D+00
      DQUANT(6)=0.025D+00
      DQUANT(7)=0.05D+00
      DQUANT(8)=0.075D+00
      DQUANT(9)=0.10D+00
      DQUANT(10)=0.20D+00
      DQUANT(11)=0.25D+00
      DQUANT(12)=0.5D+00
      DQUANT(13)=0.75D+00
      DQUANT(14)=0.80D+00
      DQUANT(15)=0.90D+00
      DQUANT(16)=0.925D+00
      DQUANT(17)=0.95D+00
      DQUANT(18)=0.975D+00
      DQUANT(19)=0.99D+00
      DQUANT(20)=0.9925D+00
      DQUANT(21)=0.995D+00
      DQUANT(22)=0.9975D+00
      DQUANT(23)=0.999D+00
      NQUANT=23
      SHEAD(1)='Row'
      SHEAD(2)='Mean'
      shead(3)='STD'
      shead(4)='RSTD'
      shead(5)='Low'
      shead(6)='High'
      DO I=1,NQUANT
        DVAL=DQUANT(I)*100.0D+00
        WRITE(shead(I+6),'((F5.2),A1)') DVAL,'%'
      ENDDO
      CALL GETARG(1,sfil1)
      CALL GETARG(2,sfil2)
      open(unit=2,file=trim(sfil1))
      open(unit=3,file=trim(sfil2))
      CALL GETARG(3,sform)      
      if(sform==' ') sform='1X,1PG12.5'
      dval=-1.0D-05
      sformz='('//trim(sform)//')'
      write(snum,sformz) dval
      nform=len_trim(snum)
      irows=0
      nrows=0
      ncols=0
      ditem=0.0d+00
      ditem2=0.0d+00
      dlow=1.0d+300
      dhigh=-1.0d+300
  1   continue
      read(2,'(A)',end=10) s
      call caps(s)
      call squeeze(s)
      nl=len_trim(s)
      do i=1,nl
      if(s(i:i)==',') s(i:i)=' '
      enddo      
      item=0
      ipre=0
      do i=1,nl+1
      if(s(i:i)==' ') then
      item=item+1
      sitem(item)=s(ipre+1:i-1)
      ipre=i
      endif
      enddo
      if(iread_Double(sitem(1),dval)/=0) then
        ncols=item
        irows=0
        do i=1,ncols
          sname(i)=sitem(i)
        enddo
        go to 1
      endif
      irows=irows+1
      if(irows>nrows) nrows=irows
      do i=1,ncols
        ival=iread_Double(sitem(i),dval)
        if(ival/=0) cycle
        dnn(irows,i)=dnn(irows,i)+1.0d+00
        NN=dnn(irows,i)
        DDITEM(NN,IROWS,I)=DVAL
        ditem(irows,i)=ditem(irows,i)+dval
        ditem2(irows,i)=ditem2(irows,i)+dval*dval
        if(dval<dlow(irows,i))  dlow(irows,i)=dval
        if(dval>dhigh(irows,i)) dhigh(irows,i)=dval
      enddo

      go to 1
 10   continue      
      do j=1,ncols
      write(3,'(A)') trim(sname(j))//':'

      sheads=' '
      npos=0
      do i=1,nquant+6
      sheads(npos+1:)=shead(i)
      if(i>1) then
        npos=npos+nform
      else
        npos=npos+8
      endif
      enddo      
      write(3,'(A)') trim(sheads)
      do i=1,nrows
      dn=dnn(i,j)
      dmean=ditem(i,j)/dn
      dss=ditem2(i,j)-dn*dmean*dmean
      dstd=dsqrt(dss/(dn-1.0d+00))
      if(dmean/=0.0) then
      rdstd=dabs(100.0d+00*dstd/dmean)
      else
      rdstd=dstd
      endif
      NN=DN
      DQVAL(1:30)=0.0D+00
      IMODE=1
      IF(DSTD>0.0D+00) THEN
        CALL DSORT(DDITEM(1,I,J),JO, KO, NN, 2)
        DO L=1,NQUANT
          CALL QUANT_INTERPOLATE(DQUANT(L),DDITEM(1,I,J),NN,IMODE,DQVAL(L))
        ENDDO
      ENDIF
      sform2='(I6,40('//trim(SFORM)//'))'
      write(3,sform2) i,dmean,dstd,rdstd,dlow(i,j),dhigh(i,J),(dqval(l),l=1,nquant)
      enddo
      enddo
      stop
      end
      SUBROUTINE QUANT_INTERPOLATE(DQUANT,YY,N,IMODE,QVAL)
      IMPLICIT NONE
      REAL*8 YY(*),X,X1,X2,Y,Y1,Y2,DNN,DQUANT,QVAL,YINT,SLOPE,DINVNORM
      INTEGER N,IMODE,NN,NPOS
      NN=N+1
      DNN=NN
      X=DQUANT
      NPOS=X*NN
      IF(NPOS<1) THEN
        NPOS=1
        X1=NPOS/DNN
        Y1=YY(NPOS)
        NPOS=NPOS+1
        X2=NPOS/DNN
        Y2=YY(NPOS)
      ELSE IF (NPOS>N-1) THEN
        NPOS=N
        X1=NPOS/DNN
        Y1=YY(NPOS)
        NPOS=NPOS-1
        X2=NPOS/DNN
        Y2=YY(NPOS)
      ELSE
        X1=NPOS/DNN
        Y1=YY(NPOS)
        NPOS=NPOS+1
        X2=NPOS/DNN
        Y2=YY(NPOS)
      ENDIF
      IF(IMODE==1) THEN
        X=DINVNORM(X)
        X1=DINVNORM(X1)
        X2=DINVNORM(X2)
!        X=DSQRT(-2.0D+00*DLOG(X))
!        X1=DSQRT(-2.0D+00*DLOG(X1))
!        X2=DSQRT(-2.0D+00*DLOG(X2))
      ENDIF
      YINT=Y1
      IF(X2/=X1) THEN
      SLOPE=(Y2-Y1)/(X2-X1)
      ELSE
      SLOPE=0.0D+00
      ENDIF
      QVAL=YINT+SLOPE*(X-X1)
      return
      END SUBROUTINE QUANT_INTERPOLATE      
      SUBROUTINE SQUEEZE(S)
!
      IMPLICIT NONE
!
      CHARACTER(LEN=*), INTENT(IN OUT) :: S
!
!------------------------------------------------------------------------------------
! Local variables
!
      INTEGER :: I,ISPACE,J
!
      J=0; ISPACE=1
      DO I=1,LEN_TRIM(S)        ! Identify and remove leading and redundant spaces
        IF(S(I:I) == CHAR(9)) S(I:I)=' '
        IF (S(I:I) == ' ' .AND. ISPACE == 1) CYCLE
        IF (S(I:I) /= ' ') ISPACE=0
        IF (S(I:I) == ' ') ISPACE=1
        J=J+1; S(J:J)=S(I:I)
      END DO
      S(J+1:)=' '
!
  999 RETURN
!
      END SUBROUTINE SQUEEZE
      FUNCTION IREAD_DOUBLE(S2,I)
!
!
      IMPLICIT NONE
!
      REAL*8, INTENT(OUT) :: I
!
      CHARACTER(LEN=*),  INTENT(IN)  :: S2
!
!------------------------------------------------------------------------------------
!
! Local Variables
!
      INTEGER :: IREAD_DOUBLE
!
      CHARACTER(LEN=40)   :: S
!
      I=0.0D+00
      IF (LEN_TRIM(S2) == 0) GO TO 50
!      
      IF (S2(1:1) /= 'e' .AND. S2(1:1) /= 'E') THEN
        S=S2
        IF (LEN_TRIM(S) > 30) GO TO 50
! Adds a period to any number text that is supposed to be formatted as REAL.
        CALL PERIOD_ADD2(S)
        IREAD_DOUBLE=0
        READ(S,90,ERR=50) I
        GO TO 999
      END IF
!      
   50 IREAD_DOUBLE=1
!
   90 FORMAT(D30.23)
!
  999 RETURN
!
      END FUNCTION IREAD_DOUBLE
      SUBROUTINE PERIOD_ADD2(S)
!

      IMPLICIT NONE
!
      CHARACTER (LEN=*), INTENT(IN OUT) :: S
!
!------------------------------------------------------------------------------------
!
! Local Variables
!
      INTEGER :: I,LELOC,LPER,NZ
!
      NZ=LEN_TRIM(S)
      IF (NZ /= 0 .AND. NZ < LEN(S)) THEN
        LELOC=INDEX(S,'E')+INDEX(S,'E')
        LPER=INDEX(S,'.')
!
        IF (LPER == 0) THEN
          IF (LELOC == 0) THEN
            S(NZ+1:NZ+1)='.'
          ELSE
            DO I=NZ,LELOC,-1
              S(I+1:I+1)=S(I:I)
            END DO
            S(LELOC:LELOC)='.'
          END IF
        END IF
      END IF  
!
  999 RETURN
!
      END SUBROUTINE PERIOD_ADD2

      INTEGER FUNCTION RINDEX2(S1,S2)
      CHARACTER*(*) S1,S2     
!
!------------------------------------------------------------------------------------
!      
      N1=LEN(S1)
      N2=LEN(S2)
      RINDEX2=0
      DO I=N1-N2+1,1,-1
        IF(S1(I:I+N2-1) == S2)THEN
          RINDEX2=I
          GO TO 999
        ENDIF
      ENDDO
!      
  999 RETURN
!      
      END FUNCTION RINDEX2
      SUBROUTINE CAPS(S)
!
!
      IMPLICIT NONE
!
      CHARACTER(LEN=*), INTENT(IN OUT) :: S
!
!------------------------------------------------------------------------------------
!
! Local Variables
!
      INTEGER  :: I,IL,NL,IQUOTE,IDQUOTE,NLEN,ICONTINUE
!
      NL=LEN_TRIM(S)
!
      DO I=1,NL
        IL=ICHAR(S(I:I))
        IF (IL < 97 .OR. IL > 122) CYCLE
        IL=IL-32
        S(I:I)=CHAR(IL)
      END DO
!
  999 RETURN
!
      END SUBROUTINE CAPS

      SUBROUTINE DSORT(DX, JO, KO, N, KFLAG)
!      

      IMPLICIT NONE
!
      INTEGER, INTENT(IN)     :: KFLAG, N      ! Scalar Arguments
      REAL*8, INTENT(IN OUT) :: DX(N)
      INTEGER JO(N),KO(N)  ! Array Arguments; * replace by N (DZD)
!
!------------------------------------------------------------------------------------
!***BEGIN PROLOGUE  DSORT
!***PURPOSE  Sort an array and optionally make the same interchanges in
!            an auxiliary array.  The array may be sorted in increasing
!            or decreasing order.  A slightly modified QUICKSORT
!            algorithm is used.
!***LIBRARY   SLATEC
!***CATEGORY  N6A2B
!***TYPE      DOUBLE PRECISION (SSORT-S, DSORT-D, ISORT-I)
!***KEYWORDS  SINGLETON QUICKSORT, SORT, SORTING
!***AUTHOR  Jones, R. E., (SNLA)
!           Wisniewski, J. A., (SNLA)
!***DESCRIPTION
!
!   DSORT sorts array DX and optionally makes the same interchanges in
!   array JO.  The array DX may be sorted in increasing order or
!   decreasing order.  A slightly modified quicksort algorithm is used.
!
!   Description of Parameters
!      DX - array of values to be sorted   (usually abscissas)
!      JO - array to be (optionally) carried along
!      N  - number of values in array DX to be sorted
!      KFLAG - control parameter
!            =  2  means sort DX in increasing order and carry JO along.
!            =  1  means sort DX in increasing order (ignoring JO)
!            = -1  means sort DX in decreasing order (ignoring JO)
!            = -2  means sort DX in decreasing order and carry JO along.
!
!***REFERENCES  R. C. Singleton, Algorithm 347, An efficient algorithm
!                 for sorting with minimal storage, Communications of
!                 the ACM, 12, 3 (1969), pp. 185-187.
!
!***REVISION HISTORY  (YYMMDD)
!   761101  DATE WRITTEN
!   761118  Modified to use the Singleton quicksort algorithm.  (JAW)
!   890531  Changed all specific intrinsics to generic.  (WRB)
!   890831  Modified array declarations.  (WRB)
!   891009  Removed unreferenced statement labels.  (WRB)
!   891024  Changed category.  (WRB)
!   891024  REVISION DATE from Version 3.2
!   891214  Prologue converted to Version 4.0 format.  (BAB)
!   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
!   901012  Declared all variables; changed X,Y to DX,JO; changed
!           code to parallel SSORT. (M. McClain)
!   920501  Reformatted the REFERENCES section.  (DWL, WRB)
!   920519  Clarified error messages.  (DWL)
!   920801  Declarations section rebuilt and code restructured to use
!           IF-THEN-ELSE-ENDIF.  (RWC, WRB)
!   960402  Modified for Adapt by removing error checking. Also replace
!           * by N in dimension statement.   (DZD)
!***END PROLOGUE  DSORT
!------------------------------------------------------------------------------------
!
! Local variables
!
      INTEGER :: I, IJ, J, K, KK, L, M, NN     ! Local Scalars
      INTEGER :: IL(100), IU(100)              ! Local Arrays
!
      REAL*8   :: R, T, TT, TTY, TY             ! Local Scalars
!
      INTRINSIC :: ABS, INT                                ! Intrinsic Functions
!
      NN=N
      DO I=1,NN
        JO(I)=I
      ENDDO
      KK=ABS(KFLAG)
!
! Alter array DX to get decreasing order if needed
      IF (KFLAG <= -1) THEN
        DO I=1,NN
          DX(I)=-DX(I)
        END DO
      END IF
!
!      IF (KK == 2) GO TO 100
      IF (KK /= 2) THEN
! Sort DX only
        M=1
        I=1
        J=NN
        R=0.375D0
!
   20   IF (I == J) GO TO 60
        IF (R <= 0.5898437D0) THEN
          R=R+3.90625D-2
        ELSE
          R=R-0.21875D0
        END IF
!
   30   K=I
!
! Select a central element of the array and save it in location T
        IJ=I+INT((J-I)*R)
        T=DX(IJ)
!
! If first element of array is greater than T, interchange with T
        IF (DX(I) > T) THEN
          DX(IJ)=DX(I)
          DX(I)=T
          T=DX(IJ)
        END IF
        L=J
!
! If last element of array is less than than T, interchange with T
        IF (DX(J) < T) THEN
          DX(IJ)=DX(J)
          DX(J)=T
          T=DX(IJ)
! If first element of array is greater than T, interchange with T
          IF (DX(I) > T) THEN
            DX(IJ)=DX(I)
            DX(I)=T
            T=DX(IJ)
          END IF
        END IF
!
! Find an element in the second half of the array which is smaller than T
   40   L=L-1
        IF (DX(L) > T) GO TO 40
!
! Find an element in the first half of the array which is greater than T
   50   K=K+1
        IF (DX(K) < T) GO TO 50
!
! Interchange these elements
        IF (K <= L) THEN
          TT=DX(L)
          DX(L)=DX(K)
          DX(K)=TT
          GO TO 40
        END IF
!
! Save upper and lower subscripts of the array yet to be sorted
        IF (L-I > J-K) THEN
          IL(M)=I
          IU(M)=L
          I=K
          M=M+1
        ELSE
          IL(M)=K
          IU(M)=J
          J=L
          M=M+1
        END IF
        GO TO 70
!
! Begin again on another portion of the unsorted array
   60   M=M-1
        IF (M == 0) GO TO 190
        I=IL(M)
        J=IU(M)
!
   70   IF (J-I >= 1) GO TO 30
        IF (I == 1) GO TO 20
        I=I-1
!
   80   I=I+1
        IF (I == J) GO TO 60
        T=DX(I+1)
        IF (DX(I) <= T) GO TO 80
        K=I
!
   90   DX(K+1)=DX(K)
        K=K-1
        IF (T < DX(K)) GO TO 90
        DX(K+1)=T
        GO TO 80
      END IF
!
! Sort DX and carry JO along
  100 M=1
      I=1
      J=NN
      R=0.375D0
!
  110 IF (I == J) GO TO 150
      IF (R <= 0.5898437D0) THEN
        R=R+3.90625D-2
      ELSE
        R=R-0.21875D0
      END IF
!
  120 K=I
!
! Select a central element of the array and save it in location T
      IJ=I+INT((J-I)*R)
      T=DX(IJ)
      TY=JO(IJ)
!
! If first element of array is greater than T, interchange with T
      IF (DX(I) > T) THEN
        DX(IJ)=DX(I)
        DX(I)=T
        T=DX(IJ)
        JO(IJ)=JO(I)
        JO(I)=TY
        TY=JO(IJ)
      END IF
      L=J
!
! If last element of array is less than T, interchange with T
      IF (DX(J) < T) THEN
        DX(IJ)=DX(J)
        DX(J)=T
        T=DX(IJ)
        JO(IJ)=JO(J)
        JO(J)=TY
        TY=JO(IJ)
! If first element of array is greater than T, interchange with T
        IF (DX(I) > T) THEN
          DX(IJ)=DX(I)
          DX(I)=T
          T=DX(IJ)
          JO(IJ)=JO(I)
          JO(I)=TY
          TY=JO(IJ)
        END IF
      END IF
!
! Find an element in the second half of the array which is smaller than T
  130 L=L-1
      IF (DX(L) > T) GO TO 130
!
! Find an element in the first half of the array which is greater than T
  140 K=K+1
      IF (DX(K) < T) GO TO 140
!
! Interchange these elements
      IF (K <= L) THEN
        TT=DX(L)
        DX(L)=DX(K)
        DX(K)=TT
        TTY=JO(L)
        JO(L)=JO(K)
        JO(K)=TTY
        GO TO 130
      END IF
!
! Save upper and lower subscripts of the array yet to be sorted
      IF (L-I > J-K) THEN
        IL(M)=I
        IU(M)=L
        I=K
        M=M+1
      ELSE
        IL(M)=K
        IU(M)=J
        J=L
        M=M+1
      END IF
      GO TO 160
!
! Begin again on another portion of the unsorted array
  150 M=M-1
      IF (M == 0) GO TO 190
      I=IL(M)
      J=IU(M)
!
  160 IF (J-I >= 1) GO TO 120
      IF (I == 1) GO TO 110
      I=I-1
!
  170 I=I+1
      IF (I == J) GO TO 150
      T=DX(I+1)
      TY=JO(I+1)
      IF (DX(I) <= T) GO TO 170
      K=I
!
  180 DX(K+1)=DX(K)
      JO(K+1)=JO(K)
      K=K-1
      IF (T < DX(K)) GO TO 180
      DX(K+1)=T
      JO(K+1)=TY
      GO TO 170
!
! Clean up
  190 IF (KFLAG <= -1) THEN
        DO I=1,NN
          DX(I)=-DX(I)
        END DO
      END IF
!
  999 CONTINUE
      DO I=1,N
      J=JO(I)
      KO(J)=I
      ENDDO
      RETURN
!
      END SUBROUTINE DSORT
!
!-----------------------------HISTORY------------------------------------------------
! VERSION     : NONMEM VII
! AUTHOR      : ROBERT J. BAUER
! CREATED ON  : MAR/2009
! LANGUAGE    : FORTRAN 90/95
! LAST UPDATE : MAR/2009 - INTRODUCED HEADER INFORMATIONS AND RESTRUCTURED AS PER
!                          THE NONMEM STANDARDS
!                        - BAYESIAN METHOD INCLUDED
!               NOV/2016 - INTEGRATED NONMEM7.4 CHANGES
!
!---------------------------------- DINVNORM.F90 ------------------------------------
!
! FUNCTION DINVNORM(P2)
!
! DESCRIPTION : Normal inverse translate from a routine written by John Herrero
!
! ARGUMENTS   : P2
!               IN     - P2
!                        P2 - input value
!               OUT    - NONE
!               IN OUT - NONE
!
! CALLED BY   : GASDEV,NPDE_SAMPLE_FINALIZE
!
! CALLS       : NONE
!
! ALGORITHM   : - Compute Z and assign it to DINVNORM
!
! MODULES USED: SIZES
!
! CONTAINS    : NONE
!
! LOCALS      : A1,A2,A3,A4,A5,A6,B1,B2,B3,B4,B5,C1,C2,C3,C4,C5,C6,D1,D2,D3,D4,
!               DINVNORM,G,P,P_LOW,P_HIGH,Z,Q,R
!
!---------------------------- END OF HEADER -----------------------------------------
!
! Ren-Raw Chen, Rutgers business school
! Normal inverse translate from a routine written by John Herrero
!
!      REAL(KIND=DPSIZE) FUNCTION DINVNORM(P2)
      FUNCTION DINVNORM(P2)
!
!
      REAL*8, INTENT(IN) :: P2
!
!
!------------------------------------------------------------------------------------
!
! Local Variables
!
      REAL*8 :: A1,A2,A3,A4,A5,A6,B1,B2,B3,B4,B5,C1,C2,C3,C4,C5,C6,D1,D2, &
                           D3,D4,DINVNORM,G,P,P_LOW,P_HIGH,Z,Q,R
!
! Bauer added these extra four lines to avoid NAN
      P=P2
      G=1.0D-13
      IF (P >= 1.0D+00-G) P=1.0D+00-G
      IF (P <= G) P=G
      A1=-39.6968302866538D+00
      A2=220.946098424521D+00
      A3=-275.928510446969D+00
      A4=138.357751867269D+00
      A5=-30.6647980661472D+00
      A6=2.50662827745924D+00
      B1=-54.4760987982241D+00
      B2=161.585836858041D+00
      B3=-155.698979859887D+00
      B4=66.8013118877197D+00
      B5=-13.2806815528857D+00
      C1=-0.00778489400243029D+00
      C2=-0.322396458041136D+00
      C3=-2.40075827716184D+00
      C4=-2.54973253934373D+00
      C5=4.37466414146497D+00
      C6=2.93816398269878D+00
      D1=0.00778469570904146D+00
      D2=0.32246712907004D+00
      D3=2.445134137143D+00
      D4=3.75440866190742D+00
      P_LOW=0.02425D+00
      P_HIGH=1.0D+00-P_LOW
!
      IF (P < P_LOW) GO TO 201
      IF (P >= P_LOW) GO TO 301
  201 Q=DSQRT(-2*DLOG(P))
      Z=(((((C1*Q+C2)*Q+C3)*Q+C4)*Q+C5)*Q+C6)/   &
        ((((D1*Q+D2)*Q+D3)*Q+D4)*Q+1)
      GO TO 204
  301 IF ((P >= P_LOW).AND.(P <= P_HIGH)) GO TO 202
      IF (P > P_HIGH) GO TO 302
  202 Q=P-0.5D+00
      R=Q*Q
      Z=(((((A1*R+A2)*R+A3)*R+A4)*R+A5)*R+A6)*Q/  &
        (((((B1*R+B2)*R+B3)*R+B4)*R+B5)*R+1.0D+00)
      GO TO 204
  302 IF ((P > P_HIGH) .AND. (P < 1.0D+00)) GO TO 203
  203 Q=DSQRT(-2*DLOG(1.0D+00-P))
      Z=-(((((C1*Q+C2)*Q+C3)*Q+C4)*Q+C5)*Q+C6)/   &
        ((((D1*Q+D2)*Q+D3)*Q+D4)*Q+1.0D+00)
  204 DINVNORM=Z
!
  999 RETURN
!
      END FUNCTION DINVNORM
