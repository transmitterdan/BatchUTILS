@rem wxWidgets
@rem -------------------
@if exist "C:\wxWidgets-2.8.12" set WXDIR=C:\wxWidgets-2.8.12
@if exist "C:\wxWidgets-3.0.2" set "WXDIR=C:\wxWidgets-3.0.2"
@if exist "C:\wxWidgets-3.1.0" set "WXDIR=C:\wxWidgets-3.1.0"
@if exist "C:\storage\transmitterdan\wxWidgets-3.0.2\" set WXDIR=C:\storage\transmitterdan\wxWidgets-3.0.2
@if exist "E:\storage\transmitterdan\wxwidgets\" set WXDIR=E:\storage\transmitterdan\wxwidgets
@set "WXWIN=%WXDIR%"
@set "PATH=%WXDIR%;%WXDIR%\lib\vc_dll;E:\storage\transmitterdan\BatchUTILS;%PATH%"
@rem POedit
@rem -------------------
@if exist "%ProgramFiles%\Poedit" set "PATH=%ProgramFiles%\Poedit\GettextTools\bin;%PATH%"
@if exist "%ProgramFiles(x86)%\Poedit" set "PATH=%ProgramFiles(x86)%\Poedit\GettextTools\bin;%PATH%"
@rem CMake
@rem -------------------
@if exist "%ProgramFiles%\CMake\bin" set "PATH=%ProgramFiles%\CMake\bin;%PATH%"
@if exist "%ProgramFiles(x86)%\CMake\bin" set "PATH=%ProgramFiles(x86)%\CMake\bin;%PATH%"
@rem 7-Zip
@rem -------------------
@if exist "%ProgramFiles%\7-Zip" set "PATH=%ProgramFiles%\7-Zip;%PATH%"
@if exist "%ProgramFiles%(x86)\7-Zip" set "PATH=%ProgramFiles(x86)%\7-Zip;%PATH%"
@rem Notepad++
@rem -------------------
@if exist "%ProgramFiles(x86)%\Notepad++" set "PATH=%ProgramFiles(x86)%\Notepad++;%PATH%"
@if exist "%ProgramFiles%\Notepad++" set "PATH=%ProgramFiles%\Notepad++;%PATH%"
@rem Git
@rem -------------------
@if exist "%ProgramFiles(x86)%\Git" set "PATH=%ProgramFiles(x86)%\Git\bin;%PATH%"
@if exist "%ProgramFiles%\Git\bin" set "PATH=%ProgramFiles%\Git\bin;%PATH%"
@rem Bakefile
@rem -------------------
@if exist "C:\storage\transmitterdan\bakefile-1.2.5.1_beta-win" set "PATH=C:\storage\transmitterdan\bakefile-1.2.5.1_beta-win;%PATH%"
@exit /B 0