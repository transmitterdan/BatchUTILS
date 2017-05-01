@setlocal enableextensions enabledelayedexpansion
@echo off
@echo Cleaing %OpenCPNDIR%\buildwin\wxWidgets 
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

@echo Copying wxWidgets libraries from %WXDIR%\lib\vc_dll
mkdir %OpenCPNDIR%\buildwin\wxWidgets
copy /V "%WXDIR%\lib\vc_dll\*u_*.dll" %OpenCPNDIR%\buildwin\wxWidgets
del /Q %OpenCPNDIR%\build\Release\*u_*.dll
if  not exist %OpenCPNDIR%\build\Release\lib\NUL mkdir %OpenCPNDIR%\build\Release\lib
del /Q %OpenCPNDIR%\build\Debug\lib\*u_*.lib
if  not exist %OpenCPNDIR%\build\Release\NUL mkdir %OpenCPNDIR%\build\Release
copy /V "%WXDIR%\lib\vc_dll\*u_*.dll" %OpenCPNDIR%\build\Release
rem copy /V "%WXDIR%\lib\vc_dll\*u_*.lib" %OpenCPNDIR%\build\Release\lib

del /Q %OpenCPNDIR%\build\Debug\*ud_*dll
if  not exist %OpenCPNDIR%\build\Debug\lib\NUL mkdir %OpenCPNDIR%\build\Debug\lib
del /Q %OpenCPNDIR%\build\Debug\lib\*ud_*.lib
if  not exist %OpenCPNDIR%\build\Debug\NUL mkdir %OpenCPNDIR%\build\Debug
copy /V "%WXDIR%\lib\vc_dll\*ud_*.dll" %OpenCPNDIR%\build\Debug
rem copy /V "%WXDIR%\lib\vc_dll\*ud_*.lib" %OpenCPNDIR%\build\Debug\lib

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
