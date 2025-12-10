/*
 * File: testCG.h
 *
 * Code generated for Simulink model 'testCG'.
 *
 * Model version                  : 1.20
 * Simulink Coder version         : 25.2 (R2025b) 28-Jul-2025
 * C/C++ source code generated on : Tue Dec  9 19:54:37 2025
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef testCG_h_
#define testCG_h_
#ifndef testCG_COMMON_INCLUDES_
#define testCG_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "math.h"
#endif                                 /* testCG_COMMON_INCLUDES_ */

#include "testCG_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

/* Block states (default storage) for system '<Root>' */
typedef struct {
  real_T UnitDelay_DSTATE;             /* '<Root>/Unit Delay' */
} DW_testCG_T;

/* External inputs (root inport signals with default storage) */
typedef struct {
  real_T u;                            /* '<Root>/u' */
} ExtU_testCG_T;

/* External outputs (root outports fed by signals with default storage) */
typedef struct {
  real_T y;                            /* '<Root>/y' */
} ExtY_testCG_T;

/* Parameters (default storage) */
struct P_testCG_T_ {
  real_T A;                            /* Variable: A
                                        * Referenced by: '<Root>/GainA'
                                        */
  real_T B;                            /* Variable: B
                                        * Referenced by: '<Root>/GainB'
                                        */
  real_T C;                            /* Variable: C
                                        * Referenced by: '<Root>/GainC'
                                        */
  real_T D;                            /* Variable: D
                                        * Referenced by: '<Root>/GainD'
                                        */
  real_T UnitDelay_InitialCondition;   /* Expression: 0
                                        * Referenced by: '<Root>/Unit Delay'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_testCG_T {
  const char_T * volatile errorStatus;
};

/* Block parameters (default storage) */
extern P_testCG_T testCG_P;

/* Block states (default storage) */
extern DW_testCG_T testCG_DW;

/* External inputs (root inport signals with default storage) */
extern ExtU_testCG_T testCG_U;

/* External outputs (root outports fed by signals with default storage) */
extern ExtY_testCG_T testCG_Y;

/* Model entry point functions */
extern void testCG_initialize(void);
extern void testCG_step(void);
extern void testCG_terminate(void);

/* Real-time Model object */
extern RT_MODEL_testCG_T *const testCG_M;

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
 * '<Root>' : 'testCG'
 */
#endif                                 /* testCG_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
