@setlocal enableextensions enabledelayedexpansion
@echo off
@echo Trying to configure OpenCPN
rem ******************************************
rem * This script will configure using Cmake *
rem * to build OpenCPN. Run this in the      *
rem * OpenCPN\build folder.                  *
rem ******************************************

call findvc.bat

cd "%OpenCPNDIR%\build"

if  not exist .\Debug\NUL mkdir .\Debug
if  not exist .\Release\NUL mkdir .\Release

for /f "tokens=2 delims=[.]" %%x in ('ver') do set WINVER=%%x
@echo WINVER=%WINVER%
if not "%WINVER%"=="Version 10" goto :copyWX

powershell -Command "Invoke-WebRequest http://opencpn.navnux.org/build_deps/OpenCPN_buildwin-4.99a.7z -OutFile buildwin.7z; exit $LASTEXITCODE"
if not %ERRORLEVEL%==0 goto copyWX

7z x -y buildwin.7z -o..\buildwin
del buildwin.7z

:copyWX 
call copyWX.bat
if %ERRORLEVEL% GTR 0 goto :Error

call docopyAll.bat clean

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

if "%test%"=="%var%" (set "XP_FLAG="/SUBSYSTEM:WINDOWS" " ) else (set "XP_FLAG="/SUBSYSTEM:WINDOWS,5.01" ")
@echo XP_FLAG=%XP_FLAG%
echo configuring generator %vcgen% and toolset v%vcts%
@echo cmake -Wno-dev %A_FLAG% -G"%vcgen%" -T "v%vcts%" -D CMAKE_SYSTEM_VERSION=8.1 -D CMAKE_CXX_FLAGS="/D_USING_V110_SDK71_ /MP /EHsc /DWIN32" -D CMAKE_C_FLAGS="/MP /D_USING_V110_SDK71_" -D OCPN_ENABLE_SYSTEM_CMD_SOUND=ON -D CMAKE_EXE_LINKER_FLAGS="%XP_FLAG% " -D CMAKE_MODULE_LINKER_FLAGS="%XP_FLAG% " -D CMAKE_SHARED_MODULE_LINKER_FLAGS="%XP_FLAG% " ..
cmake -Wno-dev "%A_FLAG%" -G"%vcgen%" -T "v%vcts%" -D CMAKE_SYSTEM_VERSION=8.1 -D CMAKE_CXX_FLAGS="/D_USING_V110_SDK71_ /MP /EHsc /DWIN32" -D CMAKE_C_FLAGS="/MP /D_USING_V110_SDK71_" -D OCPN_ENABLE_SYSTEM_CMD_SOUND=ON -D CMAKE_EXE_LINKER_FLAGS="%XP_FLAG% " -D CMAKE_MODULE_LINKER_FLAGS="%XP_FLAG% " -D CMAKE_SHARED_MODULE_LINKER_FLAGS="%XP_FLAG% " ..
if %ERRORLEVEL% GTR 0 goto :Error
set vcts=
set vcgen=
@endlocal
exit /b 0

:noVC
@echo Error: No compatible Visual Studio installed.
@echo VCINSTALLDIR=%VCINSTALLDIR%
@echo VSINSTALLDIR=%VSINSTALLDIR%

:Error
@echo Error: Configuration encountered an error.
@echo Error: Configuration incomplete!
@endlocal
exit /b 1
