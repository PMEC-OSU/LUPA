/*
 * File: slrealtime_code_profiling_utility_functions.cpp
 *
 * Code generated for instrumentation.
 *
 */

#include "slrealtime_code_profiling_utility_functions.h"

/* Code instrumentation offset(s) for model  */
#define taskTimeStart__offset          0
#define taskTimeEnd__offset            0

/* A function parameter may be intentionally unused */
#ifndef UNUSED_PARAMETER
# if defined(__LCC__)
#   define UNUSED_PARAMETER(x)
# else
#   define UNUSED_PARAMETER(x)         (void) (x)
# endif
#endif

void xilUploadProfilingData(uint32_T sectionId)
{
  slrealtimeAddEvent(sectionId);
}

/* For real-time, multitasking case this function is stubbed out. */
#define xilProfilingTimerFreezeInternal() {}

void xilProfilingTimerFreeze(void)
{
}

#define xilProfilingTimerUnFreezeInternal() {}

void xilProfilingTimerUnFreeze(void)
{
}

/* Tic/Toc methods for task profiling */
#define taskTimeStart(id)              { \
 xilUploadProfilingData(id); \
 xilProfilingTimerUnFreezeInternal(); \
}
#define taskTimeEnd(id)                { \
 uint32_T sectionIdNeg = id; \
 sectionIdNeg = ~sectionIdNeg; \
 xilProfilingTimerFreezeInternal(); \
 xilUploadProfilingData(sectionIdNeg); \
}

/* Code instrumentation method(s) for model  */
void taskTimeStart_(uint32_T sectionId)
{
  taskTimeStart(taskTimeStart__offset + sectionId);
}

void taskTimeEnd_(uint32_T sectionId)
{
  taskTimeEnd(taskTimeEnd__offset + sectionId);
}
