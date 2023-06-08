function MIP = ConvertNifti2FullTiff(nii_directory, tiff_directory, bounding_box, overwrite_all)
%CONVERTNIFTI2FULLTIFF Converts cropped NIfTI images into full size tiffs.
%   Also computes the MIP of the tiff images while they are in memory.
%
% mipStack = ConvertNifti2FullTiff(in_dir, out_dir, bounding_box, overwrite_all)
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
% bounding_box -- the bounding box of the embedded nifti image to in the
%   form [ul_corner widths]  ex. [123, 139, 40, 100, 200, 50]
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
    tiff_directory = [];
end
if nargin < 3
    bounding_box = [];
end
if nargin < 4
    overwrite_all = 0;
end
% Allow out_directory to be assigned to [] for the default of the pwd
if isempty(tiff_directory)
    tiff_directory = '';
end
% Ensure that the output directory ends in a filesep
if ~isempty(tiff_directory) && (tiff_directory(end) ~= filesep)
    tiff_directory = [tiff_directory filesep];
end

% The full size tiff image into which we will embbed the cropped nifti
full_size = [512, 512, 320];
% Parse out the min and max information from the bounding_box
if ~isempty(bounding_box)
    xmin = bounding_box(1);
    xmax = xmin + bounding_box(1+3)-1;
    
    ymin = bounding_box(2);
    ymax = ymin + bounding_box(2+3)-1;
    
    zmin = bounding_box(3);
    zmax = zmin + bounding_box(3+3)-1;
end

% Set to negative infinity until it is set to actual data using the max()
% function
MIP = -Inf;

if ~isdir(nii_directory) % If the input is a file
    file_name = nii_directory;
    new_name = [tiff_directory file_name(1:end-3) 'tif'];
    
    MIP = nifti2tiff(file_name, new_name);
    
else % The file is a directory
    dir_name = nii_directory;
    % Get all .nii filenames
    Dir = dir([dir_name filesep '*.nii']);
    filenames = {Dir.name};
    % Create the output directory if necessary
    if ~isempty(tiff_directory) && ~exist(tiff_directory, 'dir')
        if ~mkdir(tiff_directory)
            % Error if the output directory cannot be created.
            error(['Output directory ' tiff_directory ' could not be created.']);
        end
    end
    % Iterate through the images and convert
    for file_idx = 1:length(filenames)
        % We don't want the batch process to quit if there is an error on a
        % single file, so we use a try-catch statement
        try
            file_name = filenames{file_idx};
            % add the directory prefixes
            new_name = [tiff_directory file_name(1:end-3) 'tif'];
            file_name = [dir_name filesep file_name];%#ok<AGROW>
            % read in the image data and convert if necessary
            image_data = nifti2tiff(file_name, new_name);
            % update the MIP
            MIP = max(MIP, image_data);
            disp(['ConvertNifti2Tiff: ' new_name ' was created.']);
        catch err
            % Escape backslashes in file_name so they aren't interpreted as
            % control sequences
            escaped_file_name = strrep(file_name, '\', '\\');
            fprintf(['ConvertNifti2Tiff: ' escaped_file_name ' not converted due to the exception %s:%s\n'], err.identifier, err.message);
        end
    end
    
end

% Internal function which does the actual read conversion and write
    function data = nifti2tiff(in_fname, out_fname)
        % Read the nifti stack
        nii = load_nii(in_fname);
        
        if ~isempty(bounding_box)
            % Embed the nii data into a larger array that is filled with -2048 to
            % match the background of the original data
            data = ones(full_size) .* 30720;
            data(ymin:ymax, xmin:xmax, zmin:zmax) = nii.img;
        else
            % No changes or embedding of the data
            data = nii.img;
        end
        % Check if we are to overwrite the file
        [overwriteQ, overwrite_all] = QueryOverwrite(new_name, overwrite_all);
        % If we want to write to the file, do it, else don't and display a message.
        if overwriteQ == true
            TiffStackWrite(uint16(data), out_fname);
            
        else
            disp(['ConvertNifti2Tiff: ' new_name ' not overwritten.']);
        end
    end % nifti2tiff function

end % Top level function