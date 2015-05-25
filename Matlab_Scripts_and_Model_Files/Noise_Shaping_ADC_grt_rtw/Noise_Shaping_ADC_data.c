/*
 * Noise_Shaping_ADC_data.c
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

/* Block parameters (auto storage) */
Parameters_Noise_Shaping_ADC Noise_Shaping_ADC_P = {
  0.000697265625,                      /* Expression: 357/512000
                                        * Referenced by: '<Root>/Transport Delay'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<Root>/Transport Delay'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<Root>/Rate Transition'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<Root>/Integrator'
                                        */

  /*  Computed Parameter: AnalogButterworthLPFilter_A
   * Referenced by: '<Root>/Analog Butterworth LP Filter'
   */
  { -2513.2741228718346, 2513.2741228718346, -4066.5629538522076,
    -2513.2741228718346, 2513.2741228718346, 2513.2741228718346,
    -1553.2888309803729, -2513.2741228718346, 2513.2741228718346 },
  2513.2741228718346,                  /* Computed Parameter: AnalogButterworthLPFilter_B
                                        * Referenced by: '<Root>/Analog Butterworth LP Filter'
                                        */
  1.0,                                 /* Computed Parameter: AnalogButterworthLPFilter_C
                                        * Referenced by: '<Root>/Analog Butterworth LP Filter'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<Root>/Analog Butterworth LP Filter'
                                        */
  0.75,                                /* Expression: 3/4
                                        * Referenced by: '<Root>/Gain'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/Signal Generator'
                                        */
  80.0                                 /* Expression: 80
                                        * Referenced by: '<Root>/Signal Generator'
                                        */
};

/* Constant parameters (auto storage) */
const ConstParam_Noise_Shaping_ADC Noise_Shaping_ADC_ConstP = {
  /* Pooled Parameter (Expression: a.h)
   * Referenced by:
   *   '<Root>/FIR x4(a) Decimation'
   *   '<Root>/FIR x4(b) Decimation'
   *   '<Root>/FIR x4(c) Decimation'
   */
  { -0.0015773009669163734, -0.013344731764831721, 0.049370275913673906,
    0.14772616485208548, 0.080311043870150617, -0.0091156040250174146,
    -0.0046780770268196352, 0.0013957011754421019, 0.00021617210861662342,
    -0.012343365954933292, 0.022373544662365671, 0.1344193077955341,
    0.11042986708120012, 0.0025086414153176087, -0.00871352362918846,
    0.001021884493320653, 0.001021884493320653, -0.00871352362918846,
    0.0025086414153176087, 0.11042986708120012, 0.1344193077955341,
    0.022373544662365671, -0.012343365954933292, 0.00021617210861662342,
    0.0013957011754421019, -0.0046780770268196352, -0.0091156040250174146,
    0.080311043870150617, 0.14772616485208548, 0.049370275913673906,
    -0.013344731764831721, -0.0015773009669163734 }
};
