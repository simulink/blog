###########################################################################
## Makefile generated for component 'SeriesHybridTransmission'. 
## 
## Makefile     : SeriesHybridTransmission.mk
## Generated on : Mon Nov 16 15:37:24 2026
## Final product: .\SeriesHybridTransmission.dll
## Product type : shared library
## 
###########################################################################

###########################################################################
## MACROS
###########################################################################

# Macro Descriptions:
# PRODUCT_NAME            Name of the system to build
# MAKEFILE                Name of this makefile
# COMPILER_COMMAND_FILE   Compiler command listing model reference header paths
# CMD_FILE                Command file
# DEF_FILE                Definition file

PRODUCT_NAME              = SeriesHybridTransmission
MAKEFILE                  = SeriesHybridTransmission.mk
MATLAB_ROOT               = L:\MATLAB\R2026b
MATLAB_BIN                = L:\MATLAB\R2026b\bin
MATLAB_ARCH_BIN           = $(MATLAB_BIN)\win64
START_DIR                 = L:\Projects\Blog\repo13\2026_11_16_Debugging_with_AI\cache
SOLVER                    = 
SOLVER_OBJ                = 
CLASSIC_INTERFACE         = 1
TGT_FCN_LIB               = ISO_C
MODEL_HAS_DYNAMICALLY_LOADED_SFCNS = 0
RELATIVE_PATH_TO_ANCHOR   = ..\..\..
COMPILER_COMMAND_FILE     = SeriesHybridTransmission_comp.rsp
CMD_FILE                  = SeriesHybridTransmission.rsp
DEF_FILE                  = $(PRODUCT_NAME).def
C_STANDARD_OPTS           = 
CPP_STANDARD_OPTS         = 
NODEBUG                   = 1
LIBSSC_SLI_VCX64_OBJS     = 
LIBSSC_CORE_VCX64_OBJS    = 
LIBPM_ST_VCX64_OBJS       = 
LIBMC_VCX64_OBJS          = 
LIBEX_VCX64_OBJS          = 
LIBPM_VCX64_OBJS          = 

###########################################################################
## TOOLCHAIN SPECIFICATIONS
###########################################################################

# Toolchain Name:          Microsoft Visual C++ 2022 v17.0 | nmake (64-bit Windows)
# Supported Version(s):    17.0
# ToolchainInfo Version:   2026b
# Specification Revision:  1.0
# 
#-------------------------------------------
# Macros assumed to be defined elsewhere
#-------------------------------------------

# C_STANDARD_OPTS
# CPP_STANDARD_OPTS
# NODEBUG
# cvarsdll
# cvarsmt
# conlibsmt
# ldebug
# conflags
# cflags

#-----------
# MACROS
#-----------

MW_EXTERNLIB_DIR    = $(MATLAB_ROOT)\extern\lib\win64\microsoft
MW_LIB_DIR          = $(MATLAB_ROOT)\lib\win64
CPU                 = AMD64
APPVER              = 5.02
CVARSFLAG           = $(cvarsmt)
CFLAGS_ADDITIONAL   = -D_CRT_SECURE_NO_WARNINGS
CPPFLAGS_ADDITIONAL = -EHs -D_CRT_SECURE_NO_WARNINGS /wd4251 /Zc:__cplusplus
LIBS_TOOLCHAIN      = $(conlibs)

TOOLCHAIN_SRCS = 
TOOLCHAIN_INCS = 
TOOLCHAIN_LIBS = 

#------------------------
# BUILD TOOL COMMANDS
#------------------------

# C Compiler: Microsoft Visual C Compiler
CC = cl

# Linker: Microsoft Visual C Linker
LD = link

# C++ Compiler: Microsoft Visual C++ Compiler
CPP = cl

# C++ Linker: Microsoft Visual C++ Linker
CPP_LD = link

# Archiver: Microsoft Visual C/C++ Archiver
AR = lib

# MEX Tool: MEX Tool
MEX_PATH = $(MATLAB_ARCH_BIN)
MEX = "$(MEX_PATH)\mex"

# Download: Download
DOWNLOAD =

# Execute: Execute
EXECUTE = $(PRODUCT)

# Builder: NMAKE Utility
MAKE = nmake


#-------------------------
# Directives/Utilities
#-------------------------

CDEBUG              = -Z7
C_OUTPUT_FLAG       = -Fo
LDDEBUG             = /DEBUG
OUTPUT_FLAG         = -out:
CPPDEBUG            = -Z7
CPP_OUTPUT_FLAG     = -Fo
CPPLDDEBUG          = /DEBUG
OUTPUT_FLAG         = -out:
ARDEBUG             =
STATICLIB_OUTPUT_FLAG = -out:
MEX_DEBUG           = -g
RM                  = @del
ECHO                = @echo
MV                  = @ren
RUN                 = @cmd /C

