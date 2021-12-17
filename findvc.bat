@echo off
@echo Trying to find Visual Studio version
echo Searching in "%VSINSTALLDIR%"
set __ts__=
set __gen__=

if /I "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio 12.0\" call :VS2013
if /I "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\" call :VS2015
if /I "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\" call :VS2017
if /I "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\" call :VS2017
if /I "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\" call :VS2019
if /I "%VSINSTALLDIR%" == "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Preview\" call :VS2019
if /I "%VSINSTALLDIR%" == "%ProgramFiles%\Microsoft Visual Studio\2022\Preview\" call :VS2022PV
if /I "%VSINSTALLDIR%" == "%ProgramFiles%\Microsoft Visual Studio\2022\Community\" call :VS2022
echo "__get__ = %__get__%"
if "%__gen__%" == "" call :noVC

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

:VS2019
echo Configuring for VS2019
set "__gen__=Visual Studio 16 2019"
set "__ts__=142"
exit /b 0

:VS2022PV
echo Configuring for VS2022 Preview
set "__gen__=Visual Studio 17 2022"
set "__ts__=143"
exit /b 0

:VS2022
echo Configuring for VS2022 Preview
set "__gen__=Visual Studio 17 2022"
set "__ts__=143"
exit /b 0
