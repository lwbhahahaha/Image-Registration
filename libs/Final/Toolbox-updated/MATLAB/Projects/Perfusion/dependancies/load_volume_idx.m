function [ v_mat ] = load_volume_idx( acq_path, idx )
%[ v_mat ] = load_volume_idx( acq_path, idx )
%
%LOAD_VOLUME_IDX loads specified volume from the provided acquisition
%time-series.
%
%   load_volume_idx
%
%   INPUTS:
%
%   acq_path                      STR
%                                 Path to acquisition of interest.  Include
%                                 REGISTERED if desired
%
%
%   idx                           INT
%                                 Index of volume to load, relative to
%                                 time-series
%
% 
%
%   OUTPUTS:
%
%   v_mat                         VOLUME(DOUBLE) | [512 x 512 x 320] (HU)
%                                 Volume at specified index
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 05-Jan-2018
%

% acq_path = ['//polaris/Data4_New/bpziemer/animal_perfusion_data/Patient_UT/CTP024/REGISTERED'];
% idx = 12;
% ['//polaris/Data4_New/bpziemer/animal_perfusion_data/Patient_UT/CTP024/REGISTERED/mat/%02d.mat']
% \\polaris\Data4_New\bpziemer\animal_perfusion_data\Patient_UT\CTP024\REGISTERED/mat/%02d.mat
temp_path = process_path(acq_path);
template_vol_path = [temp_path '/mat/%02d.mat'];
v_path = sprintf(template_vol_path, idx);
v_path = verify_path(acq_path, v_path, 'TimeSeriesVolume');
v_mat = double(loadMAT(v_path));

end
