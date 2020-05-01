% ----------------------------------------------------------------------------------------------- %
% MakeMex - Generating Linux x64 MEX File for GLPK
% Generates the MEX file of GLPK for Linux x64 system by downloading GLPK
% 4.65, Unpacking it, Compiling it and Compiling the MEX.
% Reference:
%   1. See https://github.com/blegat/glpkmex.
% Remarks:
%   1.  Was verified on Linux Mint 19.3 (Based on Ubuntu 18.04 LTS) with
%       GCC 7.5.0.
% TODO:
%   1.  A
%   Release Notes:
%   -   1.0.000     01/05/2020  Royi Avital
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

MEX_API_R2018A              = '-R2018a'; %<! Large Arrays (64 Bit Indices), Interleaved Complex Arrays
MEX_API_R2017B              = '-R2017b'; %<! Large Arrays (64 Bit Indices), Separate Complex Arrays
MEX_API_LARGE_ARRAY         = '-largeArrayDims'; %<! Large Arrays (64 Bit Indices), Separate Complex Arrays (Basically like R2017b)
MEX_API_COMPATIBLE_ARRAY    = '-compatibleArrayDims'; %<! 32 Bit Indices, Separate Complex Arrays

glpkFileName    = 'glpk-4.65.tar.gz';
glpkUrl         = 'https://ftp.gnu.org/gnu/glpk/glpk-4.65.tar.gz';
glpkFolder      = 'glpk-4.65';
mexFileName     = 'glpkcc.cpp';
libFileName     = 'libglpk.a';


%% User Settings

% Requires CPU with AVX2, Might be faster
cCompFlags      = '-O2 -mavx2';
mexCompFlags    = '-Ofast -mavx2';

useCompFlags    = OFF;
% Add support for arrays larger than ~2^31 elements (MEX_API_R2018A,
% MEX_API_R2018A, MEX_API_LARGE_ARRAY)
mexApi          = MEX_API_R2017B;


%% Inner Settings

glpkBuildFolder     = [glpkFolder, FILE_SEP];
glpkSrcFolder       = [glpkFolder, FILE_SEP, 'src', FILE_SEP];
workingFolderPath   = [pwd(), FILE_SEP];


%% Downloading Data & Setting Environment

disp(['Downloading GLPK 4.65 from Official Site']);
disp([' ']);
glpkFilePath    = websave(glpkFileName, glpkUrl);
disp(['Unpacking the TAR File']);
disp([' ']);
cFileNames      = untar(glpkFileName);

currFolder = cd(glpkBuildFolder);


%% Compilation

% Compiling the GLPK Library
disp(['Compiling the GLPK Library']);
disp([' ']);
if(useCompFlags == ON)
    cFlags = cCompFlags;
else
    cFlags = [];
end

system('./configure');
% The flag '-fPIC' is a must in order to statically link the EMX to the
% GLPK Library
system(['make CFLAGS="$CFLAGS -fPIC ', cFlags, '"']);

disp(['Checking the Compilation of the GLPK Library: If it shows "OPTIMAL LP SOLUTION FOUND" all worked!']);
disp([' ']);
system(['make check']);

cd(currFolder);

if(useCompFlags == ON)
    mexCompFlags      = ['CFLAGS=$CFLAGS ', mexCompFlags];
else
    mexCompFlags      = ['CFLAGS=$CFLAGS'];
end
includeFolder   = ['-I', glpkSrcFolder];
libFilePath     = [glpkSrcFolder, FILE_SEP, '.libs', FILE_SEP, libFileName];

disp(['Compiling the MEX File']);
disp([' ']);

mex('-v', mexApi, mexCompFlags, includeFolder, mexFileName, libFilePath);
% mex 'glpkcc.cpp' -Lglpk-4.65/src -Iglpk-4.65/src -lglpk
% 
% mex 'glpkcc.cpp' 'glpk-4.65/src/.libs/libglpk.a' -Iglpk-4.65/src
% mex -Iglpk-4.65/src glpkcc.cpp glpk-4.65/src/.libs/libglpk.a


% Verify
disp(['Verifying the MEX File: If it shows "MEX interface to GLPK Version 4.65" all worked!']);
disp([' ']);
glpkcc(); %<! Should display the version

clear('all'); %<! In order to remove the MEX from memory


%% Restore Defaults

% set(0, 'DefaultFigureWindowStyle', 'normal');
% set(0, 'DefaultAxesLooseInset', defaultLoosInset);

