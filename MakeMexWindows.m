% ----------------------------------------------------------------------------------------------- %
% MakeMex - Generating Windows x64 MEX File for GLPK
% Generates the MEX file of GLPK for Windows x64 system by downloading GLPK
% 4.65, Unpacking it, Compiling it and Compiling the MEX.
% Reference:
%   1. See https://github.com/blegat/glpkmex.
% Remarks:
%   1.  Was verified on computer with MSVC 2017 Professional. For other
%       compilers (Community edition or different version) please update
%       'MSVC_xxx_COMMON_TOOLS_PATH'. 
% TODO:
%   1.  A
%   Release Notes:
%   -   1.0.003     23/11/2022  Royi Avital
%       *   Fixed issue with displaying the correct version of GLPK in `Verify`.
%   -   1.0.002     25/03/2022  Royi Avital
%       *   Added support for MSVC 2022 on MATLAB R2022a.
%       *   Added support for GLPK 5.0.
%   -   1.0.001     14/08/2020  Royi Avital
%       *   Fixed a bug with support for MSVC 2019.
%       *   Set the default compiler to be MSVC 2019.
%   -   1.0.000     30/04/2020  Royi Avital
%       *   First release version.
% ----------------------------------------------------------------------------------------------- %


%% Setting Environment Parameters

close('all');
clear('all');
clc();

FALSE   = 0;
TRUE    = 1;

OFF     = 0;
ON      = 1;

FILE_SEP = filesep();
PATH_SEP = pathsep();

MSVC_VERSION_150_PROFESSIONAL   = 1; %<! MSVC 2017 Professtional Edition
MSVC_VERSION_150_COMMUNITY      = 2; %<! MSVC 2019 Community Edition
MSVC_VERSION_160_PROFESSIONAL   = 3; %<! MSVC 2019 Professional Edition
MSVC_VERSION_160_COMMUNITY      = 4; %<! MSVC 2019 Community Edition
MSVC_VERSION_170_PROFESSIONAL   = 5; %<! MSVC 2022 Professional Edition
MSVC_VERSION_170_COMMUNITY      = 6; %<! MSVC 2022 Community Edition

MSVC_150_PROFESSIONAL_COMMON_TOOLS_PATH = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\Tools\';
MSVC_150_COMMUNITY_COMMON_TOOLS_PATH    = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\';
MSVC_160_PROFESSIONAL_COMMON_TOOLS_PATH = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\Tools\';
MSVC_160_COMMUNITY_COMMON_TOOLS_PATH    = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\';
MSVC_170_PROFESSIONAL_COMMON_TOOLS_PATH = 'C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\';
MSVC_170_COMMUNITY_COMMON_TOOLS_PATH    = 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\';

BUILD_BATCH_FILENAME    = 'Build_GLPK_MEX.bat';

MEX_API_R2018A              = '-R2018a'; %<! Large Arrays (64 Bit Indices), Interleaved Complex Arrays
MEX_API_R2017B              = '-R2017b'; %<! Large Arrays (64 Bit Indices), Separate Complex Arrays
MEX_API_LARGE_ARRAY         = '-largeArrayDims'; %<! Large Arrays (64 Bit Indices), Separate Complex Arrays (Basically like R2017b)
MEX_API_COMPATIBLE_ARRAY    = '-compatibleArrayDims'; %<! 32 Bit Indices, Separate Complex Arrays

GLPK_VERSION_4_65 = 1;
GLPK_VERSION_5_00 = 2;

cGlpkVersion = {['4.65'], ['5.0']};


%% User Settings

glpkVersion = GLPK_VERSION_5_00;

msvcVersion     = MSVC_VERSION_170_PROFESSIONAL;

% Requires CPU with AVX2, Might be faster
cCompFlags      = ' /MT /O2 /Ob3 /Oi /arch:AVX2 ';
mexCompFlags    = ' /MT /O2 /Ob3 /Oi /arch:AVX2 ';

% Use the default
useCompFlags    = OFF;
% Add support for arrays larger than ~2^31 elements (MEX_API_R2018A,
% MEX_API_R2018A, MEX_API_LARGE_ARRAY)
mexApi          = MEX_API_R2017B;


