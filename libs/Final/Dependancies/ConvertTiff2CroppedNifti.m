function ConvertTiff2CroppedNifti(tiff_directory, nii_directory, bounding_box, overwrite_all)
%CONVERTTIFF2CROPPEDNIFTI converts tiff images into the NIfTI file format.
%
% ConvertTiff2Nifti(in_dir, out_dir, bounding_box, overwrite_all) 
%
% Part of the Cardiac Workflow project.
%
% This function can operate on a single file or on a directory. If given a
% directory, it will convert all .tif files to .nii files asking if a file
% should be overwritten if it exists. This function will also crop the
% nifti image before saving in according to the bounding_box.
%
% out_directory -- the output directory to save the images in. 
%
% bounding_box -- the bounding box to crop to in the form [ul_corner widths]
%       eg. [123, 139, 40, 100, 200, 50]
%
% overwrite_all -- optional parameter that will prevent repeated
% questioning about overwrites: if set to 1 it will silently overwrite
% files and if set to -1 it will skip converting files if an overwrite
% would occur.
%
% Uses functions from the "Tools for NIfTI and ANALYZE Images" toolbox
% written by Jimmy Shen on the Mathworks FEX:
% http://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
%
% Author: Travis Johnson
%         Molloi Lab
 
% Input checking and default arguments
if nargin < 2 
    nii_directory = '';
end
if nargin < 3
    bounding_box = [];
end
if nargin < 4
    overwrite_all = 0;
end
% Allow out_directory to be assigned to [] for the default of the pwd
if isempty(nii_directory)
    nii_directory = '';
end
% Ensure that the output directory ends in a filesep
if ~isempty(nii_directory) && (nii_directory(end) ~= filesep)
    nii_directory = [nii_directory filesep];
end

% Logic for file vs directory running and querying for overwrite
if ~isdir(tiff_directory) % If the input is a file
    file_name = tiff_directory;
    new_name = [nii_directory file_name(1:end-3) 'nii'];
    % Check that we don't overwrite a file that shouldn't be overwritten.
    [overwriteQ, overwrite_all] = QueryOverwrite(new_name, overwrite_all);%#ok<NASGU>
    % If we want to write to the file, do it
    if overwriteQ == true
        tiff2nifti(file_name, new_name);
%         converted_list{1} = new_name;
    else % Otherwise display that we did not convert
        disp(['ConvertTiff2Nifti: ' file_name ' not overwritten.']);
        return
    end
    
else % The file is a directory
    input_dir = tiff_directory;
    % Get all .tif filenames
    Dir = dir([input_dir filesep '*.tif']);
    filenames = {Dir.name};
    % Create the output directory if necessary
    if ~isempty(nii_directory) && ~exist(nii_directory, 'dir')
        if ~mkdir(nii_directory) 
            % Error if the output directory cannot be created.
            error(['Output directory ' nii_directory ' could not be created.']);
        end
    end
    % Iterate through the images and convert
%     converted_list = cell(length(filenames), 1);
    for file_idx = 1:length(filenames)
        % We don't want the batch process to quit if there is an error on a 
        % single file, so we use a try-catch statement
        try
            file_name = filenames{file_idx};
            % add the directory prefix for robustness
            new_name = [nii_directory file_name(1:end-3) 'nii'];
            file_name = [tiff_directory filesep file_name]; %#ok<AGROW>
            % Check that we don't overwrite a file that shouldn't be overwritten.
            [overwriteQ, overwrite_all] = QueryOverwrite(new_name, overwrite_all);
            if overwriteQ == true
                % Run the conversion function
                tiff2nifti(file_name, new_name);
%                 converted_list{file_idx} = new_name;
            else
                disp(['ConvertTiff2CroppedNifti: ' new_name ' not overwritten.']);
            end
        catch err
            % Escape backslashes to they aren't interpreted as control
            % sequences
            escaped_file_name = strrep(file_name, '\', '\\');
            fprintf(['ConvertTiff2CroppedNifti: ' escaped_file_name ' not converted due to the exception\n %s: %s\n'], err.identifier, err.message);
        end
    end

end

% Helper internal function which does the actual read and write
function tiff2nifti(in_fname, out_fname)
    % hardcoded voxel size is kinda ugly but extracting it from the tiff
    % header or ImageDescription tag seems iffy.
    voxel_size = [0.429 0.429 0.5];
   
    % Read the tiff stack data
    tiff = TiffStackRead(in_fname);
    % crop it if necessary
    if ~isempty(bounding_box)
        tiff = imcrop3D(tiff, bounding_box);
    end
    
    % Optionally transform the image?
    % Without this, the nifti image does not have the same orientation as
    % the inputted tiff when loaded in ImageJ. They are the same in Matlab
    % though
    % tiff = imtransform(tiff, maketform('affine', [[0 1 0]; [1 0 0]; [0 0 1]]));
    
    % Make a NIfTI image with the right voxel size
    nii = make_nii(tiff, voxel_size, [], 512 );
    nii.hdr.dime.xyzt_units = 2; % set the units to mm
    
    save_nii(nii, out_fname);
end % tiff2nifti function


end % Top level function