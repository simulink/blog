#ifndef SeriesHybridTransmission_h_
#define SeriesHybridTransmission_h_
#ifndef SeriesHybridTransmission_COMMON_INCLUDES_
#define SeriesHybridTransmission_COMMON_INCLUDES_
#include <stdlib.h>
#include "sl_AsyncioQueue/AsyncioQueueCAPI.h"
#include "rtwtypes.h"
#include "sigstream_rtw.h"
#include "simtarget/slSimTgtSigstreamRTW.h"
#include "simtarget/slSimTgtSlioCoreRTW.h"
#include "simtarget/slSimTgtSlioClientsRTW.h"
#include "simtarget/slSimTgtSlioSdiRTW.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "raccel.h"
#include "slsv_diagnostic_codegen_c_api.h"
#include "rt_logging_simtarget.h"
#include "rt_nonfinite.h"
#include "math.h"
#include "dt_info.h"
#include "ext_work.h"
#include "nesl_rtw_rtp.h"
#include "SeriesHybridTransmission_836bb176_1_gateway.h"
#include "nesl_rtw.h"
#include "ne_std.h"
#endif
#include "SeriesHybridTransmission_types.h"
#include <string.h>
#include "rt_zcfcnRefine.h"
#include "rtGetInf.h"
#include <stddef.h>
#include "rtw_modelmap.h"
#include "rtw_modelmap_simtarget.h"
#include "rt_defines.h"
#include "zero_crossing_types.h"
#define MODEL_NAME SeriesHybridTransmission
#define NSAMPLE_TIMES (3) 
#define NINPUTS (0)       
#define NOUTPUTS (1)     
#define NBLOCKIO (22) 
#define NUM_ZC_EVENTS (17) 
#ifndef NCSTATES
#define NCSTATES (34)   
#elif NCSTATES != 34
#error Invalid specification of NCSTATES defined in compiler command
#endif
#ifndef rtmGetDataMapInfo
#define rtmGetDataMapInfo(rtm) (*rt_dataMapInfoPtr)
#endif
#ifndef rtmSetDataMapInfo
#define rtmSetDataMapInfo(rtm, val) (rt_dataMapInfoPtr = &val)
#endif
#ifndef IN_RACCEL_MAIN
#endif
typedef struct { real_T mxlggdymth ; real_T gzopggd2h3 ; real_T iqjkejjtxl ;
real_T kjwq4q4qoi ; real_T bbtjf3mpaa [ 4 ] ; real_T eig3b4noss [ 4 ] ;
real_T lobuefx021 ; real_T puaiyfntok ; real_T gdeuysczfp ; real_T otmbqg5yzs
; real_T j5d423dshv ; real_T nzeddfqxfa ; real_T hi04d2uald ; real_T
ovdfvbuehq ; real_T nnmpux3se1 [ 4 ] ; real_T acaukxyv3c ; real_T k03xt2b02o
[ 41 ] ; real_T p51py0zwam [ 9 ] ; real_T piw1thaima ; real_T cjjifhibam ;
real_T krgzwqxxc4 ; real_T a4mgjuzchb ; } B ; typedef struct { real_T
cm3yz21kmm [ 2 ] ; real_T dwnluyjp1y [ 2 ] ; real_T pozeu2skuu [ 2 ] ; real_T
kvhulgmkxg ; real_T o5kdmldxnm ; real_T ibyrtx3wmn [ 17 ] ; real_T lxh24ns0v3
; real_T ospl1vg2ao ; real_T cumjyqtmkz ; void * mtl20p1pjf ; void *
mshwrvwjum ; void * ba3wa4xoch ; void * hxigt3wu31 ; void * dbcetkdxe1 ; void
* e0dwsim2ab ; void * fi3cjqy0ly ; void * lbsrijp0kk ; void * pn4sfv0kpt ;
void * ejajmfuu22 ; void * ddbfa243ff ; void * jzzidweox5 ; struct { void *
AQHandles ; } bodlhifxqj ; struct { void * AQHandles ; } gvjdpirtlp ; int32_T
kkbctdleld ; int32_T bcn1p3foly ; int_T nao4oexhpo [ 12 ] ; int_T bvrw4irq2r
; int_T primpwmo4v ; int_T imzgdjkn5o ; int_T plrydhxfue ; int_T dsyjjimhxm ;
int_T orssjfag1p ; int_T esquov3qle ; int_T eh3gfeebmo ; int_T fjnrrpwbdk ;
int_T gpzjgivblu ; int32_T mifdyfljhg ; uint8_T aysmj1fmqf [ 17 ] ; uint8_T
dq3atvr5dh [ 17 ] ; uint8_T ixys421w5u ; uint8_T bssz4jfejo ; boolean_T
g2bcftdtlq ; boolean_T ob5s2qr30m ; boolean_T iwmksvg23x ; } DW ; typedef
struct { real_T lm5dadbpxg ; real_T jw5o5u1l5p ; real_T b5cxsvrp0c ; real_T
n0chqwit1m ; real_T fig3xizb2v [ 29 ] ; real_T pomewa0uqg ; } X ; typedef
struct { real_T lm5dadbpxg ; real_T jw5o5u1l5p ; real_T b5cxsvrp0c ; real_T
n0chqwit1m ; real_T fig3xizb2v [ 29 ] ; real_T pomewa0uqg ; } XDot ; typedef
struct { boolean_T lm5dadbpxg ; boolean_T jw5o5u1l5p ; boolean_T b5cxsvrp0c ;
boolean_T n0chqwit1m ; boolean_T fig3xizb2v [ 29 ] ; boolean_T pomewa0uqg ; }
XDis ; typedef struct { real_T lm5dadbpxg ; real_T jw5o5u1l5p ; real_T
b5cxsvrp0c ; real_T n0chqwit1m ; real_T fig3xizb2v [ 29 ] ; real_T pomewa0uqg
; } CStateAbsTol ; typedef struct { real_T lm5dadbpxg ; real_T jw5o5u1l5p ;
real_T b5cxsvrp0c ; real_T n0chqwit1m ; real_T fig3xizb2v [ 29 ] ; real_T
pomewa0uqg ; } CXPtMin ; typedef struct { real_T lm5dadbpxg ; real_T
jw5o5u1l5p ; real_T b5cxsvrp0c ; real_T n0chqwit1m ; real_T fig3xizb2v [ 29 ]
; real_T pomewa0uqg ; } CXPtMax ; typedef struct { real_T dxsvnaimba ; real_T
kblrjtmre0 ; real_T dd5nlxn50y ; real_T la4jgwrr44 ; real_T pgv02qvlnq ;
real_T effbs3mh3k ; real_T nxpl44pzvx ; real_T jx4ao4beq0 ; real_T jdrs0vbd5h
; real_T mcknisogvb ; real_T dgayyy0mui ; real_T hu4y25nk5q ; real_T
fuxthd5c5z ; real_T mzwf5engok ; real_T d2ejnbmb2d ; real_T e21b31o2ml ;
real_T htzu1qvvwm ; real_T cpi2ecei1z ; real_T ntf4ahtveg ; real_T jbrq0mo4yb
; real_T plm00nljit ; real_T owkaanxnev ; real_T j0uaxeyps1 ; real_T
fntfuu3abb ; real_T lgae1vqgky ; real_T kfynvdk5b5 ; real_T jhhazx21u3 ;
real_T ak0k3kjdzv ; } ZCV ; typedef struct { ZCSigState ohd3fdgnb0 ;
ZCSigState jvnsskwbbz ; ZCSigState hslchf3rmh ; ZCSigState giyk3a1ugt ;
ZCSigState io0dib0mfe ; ZCSigState nietd2gwti ; ZCSigState dbgh4wup2p ;
ZCSigState cexlejupmd ; ZCSigState k3c4ntbwb2 ; ZCSigState ngjmcy1qtw ;
ZCSigState mn5kozzvxd ; ZCSigState famuu0xeyz ; ZCSigState ffemg2s3n4 ;
ZCSigState jajmzesahc ; ZCSigState kwndkq1mpq ; ZCSigState opt0uqsqc5 ;
ZCSigState iosikwzt21 ; } PrevZCX ; typedef struct { int_T ir [ 19 ] ; int_T
jc [ 35 ] ; real_T pr [ 19 ] ; } MassMatrix ; typedef struct { real_T
nsumcoek0x ; } ExtY ; typedef struct { rtwCAPI_ModelMappingInfo mmi ; }
DataMapInfo ; struct P_ { real_T
_AccelEndTime2f2SeriesHybridTransmission_sldd_ ; real_T
_AccelStartTime2f2SeriesHybridTransmission_sldd_ ; real_T
_AirDensity2f2SeriesHybridTransmission_sldd_ ; real_T
_BatteryResistance2f2SeriesHybridTransmission_sldd_ ; real_T
_BatteryVoltage2f2SeriesHybridTransmission_sldd_ ; real_T
_CommandAcceleration2f2SeriesHybridTransmission_sldd_ ; real_T
_DCBusVoltage2f2SeriesHybridTransmission_sldd_ ; real_T
_DecelEndTime2f2SeriesHybridTransmission_sldd_ ; real_T
_DecelStartTime2f2SeriesHybridTransmission_sldd_ ; real_T
_EngineInertia2f2SeriesHybridTransmission_sldd_ ; real_T
_EngineSpeedCorrection2f2SeriesHybridTransmission_sldd_ ; real_T
_EngineTimeConstant2f2SeriesHybridTransmission_sldd_ ; real_T
_GeneratorEfficiency2f2SeriesHybridTransmission_sldd_ ; real_T
_GeneratorTimeConstant2f2SeriesHybridTransmission_sldd_ ; real_T
_GeneratorTorqueDemand2f2SeriesHybridTransmission_sldd_ ; real_T
_MotorEfficiency2f2SeriesHybridTransmission_sldd_ ; real_T
_MotorSpeedKi2f2SeriesHybridTransmission_sldd_ ; real_T
_MotorSpeedKp2f2SeriesHybridTransmission_sldd_ ; real_T
_VehicleDragCoeff2f2SeriesHybridTransmission_sldd_ ; real_T
_VehicleFrontalArea2f2SeriesHybridTransmission_sldd_ ; real_T rpm0 ; real_T
v0 ; real_T wheel_radius ; real_T Sensordynamics_A ; real_T Sensordynamics_C
; real_T Kp_Gain ; real_T u1_UpperSat ; real_T u1_LowerSat ; real_T
Limits4040_IC ; real_T Limits4040_UpperSat ; real_T Limits4040_LowerSat ;
real_T u0HzLowpassFilter_A ; real_T u0HzLowpassFilter_C ; real_T
u040_UpperSat ; real_T u040_LowerSat ; real_T mps2kmh_Gain ; real_T
Accelerateatt2s_Y0 ; real_T Accelerateatt2s_YFinal ; real_T
Stopaccelerationatt7s_Y0 ; real_T Stopaccelerationatt7s_YFinal ; real_T
Decelerateatt12s_Y0 ; real_T Decelerateatt12s_YFinal ; real_T
Stopdecelerationatt17s_Y0 ; real_T Stopdecelerationatt17s_YFinal ; real_T
Integrator_IC ; real_T input1_Value ; real_T input2_Value ; real_T
input1_Value_imdncjs2s2 ; real_T input2_Value_ca3sfw5rnz ; real_T
input1_Value_ggh4buor1f ; real_T input2_Value_ajtyxd4ixo ; } ; extern const
char_T * RT_MEMORY_ALLOCATION_ERROR ; extern B rtB ; extern X rtX ; extern DW
rtDW ; extern PrevZCX rtPrevZCX ; extern ExtY rtY ; extern MassMatrix
rtMassMatrix ; extern P rtP ; extern mxArray *
mr_SeriesHybridTransmission_GetDWork ( ) ; extern void
mr_SeriesHybridTransmission_SetDWork ( const mxArray * ssDW ) ; extern
mxArray * mr_SeriesHybridTransmission_GetSimStateDisallowedBlocks ( ) ;
extern const rtwCAPI_ModelMappingStaticInfo *
SeriesHybridTransmission_GetCAPIStaticMap ( void ) ; void
raccel_InitializeSubmodelGlobalParams ( void ) ; void
raccel_ParamWriterUpdateSubmodelGlobalParams ( void ) ; void
raccel_RuntimeUpdateSubmodelGlobalParams ( void ) ; extern SimStruct * rtS ;
extern DataMapInfo * rt_dataMapInfoPtr ; extern rtwCAPI_ModelMappingInfo *
rt_modelMapInfoPtr ; void MdlOutputs ( int_T tid ) ; void
MdlOutputsParameterSampleTime ( SimStruct * const , int_T ) ; void MdlUpdate
( int_T tid ) ; void MdlTerminate ( SimStruct * const ) ; void
MdlInitializeSizes ( SimStruct * const ) ; void MdlInitializeSampleTimes ( SimStruct * const ) ; void raccel_register_model ( SimStruct * , ssExecutionInfo * ) ;
#endif
