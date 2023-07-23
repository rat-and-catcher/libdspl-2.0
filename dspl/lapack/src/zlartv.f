*> \brief \b ZLARTV applies a vector of plane rotations with real cosines and complex sines to the elements of a pair of vectors.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download ZLARTV + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/zlartv.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/zlartv.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/zlartv.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE ZLARTV( N, X, INCX, Y, INCY, C, S, INCC )
*
*       .. Scalar Arguments ..
*       INTEGER            INCC, INCX, INCY, N
*       ..
*       .. Array Arguments ..
*       DOUBLE PRECISION   C( * )
*       COMPLEX*16         S( * ), X( * ), Y( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> ZLARTV applies a vector of complex plane rotations with real cosines
*> to elements of the complex vectors x and y. For i = 1,2,...,n
*>
*>    ( x(i) ) := (        c(i)   s(i) ) ( x(i) )
*>    ( y(i) )    ( -conjg(s(i))  c(i) ) ( y(i) )
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of plane rotations to be applied.
*> \endverbatim
*>
*> \param[in,out] X
*> \verbatim
*>          X is COMPLEX*16 array, dimension (1+(N-1)*INCX)
*>          The vector x.
*> \endverbatim
*>
*> \param[in] INCX
*> \verbatim
*>          INCX is INTEGER
*>          The increment between elements of X. INCX > 0.
*> \endverbatim
*>
*> \param[in,out] Y
*> \verbatim
*>          Y is COMPLEX*16 array, dimension (1+(N-1)*INCY)
*>          The vector y.
*> \endverbatim
*>
*> \param[in] INCY
*> \verbatim
*>          INCY is INTEGER
*>          The increment between elements of Y. INCY > 0.
*> \endverbatim
*>
*> \param[in] C
*> \verbatim
*>          C is DOUBLE PRECISION array, dimension (1+(N-1)*INCC)
*>          The cosines of the plane rotations.
*> \endverbatim
*>
*> \param[in] S
*> \verbatim
*>          S is COMPLEX*16 array, dimension (1+(N-1)*INCC)
*>          The sines of the plane rotations.
*> \endverbatim
*>
*> \param[in] INCC
*> \verbatim
*>          INCC is INTEGER
*>          The increment between elements of C and S. INCC > 0.
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
*> \date December 2016
*
*> \ingroup complex16OTHERauxiliary
*
*  =====================================================================
      SUBROUTINE ZLARTV( N, X, INCX, Y, INCY, C, S, INCC )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      INTEGER            INCC, INCX, INCY, N
*     ..
*     .. Array Arguments ..
      DOUBLE PRECISION   C( * )
      COMPLEX*16         S( * ), X( * ), Y( * )
*     ..
*
*  =====================================================================
*
*     .. Local Scalars ..
      INTEGER            I, IC, IX, IY
      COMPLEX*16         XI, YI
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          DCONJG
*     ..
*     .. Executable Statements ..
*
      IX = 1
      IY = 1
      IC = 1
      DO 10 I = 1, N
         XI = X( IX )
         YI = Y( IY )
         X( IX ) = C( IC )*XI + S( IC )*YI
         Y( IY ) = C( IC )*YI - DCONJG( S( IC ) )*XI
         IX = IX + INCX
         IY = IY + INCY
         IC = IC + INCC
   10 CONTINUE
      RETURN
*
*     End of ZLARTV
*
      END
