#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_dxf_p.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_dxf_p ( const NeDynamicSystem
* LC , const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { static
int32_T _cg_const_1 [ 30 ] = { 0 , 0 , 3 , 4 , 4 , 5 , 5 , 9 , 10 , 10 , 13 ,
13 , 13 , 13 , 13 , 13 , 15 , 15 , 15 , 15 , 17 , 18 , 20 , 24 , 26 , 26 , 26
, 26 , 26 , 28 } ; static int32_T _cg_const_2 [ 28 ] = { 16 , 18 , 19 , 16 ,
19 , 20 , 21 , 22 , 26 , 21 , 10 , 22 , 26 , 18 , 20 , 18 , 19 , 17 , 20 , 21
, 23 , 24 , 27 , 28 , 23 , 24 , 27 , 28 } ; ( void ) t1 ; ( void ) LC ; out
-> mDXF_P . mNumCol = 29ULL ; out -> mDXF_P . mNumRow = 29ULL ; out -> mDXF_P
. mJc [ 0 ] = _cg_const_1 [ 0 ] ; out -> mDXF_P . mJc [ 1 ] = _cg_const_1 [ 1
] ; out -> mDXF_P . mJc [ 2 ] = _cg_const_1 [ 2 ] ; out -> mDXF_P . mJc [ 3 ]
= _cg_const_1 [ 3 ] ; out -> mDXF_P . mJc [ 4 ] = _cg_const_1 [ 4 ] ; out ->
mDXF_P . mJc [ 5 ] = _cg_const_1 [ 5 ] ; out -> mDXF_P . mJc [ 6 ] =
_cg_const_1 [ 6 ] ; out -> mDXF_P . mJc [ 7 ] = _cg_const_1 [ 7 ] ; out ->
mDXF_P . mJc [ 8 ] = _cg_const_1 [ 8 ] ; out -> mDXF_P . mJc [ 9 ] =
_cg_const_1 [ 9 ] ; out -> mDXF_P . mJc [ 10 ] = _cg_const_1 [ 10 ] ; out ->
mDXF_P . mJc [ 11 ] = _cg_const_1 [ 11 ] ; out -> mDXF_P . mJc [ 12 ] =
_cg_const_1 [ 12 ] ; out -> mDXF_P . mJc [ 13 ] = _cg_const_1 [ 13 ] ; out ->
mDXF_P . mJc [ 14 ] = _cg_const_1 [ 14 ] ; out -> mDXF_P . mJc [ 15 ] =
_cg_const_1 [ 15 ] ; out -> mDXF_P . mJc [ 16 ] = _cg_const_1 [ 16 ] ; out ->
mDXF_P . mJc [ 17 ] = _cg_const_1 [ 17 ] ; out -> mDXF_P . mJc [ 18 ] =
_cg_const_1 [ 18 ] ; out -> mDXF_P . mJc [ 19 ] = _cg_const_1 [ 19 ] ; out ->
mDXF_P . mJc [ 20 ] = _cg_const_1 [ 20 ] ; out -> mDXF_P . mJc [ 21 ] =
_cg_const_1 [ 21 ] ; out -> mDXF_P . mJc [ 22 ] = _cg_const_1 [ 22 ] ; out ->
mDXF_P . mJc [ 23 ] = _cg_const_1 [ 23 ] ; out -> mDXF_P . mJc [ 24 ] =
_cg_const_1 [ 24 ] ; out -> mDXF_P . mJc [ 25 ] = _cg_const_1 [ 25 ] ; out ->
mDXF_P . mJc [ 26 ] = _cg_const_1 [ 26 ] ; out -> mDXF_P . mJc [ 27 ] =
_cg_const_1 [ 27 ] ; out -> mDXF_P . mJc [ 28 ] = _cg_const_1 [ 28 ] ; out ->
mDXF_P . mJc [ 29 ] = _cg_const_1 [ 29 ] ; out -> mDXF_P . mIr [ 0 ] =
_cg_const_2 [ 0 ] ; out -> mDXF_P . mIr [ 1 ] = _cg_const_2 [ 1 ] ; out ->
mDXF_P . mIr [ 2 ] = _cg_const_2 [ 2 ] ; out -> mDXF_P . mIr [ 3 ] =
_cg_const_2 [ 3 ] ; out -> mDXF_P . mIr [ 4 ] = _cg_const_2 [ 4 ] ; out ->
mDXF_P . mIr [ 5 ] = _cg_const_2 [ 5 ] ; out -> mDXF_P . mIr [ 6 ] =
_cg_const_2 [ 6 ] ; out -> mDXF_P . mIr [ 7 ] = _cg_const_2 [ 7 ] ; out ->
mDXF_P . mIr [ 8 ] = _cg_const_2 [ 8 ] ; out -> mDXF_P . mIr [ 9 ] =
_cg_const_2 [ 9 ] ; out -> mDXF_P . mIr [ 10 ] = _cg_const_2 [ 10 ] ; out ->
mDXF_P . mIr [ 11 ] = _cg_const_2 [ 11 ] ; out -> mDXF_P . mIr [ 12 ] =
_cg_const_2 [ 12 ] ; out -> mDXF_P . mIr [ 13 ] = _cg_const_2 [ 13 ] ; out ->
mDXF_P . mIr [ 14 ] = _cg_const_2 [ 14 ] ; out -> mDXF_P . mIr [ 15 ] =
_cg_const_2 [ 15 ] ; out -> mDXF_P . mIr [ 16 ] = _cg_const_2 [ 16 ] ; out ->
mDXF_P . mIr [ 17 ] = _cg_const_2 [ 17 ] ; out -> mDXF_P . mIr [ 18 ] =
_cg_const_2 [ 18 ] ; out -> mDXF_P . mIr [ 19 ] = _cg_const_2 [ 19 ] ; out ->
mDXF_P . mIr [ 20 ] = _cg_const_2 [ 20 ] ; out -> mDXF_P . mIr [ 21 ] =
_cg_const_2 [ 21 ] ; out -> mDXF_P . mIr [ 22 ] = _cg_const_2 [ 22 ] ; out ->
mDXF_P . mIr [ 23 ] = _cg_const_2 [ 23 ] ; out -> mDXF_P . mIr [ 24 ] =
_cg_const_2 [ 24 ] ; out -> mDXF_P . mIr [ 25 ] = _cg_const_2 [ 25 ] ; out ->
mDXF_P . mIr [ 26 ] = _cg_const_2 [ 26 ] ; out -> mDXF_P . mIr [ 27 ] =
_cg_const_2 [ 27 ] ; ( void ) LC ; ( void ) out ; return 0 ; }
