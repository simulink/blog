#ifndef MULTIWORD_TYPES_H
#define MULTIWORD_TYPES_H
#include "rtwtypes.h"
typedef int64_T chunk_T ; typedef uint64_T uchunk_T ; typedef long long
longlong_T ;
#ifndef INT128M_T
#define INT128M_T
typedef struct { uint64_T chunks [ 2 ] ; } int128m_T ;
#endif
#ifndef CINT128M_T
#define CINT128M_T
typedef struct { int128m_T re ; int128m_T im ; } cint128m_T ;
#endif
#ifndef UINT128M_T
#define UINT128M_T
typedef struct { uint64_T chunks [ 2 ] ; } uint128m_T ;
#endif
#ifndef CUINT128M_T
#define CUINT128M_T
typedef struct { uint128m_T re ; uint128m_T im ; } cuint128m_T ;
#endif
#ifndef INT192M_T
#define INT192M_T
typedef struct { uint64_T chunks [ 3 ] ; } int192m_T ;
#endif
#ifndef CINT192M_T
#define CINT192M_T
typedef struct { int192m_T re ; int192m_T im ; } cint192m_T ;
#endif
#ifndef UINT192M_T
#define UINT192M_T
typedef struct { uint64_T chunks [ 3 ] ; } uint192m_T ;
#endif
#ifndef CUINT192M_T
#define CUINT192M_T
typedef struct { uint192m_T re ; uint192m_T im ; } cuint192m_T ;
#endif
#ifndef INT256M_T
#define INT256M_T
typedef struct { uint64_T chunks [ 4 ] ; } int256m_T ;
#endif
#ifndef CINT256M_T
#define CINT256M_T
typedef struct { int256m_T re ; int256m_T im ; } cint256m_T ;
#endif
#ifndef UINT256M_T
#define UINT256M_T
typedef struct { uint64_T chunks [ 4 ] ; } uint256m_T ;
#endif
#ifndef CUINT256M_T
#define CUINT256M_T
typedef struct { uint256m_T re ; uint256m_T im ; } cuint256m_T ;
#endif
#ifndef INT320M_T
#define INT320M_T
typedef struct { uint64_T chunks [ 5 ] ; } int320m_T ;
#endif
#ifndef CINT320M_T
#define CINT320M_T
typedef struct { int320m_T re ; int320m_T im ; } cint320m_T ;
#endif
#ifndef UINT320M_T
#define UINT320M_T
typedef struct { uint64_T chunks [ 5 ] ; } uint320m_T ;
#endif
#ifndef CUINT320M_T
#define CUINT320M_T
typedef struct { uint320m_T re ; uint320m_T im ; } cuint320m_T ;
#endif
#ifndef INT384M_T
#define INT384M_T
typedef struct { uint64_T chunks [ 6 ] ; } int384m_T ;
#endif
#ifndef CINT384M_T
#define CINT384M_T
typedef struct { int384m_T re ; int384m_T im ; } cint384m_T ;
#endif
#ifndef UINT384M_T
#define UINT384M_T
typedef struct { uint64_T chunks [ 6 ] ; } uint384m_T ;
#endif
#ifndef CUINT384M_T
#define CUINT384M_T
typedef struct { uint384m_T re ; uint384m_T im ; } cuint384m_T ;
#endif
#ifndef INT448M_T
#define INT448M_T
typedef struct { uint64_T chunks [ 7 ] ; } int448m_T ;
#endif
#ifndef CINT448M_T
#define CINT448M_T
typedef struct { int448m_T re ; int448m_T im ; } cint448m_T ;
#endif
#ifndef UINT448M_T
#define UINT448M_T
typedef struct { uint64_T chunks [ 7 ] ; } uint448m_T ;
#endif
#ifndef CUINT448M_T
#define CUINT448M_T
typedef struct { uint448m_T re ; uint448m_T im ; } cuint448m_T ;
#endif
#ifndef INT512M_T
#define INT512M_T
typedef struct { uint64_T chunks [ 8 ] ; } int512m_T ;
#endif
#ifndef CINT512M_T
#define CINT512M_T
typedef struct { int512m_T re ; int512m_T im ; } cint512m_T ;
#endif
#ifndef UINT512M_T
#define UINT512M_T
typedef struct { uint64_T chunks [ 8 ] ; } uint512m_T ;
#endif
#ifndef CUINT512M_T
#define CUINT512M_T
typedef struct { uint512m_T re ; uint512m_T im ; } cuint512m_T ;
#endif
#ifndef INT576M_T
#define INT576M_T
typedef struct { uint64_T chunks [ 9 ] ; } int576m_T ;
#endif
#ifndef CINT576M_T
#define CINT576M_T
typedef struct { int576m_T re ; int576m_T im ; } cint576m_T ;
#endif
#ifndef UINT576M_T
#define UINT576M_T
typedef struct { uint64_T chunks [ 9 ] ; } uint576m_T ;
#endif
#ifndef CUINT576M_T
#define CUINT576M_T
typedef struct { uint576m_T re ; uint576m_T im ; } cuint576m_T ;
#endif
#ifndef INT640M_T
#define INT640M_T
typedef struct { uint64_T chunks [ 10 ] ; } int640m_T ;
#endif
#ifndef CINT640M_T
#define CINT640M_T
typedef struct { int640m_T re ; int640m_T im ; } cint640m_T ;
#endif
#ifndef UINT640M_T
#define UINT640M_T
typedef struct { uint64_T chunks [ 10 ] ; } uint640m_T ;
#endif
#ifndef CUINT640M_T
#define CUINT640M_T
typedef struct { uint640m_T re ; uint640m_T im ; } cuint640m_T ;
#endif
#ifndef INT704M_T
#define INT704M_T
typedef struct { uint64_T chunks [ 11 ] ; } int704m_T ;
#endif
#ifndef CINT704M_T
#define CINT704M_T
typedef struct { int704m_T re ; int704m_T im ; } cint704m_T ;
#endif
#ifndef UINT704M_T
#define UINT704M_T
typedef struct { uint64_T chunks [ 11 ] ; } uint704m_T ;
#endif
#ifndef CUINT704M_T
#define CUINT704M_T
typedef struct { uint704m_T re ; uint704m_T im ; } cuint704m_T ;
#endif
#ifndef INT768M_T
#define INT768M_T
typedef struct { uint64_T chunks [ 12 ] ; } int768m_T ;
#endif
#ifndef CINT768M_T
#define CINT768M_T
typedef struct { int768m_T re ; int768m_T im ; } cint768m_T ;
#endif
#ifndef UINT768M_T
#define UINT768M_T
typedef struct { uint64_T chunks [ 12 ] ; } uint768m_T ;
#endif
#ifndef CUINT768M_T
#define CUINT768M_T
typedef struct { uint768m_T re ; uint768m_T im ; } cuint768m_T ;
#endif
#ifndef INT832M_T
#define INT832M_T
typedef struct { uint64_T chunks [ 13 ] ; } int832m_T ;
#endif
#ifndef CINT832M_T
#define CINT832M_T
typedef struct { int832m_T re ; int832m_T im ; } cint832m_T ;
#endif
#ifndef UINT832M_T
#define UINT832M_T
typedef struct { uint64_T chunks [ 13 ] ; } uint832m_T ;
#endif
#ifndef CUINT832M_T
#define CUINT832M_T
typedef struct { uint832m_T re ; uint832m_T im ; } cuint832m_T ;
#endif
#ifndef INT896M_T
#define INT896M_T
typedef struct { uint64_T chunks [ 14 ] ; } int896m_T ;
#endif
#ifndef CINT896M_T
#define CINT896M_T
typedef struct { int896m_T re ; int896m_T im ; } cint896m_T ;
#endif
#ifndef UINT896M_T
#define UINT896M_T
typedef struct { uint64_T chunks [ 14 ] ; } uint896m_T ;
#endif
#ifndef CUINT896M_T
#define CUINT896M_T
typedef struct { uint896m_T re ; uint896m_T im ; } cuint896m_T ;
#endif
#ifndef INT960M_T
#define INT960M_T
typedef struct { uint64_T chunks [ 15 ] ; } int960m_T ;
#endif
#ifndef CINT960M_T
#define CINT960M_T
typedef struct { int960m_T re ; int960m_T im ; } cint960m_T ;
#endif
#ifndef UINT960M_T
#define UINT960M_T
typedef struct { uint64_T chunks [ 15 ] ; } uint960m_T ;
#endif
#ifndef CUINT960M_T
#define CUINT960M_T
typedef struct { uint960m_T re ; uint960m_T im ; } cuint960m_T ;
#endif
#ifndef INT1024M_T
#define INT1024M_T
typedef struct { uint64_T chunks [ 16 ] ; } int1024m_T ;
#endif
#ifndef CINT1024M_T
#define CINT1024M_T
typedef struct { int1024m_T re ; int1024m_T im ; } cint1024m_T ;
#endif
#ifndef UINT1024M_T
#define UINT1024M_T
typedef struct { uint64_T chunks [ 16 ] ; } uint1024m_T ;
#endif
#ifndef CUINT1024M_T
#define CUINT1024M_T
typedef struct { uint1024m_T re ; uint1024m_T im ; } cuint1024m_T ;
#endif
#ifndef INT1088M_T
#define INT1088M_T
typedef struct { uint64_T chunks [ 17 ] ; } int1088m_T ;
#endif
#ifndef CINT1088M_T
#define CINT1088M_T
typedef struct { int1088m_T re ; int1088m_T im ; } cint1088m_T ;
#endif
#ifndef UINT1088M_T
#define UINT1088M_T
typedef struct { uint64_T chunks [ 17 ] ; } uint1088m_T ;
#endif
#ifndef CUINT1088M_T
#define CUINT1088M_T
typedef struct { uint1088m_T re ; uint1088m_T im ; } cuint1088m_T ;
#endif
#ifndef INT1152M_T
#define INT1152M_T
typedef struct { uint64_T chunks [ 18 ] ; } int1152m_T ;
#endif
#ifndef CINT1152M_T
#define CINT1152M_T
typedef struct { int1152m_T re ; int1152m_T im ; } cint1152m_T ;
#endif
#ifndef UINT1152M_T
#define UINT1152M_T
typedef struct { uint64_T chunks [ 18 ] ; } uint1152m_T ;
#endif
#ifndef CUINT1152M_T
#define CUINT1152M_T
typedef struct { uint1152m_T re ; uint1152m_T im ; } cuint1152m_T ;
#endif
#ifndef INT1216M_T
#define INT1216M_T
typedef struct { uint64_T chunks [ 19 ] ; } int1216m_T ;
#endif
#ifndef CINT1216M_T
#define CINT1216M_T
typedef struct { int1216m_T re ; int1216m_T im ; } cint1216m_T ;
#endif
#ifndef UINT1216M_T
#define UINT1216M_T
typedef struct { uint64_T chunks [ 19 ] ; } uint1216m_T ;
#endif
#ifndef CUINT1216M_T
#define CUINT1216M_T
typedef struct { uint1216m_T re ; uint1216m_T im ; } cuint1216m_T ;
#endif
#ifndef INT1280M_T
#define INT1280M_T
typedef struct { uint64_T chunks [ 20 ] ; } int1280m_T ;
#endif
#ifndef CINT1280M_T
#define CINT1280M_T
typedef struct { int1280m_T re ; int1280m_T im ; } cint1280m_T ;
#endif
#ifndef UINT1280M_T
#define UINT1280M_T
typedef struct { uint64_T chunks [ 20 ] ; } uint1280m_T ;
#endif
#ifndef CUINT1280M_T
#define CUINT1280M_T
typedef struct { uint1280m_T re ; uint1280m_T im ; } cuint1280m_T ;
#endif
#ifndef INT1344M_T
#define INT1344M_T
typedef struct { uint64_T chunks [ 21 ] ; } int1344m_T ;
#endif
#ifndef CINT1344M_T
#define CINT1344M_T
typedef struct { int1344m_T re ; int1344m_T im ; } cint1344m_T ;
#endif
#ifndef UINT1344M_T
#define UINT1344M_T
typedef struct { uint64_T chunks [ 21 ] ; } uint1344m_T ;
#endif
#ifndef CUINT1344M_T
#define CUINT1344M_T
typedef struct { uint1344m_T re ; uint1344m_T im ; } cuint1344m_T ;
#endif
#ifndef INT1408M_T
#define INT1408M_T
typedef struct { uint64_T chunks [ 22 ] ; } int1408m_T ;
#endif
#ifndef CINT1408M_T
#define CINT1408M_T
typedef struct { int1408m_T re ; int1408m_T im ; } cint1408m_T ;
#endif
#ifndef UINT1408M_T
#define UINT1408M_T
typedef struct { uint64_T chunks [ 22 ] ; } uint1408m_T ;
#endif
#ifndef CUINT1408M_T
#define CUINT1408M_T
typedef struct { uint1408m_T re ; uint1408m_T im ; } cuint1408m_T ;
#endif
#ifndef INT1472M_T
#define INT1472M_T
typedef struct { uint64_T chunks [ 23 ] ; } int1472m_T ;
#endif
#ifndef CINT1472M_T
#define CINT1472M_T
typedef struct { int1472m_T re ; int1472m_T im ; } cint1472m_T ;
#endif
#ifndef UINT1472M_T
#define UINT1472M_T
typedef struct { uint64_T chunks [ 23 ] ; } uint1472m_T ;
#endif
#ifndef CUINT1472M_T
#define CUINT1472M_T
typedef struct { uint1472m_T re ; uint1472m_T im ; } cuint1472m_T ;
#endif
#ifndef INT1536M_T
#define INT1536M_T
typedef struct { uint64_T chunks [ 24 ] ; } int1536m_T ;
#endif
#ifndef CINT1536M_T
#define CINT1536M_T
typedef struct { int1536m_T re ; int1536m_T im ; } cint1536m_T ;
#endif
#ifndef UINT1536M_T
#define UINT1536M_T
typedef struct { uint64_T chunks [ 24 ] ; } uint1536m_T ;
#endif
#ifndef CUINT1536M_T
#define CUINT1536M_T
typedef struct { uint1536m_T re ; uint1536m_T im ; } cuint1536m_T ;
#endif
#ifndef INT1600M_T
#define INT1600M_T
typedef struct { uint64_T chunks [ 25 ] ; } int1600m_T ;
#endif
#ifndef CINT1600M_T
#define CINT1600M_T
typedef struct { int1600m_T re ; int1600m_T im ; } cint1600m_T ;
#endif
#ifndef UINT1600M_T
#define UINT1600M_T
typedef struct { uint64_T chunks [ 25 ] ; } uint1600m_T ;
#endif
#ifndef CUINT1600M_T
#define CUINT1600M_T
typedef struct { uint1600m_T re ; uint1600m_T im ; } cuint1600m_T ;
#endif
#ifndef INT1664M_T
#define INT1664M_T
typedef struct { uint64_T chunks [ 26 ] ; } int1664m_T ;
#endif
#ifndef CINT1664M_T
#define CINT1664M_T
typedef struct { int1664m_T re ; int1664m_T im ; } cint1664m_T ;
#endif
#ifndef UINT1664M_T
#define UINT1664M_T
typedef struct { uint64_T chunks [ 26 ] ; } uint1664m_T ;
#endif
#ifndef CUINT1664M_T
#define CUINT1664M_T
typedef struct { uint1664m_T re ; uint1664m_T im ; } cuint1664m_T ;
#endif
#ifndef INT1728M_T
#define INT1728M_T
typedef struct { uint64_T chunks [ 27 ] ; } int1728m_T ;
#endif
#ifndef CINT1728M_T
#define CINT1728M_T
typedef struct { int1728m_T re ; int1728m_T im ; } cint1728m_T ;
#endif
#ifndef UINT1728M_T
#define UINT1728M_T
typedef struct { uint64_T chunks [ 27 ] ; } uint1728m_T ;
#endif
#ifndef CUINT1728M_T
#define CUINT1728M_T
typedef struct { uint1728m_T re ; uint1728m_T im ; } cuint1728m_T ;
#endif
#ifndef INT1792M_T
#define INT1792M_T
typedef struct { uint64_T chunks [ 28 ] ; } int1792m_T ;
#endif
#ifndef CINT1792M_T
#define CINT1792M_T
typedef struct { int1792m_T re ; int1792m_T im ; } cint1792m_T ;
#endif
#ifndef UINT1792M_T
#define UINT1792M_T
typedef struct { uint64_T chunks [ 28 ] ; } uint1792m_T ;
#endif
#ifndef CUINT1792M_T
#define CUINT1792M_T
typedef struct { uint1792m_T re ; uint1792m_T im ; } cuint1792m_T ;
#endif
#ifndef INT1856M_T
#define INT1856M_T
typedef struct { uint64_T chunks [ 29 ] ; } int1856m_T ;
#endif
#ifndef CINT1856M_T
#define CINT1856M_T
typedef struct { int1856m_T re ; int1856m_T im ; } cint1856m_T ;
#endif
#ifndef UINT1856M_T
#define UINT1856M_T
typedef struct { uint64_T chunks [ 29 ] ; } uint1856m_T ;
#endif
#ifndef CUINT1856M_T
#define CUINT1856M_T
typedef struct { uint1856m_T re ; uint1856m_T im ; } cuint1856m_T ;
#endif
#ifndef INT1920M_T
#define INT1920M_T
typedef struct { uint64_T chunks [ 30 ] ; } int1920m_T ;
#endif
#ifndef CINT1920M_T
#define CINT1920M_T
typedef struct { int1920m_T re ; int1920m_T im ; } cint1920m_T ;
#endif
#ifndef UINT1920M_T
#define UINT1920M_T
typedef struct { uint64_T chunks [ 30 ] ; } uint1920m_T ;
#endif
#ifndef CUINT1920M_T
#define CUINT1920M_T
typedef struct { uint1920m_T re ; uint1920m_T im ; } cuint1920m_T ;
#endif
#ifndef INT1984M_T
#define INT1984M_T
typedef struct { uint64_T chunks [ 31 ] ; } int1984m_T ;
#endif
#ifndef CINT1984M_T
#define CINT1984M_T
typedef struct { int1984m_T re ; int1984m_T im ; } cint1984m_T ;
#endif
#ifndef UINT1984M_T
#define UINT1984M_T
typedef struct { uint64_T chunks [ 31 ] ; } uint1984m_T ;
#endif
#ifndef CUINT1984M_T
#define CUINT1984M_T
typedef struct { uint1984m_T re ; uint1984m_T im ; } cuint1984m_T ;
#endif
#ifndef INT2048M_T
#define INT2048M_T
typedef struct { uint64_T chunks [ 32 ] ; } int2048m_T ;
#endif
#ifndef CINT2048M_T
#define CINT2048M_T
typedef struct { int2048m_T re ; int2048m_T im ; } cint2048m_T ;
#endif
#ifndef UINT2048M_T
#define UINT2048M_T
typedef struct { uint64_T chunks [ 32 ] ; } uint2048m_T ;
#endif
#ifndef CUINT2048M_T
#define CUINT2048M_T
typedef struct { uint2048m_T re ; uint2048m_T im ; } cuint2048m_T ;
#endif
#endif
