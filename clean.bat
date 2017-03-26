@setlocal enableextensions enabledelayedexpansion
rem @echo off
if not "%1"=="release" if not "%1"=="debug" goto usage
:ok
cmake --build . --config %1 --target clean
:finish
@endlocal
exit /b 0
:usage
@echo Usage: %0  release | debug
@echo Example 1: %0 debug
@echo Above command will clean out the release or 
@echo debug tree and prepare for a build from scratch.
@echo Note that it also removes OpenCPN.ini so
@echo it will be as if running the first time if
@echo you run portable (i.e. OpenCPN -p).
@echo It does not clean out any charts but it does remove
@echo the information about the default chart location so
@echo you will have to set that up next time you run 
@echo in portable mode.
endlocal
exit /b /1
