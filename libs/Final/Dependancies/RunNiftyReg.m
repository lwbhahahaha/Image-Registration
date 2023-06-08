function RunNiftyReg(nii_directory, reg_directory, reference_fname, f3d_opts)
%RUNNIFTYREG Runs the NiftyReg registration program on a directory of
% files, transforming them to match the reference image passed in.
%
% Part of the Cardiac Workflow Project
%

% make sure that the reference filename ends in nii taking care to allow
% for no file extension or ".tif" just in case.
% All the following inputs are acceptable: "t98.nii", "t98", "t98.tif"
if ~strcmp(reference_fname(end-2:end), 'nii')
    % mathces non . characters from the beginning of the line
    base_name = regexp(reference_fname, '^[^.]*', 'match');
    reference_fname = strcat(base_name{1}, '.nii');
end

nii_dir = dir( [nii_directory filesep '*.nii'] );
file_names = {nii_dir.name};

for idx = 1 : numel(file_names) 
    tic
  try
    floating_fname = file_names{idx};
% Better to just let the image be self-registered so that it is not
% processed differently than the others.
%     % copy file if it is the reference image
%     if strcmpi(floating_fname, reference_fname)
%         % Construct the new name to match what is done in Call_Niftyreg
%         base_name = floating_fname(1:end-4);
%         output_fname = strcat(reg_directory, filesep, 'reg_f3d_', base_name, '.nii');
%         copyfile([nii_directory filesep floating_fname], output_fname);
%         continue
%     end
    % Construct the path names for the transformation files so that we can
    % check whether or not to run NiftyReg.
    affine_file = strcat('"', reg_directory, filesep, 'params', filesep, 'aff_', floating_fname(1:end-4), '.txt"');
    output_cpp  = strcat('"', reg_directory, filesep, 'params', filesep, 'cpp_', floating_fname(1:end-4), '.nii"');
    % Run the affine registration first
    if ~exist(affine_file(2:end-1), 'file') % have to remove the " from either side
        Call_Niftyreg('aladin', reference_fname, floating_fname, nii_directory, reg_directory);
    else
        fprintf('Skipping aladin for %s: aff file detected.\n', floating_fname);
    end
    % Followed by the deformable registration
    if ~exist(output_cpp(2:end-1), 'file') % have to remove the " from either side
        Call_Niftyreg('f3d', reference_fname, floating_fname, nii_directory, reg_directory, f3d_opts);
    else
        fprintf('Skipping f3d for %s: cpp file detected.\n', floating_fname);
    end
  catch
     fprintf('Error occured for file %s.\n', floating_fname);
  end
    fprintf('Completed %s in %d s.\n', floating_fname, round(toc));
end

%% Delete the aladin images
aladin_dir = dir( [reg_directory filesep '*aladin*.nii'] );
aladin_file_names = {aladin_dir.name};

for idx = 1 : numel(aladin_file_names)
    fname = aladin_file_names{idx};
    delete(strcat(reg_directory, filesep, fname)); 
end

% %% Move the aladin files into their own folder in the reg directory
% aladin_directory = strcat(reg_directory, filesep, 'aladin');
% if ~exist(aladin_directory, 'dir')
%     mkdir(aladin_directory);
% end
% 
% aladin_dir = dir( [reg_directory filesep '*aladin*.nii'] );
% aladin_file_names = {aladin_dir.name};
% 
% for idx = 1 : numel(aladin_file_names)
%     fname = aladin_file_names{idx};
%     movefile([reg_directory filesep fname],[aladin_directory filesep fname]); 
% end