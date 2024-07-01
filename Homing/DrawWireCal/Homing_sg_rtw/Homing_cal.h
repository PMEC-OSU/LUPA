#ifndef Homing_cal_h_
#define Homing_cal_h_
#include "rtwtypes.h"

/* Storage class 'PageSwitching', for system '<Root>' */
struct Homing_cal_type {
  real_T Gain_Gain;                    /* Expression: -1.221706459368690e-05
                                        * Referenced by: '<Root>/Gain'
                                        */
  real_T Constant_Value;               /* Expression: 4.071504459855158e+02
                                        * Referenced by: '<Root>/Constant'
                                        */
  real_T zerooffset_Value;             /* Expression: 0.25
                                        * Referenced by: '<Root>/zero offset'
                                        */
};

/* Storage class 'PageSwitching' */
extern Homing_cal_type Homing_cal_impl;
extern Homing_cal_type *Homing_cal;

#endif                                 /* Homing_cal_h_ */