#----------------------------------------
# "Faster Builds" Build Configuration
#----------------------------------------

MEX_CPPFLAGS         =
MEX_CPPLDFLAGS       =
MEX_CFLAGS           =
MEX_LDFLAGS          =



#---------------------------
# Model-Specific Options
#---------------------------

CFLAGS = $(cflags) $(cvarsdll) $(CFLAGS_ADDITIONAL) $(C_STANDARD_OPTS) /Od /Oy-

LDFLAGS = $(ldebug) $(conflags) $(LIBS_TOOLCHAIN)

SHAREDLIB_LDFLAGS = $(ldebug) $(conflags) $(LIBS_TOOLCHAIN) -dll -def:$(DEF_FILE)

CPPFLAGS = /TP $(cflags) $(cvarsdll) $(CPPFLAGS_ADDITIONAL) $(CPP_STANDARD_OPTS) /Od /Oy-

CPP_LDFLAGS = $(ldebug) $(conflags) $(LIBS_TOOLCHAIN)

CPP_SHAREDLIB_LDFLAGS = $(ldebug) $(conflags) $(LIBS_TOOLCHAIN) -dll -def:$(DEF_FILE)

ARFLAGS = /nologo

DOWNLOAD_FLAGS = 

EXECUTE_FLAGS = 

MAKE_FLAGS = -f $(MAKEFILE)

###########################################################################
## OUTPUT INFO
###########################################################################

PRODUCT = .\SeriesHybridTransmission.dll
PRODUCT_TYPE = "shared library"
BUILD_TYPE = "Shared Library Target"

###########################################################################
## INCLUDE PATHS
###########################################################################

INCLUDES_BUILDINFO = 

INCLUDES = $(INCLUDES_BUILDINFO)

###########################################################################
## DEFINES
###########################################################################

DEFINES_BUILD_ARGS = -DCLASSIC_INTERFACE=1 -DALLOCATIONFCN=0 -DONESTEPFCN=0 -DTERMFCN=1 -DMULTI_INSTANCE_CODE=0 -DINTEGER_CODE=0
DEFINES_CUSTOM = -DEXT_MODE -DIS_RAPID_ACCEL
DEFINES_OPTS = -DTGTCONN -DIS_SIM_TARGET -DENABLE_SLEXEC_SSBRIDGE=1 -DNRT -DRSIM_PARAMETER_LOADING -DRSIM_WITH_SL_SOLVER -DUSE_LOCALHOST -DMODEL_HAS_DYNAMICALLY_LOADED_SFCNS=0 -DON_TARGET_WAIT_FOR_START=0 -DTID01EQ=0
DEFINES_STANDARD = -DMODEL=SeriesHybridTransmission -DNUMST=2 -DNCSTATES=34 -DHAVESTDIO

DEFINES = $(DEFINES_BUILD_ARGS) $(DEFINES_CUSTOM) $(DEFINES_OPTS) $(DEFINES_STANDARD)

###########################################################################
## SOURCE FILES
###########################################################################

