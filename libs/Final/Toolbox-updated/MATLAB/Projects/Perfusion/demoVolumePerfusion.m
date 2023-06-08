% demoVolumePerfusion.m
% 
%   Author:  Shant Malkasian
%   Email: smalkasi@uci.edu
%   Date: 01/04/2018
%   Description:  This script will demonstrate how to use the function
%   VolumePerfusion.  VolumePerfusion is a generalized function that allows
%   for the calculation of volumetric perfusion using CT data.  For more
%   information about VolumePerfusion, see 'help VolumePerfusion.m'

%% CASE 1:  CARDIAC | REGISTERED | 2 VOLUME PROSPECTIVE | SAVE TO EXCEL
clc
clear acq_path mask_org_path params perf

acq_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\DoseReductionDataPaper2_2018\03_07_17_data\Acq03_Baseline_2V\REGISTERED\'; % NOTICE, INCLUDE REGISTERED!
mask_org_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\DoseReductionDataPaper2_2018\03_07_17_data\Acq03_Baseline_2V\REGISTERED\SEGMENT_2V_1px\HEART_BW.mat';

% OPTIONAL PARAMETERS:
params.xlsx_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\DoseReductionDataPaper2_2018\03_07_17_data\demo_VolumePerfusion_CARDIAC_2V_PROSPECTIVE.xlsx'; % SPECIFY TO SAVE TO EXCEL
params.aif_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\DoseReductionDataPaper2_2018\03_07_17_data\SEGMENT_dcm\AA_dcm';
% RUN:
perf = VolumePerfusion(acq_path, mask_org_path, params);

%% CASE 2: CARDIAC | REGISTERED | 2 VOLUME RETROSPECTIVE | SAVE TO EXCEL
clc
clear acq_path mask_org_path params perf

acq_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\DoseReductionDataPaper2_2018\03_07_17_data\Acq02_Baseline_Continuous\REGISTERED\'; % NOTICE, INCLUDE REGISTERED!
mask_org_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\DoseReductionDataPaper2_2018\03_07_17_data\Acq02_Baseline_Continuous\REGISTERED\SEGMENT_2V_1px\HEART_BW.mat';

% OPTIONAL PARAMETERS:
params.xlsx_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\03_07_17_data\CardiacPerfusion\demo_VolumePerfusion_CARDIAC_2V_PROSPECTIVE.xlsx'; % SPECIFY TO SAVE TO EXCEL
% params.verbose = true;
params.v1_trigger_hu = 140;
params.avg_v1 = true;
% params.v2_trigger_dt = 4.5;
% RUN:
perf = VolumePerfusion(acq_path, mask_org_path, params);

%% CASE 3a: CARDIAC | REGISTERED | 2 VOLUME RETROSPECTIVE | SELECT PEAK AIF FOR V2 | 17-SEGMENT PERFUSION FROM MAT | SAVE TO EXCEL
clc
clear acq_path mask_org_path params perf


acq_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\03_07_17_data\CardiacPerfusion\Acq02_Baseline_Continuous\REGISTERED\'; % NOTICE, INCLUDE REGISTERED!
mask_org_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\03_07_17_data\CardiacPerfusion\Acq02_Baseline_Continuous\REGISTERED\SEGMENT_2V_1px\HEART_BW.mat';

% OPTIONAL PARAMETERS:
params.xlsx_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\03_07_17_data\CardiacPerfusion\demo_VolumePerfusion_CARDIAC_2V_PROSPECTIVE.xlsx'; % SPECIFY TO SAVE TO EXCEL
params.mask_reg_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\03_07_17_data\CardiacPerfusion\Acq02_Baseline_Continuous\REGISTERED\17seg\AHA17seg.mat';
params.mask_reg_labels = {'AHA17',...
                       'SEGMENT1', 'SEGMENT2', 'SEGMENT3', 'SEGMENT4',...
                       'SEGMENT5', 'SEGMENT6', 'SEGMENT7', 'SEGMENT8',...
                       'SEGMENT9', 'SEGMENT10', 'SEGMENT11', 'SEGMENT12',...
                       'SEGMENT13', 'SEGMENT14', 'SEGMENT15', 'SEGMENT16',...
                       'SEGMENT17'};
