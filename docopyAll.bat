@setlocal enableextensions enabledelayedexpansion
@echo off
@echo "Setting up dependent files."
rem *********************************************************************************
rem This batch file copies dependency files into the proper folder based on         *
rem a single argument. If the argument is "Debug" (without ") then it will          *
rem copy dependent files into the build\debug tree so OpenCPN will run in debug     *
rem mode.                                                                           *
rem If the argument is "Release" (without ") then it will copy dependent files      *
rem into the build\Release folder under the build folder.                           *
rem *********************************************************************************
if "%1"=="" goto usage
if not exist %OpenCPNDIR%\build\%1 goto usage
if not "%1" == "Debug" if not "%1" == "debug" goto normal
if not "%1" == "Release" if not "%1" == "release" goto debug
:debug
if not "%1" == "Debug" if not "%1" == "debug" goto usage
set rdir1=%OpenCPNDIR%\build\%1
set pld1=%OpenCPNDIR%\build\%1\plugins
goto go
:normal
if not "%1" == "Release" if not "%1" == "release" goto usage
set rdir1=%OpenCPNDIR%\build\%1
set pld1=%OpenCPNDIR%\build\%1\plugins
:go
if "%2" == "PluginsOnly" goto copy_plugins

@echo Copying DLLs...
del /f %rdir1%\*.dll
copy /Y /V %OpenCPNDIR%\buildwin\gtk\*.dll %rdir1%
copy /Y /V %OpenCPNDIR%\buildwin\expat-2.1.0\*.dll %rdir1%
copy /Y /V %OpenCPNDIR%\buildwin\*.dll %rdir1%
if exist %OpenCPNDIR%\buildwin\vc copy /Y /V %OpenCPNDIR%\buildwin\vc\*.dll %rdir1%
@echo Copying wxWidgets DLL files...
if not "%1" == "release" if not "%1" == "Release" xcopy /Y /Q /H /E /K /I %WXDIR%\lib\vc_dll\*ud_*.dll %rdir1%
if not "%1" == "debug" if not "%1" == "Debug" xcopy /Y /Q /H /E /K /I %WXDIR%\lib\vc_dll\*u_*.dll %rdir1%
@rem @echo Copying wxWidgets locale files
@rem if not exist %rdir1%\locale mkdir %rdir1%\locale
@rem xcopy /Y /V /H /E /K /I %WXDIR%\locale %rdir1%\locale


@echo "Copying data files"
if not exist %rdir1%\doc mkdir %rdir1%\doc
if not exist %rdir1%\gshhs mkdir %rdir1%\gshhs
if not exist %rdir1%\plugins mkdir %rdir1%\plugins
if not exist %rdir1%\s57data mkdir %rdir1%\s57data
if not exist %rdir1%\share mkdir %rdir1%\share
if not exist %rdir1%\sounds mkdir %rdir1%\sounds
if not exist %rdir1%\tcdata mkdir %rdir1%\tcdata
if not exist %rdir1%\uidata mkdir %rdir1%\uidata
if not exist %rdir1%\uidata\traditional mkdir %rdir1%\uidata\traditional
if not exist %rdir1%\uidata\journeyman mkdir %rdir1%\uidata\journeyman
if not exist %rdir1%\uidata\journeyman_flat mkdir %rdir1%\uidata\journeyman_flat

if not exist %rdir1%\wvsdata mkdir %rdir1%\wvsdata

:copy_uidata
@echo Copying icons and syles
copy /Y /V %OpenCPNDIR%\src\bitmaps\styles.xml %rdir1%\uidata
copy /Y /V %OpenCPNDIR%\src\bitmaps\toolicons_traditional.png %rdir1%\uidata
copy /Y /V %OpenCPNDIR%\src\bitmaps\toolicons_journeyman.png %rdir1%\uidata
copy /Y /V %OpenCPNDIR%\src\bitmaps\toolicons_journeyman_flat.png %rdir1%\uidata
copy /Y /V %OpenCPNDIR%\src\bitmaps\iconAll.png %rdir1%\uidata
copy /Y /V %OpenCPNDIR%\src\bitmaps\iconMinimum.png %rdir1%\uidata
copy /Y /V %OpenCPNDIR%\src\bitmaps\iconRMinus.png %rdir1%\uidata
copy /Y /V %OpenCPNDIR%\src\bitmaps\iconRPlus.png %rdir1%\uidata
copy /Y /V %OpenCPNDIR%\src\bitmaps\iconStandard.png %rdir1%\uidata
copy /Y /V %OpenCPNDIR%\src\bitmaps\iconUserStd.png %rdir1%\uidata
@echo Copying toolbar icons
xcopy /Y /Q /H /E /K /I  %OpenCPNDIR%\data\svg\journeyman %rdir1%\uidata\journeyman
xcopy /Y /Q /H /E /K /I  %OpenCPNDIR%\data\svg\journeyman_flat %rdir1%\uidata\journeyman_flat
xcopy /Y /Q /H /E /K /I  %OpenCPNDIR%\data\svg\traditional %rdir1%\uidata\traditional
xcopy /Y /Q /H /E /K /I  %OpenCPNDIR%\data\svg\markicons %rdir1%\uidata\markicons
@echo Copying documentation and misc. data
xcopy /Y /Q /H /E /K /I  %OpenCPNDIR%\data\doc %rdir1%\doc
xcopy /Y /Q /H /E /K /I  %OpenCPNDIR%\data\gshhs %rdir1%\gshhs
xcopy /Y /Q /H /E /K /I  %OpenCPNDIR%\data\s57data %rdir1%\s57data
xcopy /Y /Q /H /E /K /I  %OpenCPNDIR%\data\sounds %rdir1%\sounds
xcopy /Y /Q /H /E /K /I  %OpenCPNDIR%\data\tcdata %rdir1%\tcdata
xcopy /Y /Q /H /E /K /I  %OpenCPNDIR%\data\wvsdata %rdir1%\wvsdata
xcopy /Y /Q /H /E /K /I  %OpenCPNDIR%\data\license.txt %rdir1%

for /d %%a in (
  "%OpenCPNDIR%\build\_CPack_Packages\win32\NSIS\opencpn_*_setup"
) do set "ShareFolder=%%~fa\share"

if "%ShareFolder%" == "" goto copy_crashrpt
if not exist "%ShareFolder%" goto copy_crashrpt
xcopy /Y /Q /H /E /K /I %ShareFolder% %rdir1%\share

:copy_crashrpt
@echo "Copying Crash Reporter"
xcopy /Y /Q /H /E /K /I %OpenCPNDIR%\buildwin\crashrpt\*.dll %rdir1%
xcopy /Y /Q /H /E /K /I %OpenCPNDIR%\buildwin\crashrpt\*.txt %rdir1%
xcopy /Y /Q /H /E /K /I %OpenCPNDIR%\buildwin\crashrpt\Crash*.exe %rdir1%
xcopy /Y /Q /H /E /K /I %OpenCPNDIR%\buildwin\crashrpt\*.ini %rdir1%

:copy_programdata
rem del /f /q %rdir1%\opencpn.ini
rem del /f /q %rdir1%\navobj.xml
rem del /f /q %rdir1%\navobj.xml.1
rem del /f /q %rdir1%\CHRTLIST.DAT
rem copy /v %PROGRAMDATA%\OpenCPN\opencpn.ini %rdir1%\opencpn.ini
rem copy /v %PROGRAMDATA%\OpenCPN\navobj.xml %rdir1%\navobj.xml
rem copy /v %PROGRAMDATA%\OpenCPN\navobj.xml.1 %rdir1%\navobj.xml.1
rem copy /v %PROGRAMDATA%\OpenCPN\CHRTLIST.DAT %rdir1%\CHRTLIST.DAT

:copy_plugins
for /D %%f in (%OpenCPNDIR%\plugins\*) do call :handlePluginDir %1 %%f %pld1%

exit /b 0
:usage
endlocal
@echo Usage: docopy rundir (e.g. "docopy Debug" for debug mode
@echo                         or "docopy Release" for release mode)
@echo
@echo ***********************************************************************************
@echo * This batch file copies dependency files into the proper folder based on         *
@echo * a single argument. If the argument is "Debug" (without ") then it will          *
@echo * copy dependent files into the build\debug tree so OpenCPN will run in debug     *
@echo * mode.                                                                           *
@echo * If the argument is "Release" (without ") then it will copy dependent files      *
@echo * into the build\Release folder under the build folder.                           *
@echo *                                                                                 *
@echo * NOTE: You must call cleanPlugins.bat before building OpenCPN!!!                 *
@echo *       Then you can call docopy.bat release | debug                              *
@echo *                                                                                 *
@echo * NOTE: This moves files into the folder under build. Therefore, you must start   *
@echo *       OpenCPN.exe with the -p option. That way it will use the proper folder for*
@echo *       obtaining the .ini file and other key data files. You can set the startup *
@echo *       command line option in Visual Studio configuration properties Debugging   *
@echo *       section. Be sure to put -p in the Command Arguments option.               *
@echo ***********************************************************************************
exit /b 1

:handlePluginDir
rem @echo echo
rem @echo handlePluginDir %1 %2 %3
rem @echo Trying
FOR %%a IN (%2) DO (
    if exist %%a (
        set FILEEXT=%%~nxa
    )
)
rem @echo "call :copyPlugin %FILEEXT% %1 %3"
call :copyPlugin %FILEEXT% %1 %3
exit /b 0

:copyPlugin
rem @echo arg0=%0
rem @echo arg1=%1
rem @echo arg2=%2
rem @echo arg3=%3
if not exist %3 mkdir %3
@echo "Copying %OpenCPNDIR%\build\plugins\%1\%2\%1.dll--->%3"
copy /Y /V %OpenCPNDIR%\build\plugins\%1\%2\%1.dll %3
if not exist %OpenCPNDIR%\plugins\%1\data goto endCopyPlugin
if not exist "%3\%1\data" mkdir "%3\%1\data"
@echo "Xcopying %OpenCPNDIR%\plugins\%1\data-->%3\%1\data"
xcopy /Y /Q /H /E /K /I %OpenCPNDIR%\plugins\%1\data %3\%1\data
:endCopyPlugin
exit /b
