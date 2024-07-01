/*
 * Homing.h
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "Homing".
 *
 * Model version              : 1.18
 * Simulink Coder version : 24.1 (R2024a) 19-Nov-2023
 * C++ source code generated on : Mon Jul  1 10:13:02 2024
 *
 * Target selection: speedgoat.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Linux 64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef Homing_h_
#define Homing_h_
#include <logsrv.h>
#include "rtwtypes.h"
#include "rtw_extmode.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "stddef.h"
#include "stdlib.h"
#include "string"
#include "Logger.hpp"
#include "slecatutils.h"
#include "StartCallbackAPI.h"
#include "sysran_types.h"
#include "sl_types_def.h"
#include "Homing_types.h"
#include "Homing_cal.h"
#include <cstring>

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
#define rtmGetStopRequested(rtm)       ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
#define rtmSetStopRequested(rtm, val)  ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
#define rtmGetStopRequestedPtr(rtm)    (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
#define rtmGetT(rtm)                   ((rtm)->Timing.taskTime0)
#endif

/* Block signals (default storage) */
struct B_Homing_T {
  real_T DataTypeConversion;           /* '<Root>/Data Type Conversion' */
  real_T Gain;                         /* '<Root>/Gain' */
  real_T Subtract;                     /* '<Root>/Subtract' */
  real_T linPos_m;                     /* '<Root>/Subtract1' */
  uint32_T original;                   /* '<Root>/EtherCAT PDO Receive' */
  int32_T EtherCATInit[6];             /* '<Root>/EtherCAT Init' */
};

/* Block states (default storage) for system '<Root>' */
struct DW_Homing_T {
  struct {
    real_T EXECRATIO;
  } EtherCATInit_RWORK;                /* '<Root>/EtherCAT Init' */

  struct {
    void *AQHandles;
  } TAQSigLogging_InsertedFor_Ether;   /* synthesized block */

  struct {
    void *AQHandles;
  } TAQSigLogging_InsertedFor_Subtr;   /* synthesized block */

  int_T EtherCATPDOReceive_IWORK[7];   /* '<Root>/EtherCAT PDO Receive' */
};

/* Real-time Model Data Structure */
struct tag_RTM_Homing_T {
  const char_T *errorStatus;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    time_T taskTime0;
    uint32_T clockTick0;
    uint32_T clockTickH0;
    time_T stepSize0;
    boolean_T stopRequestedFlag;
  } Timing;
};

/* Block signals (default storage) */
#ifdef __cplusplus

extern "C"
{

#endif

  extern struct B_Homing_T Homing_B;

#ifdef __cplusplus

}

#endif

/* Block states (default storage) */
extern struct DW_Homing_T Homing_DW;

#ifdef __cplusplus

extern "C"
{

#endif

  /* Model entry point functions */
  extern void Homing_initialize(void);
  extern void Homing_step(void);
  extern void Homing_terminate(void);

#ifdef __cplusplus

}

#endif

/* Real-time Model object */
#ifdef __cplusplus

extern "C"
{

#endif

  extern RT_MODEL_Homing_T *const Homing_M;

#ifdef __cplusplus

}

#endif

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
 * '<Root>' : 'Homing'
 */
#endif                                 /* Homing_h_ */
