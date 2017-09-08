@echo off
if "%1"=="" goto usage
mkdir %1
cd %1
if %ERRORLEVEL% GTR 0 goto quit
@echo Cloning OpenCPN
git clone https://github.com/%1/OpenCPN.git
if %ERRORLEVEL% GTR 0 goto quit
pushd opencpn
git fetch --all
if not "%1" == "opencpn" if not "%1" == "OpenCPN" goto setUsptream
goto checkout
:setUsptream
git remote add upstream https://github.com/OpenCPN/OpenCPN.git
:checkout
git checkout master
mkdir build
powershell -Command "(New-Object Net.WebClient).DownloadFile('http://sourceforge.net/projects/opencpnplugins/files/opencpn_packaging_data/OpenCPN_buildwin.7z/download', 'OpenCPN_buildwin.7z')"
if not exist OpenCPN_buildwin.7z powershell -Command "(New-Object Net.WebClient).DownloadFile('http://sourceforge.net/projects/opencpnplugins/files/opencpn_packaging_data/OpenCPN_buildwin.7z/download', 'OpenCPN_buildwin.7z')"
powershell -Command "(New-Object Net.WebClient).DownloadFile('http://sourceforge.net/projects/opencpnplugins/files/opencpn_packaging_data/OpenCPN_buildwin-svg.7z/download', 'OpenCPN_buildwin-svg.7z')"
if not exit OpenCPN_buildwin-svg.7z powershell -Command "(New-Object Net.WebClient).DownloadFile('http://sourceforge.net/projects/opencpnplugins/files/opencpn_packaging_data/OpenCPN_buildwin-svg.7z/download', 'OpenCPN_buildwin-svg.7z')"
if not exist OpenCPN_buildwin.7z goto quit
if not exist OpenCPN_buildwin-svg.7z goto quit
call unzip
if %ERRORLEVEL% GTR 0 goto Done
cd build
call config.bat
rem call dbbuild.bat
rem call build.bat
:Done
popd
exit /b 0
:quit
exit /b 1
:usage
@echo Usage: clone_opencpn.bat repository_name
@echo        repository_name = github account name to clone from
@echo Note: This script does not work if you are cloning from the
@echo       master opencpn repository (github.com/OpenCPN/OpenCPN.git).
@echo       If you are trying to clone that repository think about why
@echo       you would ever want to do that. There are not practical
@echo       reasons to do so. You should probably fork the OpenCPN
@echo       master and then clone from your own fork. That's what this
@echo       script assumes you have done.
exit /b 1

:unzip
7z x OpenCPN_buildwin.7z
if %ERRORLEVEL% GTR 0 exit /b 1
del OpenCPN_buildwin.7z
7z x OpenCPN_buildwin-svg.7z
if %ERRORLEVEL% GTR 0 exit /b 1
del OpenCPN_buildwin-svg.7z
exit /b 0

