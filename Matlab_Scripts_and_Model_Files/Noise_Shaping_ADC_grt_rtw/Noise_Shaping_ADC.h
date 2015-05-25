/*
 * Noise_Shaping_ADC.h
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
#ifndef RTW_HEADER_Noise_Shaping_ADC_h_
#define RTW_HEADER_Noise_Shaping_ADC_h_
#ifndef Noise_Shaping_ADC_COMMON_INCLUDES_
# define Noise_Shaping_ADC_COMMON_INCLUDES_
#include <float.h>
#include <stddef.h>
#include <math.h>
#include <string.h>
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "rt_logging.h"
#include "rt_nonfinite.h"
#endif                                 /* Noise_Shaping_ADC_COMMON_INCLUDES_ */

#include "Noise_Shaping_ADC_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetFinalTime
# define rtmGetFinalTime(rtm)          ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetRTWLogInfo
# define rtmGetRTWLogInfo(rtm)         ((rtm)->rtwLogInfo)
#endif

#ifndef rtmCounterLimit
# define rtmCounterLimit(rtm, idx)     ((rtm)->Timing.TaskCounters.cLimit[(idx)])
#endif

#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef rtmStepTask
# define rtmStepTask(rtm, idx)         ((rtm)->Timing.TaskCounters.TID[(idx)] == 0)
#endif

#ifndef rtmGetStopRequested
# define rtmGetStopRequested(rtm)      ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
# define rtmSetStopRequested(rtm, val) ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
# define rtmGetStopRequestedPtr(rtm)   (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
# define rtmGetT(rtm)                  (rtmGetTPtr((rtm))[0])
#endif

#ifndef rtmGetTFinal
# define rtmGetTFinal(rtm)             ((rtm)->Timing.tFinal)
#endif

#ifndef rtmTaskCounter
# define rtmTaskCounter(rtm, idx)      ((rtm)->Timing.TaskCounters.TID[(idx)])
#endif

/* Block signals (auto storage) */
typedef struct {
  real_T AnalogInputDelayed;           /* '<Root>/Transport Delay' */
  real_T RateTransition;               /* '<Root>/Rate Transition' */
  real_T Error;                        /* '<Root>/Sum1' */
  real_T Bitquantizer;                 /* '<Root>/1-Bit quantizer' */
  real_T bitErrorSignal;               /* '<Root>/Zero-Order Hold' */
  real_T FIRx4aDecimation;             /* '<Root>/FIR x4(a) Decimation' */
  real_T FIRx4bDecimation;             /* '<Root>/FIR x4(b) Decimation' */
  real_T DigitizedApproximation;       /* '<Root>/FIR x4(c) Decimation' */
  real_T SignalGenerator;              /* '<Root>/Signal Generator' */
  real_T Sum;                          /* '<Root>/Sum' */
} BlockIO_Noise_Shaping_ADC;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real_T FIRx4aDecimation_OutBuff;     /* '<Root>/FIR x4(a) Decimation' */
  real_T FIRx4aDecimation_StatesBuff[32];/* '<Root>/FIR x4(a) Decimation' */
  real_T FIRx4bDecimation_OutBuff;     /* '<Root>/FIR x4(b) Decimation' */
  real_T FIRx4bDecimation_StatesBuff[32];/* '<Root>/FIR x4(b) Decimation' */
  real_T FIRx4cDecimation_OutBuff;     /* '<Root>/FIR x4(c) Decimation' */
  real_T FIRx4cDecimation_StatesBuff[32];/* '<Root>/FIR x4(c) Decimation' */
  real_T RateTransition_Buffer0;       /* '<Root>/Rate Transition' */
  real_T FIRx4aDecimation_Sums;        /* '<Root>/FIR x4(a) Decimation' */
  real_T FIRx4bDecimation_Sums;        /* '<Root>/FIR x4(b) Decimation' */
  real_T FIRx4cDecimation_Sums;        /* '<Root>/FIR x4(c) Decimation' */
  struct {
    real_T modelTStart;
    real_T TUbufferArea[8192];
  } TransportDelay_RWORK;              /* '<Root>/Transport Delay' */

  struct {
    void *TUbufferPtrs[2];
  } TransportDelay_PWORK;              /* '<Root>/Transport Delay' */

  struct {
    void *LoggedData;
  } Scope1_PWORK;                      /* '<Root>/Scope1' */

  int32_T FIRx4aDecimation_PhaseIdx;   /* '<Root>/FIR x4(a) Decimation' */
  int32_T FIRx4aDecimation_OutIdx;     /* '<Root>/FIR x4(a) Decimation' */
  int32_T FIRx4aDecimation_CoeffIdx;   /* '<Root>/FIR x4(a) Decimation' */
  int32_T FIRx4aDecimation_TapDelayIndex;/* '<Root>/FIR x4(a) Decimation' */
  int32_T FIRx4bDecimation_PhaseIdx;   /* '<Root>/FIR x4(b) Decimation' */
  int32_T FIRx4bDecimation_OutIdx;     /* '<Root>/FIR x4(b) Decimation' */
  int32_T FIRx4bDecimation_CoeffIdx;   /* '<Root>/FIR x4(b) Decimation' */
  int32_T FIRx4bDecimation_TapDelayIndex;/* '<Root>/FIR x4(b) Decimation' */
  int32_T FIRx4cDecimation_PhaseIdx;   /* '<Root>/FIR x4(c) Decimation' */
  int32_T FIRx4cDecimation_OutIdx;     /* '<Root>/FIR x4(c) Decimation' */
  int32_T FIRx4cDecimation_CoeffIdx;   /* '<Root>/FIR x4(c) Decimation' */
  int32_T FIRx4cDecimation_TapDelayIndex;/* '<Root>/FIR x4(c) Decimation' */
  struct {
    int_T Tail;
    int_T Head;
    int_T Last;
    int_T CircularBufSize;
  } TransportDelay_IWORK;              /* '<Root>/Transport Delay' */
} D_Work_Noise_Shaping_ADC;

