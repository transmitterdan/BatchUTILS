@setlocal enableextensions enabledelayedexpansion
@echo off
@echo Trying to configure...
rem ******************************************
rem * This script will configure using Cmake *
rem * to build OpenCPN. Run this in the      *
rem * OpenCPN\build folder.                  *
rem ******************************************
if not "%WXDIR%"=="" goto foundWx
@echo You have to set environment variable WIXDIR first.
exit /b 1

:foundWx

@echo Cleaning ..\buildwin\wxWidgets 
if exist ..\buildwin\wxWidgets\NUL rmdir /S /Q ..\buildwin\wxWidgets
@echo Copying wxWidgets libraries from %WXDIR%\lib\vc_dll
mkdir ..\buildwin\wxWidgets
copy /V "%WXDIR%\lib\vc_dll\*u_*.dll" ..\buildwin\wxWidgets
del /Q .\Release\*u_*.dll
del /Q .\Debug\*ud_*.dll
copy /V "%WXDIR%\lib\vc_dll\*u_*.dll" .\Release
copy /V "%WXDIR%\lib\vc_dll\*ud_*.dll" .\Debug
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
