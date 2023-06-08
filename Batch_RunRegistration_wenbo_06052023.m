%% 06/05/23
clear;
clc;
% addpath(genpath('\\POLARIS\Data4_New\Travis\MATLAB\libsTravis'));
% addpath(genpath('\\POLARIS\Data4_New\Travis\MATLAB\libsFEX'));

BB = [3, 124, 1, 477, 316, 829];

% Find all acqs' dirs under "with_motion" dir
fprintf('\nStep 1: Locating acquisition(s)...\n')
studys_dir = '.\with_motion\';
all_dirs_under_study_dir = dir(studys_dir);
dirFlags = [all_dirs_under_study_dir.isdir];
subDirs = all_dirs_under_study_dir(dirFlags);
acqs_dir = {subDirs(3:end).name};
for idx = 1 : numel(acqs_dir)
    fprintf('\tAcquisition found: "%s"\n', acqs_dir{idx})
    acqs_dir{idx} = [studys_dir acqs_dir{idx}];
end

% Define master directory to register all others against.
fprintf('\nStep 2: Locating the reference acquisition...\n')
master_dir = '.\reference_acq\';
all_dirs_under_ref_dir = dir(master_dir);
dirFlags = [all_dirs_under_ref_dir.isdir];
subDirs = all_dirs_under_ref_dir(dirFlags);
ref_dirs = {subDirs(3:end).name};
if (size(ref_dirs, 1) * size(ref_dirs, 2) ~= 1)
    fprintf('\tError: Number of reference acquisition is not 1!\nExiting...\n')
    return
end
fprintf('\tAcquisition found: "%s"\n', ref_dirs{1})
ref_dir = [master_dir ref_dirs{1}];

% Run registration
reference_fname = 'nii1'; 

fprintf('\nStep 3: Running registration\n')
for idx = 1 : numel(acqs_dir)
    fprintf('\t On acquisition "%s"...\n', acqs_dir{idx})
    try
        acq_dir = acqs_dir{idx};
        RunRegistrationDICOM_mod(acq_dir, ref_dir, reference_fname, BB)
    catch exception
        message = sprintf(['Batch_RunRegistration: Error occured while '...
               'processing %s.\n Error message: %s.'],...
               acq_dir, exception.message);
        disp(message);
    end
end