#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_ic.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_ic ( const NeDynamicSystem *
LC , const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { ( void ) LC
; out -> mIC . mX [ 0ULL ] = 540000.0 ; out -> mIC . mX [ 1ULL ] =
209.43951023931953 ; out -> mIC . mX [ 2ULL ] = 0.0 ; out -> mIC . mX [ 3ULL
] = 0.0 ; out -> mIC . mX [ 4ULL ] = 0.0 ; out -> mIC . mX [ 5ULL ] = 0.0 ;
out -> mIC . mX [ 6ULL ] = 50.0 ; out -> mIC . mX [ 7ULL ] = 0.0 ; out -> mIC
. mX [ 8ULL ] = 0.0 ; out -> mIC . mX [ 9ULL ] = t1 -> mP_R . mX [ 11ULL ] ;
out -> mIC . mX [ 10ULL ] = 50.0 ; out -> mIC . mX [ 11ULL ] = 0.0 ; out ->
mIC . mX [ 12ULL ] = 0.0 ; out -> mIC . mX [ 13ULL ] = 0.0 ; out -> mIC . mX
[ 14ULL ] = 0.0 ; out -> mIC . mX [ 15ULL ] = 0.0 ; out -> mIC . mX [ 16ULL ]
= 0.0 ; out -> mIC . mX [ 17ULL ] = 0.0 ; out -> mIC . mX [ 18ULL ] = 0.0 ;
out -> mIC . mX [ 19ULL ] = 0.0 ; out -> mIC . mX [ 20ULL ] = 0.0 ; out ->
mIC . mX [ 21ULL ] = 0.0 ; out -> mIC . mX [ 22ULL ] = 0.0 ; out -> mIC . mX
[ 23ULL ] = 0.0 ; out -> mIC . mX [ 24ULL ] = 0.0 ; out -> mIC . mX [ 25ULL ]
= 0.0 ; out -> mIC . mX [ 26ULL ] = 0.0 ; out -> mIC . mX [ 27ULL ] = 0.0 ;
out -> mIC . mX [ 28ULL ] = 0.0 ; ( void ) LC ; ( void ) out ; return 0 ; }
