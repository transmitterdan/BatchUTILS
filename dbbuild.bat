@echo off
rem Build debug version of OpenCPN then copy all needed support files to debug folder.
call findvc.bat
if %ERRORLEVEL% NEQ 0 goto :quit
cd "%OpenCPNDIR%\build"

:noCopy
if "%1"=="" goto :noconfig
cmake --build . --config debug --target %1
if %ERRORLEVEL% NEQ 0 goto :quitnow
rem cmake --build . --config debug --target %1
@echo Debug build %1 using cmake finished. ERRORLEVEL = %ERRORLEVEL%
call docopyAll %1
goto :finished
:noconfig
cmake --build . --config debug
if %ERRORLEVEL% NEQ 0 goto :quitnow
@echo Build using cmake finished. ERRORLEVEL = %ERRORLEVEL%
call docopyAll debug
:finished
rem @echo [101;93m Red Highlighter [0m
rem @echo ^<ESC^>[4m [4mUnderline[0m
rem @echo ^<ESC^>[7m [7mInverse[0m

@echo Be sure you set Visual Studio Debug options to use the [101;93m -p [0m option and set working directory

@echo "Use menu option Debug->opencpn Properties...->Configuration Properties->Debugging->Command Arguments and type in -p"

@echo Also set the working directory to [101;93m $(ProjectDir)\Debug [0m
date /t
time /t
exit /b 0
:quitnow
@echo Debug build failed!
exit /b 1
