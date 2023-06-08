function Call_Niftyreg_mod(program, target_nii, floating_nii, master_dir, in_dir, out_dir, more_opts)
%CALL_NIFTYREG Calls the image registration programs of Nifty Reg.
%
% Call_Niftyreg(program, target_nii, floating_nii, in_dir, out_dir, more_opts)
%  * program -- can be either "aladin" for affine registration or "f3d" for
%    deformable registration.
%  * target_nii -- filename of the target / reference NIfTI image
%  * floating_nii -- filename of the NIfTI image to be registered
%  * master_dir -- directory containing ref volume to be usedi in
%  registeration.
%  * in_dir -- directory containing the input NIfTI format images
%  * out_dir -- directory to save information about the transformations and
%               the registered images
%  * opts_str -- string with additional flags / command line parameters to
%                be passed to the program
%
% Author: Travis Johnson
%         Molloi Lab Group

% ***********************************
% The variables below may need to be changed depending on the computer this
% program is ran on.
% ***********************************
nifty_reg_path  = '.\libs\niftyReg\nift_reg_app\bin';
reg_aladin_path = [nifty_reg_path filesep 'reg_aladin.exe'];
reg_f3d_path    = [nifty_reg_path filesep 'reg_f3d.exe'];

% Input checking and default values
% narginchk(3, 6)
if nargin < 4 || isempty(in_dir)
    in_dir  = pwd;
end
if nargin < 5 || isempty(out_dir)
    out_dir = pwd;
end
if nargin < 6
    more_opts = '';
end

% Ensure that the input directory ends in a filesep
if in_dir(end) ~= filesep
    in_dir = [in_dir filesep];
end
% Ensure that the output directory ends in a filesep
if out_dir(end) ~= filesep
    out_dir = [out_dir filesep];
end

% Determine which program is to be ran
if strcmpi(program, 'aladin')
    exe_string = reg_aladin_path;
elseif strcmpi(program, 'f3d')
    exe_string = reg_f3d_path;
else
    error(['Call_Niftyreg: The input "program" must be either "aladin" for '...
           'affine registration, or "f3d" for deformable registration.']);
end

% make directories if necessary
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end
if ~exist([out_dir, 'params'], 'dir')
    mkdir([out_dir, 'params']);
end

% My file naming convention for outputs
base_name = floating_nii(1:end-4);
affine_file = strcat('"', out_dir, 'params', filesep, 'aff_', base_name, '.txt"');
output_cpp  = strcat('"', out_dir, 'params', filesep, 'cpp_', base_name, '.nii"');
output_nii  = strcat('"', out_dir, 'reg_', program, '_', base_name, '.nii"');

% Create the options string
opts_string = [' -ref ' ['"' master_dir 'REGISTERED\nii\' floating_nii '"'] ' -flo ' ['"' in_dir floating_nii '"'] ...
               ' -aff ' affine_file ' -res ' output_nii ];

% Additional options if running f3d
if strcmpi(program, 'f3d')
    opts_string = [opts_string ' -cpp ' output_cpp];
end

% Additional options passed in by the user
opts_string = [opts_string ' ' more_opts];

disp(['[Call_Niftyreg]: ' exe_string opts_string]);
system(['start /WAIT ' exe_string opts_string]);
pause(.1);