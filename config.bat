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
if  not exist .\RELWITHDEBINFO\NUL mkdir .\RELWITHDEBINFO

if "%1" == "nodl" goto :copyWX
if "%1" == "cmake" goto :copyWX

for /f "tokens=2 delims=[.]" %%x in ('ver') do set WINVER=%%x
@echo WINVER=%WINVER%
if not "%WINVER%"=="Version 10" goto :copyWX
rem powershell -Command "Invoke-WebRequest https://download.opencpn.org/s/54HsBDLNzRZLL6i/download -OutFile nsis-3.04-setup.exe
rem powershell -Command "[System.Net.ServicePointManager]::MaxServicePointIdleTime = 5000000; Invoke-WebRequest https://download.opencpn.org/s/oibxM3kzfzKcSc3/download -OutFile buildwin.7z; exit $LASTEXITCODE"
mkdir %OpenCPNDIR%\buildwintemp
curl -L -o %OpenCPNDIR%\buildwintemp\OCPNWindowsCoreBuildSupport.zip https://github.com/OpenCPN/OCPNWindowsCoreBuildSupport/archive/refs/tags/v0.1.zip
if %ERRORLEVEL%==0 goto :unzipWX
@echo "Error detected downloading Windows build dependencies."
goto :copyWX

:unzipWX
7z x -y %OpenCPNDIR%\buildwintemp\OCPNWindowsCoreBuildSupport.zip -o%OpenCPNDIR%\buildwintemp
XCOPY %OpenCPNDIR%\buildwintemp\OCPNWindowsCoreBuildSupport-0.1\buildwin %OpenCPNDIR%\buildwin /s /y
rmdir /s /q %OpenCPNDIR%\buildwintemp
:copyWX 
if "%1" == "cmake" goto :Cmake

rem call copyWX.bat
rem if %ERRORLEVEL% GTR 0 goto :Error

call docopyAll.bat CLEAN
call docopyAll.bat RELEASE
call docopyAll.bat DEBUG
call doCopyAll.bat RELWITHDEBINFO

:config

@echo Updating all plugins to latest
pushd ..\plugins
if not exist aisradar_pi\NUL goto :vfkaps
ren aisradar_pi radar_pi
pushd radar_pi
git pull upstream master
git push
popd
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

:Cmake
rem if not exist .\CMakeCache.txt goto :Cmake1
rem del .\CMakeCache.txt
@echo Clearing the decks...
rmdir /s /q CMakeFiles fpu_neon include lib libs mavx2 msse msse2 msse3 opencpn.dir plugins Resources S57ENC.dir SYMBOLS.dir Win32
del /q *.*
del /s /q CMakeCache.txt
@echo Decks clear...

:Cmake1
set A_FLAG=
set "var=%vcgen%"
set "search=2019"
CALL set "test=%%var:%search%=%%"
@echo test = "%test%"
if "%test%" NEQ "%var%" (set "A_FLAG=-AWin32")
set "search=2022"
CALL set "test=%%var:%search%=%%"
@echo test = "%test%"
if "%test%" NEQ "%var%" (set "A_FLAG=-AWin32")
@echo A_FLAG="%A_FLAG%"

set "var=%vcts%"
set "search=_xp"
CALL set "test=%%var:%search%=%%"

if "%test%"=="%var%" (set "XP_FLAG="/MAP" " ) else (set "XP_FLAG="/SUBSYSTEM:WINDOWS,5.01" ")
@echo XP_FLAG=%XP_FLAG%
@echo wxWidgets folder=%wxWidgets_LIB_DIR%
@echo configuring generator %vcgen% and toolset v%vcts%
@echo cmake -Wno-dev -DWX_LIB_DIR="%wxWidgets_LIB_DIR%" "%A_FLAG%" -G"%vcgen%" -T "v%vcts%" -D CMAKE_CXX_FLAGS="/MP /EHsc /DWIN32" -D CMAKE_C_FLAGS="/MP" -D OCPN_ENABLE_SYSTEM_CMD_SOUND=ON -D CMAKE_EXE_LINKER_FLAGS="%XP_FLAG% " -D CMAKE_MODULE_LINKER_FLAGS="%XP_FLAG% " -D OCPN_BUILD_TEST=OFF ..
rem cmake -Wno-dev -DWX_LIB_DIR="%wxWidgets_LIB_DIR%" "%A_FLAG%" -G"%vcgen%" -T "v%vcts%" --debug-find-pkg=wxWidgets -D CMAKE_SYSTEM_VERSION=8.1 -D CMAKE_CXX_FLAGS="/MP /EHsc /DWIN32" -D CMAKE_C_FLAGS="/MP" -D OCPN_ENABLE_SYSTEM_CMD_SOUND=ON -D CMAKE_EXE_LINKER_FLAGS="%XP_FLAG% " -D CMAKE_MODULE_LINKER_FLAGS="
rem cmake -Wno-dev -DWX_LIB_DIR="%wxWidgets_LIB_DIR%" "%A_FLAG%" -G"%vcgen%" -T "v%vcts%" -D CMAKE_SYSTEM_VERSION=8.1 -D CMAKE_CXX_FLAGS="/MP /EHsc /DWIN32" -D CMAKE_C_FLAGS="/MP" -D OCPN_ENABLE_SYSTEM_CMD_SOUND=ON -D CMAKE_EXE_LINKER_FLAGS="%XP_FLAG% " -D CMAKE_MODULE_LINKER_FLAGS="%XP_FLAG% " -D OCPN_BUILD_TEST=OFF ..
cmake -Wno-dev -DWX_LIB_DIR="%wxWidgets_LIB_DIR%" "%A_FLAG%" -G"%vcgen%" -T "v%vcts%" -D CMAKE_CXX_FLAGS="/MP /EHsc /DWIN32" -D CMAKE_C_FLAGS="/MP" -D OCPN_ENABLE_SYSTEM_CMD_SOUND=ON -D CMAKE_EXE_LINKER_FLAGS="%XP_FLAG% " -D CMAKE_MODULE_LINKER_FLAGS="%XP_FLAG% " -D OCPN_BUILD_TEST=OFF ..
if %ERRORLEVEL% GTR 0 goto :Error
set vcts=
set vcgen=
@echo Be sure you set Visual Studio startup project to [101;93m opencpn [0m.
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
