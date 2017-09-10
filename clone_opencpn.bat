@echo off
if "%1"=="" goto usage
if not "%2"=="" set "folder=%2"
if "%2"=="" set "folder=%1"
@echo "Building %folder%"
if not exist "%folder%\NUL" mkdir %folder%
cd %folder%
if %ERRORLEVEL% GTR 0 goto quit
@echo Cloning OpenCPN
git clone https://github.com/%1/OpenCPN.git
if %ERRORLEVEL% GTR 0 goto quit
cd
pushd opencpn
cd
git fetch --all
if not "%1" == "opencpn" if not "%1" == "OpenCPN" goto setUsptream
goto checkout
:setUsptream
git remote add upstream https://github.com/OpenCPN/OpenCPN.git
:checkout
git checkout master
mkdir build
@echo Getting buildwin extras
powershell -Command "(New-Object Net.WebClient).DownloadFile('http://sourceforge.net/projects/opencpnplugins/files/opencpn_packaging_data/OpenCPN_buildwin.7z/download', 'OpenCPN_buildwin.7z')"
if not exist OpenCPN_buildwin.7z powershell -Command "(New-Object Net.WebClient).DownloadFile('http://sourceforge.net/projects/opencpnplugins/files/opencpn_packaging_data/OpenCPN_buildwin.7z/download', 'OpenCPN_buildwin.7z')"
if not exist OpenCPN_buildwin.7z goto quit
@echo Got buildwin extras downloaded ok.
@echo Getting buildwin-svg extras
powershell -Command "(New-Object Net.WebClient).DownloadFile('http://sourceforge.net/projects/opencpnplugins/files/opencpn_packaging_data/OpenCPN_buildwin-svg.7z/download', 'OpenCPN_buildwin-svg.7z')"
if not exist OpenCPN_buildwin-svg.7z powershell -Command "(New-Object Net.WebClient).DownloadFile('http://sourceforge.net/projects/opencpnplugins/files/opencpn_packaging_data/OpenCPN_buildwin-svg.7z/download', 'OpenCPN_buildwin-svg.7z')"
if not exist OpenCPN_buildwin-svg.7z goto quit
@echo Got buildwin-svg extras downloaded ok.
call :unzip
if %ERRORLEVEL% GTR 0 goto Done
cd build
@echo Configuring.....
call config.bat
rem call dbbuild.bat
rem call build.bat
:Done
popd
exit /b 0
:quit
exit /b 1
:usage
@echo Usage: clone_opencpn.bat account_name [folder_name]
@echo        account_name = github account name to clone openCPN from
@echo        folder_name = optional folder to clone into.
@echo        Default folder is same as account_name. After this
@echo        script runs you will have folder\opencpn. Then
@echo        cd folder\opencpn\build and build away.
@echo
@echo Note: This script does not work if you are cloning from the
@echo       master opencpn repository (github.com/OpenCPN/OpenCPN.git).
@echo       If you are trying to clone that repository think about why
@echo       you would ever want to do that. There are not practical
@echo       reasons to do so. You should probably fork the OpenCPN
@echo       master and then clone from your own fork. That's what this
@echo       script assumes you have done.
exit /b 1

:unzip
@echo If you are asked about overwriting files please
@echo select "S" to skip. Don't overwrite existing files!
@echo unzipping OpenCPN_buildwin.7z
7z x -aos OpenCPN_buildwin.7z
if %ERRORLEVEL% GTR 0 exit /b 1
del OpenCPN_buildwin.7z
@echo unzipping OpenCPN_buildwin-svg.7z
7z x -aos OpenCPN_buildwin-svg.7z
if %ERRORLEVEL% GTR 0 exit /b 1
del OpenCPN_buildwin-svg.7z
exit /b 0

