@setlocal enableextensions enabledelayedexpansion
@echo off
@echo Building/copying WX DLLs...
rem ******************************************
rem * This script will configure using Cmake *
rem * to build wxWidgets. Run this in the    *
rem * OpenCPN\build folder.                  *
rem ******************************************
if not "%WXDIR%"=="" goto :foundWx
@echo You have to set environment variable WXDIR first.
exit /b 1

:foundWx
call :StartTimer
call findvc.bat
set vcdll=vc%vcts%_dll

cmake -E chdir %WXDIR% cmake -E make_directory %WXDIR%\cmake
if NOT %ERRORLEVEL%==0 goto :oops

curl -L -o %WXDIR%/cmake/webview2.zip https://www.nuget.org/api/v2/package/Microsoft.Web.WebView2
7z x %WXDIR%\cmake\webview2.zip -o%WXDIR%\3rdparty\webview2 -aoa
7z x %WXDIR%\cmake\webview2.zip -o%WXDIR%\cmake\3rdparty\webview2 -aoa

cmake -E chdir %WXDIR%\cmake cmake -DwxUSE_WINSOCK2:BOOL="0" -DwxBUILD_SAMPLES:STRING="OFF" -DwxBUILD_TESTS:STRING="CONSOLE_ONLY" -G "Visual Studio 16 2019" -T "v%vcts%" -A Win32 %WXDIR%
if NOT %ERRORLEVEL%==0 goto :oops

cmake -E chdir %WXDIR%\cmake cmake --build . --config Debug --parallel 8 -- -maxCpuCount:8
if NOT %ERRORLEVEL%==0 goto :oops

cmake -E chdir %WXDIR%\cmake cmake --build . --config Release --parallel 8 -- -maxCpuCount:8
if NOT %ERRORLEVEL%==0 goto :oops

cd %wxdir%\cmake

set targetDir=%wxdir%\lib\%vcdll%
@echo Copying wxWidgets libraries from %wxdir%\cmake\lib\vc_dll to %targetDir%
mkdir %targetDir%
xcopy /E /Y .\lib\vc_dll\*.* %targetDir%

set targetDir=%OpenCPNDIR%\buildwin\wxWidgets
@echo Copying wxWidgets libraries from %wxdir%\lib\%vcdll% to %targetDir%
call :updateWX %1
call :updateWXdeb %1

set targetDir=%OpenCPNDIR%\build\Release
@echo Copying wxWidgets libraries from %wxdir%\lib\%vcdll% to %targetDir%
call :updateWX %1

set targetDir=%OpenCPNDIR%\build\Debug
@echo Copying wxWidgets libraries from %wxdir%\lib\%vcdll% to %targetDir%
call :updateWXdeb %1

set targetDir=%OpenCPNDIR%\build\RelWithDebInfo
@echo Copying wxWidgets libraries from %wxdir%\lib\%vcdll% to %targetDir%
call :updateWX %1
cd ..
call :StopTimer
call :DisplayTimerResult
exit /b 0

:oops
@echo "Something went wrong."
cd ..
call :StopTimer
call :DisplayTimerResult
exit /b 1

:updateWX
del /Q %targetDir%\wx*u_*.dll
for /f "tokens=*" %%p in ('dir "%wxdir%\lib\%vcdll%\*u_*.dll" /b /s') do (
    if not "%1"=="/Q" cmake -E echo copy_if_different  "%%p" "%targetDir%\%%~np%%~xp"
    cmake -E copy_if_different "%%p" "%targetDir%\%%~np%%~xp"
)
del /Q %targetDir%\wx*u_*.pdb
for /f "tokens=*" %%p in ('dir "%wxdir%\lib\%vcdll%\*u_*.pdb" /b /s') do (
    if not "%1"=="/Q" cmake -E echo copy_if_different "%%p" "%targetDir%\%%~np%%~xp"
    cmake -E copy_if_different "%%p" "%targetDir%\%%~np%%~xp"
)
exit /b 0

:updateWXdeb
del /Q %targetDir%\wx*ud_*.dll
for /f "tokens=*" %%p in ('dir "%wxdir%\lib\%vcdll%\wx*ud_*.dll" /b /s') do (
    if not "%1"=="/Q" cmake -E echo copy_if_different  "%%p" "%targetDir%\%%~np%%~xp"
    cmake -E copy_if_different "%%p" "%targetDir%\%%~np%%~xp"
)
del /Q %targetDir%\wx*ud_*.pdb
for /f "tokens=*" %%p in ('dir "%wxdir%\lib\%vcdll%\wx*ud_*.pdb" /b /s') do (
    if not "%1"=="/Q" cmake -E echo copy_if_different "%%p" "%targetDir%\%%~np%%~xp"
    cmake -E copy_if_different "%%p" "%targetDir%\%%~np%%~xp"
)
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
