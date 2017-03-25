@echo off
@echo Copying %WXDIR%\lib\vc_dlls
xcopy /Y /H /E /K /I %WXDIR%\lib\vc_dll\*u_*.dll ..\buildwin\wxWidgets

if not exist CMakeCache.txt goto config
del CMakeCache.txt
:config
cmake -Wno-dev -G "Visual Studio 14 2015" -T v140_xp ..
