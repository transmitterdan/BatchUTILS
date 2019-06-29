@setlocal enableextensions enabledelayedexpansion
@echo off
rem Build non-debug version of OpenCPN. There is an optional command line to build the install package:
rem build package - will build the install package and put it in the release folder.
rem build package install - will build and run the installer on the local machine
call findvc.bat
set vcdll=vc%vcts%_dll
set wxDLL=wxbase313u_net_vc_custom.dll
SET FILE1="%WXDIR%\lib\%vcdll%\%wxDLL%"
SET FILE2="..\buildwin\wxWidgets\%wxDLL%"

FOR %%i IN (%FILE1%) DO SET DATE1=%%~ti
FOR %%i IN (%FILE2%) DO SET DATE2=%%~ti
@echo %FILE1%:%DATE1% and %FILE2%:%DATE2%
IF "%DATE1%"=="%DATE2%" ECHO Files %FILE1% and %FILE2% have same age && GOTO noCopy
call copyWX.bat

:noCopy
if "%1"=="" goto notarget
rem cmake --build --trace-expand . "-DCMAKE_TOOLCHAIN_FILE=e:/storage/transmitterdan/vcpkg/scripts/buildsystems/vcpkg.cmake" --config Release --target %1
cmake --build . --config Release --target %1
if %ERRORLEVEL% NEQ 0 goto quit
goto install
:notarget
cmake --build . --config Release
if %ERRORLEVEL% NEQ 0 goto quit
call docopyAll Release
goto finish
:install
if not "%2"=="install" goto moveit
@echo Starting install
timeout /t 5
for %%I in (opencpn*.exe) do %%~nI
:moveit
if not "%1"=="package" goto finish
if exist "%USERPROFILE%\Google Drive\NUL" move opencpn*.exe "%USERPROFILE%\Google Drive\"
:finish
@echo Be sure you set Visual Studio Debug options to use the -p option
@echo Use menu option Debug->opencpn Properties...->Configuration Properties->Debugging->Command Arguments and type in -p
date /t
time /t
exit /b 0
:quit
@echo Build failed!
@echo Maybe you should use "package" as the target instead of "%1".
exit /b 1
