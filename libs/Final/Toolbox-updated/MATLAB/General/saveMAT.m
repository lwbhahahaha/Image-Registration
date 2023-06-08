function [  ] = saveMAT( val, file_path, tags )
%SAVEMAT is used to streamline writing MAT files
%
%   saveMAT provides further functionality, to allow for standardized tags
%   be used when saving variables.  The tags variable can be included, to
%   include information, like the date a variable was saved, what function
%   was used to save, what parameters were used to generate the
%   variable.  Think of tags as a DICOM header.
%
%   INPUTS:
%
%   val                           ANY TYPE
%                                 Main variable to write as MAT file.
%                                 *REQUIRED*
% 
% 
%   file_path                     STR | '.../HEART_SEGMENTATION_1.mat
%                                 File path to write val to.
%                                 *REQUIRED*
% 
%
%   tags                          STRUCT
%                                 Further information to save with val, to
%                                 allow for better organization of data.
%                                 *OPTIONAL*
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 04-Jan-2018
%

switch nargin
    case 2
    save(file_path, 'val');
    case 3
    save(file_path, 'val', 'tags');
end

end
