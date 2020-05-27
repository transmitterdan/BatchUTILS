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

call findvc.bat

:foundWx
set vcdll=vc%vcts%_dll
@echo "vcdll = %vcdll%"
@echo Cleaning ..\buildwin\wxWidgets 
if not exist ..\buildwin\wxWidgets\NUL goto :skip
@echo Deleting old wxWidgets libraries
rmdir /S /Q ..\buildwin\wxWidgets
mkdir ..\buildwin\wxWidgets
:skip
@echo Copying wxWidgets libraries from %WXDIR%\lib\%vcdll%
copy /V "%WXDIR%\lib\%vcdll%\wx*u_*.dll" ..\buildwin\wxWidgets
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
copy /V "%WXDIR%\lib\%vcdll%\wx*ud_*.dll" ..\buildwin\wxWidgets
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
del /Q .\Release\wx*u_*.dll
del /Q .\Debug\wx*ud_*.dll
copy /V "%WXDIR%\lib\%vcdll%\wx*u_*.dll" .\Release
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
copy /V "%WXDIR%\lib\%vcdll%\wx*u_*.pdb" .\Release
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
copy /V "%WXDIR%\lib\%vcdll%\wx*ud_*.dll" .\Debug
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
copy /V "%WXDIR%\lib\%vcdll%\wx*ud_*.pdb" .\Debug
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
exit /b 0
:quit
exit /b 1
