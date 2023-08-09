function MakeMexLinux(glpkVersion, options)
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
%
% MexApi
%   * -R2018a : Large Arrays (64 Bit Indices), Interleaved Complex Arrays
%   * -R2017b : Large Arrays (64 Bit Indices), Separate Complex Arrays
%   * -largeArrayDims : Large Arrays (64 Bit Indices), Separate Complex Arrays (Basically like R2017b)
%   * -compatibleArrayDims : 32 Bit Indices, Separate Complex Arrays
%
% ----------------------------------------------------------------------------------------------- %

arguments
    glpkVersion             (1,1)       string      {mustBeMember(glpkVersion, ["4.48","4.65","5.0"])}    = "4.48";
    options.MexApi          (1,1)       string      {mustBeMember(options.MexApi, ["-R2017b","-R2018a","-largeArrayDims","-compatibleArrayDims"])} = "-R2017b";
    options.UseCompFlags    (1,1)       logical     = false;
end

%% Setting Environment Parameters

glpkFileName    = "glpk-" + glpkVersion + ".tar.gz";
glpkUrl         = "https://ftp.gnu.org/gnu/glpk/glpk-" + glpkVersion + ".tar.gz";
glpkFolder      = "glpk-" + glpkVersion;
if glpkVersion == "4.48"
    mexFileName     = 'glpkcc_4.48.cpp';
else
    mexFileName     = 'glpkcc.cpp';
end

%% User Settings

% Requires CPU with AVX2, Might be faster
cCompFlags      = '-O2 -mavx2';
mexCompFlags    = '-Ofast -mavx2';

%% Inner Settings

glpkBuildFolder = glpkFolder;
glpkSrcFolder   = fullfile(glpkFolder, 'src');
libFileName     = 'libglpk.a';

%% Downloading Data & Setting Environment

disp("Downloading GLPK " + glpkVersion + " from Official Site");
disp(" ");
websave(glpkFileName, glpkUrl);
disp("Unpacking the TAR File");
disp(" ");
untar(glpkFileName);

currFolder = cd(glpkBuildFolder);


%% Compilation

% Compiling the GLPK Library
disp("Compiling the GLPK Library");
disp(" ");
if(options.UseCompFlags)
    cFlags = cCompFlags;
else
    cFlags = '';
end

[status,log] = system('./configure');
assert(status == 0, "Failed to configure with message:\n%s", log)
% The flag '-fPIC' is a must in order to statically link the EMX to the
% GLPK Library
[status,log] = system(['make CFLAGS="$CFLAGS -fPIC ', cFlags, '"']);
assert(status == 0, "Failed to compile with message:\n%s", log)

disp("Checking the Compilation of the GLPK Library: If it shows ""OPTIMAL LP SOLUTION FOUND"" all worked!");
disp(" ");
[status,log] = system('make check');
assert(status == 0, "Failed to check with message:\n%s", log)

cd(currFolder);

if(options.UseCompFlags)
    mexCompFlags      = ['CFLAGS=$CFLAGS ', mexCompFlags];
else
    mexCompFlags      = 'CFLAGS=$CFLAGS';
end
includeFolder   = ['-I', char(glpkSrcFolder)];
libFilePath     = char(fullfile(glpkSrcFolder, '.libs', libFileName));

disp("Compiling the MEX File");
disp(" ");

mex('-v', options.MexApi, mexCompFlags, includeFolder, mexFileName, libFilePath);

% Verify
disp("Verifying the MEX File: If it shows ""MEX interface to GLPK Version " + glpkVersion + """ all worked!");
disp(" ");
glpkcc(); %<! Should display the version

clear("glpkcc"); %<! In order to remove the MEX from memory


%% Restore Defaults

% set(0, 'DefaultFigureWindowStyle', 'normal');
% set(0, 'DefaultAxesLooseInset', defaultLoosInset);

