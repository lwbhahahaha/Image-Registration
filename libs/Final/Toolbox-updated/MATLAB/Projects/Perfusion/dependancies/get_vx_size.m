function [ vx_size ] = get_vx_size( dcm_path )
%[ vx_size ] = get_vx_size( dcm_path )
%
%GET_VX_SIZE parses the voxel dimensions of the acquisition of interest
%from DICOM header data.
%
%   get_vx_size
%
%   INPUTS:
%
%   dcm_path                      STR
%                                 Path to DICOM files of acquisition of
%                                 interest
%
%
%   OUTPUTS:
%
%   vx_size                       VECTOR(DOUBLE) | [X Y Z] (voxel/mm^3)
%                                 Dimensions of voxels in X Y and Z
%                                 directions
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 05-Jan-2018
%
dcm_path        = strrep(dcm_path, 'REGISTERED/', '');
dcm_folders     = regexpdir(dcm_path, '([0-9]+\.+[0-9])|(SE[0-9]+)|[0-9]', false);   
dcm_file        = regexpdir(dcm_folders{1}, '(\.dcm$)|(\.DCM$)', false);
if isempty(dcm_file)
    dcm_file = dcm_folders;
end
metadata        = dicominfo(dcm_file{1});
vx_size         = [metadata.PixelSpacing(1) metadata.PixelSpacing(2) metadata.SliceThickness]; % mm/vx


end
