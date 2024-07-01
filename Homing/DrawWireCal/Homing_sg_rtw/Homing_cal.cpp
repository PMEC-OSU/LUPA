#include "Homing_cal.h"
#include "Homing.h"

/* Storage class 'PageSwitching' */
Homing_cal_type Homing_cal_impl = {
  /* Expression: -1.221706459368690e-05
   * Referenced by: '<Root>/Gain'
   */
  -1.22170645936869E-5,

  /* Expression: 4.071504459855158e+02
   * Referenced by: '<Root>/Constant'
   */
  407.15044598551577,

  /* Expression: 0.25
   * Referenced by: '<Root>/zero offset'
   */
  0.25
};

Homing_cal_type *Homing_cal = &Homing_cal_impl;
