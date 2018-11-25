@echo off
if "%1"=="" goto notarget
cmake --build . --config debug --target %1
if %ERRORLEVEL% NEQ 0 goto quit
rem cmake --build . --config debug --target %1
@echo Debug build %1 using cmake finished. ERRORLEVEL = %ERRORLEVEL%
goto finished
:notarget
cmake --build . --config debug
if %ERRORLEVEL% NEQ 0 goto quit
@echo Build using cmake finished. ERRORLEVEL = %ERRORLEVEL%
call docopyAll Debug
:finished
date /t
time /t
exit /b 0
:quit
@echo Debug build failed!
exit /b 1
