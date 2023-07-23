/*
* Copyright (c) 2015-2022 Sergey Bakhurin
* Digital Signal Processing Library [http://dsplib.org]
*
* This file is part of DSPL.
*
* is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* DSPL is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.    See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Foobar.    If not, see <http://www.gnu.org/licenses/>.
*/


#include <stdio.h>
#include <stdlib.h>
#include "dspl.h"


#ifdef DOXYGEN_ENGLISH
/*! ****************************************************************************
\ingroup SPEC_MATH_TRIG_GROUP
\fn int sin_cmplx(complex_t* x, int n, complex_t *y)
\brief The sine function the complex vector argument `x`.

Function calculates the sine function as: \n
\f[
\textrm{cos}(x) = \frac{\exp(jx) - \exp(-jx)}{2j} 
\f]    


\param[in]    x
Pointer to the argument vector `x`. \n
Vector size is `[n x 1]`.    \n \n

\param[in]    n
Input vector `x` and the sine vector `y` size. \n \n

\param[out] y
Pointer to the output complex vector `y`,
corresponds to the input vector `x`. \n
Vector size is `[n x 1]`.    \n
Memory must be allocated.    \n \n

\return
`RES_OK` if function calculated successfully.    \n
Else \ref ERROR_CODE_GROUP "code error". \n

Example: \n
\code{.cpp}
    complex_t x[3] = {{1.0, 2.0}, {3.0, 4.0}, {5.0, 6.0}};
    complex_t y[3];
    int k;
    
    sin_cmplx(x, 3, y);
    
    for(k = 0; k < 3; k++)
        printf("sin_cmplx(%.1f%+.1fj) = %9.3f%+9.3fj\n", 
                RE(x[k]), IM(x[k]), RE(y[k]), IM(y[k]));
     
\endcode 
 \n

Output is: \n
\verbatim
sin_cmplx(1.0+2.0j) =       3.166  +1.960j
sin_cmplx(3.0+4.0j) =       3.854 -27.017j
sin_cmplx(5.0+6.0j) =    -193.430 +57.218j
\endverbatim

\author Sergey Bakhurin www.dsplib.org
***************************************************************************** */
#endif
#ifdef DOXYGEN_RUSSIAN
/*! ****************************************************************************
\ingroup SPEC_MATH_TRIG_GROUP
\fn int sin_cmplx(complex_t* x, int n, complex_t *y)
\brief  Синус комплексного аргумента `x`.

Функция рассчитывает значения синуса комплексного аргумента, 
заданного вектором `x` длины `n`:  \n
\f[
\textrm{sin}(x) = \frac{\exp(jx) - \exp(-jx)}{2j} 
\f]  

\param[in]  x
Указатель на вектор аргумента комплексного синуса. \n
Размер вектора `[n x 1]`.  \n \n

\param[in]  n
Размер входного и выходного векторов `x` и `y`. \n \n

\param[out] y
Указатель на вектор значений комплексного синуса,
соответствующего входному вектору `x`. \n
Размер массива `[n x 1]`.  \n
Память должна быть выделена.  \n \n

\return
`RES_OK` если значение функции рассчитано успешно   .  \n
В противном случае \ref ERROR_CODE_GROUP "код ошибки": \n

Например при выполнении следующего кода 
\code{.cpp}
    complex_t x[3] = {{1.0, 2.0}, {3.0, 4.0}, {5.0, 6.0}};
    complex_t y[3];
    int k;
    
    sin_cmplx(x, 3, y);
    
    for(k = 0; k < 3; k++)
        printf("sin_cmplx(%.1f%+.1fj) = %9.3f%+9.3fj\n", 
                RE(x[k]), IM(x[k]), RE(y[k]), IM(y[k]));
    
 \endcode 
 \n

Результатом работы будет

\verbatim
sin_cmplx(1.0+2.0j) =     3.166   +1.960j
sin_cmplx(3.0+4.0j) =     3.854  -27.017j
sin_cmplx(5.0+6.0j) =  -193.430  +57.218j
\endverbatim

\author Бахурин Сергей www.dsplib.org 
***************************************************************************** */
#endif
int DSPL_API sin_cmplx(complex_t* x, int n, complex_t *y)
{
    int k;
    double ep, em, sx, cx;
    if(!x || !y)
        return ERROR_PTR;
    if(n < 1)
        return ERROR_SIZE;

    for(k = 0; k < n; k++)
    {
        ep = exp( IM(x[k]));
        em = exp(-IM(x[k]));
        sx = 0.5 * sin(RE(x[k]));
        cx = 0.5 * cos(RE(x[k]));
        RE(y[k]) = sx * (em + ep);
        IM(y[k]) = cx * (ep - em);
    }
    return RES_OK;
}

