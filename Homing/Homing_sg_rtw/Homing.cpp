/*
 * Homing.cpp
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "Homing".
 *
 * Model version              : 1.5
 * Simulink Coder version : 24.1 (R2024a) 19-Nov-2023
 * C++ source code generated on : Fri Jun 28 17:01:55 2024
 *
 * Target selection: speedgoat.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Linux 64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "Homing.h"
#include "rtwtypes.h"
#include "Homing_private.h"
#include <cstring>

/* Block signals (default storage) */
B_Homing_T Homing_B;

/* Block states (default storage) */
DW_Homing_T Homing_DW;

/* Real-time model */
RT_MODEL_Homing_T Homing_M_ = RT_MODEL_Homing_T();
RT_MODEL_Homing_T *const Homing_M = &Homing_M_;
void Root_EtherCATInit_callback(void * const ptr_rtm )
{
  int_T status = 1;
  static const char_T *errMsg;
  int_T j;
  static char_T msg[256];
  std::string logfile( "" );           //logFileName );
  std::string DeviceType( "I8254x" );
  mwStateClear( 0 );
  LOG(info,0) << "EtherCAT going to state 8";
  status = slrtEcatInit(0,
                        DeviceType.c_str(),
                        1,
                        1,
                        (unsigned char *)xmlecatArr_0,
                        xmlecatArr_0_count,
                        0,
                        2,
                        logfile.c_str(),
                        0.001,
                        0,
                        8 );
  if (status != XPC_ECAT_OK) {
    if ((((uint32_T)status >> 16) & 0xffff) == 0xffff ) {
      // Our error conditions, negative numbers.
      switch ( status )
      {
       case -10:        // very rare, sg_getEthercatInterface can't be executed!
        errMsg =
          "Speedgoat library files for EtherCAT port identification are not properly installed on the target";
        break;

       case -11:          // rare, sg_getEthercatInterface didn't create eciface
        errMsg = "Ethernet port mapping failed";// eciface didn't get created
        break;

       case -12:
              // common, User entered a 1 based port number that isn't reserved.
        errMsg = "EtherCAT port 1 is not reserved for EtherCAT";
        break;
      }
    } else {
      if ((uint32_T)status == 0x9811000C )
        errMsg =
          "Network port 1 is not accessible to EtherCAT.\nIt is either non-existant or not configured for EtherCAT.";
      else
        errMsg = xpcPrintEtherCATError(0, 0);
    }

    rtmSetErrorStatus(Homing_M, errMsg);
    return;
  }
}

