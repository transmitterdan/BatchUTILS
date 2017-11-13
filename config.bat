@setlocal enableextensions enabledelayedexpansion
@echo off
@echo Trying to configure...
rem ******************************************
rem * This script will configure using Cmake *
rem * to build OpenCPN. Run this in the      *
rem * OpenCPN\build folder.                  *
rem ******************************************

call copyWX.bat
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%

set __ts__=
set __gen__=

if "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio 12.0\" call :VS2013
if "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\" call :VS2015
if "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\" call :VS2017
if "%VCINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio\Preview\Community\VC\" call :VS2017

if "__gen__"=="" goto noVC

if not exist .\CMakeCache.txt goto config
del .\CMakeCache.txt
:config

if  not exist .\Debug\NUL mkdir .\Debug
if  not exist .\Release\NUL mkdir .\Release

@echo Updating all plugins to latest
pushd ..\plugins
if not exist aisradar_pi\NUL goto vfkaps
ren aisradar_pi radar_pi
cd radar_pi
git pull upstream master
git push
cd ..
ren radar_pi aisradar_pi

:vfkaps
if not exist vfkaps_pi\NUL goto ocpn_draw
pushd vfkaps_pi
git pull upstream master
git push
popd

:ocpn_draw
if not exist ocpn_draw_pi\NUL goto configure
pushd ..\plugins\ocpn_draw_pi
git pull upstream master
git push
popd

:configure
popd
echo configuring generator %__gen__% and toolset %__ts__%
cmake -Wno-dev -G "%__gen__%" -T "%__ts__%" -D CMAKE_CXX_FLAGS="/D_USING_V110_SDK71_ /MP" -D CMAKE_C_FLAGS="/MP /D_USING_V110_SDK71_" CMAKE_EXE_LINKER_FLAGS=/SUBSYSTEM:WINDOWS",5.01" CMAKE_MODULE_LINKER_FLAGS=/SUBSYSTEM:WINDOWS",5.01" CMAKE_SHARED_MODULE_LINKER_FLAGS=/SUBSYSTEM:WINDOWS",5.01" ..
set __ts__=
set __gen__=
exit /b 0

:noVC
@echo Error: No compatible Visual Studio installed.
@echo VCINSTALLDIR=%VCINSTALLDIR%
exit /b 1

:VS2013
echo Configuring for VS2013
set "__gen__=Visual Studio 12 2013"
set "__ts__=v120_xp"
exit /b 0

:VS2015
echo Configuring for VS2015
set "__gen__=Visual Studio 14 2015"
set "__ts__=v140_xp"
exit /b 0

:VS2017
echo Configuring for VS2017
set "__gen__=Visual Studio 15 2017"
set "__ts__=v141_xp"
exit /b 0
