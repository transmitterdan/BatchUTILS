# BatchUTILS
Windows batch files I use to make building OpenCPN and other things easier.

I put all of these files in a folder that is on my PATH.

Osetup.bat - Called by C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat to add other utilities to the PATH.
             Edit the VsDevCmd.bat file in administrator mode. Don't use Osetup.bat as it is but rather change it to match where your
             programming utilities are installed.
             NOTE: For Visual Studio 2017 and 2019 do not edit VsDevCmd.bat. Rather copy Osetup.bat to this folder:
             
             "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\vsdevcmd\ext"
             
             During startup VS2017 and VS2019 scan this folder and call all the .bat files found therein.

findvc.bat - Tool to identify the version of Visual Studio this command prompt running and set up build variable accordingly.  Now 
             we support muliple compilers so we had to create separate versions of wxWidgets libraries for each compiler flow. The
             findvc.bat tool sets up the proper wxWidgets folder names for linking under each compiler flow.  This only works for 
             VS2017 and above.

build.bat - Builds release version of OpenCPN from the VS command prompt. Optionally will create an installer package.

buildWX.bat - Builds wxWidgets. Note: I don't use this anymore as I build wxWidgets from my github fork. I open
              wxWidgets\build\msw\wx_vc14.sln with Visual Studio 15. My OpenCPN branch of wxWidgets will create a wxWidgets set of 
              DLLs that are compatible with OpenCPN latest master.
              
              For VS2017 & VS2019 I build wxWidgets using the batch file wxBuild.bat.
              
clean.bat - Cleans the OpenCPN build tree.

clone_opencpn.bat - Once you create a fork of OpenCPN then use this batch file to clone your fork. Usage: clone_opencpn gihub_username
                    This should work for just about anybody as is.
                    
config.bat - Run this from the OpenCPN\build folder (you have to mkdir build) to set up Cmake and create all make files.

dbbuild.bat - Builds debug version of OpenCPN. Otherwise it is like build.bat.

docopyAll.bat - helper function for build.bat and dbbuild.bat
