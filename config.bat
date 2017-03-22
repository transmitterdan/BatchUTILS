xcopy /Y /Q /H /E /K /I %WXDIR%\lib\vc_dll\*u_*.dll ..\buildwin\wxWidgets

del CMakeCache.txt
cmake -Wno-dev -G "Visual Studio 14 2015" -T v140_xp ..
