% demoGenRegionalMask.m
% 
%   Author:  Shant Malkasian
%   Email: smalkasi@uci.edu
%   Date: 01/08/2018
%   Description:  This script demonstrates how to create ordinal mask from
%   multiple DICOM masks, using GenRegionalMask.  For more help, see
%   GenRegionalMask.

%% CASE 1:  CREATE BRAIN PLUG MASK
study_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\04_26_17_data\BRAIN_PERFUSION';
acq = '\Acq01_Continuous_Baseline_00ATM';
regional_mask_title = 'MICROSPHERE_PLUGS_VITREA';
dcm_paths = { [study_path acq '\SEGMENT_Vitrea_LEFT_ANTERIOR_dcm'],...
              [study_path acq '\SEGMENT_Vitrea_RIGHT_ANTERIOR_dcm'],...
              [study_path acq '\SEGMENT_Vitrea_LEFT_POSTERIOR_dcm'],...
              [study_path acq '\SEGMENT_Vitrea_RIGHT_POSTERIOR_dcm'] };
regional_mask_path = [study_path acq '\MICROSPHERE_PLUGS_VITREA_mask.mat'];

[region_mask, region_mask_labels, region_mask_path] = GenRegionalMask(regional_mask_title, dcm_paths, regional_mask_path, 0);