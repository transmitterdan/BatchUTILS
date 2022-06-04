@echo off
@echo "********************************"
@echo "*   Entering Osetup.bat...V1.1  *"
@echo "********************************"
rem
rem Create symbolic link to this file in folder "%VSINSTALLDIR%\Common7\Tools\vsdevcmd\ext".
rem 
rem Be sure to use the complete path to this file as in the example below:
rem mklink "%VSINSTALLDIR%\Common7\Tools\vsdevcmd\ext\Osetup.bat" \transmitterdan\BatchUtils\Osetup.bat
rem Note you may have to open CMD prompt as administrator to create the link.
rem
rem Edit these lines to match the place(s) you keep your opencpn cloned repository
rem These are my locations but yours will be different so edit these lines. You don't need
rem two lines. One is enough.
if exist c:\transmitterdan\OpenCPN set "OpenCPNDIR=C:\transmitterdan\OpenCPN"
if exist d:\transmitterdan\OpenCPN set "OpenCPNDIR=D:\transmitterdan\OpenCPN"
if not ""=="%OpenCPNDIR%\build" goto :foundit
@echo Cannot find OpenCPN development folder.
goto :notfoundit

:foundit
@echo Found OpenCPN development folder at %OpenCPNDIR%
set "VSCMD_START_DIR=%OpenCPNDir%"
:notfoundit

rem Edit this line to the location where you keep BatchUTILS.
rem As before, you only need one line that matches your system.
@if exist "C:\transmitterdan\BatchUTILS" set "UTILDIR=C:\transmitterdan\BatchUTILS"
@if exist "D:\transmitterdan\BatchUTILS" set "UTILDIR=D:\transmitterdan\BatchUTILS"

call "%UTILDIR%\findvc.bat"
if %ERRORLEVEL% GTR 0 exit /b %ERRORLEVEL%
@echo "vcgen=%vcgen%"
@echo "vcts=%vcts%"

rem wxWidgets
rem -------------------
rem Edit these lines to tell the build tools where you have put the wxWidgets installation.
rem You only need one line here. I have several versions of wxWidgets so I have many lines.
rem But you only need one. You may need a certain version to compatible with
rem certain plugins.
@if exist "C:\wxWidgets-2.8.12" set "WXDIR=C:\wxWidgets-2.8.12"
@if exist "C:\wxWidgets-3.0.2" set "WXDIR=C:\wxWidgets-3.0.2"
@if exist "C:\wxWidgets-3.0.3" set "WXDIR=C:\wxWidgets-3.0.3"
@if exist "E:\wxWidgets-3.0.3" set "WXDIR=E:\wxWidgets-3.0.3"
@if exist "C:\wxWidgets-3.1.0" set "WXDIR=C:\wxWidgets-3.1.0"
@if exist "E:\wxWidgets-3.1.0" set "WXDIR=E:\wxWidgets-3.1.0"
@if exist "C:\wxWidgets-3.1.1" set "WXDIR=C:\wxWidgets-3.1.1"
@if exist "E:\wxWidgets-3.1.1" set "WXDIR=E:\wxWidgets-3.1.1"
@if exist "C:\OA\wxWidgets" set "WXDIR=C:\OA\wxWidgets"
@if exist "E:\OA\wxWidgets" set "WXDIR=E:\OA\wxWidgets"
@if not "%WXDIR%"=="" goto :foundWX
@echo Could not find wxWidgets anywhere.

goto :noWX

:foundWX
@echo Found most recent version of wxWidgets at %WXDIR%
@set "wxWIN=%WXDIR%"
@set "wxWidgets_ROOT_DIR=%WXDIR%"
@set "wxWidgets_LIB_DIR=%WXDIR%\lib\vc%vcts%_dll"
@ECHO wxWidgets folder is "%WXDIR%"

@ECHO wxWidgets_LIB_DIR folder is "%wxWidgets_LIB_DIR%"

rem call :add_to_path "%wxWidgets_LIB_DIR%"

rem call :add_to_path "%wxWin%"


rem @echo Adding "%WXDIR%\lib\vc%vcts%_dll" wxDLLs to path

rem call :add_to_path "%WXDIR%\lib\vc%vcts%_dll"

:noWX

rem Here we add all the tools that we need to build OpenCPN.
rem You should put the paths here to match your system.
rem Same as above, you don't need 2 lines for each program. One is enough.
rem But these lines represent probably 99% of the typical installations.
rem You may not have to edit these lines at all. For any tools that you
rem don't have it will just skip over them so you don't have to delete
rem any lines unless you need to.
rem POedit
rem -------------------

