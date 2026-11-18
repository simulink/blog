#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_vpf.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_vpf ( const NeDynamicSystem *
LC , const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { static
boolean_T _cg_const_1 [ 29 ] = { false , false , false , false , false ,
false , false , false , false , false , false , false , true , true , true ,
true , false , false , false , false , false , false , false , false , false
, false , false , false , false } ; ( void ) t1 ; ( void ) LC ; out -> mVPF .
mX [ 0 ] = _cg_const_1 [ 0 ] ; out -> mVPF . mX [ 1 ] = _cg_const_1 [ 1 ] ;
out -> mVPF . mX [ 2 ] = _cg_const_1 [ 2 ] ; out -> mVPF . mX [ 3 ] =
_cg_const_1 [ 3 ] ; out -> mVPF . mX [ 4 ] = _cg_const_1 [ 4 ] ; out -> mVPF
. mX [ 5 ] = _cg_const_1 [ 5 ] ; out -> mVPF . mX [ 6 ] = _cg_const_1 [ 6 ] ;
out -> mVPF . mX [ 7 ] = _cg_const_1 [ 7 ] ; out -> mVPF . mX [ 8 ] =
_cg_const_1 [ 8 ] ; out -> mVPF . mX [ 9 ] = _cg_const_1 [ 9 ] ; out -> mVPF
. mX [ 10 ] = _cg_const_1 [ 10 ] ; out -> mVPF . mX [ 11 ] = _cg_const_1 [ 11
] ; out -> mVPF . mX [ 12 ] = _cg_const_1 [ 12 ] ; out -> mVPF . mX [ 13 ] =
_cg_const_1 [ 13 ] ; out -> mVPF . mX [ 14 ] = _cg_const_1 [ 14 ] ; out ->
mVPF . mX [ 15 ] = _cg_const_1 [ 15 ] ; out -> mVPF . mX [ 16 ] = _cg_const_1
[ 16 ] ; out -> mVPF . mX [ 17 ] = _cg_const_1 [ 17 ] ; out -> mVPF . mX [ 18
] = _cg_const_1 [ 18 ] ; out -> mVPF . mX [ 19 ] = _cg_const_1 [ 19 ] ; out
-> mVPF . mX [ 20 ] = _cg_const_1 [ 20 ] ; out -> mVPF . mX [ 21 ] =
_cg_const_1 [ 21 ] ; out -> mVPF . mX [ 22 ] = _cg_const_1 [ 22 ] ; out ->
mVPF . mX [ 23 ] = _cg_const_1 [ 23 ] ; out -> mVPF . mX [ 24 ] = _cg_const_1
[ 24 ] ; out -> mVPF . mX [ 25 ] = _cg_const_1 [ 25 ] ; out -> mVPF . mX [ 26
] = _cg_const_1 [ 26 ] ; out -> mVPF . mX [ 27 ] = _cg_const_1 [ 27 ] ; out
-> mVPF . mX [ 28 ] = _cg_const_1 [ 28 ] ; ( void ) LC ; ( void ) out ;
return 0 ; }
