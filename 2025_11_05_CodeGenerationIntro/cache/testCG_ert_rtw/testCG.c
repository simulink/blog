/*
 * File: testCG.c
 *
 * Code generated for Simulink model 'testCG'.
 *
 * Model version                  : 1.20
 * Simulink Coder version         : 25.2 (R2025b) 28-Jul-2025
 * C/C++ source code generated on : Mon Nov  3 19:40:51 2025
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "testCG.h"

/* Block states (default storage) */
DW_testCG_T testCG_DW;

/* External inputs (root inport signals with default storage) */
ExtU_testCG_T testCG_U;

/* External outputs (root outports fed by signals with default storage) */
ExtY_testCG_T testCG_Y;

/* Real-time model */
static RT_MODEL_testCG_T testCG_M_;
RT_MODEL_testCG_T *const testCG_M = &testCG_M_;

/* Model step function */
void testCG_step(void)
{
  /* Outport: '<Root>/y' incorporates:
   *  Gain: '<Root>/GainC'
   *  Gain: '<Root>/GainD'
   *  Inport: '<Root>/u'
   *  Sum: '<Root>/SumCD'
   *  UnitDelay: '<Root>/Unit Delay'
   */
  testCG_Y.y = testCG_P.C * testCG_DW.UnitDelay_DSTATE + testCG_P.D * testCG_U.u;

  /* Sum: '<Root>/SumAB' incorporates:
   *  Gain: '<Root>/GainA'
   *  Gain: '<Root>/GainB'
   *  Inport: '<Root>/u'
   *  UnitDelay: '<Root>/Unit Delay'
   */
  testCG_DW.UnitDelay_DSTATE = testCG_P.A * testCG_DW.UnitDelay_DSTATE +
    testCG_P.B * testCG_U.u;
}

/* Model initialize function */
void testCG_initialize(void)
{
  /* InitializeConditions for UnitDelay: '<Root>/Unit Delay' */
  testCG_DW.UnitDelay_DSTATE = testCG_P.UnitDelay_InitialCondition;
}

/* Model terminate function */
void testCG_terminate(void)
{
  /* (no terminate code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
