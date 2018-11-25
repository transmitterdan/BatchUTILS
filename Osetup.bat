@echo off
@echo "*******************************"
@echo "*   Entering Osetup.bat...    *"
@echo "*******************************"
rem Edit these lines to match the place(s) you keep your opencpn cloned repository
rem These are my locations but yours will be different so edit these lines. You don't need
rem two lines. One is enough.
if exist e:\storage\transmitterdan\OpenCPN set "OpenCPNDIR=E:\storage\transmitterdan\OpenCPN"
if exist c:\storage\transmitterdan\OpenCPN set "OpenCPNDIR=C:\storage\transmitterdan\OpenCPN"
if not ""=="%OpenCPNDIR%" goto :foundit
@echo Cannot find OpenCPN development folder.
goto :notfoundit

:foundit
@echo Found OpenCPN development folder at %OpenCPNDIR%
:notfoundit
@rem wxWidgets
@rem -------------------
rem Edit these lines to tell the build tools where you have put the wxWidgets installation.
rem You only need one line here. I have several versions of wxWidgets so I have many lines.
rem But you only need one. I strongly recommend using the 3.0.2 version. It is compatible with
rem most plugins.
@if exist "C:\wxWidgets-2.8.12" set "WXDIR=C:\wxWidgets-2.8.12"
@if exist "C:\wxWidgets-3.0.2" set "WXDIR=C:\wxWidgets-3.0.2"
@if exist "C:\wxWidgets-3.0.3" set "WXDIR=C:\wxWidgets-3.0.3"
@if exist "E:\wxWidgets-3.0.3" set "WXDIR=E:\wxWidgets-3.0.3"
rem @if exist "C:\storage\transmitterdan\wxWidgets-3.0.2" set "WXDIR=C:\storage\transmitterdan\wxWidgets-3.0.2"
rem @if exist "E:\storage\transmitterdan\wxWidgets-3.0.2" set "WXDIR=E:\storage\transmitterdan\wxWidgets-3.0.2"
@if exist "C:\wxWidgets-3.1.0" set "WXDIR=C:\wxWidgets-3.1.0"
rem @if exist "C:\storage\transmitterdan\wxWidgets-3.1.0" set "WXDIR=C:\storage\transmitterdan\wxWidgets-3.1.0"
rem @if exist "E:\storage\transmitterdan\wxWidgets-3.1.0" set "WXDIR=E:\storage\transmitterdan\wxWidgets-3.1.0"
rem @if exist "C:\storage\transmitterdan\wxWidgets" set "WXDIR=C:\storage\transmitterdan\wxWidgets"
rem @if exist "E:\storage\transmitterdan\wxWidgets" set "WXDIR=E:\storage\transmitterdan\wxWidgets"
rem @if exist "C:\storage\transmitterdan\wxWidgets" set "WXDIR=C:\storage\transmitterdan\wxWidgets"
rem @if exist "E:\storage\rework\wxWidgets" set "WXDIR=E:\storage\rework\wxWidgets"
@if not "%WXDIR%"=="" goto :foundWX
@echo Could not find wxWidgets anywhere.
goto :noWX

:foundWX
@echo Found most recent version of wxWidgets at %WXDIR%
@set "WXWIN=%WXDIR%"
rem @ECHO "wxWidgets folder is %WXDIR%"

call :add_to_path "%WXDIR%"
call :add_to_path "%WXDIR%\lib\vc141_xp_dll"
:noWX

rem Here we add all the tools that we need to build OpenCPN.
rem You should put the paths here to match your system.
rem Same as above, you don't need 2 lines for each program. One is enough.
rem But these lines represent probably 99% of the typical installations.
rem You may not have to edit these lines at all. For any tools that you
rem don't have it will just skip over them so you don't have to delete
rem any lines unless you need to.
@rem POedit
@rem -------------------
call :add_to_path "%ProgramFiles%\Poedit\GettextTools\bin"
call :add_to_path "%ProgramFiles(x86)%\Poedit\GettextTools\bin"
@rem CMake
@rem -------------------
call :add_to_path "%ProgramFiles%\CMake\bin"
call :add_to_path "%ProgramFiles(x86)%\CMake\bin"
@rem 7-Zip
@rem -------------------
call :add_to_path "%ProgramFiles%\7-Zip"
call :add_to_path "%ProgramFiles(x86)%\7-Zip"
@rem Notepad++
@rem -------------------
call :add_to_path "%ProgramFiles(x86)%\Notepad++"
call :add_to_path "%ProgramFiles%\Notepad++"
@rem Git
@rem -------------------
call :add_to_path "%ProgramFiles(x86)%\Git\bin"
call :add_to_path "%ProgramFiles%\Git\bin"
@rem Bakefile
@rem -------------------
@rem call :add_to_path "C:\storage\transmitterdan\bakefile-1.2.5.1_beta-win"
@rem call :add_to_path "E:\storage\transmitterdan\bakefile-1.2.5.1_beta-win"

rem Edit this line to the location where you keep BatchUTILS.
rem As before, you only need one line that matches your system.
@if exist "C:\storage\transmitterdan\BatchUTILS" call :add_to_path "C:\storage\transmitterdan\BatchUTILS"
@if exist "E:\storage\transmitterdan\BatchUTILS" call :add_to_path "E:\storage\transmitterdan\BatchUTILS"

@exit /B 0


rem Don't change this stuff.
@REM ------------------------------------------------------------------------
:add_to_path
if exist "%~1" (
@   echo Adding %1 to path
    set "PATH=%~1;%PATH%"
    goto return
) else (
    if "%VSCMD_DEBUG%" GEQ "2" @echo [DEBUG:%~nx0] Could not add directory to PATH: "%~1"
    if "%VSCMD_DEBUG%" GEQ "2" goto return
	@echo Warning: Could not add directory to PATH "%~1"
)
:return
exit /B 0