SRCS = $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mcon_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_vmf.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_acon_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_passert.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_vdf.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_imin.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mpar_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_slv.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxf_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_lv.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_slf0.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mdxy_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_log.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_slf.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_obs_il.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_tdxf_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxy.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxy_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxf.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_vpf.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_obs_act.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mnl_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_acon.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_icrm_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_eq_tol.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_qx.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_vsf.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_tdxy_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mode.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_sclv.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_obs_exp.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_y.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxdelt_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxicrm_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dnf_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_ic.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_obs_all.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_imax.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxm_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_assert.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxcer_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxicr_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_qx_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dnf_v_x.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_f.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dp_r.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_nldv.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_var_tol.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_apar_p.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_zc.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_gateway.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_backsubrr_dbl.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_forwardsubrr_dbl.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_lu_real.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_matrixlib_dbl.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_capi.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_data.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_tgtconn.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\rtGetInf.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_nonfinite.c $(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_zcfcnRefine.c $(MATLAB_ROOT)\rtw\c\raccel\raccel_main.c $(MATLAB_ROOT)\rtw\c\raccel\raccel_sup.c $(MATLAB_ROOT)\rtw\c\raccel\raccel_mat.c $(MATLAB_ROOT)\simulink\include\simulink_solver_api.c $(MATLAB_ROOT)\rtw\c\src\rapid\raccel_utils.c $(MATLAB_ROOT)\rtw\c\src\rapid\slsa_sim_common_utils.c $(MATLAB_ROOT)\rtw\c\src\ext_mode\common\ext_svr.c $(MATLAB_ROOT)\rtw\c\src\ext_mode\common\updown.c $(MATLAB_ROOT)\rtw\c\src\ext_mode\common\ext_work.c $(MATLAB_ROOT)\rtw\c\src\ext_mode\common\rtiostream_interface.c $(MATLAB_ROOT)\toolbox\coder\rtiostream\src\rtiostreamtcpip\rtiostream_tcpip.c $(MATLAB_ROOT)\toolbox\coder\rtiostream\src\utils\rtiostream_utils.c

ALL_SRCS = $(SRCS)

###########################################################################
## OBJECTS
###########################################################################

OBJS = SeriesHybridTransmission_836bb176_1_ds.obj SeriesHybridTransmission_836bb176_1_ds_mcon_p.obj SeriesHybridTransmission_836bb176_1_ds_vmf.obj SeriesHybridTransmission_836bb176_1_ds_acon_p.obj SeriesHybridTransmission_836bb176_1_ds_passert.obj SeriesHybridTransmission_836bb176_1_ds_vdf.obj SeriesHybridTransmission_836bb176_1_ds_imin.obj SeriesHybridTransmission_836bb176_1_ds_mpar_p.obj SeriesHybridTransmission_836bb176_1_ds_slv.obj SeriesHybridTransmission_836bb176_1_ds_dxf_p.obj SeriesHybridTransmission_836bb176_1_ds_lv.obj SeriesHybridTransmission_836bb176_1_ds_slf0.obj SeriesHybridTransmission_836bb176_1_ds_mdxy_p.obj SeriesHybridTransmission_836bb176_1_ds_log.obj SeriesHybridTransmission_836bb176_1_ds_slf.obj SeriesHybridTransmission_836bb176_1_ds_obs_il.obj SeriesHybridTransmission_836bb176_1_ds_tdxf_p.obj SeriesHybridTransmission_836bb176_1_ds_dxy.obj SeriesHybridTransmission_836bb176_1_ds_dxy_p.obj SeriesHybridTransmission_836bb176_1_ds_dxf.obj SeriesHybridTransmission_836bb176_1_ds_vpf.obj SeriesHybridTransmission_836bb176_1_ds_obs_act.obj SeriesHybridTransmission_836bb176_1_ds_mnl_p.obj SeriesHybridTransmission_836bb176_1_ds_acon.obj SeriesHybridTransmission_836bb176_1_ds_icrm_p.obj SeriesHybridTransmission_836bb176_1_ds_eq_tol.obj SeriesHybridTransmission_836bb176_1_ds_qx.obj SeriesHybridTransmission_836bb176_1_ds_vsf.obj SeriesHybridTransmission_836bb176_1_ds_tdxy_p.obj SeriesHybridTransmission_836bb176_1_ds_mode.obj SeriesHybridTransmission_836bb176_1_ds_sclv.obj SeriesHybridTransmission_836bb176_1_ds_obs_exp.obj SeriesHybridTransmission_836bb176_1_ds_y.obj SeriesHybridTransmission_836bb176_1_ds_dxdelt_p.obj SeriesHybridTransmission_836bb176_1_ds_dxicrm_p.obj SeriesHybridTransmission_836bb176_1_ds_dnf_p.obj SeriesHybridTransmission_836bb176_1_ds_ic.obj SeriesHybridTransmission_836bb176_1_ds_obs_all.obj SeriesHybridTransmission_836bb176_1_ds_imax.obj SeriesHybridTransmission_836bb176_1_ds_dxm_p.obj SeriesHybridTransmission_836bb176_1_ds_assert.obj SeriesHybridTransmission_836bb176_1_ds_dxcer_p.obj SeriesHybridTransmission_836bb176_1_ds_dxicr_p.obj SeriesHybridTransmission_836bb176_1_ds_qx_p.obj SeriesHybridTransmission_836bb176_1_ds_dnf_v_x.obj SeriesHybridTransmission_836bb176_1_ds_f.obj SeriesHybridTransmission_836bb176_1_ds_dp_r.obj SeriesHybridTransmission_836bb176_1_ds_nldv.obj SeriesHybridTransmission_836bb176_1_ds_var_tol.obj SeriesHybridTransmission_836bb176_1_ds_apar_p.obj SeriesHybridTransmission_836bb176_1_ds_zc.obj SeriesHybridTransmission_836bb176_1.obj SeriesHybridTransmission_836bb176_1_gateway.obj rt_backsubrr_dbl.obj rt_forwardsubrr_dbl.obj rt_lu_real.obj rt_matrixlib_dbl.obj SeriesHybridTransmission.obj SeriesHybridTransmission_capi.obj SeriesHybridTransmission_data.obj SeriesHybridTransmission_tgtconn.obj rtGetInf.obj rt_nonfinite.obj rt_zcfcnRefine.obj raccel_main.obj raccel_sup.obj raccel_mat.obj simulink_solver_api.obj raccel_utils.obj slsa_sim_common_utils.obj ext_svr.obj updown.obj ext_work.obj rtiostream_interface.obj rtiostream_tcpip.obj rtiostream_utils.obj

ALL_OBJS = $(OBJS)

###########################################################################
## PREBUILT OBJECT FILES
###########################################################################

PREBUILT_OBJS = 

###########################################################################
## LIBRARIES
###########################################################################

LIBS = $(MATLAB_ROOT)\extern\physmod\win64\ssc_sli\lib\ssc_sli_vcx64.lib $(MATLAB_ROOT)\extern\physmod\win64\ssc_core\lib\ssc_core_vcx64.lib $(MATLAB_ROOT)\extern\physmod\win64\pm_st\lib\pm_st_vcx64.lib $(MATLAB_ROOT)\extern\physmod\win64\mc\lib\mc_vcx64.lib $(MATLAB_ROOT)\extern\physmod\win64\ex\lib\ex_vcx64.lib $(MATLAB_ROOT)\extern\physmod\win64\pm\lib\pm_vcx64.lib

###########################################################################
## SYSTEM LIBRARIES
###########################################################################

SYSTEM_LIBS = /LIBPATH:"$(MATLAB_ROOT)\extern\lib\win64\microsoft" "$(MW_LIB_DIR)\libmwipp.lib" "$(MW_EXTERNLIB_DIR)\libmwipp.lib" "$(MW_EXTERNLIB_DIR)\libut.lib" "$(MW_EXTERNLIB_DIR)\libmx.lib" "$(MW_EXTERNLIB_DIR)\libmex.lib" "$(MW_EXTERNLIB_DIR)\libmat.lib" "$(MW_EXTERNLIB_DIR)\libmwmathutil.lib" "$(MW_EXTERNLIB_DIR)\libmwslsa_engine.lib" "$(MW_EXTERNLIB_DIR)\libmwslexec_simbridge.lib" "$(MW_EXTERNLIB_DIR)\libmwsl_fileio.lib" "$(MW_EXTERNLIB_DIR)\libmwsigstream.lib" "$(MW_EXTERNLIB_DIR)\libmwsl_AsyncioQueue.lib" "$(MW_EXTERNLIB_DIR)\libmwsl_services.lib" "$(MW_EXTERNLIB_DIR)\libmwsdi_raccel.lib" "$(MW_EXTERNLIB_DIR)\libmwcoder_target_services.lib" "$(MW_EXTERNLIB_DIR)\libmwcoder_ParamTuningTgtAppSvc.lib" "$(MW_EXTERNLIB_DIR)\libmwslpointerutil.lib" "$(MW_EXTERNLIB_DIR)\libmwfoundation_i18n_init_c_api.lib" "$(MW_EXTERNLIB_DIR)\libmwsimulinkcoder_capi.lib" "$(MW_EXTERNLIB_DIR)\libmwsl_simtarget_instrumentation.lib" "$(MW_EXTERNLIB_DIR)\libfixedpoint.lib" "$(MW_EXTERNLIB_DIR)\libmwslexec_simlog.lib" "$(MW_EXTERNLIB_DIR)\libmwstringutil.lib"

###########################################################################
## ADDITIONAL TOOLCHAIN FLAGS
###########################################################################

#---------------
# C Compiler
#---------------

CFLAGS_ = -utf-8 /wd4459
CFLAGS_BASIC = $(DEFINES) @$(COMPILER_COMMAND_FILE)

CFLAGS = $(CFLAGS) $(CFLAGS_) $(CFLAGS_BASIC)

#-----------
# Linker
#-----------

LDFLAGS_ = -LARGEADDRESSAWARE

LDFLAGS = $(LDFLAGS) $(LDFLAGS_)

#--------------------------
# Shared Library Linker
#--------------------------

SHAREDLIB_LDFLAGS_ = -LARGEADDRESSAWARE

SHAREDLIB_LDFLAGS = $(SHAREDLIB_LDFLAGS) $(SHAREDLIB_LDFLAGS_)

#-----------------
# C++ Compiler
#-----------------

CPPFLAGS_ = -utf-8 /wd4459
CPPFLAGS_BASIC = $(DEFINES) @$(COMPILER_COMMAND_FILE)

CPPFLAGS = $(CPPFLAGS) $(CPPFLAGS_) $(CPPFLAGS_BASIC)

#---------------
# C++ Linker
#---------------

CPP_LDFLAGS_ = -LARGEADDRESSAWARE

CPP_LDFLAGS = $(CPP_LDFLAGS) $(CPP_LDFLAGS_)

#------------------------------
# C++ Shared Library Linker
#------------------------------

CPP_SHAREDLIB_LDFLAGS_ = -LARGEADDRESSAWARE

CPP_SHAREDLIB_LDFLAGS = $(CPP_SHAREDLIB_LDFLAGS) $(CPP_SHAREDLIB_LDFLAGS_)

###########################################################################
## INLINED COMMANDS
###########################################################################


!include $(MATLAB_ROOT)\rtw\c\tools\vcdefs.mak


###########################################################################
## PHONY TARGETS
###########################################################################

.PHONY : all build clean info prebuild download execute set_environment_variables


all : build
	@cmd /C @echo ### Successfully generated all binary outputs.


build : set_environment_variables prebuild $(PRODUCT)


prebuild : 


download : $(PRODUCT)


execute : download


set_environment_variables : 
	@set INCLUDE=$(INCLUDES);$(INCLUDE)
	@set LIB=$(LIB)


###########################################################################
## FINAL TARGET
###########################################################################

#----------------------------------------
# Create a shared library
#----------------------------------------

$(PRODUCT) : $(OBJS) $(PREBUILT_OBJS) $(LIBS)
	@cmd /C @echo ### Creating shared library "$(PRODUCT)" ...
	$(LD) $(SHAREDLIB_LDFLAGS) -out:$(PRODUCT) @$(CMD_FILE) $(LIBS) $(SYSTEM_LIBS) $(TOOLCHAIN_LIBS)
	@cmd /C @echo ### Created: "$(PRODUCT)"


###########################################################################
## INTERMEDIATE TARGETS
###########################################################################

#---------------------
# SOURCE-TO-OBJECT
#---------------------

.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(RELATIVE_PATH_TO_ANCHOR)}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(RELATIVE_PATH_TO_ANCHOR)}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(RELATIVE_PATH_TO_ANCHOR)}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(RELATIVE_PATH_TO_ANCHOR)}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\ex\src}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\ex\src}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\ex\src}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\ex\src}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\mc\src}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\mc\src}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\mc\src}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\mc\src}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\pm\src}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\pm\src}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\pm\src}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\pm\src}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\pm_st\src}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\pm_st\src}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\pm_st\src}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\pm_st\src}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\ssc_core\src}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\ssc_core\src}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\ssc_core\src}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\ssc_core\src}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\ssc_sli\src}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\ssc_sli\src}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\ssc_sli\src}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\extern\physmod\win64\ssc_sli\src}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(START_DIR)}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)\slprj\raccel\SeriesHybridTransmission}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(START_DIR)\slprj\raccel\SeriesHybridTransmission}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)\slprj\raccel\SeriesHybridTransmission}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(START_DIR)\slprj\raccel\SeriesHybridTransmission}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\rtw\c\src}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\rtw\c\src}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\rtw\c\src}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\rtw\c\src}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\simulink\src}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\simulink\src}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\simulink\src}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\simulink\src}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\toolbox\simulink\blocks\src}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\toolbox\simulink\blocks\src}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\toolbox\simulink\blocks\src}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\toolbox\simulink\blocks\src}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\rtw\c\src\ext_mode\common}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\rtw\c\src\ext_mode\common}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\rtw\c\src\ext_mode\common}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\rtw\c\src\ext_mode\common}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\toolbox\coder\rtiostream\src\rtiostreamtcpip}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\toolbox\coder\rtiostream\src\rtiostreamtcpip}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\toolbox\coder\rtiostream\src\rtiostreamtcpip}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\toolbox\coder\rtiostream\src\rtiostreamtcpip}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\toolbox\coder\rtiostream\src\utils}.c.obj:
	$(CC) $(CFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\toolbox\coder\rtiostream\src\utils}.cpp.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\toolbox\coder\rtiostream\src\utils}.cc.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


