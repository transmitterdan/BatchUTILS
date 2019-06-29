@echo off
rem Build debug version of OpenCPN then copy all needed support files to debug folder.
call findvc.bat
set vcdll=vc%vcts%_dll
set wxDLL=wxbase313u_net_vc_custom.dll
SET FILE1="%WXDIR%\lib\%vcdll%\%wxDLL%"
SET FILE2="..\buildwin\wxWidgets\%wxDLL%"

FOR %%i IN (%FILE1%) DO SET DATE1=%%~ti
FOR %%i IN (%FILE2%) DO SET DATE2=%%~ti
rem @echo %FILE1%:%DATE1% and %FILE2%:%DATE2%
IF "%DATE1%"=="%DATE2%" ECHO Files %FILE1% and %FILE2% have same age && GOTO noCopy
call copyWX.bat

:noCopy
if "%1"=="" goto :noconfig
cmake --build . --config debug --target %1
if %ERRORLEVEL% NEQ 0 goto :quit
rem cmake --build . --config debug --target %1
@echo Debug build %1 using cmake finished. ERRORLEVEL = %ERRORLEVEL%
call docopyAll %1
goto :finished
:noconfig
cmake --build . --config debug
if %ERRORLEVEL% NEQ 0 goto :quit
@echo Build using cmake finished. ERRORLEVEL = %ERRORLEVEL%
call docopyAll debug
:finished
@echo Be sure you set Visual Studio Debug options to use the -p option
@echo Use menu option Debug->opencpn Properties...->Configuration Properties->Debugging->Command Arguments and type in -p
date /t
time /t
exit /b 0
:quit
@echo Debug build failed!
exit /b 1
