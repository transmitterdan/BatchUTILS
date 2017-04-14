@setlocal enableextensions enabledelayedexpansion
@echo off
if "%1"=="" goto usage
if exist %1 goto build
mkdir %1
if %ERRORLEVEL% GTR 0 goto usage
cd %1
if %ERRORLEVEL% GTR 0 goto usage
cd ..
if %ERRORLEVEL% GTR 0 goto usage
rmdir /s %1
if %ERRORLEVEL% GTR 0 goto usage
git clone git://github.com/transmitterdan/wxWidgets.git
git remote add upstream https://github.com/wxWidgets/wxWidgets.git
git checkout master
git push --set-upstream origin master
git checkout OpenCPN
git push --set-upstream origin OpenCPN
cd wxWidgets
set WXDIR="%CD%"
:build
set clean=""
if "%2"=="" (set str1="default") else (set str1="%2%")
if "%3"=="" (set str2="OpenCPN") else (set str2="%3%")
REM This next line will evaluate TRUE if str1 contains substring('clean')
if not x%str1:clean=%==x%str1% set clean="clean"
set str0=%CD%
@echo Leaving %str0%
pushd %1
set str1=%CD%
@echo Entering %str1%
cd .\build\msw
rem git checkout master
rem git pull upstream master
rem git push
rem @echo Checkout out branch %str2%
rem git checkout %str2%
rem git pull upstream master
rem if not %str2%=="OpenCPN" goto donotpush
rem @echo Pushing branch %str2%
rem git push
:donotpush
REM This next line will evaluate TRUE if working directory name contains substring('2.8')
if not x%str1:2.8=%==x%str1% goto buildV2
nmake -f makefile.vc %clean% BUILD=release SHARED=1 CFLAGS=/D_USING_V120_SDK71_ CXXFLAGS=/D_USING_V120_SDK71_
if %ERRORLEVEL% GTR 0 goto quit
nmake -f makefile.vc %clean% BUILD=debug SHARED=1 CFLAGS=/D_USING_V120_SDK71_ CXXFLAGS=/D_USING_V120_SDK71_
if %ERRORLEVEL% GTR 0 goto quit
goto end
:buildV2
@echo Building old wxWidgets-2
nmake -f makefile.vc %clean% BUILD=release SHARED=1 CFLAGS=/D_USING_V120_SDK71_ CXXFLAGS="/D_USING_V120_SDK71_ /DNEED_PBT_H"
if %ERRORLEVEL% GTR 0 goto quit
nmake -f makefile.vc %clean% BUILD=debug SHARED=1 CFLAGS=/D_USING_V120_SDK71_ CXXFLAGS="/D_USING_V120_SDK71_ /DNEED_PBT_H"
if %ERRORLEVEL% GTR 0 goto quit
:end
@echo *********************************************************************************************************
@echo Don't forget to run config.bat in OpenCPN\build if you want to use the newly built versions of the DLLs *
@echo *********************************************************************************************************
@echo Returning to %str0%
popd
endlocal
exit /b /0
:quit
@echo *********************************************************************************************************
@echo Something went wrong!!!
@echo *********************************************************************************************************
@echo Returning to %str0%
popd
endlocal
exit /b /1
:usage
@echo Usage: %0 WXdir [clean]
@echo Example 1: %0 %WXDIR%
@echo Above command will do a "git pull" and build default wx libraries
@echo Example: %0 c:\wxWidgets-2.8.12 clean
@echo Above command will clean the old wx libraries 
@echo and prepare for a build from scratch
endlocal
exit /b /1