{$(MATLAB_ROOT)\toolbox\coder\rtiostream\src\utils}.cxx.obj:
	$(CPP) $(CPPFLAGS) -Fo"$@" "$<"


SeriesHybridTransmission_836bb176_1_ds.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds.c"


SeriesHybridTransmission_836bb176_1_ds_mcon_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mcon_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mcon_p.c"


SeriesHybridTransmission_836bb176_1_ds_vmf.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_vmf.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_vmf.c"


SeriesHybridTransmission_836bb176_1_ds_acon_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_acon_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_acon_p.c"


SeriesHybridTransmission_836bb176_1_ds_passert.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_passert.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_passert.c"


SeriesHybridTransmission_836bb176_1_ds_vdf.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_vdf.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_vdf.c"


SeriesHybridTransmission_836bb176_1_ds_imin.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_imin.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_imin.c"


SeriesHybridTransmission_836bb176_1_ds_mpar_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mpar_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mpar_p.c"


SeriesHybridTransmission_836bb176_1_ds_slv.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_slv.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_slv.c"


SeriesHybridTransmission_836bb176_1_ds_dxf_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxf_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxf_p.c"


SeriesHybridTransmission_836bb176_1_ds_lv.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_lv.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_lv.c"


SeriesHybridTransmission_836bb176_1_ds_slf0.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_slf0.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_slf0.c"


