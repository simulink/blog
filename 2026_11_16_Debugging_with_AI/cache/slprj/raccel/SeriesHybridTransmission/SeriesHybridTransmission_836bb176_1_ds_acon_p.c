#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_acon_p.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_acon_p ( const NeDynamicSystem
* LC , const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { static
int32_T _cg_const_2 [ 33 ] = { 3 , 5 , 4 , 7 , 25 , 6 , 11 , 25 , 0 , 12 , 14
, 12 , 13 , 15 , 18 , 15 , 20 , 1 , 16 , 16 , 8 , 10 , 24 , 22 , 8 , 23 , 8 ,
9 , 8 , 27 , 24 , 28 , 26 } ; static int32_T _cg_const_1 [ 30 ] = { 0 , 0 , 2
, 2 , 2 , 3 , 3 , 5 , 6 , 6 , 7 , 8 , 8 , 9 , 11 , 13 , 13 , 15 , 17 , 19 ,
20 , 20 , 21 , 23 , 24 , 26 , 28 , 30 , 32 , 33 } ; ( void ) t1 ; ( void ) LC
; out -> mACON_P . mNumCol = 29ULL ; out -> mACON_P . mNumRow = 29ULL ; out
-> mACON_P . mJc [ 0 ] = _cg_const_1 [ 0 ] ; out -> mACON_P . mJc [ 1 ] =
_cg_const_1 [ 1 ] ; out -> mACON_P . mJc [ 2 ] = _cg_const_1 [ 2 ] ; out ->
mACON_P . mJc [ 3 ] = _cg_const_1 [ 3 ] ; out -> mACON_P . mJc [ 4 ] =
_cg_const_1 [ 4 ] ; out -> mACON_P . mJc [ 5 ] = _cg_const_1 [ 5 ] ; out ->
mACON_P . mJc [ 6 ] = _cg_const_1 [ 6 ] ; out -> mACON_P . mJc [ 7 ] =
_cg_const_1 [ 7 ] ; out -> mACON_P . mJc [ 8 ] = _cg_const_1 [ 8 ] ; out ->
mACON_P . mJc [ 9 ] = _cg_const_1 [ 9 ] ; out -> mACON_P . mJc [ 10 ] =
_cg_const_1 [ 10 ] ; out -> mACON_P . mJc [ 11 ] = _cg_const_1 [ 11 ] ; out
-> mACON_P . mJc [ 12 ] = _cg_const_1 [ 12 ] ; out -> mACON_P . mJc [ 13 ] =
_cg_const_1 [ 13 ] ; out -> mACON_P . mJc [ 14 ] = _cg_const_1 [ 14 ] ; out
-> mACON_P . mJc [ 15 ] = _cg_const_1 [ 15 ] ; out -> mACON_P . mJc [ 16 ] =
_cg_const_1 [ 16 ] ; out -> mACON_P . mJc [ 17 ] = _cg_const_1 [ 17 ] ; out
-> mACON_P . mJc [ 18 ] = _cg_const_1 [ 18 ] ; out -> mACON_P . mJc [ 19 ] =
_cg_const_1 [ 19 ] ; out -> mACON_P . mJc [ 20 ] = _cg_const_1 [ 20 ] ; out
-> mACON_P . mJc [ 21 ] = _cg_const_1 [ 21 ] ; out -> mACON_P . mJc [ 22 ] =
_cg_const_1 [ 22 ] ; out -> mACON_P . mJc [ 23 ] = _cg_const_1 [ 23 ] ; out
-> mACON_P . mJc [ 24 ] = _cg_const_1 [ 24 ] ; out -> mACON_P . mJc [ 25 ] =
_cg_const_1 [ 25 ] ; out -> mACON_P . mJc [ 26 ] = _cg_const_1 [ 26 ] ; out
-> mACON_P . mJc [ 27 ] = _cg_const_1 [ 27 ] ; out -> mACON_P . mJc [ 28 ] =
_cg_const_1 [ 28 ] ; out -> mACON_P . mJc [ 29 ] = _cg_const_1 [ 29 ] ; out
-> mACON_P . mIr [ 0 ] = _cg_const_2 [ 0 ] ; out -> mACON_P . mIr [ 1 ] =
_cg_const_2 [ 1 ] ; out -> mACON_P . mIr [ 2 ] = _cg_const_2 [ 2 ] ; out ->
mACON_P . mIr [ 3 ] = _cg_const_2 [ 3 ] ; out -> mACON_P . mIr [ 4 ] =
_cg_const_2 [ 4 ] ; out -> mACON_P . mIr [ 5 ] = _cg_const_2 [ 5 ] ; out ->
mACON_P . mIr [ 6 ] = _cg_const_2 [ 6 ] ; out -> mACON_P . mIr [ 7 ] =
_cg_const_2 [ 7 ] ; out -> mACON_P . mIr [ 8 ] = _cg_const_2 [ 8 ] ; out ->
mACON_P . mIr [ 9 ] = _cg_const_2 [ 9 ] ; out -> mACON_P . mIr [ 10 ] =
_cg_const_2 [ 10 ] ; out -> mACON_P . mIr [ 11 ] = _cg_const_2 [ 11 ] ; out
-> mACON_P . mIr [ 12 ] = _cg_const_2 [ 12 ] ; out -> mACON_P . mIr [ 13 ] =
_cg_const_2 [ 13 ] ; out -> mACON_P . mIr [ 14 ] = _cg_const_2 [ 14 ] ; out
-> mACON_P . mIr [ 15 ] = _cg_const_2 [ 15 ] ; out -> mACON_P . mIr [ 16 ] =
_cg_const_2 [ 16 ] ; out -> mACON_P . mIr [ 17 ] = _cg_const_2 [ 17 ] ; out
-> mACON_P . mIr [ 18 ] = _cg_const_2 [ 18 ] ; out -> mACON_P . mIr [ 19 ] =
_cg_const_2 [ 19 ] ; out -> mACON_P . mIr [ 20 ] = _cg_const_2 [ 20 ] ; out
-> mACON_P . mIr [ 21 ] = _cg_const_2 [ 21 ] ; out -> mACON_P . mIr [ 22 ] =
_cg_const_2 [ 22 ] ; out -> mACON_P . mIr [ 23 ] = _cg_const_2 [ 23 ] ; out
-> mACON_P . mIr [ 24 ] = _cg_const_2 [ 24 ] ; out -> mACON_P . mIr [ 25 ] =
_cg_const_2 [ 25 ] ; out -> mACON_P . mIr [ 26 ] = _cg_const_2 [ 26 ] ; out
-> mACON_P . mIr [ 27 ] = _cg_const_2 [ 27 ] ; out -> mACON_P . mIr [ 28 ] =
_cg_const_2 [ 28 ] ; out -> mACON_P . mIr [ 29 ] = _cg_const_2 [ 29 ] ; out
-> mACON_P . mIr [ 30 ] = _cg_const_2 [ 30 ] ; out -> mACON_P . mIr [ 31 ] =
_cg_const_2 [ 31 ] ; out -> mACON_P . mIr [ 32 ] = _cg_const_2 [ 32 ] ; ( void
) LC ; ( void ) out ; return 0 ; }
