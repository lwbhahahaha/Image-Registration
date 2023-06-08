function [ filt_perf, filt_perf_map ] = filter_organ_perfusion( perf, perf_map, organ_vol, vx_size, k_size, filt_type, save_params )
%[ perf, perf_map ] = filter_organ_perfusion( perf, perf_map, organ_vol, vx_size, k_size, h_filter )
%
%FILTER_ORGAN_PERFUSION will filter and recalculate perfusion calculations
%
%   filter_organ_perfusion
%
%   INPUTS:
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
%   perf_map...                   STRUCT
%                                 For functionality with VolumePerfusion,
%                                 perfusion maps are outputted as a
%                                 structure with the following field
% 
%       whole_organ               VOLUME(DOUBLE) | 512x512x320 (mL/(min * g))
%                                 Volume-map of perfusion in whole organ of
%                                 interest.
% 
%   organ_vol                     VOLUME(LOGICAL) | [512 x 512 x 320]
%                                 Binary mask of whole organ of interest
% 
%   vx_size                       VECTOR(DOUBLE) | [X Y Z] (mm/ voxel)
%                                 Dimensions of voxel
% 
%   k_size                        SCALAR(DOUBLE) | (mm)
%                                 Length of cube kernel to filter with.
% 
%   filt_type                     STR | 'MEDIAN' or 'MEAN'
%                                 By default, no filter is applied.  If
%                                 filtering of the whole organ perfusion
%                                 map is desired, specify either 'MEDIAN'
%                                 or 'MEAN'.  Futher types of filters can
%                                 be implemented in the future.
% 
%   save_params                   STRUCT
%                                 Parameters that will be saved and later
%                                 used to determine if it is necessary to
%                                 calculate a new filtered perfusion map or
%                                 not.  
%                                 The following parameters are used:
%                                   filt_size_mm
%                                   filt_type
%                                   v1_idx
%                                   v2_idx
%                                   input_conc
%                                   delta_time
%                                   perf
%                                   acq_path
%                                   id
%
%   OUTPUTS:
%
%   filt_perf...                  STRUCT
%                                 For functionality with VolumePerfusion,
%                                 perfusion calculations are outputted as a
%                                 structure with the following field
% 
%       whole_organ               DOUBLE | (mL/(min * g))
%                                 Calculation of perfusion into
%                                 whole-organ. (FILTERED)
%       
%
%
%   filt_perf_map...              STRUCT
%                                 For functionality with VolumePerfusion,
%                                 perfusion maps are outputted as a
%                                 structure with the following field
% 
%       whole_organ               VOLUME(DOUBLE) | 512x512x320 (mL/(min * g))
%                                 Volume-map of perfusion in whole organ of
%                                 interest. 
%                                 (FILTERED)
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 21-Mar-2018
%

% SECTION 0: Initialize variables
filt_perf = struct;
filt_perf_map = struct;
perf_fields = fieldnames(perf);
organ_vol = logical(organ_vol);
k_vx_size_vx = round(k_size ./ vx_size);
filt_map_dir = '/FILTERED_PERF_MAPS';
filt_map_file_template = '/%s_%s_FILTER_%i_MM.mat';
filt_map_regexp = '[0-9]+_[A-Z]+_FILTER_[0-9]+_MM\.mat$';
acq_path = save_params.acq_path;
% SECTION 1: Determine filter type
switch filt_type
    case 'MEDIAN'
        h_filter = @nanmedian;
    case 'MEAN'
        h_filter = @nanmean;
end

% SECTION 2:  Check if previously saved filtered map can be used
if exist([acq_path filt_map_dir], 'dir')
    filt_map_paths = natsort(regexpdir([acq_path filt_map_dir], filt_map_regexp, false));
    for fp = filt_map_paths'
        cur_filt_path = fp{1};
        cur_filename = regexp(cur_filt_path, filt_map_regexp, 'match');
        cur_filt_type = regexp(cur_filename, '(MEAN)|(MEDIAN)', 'match');
        cur_filt_type = cur_filt_type{1};
        cur_nums = regexp(cur_filename, '[0-9]+', 'match');
        cur_nums = cur_nums{1};
        cur_filt_size = cur_nums{2};
        similar_vol = true;
        if all(strcmp({cur_filt_type{1}, cur_filt_size}, {filt_type, num2str(k_size)}))
            cur_filt_params = loadMAT(strrep(cur_filt_path, '.mat','_PARAMS.mat'));
            % CHECK THAT ALL PARAMETERS IN PREVIOUSLY SAVED PERF MAP MATCH
            % THE PARAMETERS BEING USED NOW
            cur_param_names = fieldnames(cur_filt_params);
            for j = 1 : length(cur_param_names)
                param_name = cur_param_names{j};
                if strcmp(param_name, 'ID')
                    % IGNORE ID
                    continue 
                end
                if ischar(cur_filt_params.(param_name)) &&...
                   ~strcmp(cur_filt_params.(param_name), save_params.(param_name))
                    similar_vol = false;
                elseif cur_filt_params.(param_name) ~= save_params.(param_name)
                    similar_vol = false;
                end
            end
            if similar_vol
                filt_perf_map.whole_organ = loadMAT(cur_filt_path);
                filt_perf.whole_organ(1) = mean(filt_perf_map.whole_organ(organ_vol));
                filt_perf.whole_organ(2) = std(filt_perf_map.whole_organ(organ_vol));
                return
            end
        end
    end
end


% SECTION 3: Filter and recalculate average perfusion in organ volume
for i = 1 : length(perf_fields)
    cur_field = perf_fields{i};
    cur_perf_map = perf_map.(cur_field);
    cur_perf_map( cur_perf_map < 0 ) = 0;
    cur_filt_perf_map = FastFilt3D(cur_perf_map, organ_vol, k_vx_size_vx, h_filter);
    cur_filt_perf(1) = mean(cur_filt_perf_map(organ_vol));
    cur_filt_perf(2) = std(cur_filt_perf_map(organ_vol));
    filt_perf.(cur_field) = cur_filt_perf;
    filt_perf_map.(cur_field) = cur_filt_perf_map;
end

% SECTION 4: Save filtered map
if ~exist([acq_path filt_map_dir], 'dir')
    mkdir([acq_path filt_map_dir]);
end

cur_filt_perf_map = filt_perf_map.whole_organ;
filt_map_path = [acq_path filt_map_dir sprintf(filt_map_file_template, save_params.ID, filt_type, round(k_size))];
save(filt_map_path, 'cur_filt_perf_map');
save(strrep(filt_map_path, '.mat','_PARAMS.mat'), 'save_params');

end
