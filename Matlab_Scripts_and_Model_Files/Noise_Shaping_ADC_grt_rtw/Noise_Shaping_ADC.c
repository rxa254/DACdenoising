/*
 * Noise_Shaping_ADC.c
 *
 * Code generation for model "Noise_Shaping_ADC".
 *
 * Model version              : 1.42
 * Simulink Coder version : 8.3 (R2012b) 20-Jul-2012
 * C source code generated on : Thu May 21 19:59:03 2015
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#include "Noise_Shaping_ADC.h"
#include "Noise_Shaping_ADC_private.h"

/* Block signals (auto storage) */
BlockIO_Noise_Shaping_ADC Noise_Shaping_ADC_B;

/* Continuous states */
ContinuousStates_Noise_Shaping_ Noise_Shaping_ADC_X;

/* Block states (auto storage) */
D_Work_Noise_Shaping_ADC Noise_Shaping_ADC_DWork;

/* Real-time model */
RT_MODEL_Noise_Shaping_ADC Noise_Shaping_ADC_M_;
RT_MODEL_Noise_Shaping_ADC *const Noise_Shaping_ADC_M = &Noise_Shaping_ADC_M_;

/*
 * Time delay interpolation routine
 *
 * The linear interpolation is performed using the formula:
 *
 *          (t2 - tMinusDelay)         (tMinusDelay - t1)
 * u(t)  =  ----------------- * u1  +  ------------------- * u2
 *              (t2 - t1)                  (t2 - t1)
 */
real_T rt_TDelayInterpolate(
  real_T tMinusDelay,                  /* tMinusDelay = currentSimTime - delay */
  real_T tStart,
  real_T *tBuf,
  real_T *uBuf,
  int_T bufSz,
  int_T *lastIdx,
  int_T oldestIdx,
  int_T newIdx,
  real_T initOutput,
  boolean_T discrete,
  boolean_T minorStepAndTAtLastMajorOutput)
{
  int_T i;
  real_T yout, t1, t2, u1, u2;

  /*
   * If there is only one data point in the buffer, this data point must be
   * the t= 0 and tMinusDelay > t0, it ask for something unknown. The best
   * guess if initial output as well
   */
  if ((newIdx == 0) && (oldestIdx ==0 ) && (tMinusDelay > tStart))
    return initOutput;

  /*
   * If tMinusDelay is less than zero, should output initial value
   */
  if (tMinusDelay <= tStart)
    return initOutput;

  /* For fixed buffer extrapolation:
   * if tMinusDelay is small than the time at oldestIdx, if discrete, output
   * tailptr value,  else use tailptr and tailptr+1 value to extrapolate
   * It is also for fixed buffer. Note: The same condition can happen for transport delay block where
   * use tStart and and t[tail] other than using t[tail] and t[tail+1].
   * See below
   */
  if ((tMinusDelay <= tBuf[oldestIdx] ) ) {
    if (discrete) {
      return(uBuf[oldestIdx]);
    } else {
      int_T tempIdx= oldestIdx + 1;
      if (oldestIdx == bufSz-1)
        tempIdx = 0;
      t1= tBuf[oldestIdx];
      t2= tBuf[tempIdx];
      u1= uBuf[oldestIdx];
      u2= uBuf[tempIdx];
      if (t2 == t1) {
        if (tMinusDelay >= t2) {
          yout = u2;
        } else {
          yout = u1;
        }
      } else {
        real_T f1 = (t2-tMinusDelay) / (t2-t1);
        real_T f2 = 1.0 - f1;

        /*
         * Use Lagrange's interpolation formula.  Exact outputs at t1, t2.
         */
        yout = f1*u1 + f2*u2;
      }

      return yout;
    }
  }

  /*
   * When block does not have direct feedthrough, we use the table of
   * values to extrapolate off the end of the table for delays that are less
   * than 0 (less then step size).  This is not completely accurate.  The
   * chain of events is as follows for a given time t.  Major output - look
   * in table.  Update - add entry to table.  Now, if we call the output at
   * time t again, there is a new entry in the table. For very small delays,
   * this means that we will have a different answer from the previous call
   * to the output fcn at the same time t.  The following code prevents this
   * from happening.
   */
  if (minorStepAndTAtLastMajorOutput) {
    /* pretend that the new entry has not been added to table */
    if (newIdx != 0) {
      if (*lastIdx == newIdx) {
        (*lastIdx)--;
      }

      newIdx--;
    } else {
      if (*lastIdx == newIdx) {
        *lastIdx = bufSz-1;
      }

      newIdx = bufSz - 1;
    }
  }

  i = *lastIdx;
  if (tBuf[i] < tMinusDelay) {
    /* Look forward starting at last index */
    while (tBuf[i] < tMinusDelay) {
      /* May occur if the delay is less than step-size - extrapolate */
      if (i == newIdx)
        break;
      i = ( i < (bufSz-1) ) ? (i+1) : 0;/* move through buffer */
    }
  } else {
    /*
     * Look backwards starting at last index which can happen when the
     * delay time increases.
     */
    while (tBuf[i] >= tMinusDelay) {
      /*
       * Due to the entry condition at top of function, we
       * should never hit the end.
       */
      i = (i > 0) ? i-1 : (bufSz-1);   /* move through buffer */
    }

    i = ( i < (bufSz-1) ) ? (i+1) : 0;
  }

  *lastIdx = i;
  if (discrete) {
    /*
     * tempEps = 128 * eps;
     * localEps = max(tempEps, tempEps*fabs(tBuf[i]))/2;
     */
    double tempEps = (DBL_EPSILON) * 128.0;
    double localEps = tempEps * fabs(tBuf[i]);
    if (tempEps > localEps) {
      localEps = tempEps;
    }

    localEps = localEps / 2.0;
    if (tMinusDelay >= (tBuf[i] - localEps)) {
      yout = uBuf[i];
    } else {
      if (i == 0) {
        yout = uBuf[bufSz-1];
      } else {
        yout = uBuf[i-1];
      }
    }
  } else {
    if (i == 0) {
      t1 = tBuf[bufSz-1];
      u1 = uBuf[bufSz-1];
    } else {
      t1 = tBuf[i-1];
      u1 = uBuf[i-1];
    }

    t2 = tBuf[i];
    u2 = uBuf[i];
    if (t2 == t1) {
      if (tMinusDelay >= t2) {
        yout = u2;
      } else {
        yout = u1;
      }
    } else {
      real_T f1 = (t2-tMinusDelay) / (t2-t1);
      real_T f2 = 1.0 - f1;

      /*
       * Use Lagrange's interpolation formula.  Exact outputs at t1, t2.
       */
      yout = f1*u1 + f2*u2;
    }
  }

  return(yout);
}

