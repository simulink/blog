#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_log.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_log ( const NeDynamicSystem *
LC , const NeDynamicSystemInput * t23 , NeDsMethodOutput * out ) { static
real_T _cg_const_2 [ 8 ] = { 0.0 , 7.957747154594768 , 15.915494309189535 ,
19.89436788648692 , 23.873241463784304 , 31.83098861837907 ,
36.60563691113593 , 39.78873577297384 } ; static real_T _cg_const_1 [ 6 ] = {
104.71975511965977 , 209.43951023931953 , 314.1592653589793 ,
418.87902047863906 , 523.5987755982989 , 628.3185307179587 } ; ETTSf3049b48
t0 ; ETTSf3049b48 t1 ; real_T nonscalar2 [ 8 ] ; real_T nonscalar1 [ 6 ] ;
real_T t2 [ 1 ] ; real_T Battery_Calculations_I2_O ; real_T
Battery_Calculations_Power_O ; real_T Battery_DC_Voltage_Source_p_v ; real_T
Engine_Engine_P ; real_T Engine_Engine_trq ; real_T Vehicle_Body_Tire_Left_N
; size_t t3 [ 1 ] ; size_t t4 [ 1 ] ; size_t t6 [ 1 ] ; nonscalar1 [ 0 ] =
_cg_const_1 [ 0 ] ; nonscalar1 [ 1 ] = _cg_const_1 [ 1 ] ; nonscalar1 [ 2 ] =
_cg_const_1 [ 2 ] ; nonscalar1 [ 3 ] = _cg_const_1 [ 3 ] ; nonscalar1 [ 4 ] =
_cg_const_1 [ 4 ] ; nonscalar1 [ 5 ] = _cg_const_1 [ 5 ] ; nonscalar2 [ 0 ] =
_cg_const_2 [ 0 ] ; nonscalar2 [ 1 ] = _cg_const_2 [ 1 ] ; nonscalar2 [ 2 ] =
_cg_const_2 [ 2 ] ; nonscalar2 [ 3 ] = _cg_const_2 [ 3 ] ; nonscalar2 [ 4 ] =
_cg_const_2 [ 4 ] ; nonscalar2 [ 5 ] = _cg_const_2 [ 5 ] ; nonscalar2 [ 6 ] =
_cg_const_2 [ 6 ] ; nonscalar2 [ 7 ] = _cg_const_2 [ 7 ] ;
Battery_Calculations_I2_O = t23 -> mX . mX [ 12ULL ] * t23 -> mX . mX [ 12ULL
] ; Battery_Calculations_Power_O = t23 -> mX . mX [ 12ULL ] * t23 -> mX . mX
[ 13ULL ] * - 0.001 ; Battery_DC_Voltage_Source_p_v = t23 -> mX . mX [ 13ULL
] + t23 -> mX . mX [ 14ULL ] ; out -> mLOG . mX [ 27ULL ] = - ( - t23 ->
mDP_R . mX [ 1ULL ] * t23 -> mX . mX [ 12ULL ] * t23 -> mX . mX [ 12ULL ] ) ;
out -> mLOG . mX [ 33ULL ] = - t23 -> mX . mX [ 16ULL ] - t23 -> mX . mX [
17ULL ] ; Engine_Engine_trq = t23 -> mX . mX [ 18ULL ] + t23 -> mX . mX [
19ULL ] ; t2 [ 0ULL ] = t23 -> mX . mX [ 1ULL ] ; t3 [ 0 ] = 6ULL ; t4 [ 0 ]
= 1ULL ; tlu2_linear_nearest_prelookup ( & t1 . mField0 [ 0ULL ] , & t1 .
mField1 [ 0ULL ] , & t1 . mField2 [ 0ULL ] , & nonscalar1 [ 0ULL ] , & t2 [
0ULL ] , & t3 [ 0ULL ] , & t4 [ 0ULL ] ) ; t2 [ 0ULL ] = Engine_Engine_trq ;
t6 [ 0 ] = 8ULL ; tlu2_linear_nearest_prelookup ( & t0 . mField0 [ 0ULL ] , &
t0 . mField1 [ 0ULL ] , & t0 . mField2 [ 0ULL ] , & nonscalar2 [ 0ULL ] , &
t2 [ 0ULL ] , & t6 [ 0ULL ] , & t4 [ 0ULL ] ) ; tlu2_2d_linear_nearest_value
( & t2 [ 0ULL ] , & t1 . mField0 [ 0ULL ] , & t1 . mField2 [ 0ULL ] , & t0 .
mField0 [ 0ULL ] , & t0 . mField2 [ 0ULL ] , ( ( const _NeDynamicSystem * ) ( LC
) ) -> mField0 , & t3 [ 0ULL ] , & t6 [ 0ULL ] , & t4 [ 0ULL ] ) ;
Engine_Engine_P = Engine_Engine_trq * t23 -> mX . mX [ 1ULL ] * 0.001 ; if ( t23
-> mX . mX [ 1ULL ] > 52.35987755982988 ) { out -> mLOG . mX [ 50ULL ] = tanh
( ( t23 -> mX . mX [ 1ULL ] - 52.35987755982988 ) * 4.0 / 2.0943951023931953
) ; } else { out -> mLOG . mX [ 50ULL ] = 0.0 ; } out -> mLOG . mX [ 51ULL ]
= ( t23 -> mX . mX [ 1ULL ] * 0.1507257277324033 + t23 -> mX . mX [ 1ULL ] *
t23 -> mX . mX [ 1ULL ] * - 0.00026169539585165624 ) + 86.81178714103382 ;
out -> mLOG . mX [ 67ULL ] = t23 -> mU . mX [ 1ULL ] ; out -> mLOG . mX [
71ULL ] = t23 -> mX . mX [ 19ULL ] * t23 -> mX . mX [ 19ULL ] * t23 -> mDP_R
. mX [ 6ULL ] * 0.10471975511965977 ; if ( t23 -> mX . mX [ 1ULL ] < - 500.0
) { out -> mLOG . mX [ 74ULL ] = - 200.0 / ( t23 -> mX . mX [ 1ULL ] == 0.0 ?
1.0E-16 : t23 -> mX . mX [ 1ULL ] ) * 1000.0 ; } else if ( t23 -> mX . mX [
1ULL ] < 500.0 ) { out -> mLOG . mX [ 74ULL ] = 400.0 ; } else { out -> mLOG
. mX [ 74ULL ] = 200.0 / ( t23 -> mX . mX [ 1ULL ] == 0.0 ? 1.0E-16 : t23 ->
mX . mX [ 1ULL ] ) * 1000.0 ; } out -> mLOG . mX [ 88ULL ] = t23 -> mU . mX [
2ULL ] ; out -> mLOG . mX [ 92ULL ] = t23 -> mX . mX [ 21ULL ] * t23 -> mX .
mX [ 21ULL ] * t23 -> mDP_R . mX [ 9ULL ] * 0.10471975511965977 ; if ( t23 ->
mX . mX [ 6ULL ] < - 500.0 ) { out -> mLOG . mX [ 95ULL ] = - 200.0 / ( t23
-> mX . mX [ 6ULL ] == 0.0 ? 1.0E-16 : t23 -> mX . mX [ 6ULL ] ) * 1000.0 ; }
else if ( t23 -> mX . mX [ 6ULL ] < 500.0 ) { out -> mLOG . mX [ 95ULL ] =
400.0 ; } else { out -> mLOG . mX [ 95ULL ] = 200.0 / ( t23 -> mX . mX [ 6ULL
] == 0.0 ? 1.0E-16 : t23 -> mX . mX [ 6ULL ] ) * 1000.0 ; }
Vehicle_Body_Tire_Left_N = t23 -> mX . mX [ 22ULL ] * 0.08333333333333333 +
2746.7999999999997 ; out -> mLOG . mX [ 115ULL ] = ( ( - t23 -> mX . mX [
21ULL ] + t23 -> mX . mX [ 24ULL ] * - 0.3 ) - t23 -> mX . mX [ 25ULL ] ) +
t23 -> mX . mX [ 26ULL ] * - 0.3 ; out -> mLOG . mX [ 120ULL ] = - t23 -> mX
. mX [ 27ULL ] - t23 -> mX . mX [ 22ULL ] ; out -> mLOG . mX [ 146ULL ] = - ( -
( - ( t23 -> mX . mX [ 22ULL ] * 0.5 ) / 3.0 / 2.0 ) - 3139.2000000000003 ) ;
out -> mLOG . mX [ 149ULL ] = ( ( real_T ) ( t23 -> mX . mX [ 9ULL ] >= 0.0 )
* 2.0 - 1.0 ) * t23 -> mX . mX [ 9ULL ] * t23 -> mX . mX [ 9ULL ] * t23 ->
mDP_R . mX [ 10ULL ] * t23 -> mDP_R . mX [ 11ULL ] * t23 -> mDP_R . mX [
12ULL ] * 0.5 * t23 -> mX . mX [ 9ULL ] ; out -> mLOG . mX [ 0ULL ] = t23 ->
mX . mX [ 12ULL ] ; out -> mLOG . mX [ 1ULL ] = t23 -> mX . mX [ 0ULL ] *
0.0002777777777777778 ; out -> mLOG . mX [ 2ULL ] = t23 -> mX . mX [ 0ULL ] *
0.0002777777777777778 ; out -> mLOG . mX [ 3ULL ] = t23 -> mX . mX [ 0ULL ] *
0.0002777777777777778 ; out -> mLOG . mX [ 4ULL ] = - t23 -> mX . mX [ 12ULL
] ; out -> mLOG . mX [ 5ULL ] = - t23 -> mX . mX [ 12ULL ] ; out -> mLOG . mX
[ 6ULL ] = - t23 -> mX . mX [ 12ULL ] ; out -> mLOG . mX [ 7ULL ] =
Battery_Calculations_I2_O ; out -> mLOG . mX [ 8ULL ] = t23 -> mX . mX [
13ULL ] ; out -> mLOG . mX [ 9ULL ] = - t23 -> mX . mX [ 12ULL ] ; out ->
mLOG . mX [ 10ULL ] = Battery_Calculations_Power_O * 1000.0 ; out -> mLOG .
mX [ 11ULL ] = Battery_Calculations_Power_O ; out -> mLOG . mX [ 12ULL ] =
Battery_Calculations_I2_O ; out -> mLOG . mX [ 13ULL ] =
Battery_Calculations_I2_O * 0.05 ; out -> mLOG . mX [ 14ULL ] =
Battery_Calculations_I2_O * 5.0E-5 ; out -> mLOG . mX [ 15ULL ] = t23 -> mX .
mX [ 13ULL ] ; out -> mLOG . mX [ 16ULL ] = - t23 -> mX . mX [ 12ULL ] ; out
-> mLOG . mX [ 17ULL ] = t23 -> mX . mX [ 12ULL ] ; out -> mLOG . mX [ 18ULL
] = - t23 -> mX . mX [ 12ULL ] ; out -> mLOG . mX [ 19ULL ] = - t23 -> mX .
mX [ 12ULL ] ; out -> mLOG . mX [ 20ULL ] = t23 -> mX . mX [ 12ULL ] ; out ->
mLOG . mX [ 21ULL ] = Battery_DC_Voltage_Source_p_v ; out -> mLOG . mX [
22ULL ] = Battery_DC_Voltage_Source_p_v ; out -> mLOG . mX [ 23ULL ] = - t23
-> mX . mX [ 12ULL ] ; out -> mLOG . mX [ 24ULL ] = t23 -> mX . mX [ 13ULL ]
; out -> mLOG . mX [ 25ULL ] = Battery_DC_Voltage_Source_p_v ; out -> mLOG .
mX [ 26ULL ] = t23 -> mX . mX [ 14ULL ] ; out -> mLOG . mX [ 28ULL ] = t23 ->
mX . mX [ 13ULL ] ; out -> mLOG . mX [ 29ULL ] = t23 -> mX . mX [ 13ULL ] ;
out -> mLOG . mX [ 30ULL ] = t23 -> mX . mX [ 13ULL ] ; out -> mLOG . mX [
31ULL ] = t23 -> mX . mX [ 15ULL ] ; out -> mLOG . mX [ 32ULL ] = - t23 -> mX
. mX [ 12ULL ] ; out -> mLOG . mX [ 34ULL ] = t23 -> mX . mX [ 13ULL ] ; out
-> mLOG . mX [ 35ULL ] = t23 -> mX . mX [ 15ULL ] ; out -> mLOG . mX [ 36ULL
] = t23 -> mX . mX [ 13ULL ] ; out -> mLOG . mX [ 37ULL ] = t23 -> mX . mX [
15ULL ] ; out -> mLOG . mX [ 38ULL ] = t23 -> mX . mX [ 13ULL ] ; out -> mLOG
. mX [ 39ULL ] = t23 -> mX . mX [ 1ULL ] ; out -> mLOG . mX [ 40ULL ] = t2 [
0ULL ] ; out -> mLOG . mX [ 41ULL ] = Engine_Engine_P * 1000.0 ; out -> mLOG
. mX [ 42ULL ] = t23 -> mU . mX [ 0ULL ] ; out -> mLOG . mX [ 43ULL ] = t23
-> mX . mX [ 20ULL ] ; out -> mLOG . mX [ 44ULL ] = t23 -> mX . mX [ 1ULL ] ;
out -> mLOG . mX [ 45ULL ] = t23 -> mX . mX [ 1ULL ] ; out -> mLOG . mX [
46ULL ] = t23 -> mX . mX [ 1ULL ] * 9.549296585513721 ; out -> mLOG . mX [
47ULL ] = t23 -> mX . mX [ 18ULL ] ; out -> mLOG . mX [ 48ULL ] = t23 -> mX .
mX [ 2ULL ] ; out -> mLOG . mX [ 49ULL ] = t23 -> mX . mX [ 1ULL ] ; out ->
mLOG . mX [ 52ULL ] = Engine_Engine_trq ; out -> mLOG . mX [ 53ULL ] = t23 ->
mX . mX [ 1ULL ] ; out -> mLOG . mX [ 54ULL ] = t23 -> mX . mX [ 1ULL ] ; out
-> mLOG . mX [ 55ULL ] = t23 -> mX . mX [ 3ULL ] ; out -> mLOG . mX [ 56ULL ]
= t23 -> mX . mX [ 1ULL ] ; out -> mLOG . mX [ 57ULL ] = t23 -> mX . mX [
1ULL ] ; out -> mLOG . mX [ 58ULL ] = t23 -> mX . mX [ 3ULL ] ; out -> mLOG .
mX [ 59ULL ] = t23 -> mX . mX [ 1ULL ] * 9.549296585513721 ; out -> mLOG . mX
[ 60ULL ] = t2 [ 0ULL ] ; out -> mLOG . mX [ 61ULL ] = t2 [ 0ULL ] * 1000.0 ;
out -> mLOG . mX [ 62ULL ] = Engine_Engine_P * 1000.0 ; out -> mLOG . mX [
63ULL ] = Engine_Engine_P ; out -> mLOG . mX [ 64ULL ] = t23 -> mU . mX [
0ULL ] ; out -> mLOG . mX [ 65ULL ] = t23 -> mX . mX [ 1ULL ] ; out -> mLOG .
mX [ 66ULL ] = t23 -> mX . mX [ 1ULL ] ; out -> mLOG . mX [ 68ULL ] = t23 ->
mX . mX [ 15ULL ] ; out -> mLOG . mX [ 69ULL ] = t23 -> mX . mX [ 16ULL ] ;
out -> mLOG . mX [ 70ULL ] = - t23 -> mX . mX [ 19ULL ] ; out -> mLOG . mX [
72ULL ] = t23 -> mX . mX [ 19ULL ] ; out -> mLOG . mX [ 73ULL ] = t23 -> mX .
mX [ 1ULL ] ; out -> mLOG . mX [ 75ULL ] = t23 -> mX . mX [ 4ULL ] ; out ->
mLOG . mX [ 76ULL ] = t23 -> mX . mX [ 15ULL ] ; out -> mLOG . mX [ 77ULL ] =
t23 -> mX . mX [ 1ULL ] ; out -> mLOG . mX [ 78ULL ] = t23 -> mX . mX [ 5ULL
] ; out -> mLOG . mX [ 79ULL ] = t23 -> mX . mX [ 1ULL ] ; out -> mLOG . mX [
80ULL ] = t23 -> mX . mX [ 1ULL ] ; out -> mLOG . mX [ 81ULL ] = t23 -> mX .
mX [ 5ULL ] ; out -> mLOG . mX [ 82ULL ] = t23 -> mX . mX [ 1ULL ] *
9.549296585513721 ; out -> mLOG . mX [ 83ULL ] = t23 -> mX . mX [ 1ULL ] ;
out -> mLOG . mX [ 84ULL ] = t23 -> mU . mX [ 1ULL ] ; out -> mLOG . mX [
85ULL ] = t23 -> mX . mX [ 15ULL ] ; out -> mLOG . mX [ 86ULL ] = t23 -> mX .
mX [ 6ULL ] ; out -> mLOG . mX [ 87ULL ] = t23 -> mX . mX [ 6ULL ] ; out ->
mLOG . mX [ 89ULL ] = t23 -> mX . mX [ 15ULL ] ; out -> mLOG . mX [ 90ULL ] =
t23 -> mX . mX [ 17ULL ] ; out -> mLOG . mX [ 91ULL ] = - t23 -> mX . mX [
21ULL ] ; out -> mLOG . mX [ 93ULL ] = t23 -> mX . mX [ 21ULL ] ; out -> mLOG
. mX [ 94ULL ] = t23 -> mX . mX [ 6ULL ] ; out -> mLOG . mX [ 96ULL ] = t23
-> mX . mX [ 7ULL ] ; out -> mLOG . mX [ 97ULL ] = t23 -> mX . mX [ 15ULL ] ;
out -> mLOG . mX [ 98ULL ] = t23 -> mX . mX [ 6ULL ] ; out -> mLOG . mX [
99ULL ] = t23 -> mX . mX [ 8ULL ] ; out -> mLOG . mX [ 100ULL ] = t23 -> mX .
mX [ 6ULL ] ; out -> mLOG . mX [ 101ULL ] = t23 -> mX . mX [ 6ULL ] ; out ->
mLOG . mX [ 102ULL ] = t23 -> mX . mX [ 8ULL ] ; out -> mLOG . mX [ 103ULL ]
= t23 -> mX . mX [ 6ULL ] * 9.549296585513721 ; out -> mLOG . mX [ 104ULL ] =
t23 -> mX . mX [ 6ULL ] ; out -> mLOG . mX [ 105ULL ] = t23 -> mU . mX [ 2ULL
] ; out -> mLOG . mX [ 106ULL ] = t23 -> mX . mX [ 15ULL ] ; out -> mLOG . mX
[ 107ULL ] = t23 -> mX . mX [ 6ULL ] ; out -> mLOG . mX [ 108ULL ] = t23 ->
mX . mX [ 6ULL ] ; out -> mLOG . mX [ 109ULL ] = t23 -> mX . mX [ 9ULL ] ;
out -> mLOG . mX [ 110ULL ] = Vehicle_Body_Tire_Left_N ; out -> mLOG . mX [
111ULL ] = t23 -> mX . mX [ 23ULL ] ; out -> mLOG . mX [ 112ULL ] = t23 -> mX
. mX [ 6ULL ] ; out -> mLOG . mX [ 113ULL ] = t23 -> mX . mX [ 6ULL ] ; out
-> mLOG . mX [ 114ULL ] = t23 -> mX . mX [ 6ULL ] ; out -> mLOG . mX [ 116ULL
] = t23 -> mX . mX [ 9ULL ] ; out -> mLOG . mX [ 117ULL ] =
Vehicle_Body_Tire_Left_N ; out -> mLOG . mX [ 118ULL ] = t23 -> mX . mX [
23ULL ] ; out -> mLOG . mX [ 119ULL ] = t23 -> mX . mX [ 6ULL ] * 0.3 ; out
-> mLOG . mX [ 121ULL ] = t23 -> mX . mX [ 24ULL ] ; out -> mLOG . mX [
122ULL ] = t23 -> mX . mX [ 6ULL ] ; out -> mLOG . mX [ 123ULL ] = t23 -> mX
. mX [ 6ULL ] * 0.3 ; out -> mLOG . mX [ 124ULL ] = - t23 -> mX . mX [ 24ULL
] ; out -> mLOG . mX [ 125ULL ] = t23 -> mX . mX [ 24ULL ] * 0.3 ; out ->
mLOG . mX [ 126ULL ] = t23 -> mX . mX [ 6ULL ] ; out -> mLOG . mX [ 127ULL ]
= t23 -> mX . mX [ 9ULL ] ; out -> mLOG . mX [ 128ULL ] =
Vehicle_Body_Tire_Left_N ; out -> mLOG . mX [ 129ULL ] = t23 -> mX . mX [
28ULL ] ; out -> mLOG . mX [ 130ULL ] = t23 -> mX . mX [ 6ULL ] ; out -> mLOG
. mX [ 131ULL ] = t23 -> mX . mX [ 6ULL ] ; out -> mLOG . mX [ 132ULL ] = t23
-> mX . mX [ 10ULL ] ; out -> mLOG . mX [ 133ULL ] = t23 -> mX . mX [ 25ULL ]
; out -> mLOG . mX [ 134ULL ] = t23 -> mX . mX [ 9ULL ] ; out -> mLOG . mX [
135ULL ] = Vehicle_Body_Tire_Left_N ; out -> mLOG . mX [ 136ULL ] = t23 -> mX
. mX [ 28ULL ] ; out -> mLOG . mX [ 137ULL ] = t23 -> mX . mX [ 6ULL ] * 0.3
; out -> mLOG . mX [ 138ULL ] = t23 -> mX . mX [ 27ULL ] ; out -> mLOG . mX [
139ULL ] = t23 -> mX . mX [ 26ULL ] ; out -> mLOG . mX [ 140ULL ] = t23 -> mX
. mX [ 6ULL ] ; out -> mLOG . mX [ 141ULL ] = t23 -> mX . mX [ 6ULL ] * 0.3 ;
out -> mLOG . mX [ 142ULL ] = - t23 -> mX . mX [ 26ULL ] ; out -> mLOG . mX [
143ULL ] = t23 -> mX . mX [ 26ULL ] * 0.3 ; out -> mLOG . mX [ 144ULL ] = t23
-> mX . mX [ 9ULL ] ; out -> mLOG . mX [ 145ULL ] = t23 -> mX . mX [ 9ULL ] ;
out -> mLOG . mX [ 147ULL ] = Vehicle_Body_Tire_Left_N ; out -> mLOG . mX [
148ULL ] = t23 -> mX . mX [ 9ULL ] ; out -> mLOG . mX [ 150ULL ] = t23 -> mX
. mX [ 11ULL ] ; out -> mLOG . mX [ 151ULL ] = t23 -> mX . mX [ 22ULL ] ; out
-> mLOG . mX [ 152ULL ] = t23 -> mX . mX [ 9ULL ] * 3.6000000000000005 ; ( void
) LC ; ( void ) out ; return 0 ; }
