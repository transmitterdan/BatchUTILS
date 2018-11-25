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
pushd ..
for /f %%i in ('cd') do set SRCFOLDER=%%i
popd
@echo Setting up %SRCFOLDER% for %1 execution.
if "%1"=="" goto usage
if not exist %SRCFOLDER%\build\%1 goto usage
set "str=%1"
call :toupper
set "mode=%upper%"
if "%mode%"=="RELEASE" goto setup
if "%mode%"=="RELWITHDEBINFO" goto setup
if "%mode%"=="MINSIZEREL" goto setup
if "%mode%"=="DEBUG" goto setup
goto usage

:setup
echo "Setting up source and destination folders"
set rdir1=%SRCFOLDER%\build\%mode%
set pld1=%SRCFOLDER%\build\%mode%\plugins
if "%2" == "PluginsOnly" goto copy_plugins

@echo Copying DLLs...
rem del /f %rdir1%\*.dll
copy /Y /V %SRCFOLDER%\buildwin\gtk\*.dll %rdir1%
copy /Y /V %SRCFOLDER%\buildwin\expat-2.1.0\*.dll %rdir1%
copy /Y /V %SRCFOLDER%\buildwin\*.dll %rdir1%
copy /Y /V %SRCFOLDER%\buildwin\*.crt %rdir1%
if exist %SRCFOLDER%\buildwin\vc copy /Y /V %SRCFOLDER%\buildwin\vc\*.dll %rdir1%
rem @echo Copying wxWidgets DLL files...
rem if "%mode%" == "DEBUG" xcopy /Y /Q /H /E /K /I %WXDIR%\lib\vc141_dll\*ud_*.dll %rdir1%
rem if "%mode%" == "RELEASE" xcopy /Y /Q /H /E /K /I %WXDIR%\lib\vc141_dll\*u_*.dll %rdir1%
rem if "%mode%" == "RELWITHDEBINFO" xcopy /Y /Q /H /E /K /I %WXDIR%\lib\vc141_dll\*u_*.dll %rdir1%
rem if "%mode%" == "MINSIZEREL" xcopy /Y /Q /H /E /K /I %WXDIR%\lib\vc141_dll\*u_*.dll %rdir1%

@rem @echo Copying wxWidgets locale files
@rem if not exist %rdir1%\locale mkdir %rdir1%\locale
@rem xcopy /Y /V /H /E /K /I %WXDIR%\locale %rdir1%\locale


@echo "Copying data files"
if not exist %rdir1%\doc echo "running mkdir %rdir1%\doc"
if not exist %rdir1%\doc mkdir %rdir1%\doc
if not exist %rdir1%\gshhs echo "running mkdir %rdir1%\gshhs"
if not exist %rdir1%\gshhs mkdir %rdir1%\gshhs
if not exist %rdir1%\plugins echo "running mkdir %rdir1%\plugins"
if not exist %rdir1%\plugins mkdir %rdir1%\plugins
if not exist %rdir1%\s57data mkdir %rdir1%\s57data
if not exist %rdir1%\share mkdir %rdir1%\share
if not exist %rdir1%\sounds mkdir %rdir1%\sounds
if not exist %rdir1%\tcdata mkdir %rdir1%\tcdata
if not exist %rdir1%\uidata mkdir %rdir1%\uidata
if not exist %rdir1%\uidata\traditional mkdir %rdir1%\uidata\traditional
if not exist %rdir1%\uidata\journeyman mkdir %rdir1%\uidata\journeyman
if not exist %rdir1%\uidata\journeyman_flat mkdir %rdir1%\uidata\journeyman_flat
if not exist %rdir1%\uidata\MUI_flat mkdir %rdir1%\uidata\MUI_flat

if not exist %rdir1%\wvsdata mkdir %rdir1%\wvsdata

