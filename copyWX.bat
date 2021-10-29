@setlocal enableextensions enabledelayedexpansion
@echo off
@echo Copying WX DLLs...
rem ******************************************
rem * This script will configure using Cmake *
rem * to build OpenCPN. Run this in the      *
rem * OpenCPN\build folder.                  *
rem ******************************************
if not "%WXDIR%"=="" goto foundWx
@echo You have to set environment variable WXDIR first.
exit /b 1
rem call findvc.bat

:foundWx
echo "Options->" "%1" "%2" "%3" "%4"
set vcdll=vc%vcts%_dll
@echo "vcdll = %vcdll%"
set targetDir=..\buildwin\wxWidgets
rem @echo Cleaning %targetDir% 
if not exist "%targetDir%" mkdir %targetDir%
rem @echo Deleting old wxWidgets libraries
rem rmdir /S /Q %targetDir%
rem mkdir %targetDir%
rem :skip
@echo Copying wxWidgets libraries from %WXDIR%\lib\%vcdll% to %targetDir%
call :updateWX %1
call :updateWXdeb %1

set targetDir=.\Release
@echo Copying wxWidgets libraries from %WXDIR%\lib\%vcdll% to %targetDir%
call :updateWX %1

set targetDir=.\Debug
@echo Copying wxWidgets libraries from %WXDIR%\lib\%vcdll% to %targetDir%
call :updateWXdeb %1

set targetDir=.\RelWithDebInfo
@echo Copying wxWidgets libraries from %WXDIR%\lib\%vcdll% to %targetDir%
call :updateWX %1

exit /b 0

rem copy /V "%WXDIR%\lib\%vcdll%\wx*u_*.dll" ..\buildwin\wxWidgets
rem if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
rem copy /V "%WXDIR%\lib\%vcdll%\wx*ud_*.dll" ..\buildwin\wxWidgets
rem if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
del /Q .\Release\wx*u_*.dll
del /Q .\Debug\wx*ud_*.dll
del /Q .\RelWithDebInfo\wx*u_*.dll
copy /V "%WXDIR%\lib\%vcdll%\wx*u_*.dll" .\Release
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
copy /V "%WXDIR%\lib\%vcdll%\wx*u_*.pdb" .\Release
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
copy /V "%WXDIR%\lib\%vcdll%\wx*ud_*.dll" .\Debug
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
copy /V "%WXDIR%\lib\%vcdll%\wx*ud_*.pdb" .\Debug
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
copy /V "%WXDIR%\lib\%vcdll%\wx*u_*.dll" .\RelWithDebInfo
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
copy /V "%WXDIR%\lib\%vcdll%\wx*u_*.pdb" .\RelWithDebInfo
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
exit /b 0
:quit
exit /b 1

:updateWX
del /Q %targetDir%\wx*u_*.dll
for /f "tokens=*" %%p in ('dir "%WXDIR%\lib\%vcdll%\*u_*.dll" /b /s') do (
    if not "%1"=="/Q" cmake -E echo copy_if_different  "%%p" "%targetDir%\%%~np%%~xp"
    cmake -E copy_if_different "%%p" "%targetDir%\%%~np%%~xp"
)
del /Q %targetDir%\wx*u_*.pdb
for /f "tokens=*" %%p in ('dir "%WXDIR%\lib\%vcdll%\*u_*.pdb" /b /s') do (
    if not "%1"=="/Q" cmake -E echo copy_if_different "%%p" "%targetDir%\%%~np%%~xp"
    cmake -E copy_if_different "%%p" "%targetDir%\%%~np%%~xp"
)
exit /b 0

:updateWXdeb
del /Q %targetDir%\wx*ud_*.dll
for /f "tokens=*" %%p in ('dir "%WXDIR%\lib\%vcdll%\wx*ud_*.dll" /b /s') do (
    if not "%1"=="/Q" cmake -E echo copy_if_different  "%%p" "%targetDir%\%%~np%%~xp"
    cmake -E copy_if_different "%%p" "%targetDir%\%%~np%%~xp"
)
del /Q %targetDir%\wx*ud_*.pdb
for /f "tokens=*" %%p in ('dir "%WXDIR%\lib\%vcdll%\wx*ud_*.pdb" /b /s') do (
    if not "%1"=="/Q" cmake -E echo copy_if_different "%%p" "%targetDir%\%%~np%%~xp"
    cmake -E copy_if_different "%%p" "%targetDir%\%%~np%%~xp"
)
exit /b 0
