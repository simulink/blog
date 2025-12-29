/*
 * File: myFirstSS.c
 *
 * Code generated for Simulink model 'myFirstSS'.
 *
 * Model version                  : 1.29
 * Simulink Coder version         : 25.2 (R2025b) 28-Jul-2025
 * C/C++ source code generated on : Mon Dec 29 08:05:19 2025
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "myFirstSS.h"

/* Block states (default storage) */
DW_myFirstSS_T myFirstSS_DW;

/* External inputs (root inport signals with default storage) */
ExtU_myFirstSS_T myFirstSS_U;

/* External outputs (root outports fed by signals with default storage) */
ExtY_myFirstSS_T myFirstSS_Y;

/* Real-time model */
static RT_MODEL_myFirstSS_T myFirstSS_M_;
RT_MODEL_myFirstSS_T *const myFirstSS_M = &myFirstSS_M_;

/* Model step function */
void myFirstSS_step(void)
{
  /* Outport: '<Root>/y' incorporates:
   *  DiscreteStateSpace: '<Root>/Discrete State-Space'
   */
  myFirstSS_Y.y = myFirstSS_P.C * myFirstSS_DW.DiscreteStateSpace_DSTATE;

  /* Update for DiscreteStateSpace: '<Root>/Discrete State-Space' incorporates:
   *  Inport: '<Root>/u'
   */
  myFirstSS_DW.DiscreteStateSpace_DSTATE = myFirstSS_P.A *
    myFirstSS_DW.DiscreteStateSpace_DSTATE + myFirstSS_P.B * myFirstSS_U.u;
}

/* Model initialize function */
void myFirstSS_initialize(void)
{
  /* InitializeConditions for DiscreteStateSpace: '<Root>/Discrete State-Space' */
  myFirstSS_DW.DiscreteStateSpace_DSTATE =
    myFirstSS_P.DiscreteStateSpace_InitialCondi;
}

/* Model terminate function */
void myFirstSS_terminate(void)
{
  /* (no terminate code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
