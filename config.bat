@setlocal enableextensions enabledelayedexpansion
@echo off
@echo Cleaning %OpenCPNDIR%\buildwin\wxWidgets 
rmdir /S /Q %OpenCPNDIR%\buildwin\wxWidgets
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%

set __ts__=
set __gen__=

if "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio 12.0\" call :VS2013
if "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\" call :VS2015
if "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\" call :VS2017

if __gen__=="" goto noVC

if not exist %OpenCPNDIR%\build\CMakeCache.txt goto config
del %OpenCPNDIR%\build\CMakeCache.txt
:config

if  not exist %OpenCPNDIR%\build\Debug\NUL mkdir %OpenCPNDIR%\build\Debug
if  not exist %OpenCPNDIR%\build\Release\NUL mkdir %OpenCPNDIR%\build\Release

@echo Copying wxWidgets libraries from %WXDIR%\lib\vc_dll
mkdir %OpenCPNDIR%\buildwin\wxWidgets
copy /V "%WXDIR%\lib\vc_dll\*u_*.dll" %OpenCPNDIR%\buildwin\wxWidgets
del /Q %OpenCPNDIR%\build\Release\*u_*.dll
rem if  not exist %OpenCPNDIR%\build\Release\lib\NUL mkdir %OpenCPNDIR%\build\Release\lib
del /Q %OpenCPNDIR%\build\Debug\*ud_*.dll
rem if  not exist %OpenCPNDIR%\build\Release\NUL mkdir %OpenCPNDIR%\build\Release
copy /V "%WXDIR%\lib\vc_dll\*u_*.dll" %OpenCPNDIR%\build\Release
copy /V "%WXDIR%\lib\vc_dll\*ud_*.dll" %OpenCPNDIR%\build\Debug

@echo Updating all plugins to latest
pushd ..\plugins
ren aisradar_pi radar_pi
cd radar_pi
git pull upstream master
git push
cd ..
ren radar_pi aisradar_pi
popd
pushd ..\plugins\ocpn_draw_pi
git pull upstream master
git push
popd

echo configuring generator %__gen__% and toolset %__ts__%
pushd %OpenCPNDIR%\build
cmake -Wno-dev -G "%__gen__%" -T "%__ts__%" ..

set __ts__=
set __gen__=
popd
exit /b 0

:noVC
@echo Error: No compatible Visual Studio installed.
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