params.v1_trigger_hu = 180;
params.v2_trigger_dt = NaN;

% RUN:
perf = VolumePerfusion(acq_path, mask_org_path, params);

%% CASE 3b: CARDIAC | REGISTERED | 2 VOLUME RETROSPECTIVE | SELECT PEAK AIF FOR V2 | 17-SEGMENT PERFUSION FROM DICOM | SAVE TO EXCEL
clc
clear acq_path mask_org_path params perf


acq_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\03_07_17_data\CardiacPerfusion\Acq02_Baseline_Continuous\REGISTERED\'; % NOTICE, INCLUDE REGISTERED!
mask_org_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\03_07_17_data\CardiacPerfusion\Acq02_Baseline_Continuous\REGISTERED\SEGMENT_2V_1px\HEART_BW.mat';

% OPTIONAL PARAMETERS:
params.xlsx_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\03_07_17_data\CardiacPerfusion\demo_VolumePerfusion_CARDIAC_2V_PROSPECTIVE.xlsx'; % SPECIFY TO SAVE TO EXCEL
params.mask_reg_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\03_07_17_data\CardiacPerfusion\Acq02_Baseline_Continuous\REGISTERED\17seg_dcm';
params.mask_reg_labels = {'AHA17',...
                       'SEGMENT1', 'SEGMENT2', 'SEGMENT3', 'SEGMENT4',...
                       'SEGMENT5', 'SEGMENT6', 'SEGMENT7', 'SEGMENT8',...
                       'SEGMENT9', 'SEGMENT10', 'SEGMENT11', 'SEGMENT12',...
                       'SEGMENT13', 'SEGMENT14', 'SEGMENT15', 'SEGMENT16',...
                       'SEGMENT17'};
params.v1_trigger_hu = 180;
params.v2_trigger_dt = NaN;

% RUN:
perf = VolumePerfusion(acq_path, mask_org_path, params);

%% CASE 4a: BRAIN PIG | 2 VOLUME RETROSPECTIVE | SELECT PEAK AIF FOR V2 | SAVE TO EXCEL
clc
clear acq_path mask_org_path params perf

acq_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\10_11_17_data\BrainPerfusion\ACQ1';
mask_org_path = '\SEGMENT_BRAIN_Vitrea_dcm';
% OPTIONAL PARAMETERS:
params.tissue_rho = 1.045;
params.xlsx_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\10_11_17_data\BrainPerfusion\demo_VolumePerfusion_BRAIN.xlsx'; % SPECIFY TO SAVE TO EXCEL
% params.aif_path = '\SEGMENT_LEFT_CAROTID_Vitrea_dcm_AIF_VolumePerfusion.mat';
params.aif_path = '\SEGMENT_LEFT_CAROTID_Vitrea_dcm';
params.time_vec_path = 'time_vector_autoGenerated.mat';

% RUN:
perf = VolumePerfusion(acq_path, mask_org_path, params);

%% CASE 4b: BRAIN PIG | 2 VOLUME RETROSPECTIVE | FIXED TIME DELAY FOR V2 | SAVE TO EXCEL
clc
clear acq_path mask_org_path params perf

acq_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\10_11_17_data\BrainPerfusion\ACQ1';
mask_org_path = '\SEGMENT_BRAIN_Vitrea_dcm';
% OPTIONAL PARAMETERS:
params.tissue_rho = 1.045;
params.xlsx_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\10_11_17_data\BrainPerfusion\demo_VolumePerfusion_BRAIN.xlsx'; % SPECIFY TO SAVE TO EXCEL
params.aif_path = '\SEGMENT_LEFT_CAROTID_Vitrea_dcm_AIF_VolumePerfusion.mat';
params.time_vec_path = 'time_vector_autoGenerated.mat';
params.v2_trigger_dt = 9.00; % SEC
params.safe_mode = true;

% RUN:
perf = VolumePerfusion(acq_path, mask_org_path, params);

%% CASE 4c: BRAIN PIG | 2 VOLUME RETROSPECTIVE | SELECT PEAK AIF FOR V2 | REGIONAL PERFUSION FROM DICOM | SAVE TO EXCEL
clc
clear acq_path mask_org_path params perf

acq_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\10_11_17_data\BrainPerfusion\ACQ1';

