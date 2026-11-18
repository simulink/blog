#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_vdf.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_vdf ( const NeDynamicSystem *
LC , const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { static
boolean_T _cg_const_1 [ 29 ] = { false , false , false , false , false ,
false , false , false , false , false , true , false , false , false , false
, false , true , true , true , true , true , true , true , true , true ,
false , true , true , true } ; ( void ) t1 ; ( void ) LC ; out -> mVDF . mX [
0 ] = _cg_const_1 [ 0 ] ; out -> mVDF . mX [ 1 ] = _cg_const_1 [ 1 ] ; out ->
mVDF . mX [ 2 ] = _cg_const_1 [ 2 ] ; out -> mVDF . mX [ 3 ] = _cg_const_1 [
3 ] ; out -> mVDF . mX [ 4 ] = _cg_const_1 [ 4 ] ; out -> mVDF . mX [ 5 ] =
_cg_const_1 [ 5 ] ; out -> mVDF . mX [ 6 ] = _cg_const_1 [ 6 ] ; out -> mVDF
. mX [ 7 ] = _cg_const_1 [ 7 ] ; out -> mVDF . mX [ 8 ] = _cg_const_1 [ 8 ] ;
out -> mVDF . mX [ 9 ] = _cg_const_1 [ 9 ] ; out -> mVDF . mX [ 10 ] =
_cg_const_1 [ 10 ] ; out -> mVDF . mX [ 11 ] = _cg_const_1 [ 11 ] ; out ->
mVDF . mX [ 12 ] = _cg_const_1 [ 12 ] ; out -> mVDF . mX [ 13 ] = _cg_const_1
[ 13 ] ; out -> mVDF . mX [ 14 ] = _cg_const_1 [ 14 ] ; out -> mVDF . mX [ 15
] = _cg_const_1 [ 15 ] ; out -> mVDF . mX [ 16 ] = _cg_const_1 [ 16 ] ; out
-> mVDF . mX [ 17 ] = _cg_const_1 [ 17 ] ; out -> mVDF . mX [ 18 ] =
_cg_const_1 [ 18 ] ; out -> mVDF . mX [ 19 ] = _cg_const_1 [ 19 ] ; out ->
mVDF . mX [ 20 ] = _cg_const_1 [ 20 ] ; out -> mVDF . mX [ 21 ] = _cg_const_1
[ 21 ] ; out -> mVDF . mX [ 22 ] = _cg_const_1 [ 22 ] ; out -> mVDF . mX [ 23
] = _cg_const_1 [ 23 ] ; out -> mVDF . mX [ 24 ] = _cg_const_1 [ 24 ] ; out
-> mVDF . mX [ 25 ] = _cg_const_1 [ 25 ] ; out -> mVDF . mX [ 26 ] =
_cg_const_1 [ 26 ] ; out -> mVDF . mX [ 27 ] = _cg_const_1 [ 27 ] ; out ->
mVDF . mX [ 28 ] = _cg_const_1 [ 28 ] ; ( void ) LC ; ( void ) out ; return 0
; }
