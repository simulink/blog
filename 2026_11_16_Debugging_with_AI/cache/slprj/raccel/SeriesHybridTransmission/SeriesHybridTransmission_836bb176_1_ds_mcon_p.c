#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_mcon_p.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_mcon_p ( const NeDynamicSystem
* LC , const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { static
int32_T _cg_const_1 [ 30 ] = { 0 , 1 , 1 , 2 , 3 , 3 , 4 , 5 , 6 , 7 , 8 , 9
, 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 , 10 ,
10 , 10 , 10 } ; static int32_T _cg_const_2 [ 10 ] = { 0 , 2 , 3 , 5 , 8 , 6
, 7 , 10 , 9 , 11 } ; ( void ) t1 ; ( void ) LC ; out -> mMCON_P . mNumCol =
29ULL ; out -> mMCON_P . mNumRow = 29ULL ; out -> mMCON_P . mJc [ 0 ] =
_cg_const_1 [ 0 ] ; out -> mMCON_P . mJc [ 1 ] = _cg_const_1 [ 1 ] ; out ->
mMCON_P . mJc [ 2 ] = _cg_const_1 [ 2 ] ; out -> mMCON_P . mJc [ 3 ] =
_cg_const_1 [ 3 ] ; out -> mMCON_P . mJc [ 4 ] = _cg_const_1 [ 4 ] ; out ->
mMCON_P . mJc [ 5 ] = _cg_const_1 [ 5 ] ; out -> mMCON_P . mJc [ 6 ] =
_cg_const_1 [ 6 ] ; out -> mMCON_P . mJc [ 7 ] = _cg_const_1 [ 7 ] ; out ->
mMCON_P . mJc [ 8 ] = _cg_const_1 [ 8 ] ; out -> mMCON_P . mJc [ 9 ] =
_cg_const_1 [ 9 ] ; out -> mMCON_P . mJc [ 10 ] = _cg_const_1 [ 10 ] ; out ->
mMCON_P . mJc [ 11 ] = _cg_const_1 [ 11 ] ; out -> mMCON_P . mJc [ 12 ] =
_cg_const_1 [ 12 ] ; out -> mMCON_P . mJc [ 13 ] = _cg_const_1 [ 13 ] ; out
-> mMCON_P . mJc [ 14 ] = _cg_const_1 [ 14 ] ; out -> mMCON_P . mJc [ 15 ] =
_cg_const_1 [ 15 ] ; out -> mMCON_P . mJc [ 16 ] = _cg_const_1 [ 16 ] ; out
-> mMCON_P . mJc [ 17 ] = _cg_const_1 [ 17 ] ; out -> mMCON_P . mJc [ 18 ] =
_cg_const_1 [ 18 ] ; out -> mMCON_P . mJc [ 19 ] = _cg_const_1 [ 19 ] ; out
-> mMCON_P . mJc [ 20 ] = _cg_const_1 [ 20 ] ; out -> mMCON_P . mJc [ 21 ] =
_cg_const_1 [ 21 ] ; out -> mMCON_P . mJc [ 22 ] = _cg_const_1 [ 22 ] ; out
-> mMCON_P . mJc [ 23 ] = _cg_const_1 [ 23 ] ; out -> mMCON_P . mJc [ 24 ] =
_cg_const_1 [ 24 ] ; out -> mMCON_P . mJc [ 25 ] = _cg_const_1 [ 25 ] ; out
-> mMCON_P . mJc [ 26 ] = _cg_const_1 [ 26 ] ; out -> mMCON_P . mJc [ 27 ] =
_cg_const_1 [ 27 ] ; out -> mMCON_P . mJc [ 28 ] = _cg_const_1 [ 28 ] ; out
-> mMCON_P . mJc [ 29 ] = _cg_const_1 [ 29 ] ; out -> mMCON_P . mIr [ 0 ] =
_cg_const_2 [ 0 ] ; out -> mMCON_P . mIr [ 1 ] = _cg_const_2 [ 1 ] ; out ->
mMCON_P . mIr [ 2 ] = _cg_const_2 [ 2 ] ; out -> mMCON_P . mIr [ 3 ] =
_cg_const_2 [ 3 ] ; out -> mMCON_P . mIr [ 4 ] = _cg_const_2 [ 4 ] ; out ->
mMCON_P . mIr [ 5 ] = _cg_const_2 [ 5 ] ; out -> mMCON_P . mIr [ 6 ] =
_cg_const_2 [ 6 ] ; out -> mMCON_P . mIr [ 7 ] = _cg_const_2 [ 7 ] ; out ->
mMCON_P . mIr [ 8 ] = _cg_const_2 [ 8 ] ; out -> mMCON_P . mIr [ 9 ] =
_cg_const_2 [ 9 ] ; ( void ) LC ; ( void ) out ; return 0 ; }
