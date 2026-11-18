#include "rtwtypes.h"
#include "rt_nonfinite.h"
#include "math.h"
real_T rtNaN = - ( real_T ) NAN ; real_T rtInf = ( real_T ) INFINITY ; real_T
rtMinusInf = - ( real_T ) INFINITY ; real32_T rtNaNF = - ( real32_T ) NAN ;
real32_T rtInfF = ( real32_T ) INFINITY ; real32_T rtMinusInfF = - ( real32_T
) INFINITY ; boolean_T rtIsInf ( real_T value ) { return ( boolean_T ) isinf
( value ) ; } boolean_T rtIsInfF ( real32_T value ) { return ( boolean_T )
isinf ( value ) ; } boolean_T rtIsNaN ( real_T value ) { return ( boolean_T )
( isnan ( value ) != 0 ) ; } boolean_T rtIsNaNF ( real32_T value ) { return ( boolean_T ) ( isnan ( value ) != 0 ) ; }
