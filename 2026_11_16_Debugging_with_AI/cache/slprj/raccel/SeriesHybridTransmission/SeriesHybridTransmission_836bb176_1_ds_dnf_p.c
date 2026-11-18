#include "ne_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_sys_struct.h"
#include "SeriesHybridTransmission_836bb176_1_ds_dnf_p.h"
#include "SeriesHybridTransmission_836bb176_1_ds.h"
#include "SeriesHybridTransmission_836bb176_1_ds_externals.h"
#include "SeriesHybridTransmission_836bb176_1_ds_external_struct.h"
#include "ssc_ml_fun.h"
int32_T SeriesHybridTransmission_836bb176_1_ds_dnf_p ( const NeDynamicSystem
* LC , const NeDynamicSystemInput * t1 , NeDsMethodOutput * out ) { static
int32_T _cg_const_1 [ 42 ] = { 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ,
0 , 0 , 0 , 0 , 0 , 0 , 0 , 2 , 4 , 6 , 6 } ; static int32_T _cg_const_2 [ 6
] = { 22 , 26 , 23 , 24 , 27 , 28 } ; ( void ) t1 ; ( void ) LC ; out ->
mDNF_P . mNumCol = 41ULL ; out -> mDNF_P . mNumRow = 29ULL ; out -> mDNF_P .
mJc [ 0 ] = _cg_const_1 [ 0 ] ; out -> mDNF_P . mJc [ 1 ] = _cg_const_1 [ 1 ]
; out -> mDNF_P . mJc [ 2 ] = _cg_const_1 [ 2 ] ; out -> mDNF_P . mJc [ 3 ] =
_cg_const_1 [ 3 ] ; out -> mDNF_P . mJc [ 4 ] = _cg_const_1 [ 4 ] ; out ->
mDNF_P . mJc [ 5 ] = _cg_const_1 [ 5 ] ; out -> mDNF_P . mJc [ 6 ] =
_cg_const_1 [ 6 ] ; out -> mDNF_P . mJc [ 7 ] = _cg_const_1 [ 7 ] ; out ->
mDNF_P . mJc [ 8 ] = _cg_const_1 [ 8 ] ; out -> mDNF_P . mJc [ 9 ] =
_cg_const_1 [ 9 ] ; out -> mDNF_P . mJc [ 10 ] = _cg_const_1 [ 10 ] ; out ->
mDNF_P . mJc [ 11 ] = _cg_const_1 [ 11 ] ; out -> mDNF_P . mJc [ 12 ] =
_cg_const_1 [ 12 ] ; out -> mDNF_P . mJc [ 13 ] = _cg_const_1 [ 13 ] ; out ->
mDNF_P . mJc [ 14 ] = _cg_const_1 [ 14 ] ; out -> mDNF_P . mJc [ 15 ] =
_cg_const_1 [ 15 ] ; out -> mDNF_P . mJc [ 16 ] = _cg_const_1 [ 16 ] ; out ->
mDNF_P . mJc [ 17 ] = _cg_const_1 [ 17 ] ; out -> mDNF_P . mJc [ 18 ] =
_cg_const_1 [ 18 ] ; out -> mDNF_P . mJc [ 19 ] = _cg_const_1 [ 19 ] ; out ->
mDNF_P . mJc [ 20 ] = _cg_const_1 [ 20 ] ; out -> mDNF_P . mJc [ 21 ] =
_cg_const_1 [ 21 ] ; out -> mDNF_P . mJc [ 22 ] = _cg_const_1 [ 22 ] ; out ->
mDNF_P . mJc [ 23 ] = _cg_const_1 [ 23 ] ; out -> mDNF_P . mJc [ 24 ] =
_cg_const_1 [ 24 ] ; out -> mDNF_P . mJc [ 25 ] = _cg_const_1 [ 25 ] ; out ->
mDNF_P . mJc [ 26 ] = _cg_const_1 [ 26 ] ; out -> mDNF_P . mJc [ 27 ] =
_cg_const_1 [ 27 ] ; out -> mDNF_P . mJc [ 28 ] = _cg_const_1 [ 28 ] ; out ->
mDNF_P . mJc [ 29 ] = _cg_const_1 [ 29 ] ; out -> mDNF_P . mJc [ 30 ] =
_cg_const_1 [ 30 ] ; out -> mDNF_P . mJc [ 31 ] = _cg_const_1 [ 31 ] ; out ->
mDNF_P . mJc [ 32 ] = _cg_const_1 [ 32 ] ; out -> mDNF_P . mJc [ 33 ] =
_cg_const_1 [ 33 ] ; out -> mDNF_P . mJc [ 34 ] = _cg_const_1 [ 34 ] ; out ->
mDNF_P . mJc [ 35 ] = _cg_const_1 [ 35 ] ; out -> mDNF_P . mJc [ 36 ] =
_cg_const_1 [ 36 ] ; out -> mDNF_P . mJc [ 37 ] = _cg_const_1 [ 37 ] ; out ->
mDNF_P . mJc [ 38 ] = _cg_const_1 [ 38 ] ; out -> mDNF_P . mJc [ 39 ] =
_cg_const_1 [ 39 ] ; out -> mDNF_P . mJc [ 40 ] = _cg_const_1 [ 40 ] ; out ->
mDNF_P . mJc [ 41 ] = _cg_const_1 [ 41 ] ; out -> mDNF_P . mIr [ 0 ] =
_cg_const_2 [ 0 ] ; out -> mDNF_P . mIr [ 1 ] = _cg_const_2 [ 1 ] ; out ->
mDNF_P . mIr [ 2 ] = _cg_const_2 [ 2 ] ; out -> mDNF_P . mIr [ 3 ] =
_cg_const_2 [ 3 ] ; out -> mDNF_P . mIr [ 4 ] = _cg_const_2 [ 4 ] ; out ->
mDNF_P . mIr [ 5 ] = _cg_const_2 [ 5 ] ; ( void ) LC ; ( void ) out ; return
0 ; }
