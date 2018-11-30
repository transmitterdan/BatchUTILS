@echo off
@echo Trying to find Visual Studio version

set __ts__=
set __gen__=

if "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio 12.0\" call :VS2013
if "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\" call :VS2015
if "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\" call :VS2017
if "%VCINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio\Preview\Community\VC\" call :VS2017

if "__gen__"=="" goto noVC

set vcgen=%__gen__%
set vcts=%__ts__%
set __ts__=
set __gen__=
@echo "vcgen=%vcgen%"
@echo "vcts=%vcts%"
exit /b 0

:noVC
@echo Error: No compatible Visual Studio installed.
@echo VCINSTALLDIR=%VCINSTALLDIR%
exit /b 1

:VS2013
echo Configuring for VS2013
set "__gen__=Visual Studio 12 2013"
set "__ts__=120_xp"
exit /b 0

:VS2015
echo Configuring for VS2015
set "__gen__=Visual Studio 14 2015"
set "__ts__=140_xp"
exit /b 0

:VS2017
echo Configuring for VS2017
set "__gen__=Visual Studio 15 2017"
set "__ts__=141_xp"
exit /b 0
