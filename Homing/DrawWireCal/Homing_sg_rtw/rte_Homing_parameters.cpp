#include "rte_Homing_parameters.h"
#include "Homing.h"
#include "Homing_cal.h"

extern Homing_cal_type Homing_cal_impl;
namespace slrealtime
{
  /* Description of SEGMENTS */
  SegmentVector segmentInfo {
    { (void*)&Homing_cal_impl, (void**)&Homing_cal, sizeof(Homing_cal_type), 2 }
  };

  SegmentVector &getSegmentVector(void)
  {
    return segmentInfo;
  }
}                                      // slrealtime
