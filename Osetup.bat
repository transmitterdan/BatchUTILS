@echo off
@echo "*******************************"
@echo "*   Entering Osetup.bat...    *"
@echo "*******************************"
if exist e:\storage\transmitterdan\OpenCPN set "OpenCPNDIR=E:\storage\transmitterdan\OpenCPN"
if exist c:\storage\transmitterdan\OpenCPN set "OpenCPNDIR=C:\storage\transmitterdan\OpenCPN"
if not ""=="%OpenCPNDIR%" goto :foundit
@echo Cannot find OpenCPN development folder.
exit /b 1

:foundit
@echo Found OpenCPN development folder at %OpenCPNDIR%
@rem wxWidgets
@rem -------------------
@if exist "C:\wxWidgets-2.8.12" set "WXDIR=C:\wxWidgets-2.8.12"
@if exist "C:\wxWidgets-3.0.2" set "WXDIR=C:\wxWidgets-3.0.2"
@if exist "C:\wxWidgets-3.1.0" set "WXDIR=C:\wxWidgets-3.1.0"
@if exist "C:\storage\transmitterdan\wxWidgets-3.0.2" set "WXDIR=C:\storage\transmitterdan\wxWidgets-3.0.2"
@if exist "C:\storage\transmitterdan\wxWidgets" set "WXDIR=C:\storage\transmitterdan\wxWidgets"
@if exist "E:\storage\transmitterdan\wxWidgets" set "WXDIR=E:\storage\transmitterdan\wxWidgets"
@if exist "E:\storage\rework\wxWidgets" set "WXDIR=E:\storage\rework\wxWidgets"
@echo Found most recent version of wxWidgets at %WXDIR%
rem @set "WXWIN=%WXDIR%"
rem @ECHO "wxWidgets folder is %WXDIR%"

call :add_to_path "%WXDIR%"
call :add_to_path "%WXDIR%\lib\vc_dll"

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
call :add_to_path "C:\storage\transmitterdan\bakefile-1.2.5.1_beta-win"
call :add_to_path "E:\storage\transmitterdan\bakefile-1.2.5.1_beta-win"

call :add_to_path "C:\storage\transmitterdan\BatchUTILS"
call :add_to_path "E:\storage\transmitterdan\BatchUTILS"

@exit /B 0



@REM ------------------------------------------------------------------------
:add_to_path
if exist "%~1" (
@   echo Adding %1 to path
    set "PATH=%~1;%PATH%"
    goto return
) else (
    if "%VSCMD_DEBUG%" GEQ "2" @echo [DEBUG:%~nx0] Could not add directory to PATH: "%~1"
    if "%VSCMD_DEBUG%" GEQ "2" goto return
)
:return
exit /B 0
