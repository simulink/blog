#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_obs_il.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_obs_il ( const NeDynamicSystem
* LC , const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { static
boolean_T _cg_const_1 [ 215 ] = { true , true , true , true , true , true ,
true , true , true , true , true , false , true , true , false , false ,
false , false , false , true , true , true , true , true , true , true , true
, true , true , true , true , true , true , true , true , true , true , true
, true , true , true , true , true , true , true , true , true , true , true
, true , true , true , true , false , false , false , true , true , true ,
true , true , true , true , true , true , true , true , true , true , true ,
true , true , true , true , true , true , true , true , false , false , false
, false , false , true , true , true , true , true , true , false , true ,
true , true , true , true , true , true , true , true , true , true , true ,
true , true , true , true , true , true , true , false , true , true , true ,
true , true , true , true , false , true , true , true , true , true , true ,
true , true , true , true , true , true , true , true , true , true , true ,
true , true , false , true , true , true , true , true , true , true , true ,
true , true , true , true , true , true , true , true , true , true , true ,
true , true , true , true , true , true , true , true , true , true , true ,
true , true , true , true , true , true , true , true , true , true , true ,
true , true , true , true , true , true , true , true , true , true , true ,
true , true , true , true , true , true , true , true , true , true , true ,
true , true , true , true , true , true , true , true , true , true , true ,
true , true , true } ; int32_T i ; ( void ) t1 ; ( void ) LC ; for ( i = 0 ;
i < 215 ; i ++ ) { out -> mOBS_IL . mX [ i ] = _cg_const_1 [ i ] ; } ( void )
LC ; ( void ) out ; return 0 ; }
