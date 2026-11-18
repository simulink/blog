set "VSCMD_START_DIR=%CD%"
set "PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer;%PATH%"
CALL "C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\VCVARSALL.BAT " amd64
IF ERRORLEVEL 1 (EXIT /B 1)
