#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_passert.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_passert ( const
NeDynamicSystem * LC , const NeDynamicSystemInput * t2 , NeDsMethodOutput *
out ) { ( void ) LC ; out -> mPASSERT . mX [ 0ULL ] = ( int32_T ) ( t2 ->
mDP_R . mX [ 1ULL ] >= 0.0 ) ; out -> mPASSERT . mX [ 1ULL ] = ( int32_T ) ( t2
-> mDP_R . mX [ 2ULL ] > 0.0 ) ; out -> mPASSERT . mX [ 2ULL ] = ( int32_T )
( t2 -> mDP_R . mX [ 3ULL ] > 0.0 ) ; out -> mPASSERT . mX [ 3ULL ] = ( int32_T
) ( t2 -> mDP_R . mX [ 4ULL ] > 0.0 ) ; out -> mPASSERT . mX [ 4ULL ] = ( int32_T ) ( t2 -> mDP_R . mX [ 3ULL ] > 0.0 ) ; out -> mPASSERT . mX [ 5ULL ] = ( int32_T ) ( t2 -> mDP_R . mX [ 7ULL ] > 0.0 ) ; out -> mPASSERT . mX [ 6ULL ] = ( int32_T ) ( t2 -> mDP_R . mX [ 5ULL ] > 0.0 ) ; out -> mPASSERT . mX [ 7ULL ] = ( int32_T ) ( t2 -> mDP_R . mX [ 5ULL ] <= 100.0 ) ; out -> mPASSERT . mX [ 8ULL ] = ( int32_T ) ( t2 -> mDP_R . mX [ 8ULL ] > 0.0 ) ; out -> mPASSERT . mX [ 9ULL ] = ( int32_T ) ( t2 -> mDP_R . mX [ 8ULL ] <= 100.0 ) ; out -> mPASSERT . mX [ 10ULL ] = ( int32_T ) ( t2 -> mDP_R . mX [ 11ULL ] > 0.0 ) ; out -> mPASSERT . mX [ 11ULL ] = ( int32_T ) ( t2 -> mDP_R . mX [ 12ULL ] >= 0.0 ) ; out -> mPASSERT . mX [ 12ULL ] = ( int32_T ) ( t2 -> mDP_R . mX [ 10ULL ] >= 0.0 ) ; out -> mPASSERT . mX [ 13ULL ] = ( int32_T ) ( t2 -> mDP_R . mX [ 5ULL ] * 300.0 / 100.0 != 0.0 ) ; out -> mPASSERT . mX [ 14ULL ] = ( int32_T ) ( t2 -> mDP_R . mX [ 8ULL ] * 300.0 / 100.0 != 0.0 ) ; out -> mPASSERT . mX [ 15ULL ] = ( int32_T ) ( t2 -> mDP_R . mX [ 4ULL ] != 0.0 ) ; ( void ) LC ; ( void ) out ; return 0 ; }
