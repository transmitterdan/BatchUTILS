@setlocal enableextensions enabledelayedexpansion
@echo off
@echo Cleaing ..\buildwin\wxWidgets 
del ..\buildwin\wxWidgets\*.dll
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%

@echo Copying %WXDIR%\lib\vc_dll->..\buildwin\wxWidgets
xcopy /Y /H /E /K /I %WXDIR%\lib\vc_dll\*u_*.dll ..\buildwin\wxWidgets

if not exist CMakeCache.txt goto config
del CMakeCache.txt
:config
cmake -Wno-dev -G "Visual Studio 14 2015" -T v140_xp ..
