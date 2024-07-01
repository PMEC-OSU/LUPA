/*
 * File: slrealtime_code_profiling_utility_functions.h
 *
 * Code generated for instrumentation.
 *
 */

/* Functions with a C call interface */
#ifdef __cplusplus

extern "C"
{

#endif

#include "tracing.h"
#ifdef __cplusplus

}

#endif

#include "rtwtypes.h"

/* Upload code instrumentation data point */
void slrealtimeUploadEvent(
  void* pData, uint32_T numMemUnits, uint32_T sectionId);

/* Uploads data */
void xilUploadProfilingData(uint32_T sectionId);

/* Pause/restart the timer while running code associated with storing and uploading the data. */
void xilProfilingTimerFreeze(void);
void xilProfilingTimerUnFreeze(void);

/* Code instrumentation method(s) for model  */
void taskTimeStart_(uint32_T sectionId);
void taskTimeEnd_(uint32_T sectionId);
