function MakeMexWindows(glpkVersion, msvcCommonToolsPath, options)
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
%   -   1.0.002     25/03/2022  Royi Avital
%       *   Added support for MSVC 2022 on MATLAB R2022a.
%       *   Added support for GLPK 5.0.
%   -   1.0.001     14/08/2020  Royi Avital
%       *   Fixed a bug with support for MSVC 2019.
%       *   Set the default compiler to be MSVC 2019.
%   -   1.0.000     30/04/2020  Royi Avital
%       *   First release version.
% ----------------------------------------------------------------------------------------------- %

arguments
    glpkVersion             (1,1)       string      {mustBeMember(glpkVersion, ["4.48","4.65","5.0"])}    = "4.48";
    msvcCommonToolsPath     (1,1)       string      = fullfile("C:","Program Files","Microsoft Visual Studio","2022","Community","Common7","Tools");
    options.MexApi          (1,1)       string      {mustBeMember(options.MexApi, ["-R2017b","-R2018a","-largeArrayDims","-compatibleArrayDims"])} = "-R2017b";
    options.UseCompFlags    (1,1)       logical     = false;
end

%% User Settings

% Requires CPU with AVX2, Might be faster
mexCompFlags    = ' /MT /O2 /Ob3 /Oi /arch:AVX2 ';
BUILD_BATCH_FILENAME    = 'Build_GLPK_MEX.bat';

%% Inner Settings

switch(glpkVersion)
    case("4.48")
        glpkString      = 'GLPK 4.48';
        glpkFileName    = 'glpk-4.48.tar.gz';
        glpkUrl         = 'https://ftp.gnu.org/gnu/glpk/glpk-4.48.tar.gz';
        glpkFolder      = 'glpk-4.48';
        mexFileName     = 'glpkcc_4.48.cpp';
        libFileName     = 'glpk.lib';
    case("4.65")
        glpkString      = 'GLPK 4.65';
        glpkFileName    = 'glpk-4.65.tar.gz';
        glpkUrl         = 'https://ftp.gnu.org/gnu/glpk/glpk-4.65.tar.gz';
        glpkFolder      = 'glpk-4.65';
        mexFileName     = 'glpkcc.cpp';
        libFileName     = 'glpk.lib';
    case("5.0")
        glpkString      = 'GLPK 5.00';
        glpkFileName    = 'glpk-5.0.tar.gz';
        glpkUrl         = 'https://ftp.gnu.org/gnu/glpk/glpk-5.0.tar.gz';
        glpkFolder      = 'glpk-5.0';
        mexFileName     = 'glpkcc.cpp';
        libFileName     = 'glpk.lib';
end

glpkWin64BuildFolder    = fullfile(glpkFolder, 'w64');
glpkSrcFolder           = fullfile(glpkFolder, 'src');

%% Downloading Data & Setting Environment

disp("Downloading " + glpkString + " from Official Site");
disp(" ");
websave(glpkFileName, glpkUrl);
disp("Unpacking the TAR File");
disp(" ");
untar(glpkFileName);

copyfile(BUILD_BATCH_FILENAME, glpkWin64BuildFolder);
currFolder  = cd(glpkWin64BuildFolder);
resetFolder = onCleanup(@() cd(currFolder));

%% Compilation

% Compiling the GLPK Library
disp("Compiling the GLPK Library");
disp(" ");
% TODO: Make the Batch File with support for input compiling flags ('cCompFlags')
[status,log] = system(sprintf('"%s/vsdevcmd.bat" -arch=x64 && %s', msvcCommonToolsPath, BUILD_BATCH_FILENAME));
assert(status == 0, "Failed to compile with message:\n%s", log)
cd(currFolder);

if(options.UseCompFlags)
    cCompFlags      = ['COMPFLAGS="$COMPFLAGS ', mexCompFlags, '"'];
else
    cCompFlags      = 'COMPFLAGS="$COMPFLAGS"';
end
includeFolder   = ['-I', fullfile(currFolder,glpkSrcFolder)];
libFolder       = ['-L', fullfile(currFolder,glpkWin64BuildFolder)];

disp("Compiling the MEX File");
disp(" ");

mex('-v', options.MexApi, cCompFlags, includeFolder, libFolder, mexFileName, libFileName);


% Verify
disp("Verifying the MEX File: If it shows ""MEX interface to GLPK Version " + glpkVersion + """ all worked!");
disp(" ");
glpkcc(); %<! Should display the version

clear("glpkcc"); %<! In order to remove the MEX from memory


%% Restore Defaults

% set(0, 'DefaultFigureWindowStyle', 'normal');
% set(0, 'DefaultAxesLooseInset', defaultLoosInset);

