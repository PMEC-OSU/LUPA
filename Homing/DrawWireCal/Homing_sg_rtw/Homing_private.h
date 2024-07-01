/*
 * Homing_private.h
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

#ifndef Homing_private_h_
#define Homing_private_h_
#include "rtwtypes.h"
#include "multiword_types.h"
#include "Homing_types.h"
#include "Homing.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"

extern unsigned int xmlecatArr_0_count;
extern unsigned char xmlecatArr_0[];
extern int_T slrtEcatDCM[8];           // From master shift controller
namespace slrealtime
{
  namespace tracing
  {
    struct IamRoot;
  }
}

extern void* slrtRegisterSignalToLoggingService(uintptr_t sigAddr);

#endif                                 /* Homing_private_h_ */