/*
 * This function updates continuous states using the ODE3 fixed-step
 * solver algorithm
 */
static void rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
{
  /* Solver Matrices */
  static const real_T rt_ODE3_A[3] = {
    1.0/2.0, 3.0/4.0, 1.0
  };

  static const real_T rt_ODE3_B[3][3] = {
    { 1.0/2.0, 0.0, 0.0 },

    { 0.0, 3.0/4.0, 0.0 },

    { 2.0/9.0, 1.0/3.0, 4.0/9.0 }
  };

  time_T t = rtsiGetT(si);
  time_T tnew = rtsiGetSolverStopTime(si);
  time_T h = rtsiGetStepSize(si);
  real_T *x = rtsiGetContStates(si);
  ODE3_IntgData *id = (ODE3_IntgData *)rtsiGetSolverData(si);
  real_T *y = id->y;
  real_T *f0 = id->f[0];
  real_T *f1 = id->f[1];
  real_T *f2 = id->f[2];
  real_T hB[3];
  int_T i;
  int_T nXc = 6;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  Noise_Shaping_ADC_derivatives();

  /* f(:,2) = feval(odefile, t + hA(1), y + f*hB(:,1), args(:)(*)); */
  hB[0] = h * rt_ODE3_B[0][0];
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[0]);
  rtsiSetdX(si, f1);
  Noise_Shaping_ADC_step0();
  Noise_Shaping_ADC_derivatives();

  /* f(:,3) = feval(odefile, t + hA(2), y + f*hB(:,2), args(:)(*)); */
  for (i = 0; i <= 1; i++) {
    hB[i] = h * rt_ODE3_B[1][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[1]);
  rtsiSetdX(si, f2);
  Noise_Shaping_ADC_step0();
  Noise_Shaping_ADC_derivatives();

  /* tnew = t + hA(3);
     ynew = y + f*hB(:,3); */
  for (i = 0; i <= 2; i++) {
    hB[i] = h * rt_ODE3_B[2][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1] + f2[i]*hB[2]);
  }

  rtsiSetT(si, tnew);
  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model step function for TID0 */
