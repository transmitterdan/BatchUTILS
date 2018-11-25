@setlocal enableextensions enabledelayedexpansion
@echo off
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
date /t
time /t
exit /b 0
:quit
@echo Build failed!
@echo Maybe you should use "package" as the target instead of "%1".
exit /b 1
