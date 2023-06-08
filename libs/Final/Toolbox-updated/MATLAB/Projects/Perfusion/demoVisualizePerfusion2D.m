%% demoVisualizePerfusion2D.m
% Author:  Shant Malkasian
% Date: 02/04/2018
% Description:  This script will demonstrate how to use
% VisualizePerfusion2D.  Specifically, VisualizePerfusion2D will create a
% 2D image of a specified slice, in any plane (ax, cor, sag), and overlap
% the corresponding perfusion map with the original grayscale image.  This
% script and associated functions were made specifically for cardiac
% datasets, but should easily be adaptable to any organ perfusion project.

%% CASE 1.a - Patient 4 | CFR Perfusion Map | LV (AHA17 Segmentation) | Axial
perf_vol = loadMAT('\\polaris\Data4_New\bpziemer\HUMAN_PERFUSION_DATA\PATIENT_4_DATA\AIDR3D_Strong_FC03\Acq01_Stress_CTP_AIDR3D_Strong_FC03\PERFUSION_MAPS\cfr_perf_map_17_seg.mat');
gray_vol = loadMAT('\\polaris\Data4_New\bpziemer\HUMAN_PERFUSION_DATA\PATIENT_4_DATA\AIDR3D_Strong_FC03\Acq01_Stress_CTP_AIDR3D_Strong_FC03\MAT\02.mat');



params.plane = 'CORONAL';
params.w_l = [800 300];
params.save_path = 'test_image.png';

[perf_gray_slice] = VisualizePerfusion2D( perf_vol, gray_vol, 200, params );


%% CASE 1.b - Patient 4 | CFR Perfusion Map | Smooth | LV (AHA17 Segmentation) | Axial

%% CASE 1.c - Patient 4 | Stress Perfusion Map | LV (AHA17 Segmentation) | Axial

%% CASE 1.d - Patient 4 | Stress Perfusion Map | Smooth | LV (AHA17 Segmentation) | Axial