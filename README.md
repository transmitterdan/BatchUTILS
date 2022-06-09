# BatchUTILS
Windows batch files I use to make building OpenCPN and other things easier.

After cloning this repository add the folder *batchutils* to your PATH environment.

## Explation of files
**Osetup.bat** - Called by "%VSINSTALLDIR%\Common7\Tools\vsdevcmd\ext\VsDevCmd.bat to add other utilities to the PATH. Make a symbolic link: mklink "%VSINSTALLDIR%\Common7\Tools\vsdevcmd\ext\osetup.bat" "\Path-To-BatchUtils\osetup.bat" . During startup, VS2017 and higher scan this folder and call all the .bat files found therein.

You must edit this file to set some environment variables.  The following environment variables are set by Osetup.bat and they must be customized for your local situation.

- **OpenCPNDIR**: Location of your OpenCPN git repository
- **UTILDIR**: Location of BatchUTILS git repository
- **WXDIR**: Location of your wxWidgets git repository

**findvc.bat** - Tool to identify the version of Visual Studio this command prompt running and set up build variable accordingly.  Now 
we support muliple compilers so we had to create separate versions of wxWidgets libraries for each compiler flow. The
findvc.bat tool sets up the proper wxWidgets folder names for linking under each compiler flow.  This only works for 
VS2017 and above.

**build.bat** - Builds release version of OpenCPN from the VS command prompt. Optionally will create an installer package.

**wxNew.bat** - Builds wxWidgets using cMake.  This is the new way to build wxWidgets from the command line. Run wxNew.bat in a 
Visual Studio 2022 command prompt.  That should build an x86 DLL version of wxWidgets.  It will also copy the 
wxWidgets dll files to your OpenCPN build tree replacing the ones used for production release.
           
**wxBuild.bat** - Builds wxWidgets.
              
              I no longer use wxBuild.bat in favor of the wxNew.bat tool

**clean.bat** - Cleans the OpenCPN build tree.

**clone_opencpn.bat** - Once you create a fork of OpenCPN then use this batch file to clone your fork. Usage: clone_opencpn gihub_username
This should work for just about anybody as is.
                    
**config.bat** - Run this from the OpenCPN\build folder (you have to mkdir build) to set up Cmake and create all make files.

**dbbuild.bat** - Builds debug version of OpenCPN. Otherwise it is like build.bat.

**docopyAll.bat** - helper function for build.bat and dbbuild.bat

**delBranch.bat** - helper function to delete a branch in local and remote git repository.

**To use these utilities the first time:**

1. Open a Developer Command Prompt for VS 20XX and do the following:
2. > cd root folder of your development tree
3. > "clone_opencpn.bat" mygitusername
4. > mkdir build
5. > cd build
6. > config
7. > dbbuild
8. > devenv

The Visual Studio environment will open.  Navigate to the opencpn build folder and open the file "opencpn.sln".

# How to build wxWidgets from git repository

1. Type the command "wxNew" to build Release and Debug wxWidget libraries.
