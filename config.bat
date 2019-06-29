@setlocal enableextensions enabledelayedexpansion
@echo off
@echo Trying to configure OpenCPN
rem ******************************************
rem * This script will configure using Cmake *
rem * to build OpenCPN. Run this in the      *
rem * OpenCPN\build folder.                  *
rem ******************************************

if  not exist .\Debug\NUL mkdir .\Debug
if  not exist .\Release\NUL mkdir .\Release

call findvc.bat

:copyWX 
call copyWX.bat
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%

if not exist .\CMakeCache.txt goto :config
del .\CMakeCache.txt
:config

@echo Updating all plugins to latest
pushd ..\plugins
if not exist aisradar_pi\NUL goto :vfkaps
ren aisradar_pi radar_pi
cd radar_pi
git pull upstream master
git push
cd ..
ren radar_pi aisradar_pi

:vfkaps
if not exist vfkaps_pi\NUL goto :ocpn_draw
pushd vfkaps_pi
git pull upstream master
git push
popd

:ocpn_draw
if not exist ocpn_draw_pi\NUL goto :configure
pushd ..\plugins\ocpn_draw_pi
git pull upstream master
git push
popd

:configure
popd

set "var=%vcgen%"
set "search=2019"
CALL set "test=%%var:%search%=%%"
if "%test%" NEQ "%var%" (set "A_FLAG=-AWin32") else set A_FLAG=
@echo A_FLAG="%A_FLAG%"

set "var=%vcts%"
set "search=_xp"
CALL set "test=%%var:%search%=%%"

if "%test%"=="%var%" (set "XP_FLAG="/SUBSYSTEM:WINDOWS"" ) else (set "XP_FLAG="/SUBSYSTEM:WINDOWS,5.01"")
@echo XP_FLAG=%XP_FLAG%

echo configuring generator %vcgen% and toolset v%vcts%
@echo cmake -Wno-dev %A_FLAG% -G"%vcgen%" -T "v%vcts%" -D CMAKE_CXX_FLAGS="/D_USING_V110_SDK71_ /MP /EHsc" -D CMAKE_C_FLAGS="/MP /D_USING_V110_SDK71_" -D CMAKE_EXE_LINKER_FLAGS=%XP_FLAG% -D CMAKE_MODULE_LINKER_FLAGS=%XP_FLAG% -D CMAKE_SHARED_MODULE_LINKER_FLAGS=%XP_FLAG% ..
cmake -Wno-dev "%A_FLAG%" -G"%vcgen%" -T "v%vcts%" -D CMAKE_CXX_FLAGS="/D_USING_V110_SDK71_ /MP /EHsc" -D CMAKE_C_FLAGS="/MP /D_USING_V110_SDK71_" -D CMAKE_EXE_LINKER_FLAGS=%XP_FLAG% -D CMAKE_MODULE_LINKER_FLAGS=%XP_FLAG% -D CMAKE_SHARED_MODULE_LINKER_FLAGS=%XP_FLAG% ..
set vcts=
set vcgen=
@endlocal
exit /b 0

:noVC
@echo Error: No compatible Visual Studio installed.
@echo VCINSTALLDIR=%VCINSTALLDIR%
@echo VSINSTALLDIR=%VCINSTALLDIR%
@endlocal
exit /b 1

