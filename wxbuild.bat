@setlocal enableextensions enabledelayedexpansion
@ECHO OFF
call :StartTimer

call findvc.bat
if %ERRORLEVEL% NEQ 0 goto :errout
@echo "findvc.bat finished..."
set compvers=vc%vcts%
set comp=%vcts%

@echo compvers=%compvers%
@echo comp=%comp%

if "%1"=="nodel" goto :nodel

rmdir %compvers%_mswuddll /s /q
rmdir %compvers%_mswudll /s /q

@echo deleting folder "..\..\lib\%compvers%_dll"
rmdir ..\..\lib\%compvers%_dll /s /q
if %ERRORLEVEL% NEQ 0 goto :errout
dir /s ..\..\lib\%compvers%_dll
if %ERRORLEVEL%==0 goto :errout
@echo Deleted the build output files from the last run.
rem goto :errout

:nodel

set "var=%compvers%"
set "search=xp"

CALL set "test=%%var:%search%=%%"
@echo testResult=%test%

if "%test%"=="%var%" (set "XP_FLAG=") else (set "XP_FLAG="/SUBSYSTEM:WINDOWS,5.01"")
@echo XP_FLAG=%XP_FLAG%

@echo "Copying setup0.h=>setup.h"
copy /y ..\..\include\wx\msw\setup0.h ..\..\include\wx\msw\setup.h
ver > nul

@if exist %compvers%x86_Release.txt del %compvers%x86_Release.txt
if %ERRORLEVEL% NEQ 0 goto :errout

@if exist %compvers%x86_Debug.txt del %compvers%x86_Debug.txt
if %ERRORLEVEL% NEQ 0 goto :errout

curl -L -o ../../3rdparty/webview2.zip https://www.nuget.org/api/v2/package/Microsoft.Web.WebView2
7z x ..\..\3rdparty\webview2.zip -o..\..\3rdparty\webview2 -aoa

rem @echo nmake /f makefile.vc BUILD=debug SHARED=1 COMPILER_VERSION=%comp% CXXFLAGS=/MP CXXFLAGS=/D_USING_V110_SDK71_ CFLAGS=/MP CFLAGS=/D_USING_V110_SDK71_ LDFLAGS=%XP_FLAG% >> %compvers%x86_Debug.txt
rem start /B nmake /f makefile.vc BUILD=debug SHARED=1 COMPILER_VERSION=%comp% CXXFLAGS=/MP CXXFLAGS=/D_USING_V110_SDK71_ CFLAGS=/MP CFLAGS=/D_USING_V110_SDK71_ LDFLAGS=%XP_FLAG% >> %compvers%x86_Debug.txt
@echo nmake /f makefile.vc BUILD=debug SHARED=1 UNICODE=1 USE_WEBVIEW=1 COMPILER_VERSION=%comp% CFLAGS=/DWXBUILDING CXXFLAGS=/DWXBUILDING LDFLAGS=%XP_FLAG% >> %compvers%x86_Debug.txt
start /B nmake /f makefile.vc BUILD=debug SHARED=1 UNICODE=1 USE_WEBVIEW=1 COMPILER_VERSION=%comp% CFLAGS=/DWXBUILDING CXXFLAGS=/DWXBUILDING LDFLAGS=%XP_FLAG% >> %compvers%x86_Debug.txt
if %ERRORLEVEL% NEQ 0 goto :errout

@REM Wait 1 second before starting release build in parallel with debug build
ping -n 2 localhost >NUL
rem @echo nmake /f makefile.vc BUILD=release DEBUG_INFO=1 SHARED=1 COMPILER_VERSION=%comp% CXXFLAGS=/MP CXXFLAGS=/D_USING_V110_SDK71_ CFLAGS=/MP CFLAGS=/D_USING_V110_SDK71_ LDFLAGS=%XP_FLAG% >> %compvers%x86_Release.txt
rem nmake /f makefile.vc BUILD=release DEBUG_INFO=1 SHARED=1 COMPILER_VERSION=%comp% CXXFLAGS=/MP CXXFLAGS=/D_USING_V110_SDK71_ CFLAGS=/MP CFLAGS=/D_USING_V110_SDK71_ LDFLAGS=%XP_FLAG% >> %compvers%x86_Release.txt
@echo nmake /f makefile.vc BUILD=release DEBUG_INFO=1 SHARED=1 UNICODE=1 USE_WEBVIEW=1  COMPILER_VERSION=%comp% CFLAGS=/DWXBUILDING CXXFLAGS=/DWXBUILDING LDFLAGS=%XP_FLAG% >> %compvers%x86_Release.txt
nmake /f makefile.vc BUILD=release DEBUG_INFO=1 SHARED=1 UNICODE=1 USE_WEBVIEW=1 COMPILER_VERSION=%comp% CFLAGS=/DWXBUILDING CXXFLAGS=/DWXBUILDING LDFLAGS=%XP_FLAG% >> %compvers%x86_Release.txt
if %ERRORLEVEL% NEQ 0 goto :errout
goto :finished_build

:errout
@echo Something bad happened...
call :StopTimer
call :DisplayTimerResult
exit /b 1
:finished_build
call :StopTimer
call :DisplayTimerResult
exit /b 0

:StartTimer
:: Store start time
set StartTIME=%TIME%
for /f "usebackq tokens=1-4 delims=:., " %%f in (`echo %StartTIME: =0%`) do set /a Start100S=1%%f*360000+1%%g*6000+1%%h*100+1%%i-36610100
goto :EOF

:StopTimer
:: Get the end time
set StopTIME=%TIME%
for /f "usebackq tokens=1-4 delims=:., " %%f in (`echo %StopTIME: =0%`) do set /a Stop100S=1%%f*360000+1%%g*6000+1%%h*100+1%%i-36610100
:: Test midnight rollover. If so, add 1 day=8640000 1/100ths secs
if %Stop100S% LSS %Start100S% set /a Stop100S+=8640000
set /a TookTime=%Stop100S%-%Start100S%
set TookTimePadded=0%TookTime%
goto :EOF

:DisplayTimerResult
:: Show timer start/stop/delta
echo Started: %StartTime%
echo Stopped: %StopTime%
echo Elapsed: %TookTime:~0,-2%.%TookTimePadded:~-2% seconds
goto :EOF
