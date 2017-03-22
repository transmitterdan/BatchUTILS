@setlocal enableextensions enabledelayedexpansion
rem @echo off
if not "%1"=="release" if not "%1"=="debug" goto usage
:ok
cmake --build . --config %1 --target clean
rmdir /s /q ..\build\%1
:finish
@endlocal
exit /b 0
:usage
@echo Usage: %0  release | debug
@echo Example 1: %0 debug
@echo Above command will clean out the debug tree and prepare
@echo for a build from scratch.
@echo Note that it also removes OpenCPN .ini files so
@echo it will be as if running OpenCPN for the first time
@echo after you clean everything.
@echo It does not clean out any charts but it does remove
@echo the information about the default chart location so
@echo you will have to set that up next time you run the
@echo cleaned version.
endlocal
exit /b /1
