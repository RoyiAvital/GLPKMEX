[![Visitors](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FRoyiAvital%2FStackExchangeCodes&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors+%28Daily+%2F+Total%29&edge_flat=false)](https://github.com/RoyiAvital/GLPKMEX)
<a href="https://liberapay.com/Royi/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a>

# GLPKMEX

[![View GLPKMEX - GNU Linear Programming Kit (GLPK) MEX Generator on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/75318-glpkmex-gnu-linear-programming-kit-glpk-mex-generator)

GLPKMEX is a MATLAB MEX Interface for the [GLPK Library](https://www.gnu.org/software/glpk/) developed by Andrew Makhorin.  
GLPKMEX is developed by Nicolo' Giorgetti (Email: giorgetti at ieee.org).  
GLPK is currently being maintained by Niels Klitgord (Email: niels at bu.edu).  

This version of GLPK MEX Generator is maintained by Royi Avital.  
It is based on [`glpkmex`](https://github.com/blegat/glpkmex) by Benoit Legat.  
It was updated to support the `4.65` and `5.0` versions of GLPK (Latest as of March 2022).

### Update 09/08/2023 (fork as odufour-mw)

- Convert the scripts into functions (update the instructions, see below)
- Add support to GLPK 4.48


## Instructions for Compiling MEX from Source

This MEX Generator builds a *Stand Alone* MEX File by linking to the static library of GLPK.  
This means the MEX file can be transferred to other computers and should work there.  
In order to use this generator download the repository and extract it any place.  
Then open a MATLAB session and navigate MATLAB to the folder the repository was extracted to and follow the instructions.

## System Requirements

 1.	A working MATLAB installation with `MEX` compiler set.
 2.	A Compiler:
 	*	Windows: MSVC 2022 (MSVC 2017 and MSVC 2019 should work but not tested)
	*	Linux: GCC 6.3 and above.

### Windows 64 Bit

Run the `MakeMexWindows` function passing the GLPK version to compile.

Example: `>> MakeMexWindows("5.0")`

### Linux 64 Bit

Run the `MakeMexLinux` function passing the GLPK version to compile.

Example: `>> MakeMexLinux("5.0")`

### MakeMex* options

- GLPK version (1st input) : "4.48" or "4.65" or "5.0"
- msvcCommonToolsPath (name-value, Windows only) : Path to Visual Studio Common Tools folder (default: C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools)
- MexApi (name-value) : "-R2017b" or "-R2018a" or "-largeArrayDims" or "-compatibleArrayDims" (default: -R2017b)
- UseCompFlags (name-value) : true or false, Add "COMPFLAGS" in compilation command for compiling the MEX (default: false)

#### Syntax examples

```
>> MakeMexWindows("4.65")
>> MakeMexLinux("5.0")
>> MakeMexWindows("4.65", msvcCommonToolsPath="C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools")
>> MakeMexLinux("4.48", MexApi="-R2017b", UseCompFlags=false)
```
 
### The MEX API

The MEX API, set by `MexApi` has importance related to the size of problems solved.  
The user should set it to either `{-R2018a, -R2017b, -largeArrayDims}`.  
In case of old MATLAB Installation, or compiling for others who might have older MATLAB one could try `-compatibleArrayDims`.  
Yet using `-compatibleArrayDims` will limit the problems to have roughly `2^31` elements. Check MATLAB documentation for more information.

## Remarks

 1.	The procedure was tested on:
	*	Windows 11 64 Bit with MSVC 2022 Professional with MATLAB R2023a.
	* 	Ubuntu 20.04 with GCC 9.4.0 with MATLAB R2023a.
