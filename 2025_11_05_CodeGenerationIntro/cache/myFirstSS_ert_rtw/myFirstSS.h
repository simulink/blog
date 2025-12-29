/*
 * File: myFirstSS.h
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

#ifndef myFirstSS_h_
#define myFirstSS_h_
#ifndef myFirstSS_COMMON_INCLUDES_
#define myFirstSS_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "math.h"
#endif                                 /* myFirstSS_COMMON_INCLUDES_ */

#include "myFirstSS_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

/* Block states (default storage) for system '<Root>' */
typedef struct {
  real_T DiscreteStateSpace_DSTATE;    /* '<Root>/Discrete State-Space' */
} DW_myFirstSS_T;

/* External inputs (root inport signals with default storage) */
typedef struct {
  real_T u;                            /* '<Root>/u' */
} ExtU_myFirstSS_T;

/* External outputs (root outports fed by signals with default storage) */
typedef struct {
  real_T y;                            /* '<Root>/y' */
} ExtY_myFirstSS_T;

/* Parameters (default storage) */
struct P_myFirstSS_T_ {
  real_T A;                            /* Variable: A
                                        * Referenced by: '<Root>/Discrete State-Space'
                                        */
  real_T B;                            /* Variable: B
                                        * Referenced by: '<Root>/Discrete State-Space'
                                        */
  real_T C;                            /* Variable: C
                                        * Referenced by: '<Root>/Discrete State-Space'
                                        */
  real_T D;                            /* Variable: D
                                        * Referenced by: '<Root>/Discrete State-Space'
                                        */
  real_T DiscreteStateSpace_InitialCondi;/* Expression: 0
                                          * Referenced by: '<Root>/Discrete State-Space'
                                          */
};

/* Real-time Model Data Structure */
struct tag_RTM_myFirstSS_T {
  const char_T * volatile errorStatus;
};

/* Block parameters (default storage) */
extern P_myFirstSS_T myFirstSS_P;

/* Block states (default storage) */
extern DW_myFirstSS_T myFirstSS_DW;

/* External inputs (root inport signals with default storage) */
extern ExtU_myFirstSS_T myFirstSS_U;

/* External outputs (root outports fed by signals with default storage) */
extern ExtY_myFirstSS_T myFirstSS_Y;

/* Model entry point functions */
extern void myFirstSS_initialize(void);
extern void myFirstSS_step(void);
extern void myFirstSS_terminate(void);

/* Real-time Model object */
extern RT_MODEL_myFirstSS_T *const myFirstSS_M;

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
 * '<Root>' : 'myFirstSS'
 */
#endif                                 /* myFirstSS_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