call :add_to_path "%ProgramFiles(x86)%\Poedit\GettextTools\bin"
if %errorlevel% == 0 goto :poedit
call :add_to_path "%ProgramFiles%\Poedit\GettextTools\bin"
if %errorlevel% == 0 goto :poedit
call :add_to_path "%ProgramW6432%\Poedit\GettextTools\bin"
if %errorlevel% == 0 goto :poedit
@echo WARNING: Could not add GettextTools\bin to PATH

:poedit
call :add_to_path "%ProgramFiles%\Poedit"
if %errorlevel% == 0 goto :Cmake
call :add_to_path "%ProgramFiles(x86)%\Poedit"
if %errorlevel% == 0 goto :Cmake
call :add_to_path "%ProgramW6432%\Poedit"
if %errorlevel% == 0 goto :Cmake
@echo WARNING: Could not add Poedit to PATH
rem CMake
rem -------------------
rem if "%vcgen%"=="Visual Studio 16 2019" goto :skip_CMake
rem if "%vcgen%"=="Visual Studio 15 2017" goto :skip_CMake

:CMake
call :add_to_path "%ProgramW6432%\CMake\bin"
if %errorlevel% == 0 goto :SevenZip
call :add_to_path "%ProgramFiles%\CMake\bin"
if %errorlevel% == 0 goto :SevenZip
call :add_to_path "%ProgramFiles(x86)%\CMake\bin"
if %errorlevel% == 0 goto :SevenZip
@echo WARNING: Could not add SevenZip\bin to PATH

:skip_CMake

:SevenZip
rem 7-Zip
rem -------------------
rem call :add_to_path "%ProgramW6432%\7-Zip"
call :add_to_path "%ProgramW6432%\7-Zip"
if %errorlevel% == 0 goto :NotepadPP
call :add_to_path "%ProgramFiles%\7-Zip"
if %errorlevel% == 0 goto :NotepadPP
call :add_to_path "%ProgramFiles(x86)%\7-Zip"
if %errorlevel% == 0 goto :NotepadPP
@echo WARNING: Could not add 7-Zip to PATH

:NotepadPP
rem Notepad++
rem -------------------
rem call :add_to_path "%ProgramW6432%\Notepad++"
call :add_to_path "%ProgramFiles(x86)%\Notepad++"
if %errorlevel% == 0 goto :Git
call :add_to_path "%ProgramW6432%\Notepad++"
if %errorlevel% == 0 goto :Git
call :add_to_path "%ProgramFiles%\Notepad++"
if %errorlevel% == 0 goto :Git
@echo WARNING: Could not add Notepad++ to PATH

:Git
rem Git
rem -------------------
call :add_to_path "%ProgramW6432%\Git\cmd"
if %errorlevel% == 0 goto :Doxygen
call :add_to_path "%ProgramFiles%\Git\cmd"
if %errorlevel% == 0 goto :Doxygen
@echo WARNING: Could not add Git to PATH

:Doxygen
rem Doxygen
rem -------------------
call :add_to_path "%ProgramFiles%\doxygen\bin"
if %errorlevel% == 0 goto :Graphviz
@echo WARNING: Could not add Doxygen\bin to PATH

:Graphviz
call :add_to_path "%ProgramFiles(x86)%\Graphviz2.38\bin"
if %errorlevel% == 0 goto :Utildir
@echo WARNING: Could not add Graphviz to PATH

:Utildir
rem Edit this line to the location where you keep BatchUTILS.
rem As before, you only need one line that matches your system.
@if exist "%UTILDIR%" call :add_to_path "%UTILDIR%"
if %errorlevel% == 0 goto :finish
@echo WARNING: Could not add UTILDIR to PATH

:finish
@exit /B 0

rem Don't change this stuff.
REM ------------------------------------------------------------------------
:add_to_path
if exist "%~1" (
@   echo Adding %1 to path
    set "PATH=%~1;%PATH%"
    exit /b 0
) else (
rem    if "%VSCMD_DEBUG%" GEQ "2" @echo [DEBUG:%~nx0] Could not add directory to PATH: "%~1"
rem    if "%VSCMD_DEBUG%" GEQ "2" goto: EOF
rem @   echo Warning: Couldn't add directory to PATH "%~1"
    exit /b 1
)
goto :EOF

