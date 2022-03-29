@setlocal enableextensions enabledelayedexpansion
@echo off
@echo Trying to configure OpenCPN
rem ******************************************
rem * This script will delete local and      *
rem * remote git branches. Specify branch    *
rem * name on command line.                  *
rem ******************************************

if "%2" == "-D" goto :hard

git branch -d "%1"
if %ERRORLEVEL% NEQ 0 goto :errout
git push origin --delete "%1"
if %ERRORLEVEL% NEQ 0 goto :errout
exit /b 0

:hard
git branch -D "%1"
if %ERRORLEVEL% NEQ 0 goto :errout
git push origin --delete "%1"
if %ERRORLEVEL% NEQ 0 goto :errout
exit /b 0

:errout
@echo Something bad happened...
exit /b 1
