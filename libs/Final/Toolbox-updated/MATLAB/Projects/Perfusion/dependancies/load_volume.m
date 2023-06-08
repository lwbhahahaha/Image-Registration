function [ vol, m ] = load_volume( vol_path, flip_vol )
%[ vol, m ] = load_volume( vol_path )
%
%LOAD_VOLUME loads volume from specified path
%
%   load_volume loads volume from specified path.  The provided path can be
%   either a folder of DICOM files or a MAT file.  If the specified path is
%   a DICOM file, it will be flipped in the Z dimension, so that the
%   outputted volume is oriented in the same manner as other computed
%   tomography datasets.
%
%   INPUTS:
%
%   vol_path                      STR | '/SOMEFOLDER/SOMEDICOMFOLDER/' OR '/SOMEFOLDER/SOMEFILE.mat'
%                                 Path to volume to load; can be either a
%                                 path to a folder of DICOM files or to a
%                                 MAT file
%
%
%   OUTPUTS:
%
%   vol                           MATRIX(DOUBLE) | [MxNx3]
%                                 Image volume
% 
%   m                             LOGICAL | True or False
%                                 True if vol was loaded from MAT
%                                 False if vol was loaded from DICOM
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 07-Feb-2018
%
if nargin < 2
    flip_vol = true;
end

warning_id = 'FileIO:loading%s';
switch path_ismat_( vol_path )
    case true
        vol = loadMAT(vol_path);
        molloi_warning(sprintf(warning_id, 'MAT'), 'Loading MAT file', vol_path);
        m = true;
    case false
        try
            vol_path = verify_path('', [vol_path '.mat'], 'Volume');
            vol = loadMAT(vol_path);
            molloi_warning(sprintf(warning_id, 'MAT'), 'Loading MAT file', vol_path);
            m = true;
            return
        catch ME
            if ~strcmp(ME.identifier, 'MolloiError:FileIO:fileNotFound')
                rethrow(ME);
            end
        end
        if isempty(regexpdir(vol_path, '\.dcm$', false))
     
%             warning('If the data you are running is REGISTERED, make sure you talk to Shant');
            if flip_vol
                vol = flipdim(ImportDICOMSequence([vol_path '/DICOM/']), 3)
            else
                vol = ImportDICOMSequence([vol_path '/DICOM/']);
            end
        else
            
            if flip_vol
                vol = flipdim(ImportDICOMSequence(vol_path), 3);
            else
                vol = ImportDICOMSequence(vol_path);
            end
            
        end
        % CHANGE VALUES FROM VITREA
        vol(vol <= -1024) = 0;
        molloi_warning(sprintf(warning_id, 'DCM'), 'Loading DCM folder', vol_path);
        m = false;
        % SAVE VOL AS MAT
        save([vol_path '.mat'], 'vol');
end


%% Helper Functions:
    function [ tf_, path_ ] = path_ismat_( path_ )
        tf_ = false;
        if ~isempty(regexpi(path_, '\.mat$', 'match'))
            tf_ = true;
        end
    end


end
