#ifndef rt_nonfinite_h_
#define rt_nonfinite_h_
#include "rtwtypes.h"
extern real_T rtInf ; extern real_T rtMinusInf ; extern real_T rtNaN ; extern
real32_T rtInfF ; extern real32_T rtMinusInfF ; extern real32_T rtNaNF ;
extern boolean_T rtIsInf ( real_T value ) ; extern boolean_T rtIsInfF ( real32_T
value ) ; extern boolean_T rtIsNaN ( real_T value ) ; extern boolean_T
rtIsNaNF ( real32_T value ) ;
#endif
