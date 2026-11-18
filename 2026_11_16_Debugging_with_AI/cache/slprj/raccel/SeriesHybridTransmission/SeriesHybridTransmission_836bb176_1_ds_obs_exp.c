#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_obs_exp.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_obs_exp ( const
NeDynamicSystem * LC , const NeDynamicSystemInput * t12 , NeDsMethodOutput *
out ) { static real_T _cg_const_1 [ 4 ] = { 10.0 , 2.0 , 1.0 , 1.0 } ; real_T
t1 [ 4 ] ; size_t t6 ; ( void ) LC ; t1 [ 0 ] = _cg_const_1 [ 0 ] ; t1 [ 1 ]
= _cg_const_1 [ 1 ] ; t1 [ 2 ] = _cg_const_1 [ 2 ] ; t1 [ 3 ] = _cg_const_1 [
3 ] ; out -> mOBS_EXP . mX [ 0ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 1ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 2ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 3ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 4ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 5ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 6ULL ] = 150.0 ; out -> mOBS_EXP . mX [ 7ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 8ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 9ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 10ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 11ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 12ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 13ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 14ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 15ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 16ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 17ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 18ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 19ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 20ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 21ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 22ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 23ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 24ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 25ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 26ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 27ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 28ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 29ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 30ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 31ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 32ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 33ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 34ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 35ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 36ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 37ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 38ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 39ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 40ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 41ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 42ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 43ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 44ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 45ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 46ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 47ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 48ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 49ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 50ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 51ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 52ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 53ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 54ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 55ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 56ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 57ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 58ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 59ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 60ULL ] = 2000.0 ; out -> mOBS_EXP . mX [ 61ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 62ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 63ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 64ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 65ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 66ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 67ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 68ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 69ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 70ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 71ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 72ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 73ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 74ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 75ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 76ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 77ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 78ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 79ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 80ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 81ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 82ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 83ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 84ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 85ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 86ULL ] = 293.15 ; out -> mOBS_EXP . mX [
87ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 88ULL ] = 0.0 ; out -> mOBS_EXP . mX [
89ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 90ULL ] = 0.0 ; out -> mOBS_EXP . mX [
91ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 92ULL ] = 300.0 ; out -> mOBS_EXP . mX
[ 93ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 94ULL ] = 0.0 ; out -> mOBS_EXP . mX
[ 95ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 96ULL ] = 0.0 ; out -> mOBS_EXP . mX
[ 97ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 98ULL ] = 0.0 ; out -> mOBS_EXP . mX
[ 99ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 100ULL ] = 0.0 ; out -> mOBS_EXP .
mX [ 101ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 102ULL ] = 0.0 ; out -> mOBS_EXP
. mX [ 103ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 104ULL ] = 0.0 ; out ->
mOBS_EXP . mX [ 105ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 106ULL ] = 0.0 ; out
-> mOBS_EXP . mX [ 107ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 108ULL ] = 0.0 ;
out -> mOBS_EXP . mX [ 109ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 110ULL ] = 0.0
; out -> mOBS_EXP . mX [ 111ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 112ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 113ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 114ULL ]
= 293.15 ; out -> mOBS_EXP . mX [ 115ULL ] = 0.0 ; out -> mOBS_EXP . mX [
116ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 117ULL ] = 0.0 ; out -> mOBS_EXP . mX
[ 118ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 119ULL ] = 0.0 ; out -> mOBS_EXP .
mX [ 120ULL ] = 300.0 ; out -> mOBS_EXP . mX [ 121ULL ] = 0.0 ; out ->
mOBS_EXP . mX [ 122ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 123ULL ] = 0.0 ; out
-> mOBS_EXP . mX [ 124ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 125ULL ] = 0.0 ;
out -> mOBS_EXP . mX [ 126ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 127ULL ] = 0.0
; out -> mOBS_EXP . mX [ 128ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 129ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 130ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 131ULL ]
= 0.0 ; out -> mOBS_EXP . mX [ 132ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 133ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 134ULL ] = 0.0 ; out -> mOBS_EXP . mX [
135ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 136ULL ] = 0.0 ; out -> mOBS_EXP . mX
[ 137ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 138ULL ] = 0.0 ; out -> mOBS_EXP .
mX [ 139ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 140ULL ] = 0.0 ; out -> mOBS_EXP
. mX [ 141ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 142ULL ] = 0.0 ; for ( t6 =
0ULL ; t6 < 4ULL ; t6 ++ ) { out -> mOBS_EXP . mX [ t6 + 143ULL ] = t1 [ t6 ]
; } out -> mOBS_EXP . mX [ 147ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 148ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 149ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 150ULL ]
= 0.0 ; out -> mOBS_EXP . mX [ 151ULL ] = 50.0 ; out -> mOBS_EXP . mX [
152ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 153ULL ] = 0.0 ; out -> mOBS_EXP . mX
[ 154ULL ] = 0.0 ; for ( t6 = 0ULL ; t6 < 4ULL ; t6 ++ ) { out -> mOBS_EXP .
mX [ t6 + 155ULL ] = t1 [ t6 ] ; } out -> mOBS_EXP . mX [ 159ULL ] = 0.0 ;
out -> mOBS_EXP . mX [ 160ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 161ULL ] = 0.0
; out -> mOBS_EXP . mX [ 162ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 163ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 164ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 165ULL ]
= 0.0 ; out -> mOBS_EXP . mX [ 166ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 167ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 168ULL ] = 0.0 ; out -> mOBS_EXP . mX [
169ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 170ULL ] = 0.0 ; for ( t6 = 0ULL ; t6
< 4ULL ; t6 ++ ) { out -> mOBS_EXP . mX [ t6 + 171ULL ] = t1 [ t6 ] ; } out
-> mOBS_EXP . mX [ 175ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 176ULL ] = 0.0 ;
out -> mOBS_EXP . mX [ 177ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 178ULL ] = 0.0
; out -> mOBS_EXP . mX [ 179ULL ] = 50.0 ; out -> mOBS_EXP . mX [ 180ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 181ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 182ULL ]
= 0.0 ; for ( t6 = 0ULL ; t6 < 4ULL ; t6 ++ ) { out -> mOBS_EXP . mX [ t6 +
183ULL ] = t1 [ t6 ] ; } out -> mOBS_EXP . mX [ 187ULL ] = 0.0 ; out ->
mOBS_EXP . mX [ 188ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 189ULL ] = 0.0 ; out
-> mOBS_EXP . mX [ 190ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 191ULL ] = 0.0 ;
out -> mOBS_EXP . mX [ 192ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 193ULL ] = 0.0
; out -> mOBS_EXP . mX [ 194ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 195ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 196ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 197ULL ]
= 0.0 ; out -> mOBS_EXP . mX [ 198ULL ] = t12 -> mP_R . mX [ 11ULL ] ; out ->
mOBS_EXP . mX [ 199ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 200ULL ] = 0.0 ; out
-> mOBS_EXP . mX [ 201ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 202ULL ] = 0.0 ;
out -> mOBS_EXP . mX [ 203ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 204ULL ] = 0.0
; out -> mOBS_EXP . mX [ 205ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 206ULL ] =
0.0 ; out -> mOBS_EXP . mX [ 207ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 208ULL ]
= 0.0 ; out -> mOBS_EXP . mX [ 209ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 210ULL
] = 0.0 ; out -> mOBS_EXP . mX [ 211ULL ] = 0.0 ; out -> mOBS_EXP . mX [
212ULL ] = 0.0 ; out -> mOBS_EXP . mX [ 213ULL ] = 0.0 ; out -> mOBS_EXP . mX
[ 214ULL ] = 0.0 ; ( void ) LC ; ( void ) out ; return 0 ; }
