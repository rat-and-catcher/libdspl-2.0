/*
* Copyright (c) 2015-2022 Sergey Bakhurin
* Digital Signal Processing Library [http://dsplib.org]
*
* This file is part of libdspl-2.0.
*
* is free software: you can redistribute it and/or modify
* it under the terms of the GNU Lesser    General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* DSPL is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.    See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with Foobar.    If not, see <http://www.gnu.org/licenses/>.
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <float.h>
#include "dspl.h"


#ifdef DOXYGEN_ENGLISH

#endif
#ifdef DOXYGEN_RUSSIAN
/*! ****************************************************************************
\ingroup PSD_GROUP
int psd_welch(double* x, int n, 
              int win_type, double win_param,
              int nfft, int noverlap, fft_t* pfft, double fs,
              int flag, double* ppsd, double* pfrq)

\brief Непараметрическая оценка спектральной плотности мощности (СПМ) 
вещественного сигнала методом Уэлча.

Функция рассчитывает спектральную плотность мощности \f$ X(f) \f$ 
выборки сигнала длительности \$n \$ отсчетов методом Уэлча:
\f[
  X(f) = \frac{1}{U P F_s }  \sum_{p = 0}^{P-1}\left| \sum_{m = 0}^{n_{FFT}-1} 
  w(m) x(m+p \cdot n_{\text{overlap}})   \exp 
   \left( -j 2\pi f m \right) \right|^2,
\f]
где \f$ w(m) \f$ -- отсчёты оконной функции, \f$ F_s \f$ -- частота 
дискретизации (Гц), \f$P = n/n_{\text{overlap}}\f$ -- количество сегментов 
смещений выборки сигналов размера \f$n_{FFT}\f$,

 \f$ U \f$ нормировочный коэффициент равный
\f[
    U = \sum_{m = 0}^{n-1} w^2(m),
\f]

Процедура разбиения исходной последовательности длительности `n` отсчетов 
на сегменты длины \f$n_{FFT}\f$ отсчетов, перекрывающихся с интервалом 
\f$n_{\text{overlap}}\f$ отсчетов, показан на следующем рисунке

\image html welch_overlap.png

Расчет спектральной плотности мощности ведется при помощи алгоритмов быстрого
преобразования Фурье, для дискретной сетки частот от 0 Гц до \f$ F_s \f$ Гц 
(по умолчанию), или от \f$-F_s /2 \f$ до \f$F_s /2 \f$, если установлен флаг 
расчета двусторонней периодограммы.

\note Периодограмма Уэлча возвращает смещенную, но состоятельную оценку СПМ.

\param[in]  x
Указатель на входной вектор комплексного сигнала \f$x(m)\f$, 
\f$ m = 0 \ldots n-1 \f$.  \n
Размер вектора `[n x 1]`.  \n \n

\param[in]  n
Размер вектора входного сигнала.
Также размер выходного вектора СПМ и 
вектора частоты также равны `n`.\n\n

\param[in]  win_type
Тип оконной функции, применяемой для модифицированной периодограммы.\n
Подробнее смотри описание функции \ref window. \n\n

\param[in]  win_param
Параметр оконной функциии. \n
Данный параметр применяется только для парамтрических типов окон
(смотри описание функции \ref window).\n
Для непараметрических функций игнорируется. \n\n

\param[in] nfft
Размер перекрывающегося сегмента.\n
Размер выходного вектора СПМ, и соответсвующего ей вектора частоты.\n\n

\param[in] noverlap
Размер сдвига сегментов относительно друг друга (отсчетов).\n
`noverlap = nfft` задает оценку без перекрытия сегментов. \n
Обычно используют сдвиг равный половине размера сегмента `noverlap = nfft/2`.\n


\param[in] pfft
Указатель на структуру \ref fft_t.  \n
Указатель может быть `NULL`. В этом случае объект структуры будет 
создан внутри функции и удален перед завершением.\n
Если предполагается многократный вызов функции, то рекомендуется создать 
объект \ref fft_t и передавать в функцию, чтобы не 
создавать его каждый раз. \n\n

\param[in] fs
частота дискретизации выборки исходного сигнала (Гц). \n\n

\param[in] flag
Комбинация битовых флагов, задающих режим расчета:
\verbatim
DSPL_FLAG_LOGMAG - СПМ считать в логарифмическом масштабе в единицах дБ/Гц
DSPL_FLAG_PSD_TWOSIDED - двусторонняя СПМ (от -Fs/2 до Fs/2)
\endverbatim

\param[in, out] ppsd
Указатель на вектор СПМ рассчитанных по входному сигналу $x$. \n
Размер вектора `[nfft x 1]`. \n
Память должна быть выделена. \n\n

\param[in, out] pfrq
Указатель на вектор частоты, соответствующей 
значениям рассчитанного вектора СПМ. \n
Размер вектора `[nfft x 1]`. \n
Указатель может быть `NULL`,в этом случае вектор частоты не 
рассчитывается и не возвращается. \n\n

\return
`RES_OK` если расчет произведен успешно.  \n
В противном случае \ref ERROR_CODE_GROUP "код ошибки". \n \n

Пример периодограммных оценок СПМ для различной длины выборки сигнала:

\include psd_welch_test.c

Программа производит расчет СПМ сигнала, состоящего из двух комплексных 
гармоник на фоне белого гауссова шума. 
Расчет ведется по выборке сигнала длины 8192 отсчета.

Рассчитанные СПМ выводятся на графики:

`nfft = 8192, noverlap = 4096`:
\image html psd_welch_8192.png

`nfft = 1024, noverlap = 512`:
\image html psd_welch_1024.png

`nfft = 256, noverlap = 128`:
\image html psd_welch_256.png

Можно видеть, что уменьшение `nfft` при фиксированной длительности сигнала
позволяет уменьшить флуктуации шума и делает оценку состоятельной.

\author Бахурин Сергей www.dsplib.org 
***************************************************************************** */
#endif
int DSPL_API psd_welch(double* x, int n, 
                      int win_type, double win_param,
                      int nfft, int noverlap, fft_t* pfft, double fs,
                      int flag, double* ppsd, double* pfrq)
{
    int err, pos, cnt, k;
    double *pdgr = NULL;
    double *tmp = NULL;
    double *w = NULL;
    fft_t *ptr_fft = NULL;
    double wn;
    
    pos = cnt = 0;
    
    pdgr = (double*)malloc(nfft * sizeof(double));
    if(!pdgr)
        return ERROR_MALLOC;
      
    tmp = (double*) malloc(nfft * sizeof(double));
    if(!tmp)
        return ERROR_MALLOC;

    /* window malloc */
    w = (double*)malloc(nfft*sizeof(double));
    if(!w)
    {
        err = ERROR_MALLOC;
        goto exit_label;
    }
    
    /* create window */
    err = window(w, nfft, win_type, win_param);
    if(err != RES_OK)
        goto exit_label;
    
    /* window normalization wn = sum(w.^2) */
    wn = 0.0; 
    for(k = 0; k < nfft; k++)
        wn += w[k]*w[k];


    if(!pfft)
    {
        ptr_fft = (fft_t*)malloc(sizeof(fft_t));
        memset(ptr_fft, 0, sizeof(fft_t));
    }
    else
        ptr_fft = pfft;
    
    
    
    
    memset(ppsd, 0, nfft * sizeof(double));
    while(pos + nfft <= n)
    {
        for(k = 0; k < nfft; k++)
            tmp[k] = x[pos+k] * w[k];
        err = fft_mag(tmp, nfft, ptr_fft, fs, 
                      flag & DSPL_FLAG_FFT_SHIFT, pdgr, NULL);
        if(err != RES_OK)
            goto exit_label;
        for(k = 0; k < nfft; k++)
            ppsd[k] += pdgr[k];
        pos += noverlap;
        cnt++;
    }
    
    if(pos < n)
    {

        memset(tmp ,0, nfft * sizeof(double));
        for(k = 0; k < n - pos; k++)
            tmp[k] = x[pos+k] * w[k];


        err = fft_mag(tmp, nfft, ptr_fft, fs, 
                      flag & DSPL_FLAG_FFT_SHIFT, pdgr, NULL);
        if(err != RES_OK)
            goto exit_label;
        
        for(k = 0; k < nfft; k++)
            ppsd[k] += pdgr[k];
        
        cnt++;
    }

    /* fill frequency */
    if(pfrq)
    {
        if(flag & DSPL_FLAG_FFT_SHIFT)
            if(n%2)
                err = linspace(-fs*0.5 + fs*0.5/(double)nfft, 
                                fs*0.5 - fs*0.5/(double)nfft, 
                                n, DSPL_SYMMETRIC, pfrq);
            else
                err = linspace(-fs*0.5, fs*0.5, nfft, DSPL_PERIODIC, pfrq);
        else
            err = linspace(0, fs, nfft, DSPL_PERIODIC, pfrq);
    }
    
    /* scale magnitude */
    if(flag & DSPL_FLAG_LOGMAG)
    {
        printf("wn = %f\n", wn);
        for(k = 0; k < nfft; k++)
            ppsd[k] = 10.0 * log10(ppsd[k] / (fs * wn * (double)cnt));
    }
    else
    {
        for(k = 0; k < nfft; k++)
            ppsd[k] /=  fs * wn * (double)cnt;
    }


exit_label:
    if(pdgr)
        free(pdgr);
    if(tmp)
        free(tmp);
    if(w)
        free(w);
    if(ptr_fft && (ptr_fft != pfft))
    {
        fft_free(ptr_fft);
        free(ptr_fft);
    }
    return err;
}
