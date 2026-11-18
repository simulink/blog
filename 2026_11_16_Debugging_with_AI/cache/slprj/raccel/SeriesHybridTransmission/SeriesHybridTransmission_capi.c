#include "rtw_capi.h"
#ifdef HOST_CAPI_BUILD
#include "SeriesHybridTransmission_capi_host.h"
#define sizeof(...) ((size_t)(0xFFFF))
#undef rt_offsetof
#define rt_offsetof(s,el) ((uint16_T)(0xFFFF))
#define TARGET_CONST
#define TARGET_STRING(s) (s)
#ifndef SS_UINT64
#define SS_UINT64 17
#endif
#ifndef SS_INT64
#define SS_INT64 18
#endif
#else
#include "builtin_typeid_types.h"
#include "SeriesHybridTransmission.h"
#include "SeriesHybridTransmission_capi.h"
#include "SeriesHybridTransmission_private.h"
#ifdef LIGHT_WEIGHT_CAPI
#define TARGET_CONST
#define TARGET_STRING(s)               ((NULL))
#else
#define TARGET_CONST                   const
#define TARGET_STRING(s)               (s)
#endif
#endif
static const rtwCAPI_Signals rtBlockSignals [ ] = { { 0 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Solver Configuration/RTP_1" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0 } , { 1 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Speed Command/Acceleration level (m//s^2)" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0 } , { 2 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Speed Command/mps2kmh" ) , TARGET_STRING ( "Command" ) , 0 , 0 , 0 , 0 , 1 } , { 3 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Speed Command/Integrator" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 4 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Strategy/Convert to wheel RPM" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 5 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Strategy/Steady-state correction factor as proportional-only control" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 2 } , { 6 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Engine/Engine Management/Kp" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 7 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Engine/Engine Management/[0,1]" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 8 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Engine/Engine Management/Sum2" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 9 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Engine/RPM Sensor/Sensor dynamics" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 10 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/Ki" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 11 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/Kp" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 12 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/Limits [-40,40]" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 13 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/[-40,40]" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 14 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/Sum" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 15 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/Sum1" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 16 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/20Hz Lowpass Filter" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 1 } , { 17 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Solver Configuration/EVAL_KEY/INPUT_1_1_1" ) , TARGET_STRING ( "" ) , 0 , 0 , 1 , 0 , 1 } , { 18 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Solver Configuration/EVAL_KEY/INPUT_2_1_1" ) , TARGET_STRING ( "" ) , 0 , 0 , 1 , 0 , 1 } , { 19 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Solver Configuration/EVAL_KEY/INPUT_3_1_1" ) , TARGET_STRING ( "" ) , 0 , 0 , 1 , 0 , 1 } , { 20 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Solver Configuration/EVAL_KEY/OUTPUT_1_0" ) , TARGET_STRING ( "" ) , 0 , 0 , 2 , 0 , 1 } , { 21 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Solver Configuration/EVAL_KEY/STATE_1" ) , TARGET_STRING ( "" ) , 0 , 0 , 3 , 0 , 1 } , { 0 , 0 , ( NULL ) , ( NULL ) , 0 , 0 , 0 , 0 , 0 } } ; static const rtwCAPI_BlockParameters rtBlockParameters [ ] = { { 22 , TARGET_STRING ( "SeriesHybridTransmission/Speed Command/mps2kmh" ) , TARGET_STRING ( "Gain" ) , 0 , 0 , 0 } , { 23 , TARGET_STRING ( "SeriesHybridTransmission/Speed Command/Accelerate at t=2s" ) , TARGET_STRING ( "InitialValue" ) , 0 , 0 , 0 } , { 24 , TARGET_STRING ( "SeriesHybridTransmission/Speed Command/Accelerate at t=2s" ) , TARGET_STRING ( "FinalValue" ) , 0 , 0 , 0 } , { 25 , TARGET_STRING ( "SeriesHybridTransmission/Speed Command/Decelerate at t=12s" ) , TARGET_STRING ( "InitialValue" ) , 0 , 0 , 0 } , { 26 , TARGET_STRING ( "SeriesHybridTransmission/Speed Command/Decelerate at t=12s" ) , TARGET_STRING ( "FinalValue" ) , 0 , 0 , 0 } , { 27 , TARGET_STRING ( "SeriesHybridTransmission/Speed Command/Stop acceleration at t=7s" ) , TARGET_STRING ( "InitialValue" ) , 0 , 0 , 0 } , { 28 , TARGET_STRING ( "SeriesHybridTransmission/Speed Command/Stop acceleration at t=7s" ) , TARGET_STRING ( "FinalValue" ) , 0 , 0 , 0 } , { 29 , TARGET_STRING ( "SeriesHybridTransmission/Speed Command/Stop decelerationat t=17s" ) , TARGET_STRING ( "InitialValue" ) , 0 , 0 , 0 } , { 30 , TARGET_STRING ( "SeriesHybridTransmission/Speed Command/Stop decelerationat t=17s" ) , TARGET_STRING ( "FinalValue" ) , 0 , 0 , 0 } , { 31 , TARGET_STRING ( "SeriesHybridTransmission/Engine/Engine Management/Kp" ) , TARGET_STRING ( "Gain" ) , 0 , 0 , 0 } , { 32 , TARGET_STRING ( "SeriesHybridTransmission/Engine/Engine Management/[0,1]" ) , TARGET_STRING ( "UpperLimit" ) , 0 , 0 , 0 } , { 33 , TARGET_STRING ( "SeriesHybridTransmission/Engine/Engine Management/[0,1]" ) , TARGET_STRING ( "LowerLimit" ) , 0 , 0 , 0 } , { 34 , TARGET_STRING ( "SeriesHybridTransmission/Engine/RPM Sensor/Sensor dynamics" ) , TARGET_STRING ( "A" ) , 0 , 0 , 0 } , { 35 , TARGET_STRING ( "SeriesHybridTransmission/Engine/RPM Sensor/Sensor dynamics" ) , TARGET_STRING ( "C" ) , 0 , 0 , 0 } , { 36 , TARGET_STRING ( "SeriesHybridTransmission/Engine/Sensor Fuel/Integrator" ) , TARGET_STRING ( "InitialCondition" ) , 0 , 0 , 0 } , { 37 , TARGET_STRING ( "SeriesHybridTransmission/Engine/Simulink-PS Converter/input1" ) , TARGET_STRING ( "Value" ) , 0 , 0 , 0 } , { 38 , TARGET_STRING ( "SeriesHybridTransmission/Engine/Simulink-PS Converter/input2" ) , TARGET_STRING ( "Value" ) , 0 , 0 , 0 } , { 39 , TARGET_STRING ( "SeriesHybridTransmission/Generator/Simulink-PS Converter/input1" ) , TARGET_STRING ( "Value" ) , 0 , 0 , 0 } , { 40 , TARGET_STRING ( "SeriesHybridTransmission/Generator/Simulink-PS Converter/input2" ) , TARGET_STRING ( "Value" ) , 0 , 0 , 0 } , { 41 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Simulink-PS Converter/input1" ) , TARGET_STRING ( "Value" ) , 0 , 0 , 0 } , { 42 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Simulink-PS Converter/input2" ) , TARGET_STRING ( "Value" ) , 0 , 0 , 0 } , { 43 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/Limits [-40,40]" ) , TARGET_STRING ( "InitialCondition" ) , 0 , 0 , 0 } , { 44 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/Limits [-40,40]" ) , TARGET_STRING ( "UpperSaturationLimit" ) , 0 , 0 , 0 } , { 45 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/Limits [-40,40]" ) , TARGET_STRING ( "LowerSaturationLimit" ) , 0 , 0 , 0 } , { 46 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/[-40,40]" ) , TARGET_STRING ( "UpperLimit" ) , 0 , 0 , 0 } , { 47 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/[-40,40]" ) , TARGET_STRING ( "LowerLimit" ) , 0 , 0 , 0 } , { 48 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/20Hz Lowpass Filter" ) , TARGET_STRING ( "A" ) , 0 , 0 , 0 } , { 49 , TARGET_STRING ( "SeriesHybridTransmission/Motor/Speed Controller/20Hz Lowpass Filter" ) , TARGET_STRING ( "C" ) , 0 , 0 , 0 } , { 0 , ( NULL ) , ( NULL ) , 0 , 0 , 0 } } ; static int_T rt_LoggedStateIdxList [ ] = { - 1 } ; static const rtwCAPI_Signals rtRootInputs [ ] = { { 0 , 0 , ( NULL ) , ( NULL ) , 0 , 0 , 0 , 0 , 0 } } ; static const rtwCAPI_Signals rtRootOutputs [ ] = { { 50 , 0 , TARGET_STRING ( "SeriesHybridTransmission/Out1" ) , TARGET_STRING ( "" ) , 1 , 0 , 0 , 0 , 1 } , { 0 , 0 , ( NULL ) , ( NULL ) , 0 , 0 , 0 , 0 , 0 } } ; static const rtwCAPI_ModelParameters rtModelParameters [ ] = { { 51 , TARGET_STRING ( "_AccelEndTime2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 52 , TARGET_STRING ( "_AccelStartTime2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 53 , TARGET_STRING ( "_AirDensity2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 54 , TARGET_STRING ( "_BatteryResistance2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 55 , TARGET_STRING ( "_BatteryVoltage2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 56 , TARGET_STRING ( "_CommandAcceleration2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 57 , TARGET_STRING ( "_DCBusVoltage2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 58 , TARGET_STRING ( "_DecelEndTime2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 59 , TARGET_STRING ( "_DecelStartTime2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 60 , TARGET_STRING ( "_EngineInertia2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 61 , TARGET_STRING ( "_EngineSpeedCorrection2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 62 , TARGET_STRING ( "_EngineTimeConstant2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 63 , TARGET_STRING ( "_GeneratorEfficiency2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 64 , TARGET_STRING ( "_GeneratorTimeConstant2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 65 , TARGET_STRING ( "_GeneratorTorqueDemand2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 66 , TARGET_STRING ( "_MotorEfficiency2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 67 , TARGET_STRING ( "_MotorSpeedKi2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 68 , TARGET_STRING ( "_MotorSpeedKp2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 69 , TARGET_STRING ( "_VehicleDragCoeff2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 70 , TARGET_STRING ( "_VehicleFrontalArea2f2SeriesHybridTransmission_sldd_" ) , 0 , 0 , 0 } , { 71 , TARGET_STRING ( "rpm0" ) , 0 , 0 , 0 } , { 72 , TARGET_STRING ( "v0" ) , 0 , 0 , 0 } , { 73 , TARGET_STRING ( "wheel_radius" ) , 0 , 0 , 0 } , { 0 , ( NULL ) , 0 , 0 , 0 } } ;
#ifndef HOST_CAPI_BUILD
static void * rtDataAddrMap [ ] = { & rtB . acaukxyv3c , & rtB . cjjifhibam ,
& rtB . piw1thaima , & rtB . gdeuysczfp , & rtB . otmbqg5yzs , & rtB .
a4mgjuzchb , & rtB . iqjkejjtxl , & rtB . kjwq4q4qoi , & rtB . gzopggd2h3 , &
rtB . mxlggdymth , & rtB . krgzwqxxc4 , & rtB . nzeddfqxfa , & rtB .
lobuefx021 , & rtB . ovdfvbuehq , & rtB . j5d423dshv , & rtB . hi04d2uald , &
rtB . puaiyfntok , & rtB . bbtjf3mpaa [ 0 ] , & rtB . eig3b4noss [ 0 ] , &
rtB . nnmpux3se1 [ 0 ] , & rtB . p51py0zwam [ 0 ] , & rtB . k03xt2b02o [ 0 ]
, & rtP . mps2kmh_Gain , & rtP . Accelerateatt2s_Y0 , & rtP .
Accelerateatt2s_YFinal , & rtP . Decelerateatt12s_Y0 , & rtP .
Decelerateatt12s_YFinal , & rtP . Stopaccelerationatt7s_Y0 , & rtP .
Stopaccelerationatt7s_YFinal , & rtP . Stopdecelerationatt17s_Y0 , & rtP .
Stopdecelerationatt17s_YFinal , & rtP . Kp_Gain , & rtP . u1_UpperSat , & rtP
. u1_LowerSat , & rtP . Sensordynamics_A , & rtP . Sensordynamics_C , & rtP .
Integrator_IC , & rtP . input1_Value , & rtP . input2_Value , & rtP .
input1_Value_imdncjs2s2 , & rtP . input2_Value_ca3sfw5rnz , & rtP .
input1_Value_ggh4buor1f , & rtP . input2_Value_ajtyxd4ixo , & rtP .
Limits4040_IC , & rtP . Limits4040_UpperSat , & rtP . Limits4040_LowerSat , &
rtP . u040_UpperSat , & rtP . u040_LowerSat , & rtP . u0HzLowpassFilter_A , &
rtP . u0HzLowpassFilter_C , & rtY . nsumcoek0x , & rtP .
_AccelEndTime2f2SeriesHybridTransmission_sldd_ , & rtP .
_AccelStartTime2f2SeriesHybridTransmission_sldd_ , & rtP .
_AirDensity2f2SeriesHybridTransmission_sldd_ , & rtP .
_BatteryResistance2f2SeriesHybridTransmission_sldd_ , & rtP .
_BatteryVoltage2f2SeriesHybridTransmission_sldd_ , & rtP .
_CommandAcceleration2f2SeriesHybridTransmission_sldd_ , & rtP .
_DCBusVoltage2f2SeriesHybridTransmission_sldd_ , & rtP .
_DecelEndTime2f2SeriesHybridTransmission_sldd_ , & rtP .
_DecelStartTime2f2SeriesHybridTransmission_sldd_ , & rtP .
_EngineInertia2f2SeriesHybridTransmission_sldd_ , & rtP .
_EngineSpeedCorrection2f2SeriesHybridTransmission_sldd_ , & rtP .
_EngineTimeConstant2f2SeriesHybridTransmission_sldd_ , & rtP .
_GeneratorEfficiency2f2SeriesHybridTransmission_sldd_ , & rtP .
_GeneratorTimeConstant2f2SeriesHybridTransmission_sldd_ , & rtP .
_GeneratorTorqueDemand2f2SeriesHybridTransmission_sldd_ , & rtP .
_MotorEfficiency2f2SeriesHybridTransmission_sldd_ , & rtP .
_MotorSpeedKi2f2SeriesHybridTransmission_sldd_ , & rtP .
_MotorSpeedKp2f2SeriesHybridTransmission_sldd_ , & rtP .
_VehicleDragCoeff2f2SeriesHybridTransmission_sldd_ , & rtP .
_VehicleFrontalArea2f2SeriesHybridTransmission_sldd_ , & rtP . rpm0 , & rtP .
v0 , & rtP . wheel_radius , } ; static int32_T * rtVarDimsAddrMap [ ] = { ( NULL
) } ;
#endif
static TARGET_CONST rtwCAPI_DataTypeMap rtDataTypeMap [ ] = { { "double" ,
"real_T" , 0 , 0 , sizeof ( real_T ) , ( uint8_T ) SS_DOUBLE , 0 , 0 , 0 } }
;
#ifdef HOST_CAPI_BUILD
#undef sizeof
#endif
static TARGET_CONST rtwCAPI_ElementMap rtElementMap [ ] = { { ( NULL ) , 0 ,
0 , 0 , 0 } , } ; static const rtwCAPI_DimensionMap rtDimensionMap [ ] = { {
rtwCAPI_SCALAR , 0 , 2 , 0 } , { rtwCAPI_VECTOR , 2 , 2 , 0 } , {
rtwCAPI_VECTOR , 4 , 2 , 0 } , { rtwCAPI_VECTOR , 6 , 2 , 0 } } ; static
const uint_T rtDimensionArray [ ] = { 1 , 1 , 4 , 1 , 9 , 1 , 41 , 1 } ;
static const real_T rtcapiStoredFloats [ ] = { 0.0 , 1.0 } ; static const
rtwCAPI_FixPtMap rtFixPtMap [ ] = { { ( NULL ) , ( NULL ) ,
rtwCAPI_FIX_RESERVED , 0 , 0 , ( boolean_T ) 0 } , } ; static const
rtwCAPI_SampleTimeMap rtSampleTimeMap [ ] = { { ( const void * ) &
rtcapiStoredFloats [ 0 ] , ( const void * ) & rtcapiStoredFloats [ 1 ] , ( int8_T ) 1 , ( uint8_T ) 0 } , { ( const void * ) & rtcapiStoredFloats [ 0 ] , ( const void * ) & rtcapiStoredFloats [ 0 ] , ( int8_T ) 0 , ( uint8_T ) 0 } , { ( NULL ) , ( NULL ) , 2 , 0 } } ; static rtwCAPI_ModelMappingStaticInfo mmiStatic = { { rtBlockSignals , 22 , rtRootInputs , 0 , rtRootOutputs , 1 } , { rtBlockParameters , 28 , rtModelParameters , 23 } , { ( NULL ) , 0 } , { rtDataTypeMap , rtDimensionMap , rtFixPtMap , rtElementMap , rtSampleTimeMap , rtDimensionArray } , "float" , { 3898635034U , 2663004245U , 1389757015U , 1923455693U } , ( NULL ) , 0 , ( boolean_T ) 0 , rt_LoggedStateIdxList } ; const rtwCAPI_ModelMappingStaticInfo * SeriesHybridTransmission_GetCAPIStaticMap ( void ) { return & mmiStatic ; }
#ifndef HOST_CAPI_BUILD
void SeriesHybridTransmission_InitializeDataMapInfo ( void ) {
rtwCAPI_SetVersion ( ( * rt_dataMapInfoPtr ) . mmi , 1 ) ;
rtwCAPI_SetStaticMap ( ( * rt_dataMapInfoPtr ) . mmi , & mmiStatic ) ;
rtwCAPI_SetLoggingStaticMap ( ( * rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ;
rtwCAPI_SetDataAddressMap ( ( * rt_dataMapInfoPtr ) . mmi , rtDataAddrMap ) ;
rtwCAPI_SetVarDimsAddressMap ( ( * rt_dataMapInfoPtr ) . mmi ,
rtVarDimsAddrMap ) ; rtwCAPI_SetInstanceLoggingInfo ( ( * rt_dataMapInfoPtr )
. mmi , ( NULL ) ) ; rtwCAPI_SetChildMMIArray ( ( * rt_dataMapInfoPtr ) . mmi
, ( NULL ) ) ; rtwCAPI_SetChildMMIArrayLen ( ( * rt_dataMapInfoPtr ) . mmi ,
0 ) ; }
#else
#ifdef __cplusplus
extern "C" {
#endif
void SeriesHybridTransmission_host_InitializeDataMapInfo ( SeriesHybridTransmission_host_DataMapInfo_T * dataMap , const char * path ) { rtwCAPI_SetVersion ( dataMap -> mmi , 1 ) ; rtwCAPI_SetStaticMap ( dataMap -> mmi , & mmiStatic ) ; rtwCAPI_SetDataAddressMap ( dataMap -> mmi , ( NULL ) ) ; rtwCAPI_SetVarDimsAddressMap ( dataMap -> mmi , ( NULL ) ) ; rtwCAPI_SetPath ( dataMap -> mmi , path ) ; rtwCAPI_SetFullPath ( dataMap -> mmi , ( NULL ) ) ; rtwCAPI_SetChildMMIArray ( dataMap -> mmi , ( NULL ) ) ; rtwCAPI_SetChildMMIArrayLen ( dataMap -> mmi , 0 ) ; }
#ifdef __cplusplus
}
#endif
#endif
