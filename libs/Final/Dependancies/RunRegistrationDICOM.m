function RunRegistrationDICOM(base_directory, reference_fname, dicom_relpath, MIP_relpath, output_relpath)
%RUNREGSITRATION Encapsulates the workflow for registering a data set
%
% RunRegistration(base_directory, reference_fname, 
%                   tiff_relpath, MIP_relpath, output_relpath)
%
% INPUTS:
%  base_directory -- full path to the base directory of the data set
%  reference_fname -- name of the reference image, e.g. 't23'
%  tiff_relpath -- relative path (from base) to the input tiff directory
%       Default: 'tiff'
%  MIP_relpath -- relative path (from base) to the .mat file of the cropped
%                  mip. Default: 'CROP\MIP_CROPPED.mat'
%  output_relpath -- relative path (from base) to the output directory
%       Default: 'REGISTERED'
% 
%
% This function must be executed on a machine with a CUDA enabled GPU such
% as Antares or Wezen.
%
% Author: Travis Johnson
%         Molloi Lab

%% Inputs and Input Checking

if nargin < 2
    error('The base directory and reference image name are required inputs.');
end
if nargin < 3
    dicom_relpath = 'DICOM';
end
if nargin < 4
    MIP_relpath = 'CROP\MIP_CROPPED.mat';
end
if nargin < 5
    output_relpath = 'REGISTERED';
end

% ensure base_directory ends in a filesep for convenience
if (base_directory(end) ~= filesep)
    base_directory = strcat(base_directory, filesep);
end

% Directory of the tiff images that are to be registered
dicom_directory = strcat(base_directory, dicom_relpath);
% .mat file with the previously generated MIP to get a bounding box from
MIP_path = strcat(base_directory, MIP_relpath);
% Directory into which we will write the registered images and such
out_directory = strcat(base_directory, output_relpath);

% ensure out_directory ends in a filesep for convenience
if (out_directory(end) ~= filesep)
    out_directory = strcat(out_directory, filesep);
end
% create the output directory if necessary
if ~exist(out_directory, 'dir')
    mkdir(out_directory);
end

% Construct the names of the various directories that will be created
nii_directory = strcat(out_directory, 'nii');
reg_directory = strcat(out_directory, 'reg');
new_tiff_directory = strcat(out_directory, 'tif');

%% Run this to set up paths if they are not already set up
% if ~exist('RunNiftyReg.m', 'file')
%     addpath(genpath('\\polaris.radsci.uci.edu\Data4_New\Travis\MATLAB\libsTravis'));
%     addpath(genpath('\\polaris.radsci.uci.edu\Data4_New\Travis\MATLAB\libsFEX'));
%     addpath(genpath('\\polaris.radsci.uci.edu\Data4_New\Travis\MATLAB\Projects\CardiacWorkflow'));
% end

%% Load the unregistered cropped MIP
warning('YOU HARDCODED THE BB IN THE CODE');
if ~exist(strcat(out_directory, 'BB.mat'), 'file')
    disp('RunRegistration: Reading in the MIP.');
    load(MIP_path, 'mipStack');
    % Compute the bounding box for the cropped mip
    %[~, BB] = MaxConnComp(mipStack ~= 0); %#ok<NODEF>
    % Expand the BB a bit to avoid influence of the edge effects 
%     BB = ExpandRect(BB, 5);
    BB = [100, 150, 10, 301, 226, 301];

    % save this bounding box
    save(strcat(out_directory, 'BB.mat'), 'BB');
else
    disp('RunRegistration: BB.mat found, loading from file.');
    load(strcat(out_directory, 'BB.mat'), 'BB');
    BB = [100, 150, 10, 301, 226, 301];
end
%% Perfrom the conversion from tiff to cropped nifti
disp('RunRegistration: Converting from DICOM to NIfTI.');
ConvertDICOM2CroppedNifti(dicom_directory, nii_directory, BB, -1);

%% Run the registration program on all the files
disp('RunRegistration: Running the registration program.');

% extra command line options to the registration program
%   -gpu   uses the GPU accelerated version of the code
%   -sx -3 sets the finale control point spacing to 3 pixels (negative = pixels)
%   -jl .3 adds a jacobian norm term to the energy function to help reduce
%           unwanted expansion of high intensity pixels near the wires
extra_f3d_opts = ' -gpu -sx -3 -jl .3 ';
RunNiftyReg(nii_directory, reg_directory, reference_fname, extra_f3d_opts);


%% Convert back to full size tiff and concurrently compute the MIP
disp('RunRegistration: Converting from NIfTI back to Tiff and computting the MIP.');

mipStack = ConvertNifti2FullTiff(reg_directory, new_tiff_directory, BB, -1);

% write the newly mip'ed image if necessary
mip_fname = strcat(out_directory, 'reg_MIP.mat');
overwriteQ = QueryOverwrite(mip_fname, -1);
if overwriteQ == true
    % adjust for unsigned -> signed
    mipStack = double(mipStack); % - 32768; %#ok<NASGU>
    save(mip_fname, 'mipStack');
else
    disp(['RunRegistration: ' mip_fname ' not overwritten.']);
end