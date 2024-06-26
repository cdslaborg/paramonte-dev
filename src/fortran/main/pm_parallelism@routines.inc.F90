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
!>  This include file contains procedure implementations of [pm_optimization](@ref pm_optimization).
!>
!>  \finmain
!>
!>  \author
!>  \AmirShahmoradi, Tuesday March 7, 2017, 3:50 AM, Institute for Computational Engineering and Sciences (ICES), The University of Texas at Austin

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        !%%%%%%%%%%%%%%%%%%%%%%%%%
#if     setForkJoinScaling_ENABLED
        !%%%%%%%%%%%%%%%%%%%%%%%%%

        !>  \brief
        !>  The scalar constant of type `integer` of default kind, representing the maximum number of
        !>  Coarray images, or MPI processes, or OpenMP threads that the procedures of this module are guaranteed to handle.<br>
        !>  This constant is particularly relevant to the algorithm of [setForkJoinScaling](@ref pm_parallelism::setForkJoinScaling).<br>
        !>
        !>  \details
        !>  The maximum value is set to ensure the outputs of [setForkJoinScaling](@ref pm_parallelism::setForkJoinScaling) do not overflow the memory.<br>
        !>
        !>  \interface{MAX_NUM_IMAGE}
        !>  \code{.F90}
        !>
        !>      use pm_parallelism, only: MAX_NUM_IMAGE
        !>
        !>      print *, MAX_NUM_IMAGE
        !>
        !>  \endcode
        !>
        !>  \finmain{MAX_NUM_IMAGE}
        !>
        !>  \author
        !>  \AmirShahmoradi, Tuesday March 7, 2017, 3:50 AM, Institute for Computational Engineering and Sciences (ICES), The University of Texas at Austin
        !integer(IK)    , parameter :: MAX_NUM_IMAGE = (huge(0_IK) - mod(huge(0_IK), 2_IK)) / 2_IK ! maximum number of images supported by this algorithm.
        integer(IK)     , parameter :: POWER_BASE = 2_IK
        integer(IK)     , parameter :: MAX_NUM_IMAGE = (huge(0_IK) - mod(huge(0_IK), POWER_BASE)) / POWER_BASE
        integer(IK)     , parameter :: MID_NUM_IMAGE = 2**13_IK ! The number above which we switch to log-linear range.
        character(*, SK), parameter :: PROCEDURE_NAME = MODULE_NAME//SK_"@setForkJoinScaling()"
        real(RKC)                   :: contributionImageFirst, totalRunTime, parSecTimeEffective, comSecTimeTotal
        integer(IK)                 :: lenScaling, iell
        logical(LK)                 :: maxvalFound

        CHECK_ASSERTION(__LINE__, 0 <= seqSecTime, SK_"@setForkJoinScaling(): The condition `0 <= seqSecTime` must hold. seqSecTime = "//getStr(seqSecTime))
        CHECK_ASSERTION(__LINE__, 0 <= parSecTime, SK_"@setForkJoinScaling(): The condition `0 <= parSecTime` must hold. parSecTime = "//getStr(parSecTime))
        CHECK_ASSERTION(__LINE__, 0 <= comSecTime, SK_"@setForkJoinScaling(): The condition `0 <= comSecTime` must hold. comSecTime = "//getStr(comSecTime))
        CHECK_ASSERTION(__LINE__, 0 <= conProb .and. conProb <= 1, SK_"@setForkJoinScaling(): The condition `0. <= conProb .and. conProb <= 1.` must hold. conProb = "//getStr(conProb))

        totalRunTime = seqSecTime + parSecTime ! serial + parallel section runtime of the code per function call.
        if (0._RKC < totalRunTime) then

            if (present(scalingMinLen)) then
                CHECK_ASSERTION(__LINE__, 0 <= scalingMinLen, SK_"@setForkJoinScaling(): The condition `0 <= scalingMinLen` must hold. scalingMinLen = "//getStr(scalingMinLen))
                lenScaling = scalingMinLen
            else
                lenScaling = ceiling(2._RKC / max(conProb, 0.001_RKC), IK)
            end if
            call setResized(scaling, lenScaling)
            call setResized(numproc, lenScaling)

            iell = 1_IK
            numproc(iell) = 1_IK
            scalingMaxLoc = iell
            scalingMaxVal = 1._RKC
            scaling(iell) = scalingMaxVal
            maxvalFound = .false._LK
            loopScaling: do
                if (numproc(iell) < MAX_NUM_IMAGE) then
                    if (iell < lenScaling) then
                        iell = iell + 1_IK
                        if (0._RKC < comSecTime .and. numproc(iell - 1) < MID_NUM_IMAGE) then
                            numproc(iell) = iell
                        else
                            ! Here, the scaling function is monotonically increasing.
                            ! We cannot afford computing the scaling for each and every process count.
                            ! As a compromise, we do it for a log-linear range.
                            numproc(iell) = numproc(iell - 1) * POWER_BASE
                        end if
                        ! compute the fraction of work done by the first image.
                        if (0._RKC < conProb) then
                            contributionImageFirst = exp(getGeomCyclicLogPMF(stepSuccess = 1_IK, probSuccess = conProb, period = numproc(iell)))
                        else ! if (conProb == 0._RKC) then
                            contributionImageFirst = 1._RKC / numproc(iell)
                        end if
                        ! effective runtime of the parallel-section of the code, when executed in parallel on iell processes.
                        parSecTimeEffective = parSecTime * contributionImageFirst
                        ! Assume communication time grows linearly with the number of processes.
                        comSecTimeTotal = (numproc(iell) - 1_IK) * comSecTime
                        scaling(iell) = totalRunTime / (seqSecTime + parSecTimeEffective + comSecTimeTotal)
                        if (scalingMaxVal < scaling(iell)) then
                            scalingMaxVal = scaling(iell)
                            scalingMaxLoc = iell
                        else
                            maxvalFound = .true._LK
                        end if
                    elseif (maxvalFound .and. scalingMaxLoc * 3 <= iell) then
                        exit loopScaling
                    else
                        call setResized(numproc)
                        call setResized(scaling)
                        lenScaling = size(scaling, 1, IK)
                    end if
                else
                    exit loopScaling !error stop PROCEDURE_NAME//SK_": Failed to find the number of processes with which the maximum Fork-Join scaling occurs." ! LCOV_EXCL_LINE
                end if
            end do loopScaling
            numproc = numproc(1 : iell)
            scaling = scaling(1 : iell)

        else

            ! There is no code to execute, possibly only parallel overhead.
            numproc = [1_IK]
            scalingMaxLoc = 1_IK
            scalingMaxVal = 0_IK
            scaling = [scalingMaxVal]

        end if

#else
        !%%%%%%%%%%%%%%%%%%%%%%%%
#error  "Unrecognized interface."
        !%%%%%%%%%%%%%%%%%%%%%%%%
#endif