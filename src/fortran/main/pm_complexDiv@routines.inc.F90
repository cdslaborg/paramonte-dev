!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!                                                                                                                            !!!!
!!!!    ParaMonte: Parallel Monte Carlo and Machine Learning Library.                                                           !!!!
!!!!                                                                                                                            !!!!
!!!!    Copyright (C) 2012-present, The Computational Data Science Lab                                                          !!!!
!!!!                                                                                                                            !!!!
!!!!    This file is part of the ParaMonte library.                                                                             !!!!
!!!!                                                                                                                            !!!!
!!!!    LICENSE                                                                                                                 !!!!
!!!!                                                                                                                            !!!!
!!!!       https://github.com/cdslaborg/paramonte/blob/main/LICENSE.md                                                          !!!!
!!!!                                                                                                                            !!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!>  \brief
!>  This file contains the implementation details of the routines under
!>  the generic interfaces of module [pm_complexDiv](@ref pm_complexDiv).
!>
!>  \finmain
!>
!>  \author
!>  \AmirShahmoradi, September 1, 2017, 12:00 AM, Institute for Computational Engineering and Sciences (ICES), The University of Texas at Austin

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#if     getDiv_CK_ENABLED
        real(CKC) :: r, d
        CHECK_ASSERTION(__LINE__, divisor /= (0._CKC, 0._CKC), SK_"@getDiv(): The condition `divisor /= (0._CKC, 0._CKC)` must hold. divisor = "//getStr(divisor))
        if (abs(divisor%re) < abs(divisor%im)) then
            r = divisor%re / divisor%im
            d = divisor%im + r * divisor%re
            quotient%re = (dividend%re * r + dividend%im) / d
            quotient%im = (dividend%im * r - dividend%re) / d
        else
            r = divisor%im / divisor%re
            d = divisor%re + r * divisor%im
            quotient%re = (dividend%re + dividend%im * r) / d
            quotient%im = (dividend%im - dividend%re * r) / d
        end if
#else
#error  "Unrecognized interface."
#endif