SeriesHybridTransmission_836bb176_1_ds_mdxy_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mdxy_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mdxy_p.c"


SeriesHybridTransmission_836bb176_1_ds_log.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_log.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_log.c"


SeriesHybridTransmission_836bb176_1_ds_slf.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_slf.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_slf.c"


SeriesHybridTransmission_836bb176_1_ds_obs_il.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_obs_il.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_obs_il.c"


SeriesHybridTransmission_836bb176_1_ds_tdxf_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_tdxf_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_tdxf_p.c"


SeriesHybridTransmission_836bb176_1_ds_dxy.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxy.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxy.c"


SeriesHybridTransmission_836bb176_1_ds_dxy_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxy_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxy_p.c"


SeriesHybridTransmission_836bb176_1_ds_dxf.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxf.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxf.c"


SeriesHybridTransmission_836bb176_1_ds_vpf.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_vpf.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_vpf.c"


SeriesHybridTransmission_836bb176_1_ds_obs_act.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_obs_act.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_obs_act.c"


SeriesHybridTransmission_836bb176_1_ds_mnl_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mnl_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mnl_p.c"


SeriesHybridTransmission_836bb176_1_ds_acon.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_acon.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_acon.c"


SeriesHybridTransmission_836bb176_1_ds_icrm_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_icrm_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_icrm_p.c"