:copy_uidata
@echo Copying icons and syles
copy /Y /V %SRCFOLDER%\src\bitmaps\styles.xml %rdir1%\uidata
copy /Y /V %SRCFOLDER%\src\bitmaps\toolicons_traditional.png %rdir1%\uidata
copy /Y /V %SRCFOLDER%\src\bitmaps\toolicons_journeyman.png %rdir1%\uidata
copy /Y /V %SRCFOLDER%\src\bitmaps\toolicons_journeyman_flat.png %rdir1%\uidata
copy /Y /V %SRCFOLDER%\src\bitmaps\iconAll.png %rdir1%\uidata
copy /Y /V %SRCFOLDER%\src\bitmaps\iconMinimum.png %rdir1%\uidata
copy /Y /V %SRCFOLDER%\src\bitmaps\iconRMinus.png %rdir1%\uidata
copy /Y /V %SRCFOLDER%\src\bitmaps\iconRPlus.png %rdir1%\uidata
copy /Y /V %SRCFOLDER%\src\bitmaps\iconStandard.png %rdir1%\uidata
copy /Y /V %SRCFOLDER%\src\bitmaps\iconUserStd.png %rdir1%\uidata
@echo Copying toolbar icons
xcopy /Y /Q /H /E /K /I  %SRCFOLDER%\data\svg\journeyman %rdir1%\uidata\journeyman
xcopy /Y /Q /H /E /K /I  %SRCFOLDER%\data\svg\journeyman_flat %rdir1%\uidata\journeyman_flat
xcopy /Y /Q /H /E /K /I  %SRCFOLDER%\data\svg\traditional %rdir1%\uidata\traditional
xcopy /Y /Q /H /E /K /I  %SRCFOLDER%\data\svg\MUI_flat %rdir1%\uidata\MUI_flat
xcopy /Y /Q /H /E /K /I  %SRCFOLDER%\data\svg\markicons %rdir1%\uidata\markicons
@echo Copying documentation and misc. data
xcopy /Y /Q /H /E /K /I  %SRCFOLDER%\data\doc %rdir1%\doc
xcopy /Y /Q /H /E /K /I  %SRCFOLDER%\data\gshhs %rdir1%\gshhs
xcopy /Y /Q /H /E /K /I  %SRCFOLDER%\data\s57data %rdir1%\s57data
xcopy /Y /Q /H /E /K /I  %SRCFOLDER%\data\sounds %rdir1%\sounds
xcopy /Y /Q /H /E /K /I  %SRCFOLDER%\data\tcdata %rdir1%\tcdata
xcopy /Y /Q /H /E /K /I  %SRCFOLDER%\data\wvsdata %rdir1%\wvsdata
xcopy /Y /Q /H /E /K /I  %SRCFOLDER%\data\license.txt %rdir1%

for /d %%a in (
  "%SRCFOLDER%\build\_CPack_Packages\win32\NSIS\opencpn_*_setup"
) do set "ShareFolder=%%~fa\share"

if "%ShareFolder%" == "" goto copy_crashrpt
if not exist "%ShareFolder%" goto copy_crashrpt
xcopy /Y /Q /H /E /K /I %ShareFolder% %rdir1%\share

:copy_crashrpt
@echo "Copying Crash Reporter"
xcopy /Y /Q /H /E /K /I %SRCFOLDER%\buildwin\crashrpt\*.dll %rdir1%
xcopy /Y /Q /H /E /K /I %SRCFOLDER%\buildwin\crashrpt\*.txt %rdir1%
xcopy /Y /Q /H /E /K /I %SRCFOLDER%\buildwin\crashrpt\Crash*.exe %rdir1%
xcopy /Y /Q /H /E /K /I %SRCFOLDER%\buildwin\crashrpt\*.ini %rdir1%

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
for /D %%f in (%SRCFOLDER%\plugins\*) do call :handlePluginDir %1 %%f %pld1%

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
if not exist %SRCFOLDER%\build\plugins\%1\%2\%1.dll goto endCopyPlugin
if not exist %3 mkdir %3
@echo "Copying %SRCFOLDER%\build\plugins\%1\%2\%1.dll--->%3"
copy /Y /V %SRCFOLDER%\build\plugins\%1\%2\%1.dll %3
if not exist %SRCFOLDER%\plugins\%1\data goto endCopyPlugin
if not exist "%3\%1\data" mkdir "%3\%1\data"
@echo "Xcopying %SRCFOLDER%\plugins\%1\data-->%3\%1\data"
xcopy /Y /Q /H /E /K /I %SRCFOLDER%\plugins\%1\data %3\%1\data
:endCopyPlugin
exit /b 0

:toupper
@rem convert str to uppercase and put it in variable upper
for /f "usebackq delims=" %%I in (`powershell "\"%str%\".toUpper()"`) do set "upper=%%~I"
exit /b 0