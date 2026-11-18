#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_slv.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_slv ( const NeDynamicSystem *
LC , const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { static
boolean_T _cg_const_1 [ 29 ] = { false , false , false , false , false ,
false , false , false , false , false , false , false , true , true , true ,
false , false , false , false , false , false , false , false , false , false
, true , false , false , false } ; ( void ) t1 ; ( void ) LC ; out -> mSLV .
mX [ 0 ] = _cg_const_1 [ 0 ] ; out -> mSLV . mX [ 1 ] = _cg_const_1 [ 1 ] ;
out -> mSLV . mX [ 2 ] = _cg_const_1 [ 2 ] ; out -> mSLV . mX [ 3 ] =
_cg_const_1 [ 3 ] ; out -> mSLV . mX [ 4 ] = _cg_const_1 [ 4 ] ; out -> mSLV
. mX [ 5 ] = _cg_const_1 [ 5 ] ; out -> mSLV . mX [ 6 ] = _cg_const_1 [ 6 ] ;
out -> mSLV . mX [ 7 ] = _cg_const_1 [ 7 ] ; out -> mSLV . mX [ 8 ] =
_cg_const_1 [ 8 ] ; out -> mSLV . mX [ 9 ] = _cg_const_1 [ 9 ] ; out -> mSLV
. mX [ 10 ] = _cg_const_1 [ 10 ] ; out -> mSLV . mX [ 11 ] = _cg_const_1 [ 11
] ; out -> mSLV . mX [ 12 ] = _cg_const_1 [ 12 ] ; out -> mSLV . mX [ 13 ] =
_cg_const_1 [ 13 ] ; out -> mSLV . mX [ 14 ] = _cg_const_1 [ 14 ] ; out ->
mSLV . mX [ 15 ] = _cg_const_1 [ 15 ] ; out -> mSLV . mX [ 16 ] = _cg_const_1
[ 16 ] ; out -> mSLV . mX [ 17 ] = _cg_const_1 [ 17 ] ; out -> mSLV . mX [ 18
] = _cg_const_1 [ 18 ] ; out -> mSLV . mX [ 19 ] = _cg_const_1 [ 19 ] ; out
-> mSLV . mX [ 20 ] = _cg_const_1 [ 20 ] ; out -> mSLV . mX [ 21 ] =
_cg_const_1 [ 21 ] ; out -> mSLV . mX [ 22 ] = _cg_const_1 [ 22 ] ; out ->
mSLV . mX [ 23 ] = _cg_const_1 [ 23 ] ; out -> mSLV . mX [ 24 ] = _cg_const_1
[ 24 ] ; out -> mSLV . mX [ 25 ] = _cg_const_1 [ 25 ] ; out -> mSLV . mX [ 26
] = _cg_const_1 [ 26 ] ; out -> mSLV . mX [ 27 ] = _cg_const_1 [ 27 ] ; out
-> mSLV . mX [ 28 ] = _cg_const_1 [ 28 ] ; ( void ) LC ; ( void ) out ;
return 0 ; }