SeriesHybridTransmission_836bb176_1_ds_eq_tol.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_eq_tol.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_eq_tol.c"


SeriesHybridTransmission_836bb176_1_ds_qx.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_qx.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_qx.c"


SeriesHybridTransmission_836bb176_1_ds_vsf.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_vsf.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_vsf.c"


SeriesHybridTransmission_836bb176_1_ds_tdxy_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_tdxy_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_tdxy_p.c"


SeriesHybridTransmission_836bb176_1_ds_mode.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mode.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_mode.c"


SeriesHybridTransmission_836bb176_1_ds_sclv.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_sclv.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_sclv.c"


SeriesHybridTransmission_836bb176_1_ds_obs_exp.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_obs_exp.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_obs_exp.c"


SeriesHybridTransmission_836bb176_1_ds_y.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_y.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_y.c"


SeriesHybridTransmission_836bb176_1_ds_dxdelt_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxdelt_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxdelt_p.c"


SeriesHybridTransmission_836bb176_1_ds_dxicrm_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxicrm_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxicrm_p.c"


SeriesHybridTransmission_836bb176_1_ds_dnf_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dnf_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dnf_p.c"


SeriesHybridTransmission_836bb176_1_ds_ic.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_ic.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_ic.c"


SeriesHybridTransmission_836bb176_1_ds_obs_all.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_obs_all.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_obs_all.c"


SeriesHybridTransmission_836bb176_1_ds_imax.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_imax.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_imax.c"


SeriesHybridTransmission_836bb176_1_ds_dxm_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxm_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxm_p.c"


SeriesHybridTransmission_836bb176_1_ds_assert.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_assert.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_assert.c"


SeriesHybridTransmission_836bb176_1_ds_dxcer_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxcer_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxcer_p.c"


SeriesHybridTransmission_836bb176_1_ds_dxicr_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxicr_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dxicr_p.c"


SeriesHybridTransmission_836bb176_1_ds_qx_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_qx_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_qx_p.c"


SeriesHybridTransmission_836bb176_1_ds_dnf_v_x.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dnf_v_x.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dnf_v_x.c"


SeriesHybridTransmission_836bb176_1_ds_f.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_f.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_f.c"


SeriesHybridTransmission_836bb176_1_ds_dp_r.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dp_r.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_dp_r.c"


