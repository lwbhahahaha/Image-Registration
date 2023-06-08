function [ tf ] = is_dcm_dir( path )
%[ tf ] = is_dcm_dir( path )
%
%IS_DCM_DIR checks if the inputted path is a folder containing DICOM files.
% In special cases, like for the human brain perfusion datasets, DICOM
% files do not have the '.dcm' or '.DICOM' suffix.  This special case will
% NOT be addressed in this code.  A separate function can be written to
% append '.dcm' suffixes to files, but it is beyond the scope of this
% function.
%
%   is_dcm_dir
%
%   INPUTS:
%
%   path                          STR
%                                 Path to folder of interest
%
%
%   OUTPUTS:
%
%   tf                            LOGICAL
%                                 Returns 1 if path is a valid folder
%                                 containing DICOM files; else returns 0
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 08-Jan-2018
%

tf = 0;
if isdir(path) &... Check if path is a folder and NOT a file
   (length(regexpdir(path, '\.dcm$', false)) >= 160 |... Folder contains atleast 160 files ending with '.dcm'
    length(regexpdir(path, '\.DICOM$', false)) >= 160) % Folder contains atleast 160 files ending with '.DICOM'
   % ADD: Further criteria for determining if a folder contains a complete
   % set of DICOM images can be added to the above boolean statements.
   tf = 1;
end

end