%% Inner Settings

switch(glpkVersion)
    case(GLPK_VERSION_4_65)
        glpkString      = 'GLPK 4.65';
        glpkFileName    = 'glpk-4.65.tar.gz';
        glpkUrl         = 'https://ftp.gnu.org/gnu/glpk/glpk-4.65.tar.gz';
        glpkFolder      = 'glpk-4.65';
        mexFileName     = 'glpkcc.cpp';
        libFileName     = 'glpk.lib';
    case(GLPK_VERSION_5_00)
        glpkString      = 'GLPK 5.00';
        glpkFileName    = 'glpk-5.0.tar.gz';
        glpkUrl         = 'https://ftp.gnu.org/gnu/glpk/glpk-5.0.tar.gz';
        glpkFolder      = 'glpk-5.0';
        mexFileName     = 'glpkcc.cpp';
        libFileName     = 'glpk.lib';
end

switch(msvcVersion)
    case(MSVC_VERSION_150_PROFESSIONAL)
        msvcCommonToolsPath = MSVC_150_PROFESSIONAL_COMMON_TOOLS_PATH;
    case(MSVC_VERSION_150_COMMUNITY)
        msvcCommonToolsPath = MSVC_150_COMMUNITY_COMMON_TOOLS_PATH;
    case(MSVC_VERSION_160_PROFESSIONAL)
        msvcCommonToolsPath = MSVC_160_PROFESSIONAL_COMMON_TOOLS_PATH;
    case(MSVC_VERSION_160_COMMUNITY)
        msvcCommonToolsPath = MSVC_160_COMMUNITY_COMMON_TOOLS_PATH;
    case(MSVC_VERSION_170_PROFESSIONAL)
        msvcCommonToolsPath = MSVC_170_PROFESSIONAL_COMMON_TOOLS_PATH;
    case(MSVC_VERSION_170_COMMUNITY)
        msvcCommonToolsPath = MSVC_170_COMMUNITY_COMMON_TOOLS_PATH;
end

glpkWin64BuildFolder    = [glpkFolder, FILE_SEP, 'w64', FILE_SEP];
glpkSrcFolder           = [glpkFolder, FILE_SEP, 'src', FILE_SEP];
workingFolderPath       = [pwd(), FILE_SEP];


%% Downloading Data & Setting Environment

disp(['Downloading ', glpkString, ' from Official Site']);
disp([' ']);
glpkFilePath    = websave(glpkFileName, glpkUrl);
disp(['Unpacking the TAR File']);
disp([' ']);
cFileNames      = untar(glpkFileName);

copyfile(BUILD_BATCH_FILENAME, glpkWin64BuildFolder);
currFolder = cd(glpkWin64BuildFolder);


%% Compilation

% Compiling the GLPK Library
disp(['Compiling the GLPK Library']);
disp([' ']);
% TODO: Make the Batch File with support for input compiling flags ('cCompFlags')
system(['"', msvcCommonToolsPath, 'vsdevcmd.bat" -arch=x64 && ', BUILD_BATCH_FILENAME]);
cd(currFolder);

if(useCompFlags == ON)
    cCompFlags      = ['COMPFLAGS="$COMPFLAGS ', mexCompFlags, '"'];
else
    cCompFlags      = ['COMPFLAGS="$COMPFLAGS"'];
end
includeFolder   = ['-I', glpkSrcFolder];
libFolder       = ['-L', glpkWin64BuildFolder];

disp(['Compiling the MEX File']);
disp([' ']);

mex('-v', mexApi, cCompFlags, includeFolder, libFolder, mexFileName, libFileName);


% Verify
disp(['Verifying the MEX File: If it shows "MEX interface to GLPK Version ', cGlpkVersion{glpkVersion}, '" all worked!']);
disp([' ']);
glpkcc(); %<! Should display the version

clear('all'); %<! In order to remove the MEX from memory


%% Restore Defaults

% set(0, 'DefaultFigureWindowStyle', 'normal');
% set(0, 'DefaultAxesLooseInset', defaultLoosInset);

