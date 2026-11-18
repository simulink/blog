#ifndef struct__NeDynamicSystemTag
#define struct__NeDynamicSystemTag
typedef struct _NeDynamicSystemTag { NeDynamicSystem mBase ; int32_T mRefCnt
; PmAllocator mAlloc ; real_T * mField0 ; } _NeDynamicSystem ;
#else
typedef struct _NeDynamicSystemTag _NeDynamicSystem ;
#endif
