function [I, dcm_info] = ImportDICOMSequence2(image_directory, fname_cells)
%IMPORTDICOMSEQUENCE Reads image files from a directory into a 3D stack
%
% I = ImportDICOMSequence(image_directory, fname_cells)
%
% Currently this function is made for 16 bit signed DICOM images in a
% single directory that form a 3D stack. This could be expanded on to add
% generality when it is needed (see TODO below)
%
% If a cell array of file names is passed in as well, then the resulting
% stack will only contain those images in the specified order. It is
% assumed that all the files reside in the image_directory directory.
%
% Relies on the natsort function written by Stephen Cobeldick from the FEX
% to ensure that the file names are sorted in a natural order (eg. numeric
% instead of lexographical) so that the images in the sequence are read in
% correctly.
% http://www.mathworks.com/matlabcentral/fileexchange/34464-customizable-natural-order-sort
%
% Author: Travis Johnson
%         Molloi Lab

% Input checking
% Ensure that the input directory ends in a filesep
% Modified to 
if (image_directory(end) ~= filesep)
    image_directory = [image_directory filesep];
end

if nargin == 1
    % Load up the image directory ensuring that files are found
    image_dir = dir([image_directory '*.dcm']);
    if isempty( image_dir );
        image_dir = dir([image_directory '*']);
        if isempty( image_dir )
            exception = MException(strcat(mfilename, ':NoDICOM'),...
                            'No DICOM format images detected in "%s".',...
                            image_directory);
            throw(exception);
        end
    end
    % Parse out the file names using natsort to put them in a sensible order
    file_names = natsort({image_dir.name});
else % optional cell array passed in
    file_names = fname_cells;
end

skip_fnames = {'.', '..'};
for i = skip_fnames
    file_names = setdiff(file_names,i);
end

    



% Determine information about the images before allocating memory
fname = file_names{round(end/2)};
fname = [image_directory fname];

dcm_info = dicominfo(fname);

stack_size(1) = dcm_info.Width;
stack_size(2) = dcm_info.Height;



stack_size(3) = numel(file_names);
try
    if strcmp(dcm_info.Modality, 'MR')
        stack_size(1) = dcm_info.Height;
        stack_size(2) = dcm_info.Width;
    end
catch
end


% Now allocate and fill the matrix
I = zeros( stack_size, 'int16'); % TODO Generalize this to work with any DICOM format pixel type
% Use a TextProgressbar object to display the progress with text.
TP = TextProgressbar(sprintf('Importing %d images... ', stack_size(3)));

% Possible fields for determining image slice; Clinical images are not
% always standardized so each DICOM tag will be tested to parse slice
% position

slice_tags = {'InStackPosition',...
              'InStackPositionNumber',...
              'InstanceNumber'};
          

          
          
for idx = 1 : stack_size(3)
    % update progress
    TP.update(num2str(idx));

    % do the file reading
    fname = file_names{idx};
    if any(strcmp(fname, skip_fnames))
        continue
    end
    fname = [image_directory fname];
    dcm_slice_info = dicominfo(fname);
    
    if dcm_info.Width ~= dcm_slice_info.Width && dcm_info.Height ~= dcm_slice_info.Height
        continue
    end
    % Added this to ensure the stack is loaded in proper order.
%     try
% 		slice = rem( double(dcm_slice_info.InStackPosition) , stack_size(3) );
%     catch
%         try
%             slice = rem( double(dcm_slice_info.InStackPositionNumber), stack_size(3));
%             if ~slice
%                 slice = stack_size(3);
%             end
%         catch
%             try
%                 slice = rem( double(dcm_slice_info.InstanceNumber), stack_size(3));
% %                 slice = rem( double(dcm_slice_info.InstanceNumber)+1, stack_size(3)); % removed +1
%                 if ~slice
%                     slice = stack_size(3);
%                 end
%             catch
%                 slice = idx;
%             end 
%      
%         end
%     end

%   UPDATED CODE:
%     slice = 0;
%     for tt = slice_tags
%         try
%             slice = rem(double(dcm_slice_info.(tt{1})), stack_size(3));
%             if ~slice
%                 slice = stack_size(3);
%             end
%         catch ME
%             if ~strcmp(ME.identifier, 'MATLAB:nonExistentField') % UNLESS FIELD DOESN'T EXIST IN DICOMTAG, RAISE ERROR
%                 rethrow(ME);
%             end
%         end
%     end
%     if ~slice % IF NO SLICE IS FOUND, USE IDX
%         slice = idx;
%     end
    
    % Change 'slice' to 'idx' to revert to old method.
    I(:,:,idx ) = dicomread( fname );
    
end  

if any(logical(strcmp(fields(dcm_info), 'RescaleIntercept')))
%     I = I + dcm_info.RescaleIntercept;
end

TP.delete();













