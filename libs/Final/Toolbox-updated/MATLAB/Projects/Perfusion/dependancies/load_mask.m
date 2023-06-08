function [ mask, mask_path ] = load_mask( mask_path, acq_path, err_mode, reg_tf )
%[ mask, mask_path ] = load_mask( mask_path, acq_path, err_mode )
%
%LOAD_MASK attempts to load a volume mask with the provided path.
%
%   load_mask attempts to load a volume mask with the provided path.  The
%   path may either be a path relative to acq_path (DYNAMIC PATH) or a full
%   path, independent of acq_path (STATIC PATH).  A descriptive
%   PerfusionError is generated if the provided mask_path is unreachable.
%   This function can be used to load both an ordinal and binary volume
%   mask.
%
%   INPUTS:
%
%   mask_path                     STR
%                                 Path to binary volume mask of interest.
%                                 The provided path can be a path relative
%                                 to acq_path (DYNAMIC) or a complete path
%                                 (STATIC)
%
%
%   acq_path                      STR
%                                 Path to acquisition of interest.  Include
%                                 REGISTERED if desired
%
%
%   err_mode                      STR
%                                 A label to help provide a more
%                                 descriptive error
% 
%   reg_tf                        LOGICAL
%                                 Specify if the acqisition being processed
%                                 is registered or not
%
%
%   OUTPUTS:
%
%   mask                          VOLUME(LOGICAL or DOUBLE) | [512 x 512 x 320]
%                                 A volume mask that is either a binary
%                                 mask or an ordinal mask of specific
%                                 regions.
%
%
%   mask_path                     STR
%                                 Actual path to mask which was loaded, as
%                                 this path may vary depending on the type
%                                 of mask_path initial provided (DYNAMIC |
%                                 STATIC); mask_path will always be a path
%                                 to a MAT file
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 05-Jan-2018
%

if nargin == 3
    reg_tf = 0;
end

try
    % If mask_org_path exists, it must be a COMPLETE file path (like
    % includes //polaris/data4_new/.../HEART_BW.mat)
    error_check_path(mask_path, err_mode);
    warning('PerfusionWarning:fileSelection:Static',...
        'PerfusionWarning \nFileSelection | STATIC | %s\n', err_mode);
catch ME
    if strcmp(ME.identifier, ['PerfusionError:fileNotFound:' err_mode])
        % If mask_org_path doesn't exist, try to append mask_org_path
        % to acq_path
        mask_path = [acq_path mask_path];
        error_check_path(mask_path, err_mode);
        warning('PerfusionWarning:fileSelection:Dynamic',...
            'PerfusionWarning \nFileSelection | DYNAMIC | %s\n', err_mode);
    else
        rethrow(ME);
    end
end

if is_dcm_dir(mask_path)
    % Load from DICOM
    [mask, mask_path] = load_mask_dcm_(mask_path);
else
    % Load from MAT
    mask = load_mask_mat_(mask_path);
end

%% HELPER FUNCTIONS:
    function [mask_, mask_path_mat_] = load_mask_dcm_(mask_path_)
        % Load mask_ from a DICOM dataset.  When loading DICOM datasets,
        % the imported dataset must be converted into a binary image.
        % DICOM datasets exported from Vitrea typically assign 'background'
        % voxels a value of -1024 or -2048.  These values will be used to
        % convert a grayscale volume into a binary volume.  Additionally,
        % registered datasets typically 'flip' volumes in the Z-axis,
        % relative to Vitrea datasets.  This means that usually, with the
        % current iteration of code (Jan 2018), if a dataset is registered,
        % a mask imported from a DICOM folder MUST be flipped in the
        % Z-axis, in order to correspond to other registered volumes.
        
        mask_path_mat_ = [mask_path_ '.mat'];
        try
            error_check_path(mask_path_mat_, err_mode);
            mask_ = load_mask_mat_(mask_path_mat_);
            warning('PerfusionWarning:fileSelection:loadedMatFile',...
                'PerfusionWarning \nFileSelection | LoadedMatFile | %s\n', err_mode);
            return % Load from already created MAT file and return
        catch ME_
            if ~strcmp(ME_.identifier, ['PerfusionError:fileNotFound:' err_mode])
                rethrow(ME_);
            end
        end
            
        % If MAT file is not found, load mask from provided DICOM folder
        % and save the mask as a MAT for future use.
        mask_ = double(ImportDICOMSequence(mask_path_));
        mask_(mask_ == -1024 | mask_ == -2048) = 0;
        mask_ = flipdim(mask_, 3);
%         if reg_tf
%             mask_ = flipdim(mask_, 3);
%         end
        saveMAT(mask_, mask_path_mat_);
        warning('PerfusionWarning:fileSelection:savedMatFile',...
            'Perfusion Warning \nFileSelection | SavedMatFile | %s\n', err_mode);
    end

    function [mask_] = load_mask_mat_(mask_path_)
        mask_ = loadMAT(mask_path_);
    end
end
