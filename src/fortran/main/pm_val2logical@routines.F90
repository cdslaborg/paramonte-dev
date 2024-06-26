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
!>  This file contains procedure implementations of [val2logical_pmod](@ref pm_val2logical).
!>
!>  \finmain
!>
!>  \author
!>  \AmirShahmoradi, September 1, 2017, 12:00 AM, Institute for Computational Engineering and Sciences (ICES), The University of Texas at Austin

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

submodule (pm_val2logical) routines ! LCOV_EXCL_LINE

    implicit none

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

contains

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define getLogical_ENABLED 1

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define Def_ENABLED 1

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define SK_ENABLED 1

#if SK5_ENABLED
    module procedure getLogicalDef_SK5
        use pm_kind, only: LKC => LK, SKC => SK5
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if SK4_ENABLED
    module procedure getLogicalDef_SK4
        use pm_kind, only: LKC => LK, SKC => SK4
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if SK3_ENABLED
    module procedure getLogicalDef_SK3
        use pm_kind, only: LKC => LK, SKC => SK3
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if SK2_ENABLED
    module procedure getLogicalDef_SK2
        use pm_kind, only: LKC => LK, SKC => SK2
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if SK1_ENABLED
    module procedure getLogicalDef_SK1
        use pm_kind, only: LKC => LK, SKC => SK1
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#undef SK_ENABLED

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#undef Def_ENABLED

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#undef getLogical_ENABLED

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define setLogical_ENABLED 1

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define Def_ENABLED 1

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define SK_ENABLED 1

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#if LK5_ENABLED && SK5_ENABLED
    module procedure setLogicalDef_LK5_SK5
        use pm_kind, only: LKC => LK5, SKC => SK5
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK5_ENABLED && SK4_ENABLED
    module procedure setLogicalDef_LK5_SK4
        use pm_kind, only: LKC => LK5, SKC => SK4
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK5_ENABLED && SK3_ENABLED
    module procedure setLogicalDef_LK5_SK3
        use pm_kind, only: LKC => LK5, SKC => SK3
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK5_ENABLED && SK2_ENABLED
    module procedure setLogicalDef_LK5_SK2
        use pm_kind, only: LKC => LK5, SKC => SK2
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK5_ENABLED && SK1_ENABLED
    module procedure setLogicalDef_LK5_SK1
        use pm_kind, only: LKC => LK5, SKC => SK1
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#if LK4_ENABLED && SK5_ENABLED
    module procedure setLogicalDef_LK4_SK5
        use pm_kind, only: LKC => LK4, SKC => SK5
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK4_ENABLED && SK4_ENABLED
    module procedure setLogicalDef_LK4_SK4
        use pm_kind, only: LKC => LK4, SKC => SK4
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK4_ENABLED && SK3_ENABLED
    module procedure setLogicalDef_LK4_SK3
        use pm_kind, only: LKC => LK4, SKC => SK3
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK4_ENABLED && SK2_ENABLED
    module procedure setLogicalDef_LK4_SK2
        use pm_kind, only: LKC => LK4, SKC => SK2
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK4_ENABLED && SK1_ENABLED
    module procedure setLogicalDef_LK4_SK1
        use pm_kind, only: LKC => LK4, SKC => SK1
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#if LK3_ENABLED && SK5_ENABLED
    module procedure setLogicalDef_LK3_SK5
        use pm_kind, only: LKC => LK3, SKC => SK5
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK3_ENABLED && SK4_ENABLED
    module procedure setLogicalDef_LK3_SK4
        use pm_kind, only: LKC => LK3, SKC => SK4
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK3_ENABLED && SK3_ENABLED
    module procedure setLogicalDef_LK3_SK3
        use pm_kind, only: LKC => LK3, SKC => SK3
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK3_ENABLED && SK2_ENABLED
    module procedure setLogicalDef_LK3_SK2
        use pm_kind, only: LKC => LK3, SKC => SK2
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK3_ENABLED && SK1_ENABLED
    module procedure setLogicalDef_LK3_SK1
        use pm_kind, only: LKC => LK3, SKC => SK1
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#if LK2_ENABLED && SK5_ENABLED
    module procedure setLogicalDef_LK2_SK5
        use pm_kind, only: LKC => LK2, SKC => SK5
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK2_ENABLED && SK4_ENABLED
    module procedure setLogicalDef_LK2_SK4
        use pm_kind, only: LKC => LK2, SKC => SK4
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK2_ENABLED && SK3_ENABLED
    module procedure setLogicalDef_LK2_SK3
        use pm_kind, only: LKC => LK2, SKC => SK3
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK2_ENABLED && SK2_ENABLED
    module procedure setLogicalDef_LK2_SK2
        use pm_kind, only: LKC => LK2, SKC => SK2
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK2_ENABLED && SK1_ENABLED
    module procedure setLogicalDef_LK2_SK1
        use pm_kind, only: LKC => LK2, SKC => SK1
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#if LK1_ENABLED && SK5_ENABLED
    module procedure setLogicalDef_LK1_SK5
        use pm_kind, only: LKC => LK1, SKC => SK5
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK1_ENABLED && SK4_ENABLED
    module procedure setLogicalDef_LK1_SK4
        use pm_kind, only: LKC => LK1, SKC => SK4
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK1_ENABLED && SK3_ENABLED
    module procedure setLogicalDef_LK1_SK3
        use pm_kind, only: LKC => LK1, SKC => SK3
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK1_ENABLED && SK2_ENABLED
    module procedure setLogicalDef_LK1_SK2
        use pm_kind, only: LKC => LK1, SKC => SK2
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK1_ENABLED && SK1_ENABLED
    module procedure setLogicalDef_LK1_SK1
        use pm_kind, only: LKC => LK1, SKC => SK1
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#undef SK_ENABLED

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#undef Def_ENABLED

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define Err_ENABLED 1

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define SK_ENABLED 1

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#if LK5_ENABLED && SK5_ENABLED
    module procedure setLogicalErr_LK5_SK5
        use pm_kind, only: LKC => LK5, SKC => SK5
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK5_ENABLED && SK4_ENABLED
    module procedure setLogicalErr_LK5_SK4
        use pm_kind, only: LKC => LK5, SKC => SK4
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK5_ENABLED && SK3_ENABLED
    module procedure setLogicalErr_LK5_SK3
        use pm_kind, only: LKC => LK5, SKC => SK3
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK5_ENABLED && SK2_ENABLED
    module procedure setLogicalErr_LK5_SK2
        use pm_kind, only: LKC => LK5, SKC => SK2
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK5_ENABLED && SK1_ENABLED
    module procedure setLogicalErr_LK5_SK1
        use pm_kind, only: LKC => LK5, SKC => SK1
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#if LK4_ENABLED && SK5_ENABLED
    module procedure setLogicalErr_LK4_SK5
        use pm_kind, only: LKC => LK4, SKC => SK5
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK4_ENABLED && SK4_ENABLED
    module procedure setLogicalErr_LK4_SK4
        use pm_kind, only: LKC => LK4, SKC => SK4
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK4_ENABLED && SK3_ENABLED
    module procedure setLogicalErr_LK4_SK3
        use pm_kind, only: LKC => LK4, SKC => SK3
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK4_ENABLED && SK2_ENABLED
    module procedure setLogicalErr_LK4_SK2
        use pm_kind, only: LKC => LK4, SKC => SK2
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK4_ENABLED && SK1_ENABLED
    module procedure setLogicalErr_LK4_SK1
        use pm_kind, only: LKC => LK4, SKC => SK1
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#if LK3_ENABLED && SK5_ENABLED
    module procedure setLogicalErr_LK3_SK5
        use pm_kind, only: LKC => LK3, SKC => SK5
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK3_ENABLED && SK4_ENABLED
    module procedure setLogicalErr_LK3_SK4
        use pm_kind, only: LKC => LK3, SKC => SK4
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK3_ENABLED && SK3_ENABLED
    module procedure setLogicalErr_LK3_SK3
        use pm_kind, only: LKC => LK3, SKC => SK3
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK3_ENABLED && SK2_ENABLED
    module procedure setLogicalErr_LK3_SK2
        use pm_kind, only: LKC => LK3, SKC => SK2
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK3_ENABLED && SK1_ENABLED
    module procedure setLogicalErr_LK3_SK1
        use pm_kind, only: LKC => LK3, SKC => SK1
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#if LK2_ENABLED && SK5_ENABLED
    module procedure setLogicalErr_LK2_SK5
        use pm_kind, only: LKC => LK2, SKC => SK5
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK2_ENABLED && SK4_ENABLED
    module procedure setLogicalErr_LK2_SK4
        use pm_kind, only: LKC => LK2, SKC => SK4
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK2_ENABLED && SK3_ENABLED
    module procedure setLogicalErr_LK2_SK3
        use pm_kind, only: LKC => LK2, SKC => SK3
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK2_ENABLED && SK2_ENABLED
    module procedure setLogicalErr_LK2_SK2
        use pm_kind, only: LKC => LK2, SKC => SK2
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK2_ENABLED && SK1_ENABLED
    module procedure setLogicalErr_LK2_SK1
        use pm_kind, only: LKC => LK2, SKC => SK1
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#if LK1_ENABLED && SK5_ENABLED
    module procedure setLogicalErr_LK1_SK5
        use pm_kind, only: LKC => LK1, SKC => SK5
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK1_ENABLED && SK4_ENABLED
    module procedure setLogicalErr_LK1_SK4
        use pm_kind, only: LKC => LK1, SKC => SK4
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK1_ENABLED && SK3_ENABLED
    module procedure setLogicalErr_LK1_SK3
        use pm_kind, only: LKC => LK1, SKC => SK3
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK1_ENABLED && SK2_ENABLED
    module procedure setLogicalErr_LK1_SK2
        use pm_kind, only: LKC => LK1, SKC => SK2
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

#if LK1_ENABLED && SK1_ENABLED
    module procedure setLogicalErr_LK1_SK1
        use pm_kind, only: LKC => LK1, SKC => SK1
#include "pm_val2logical@routines.inc.F90"
    end procedure
#endif

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#undef SK_ENABLED

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#undef Err_ENABLED

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#undef setLogical_ENABLED

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end submodule routines
