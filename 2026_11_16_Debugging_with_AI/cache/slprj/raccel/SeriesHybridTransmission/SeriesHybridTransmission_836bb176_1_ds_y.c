#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_y.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_y ( const NeDynamicSystem * LC
, const NeDynamicSystemInput * t18 , NeDsMethodOutput * out ) { static real_T
_cg_const_2 [ 8 ] = { 0.0 , 7.957747154594768 , 15.915494309189535 ,
19.89436788648692 , 23.873241463784304 , 31.83098861837907 ,
36.60563691113593 , 39.78873577297384 } ; static real_T _cg_const_1 [ 6 ] = {
104.71975511965977 , 209.43951023931953 , 314.1592653589793 ,
418.87902047863906 , 523.5987755982989 , 628.3185307179587 } ; ETTSf3049b48
t0 ; ETTSf3049b48 t1 ; real_T nonscalar2 [ 8 ] ; real_T nonscalar1 [ 6 ] ;
real_T t2 [ 1 ] ; real_T Engine_Engine_trq ; size_t t3 [ 1 ] ; size_t t4 [ 1
] ; size_t t6 [ 1 ] ; nonscalar1 [ 0 ] = _cg_const_1 [ 0 ] ; nonscalar1 [ 1 ]
= _cg_const_1 [ 1 ] ; nonscalar1 [ 2 ] = _cg_const_1 [ 2 ] ; nonscalar1 [ 3 ]
= _cg_const_1 [ 3 ] ; nonscalar1 [ 4 ] = _cg_const_1 [ 4 ] ; nonscalar1 [ 5 ]
= _cg_const_1 [ 5 ] ; nonscalar2 [ 0 ] = _cg_const_2 [ 0 ] ; nonscalar2 [ 1 ]
= _cg_const_2 [ 1 ] ; nonscalar2 [ 2 ] = _cg_const_2 [ 2 ] ; nonscalar2 [ 3 ]
= _cg_const_2 [ 3 ] ; nonscalar2 [ 4 ] = _cg_const_2 [ 4 ] ; nonscalar2 [ 5 ]
= _cg_const_2 [ 5 ] ; nonscalar2 [ 6 ] = _cg_const_2 [ 6 ] ; nonscalar2 [ 7 ]
= _cg_const_2 [ 7 ] ; out -> mY . mX [ 1ULL ] = t18 -> mX . mX [ 12ULL ] *
t18 -> mX . mX [ 13ULL ] * - 0.001 ; Engine_Engine_trq = t18 -> mX . mX [
18ULL ] + t18 -> mX . mX [ 19ULL ] ; t2 [ 0ULL ] = t18 -> mX . mX [ 1ULL ] ;
t3 [ 0 ] = 6ULL ; t4 [ 0 ] = 1ULL ; tlu2_linear_nearest_prelookup ( & t1 .
mField0 [ 0ULL ] , & t1 . mField1 [ 0ULL ] , & t1 . mField2 [ 0ULL ] , &
nonscalar1 [ 0ULL ] , & t2 [ 0ULL ] , & t3 [ 0ULL ] , & t4 [ 0ULL ] ) ; t2 [
0ULL ] = Engine_Engine_trq ; t6 [ 0 ] = 8ULL ; tlu2_linear_nearest_prelookup
( & t0 . mField0 [ 0ULL ] , & t0 . mField1 [ 0ULL ] , & t0 . mField2 [ 0ULL ]
, & nonscalar2 [ 0ULL ] , & t2 [ 0ULL ] , & t6 [ 0ULL ] , & t4 [ 0ULL ] ) ;
tlu2_2d_linear_nearest_value ( & t2 [ 0ULL ] , & t1 . mField0 [ 0ULL ] , & t1
. mField2 [ 0ULL ] , & t0 . mField0 [ 0ULL ] , & t0 . mField2 [ 0ULL ] , ( ( const _NeDynamicSystem * ) ( LC ) ) -> mField0 , & t3 [ 0ULL ] , & t6 [ 0ULL ] , & t4 [ 0ULL ] ) ; out -> mY . mX [ 5ULL ] = Engine_Engine_trq * t18 -> mX . mX [ 1ULL ] * 0.001 ; out -> mY . mX [ 0ULL ] = t18 -> mX . mX [ 0ULL ] * 0.0002777777777777778 ; out -> mY . mX [ 2ULL ] = t18 -> mX . mX [ 12ULL ] * t18 -> mX . mX [ 12ULL ] * 5.0E-5 ; out -> mY . mX [ 3ULL ] = t18 -> mX . mX [ 1ULL ] * 9.549296585513721 ; out -> mY . mX [ 4ULL ] = t2 [ 0ULL ] * 1000.0 ; out -> mY . mX [ 6ULL ] = t18 -> mX . mX [ 1ULL ] * 9.549296585513721 ; out -> mY . mX [ 7ULL ] = t18 -> mX . mX [ 6ULL ] * 9.549296585513721 ; out -> mY . mX [ 8ULL ] = t18 -> mX . mX [ 9ULL ] * 3.6000000000000005 ; ( void ) LC ; ( void ) out ; return 0 ; }
