#include "SeriesHybridTransmission_capi_host.h"
static SeriesHybridTransmission_host_DataMapInfo_T root;
static int initialized = 0;
__declspec( dllexport ) rtwCAPI_ModelMappingInfo *getRootMappingInfo()
{
    if (initialized == 0) {
        initialized = 1;
        SeriesHybridTransmission_host_InitializeDataMapInfo(&(root), "SeriesHybridTransmission");
    }
    return &root.mmi;
}

rtwCAPI_ModelMappingInfo *mexFunction(){return(getRootMappingInfo());}
