function [ perf, perf_map, organ_mass, delta_hu, flow, flow_map ] = calc_organ_perfusion( v1_vol, v2_vol, organ_vol, input_conc, tissue_rho, vx_size, delta_time )
%[ perf, perf_map organ_mass, delta_hu ] = calc_organ_perfusion( v1_vol, v2_vol, organ_vol, input_conc, tissue_rho, vx_size, delta_time )
%
%CALC_ORGAN_PERFUSION calculates 2-volume volumetric CT perfusion
%
%   calc_organ_perfusion calculates 2-volume volumetric CT perfusion.  v1_vol and
%   v2_vol should already be cropped to region of interest.  Determining
%   volume 1 and volume 2, and the respective segmentation, occurs outside
%   of this function.   For reference, the first line of variable 
%   descriptions, below, will first include the variable type and an 
%   example of a real definition of the variable.  All input parameters are
%   required.  The calculations below have been formatted to match the
%   equations listed in the article "Comprehensive Assessment of Coronary 
%   Artery Disease by Using First-Pass Analysis Dynamic CT Perfusion: 
%   Validation in a Swine Model".  Please refer to this article for a
%   detailed overview of the calculation of CT perfusion.
%
%   INPUTS:
%
%   v1_vol                        VOLUME(DOUBLE) | [512 x 512 x 320] (HU)
%                                 Cropped volume 1
%
%
%   v2_vol                        VOLUME(DOUBLE) | [512 x 512 x 320] (HU)
%                                 Cropped volume 2
% 
%   organ_vol                     VOLUME(LOGICAL) | [512 x 512 x 320]
%                                 Binary mask of whole organ of interest
%
%
%   input_conc                    DOUBLE | (HU)
%                                 Concentration of contrast entering
%                                 cropped volumes of interest.
%
%
%   tissue_rho                    DOUBLE | (g/mL)
%                                 Density of organ of interest.  Further
%                                 functionality needs to be adapted, to
%                                 allow for the input of tissue_rho as a
%                                 volume mass map, for heterogenous organs
%                                 like the brain and lung.
%
%
%   vx_size                       VECTOR(DOUBLE) | [X Y Z] (voxel/mm^3)
%                                 Dimensions of voxels in volume 1 and 2.
%
%
%   delta_time                    DOUBLE | (SEC)
%                                 Exact time delay between volume 1 and 2.
%
%
%   OUTPUTS:
%
%   perf...                       STRUCT
%                                 For functionality with VolumePerfusion,
%                                 perfusion calculations are outputted as a
%                                 structure with the following field
% 
%       whole_organ               DOUBLE | (mL/(min * g))
%                                 Calculation of perfusion into
%                                 whole-organ.
%       
%
%
%   perf_maps...                  STRUCT
%                                 For functionality with VolumePerfusion,
%                                 perfusion maps are outputted as a
%                                 structure with the following field
% 
%       whole_organ               VOLUME(DOUBLE) | 512x512x320 (mL/(min * g))
%                                 Volume-map of perfusion in whole organ of
%                                 interest.  No post-processing will be
%                                 provided for any perf_maps.  Further
%                                 processing of perf_maps, such as smoothing
%                                 or writing as DICOM files, should be
%                                 performed OUTSIDE this function.
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 05-Jan-2018
%


% TODO:  MATCH NOTATION TO RADIOLOGY PAPER
% organ_vol = logical(v2_vol);


% NOTE: HU is basically equal to # of photons absorbed / vx_size(3), THUS the term
% organ_vol_inplane 'could' be thought of as being in units of VOLUME.

if isvol_(tissue_rho)
    % SPECIFIC TO LUNG
    organ_mass = tissue_rho(organ_vol);
    organ_mass = sum(organ_mass);
else
    organ_mass = sum(organ_vol(:)) * tissue_rho * vx_size(1) * vx_size(2) * vx_size(3) / 1000; % g [mass of organ of interest]
end


delta_hu = nanmean(v2_vol(organ_vol)) - nanmean(v1_vol(organ_vol)); % HU [for diagnostic output;]


organ_vol_inplane =  vx_size(1) * vx_size(2) / 1000; %cm^3 [in-plane volume of organ of interest, for input concentration calculation]
v1_mass = sum(v1_vol(organ_vol)) * organ_vol_inplane;
v2_mass = sum(v2_vol(organ_vol)) * organ_vol_inplane;

perf = [0 0];
flow  = ((1/input_conc) * ((v2_mass - v1_mass) / (delta_time/60))); % mL/min [blood flow of organ of interest]
perf(1) = flow / organ_mass; % mL/min/g [blood perfusion of organ of interest]
flow_map = (v2_vol - v1_vol) ./ (mean(v2_vol(organ_vol)) - mean(v1_vol(organ_vol))) .* flow; % mL/min/g [voxel-by-voxel blood perfusion of organ of interest]


perf_map = flow_map ./ organ_mass;
perf(2) = std(perf_map(organ_vol));





%% Helper Functions:
    function [ tf_ ] = isvol_( tissue_rho_ )
        tf_ = false;
        if size(size(tissue_rho_), 2) == 3
            tf_ = true;
        end
    end
end
