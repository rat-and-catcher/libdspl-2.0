*> \brief \b CLANSB returns the value of the 1-norm, or the Frobenius norm, or the infinity norm, or the element of largest absolute value of a symmetric band matrix.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CLANSB + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/clansb.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/clansb.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/clansb.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       REAL             FUNCTION CLANSB( NORM, UPLO, N, K, AB, LDAB,
*                        WORK )
*
*       .. Scalar Arguments ..
*       CHARACTER          NORM, UPLO
*       INTEGER            K, LDAB, N
*       ..
*       .. Array Arguments ..
*       REAL               WORK( * )
*       COMPLEX            AB( LDAB, * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CLANSB  returns the value of the one norm,  or the Frobenius norm, or
*> the  infinity norm,  or the element of  largest absolute value  of an
*> n by n symmetric band matrix A,  with k super-diagonals.
*> \endverbatim
*>
*> \return CLANSB
*> \verbatim
*>
*>    CLANSB = ( max(abs(A(i,j))), NORM = 'M' or 'm'
*>             (
*>             ( norm1(A),         NORM = '1', 'O' or 'o'
*>             (
*>             ( normI(A),         NORM = 'I' or 'i'
*>             (
*>             ( normF(A),         NORM = 'F', 'f', 'E' or 'e'
*>
*> where  norm1  denotes the  one norm of a matrix (maximum column sum),
*> normI  denotes the  infinity norm  of a matrix  (maximum row sum) and
*> normF  denotes the  Frobenius norm of a matrix (square root of sum of
*> squares).  Note that  max(abs(A(i,j)))  is not a consistent matrix norm.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] NORM
*> \verbatim
*>          NORM is CHARACTER*1
*>          Specifies the value to be returned in CLANSB as described
*>          above.
*> \endverbatim
*>
*> \param[in] UPLO
*> \verbatim
*>          UPLO is CHARACTER*1
*>          Specifies whether the upper or lower triangular part of the
*>          band matrix A is supplied.
*>          = 'U':  Upper triangular part is supplied
*>          = 'L':  Lower triangular part is supplied
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The order of the matrix A.  N >= 0.  When N = 0, CLANSB is
*>          set to zero.
*> \endverbatim
*>
*> \param[in] K
*> \verbatim
*>          K is INTEGER
*>          The number of super-diagonals or sub-diagonals of the
*>          band matrix A.  K >= 0.
*> \endverbatim
*>
*> \param[in] AB
*> \verbatim
*>          AB is COMPLEX array, dimension (LDAB,N)
*>          The upper or lower triangle of the symmetric band matrix A,
*>          stored in the first K+1 rows of AB.  The j-th column of A is
*>          stored in the j-th column of the array AB as follows:
*>          if UPLO = 'U', AB(k+1+i-j,j) = A(i,j) for max(1,j-k)<=i<=j;
*>          if UPLO = 'L', AB(1+i-j,j)   = A(i,j) for j<=i<=min(n,j+k).
*> \endverbatim
*>
*> \param[in] LDAB
*> \verbatim
*>          LDAB is INTEGER
*>          The leading dimension of the array AB.  LDAB >= K+1.
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is REAL array, dimension (MAX(1,LWORK)),
*>          where LWORK >= N when NORM = 'I' or '1' or 'O'; otherwise,
*>          WORK is not referenced.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \ingroup complexOTHERauxiliary
*
*  =====================================================================
      REAL             FUNCTION CLANSB( NORM, UPLO, N, K, AB, LDAB,
     $                 WORK )
*
*  -- LAPACK auxiliary routine --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*
      IMPLICIT NONE
*     .. Scalar Arguments ..
      CHARACTER          NORM, UPLO
      INTEGER            K, LDAB, N
*     ..
*     .. Array Arguments ..
      REAL               WORK( * )
      COMPLEX            AB( LDAB, * )
*     ..
*
* =====================================================================
*
*     .. Parameters ..
      REAL               ONE, ZERO
      PARAMETER          ( ONE = 1.0E+0, ZERO = 0.0E+0 )
*     ..
*     .. Local Scalars ..
      INTEGER            I, J, L
      REAL               ABSA, SUM, VALUE
*     ..
*     .. Local Arrays ..
      REAL               SSQ( 2 ), COLSSQ( 2 )
*     ..
*     .. External Functions ..
      LOGICAL            LSAME, SISNAN
      EXTERNAL           LSAME, SISNAN
*     ..
*     .. External Subroutines ..
      EXTERNAL           CLASSQ, SCOMBSSQ
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          ABS, MAX, MIN, SQRT
*     ..
*     .. Executable Statements ..
*
      IF( N.EQ.0 ) THEN
         VALUE = ZERO
      ELSE IF( LSAME( NORM, 'M' ) ) THEN
*
*        Find max(abs(A(i,j))).
*
         VALUE = ZERO
         IF( LSAME( UPLO, 'U' ) ) THEN
            DO 20 J = 1, N
               DO 10 I = MAX( K+2-J, 1 ), K + 1
                  SUM = ABS( AB( I, J ) )
                  IF( VALUE .LT. SUM .OR. SISNAN( SUM ) ) VALUE = SUM
   10          CONTINUE
   20       CONTINUE
         ELSE
            DO 40 J = 1, N
               DO 30 I = 1, MIN( N+1-J, K+1 )
                  SUM = ABS( AB( I, J ) )
                  IF( VALUE .LT. SUM .OR. SISNAN( SUM ) ) VALUE = SUM
   30          CONTINUE
   40       CONTINUE
         END IF
      ELSE IF( ( LSAME( NORM, 'I' ) ) .OR. ( LSAME( NORM, 'O' ) ) .OR.
     $         ( NORM.EQ.'1' ) ) THEN
*
*        Find normI(A) ( = norm1(A), since A is symmetric).
*
         VALUE = ZERO
         IF( LSAME( UPLO, 'U' ) ) THEN
            DO 60 J = 1, N
               SUM = ZERO
               L = K + 1 - J
               DO 50 I = MAX( 1, J-K ), J - 1
                  ABSA = ABS( AB( L+I, J ) )
                  SUM = SUM + ABSA
                  WORK( I ) = WORK( I ) + ABSA
   50          CONTINUE
               WORK( J ) = SUM + ABS( AB( K+1, J ) )
   60       CONTINUE
            DO 70 I = 1, N
               SUM = WORK( I )
               IF( VALUE .LT. SUM .OR. SISNAN( SUM ) ) VALUE = SUM
   70       CONTINUE
         ELSE
            DO 80 I = 1, N
               WORK( I ) = ZERO
   80       CONTINUE
            DO 100 J = 1, N
               SUM = WORK( J ) + ABS( AB( 1, J ) )
               L = 1 - J
               DO 90 I = J + 1, MIN( N, J+K )
                  ABSA = ABS( AB( L+I, J ) )
                  SUM = SUM + ABSA
                  WORK( I ) = WORK( I ) + ABSA
   90          CONTINUE
               IF( VALUE .LT. SUM .OR. SISNAN( SUM ) ) VALUE = SUM
  100       CONTINUE
         END IF
      ELSE IF( ( LSAME( NORM, 'F' ) ) .OR. ( LSAME( NORM, 'E' ) ) ) THEN
*
*        Find normF(A).
*        SSQ(1) is scale
*        SSQ(2) is sum-of-squares
*        For better accuracy, sum each column separately.
*
         SSQ( 1 ) = ZERO
         SSQ( 2 ) = ONE
*
*        Sum off-diagonals
*
         IF( K.GT.0 ) THEN
            IF( LSAME( UPLO, 'U' ) ) THEN
               DO 110 J = 2, N
                  COLSSQ( 1 ) = ZERO
                  COLSSQ( 2 ) = ONE
                  CALL CLASSQ( MIN( J-1, K ), AB( MAX( K+2-J, 1 ), J ),
     $                         1, COLSSQ( 1 ), COLSSQ( 2 ) )
                  CALL SCOMBSSQ( SSQ, COLSSQ )
  110          CONTINUE
               L = K + 1
            ELSE
               DO 120 J = 1, N - 1
                  COLSSQ( 1 ) = ZERO
                  COLSSQ( 2 ) = ONE
                  CALL CLASSQ( MIN( N-J, K ), AB( 2, J ), 1,
     $                         COLSSQ( 1 ), COLSSQ( 2 ) )
                  CALL SCOMBSSQ( SSQ, COLSSQ )
  120          CONTINUE
               L = 1
            END IF
            SSQ( 2 ) = 2*SSQ( 2 )
         ELSE
            L = 1
         END IF
*
*        Sum diagonal
*
         COLSSQ( 1 ) = ZERO
         COLSSQ( 2 ) = ONE
         CALL CLASSQ( N, AB( L, 1 ), LDAB, COLSSQ( 1 ), COLSSQ( 2 ) )
         CALL SCOMBSSQ( SSQ, COLSSQ )
         VALUE = SSQ( 1 )*SQRT( SSQ( 2 ) )
      END IF
*
      CLANSB = VALUE
      RETURN
*
*     End of CLANSB
*
      END
