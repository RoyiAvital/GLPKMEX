# GLPKMEX

[![View GLPKMEX - GNU Linear Programming Kit (GLPK) MEX Generator on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/75318-glpkmex-gnu-linear-programming-kit-glpk-mex-generator)

GLPKMEX is a MATLAB MEX Interface for the [GLPK Library](https://www.gnu.org/software/glpk/) developed by Andrew Makhorin.  
GLPKMEX is developed by Nicolo' Giorgetti (Email: giorgetti at ieee.org).  
GLPK is currently being maintained by Niels Klitgord (Email: niels at bu.edu).  

This version of GLPK MEX Generator is maintained by Royi Avital.  
It is based on [`glpkmex`](https://github.com/blegat/glpkmex) by Benoit Legat.  
It was updated to support the `4.65` version of GLPK (Latest as of May 2020).

## Instructions for Compiling MEX from Source

This MEX Generator builds a *Stand Alone* MEX File by linking to the static library of GLPK.  
This means the MEX file can be transferred to other computers and should work there.  
In order to use this generator download the repository and extract it any place.  
Then open a MATLAB session and navigate MATLAB to the folder the repository was extracted to and follow the instructions.

## System Requirements

 1.	A working MATLAB installation with `MEX` compiler set.
 2.	A Compiler:
 	*	Windows: MSVC 2017 or MSVC 2019.
	*	Linux: GCC 6.3 and above.

### Windows 64 Bit

 1.	Open the `MakeMexWindows.m` file.
 2.	Go to the `User Settings` section and edit the `msvcVersion` according to the predefined constants.
 3.	Update `mexCompFlags` for MEX Compilation flags. It won't have any significant performance gain as most of work is done in the GLPK Library.
 	In case of being unsure, just set `useCompFlags = OFF;` (Default).
 4.	Set the MEX API by `mexApi`.
 5.	Run the script. At the end it should verify the generated `MEX` file is working.

### Linux 64 Bit

 1.	Open the `MakeMexLinux.m` file.
 2.	Go to the `User Settings` section and edit the `cCompFlags`. For most cases the best choice is `-march=native`.  
 	I'd also recommend using `-O2`. I haven't checked `-fast-math`. In case of being unsure, just set `useCompFlags = OFF;` (Default).
 3.	Update `mexCompFlags` for MEX Compilation flags. It won't have any significant performance gain as most of work is done in the GLPK Library.
 	In case of being unsure, just set `useCompFlags = OFF;` (Default).
 4.	Set the MEX API by `mexApi`.
 5.	Run the script. At the end it should verify the generated `MEX` file is working.
 
### The MEX API

The MEX API, set by `mexApi` has importance related to the size of problems solved.  
The user should set it to either `{MEX_API_R2018A, MEX_API_R2017B, MEX_API_LARGE_ARRAY}`.  
In case of old MATLAB Installation, or compiling for others who might have older MATLAB one could try `MEX_API_COMPATIBLE_ARRAY`.  
Yet using `MEX_API_COMPATIBLE_ARRAY` will limit the problems to have roughly `2^31` elements. Check MATLAB documentation for more information.

### macOS

TBD

## Remarks

 1.	The procedure was tested on:
	*	Windows 10 64 Bit with MSVC 2017 Professional with MATLAB R2020a.
	*	Windows 10 64 Bit with MSVC 2019 Professional with MATLAB R2020a.
	*	Windows 10 64 Bit with MSVC 2019 Community with MATLAB R2020a.
	* 	Linux Mint 19.3 (Based on Ubuntu 18.04 LTS) with GCC 7.5.0 with MATLAB R2020a.
 2. Users with different Operating System (Specifically macOS), Please assist with issues.
