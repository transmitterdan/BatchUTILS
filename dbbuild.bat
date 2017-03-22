@echo off
cmake --build . --config debug
if %ERRORLEVEL% GTR 0 goto quit
call docopyAll Debug
date /t
time /t
exit /b 0
:quit
@echo Debug build failed!
exit /b 1