/* Model step function */
void Homing_step(void)
{
  {
    /* user code (Output function Header) */
    {
      /*------------ S-Function Block: <Root>/EtherCAT Init Process Received Frames ------------*/
      unsigned int data[6]= { 0 };

      int32_T msdata[4] = { 0 };

      xpcEtherCATReadProcessData(0,NULL);
      mwErrorGet((int_T)0,
                 &data[0], &data[1], &data[2], (int *)&data[3], &data[4], (int *)
                 &data[5]);
      memcpy(&Homing_B.EtherCATInit[0], data,6*sizeof(int32_T));
      mwErrorClear( (int_T)0 );

      // Clear all momentary triggered values
    }

    /* S-Function (slecatpdorx): '<Root>/EtherCAT PDO Receive' */
    {
      /*------------ S-Function Block: <Root>/EtherCAT PDO Receive PDO receive block  ------------*/
      static int counter= 0;
      int_T sigIdx;
      int_T bitOffset;
      uint8_T *sigOutputPtr = (uint8_T *)&Homing_B.original;
      uint8_T *ecatRxBufPtr;           // Pointer to the stack PDO rx buffer
      ecatRxBufPtr = (uint8_T *)xpcEtherCATgetPDin( 0 );
      bitOffset = 1000;
      for (sigIdx=0; sigIdx < 1; sigIdx++) {
        switch ( 7 ) {
         case SS_DOUBLE:
          ((real_T *)sigOutputPtr)[sigIdx] = *((real_T *)(ecatRxBufPtr+bitOffset/
            8));
          break;

         case SS_SINGLE:
          ((real32_T *)sigOutputPtr)[sigIdx] = *((real32_T *)(ecatRxBufPtr+
            bitOffset/8));
          break;

         case SS_INT8:
          if ((bitOffset % 8 == 0) && (32 == 8) && (4 == sizeof(int8_T))) {
            ((int8_T *)sigOutputPtr)[sigIdx] = *((int8_T *)(ecatRxBufPtr+
              bitOffset/8));
          } else {
            slrtEcatCopyBitsRx(ecatRxBufPtr, bitOffset, 32, sigOutputPtr+sigIdx*
                               4, 4);
          }
          break;

         case SS_UINT8:
          if ((bitOffset%8 == 0) && (32 == 8) && (4 == sizeof(uint8_T))) {
            ((uint8_T *)sigOutputPtr)[sigIdx] = *((uint8_T *)(ecatRxBufPtr+
              bitOffset/8));
          } else {
            slrtEcatCopyBitsRx(ecatRxBufPtr, bitOffset, 32, sigOutputPtr+sigIdx*
                               4, 4);
          }
          break;

         case SS_BOOLEAN:
          slrtEcatCopyBitsRx(ecatRxBufPtr, bitOffset, 32, sigOutputPtr+sigIdx*4,
                             4);
          break;

         case SS_INT16:
          if ((bitOffset%16 == 0) && (32 == 16) && (4 == sizeof(int16_T))) {
            ((int16_T *)sigOutputPtr)[sigIdx] = *((int16_T *)(ecatRxBufPtr+
              bitOffset/8));
          } else {
            slrtEcatCopyBitsRx(ecatRxBufPtr, bitOffset, 32, sigOutputPtr+sigIdx*
                               4, 4);
          }
          break;

         case SS_UINT16:
          if ((bitOffset%16 == 0) && (32 == 16) && (4 == sizeof(uint16_T))) {
            ((uint16_T *)sigOutputPtr)[sigIdx] = *((uint16_T *)(ecatRxBufPtr+
              bitOffset/8));
          } else {
            slrtEcatCopyBitsRx(ecatRxBufPtr, bitOffset, 32, sigOutputPtr+sigIdx*
                               4, 4);
          }
          break;

         case SS_INT32:
          if ((bitOffset%32 == 0) && (32 == 32) && (4 == sizeof(int32_T))) {
            ((int32_T *)sigOutputPtr)[sigIdx] = *((int32_T *)(ecatRxBufPtr+
              bitOffset/8));
          } else {
            slrtEcatCopyBitsRx(ecatRxBufPtr, bitOffset, 32, sigOutputPtr+sigIdx*
                               4, 4);
          }
          break;

         case SS_UINT32:
          if ((bitOffset%32 == 0) && (32 == 32) && (4 == sizeof(uint32_T))) {
            ((uint32_T *)sigOutputPtr)[sigIdx] = *((uint32_T *)(ecatRxBufPtr+
              bitOffset/8));
          } else {
            slrtEcatCopyBitsRx(ecatRxBufPtr, bitOffset, 32, sigOutputPtr+sigIdx*
                               4, 4);
          }
          break;

         default:
          /* Fatal error, unsupported type. This is checked in getDataSizes, so it should never happen. */
          break;
        }

        bitOffset += 32;
      }
    }

    /* DataTypeConversion: '<Root>/Data Type Conversion' */
    Homing_B.double_p = Homing_B.original;

    /* user code (Output function Trailer) */
    {
      /*------------ S-Function Block: <Root>/EtherCAT Init Write Process Data ,Run Admin Tasks and then Write Acyclic Data------------*/
      xpcEtherCATWriteProcessData(0,NULL);
      xpcEtherCATExecAdminJobs(0);
      xpcEtherCATWriteAcyclicData(0);
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++Homing_M->Timing.clockTick0)) {
    ++Homing_M->Timing.clockTickH0;
  }

  Homing_M->Timing.taskTime0 = Homing_M->Timing.clockTick0 *
    Homing_M->Timing.stepSize0 + Homing_M->Timing.clockTickH0 *
    Homing_M->Timing.stepSize0 * 4294967296.0;
}

/* Model initialize function */
void Homing_initialize(void)
{
  /* Registration code */
  Homing_M->Timing.stepSize0 = 0.001;

  /* block I/O */
  (void) std::memset((static_cast<void *>(&Homing_B)), 0,
                     sizeof(B_Homing_T));

  /* states (dwork) */
  (void) std::memset(static_cast<void *>(&Homing_DW), 0,
                     sizeof(DW_Homing_T));

  /* Start for S-Function (slecatinit): '<Root>/EtherCAT Init' */
  slrealtime::StartCallbackService::registerCB( std::bind
    ( Root_EtherCATInit_callback, nullptr ), 10 );
}

/* Model terminate function */
void Homing_terminate(void)
{
  /* user code (Terminate function Trailer) */

  /*------------ S-Function Block: <Root>/EtherCAT Init Process Shutdown Network ------------*/
  {
    int_T status;
    status = xpcEtherCATstop(0, 1000 );/* 1 second timeout */
  }
}