/* Continuous states (auto storage) */
typedef struct {
  real_T Integrator_CSTATE;            /* '<Root>/Integrator' */
  real_T AnalogButterworthLPFilter_CSTAT[5];/* '<Root>/Analog Butterworth LP Filter' */
} ContinuousStates_Noise_Shaping_;

/* State derivatives (auto storage) */
typedef struct {
  real_T Integrator_CSTATE;            /* '<Root>/Integrator' */
  real_T AnalogButterworthLPFilter_CSTAT[5];/* '<Root>/Analog Butterworth LP Filter' */
} StateDerivatives_Noise_Shaping_;

/* State disabled  */
typedef struct {
  boolean_T Integrator_CSTATE;         /* '<Root>/Integrator' */
  boolean_T AnalogButterworthLPFilter_CSTAT[5];/* '<Root>/Analog Butterworth LP Filter' */
} StateDisabled_Noise_Shaping_ADC;

#ifndef ODE3_INTG
#define ODE3_INTG

/* ODE3 Integration Data */
typedef struct {
  real_T *y;                           /* output */
  real_T *f[3];                        /* derivatives */
} ODE3_IntgData;

#endif

/* Constant parameters (auto storage) */
typedef struct {
  /* Pooled Parameter (Expression: a.h)
   * Referenced by:
   *   '<Root>/FIR x4(a) Decimation'
   *   '<Root>/FIR x4(b) Decimation'
   *   '<Root>/FIR x4(c) Decimation'
   */
  real_T pooled1[32];
} ConstParam_Noise_Shaping_ADC;

