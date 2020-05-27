@echo off
rem Build debug version of OpenCPN then copy all needed support files to debug folder.
call findvc.bat
if %ERRORLEVEL% NEQ 0 goto :quit
cd "%OpenCPNDIR%\build"
set vcdll=vc%vcts%_dll
set wxDLL=wxbase*ud_
rem Find wxbase dll file name
for /f "tokens=*" %%a in ('dir "%WXDIR%\lib\%vcdll%\%wxDLL%*.dll" /b /s') do set p1=%%a
if defined p1 (
echo %p1%
) else (
echo File1 not found
)

SET FILE1="%p1%"

for /f "tokens=*" %%a in ('dir "..\buildwin\wxWidgets\%wxDLL%*.dll" /b /s') do set p2=%%a
if defined p2 (
echo %p2%
) else (
echo File2 not found
)
SET FILE2="%p2%"

FOR %%i IN (%FILE1%) DO SET DATE1=%%~ti
FOR %%i IN (%FILE2%) DO SET DATE2=%%~ti
@echo %FILE1%:%DATE1% and %FILE2%:%DATE2%
IF "%DATE1%"=="%DATE2%" ECHO Files %FILE1% and %FILE2% have same age && GOTO :noCopy
call copyWX.bat
if %ERRORLEVEL% NEQ 0 goto :quitnow

:noCopy
if "%1"=="" goto :noconfig
cmake --build . --config debug --target %1
if %ERRORLEVEL% NEQ 0 goto :quitnow
rem cmake --build . --config debug --target %1
@echo Debug build %1 using cmake finished. ERRORLEVEL = %ERRORLEVEL%
call docopyAll %1
goto :finished
:noconfig
cmake --build . --config debug
if %ERRORLEVEL% NEQ 0 goto :quitnow
@echo Build using cmake finished. ERRORLEVEL = %ERRORLEVEL%
call docopyAll debug
:finished
@echo Be sure you set Visual Studio Debug options to use the -p option
@echo Use menu option Debug->opencpn Properties...->Configuration Properties->Debugging->Command Arguments and type in -p
date /t
time /t
exit /b 0
:quitnow
@echo Debug build failed!
exit /b 1
