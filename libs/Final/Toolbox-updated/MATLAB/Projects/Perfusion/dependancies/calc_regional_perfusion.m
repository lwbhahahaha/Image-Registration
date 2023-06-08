function [ perf, perf_maps, mass, change_hu ] = calc_regional_perfusion( perf, perf_maps, mass, change_hu, v1_vol, v2_vol, organ_mask, regional_mask, regional_labels, tissue_rho, vx_size )
%[ perf, perf_maps, mass, hu_change ] = calc_regional_perfusion( perf, perf_maps, mass, change_hu, v1_vol, v2_vol, organ_mask, regional_mask, regional_labels, tissue_rho, vx_size )
%
%CALC_REGIONAL_PERFUSION calculates 2-volume volumeteric regional perfusion
%
%   calc_regional_perfusion uses an ordinal mask of specified regions to
%   calculate 2-volume volumetric perfusion.  This function updates the
%   inputted perf and perf_maps structures by appending the respective
%   regional perfusion values and maps to these structures.  This function
%   was specifically made for use with VolumePerfusion.
%
%   INPUTS:
%
%   perf                          STRUCT(DOUBLE) | (mL/(min * g))
%                                 Structure of previously calculated
%                                 perfusion values.  New regional perfusion
%                                 values are appended to this structure,
%                                 following the regional_labels
%                                 convention.
%
%
%   perf_maps                     STRUCT(VOLUME(DOUBLE)) | (mL/(min * g))
%                                 Structure of previously calculated
%                                 perfusion maps.  This structure must have
%                                 the field whole_organ defined as the
%                                 perfusion map of the whole organ of
%                                 interest.  This map is used to calculate
%                                 regional perfusion measurements.
% 
%   mass                          STRUCT(DOUBLE) | (g)
%                                 Structure of mass of each compartment
% 
%   change_hu                     STRUCT(DOUBLE) | (HU)
%                                 Average change of enhancement in each
%                                 compartment, between V1 and V2
% 
%   v1_vol                        VOLUME(DOUBLE) | (HU) [512 x 512 x 320]
%                                 Grayscale volume 1 image
%  
%   v2_vol                        VOLUME(DOUBLE) | (HU) [512 x 512 x 320]
%                                 Grayscale volume 2 image
%
%
%   organ_mask                    VOLUME(LOGICAL) | [512 x 512 x 320]
%                                 Binary image volume of organ of interest
%
%
%   regional_mask                 VOLUME(DOUBLE) | [512 x 512 x 320]
%                                 Ordinal volume labeling specific regions
%                                 to calculate perfusion within.
%
%
%   regional_labels               {STR}
%                                 Cell array of str labels, corresponding
%                                 to the different regions in
%                                 regional_mask.  The FIRST element of
%                                 regional_labels will correspond to the
%                                 title of the regions, while every
%                                 subsequent element in regional_labels
%                                 correspondes to each region in
%                                 regional_mask, positionally.  Thus,
%                                 LENGTH(regional_labels) = 1 + # of
%                                 regions, as the first element of
%                                 regional_labels is the title.
%  
%   tissue_rho                    MATRIX(DOUBLE) or DOUBLE | (g) or (g/mL), respectively
%                                 Mass map or tissue density of organ
%                                 compartment.
% 
%   vx_size                       VECOTR(DOUBLE) | [X Y Z] (mm/vx)
%                                 Dimensions of current voxel size
%
%
%   OUTPUTS:
%
%   perf...                       STRUCT
% 
%       whole_organ               DOUBLE | 2.05 mL/(min * g)
%                                 Calculation of perfusion into
%                                 whole-organ.
% 
%    *REGIONAL PERFUSION MEASUREMENTS*  
% 
%       region1                   DOUBLE | 1.05 mL/(min *g)
%                                 Calculation of perfusion into region1, as
%                                 defined by mask_reg_path.  If
%                                 mask_reg_path is not provided, regional
%                                 perfusion elements of the variable perf
%                                 will not be defined.
% 
%       region2
%       .
%       .
%       .
%       regionN
%
%
%   perf_maps...                  STRUCT
% 
%       whole_organ               VOLUME(DOUBLE) | 512x512x320 mL/(min * g)
%                                 Volume-map of perfusion in whole organ of
%                                 interest.  No post-processing will be
%                                 provided for any perf_maps.  Further
%                                 processing of perf_maps, such as smoothing
%                                 or writing as DICOM files, should be
%                                 performed OUTSIDE this function.
% 
%    *REGIONAL PERFUSION MAPS*
% 
%       region1                   VOLUME(DOUBLE) | 512x512x320 mL/(min * g)
%                                 Volume-map of perfusion in region of
%                                 interest.  No post-processing will be
%                                 provided for any perf_maps.  Further
%                                 processing of perf_maps, such as smoothing
%                                 or writing as DICOM files, should be
%                                 performed OUTSIDE this function.
% 
%       region2
%       .
%       .
%       .
%       regionN
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 05-Jan-2018
%
for i = 2 : length(regional_labels)
    label = regional_labels{i};
    
    % CALCULATE PERFUSION
    reg_perf = [NaN NaN];
    reg_perf(1) = mean(perf_maps.whole_organ((regional_mask == (i-1)) & organ_mask));
    reg_perf(2) = std(perf_maps.whole_organ((regional_mask == (i-1)) & organ_mask));
    perf.(label) = reg_perf;
    regional_map = perf_maps.whole_organ;
    regional_map( ~((regional_mask == (i-1)) & organ_mask) ) = 0;
    perf_maps.(label) = regional_map;
     
    cur_regional_mask = ((regional_mask == (i-1)) & organ_mask);   
    
    % CALCULATE MASS
    if isvol_(tissue_rho)
        mass.(label) = sum(tissue_rho(cur_regional_mask));
    else
        mass.(label) = sum(cur_regional_mask(:)) * tissue_rho * vx_size(1) * vx_size(2) * vx_size(3) / 1000;
    end
    
    % CALCULATE CHANGE IN HU
    change_hu.(label) = nanmean(v2_vol(cur_regional_mask)) - nanmean(v1_vol(cur_regional_mask));
    
end
%% Helper Functions:
    function [ tf_ ] = isvol_( tissue_rho_ )
        tf_ = false;
        if size(size(tissue_rho_), 2) == 3
            tf_ = true;
        end
    end
end