SeriesHybridTransmission_836bb176_1_ds_nldv.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_nldv.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_nldv.c"


SeriesHybridTransmission_836bb176_1_ds_var_tol.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_var_tol.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_var_tol.c"


SeriesHybridTransmission_836bb176_1_ds_apar_p.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_apar_p.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_apar_p.c"


SeriesHybridTransmission_836bb176_1_ds_zc.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_zc.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_ds_zc.c"


SeriesHybridTransmission_836bb176_1.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1.c"


SeriesHybridTransmission_836bb176_1_gateway.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_gateway.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_836bb176_1_gateway.c"


rt_backsubrr_dbl.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_backsubrr_dbl.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_backsubrr_dbl.c"


rt_forwardsubrr_dbl.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_forwardsubrr_dbl.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_forwardsubrr_dbl.c"


rt_lu_real.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_lu_real.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_lu_real.c"


rt_matrixlib_dbl.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_matrixlib_dbl.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_matrixlib_dbl.c"


SeriesHybridTransmission.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission.c"


SeriesHybridTransmission_capi.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_capi.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_capi.c"


SeriesHybridTransmission_data.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_data.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_data.c"


SeriesHybridTransmission_tgtconn.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_tgtconn.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\SeriesHybridTransmission_tgtconn.c"


rtGetInf.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rtGetInf.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rtGetInf.c"


rt_nonfinite.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_nonfinite.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_nonfinite.c"


rt_zcfcnRefine.obj : "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_zcfcnRefine.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(START_DIR)\slprj\raccel\SeriesHybridTransmission\rt_zcfcnRefine.c"


raccel_main.obj : "$(MATLAB_ROOT)\rtw\c\raccel\raccel_main.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(MATLAB_ROOT)\rtw\c\raccel\raccel_main.c"


raccel_sup.obj : "$(MATLAB_ROOT)\rtw\c\raccel\raccel_sup.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(MATLAB_ROOT)\rtw\c\raccel\raccel_sup.c"


raccel_mat.obj : "$(MATLAB_ROOT)\rtw\c\raccel\raccel_mat.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(MATLAB_ROOT)\rtw\c\raccel\raccel_mat.c"


simulink_solver_api.obj : "$(MATLAB_ROOT)\simulink\include\simulink_solver_api.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(MATLAB_ROOT)\simulink\include\simulink_solver_api.c"


raccel_utils.obj : "$(MATLAB_ROOT)\rtw\c\src\rapid\raccel_utils.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(MATLAB_ROOT)\rtw\c\src\rapid\raccel_utils.c"


slsa_sim_common_utils.obj : "$(MATLAB_ROOT)\rtw\c\src\rapid\slsa_sim_common_utils.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(MATLAB_ROOT)\rtw\c\src\rapid\slsa_sim_common_utils.c"


ext_svr.obj : "$(MATLAB_ROOT)\rtw\c\src\ext_mode\common\ext_svr.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(MATLAB_ROOT)\rtw\c\src\ext_mode\common\ext_svr.c"


updown.obj : "$(MATLAB_ROOT)\rtw\c\src\ext_mode\common\updown.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(MATLAB_ROOT)\rtw\c\src\ext_mode\common\updown.c"


ext_work.obj : "$(MATLAB_ROOT)\rtw\c\src\ext_mode\common\ext_work.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(MATLAB_ROOT)\rtw\c\src\ext_mode\common\ext_work.c"


rtiostream_interface.obj : "$(MATLAB_ROOT)\rtw\c\src\ext_mode\common\rtiostream_interface.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(MATLAB_ROOT)\rtw\c\src\ext_mode\common\rtiostream_interface.c"


rtiostream_tcpip.obj : "$(MATLAB_ROOT)\toolbox\coder\rtiostream\src\rtiostreamtcpip\rtiostream_tcpip.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(MATLAB_ROOT)\toolbox\coder\rtiostream\src\rtiostreamtcpip\rtiostream_tcpip.c"


rtiostream_utils.obj : "$(MATLAB_ROOT)\toolbox\coder\rtiostream\src\utils\rtiostream_utils.c"
	$(CC) $(CFLAGS) -Fo"$@" "$(MATLAB_ROOT)\toolbox\coder\rtiostream\src\utils\rtiostream_utils.c"


#------------------------
# BUILDABLE LIBRARIES
#------------------------

$(MATLAB_ROOT)\extern\physmod\win64\ssc_sli\lib\ssc_sli_vcx64.lib : $(LIBSSC_SLI_VCX64_OBJS)
	@cmd /C @echo ### Creating static library $@ ...
	$(AR) $(ARFLAGS) -out:$@ $(LIBSSC_SLI_VCX64_OBJS)


