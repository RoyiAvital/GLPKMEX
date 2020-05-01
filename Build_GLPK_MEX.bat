REM Build GLPK DLL with Microsoft Visual Studio 2017 - Royi Avital
REM This scripts assumes the Development CMD is predefined
REM This will build both the Static Library of GLPK and the Dynamic Library of GLPK

copy config_VC config.h

nmake.exe /f Makefile_VC
nmake.exe /f Makefile_VC check

nmake.exe /f Makefile_VC_DLL
nmake.exe /f Makefile_VC_DLL check