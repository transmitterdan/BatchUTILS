@setlocal enableextensions enabledelayedexpansion
@echo off
@echo Copying WX DLLs...
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
@echo Copying wxWidgets libraries from %WXDIR%\lib\vc141_xp_dll
mkdir ..\buildwin\wxWidgets
copy /V "%WXDIR%\lib\vc141_xp_dll\wx*u_*.dll" ..\buildwin\wxWidgets
del /Q .\Release\wx*u_*.dll
del /Q .\Debug\wx*ud_*.dll
copy /V "%WXDIR%\lib\vc141_xp_dll\wx*u_*.dll" .\Release
copy /V "%WXDIR%\lib\vc141_xp_dll\wx*ud_*.dll" .\Debug
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
