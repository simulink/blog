#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_dp_r.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_dp_r ( const NeDynamicSystem *
LC , const NeDynamicSystemInput * t3 , NeDsMethodOutput * out ) { real_T
parameter_update1 ; ( void ) LC ; out -> mDP_R . mX [ 3ULL ] = t3 -> mP_R .
mX [ 3ULL ] ; out -> mDP_R . mX [ 10ULL ] = t3 -> mP_R . mX [ 8ULL ] ; out ->
mDP_R . mX [ 0ULL ] = t3 -> mP_R . mX [ 0ULL ] ; out -> mDP_R . mX [ 1ULL ] =
t3 -> mP_R . mX [ 1ULL ] ; out -> mDP_R . mX [ 2ULL ] = t3 -> mP_R . mX [
2ULL ] ; out -> mDP_R . mX [ 4ULL ] = t3 -> mP_R . mX [ 4ULL ] ; out -> mDP_R
. mX [ 5ULL ] = t3 -> mP_R . mX [ 5ULL ] ; parameter_update1 = t3 -> mP_R .
mX [ 5ULL ] * 300.0 / 100.0 ; out -> mDP_R . mX [ 6ULL ] = ( 1.0 - t3 -> mP_R
. mX [ 5ULL ] / 100.0 ) * 600.0 / ( parameter_update1 == 0.0 ? 1.0E-16 :
parameter_update1 ) ; out -> mDP_R . mX [ 7ULL ] = t3 -> mP_R . mX [ 6ULL ] ;
out -> mDP_R . mX [ 8ULL ] = t3 -> mP_R . mX [ 7ULL ] ; parameter_update1 =
t3 -> mP_R . mX [ 7ULL ] * 300.0 / 100.0 ; out -> mDP_R . mX [ 9ULL ] = ( 1.0
- t3 -> mP_R . mX [ 7ULL ] / 100.0 ) * 600.0 / ( parameter_update1 == 0.0 ?
1.0E-16 : parameter_update1 ) ; out -> mDP_R . mX [ 11ULL ] = t3 -> mP_R . mX
[ 9ULL ] ; out -> mDP_R . mX [ 12ULL ] = t3 -> mP_R . mX [ 10ULL ] ; ( void )
LC ; ( void ) out ; return 0 ; }
