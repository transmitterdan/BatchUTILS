@setlocal enableextensions enabledelayedexpansion
@ECHO ON
time /t

call findvc.bat

set compvers=vc%vcts%
set comp=%vcts%

@echo compvers=%compvers%
@echo comp=%comp%

if "%1"=="nodel" goto :nodel

rmdir %compvers%_mswuddll /s /q
rmdir %compvers%_mswudll /s /q

@echo deleting folder "..\..\lib\%compvers%_dll"
rmdir ..\..\lib\%compvers%_dll /s /q
@echo Delete the build output files from the last run.

:nodel

set "var=%compvers%"
set "search=160"
CALL set "test=%%var:%search%=%%"
if "%test%"=="%var%" (set "XP_FLAG=,5.01") else set "XP_FLAG="

@echo Copying setup0.h=>setup.h
copy /y ..\..\include\wx\msw\setup0.h ..\..\include\wx\msw\setup.h
@if exist %compvers%x86_Release.txt del %compvers%x86_Release.txt
@if exist %compvers%x86_Debug.txt del %compvers%x86_Debug.txt
@echo start /B nmake /f makefile.vc BUILD=release SHARED=1 COMPILER_VERSION=%comp% CXXFLAGS=/MP CXXFLAGS=/D_USING_V110_SDK71_ CFLAGS=/MP CFLAGS=/D_USING_V110_SDK71_ LDFLAGS=/SUBSYSTEM:WINDOWS%XP_FLAG% >> %compvers%x86_Release.txt
start /B nmake /f makefile.vc BUILD=release SHARED=1 COMPILER_VERSION=%comp% CXXFLAGS=/MP CXXFLAGS=/D_USING_V110_SDK71_ CFLAGS=/MP CFLAGS=/D_USING_V110_SDK71_ LDFLAGS=/SUBSYSTEM:WINDOWS%XP_FLAG% >> %compvers%x86_Release.txt
if %ERRORLEVEL% NEQ 0 goto :quit
@REM Wait 1 second before starting release build in parallel with debug build
ping -n 2 localhost >NUL
@echo nmake /f makefile.vc BUILD=debug SHARED=1 COMPILER_VERSION=%comp% CXXFLAGS=/MP CXXFLAGS=/D_USING_V110_SDK71_ CFLAGS=/MP CFLAGS=/D_USING_V110_SDK71_ LDFLAGS=/SUBSYSTEM:WINDOWS%XP_FLAG% >> %compvers%x86_Debug.txt
nmake /f makefile.vc BUILD=debug SHARED=1 COMPILER_VERSION=%comp% CXXFLAGS=/MP CXXFLAGS=/D_USING_V110_SDK71_ CFLAGS=/MP CFLAGS=/D_USING_V110_SDK71_ LDFLAGS=/SUBSYSTEM:WINDOWS%XP_FLAG% >> %compvers%x86_Debug.txt
if %ERRORLEVEL% NEQ 0 goto :quit
time /t
goto :finished

:quit
@echo Something bad happened...
:finished