% CREATE COMBINED MASK VOLUME OF PLUGS
region_title = 'BRAIN_MICROSPHERE_PLUGS_VITREA';
region_dcm_paths = {[acq_path '/SEGMENT_BRAIN_LEFT_ANT_LOBE_Vitrea_dcm'],...
                    [acq_path '/SEGMENT_BRAIN_LEFT_POST_LOBE_Vitrea_dcm'],...
                    [acq_path '/SEGMENT_BRAIN_RIGHT_ANT_LOBE_Vitrea_dcm'],...
                    [acq_path '/SEGMENT_BRAIN_RIGHT_POST_LOBE_Vitrea_dcm']};
region_mask_path = [acq_path '/' region_title '.mat'];
[~, region_mask_labels, region_mask_path] = GenRegionalMask(region_title, region_dcm_paths, region_mask_path, 0);

% SET PERFUSION PARAMETERS:
mask_org_path = '\SEGMENT_BRAIN_Vitrea_dcm';
% OPTIONAL PARAMETERS:
params.tissue_rho = 1.045;
params.xlsx_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\10_11_17_data\BrainPerfusion\demo_VolumePerfusion_BRAIN.xlsx'; % SPECIFY TO SAVE TO EXCEL
params.aif_path = '\SEGMENT_LEFT_CAROTID_Vitrea_dcm_AIF_VolumePerfusion.mat';
params.time_vec_path = 'time_vector_autoGenerated.mat';
params.mask_reg_path = region_mask_path;
params.mask_reg_labels = region_mask_labels;
params.v1_trigger_hu = 300;

% RUN:
[perf, perf_maps] = VolumePerfusion(acq_path, mask_org_path, params);

%% CASE 4d: BRAIN PIG | 2 VOLUME RETROSPECTIVE | SELECT PEAK AIF FOR V2 | MEDIAN FILTER | SAVE TO EXCEL
clc
% clear acq_path mask_org_path params perf perf_maps

acq_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\10_11_17_data\BrainPerfusion\ACQ1';
mask_org_path = '\SEGMENT_BRAIN_Vitrea_dcm';
% OPTIONAL PARAMETERS:
params.tissue_rho = 1.045;
params.xlsx_path = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\10_11_17_data\BrainPerfusion\demo_VolumePerfusion_BRAIN.xlsx'; % SPECIFY TO SAVE TO EXCEL
% params.aif_path = '\SEGMENT_LEFT_CAROTID_Vitrea_dcm_AIF_VolumePerfusion.mat';
params.aif_path = '\SEGMENT_LEFT_CAROTID_Vitrea_dcm';
params.time_vec_path = 'time_vector_autoGenerated.mat';
params.filt_size_mm = 2; % mm
params.filt_type = 'MEDIAN';
% RUN:
[perf, perf_maps] = VolumePerfusion(acq_path, mask_org_path, params);

%% CASE 6a: BRAIN HUMAN | 2 VOLUME RETROSPECTIVE | SELECT PEAK AIF FOR V2 | SAVE TO EXCEL

%% CASE 6b: BRAIN HUMAN | 2 VOLUME RETROSPECTIVE | FIXED TIME DELAY FOR V2 | SAVE TO EXCEL

%% CASE 7a: KIDNEY | 2 VOLUME RETROSPECTIVE | SELECT PEAK AIF FOR V2 | SAVE TO EXCEL

%% CASE 7b: KIDNEY | 2 VOLUME RETROSPECTIVE | FIXED TIME DELAY FOR V2 | SAVE TO EXCEL


%% CASE 8a: CARDIAC | PATIENT 4 | 2 VOLUME PROSPECTIVE | UNREGISTERED
acq_path = '\\polaris\Data4_New\bpziemer\HUMAN_PERFUSION_DATA\PATIENT_4_DATA\AIDR3D_Strong_FC03\Acq03_Rest_CTP_AIDR3D_Strong_FC03';
mask_org_path = 'SEGMENT_dcm\17_SEG_dcm';

params.v1_hu_avg = 88.5; % (HU) DETERMINED IN VITREA
params.aif_vec = [285.0 526.2]; % (HU) DETERMINED IN VITREA

[perf, perf_maps] = VolumePerfusion(acq_path, mask_org_path, params);



