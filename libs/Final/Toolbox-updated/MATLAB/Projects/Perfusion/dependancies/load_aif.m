function [ aif_vec, aif_vec_path ] = load_aif( aif_path, acq_path, disable_flip)
%[ aif_vec, aif_vec_path ] = load_aif( aif_path, acq_path, reg_tf )
%
%LOAD_AIF attempts to load the provided AIF vector from the provided path.
%
%   load_aif attempts to load the provided AIF vector from the provided
%   path.  If aif_path points to a volume mask, the volume mask will be
%   loaded and the AIF will be generated, and the newly generated AIF will
%   be saved.
%
%   INPUTS:
%
%   aif_path                      STR
%                                 Path to AIF vector or AIF volume mask
%
%
%   acq_path                      STR
%                                 Path to acquisition of interest.  Include
%                                 REGISTERED if desired  

%   flip_vol                      Enable the filpdim function
%                                 Default is true
%
%   OUTPUTS:
%
%   aif_vec                       VECTOR(DOUBLE) | (HU)
%                                 Arterial input function (AIF) vector,
%                                 over time
% 

%   aif_vec_path                  STR
%                                 Path of actual AIF vector loaded.
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 05-Jan-2018
%

if nargin < 3
    disable_flip = true;
end

err_mode = 'AIF';
aif_path = verify_path(acq_path, aif_path, err_mode);
aif_var = load_volume(aif_path, disable_flip);
if any(size(size(aif_var)) == 3)
    aif_split_path = strsplit(aif_path, '/');
    aif_vec_path = [acq_path '/' strrep([aif_split_path{end}], '.mat', '') '_AIF_VolumePerfusion.mat'];
    if ~exist(aif_vec_path, 'file')
        aif_vec = gen_aif(acq_path, logical(aif_var));
        saveMAT(aif_vec, aif_vec_path);
    else
        aif_vec = loadMAT(aif_vec_path);
    end
else
    aif_vec = aif_var;
    aif_vec_path = aif_path;
end

end