void Noise_Shaping_ADC_step0(void)     /* Sample time: [0.0s, 0.0s] */
{
  /* local block i/o variables */
  real_T rtb_AnalogInput;
  real_T rtb_AnalogButterworthLPFilter;
  real_T temp;
  int32_T curTapIdx;
  int32_T outIdx;
  int32_T cffIdx;
  int32_T j;
  if (rtmIsMajorTimeStep(Noise_Shaping_ADC_M)) {
    /* set solver stop time */
    if (!(Noise_Shaping_ADC_M->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&Noise_Shaping_ADC_M->solverInfo,
                            ((Noise_Shaping_ADC_M->Timing.clockTickH0 + 1) *
        Noise_Shaping_ADC_M->Timing.stepSize0 * 4294967296.0));
    } else {
      rtsiSetSolverStopTime(&Noise_Shaping_ADC_M->solverInfo,
                            ((Noise_Shaping_ADC_M->Timing.clockTick0 + 1) *
        Noise_Shaping_ADC_M->Timing.stepSize0 +
        Noise_Shaping_ADC_M->Timing.clockTickH0 *
        Noise_Shaping_ADC_M->Timing.stepSize0 * 4294967296.0));
    }

    if (rtmIsMajorTimeStep(Noise_Shaping_ADC_M)) {
      /* Update the flag to indicate when data transfers from
       *  Sample time: [1.953125E-6s, 0.0s] to Sample time: [7.8125E-6s, 0.0s]  */
      (Noise_Shaping_ADC_M->Timing.RateInteraction.TID1_2)++;
      if ((Noise_Shaping_ADC_M->Timing.RateInteraction.TID1_2) > 3) {
        Noise_Shaping_ADC_M->Timing.RateInteraction.TID1_2 = 0;
      }

      /* Update the flag to indicate when data transfers from
       *  Sample time: [1.953125E-6s, 0.0s] to Sample time: [0.000125s, 0.0s]  */
      (Noise_Shaping_ADC_M->Timing.RateInteraction.TID1_4)++;
      if ((Noise_Shaping_ADC_M->Timing.RateInteraction.TID1_4) > 63) {
        Noise_Shaping_ADC_M->Timing.RateInteraction.TID1_4 = 0;
      }
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep(Noise_Shaping_ADC_M)) {
    Noise_Shaping_ADC_M->Timing.t[0] = rtsiGetT(&Noise_Shaping_ADC_M->solverInfo);
  }

  /* TransportDelay: '<Root>/Transport Delay' */
  {
    real_T **uBuffer = (real_T**)
      &Noise_Shaping_ADC_DWork.TransportDelay_PWORK.TUbufferPtrs[0];
    real_T **tBuffer = (real_T**)
      &Noise_Shaping_ADC_DWork.TransportDelay_PWORK.TUbufferPtrs[1];
    real_T simTime = Noise_Shaping_ADC_M->Timing.t[0];
    real_T tMinusDelay = simTime - Noise_Shaping_ADC_P.TransportDelay_Delay;
    Noise_Shaping_ADC_B.AnalogInputDelayed = rt_TDelayInterpolate(
      tMinusDelay,
      0.0,
      *tBuffer,
      *uBuffer,
      Noise_Shaping_ADC_DWork.TransportDelay_IWORK.CircularBufSize,
      &Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Last,
      Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Tail,
      Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Head,
      Noise_Shaping_ADC_P.TransportDelay_InitOutput,
      0,
      0);
  }

  /* RateTransition: '<Root>/Rate Transition' */
  if (rtmIsMajorTimeStep(Noise_Shaping_ADC_M) &&
      (Noise_Shaping_ADC_M->Timing.RateInteraction.TID1_4 == 1)) {
    Noise_Shaping_ADC_B.RateTransition =
      Noise_Shaping_ADC_DWork.RateTransition_Buffer0;
  }

  /* End of RateTransition: '<Root>/Rate Transition' */

  /* Sum: '<Root>/Sum1' */
  Noise_Shaping_ADC_B.Error = Noise_Shaping_ADC_B.AnalogInputDelayed -
    Noise_Shaping_ADC_B.RateTransition;
  if (rtmIsMajorTimeStep(Noise_Shaping_ADC_M)) {
  }

  /* Integrator: '<Root>/Integrator' */
  rtb_AnalogButterworthLPFilter = Noise_Shaping_ADC_X.Integrator_CSTATE;

  /* Signum: '<Root>/1-Bit quantizer' */
  if (rtb_AnalogButterworthLPFilter < 0.0) {
    Noise_Shaping_ADC_B.Bitquantizer = -1.0;
  } else if (rtb_AnalogButterworthLPFilter > 0.0) {
    Noise_Shaping_ADC_B.Bitquantizer = 1.0;
  } else if (rtb_AnalogButterworthLPFilter == 0.0) {
    Noise_Shaping_ADC_B.Bitquantizer = 0.0;
  } else {
    Noise_Shaping_ADC_B.Bitquantizer = rtb_AnalogButterworthLPFilter;
  }

  /* End of Signum: '<Root>/1-Bit quantizer' */

  /* StateSpace: '<Root>/Analog Butterworth LP Filter' */
  {
    rtb_AnalogButterworthLPFilter =
      Noise_Shaping_ADC_P.AnalogButterworthLPFilter_C*
      Noise_Shaping_ADC_X.AnalogButterworthLPFilter_CSTAT[4];
  }

  if (rtmIsMajorTimeStep(Noise_Shaping_ADC_M)) {
    /* ZeroOrderHold: '<Root>/Zero-Order Hold' */
    Noise_Shaping_ADC_B.bitErrorSignal = Noise_Shaping_ADC_B.Bitquantizer;

    /* S-Function (sdspfirdn2): '<Root>/FIR x4(a) Decimation' */
    outIdx = Noise_Shaping_ADC_DWork.FIRx4aDecimation_OutIdx;
    cffIdx = Noise_Shaping_ADC_DWork.FIRx4aDecimation_CoeffIdx;
    curTapIdx = Noise_Shaping_ADC_DWork.FIRx4aDecimation_TapDelayIndex;
    Noise_Shaping_ADC_DWork.FIRx4aDecimation_StatesBuff[Noise_Shaping_ADC_DWork.FIRx4aDecimation_TapDelayIndex]
      = Noise_Shaping_ADC_B.bitErrorSignal;
    for (j = 0; j < 8; j++) {
      Noise_Shaping_ADC_DWork.FIRx4aDecimation_Sums +=
        Noise_Shaping_ADC_DWork.FIRx4aDecimation_StatesBuff[curTapIdx] *
        Noise_Shaping_ADC_ConstP.pooled1[cffIdx];
      cffIdx++;
      curTapIdx -= 4;
      if (curTapIdx < 0) {
        curTapIdx += 32;
      }
    }

    curTapIdx = Noise_Shaping_ADC_DWork.FIRx4aDecimation_TapDelayIndex;
    if (Noise_Shaping_ADC_DWork.FIRx4aDecimation_TapDelayIndex + 1 >= 32) {
      curTapIdx = -1;
    }

    j = Noise_Shaping_ADC_DWork.FIRx4aDecimation_PhaseIdx;
    if (Noise_Shaping_ADC_DWork.FIRx4aDecimation_PhaseIdx + 1 >= 4) {
      Noise_Shaping_ADC_DWork.FIRx4aDecimation_OutBuff =
        Noise_Shaping_ADC_DWork.FIRx4aDecimation_Sums;
      Noise_Shaping_ADC_DWork.FIRx4aDecimation_Sums = 0.0;
      outIdx = Noise_Shaping_ADC_DWork.FIRx4aDecimation_OutIdx + 1;
      if (Noise_Shaping_ADC_DWork.FIRx4aDecimation_OutIdx + 1 >= 1) {
        outIdx = 0;
      }

      j = -1;
      cffIdx = 0;
    }

    Noise_Shaping_ADC_DWork.FIRx4aDecimation_CoeffIdx = cffIdx;
    Noise_Shaping_ADC_DWork.FIRx4aDecimation_PhaseIdx = j + 1;
    Noise_Shaping_ADC_DWork.FIRx4aDecimation_TapDelayIndex = curTapIdx + 1;
    Noise_Shaping_ADC_DWork.FIRx4aDecimation_OutIdx = outIdx;
    if ((Noise_Shaping_ADC_M->Timing.RateInteraction.TID1_2 == 1)) {
      Noise_Shaping_ADC_B.FIRx4aDecimation =
        Noise_Shaping_ADC_DWork.FIRx4aDecimation_OutBuff;
    }

    /* End of S-Function (sdspfirdn2): '<Root>/FIR x4(a) Decimation' */
  }

  /* Gain: '<Root>/Gain' */
  rtb_AnalogInput = Noise_Shaping_ADC_P.Gain_Gain *
    rtb_AnalogButterworthLPFilter;

  /* SignalGenerator: '<Root>/Signal Generator' */
  temp = Noise_Shaping_ADC_P.SignalGenerator_Frequency *
    Noise_Shaping_ADC_M->Timing.t[0];
  if (temp - floor(temp) >= 0.5) {
    Noise_Shaping_ADC_B.SignalGenerator =
      Noise_Shaping_ADC_P.SignalGenerator_Amplitude;
  } else {
    Noise_Shaping_ADC_B.SignalGenerator =
      -Noise_Shaping_ADC_P.SignalGenerator_Amplitude;
  }

  /* End of SignalGenerator: '<Root>/Signal Generator' */

  /* Sum: '<Root>/Sum' */
  Noise_Shaping_ADC_B.Sum = rtb_AnalogInput - Noise_Shaping_ADC_B.bitErrorSignal;
  if (rtmIsMajorTimeStep(Noise_Shaping_ADC_M)) {
    /* Matfile logging */
    rt_UpdateTXYLogVars(Noise_Shaping_ADC_M->rtwLogInfo,
                        (Noise_Shaping_ADC_M->Timing.t));
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(Noise_Shaping_ADC_M)) {
    /* Update for TransportDelay: '<Root>/Transport Delay' */
    {
      real_T **uBuffer = (real_T**)
        &Noise_Shaping_ADC_DWork.TransportDelay_PWORK.TUbufferPtrs[0];
      real_T **tBuffer = (real_T**)
        &Noise_Shaping_ADC_DWork.TransportDelay_PWORK.TUbufferPtrs[1];
      real_T simTime = Noise_Shaping_ADC_M->Timing.t[0];
      boolean_T bufferisfull = FALSE;
      Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Head =
        ((Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Head <
          (Noise_Shaping_ADC_DWork.TransportDelay_IWORK.CircularBufSize-1)) ?
         (Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Head+1) : 0);
      if (Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Head ==
          Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Tail) {
        bufferisfull = TRUE;
        Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Tail =
          ((Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Tail <
            (Noise_Shaping_ADC_DWork.TransportDelay_IWORK.CircularBufSize-1)) ?
           (Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Tail+1) : 0);
      }

      (*tBuffer)[Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Head] = simTime;
      (*uBuffer)[Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Head] =
        rtb_AnalogInput;
      if (bufferisfull) {
        rtsiSetSolverNeedsReset(&Noise_Shaping_ADC_M->solverInfo, TRUE);
        rtsiSetBlkStateChange(&Noise_Shaping_ADC_M->solverInfo, TRUE);
      }
    }

    /* BlkStateChangeFlag is set, need to run a minor output */
    if (rtmIsMajorTimeStep(Noise_Shaping_ADC_M)) {
      if (rtsiGetBlkStateChange(&Noise_Shaping_ADC_M->solverInfo)) {
        rtsiSetSimTimeStep(&Noise_Shaping_ADC_M->solverInfo,MINOR_TIME_STEP);
        rtsiSetBlkStateChange(&Noise_Shaping_ADC_M->solverInfo, FALSE);
        Noise_Shaping_ADC_step0();
        rtsiSetSimTimeStep(&Noise_Shaping_ADC_M->solverInfo, MAJOR_TIME_STEP);
      }
    }
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(Noise_Shaping_ADC_M)) {
    /* signal main to stop simulation */
    {                                  /* Sample time: [0.0s, 0.0s] */
      if ((rtmGetTFinal(Noise_Shaping_ADC_M)!=-1) &&
          !((rtmGetTFinal(Noise_Shaping_ADC_M)-
             (((Noise_Shaping_ADC_M->Timing.clockTick1+
                Noise_Shaping_ADC_M->Timing.clockTickH1* 4294967296.0)) *
              1.953125E-6)) > (((Noise_Shaping_ADC_M->Timing.clockTick1+
              Noise_Shaping_ADC_M->Timing.clockTickH1* 4294967296.0)) *
            1.953125E-6) * (DBL_EPSILON))) {
        rtmSetErrorStatus(Noise_Shaping_ADC_M, "Simulation finished");
      }
    }

    rt_ertODEUpdateContinuousStates(&Noise_Shaping_ADC_M->solverInfo);

    /* Update absolute time */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick0 and the high bits
     * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++Noise_Shaping_ADC_M->Timing.clockTick0)) {
      ++Noise_Shaping_ADC_M->Timing.clockTickH0;
    }

    Noise_Shaping_ADC_M->Timing.t[0] = rtsiGetSolverStopTime
      (&Noise_Shaping_ADC_M->solverInfo);

    /* Update absolute time */
    /* The "clockTick1" counts the number of times the code of this task has
     * been executed. The resolution of this integer timer is 1.953125E-6, which is the step size
     * of the task. Size of "clockTick1" ensures timer will not overflow during the
     * application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick1 and the high bits
     * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
     */
    Noise_Shaping_ADC_M->Timing.clockTick1++;
    if (!Noise_Shaping_ADC_M->Timing.clockTick1) {
      Noise_Shaping_ADC_M->Timing.clockTickH1++;
    }
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void Noise_Shaping_ADC_derivatives(void)
{
  /* Derivatives for Integrator: '<Root>/Integrator' */
  ((StateDerivatives_Noise_Shaping_ *) Noise_Shaping_ADC_M->ModelData.derivs)
    ->Integrator_CSTATE = Noise_Shaping_ADC_B.Sum;

  /* Derivatives for StateSpace: '<Root>/Analog Butterworth LP Filter' */
  {
    ((StateDerivatives_Noise_Shaping_ *) Noise_Shaping_ADC_M->ModelData.derivs
      )->AnalogButterworthLPFilter_CSTAT[0] =
      (Noise_Shaping_ADC_P.AnalogButterworthLPFilter_A[0])*
      Noise_Shaping_ADC_X.AnalogButterworthLPFilter_CSTAT[0];
    ((StateDerivatives_Noise_Shaping_ *) Noise_Shaping_ADC_M->ModelData.derivs
      )->AnalogButterworthLPFilter_CSTAT[0] +=
      Noise_Shaping_ADC_P.AnalogButterworthLPFilter_B*
      Noise_Shaping_ADC_B.SignalGenerator;
    ((StateDerivatives_Noise_Shaping_ *) Noise_Shaping_ADC_M->ModelData.derivs
      )->AnalogButterworthLPFilter_CSTAT[1] =
      (Noise_Shaping_ADC_P.AnalogButterworthLPFilter_A[1])*
      Noise_Shaping_ADC_X.AnalogButterworthLPFilter_CSTAT[0]
      + (Noise_Shaping_ADC_P.AnalogButterworthLPFilter_A[2])*
      Noise_Shaping_ADC_X.AnalogButterworthLPFilter_CSTAT[1]
      + (Noise_Shaping_ADC_P.AnalogButterworthLPFilter_A[3])*
      Noise_Shaping_ADC_X.AnalogButterworthLPFilter_CSTAT[2];
    ((StateDerivatives_Noise_Shaping_ *) Noise_Shaping_ADC_M->ModelData.derivs
      )->AnalogButterworthLPFilter_CSTAT[2] =
      (Noise_Shaping_ADC_P.AnalogButterworthLPFilter_A[4])*
      Noise_Shaping_ADC_X.AnalogButterworthLPFilter_CSTAT[1];
    ((StateDerivatives_Noise_Shaping_ *) Noise_Shaping_ADC_M->ModelData.derivs
      )->AnalogButterworthLPFilter_CSTAT[3] =
      (Noise_Shaping_ADC_P.AnalogButterworthLPFilter_A[5])*
      Noise_Shaping_ADC_X.AnalogButterworthLPFilter_CSTAT[2]
      + (Noise_Shaping_ADC_P.AnalogButterworthLPFilter_A[6])*
      Noise_Shaping_ADC_X.AnalogButterworthLPFilter_CSTAT[3]
      + (Noise_Shaping_ADC_P.AnalogButterworthLPFilter_A[7])*
      Noise_Shaping_ADC_X.AnalogButterworthLPFilter_CSTAT[4];
    ((StateDerivatives_Noise_Shaping_ *) Noise_Shaping_ADC_M->ModelData.derivs
      )->AnalogButterworthLPFilter_CSTAT[4] =
      (Noise_Shaping_ADC_P.AnalogButterworthLPFilter_A[8])*
      Noise_Shaping_ADC_X.AnalogButterworthLPFilter_CSTAT[3];
  }
}

/* Model step function for TID2 */
void Noise_Shaping_ADC_step2(void)     /* Sample time: [7.8125E-6s, 0.0s] */
{
  int32_T curTapIdx;
  int32_T outIdx;
  int32_T cffIdx;
  int32_T j;

  /* Update the flag to indicate when data transfers from
   *  Sample time: [7.8125E-6s, 0.0s] to Sample time: [3.125E-5s, 0.0s]  */
  (Noise_Shaping_ADC_M->Timing.RateInteraction.TID2_3)++;
  if ((Noise_Shaping_ADC_M->Timing.RateInteraction.TID2_3) > 3) {
    Noise_Shaping_ADC_M->Timing.RateInteraction.TID2_3 = 0;
  }

  /* S-Function (sdspfirdn2): '<Root>/FIR x4(b) Decimation' */
  outIdx = Noise_Shaping_ADC_DWork.FIRx4bDecimation_OutIdx;
  cffIdx = Noise_Shaping_ADC_DWork.FIRx4bDecimation_CoeffIdx;
  curTapIdx = Noise_Shaping_ADC_DWork.FIRx4bDecimation_TapDelayIndex;
  Noise_Shaping_ADC_DWork.FIRx4bDecimation_StatesBuff[Noise_Shaping_ADC_DWork.FIRx4bDecimation_TapDelayIndex]
    = Noise_Shaping_ADC_B.FIRx4aDecimation;
  for (j = 0; j < 8; j++) {
    Noise_Shaping_ADC_DWork.FIRx4bDecimation_Sums +=
      Noise_Shaping_ADC_DWork.FIRx4bDecimation_StatesBuff[curTapIdx] *
      Noise_Shaping_ADC_ConstP.pooled1[cffIdx];
    cffIdx++;
    curTapIdx -= 4;
    if (curTapIdx < 0) {
      curTapIdx += 32;
    }
  }

  curTapIdx = Noise_Shaping_ADC_DWork.FIRx4bDecimation_TapDelayIndex;
  if (Noise_Shaping_ADC_DWork.FIRx4bDecimation_TapDelayIndex + 1 >= 32) {
    curTapIdx = -1;
  }

  j = Noise_Shaping_ADC_DWork.FIRx4bDecimation_PhaseIdx;
  if (Noise_Shaping_ADC_DWork.FIRx4bDecimation_PhaseIdx + 1 >= 4) {
    Noise_Shaping_ADC_DWork.FIRx4bDecimation_OutBuff =
      Noise_Shaping_ADC_DWork.FIRx4bDecimation_Sums;
    Noise_Shaping_ADC_DWork.FIRx4bDecimation_Sums = 0.0;
    outIdx = Noise_Shaping_ADC_DWork.FIRx4bDecimation_OutIdx + 1;
    if (Noise_Shaping_ADC_DWork.FIRx4bDecimation_OutIdx + 1 >= 1) {
      outIdx = 0;
    }

    j = -1;
    cffIdx = 0;
  }

  Noise_Shaping_ADC_DWork.FIRx4bDecimation_CoeffIdx = cffIdx;
  Noise_Shaping_ADC_DWork.FIRx4bDecimation_PhaseIdx = j + 1;
  Noise_Shaping_ADC_DWork.FIRx4bDecimation_TapDelayIndex = curTapIdx + 1;
  Noise_Shaping_ADC_DWork.FIRx4bDecimation_OutIdx = outIdx;
  if ((Noise_Shaping_ADC_M->Timing.RateInteraction.TID2_3 == 1)) {
    Noise_Shaping_ADC_B.FIRx4bDecimation =
      Noise_Shaping_ADC_DWork.FIRx4bDecimation_OutBuff;
  }

  /* End of S-Function (sdspfirdn2): '<Root>/FIR x4(b) Decimation' */
}

/* Model step function for TID3 */
void Noise_Shaping_ADC_step3(void)     /* Sample time: [3.125E-5s, 0.0s] */
{
  int32_T curTapIdx;
  int32_T outIdx;
  int32_T cffIdx;
  int32_T j;

  /* Update the flag to indicate when data transfers from
   *  Sample time: [3.125E-5s, 0.0s] to Sample time: [0.000125s, 0.0s]  */
  (Noise_Shaping_ADC_M->Timing.RateInteraction.TID3_4)++;
  if ((Noise_Shaping_ADC_M->Timing.RateInteraction.TID3_4) > 3) {
    Noise_Shaping_ADC_M->Timing.RateInteraction.TID3_4 = 0;
  }

  /* S-Function (sdspfirdn2): '<Root>/FIR x4(c) Decimation' */
  outIdx = Noise_Shaping_ADC_DWork.FIRx4cDecimation_OutIdx;
  cffIdx = Noise_Shaping_ADC_DWork.FIRx4cDecimation_CoeffIdx;
  curTapIdx = Noise_Shaping_ADC_DWork.FIRx4cDecimation_TapDelayIndex;
  Noise_Shaping_ADC_DWork.FIRx4cDecimation_StatesBuff[Noise_Shaping_ADC_DWork.FIRx4cDecimation_TapDelayIndex]
    = Noise_Shaping_ADC_B.FIRx4bDecimation;
  for (j = 0; j < 8; j++) {
    Noise_Shaping_ADC_DWork.FIRx4cDecimation_Sums +=
      Noise_Shaping_ADC_DWork.FIRx4cDecimation_StatesBuff[curTapIdx] *
      Noise_Shaping_ADC_ConstP.pooled1[cffIdx];
    cffIdx++;
    curTapIdx -= 4;
    if (curTapIdx < 0) {
      curTapIdx += 32;
    }
  }

  curTapIdx = Noise_Shaping_ADC_DWork.FIRx4cDecimation_TapDelayIndex;
  if (Noise_Shaping_ADC_DWork.FIRx4cDecimation_TapDelayIndex + 1 >= 32) {
    curTapIdx = -1;
  }

  j = Noise_Shaping_ADC_DWork.FIRx4cDecimation_PhaseIdx;
  if (Noise_Shaping_ADC_DWork.FIRx4cDecimation_PhaseIdx + 1 >= 4) {
    Noise_Shaping_ADC_DWork.FIRx4cDecimation_OutBuff =
      Noise_Shaping_ADC_DWork.FIRx4cDecimation_Sums;
    Noise_Shaping_ADC_DWork.FIRx4cDecimation_Sums = 0.0;
    outIdx = Noise_Shaping_ADC_DWork.FIRx4cDecimation_OutIdx + 1;
    if (Noise_Shaping_ADC_DWork.FIRx4cDecimation_OutIdx + 1 >= 1) {
      outIdx = 0;
    }

    j = -1;
    cffIdx = 0;
  }

  Noise_Shaping_ADC_DWork.FIRx4cDecimation_CoeffIdx = cffIdx;
  Noise_Shaping_ADC_DWork.FIRx4cDecimation_PhaseIdx = j + 1;
  Noise_Shaping_ADC_DWork.FIRx4cDecimation_TapDelayIndex = curTapIdx + 1;
  Noise_Shaping_ADC_DWork.FIRx4cDecimation_OutIdx = outIdx;
  if ((Noise_Shaping_ADC_M->Timing.RateInteraction.TID3_4 == 1)) {
    Noise_Shaping_ADC_B.DigitizedApproximation =
      Noise_Shaping_ADC_DWork.FIRx4cDecimation_OutBuff;
  }

  /* End of S-Function (sdspfirdn2): '<Root>/FIR x4(c) Decimation' */
}

/* Model step function for TID4 */
void Noise_Shaping_ADC_step4(void)     /* Sample time: [0.000125s, 0.0s] */
{
  /* Update for RateTransition: '<Root>/Rate Transition' */
  Noise_Shaping_ADC_DWork.RateTransition_Buffer0 =
    Noise_Shaping_ADC_B.DigitizedApproximation;
}

/* Model step wrapper function for compatibility with a static main program */
void Noise_Shaping_ADC_step(int_T tid)
{
  switch (tid) {
   case 0 :
    Noise_Shaping_ADC_step0();
    break;

   case 2 :
    Noise_Shaping_ADC_step2();
    break;

   case 3 :
    Noise_Shaping_ADC_step3();
    break;

   case 4 :
    Noise_Shaping_ADC_step4();
    break;

   default :
    break;
  }
}

/* Model initialize function */
void Noise_Shaping_ADC_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)Noise_Shaping_ADC_M, 0,
                sizeof(RT_MODEL_Noise_Shaping_ADC));
  (Noise_Shaping_ADC_M)->Timing.TaskCounters.cLimit[0] = 1;
  (Noise_Shaping_ADC_M)->Timing.TaskCounters.cLimit[1] = 1;
  (Noise_Shaping_ADC_M)->Timing.TaskCounters.cLimit[2] = 4;
  (Noise_Shaping_ADC_M)->Timing.TaskCounters.cLimit[3] = 16;
  (Noise_Shaping_ADC_M)->Timing.TaskCounters.cLimit[4] = 64;

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&Noise_Shaping_ADC_M->solverInfo,
                          &Noise_Shaping_ADC_M->Timing.simTimeStep);
    rtsiSetTPtr(&Noise_Shaping_ADC_M->solverInfo, &rtmGetTPtr
                (Noise_Shaping_ADC_M));
    rtsiSetStepSizePtr(&Noise_Shaping_ADC_M->solverInfo,
                       &Noise_Shaping_ADC_M->Timing.stepSize0);
    rtsiSetdXPtr(&Noise_Shaping_ADC_M->solverInfo,
                 &Noise_Shaping_ADC_M->ModelData.derivs);
    rtsiSetContStatesPtr(&Noise_Shaping_ADC_M->solverInfo,
                         &Noise_Shaping_ADC_M->ModelData.contStates);
    rtsiSetNumContStatesPtr(&Noise_Shaping_ADC_M->solverInfo,
      &Noise_Shaping_ADC_M->Sizes.numContStates);
    rtsiSetErrorStatusPtr(&Noise_Shaping_ADC_M->solverInfo, (&rtmGetErrorStatus
      (Noise_Shaping_ADC_M)));
    rtsiSetRTModelPtr(&Noise_Shaping_ADC_M->solverInfo, Noise_Shaping_ADC_M);
  }

  rtsiSetSimTimeStep(&Noise_Shaping_ADC_M->solverInfo, MAJOR_TIME_STEP);
  Noise_Shaping_ADC_M->ModelData.intgData.y =
    Noise_Shaping_ADC_M->ModelData.odeY;
  Noise_Shaping_ADC_M->ModelData.intgData.f[0] =
    Noise_Shaping_ADC_M->ModelData.odeF[0];
  Noise_Shaping_ADC_M->ModelData.intgData.f[1] =
    Noise_Shaping_ADC_M->ModelData.odeF[1];
  Noise_Shaping_ADC_M->ModelData.intgData.f[2] =
    Noise_Shaping_ADC_M->ModelData.odeF[2];
  Noise_Shaping_ADC_M->ModelData.contStates = ((real_T *) &Noise_Shaping_ADC_X);
  rtsiSetSolverData(&Noise_Shaping_ADC_M->solverInfo, (void *)
                    &Noise_Shaping_ADC_M->ModelData.intgData);
  rtsiSetSolverName(&Noise_Shaping_ADC_M->solverInfo,"ode3");
  rtmSetTPtr(Noise_Shaping_ADC_M, &Noise_Shaping_ADC_M->Timing.tArray[0]);
  rtmSetTFinal(Noise_Shaping_ADC_M, 10.0);
  Noise_Shaping_ADC_M->Timing.stepSize0 = 1.953125E-6;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    Noise_Shaping_ADC_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(Noise_Shaping_ADC_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(Noise_Shaping_ADC_M->rtwLogInfo, (NULL));
    rtliSetLogT(Noise_Shaping_ADC_M->rtwLogInfo, "tout");
    rtliSetLogX(Noise_Shaping_ADC_M->rtwLogInfo, "");
    rtliSetLogXFinal(Noise_Shaping_ADC_M->rtwLogInfo, "");
    rtliSetSigLog(Noise_Shaping_ADC_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(Noise_Shaping_ADC_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(Noise_Shaping_ADC_M->rtwLogInfo, 0);
    rtliSetLogMaxRows(Noise_Shaping_ADC_M->rtwLogInfo, 1000);
    rtliSetLogDecimation(Noise_Shaping_ADC_M->rtwLogInfo, 1);
    rtliSetLogY(Noise_Shaping_ADC_M->rtwLogInfo, "");
    rtliSetLogYSignalInfo(Noise_Shaping_ADC_M->rtwLogInfo, (NULL));
    rtliSetLogYSignalPtrs(Noise_Shaping_ADC_M->rtwLogInfo, (NULL));
  }

  /* block I/O */
  (void) memset(((void *) &Noise_Shaping_ADC_B), 0,
                sizeof(BlockIO_Noise_Shaping_ADC));

  /* states (continuous) */
  {
    (void) memset((void *)&Noise_Shaping_ADC_X, 0,
                  sizeof(ContinuousStates_Noise_Shaping_));
  }

  /* states (dwork) */
  (void) memset((void *)&Noise_Shaping_ADC_DWork, 0,
                sizeof(D_Work_Noise_Shaping_ADC));

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(Noise_Shaping_ADC_M->rtwLogInfo, 0.0,
    rtmGetTFinal(Noise_Shaping_ADC_M), Noise_Shaping_ADC_M->Timing.stepSize0,
    (&rtmGetErrorStatus(Noise_Shaping_ADC_M)));

  /* Start for TransportDelay: '<Root>/Transport Delay' */
  {
    real_T *pBuffer =
      &Noise_Shaping_ADC_DWork.TransportDelay_RWORK.TUbufferArea[0];
    Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Tail = 0;
    Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Head = 0;
    Noise_Shaping_ADC_DWork.TransportDelay_IWORK.Last = 0;
    Noise_Shaping_ADC_DWork.TransportDelay_IWORK.CircularBufSize = 4096;
    pBuffer[0] = Noise_Shaping_ADC_P.TransportDelay_InitOutput;
    pBuffer[4096] = Noise_Shaping_ADC_M->Timing.t[0];
    Noise_Shaping_ADC_DWork.TransportDelay_PWORK.TUbufferPtrs[0] = (void *)
      &pBuffer[0];
    Noise_Shaping_ADC_DWork.TransportDelay_PWORK.TUbufferPtrs[1] = (void *)
      &pBuffer[4096];
  }

  /* Start for RateTransition: '<Root>/Rate Transition' */
  Noise_Shaping_ADC_B.RateTransition = Noise_Shaping_ADC_P.RateTransition_X0;

  /* InitializeConditions for RateTransition: '<Root>/Rate Transition' */
  Noise_Shaping_ADC_DWork.RateTransition_Buffer0 =
    Noise_Shaping_ADC_P.RateTransition_X0;

  /* InitializeConditions for Integrator: '<Root>/Integrator' */
  Noise_Shaping_ADC_X.Integrator_CSTATE = Noise_Shaping_ADC_P.Integrator_IC;

  /* InitializeConditions for StateSpace: '<Root>/Analog Butterworth LP Filter' */
  {
    int_T i1;
    real_T *xc = &Noise_Shaping_ADC_X.AnalogButterworthLPFilter_CSTAT[0];
    for (i1=0; i1 < 5; i1++) {
      xc[i1] = Noise_Shaping_ADC_P.AnalogButterworthLPFilter_X0;
    }
  }

  /* InitializeConditions for S-Function (sdspfirdn2): '<Root>/FIR x4(a) Decimation' */
  Noise_Shaping_ADC_DWork.FIRx4aDecimation_TapDelayIndex = 0;
  Noise_Shaping_ADC_DWork.FIRx4aDecimation_PhaseIdx = 3;
  Noise_Shaping_ADC_DWork.FIRx4aDecimation_CoeffIdx = 24;
  Noise_Shaping_ADC_DWork.FIRx4aDecimation_OutIdx = 0;
  Noise_Shaping_ADC_DWork.FIRx4aDecimation_OutBuff = 0.0;
  Noise_Shaping_ADC_DWork.FIRx4aDecimation_Sums = 0.0;
  memset(&Noise_Shaping_ADC_DWork.FIRx4aDecimation_StatesBuff[0], 0, sizeof
         (real_T) << 5U);

  /* InitializeConditions for S-Function (sdspfirdn2): '<Root>/FIR x4(b) Decimation' */
  Noise_Shaping_ADC_DWork.FIRx4bDecimation_TapDelayIndex = 0;
  Noise_Shaping_ADC_DWork.FIRx4bDecimation_PhaseIdx = 3;
  Noise_Shaping_ADC_DWork.FIRx4bDecimation_CoeffIdx = 24;
  Noise_Shaping_ADC_DWork.FIRx4bDecimation_OutIdx = 0;
  Noise_Shaping_ADC_DWork.FIRx4bDecimation_OutBuff = 0.0;
  Noise_Shaping_ADC_DWork.FIRx4bDecimation_Sums = 0.0;
  memset(&Noise_Shaping_ADC_DWork.FIRx4bDecimation_StatesBuff[0], 0, sizeof
         (real_T) << 5U);

  /* InitializeConditions for S-Function (sdspfirdn2): '<Root>/FIR x4(c) Decimation' */
  Noise_Shaping_ADC_DWork.FIRx4cDecimation_TapDelayIndex = 0;
  Noise_Shaping_ADC_DWork.FIRx4cDecimation_PhaseIdx = 3;
  Noise_Shaping_ADC_DWork.FIRx4cDecimation_CoeffIdx = 24;
  Noise_Shaping_ADC_DWork.FIRx4cDecimation_OutIdx = 0;
  Noise_Shaping_ADC_DWork.FIRx4cDecimation_OutBuff = 0.0;
  Noise_Shaping_ADC_DWork.FIRx4cDecimation_Sums = 0.0;
  memset(&Noise_Shaping_ADC_DWork.FIRx4cDecimation_StatesBuff[0], 0, sizeof
         (real_T) << 5U);
}

/* Model terminate function */
void Noise_Shaping_ADC_terminate(void)
{
}