$(MATLAB_ROOT)\extern\physmod\win64\ssc_core\lib\ssc_core_vcx64.lib : $(LIBSSC_CORE_VCX64_OBJS)
	@cmd /C @echo ### Creating static library $@ ...
	$(AR) $(ARFLAGS) -out:$@ $(LIBSSC_CORE_VCX64_OBJS)


$(MATLAB_ROOT)\extern\physmod\win64\pm_st\lib\pm_st_vcx64.lib : $(LIBPM_ST_VCX64_OBJS)
	@cmd /C @echo ### Creating static library $@ ...
	$(AR) $(ARFLAGS) -out:$@ $(LIBPM_ST_VCX64_OBJS)


$(MATLAB_ROOT)\extern\physmod\win64\mc\lib\mc_vcx64.lib : $(LIBMC_VCX64_OBJS)
	@cmd /C @echo ### Creating static library $@ ...
	$(AR) $(ARFLAGS) -out:$@ $(LIBMC_VCX64_OBJS)


$(MATLAB_ROOT)\extern\physmod\win64\ex\lib\ex_vcx64.lib : $(LIBEX_VCX64_OBJS)
	@cmd /C @echo ### Creating static library $@ ...
	$(AR) $(ARFLAGS) -out:$@ $(LIBEX_VCX64_OBJS)


$(MATLAB_ROOT)\extern\physmod\win64\pm\lib\pm_vcx64.lib : $(LIBPM_VCX64_OBJS)
	@cmd /C @echo ### Creating static library $@ ...
	$(AR) $(ARFLAGS) -out:$@ $(LIBPM_VCX64_OBJS)


###########################################################################
## DEPENDENCIES
###########################################################################

$(ALL_OBJS) : rtw_proj.tmw $(COMPILER_COMMAND_FILE) $(MAKEFILE)


###########################################################################
## MISCELLANEOUS TARGETS
###########################################################################

info : 
	@cmd /C @echo ### PRODUCT = $(PRODUCT)
	@cmd /C @echo ### PRODUCT_TYPE = $(PRODUCT_TYPE)
	@cmd /C @echo ### BUILD_TYPE = $(BUILD_TYPE)
	@cmd /C @echo ### INCLUDES = $(INCLUDES)
	@cmd /C @echo ### DEFINES = $(DEFINES)
	@cmd /C @echo ### ALL_SRCS = $(ALL_SRCS)
	@cmd /C @echo ### ALL_OBJS = $(ALL_OBJS)
	@cmd /C @echo ### LIBS = $(LIBS)
	@cmd /C @echo ### MODELREF_LIBS = $(MODELREF_LIBS)
	@cmd /C @echo ### SYSTEM_LIBS = $(SYSTEM_LIBS)
	@cmd /C @echo ### TOOLCHAIN_LIBS = $(TOOLCHAIN_LIBS)
	@cmd /C @echo ### CFLAGS = $(CFLAGS)
	@cmd /C @echo ### LDFLAGS = $(LDFLAGS)
	@cmd /C @echo ### SHAREDLIB_LDFLAGS = $(SHAREDLIB_LDFLAGS)
	@cmd /C @echo ### CPPFLAGS = $(CPPFLAGS)
	@cmd /C @echo ### CPP_LDFLAGS = $(CPP_LDFLAGS)
	@cmd /C @echo ### CPP_SHAREDLIB_LDFLAGS = $(CPP_SHAREDLIB_LDFLAGS)
	@cmd /C @echo ### ARFLAGS = $(ARFLAGS)
	@cmd /C @echo ### MEX_CFLAGS = $(MEX_CFLAGS)
	@cmd /C @echo ### MEX_CPPFLAGS = $(MEX_CPPFLAGS)
	@cmd /C @echo ### MEX_LDFLAGS = $(MEX_LDFLAGS)
	@cmd /C @echo ### MEX_CPPLDFLAGS = $(MEX_CPPLDFLAGS)
	@cmd /C @echo ### DOWNLOAD_FLAGS = $(DOWNLOAD_FLAGS)
	@cmd /C @echo ### EXECUTE_FLAGS = $(EXECUTE_FLAGS)
	@cmd /C @echo ### MAKE_FLAGS = $(MAKE_FLAGS)


clean : 
	$(ECHO) "### Deleting all derived files ..."
	@if exist $(PRODUCT) $(RM) $(PRODUCT)
	$(RM) $(ALL_OBJS)
	$(ECHO) "### Deleted all derived files."


