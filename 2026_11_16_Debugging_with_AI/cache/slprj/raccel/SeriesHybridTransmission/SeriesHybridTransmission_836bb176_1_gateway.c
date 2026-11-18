#ifdef MATLAB_MEX_FILE
#include "tmwtypes.h"
#else
#include "rtwtypes.h"
#endif
#include "nesl_rtw.h"
#include "SeriesHybridTransmission_836bb176_1.h"
#include "SeriesHybridTransmission_836bb176_1_gateway.h"
void SeriesHybridTransmission_836bb176_1_gateway ( void ) { NeModelParameters
modelparams = { ( enum NeSolverTypeTag ) 0 , 0.001 , 0.001 , TRUE , FALSE ,
0.001 , 0.0 , FALSE , FALSE , FALSE , ( enum SscLoggingSettingTag ) 0 ,
716845847.0 , FALSE , FALSE } ; NeSolverParameters solverparams = { TRUE ,
TRUE , TRUE , TRUE , FALSE , TRUE , TRUE , TRUE , FALSE , FALSE , FALSE ,
FALSE , TRUE , FALSE , FALSE , 0.001 , 1e-06 , 1e-09 , FALSE , FALSE , 100U ,
FALSE , 1U , ( enum NeConsistencySolverTag ) 2 , ( enum
NeCanonicalOrderingTag ) 0 , ( enum NeOptimizeIntermediatesTag ) 0 , ( enum
NeMulticoreSolverChoiceTag ) 0 , ( enum NeIndexReductionMethodTag ) 1 , FALSE
, 1e-09 , ( enum NeToleranceSourceTag ) 1 , 0.001 , 0.001 , 0.001 , FALSE , ( enum NeLocalSolverChoiceTag ) 0 , TRUE , 1U , 0.01 , FALSE , 3U , 2U , FALSE , 2U , ( enum NeLinearAlgebraChoiceTag ) 0 , 0U , ( enum NeEquationFormulationChoiceTag ) 0 , 1024U , TRUE , 0.001 , ( enum NePartitionStorageMethodTag ) 0 , 1024U , ( enum NePartitionMethodTag ) 1 , FALSE , ( enum NeMultibodyLocalSolverChoiceTag ) 0 , 0.001 } ; const NeOutputParameters * outputparameters = NULL ; NeDae * dae ; size_t numOutputs = 0 ; int rtpDaes [ 1 ] = { 0 } ; int * rtwLogDaes = NULL ; int * solverHitDaes = NULL ; { static const NeOutputParameters outputparameters_init [ ] = { { 0U , 0U } , } ; outputparameters = outputparameters_init ; numOutputs = sizeof ( outputparameters_init ) / sizeof ( outputparameters_init [ 0 ] ) ; } SeriesHybridTransmission_836bb176_1_dae ( & dae , & modelparams , & solverparams ) ; nesl_register_simulator_group ( "SeriesHybridTransmission/Solver Configuration_1" , 1 , & dae , & solverparams , & modelparams , numOutputs , outputparameters , 1 , rtpDaes , 0 , rtwLogDaes , 0 , solverHitDaes ) ; }
