@setlocal enableextensions enabledelayedexpansion
@echo off
call :copyLibs
if %ERRORLEVEL% GTR 0 goto quit
if "%1"=="" goto notarget
cmake --build . --config release --target %1
if %ERRORLEVEL% GTR 0 goto quit
goto install
:notarget
cmake --build . --config release
if %ERRORLEVEL% GTR 0 goto quit
goto finish
:install
if not "%2"=="install" goto moveit
@echo Starting install
timeout /t 5
for %%I in (ocpn_draw*.exe) do %%~nI
:moveit
if not "%1"=="package" goto finish
move ocpn_draw*.exe "%USERPROFILE%\Google Drive\"
:finish
date /t
time /t
exit /b 0
:quit
@echo Build failed!
@echo Maybe you should use "package" as the target instead of "%1".
exit /b 1

:copyLibs
copy "%OpenCPNDIR%\build\Release\opencpn.lib" .
copy "%OpenCPNDIR%\build\Release\wxsvg.lib" .
exit /b 0