/* Parameters (auto storage) */
struct Parameters_Noise_Shaping_ADC_ {
  real_T TransportDelay_Delay;         /* Expression: 357/512000
                                        * Referenced by: '<Root>/Transport Delay'
                                        */
  real_T TransportDelay_InitOutput;    /* Expression: 0
                                        * Referenced by: '<Root>/Transport Delay'
                                        */
  real_T RateTransition_X0;            /* Expression: 0
                                        * Referenced by: '<Root>/Rate Transition'
                                        */
  real_T Integrator_IC;                /* Expression: 0
                                        * Referenced by: '<Root>/Integrator'
                                        */
  real_T AnalogButterworthLPFilter_A[9];/* Computed Parameter: AnalogButterworthLPFilter_A
                                         * Referenced by: '<Root>/Analog Butterworth LP Filter'
                                         */
  real_T AnalogButterworthLPFilter_B;  /* Computed Parameter: AnalogButterworthLPFilter_B
                                        * Referenced by: '<Root>/Analog Butterworth LP Filter'
                                        */
  real_T AnalogButterworthLPFilter_C;  /* Computed Parameter: AnalogButterworthLPFilter_C
                                        * Referenced by: '<Root>/Analog Butterworth LP Filter'
                                        */
  real_T AnalogButterworthLPFilter_X0; /* Expression: 0
                                        * Referenced by: '<Root>/Analog Butterworth LP Filter'
                                        */
  real_T Gain_Gain;                    /* Expression: 3/4
                                        * Referenced by: '<Root>/Gain'
                                        */
  real_T SignalGenerator_Amplitude;    /* Expression: 1
                                        * Referenced by: '<Root>/Signal Generator'
                                        */
  real_T SignalGenerator_Frequency;    /* Expression: 80
                                        * Referenced by: '<Root>/Signal Generator'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_Noise_Shaping_ADC {
  const char_T *errorStatus;
  RTWLogInfo *rtwLogInfo;
  RTWSolverInfo solverInfo;

  /*
   * ModelData:
   * The following substructure contains information regarding
   * the data used in the model.
   */
  struct {
    real_T *contStates;
    real_T *derivs;
    boolean_T *contStateDisabled;
    boolean_T zCCacheNeedsReset;
    boolean_T derivCacheNeedsReset;
    boolean_T blkStateChange;
    real_T odeY[6];
    real_T odeF[3][6];
    ODE3_IntgData intgData;
  } ModelData;

  /*
   * Sizes:
   * The following substructure contains sizes information
   * for many of the model attributes such as inputs, outputs,
   * dwork, sample times, etc.
   */
  struct {
    int_T numContStates;
    int_T numSampTimes;
  } Sizes;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    uint32_T clockTick0;
    uint32_T clockTickH0;
    time_T stepSize0;
    uint32_T clockTick1;
    uint32_T clockTickH1;
    struct {
      uint8_T TID[5];
      uint8_T cLimit[5];
    } TaskCounters;

    struct {
      uint8_T TID1_2;
      uint8_T TID1_4;
      uint8_T TID2_3;
      uint8_T TID3_4;
    } RateInteraction;

    time_T tFinal;
    SimTimeStep simTimeStep;
    boolean_T stopRequestedFlag;
    time_T *t;
    time_T tArray[5];
  } Timing;
};

/* Block parameters (auto storage) */
extern Parameters_Noise_Shaping_ADC Noise_Shaping_ADC_P;

/* Block signals (auto storage) */
extern BlockIO_Noise_Shaping_ADC Noise_Shaping_ADC_B;

/* Continuous states (auto storage) */
extern ContinuousStates_Noise_Shaping_ Noise_Shaping_ADC_X;

/* Block states (auto storage) */
extern D_Work_Noise_Shaping_ADC Noise_Shaping_ADC_DWork;

/* Constant parameters (auto storage) */
extern const ConstParam_Noise_Shaping_ADC Noise_Shaping_ADC_ConstP;

/* Model entry point functions */
extern void Noise_Shaping_ADC_initialize(void);
extern void Noise_Shaping_ADC_step0(void);
extern void Noise_Shaping_ADC_step(int_T tid);
extern void Noise_Shaping_ADC_terminate(void);

/* Real-time Model object */
extern RT_MODEL_Noise_Shaping_ADC *const Noise_Shaping_ADC_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'Noise_Shaping_ADC'
 */
#endif                                 /* RTW_HEADER_Noise_Shaping_ADC_h_ */
