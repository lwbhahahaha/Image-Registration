function [ v1_idx, v2_idx, perf_mode ] = select_vol_idx_fixed_delay( aif_vec, time_vec, v1_trigger_hu, v1_offset, v2_trigger_dt )
%[ v1_idx, v2_idx, perf_mode ] = select_vol_idx( aif_vec, time_vec, v1_trigger_hu, v2_trigger_dt )
%
%SELECT_VOL_IDX intelligently determiens volume 1 and 2 indices
%
%   select_vol_idx Selects V1 and V2 indices for 2 volume perfusion calculations;
%   using the inputted aif and time vector.  An error will be raised
%   if aif_vec_ and time_vec_ are not the same length and if v2_idx <
%   v1_idx.  This function intelligently determines which perfusion
%   mode to use, based on the lengths of aif_vec_ and time_vec_.  If
%   length(aif_vec_ and time_vec_) == 2, then perf_mode_ is
%   PROSPECTIVE, if > 2, then perf_mode_ is RETROSPECTIVE.
%   v1_trigger_hu_ and v2_trigger_dt_ are only used in RETROSPECTIVE
%   mode.  If v1_trigger_hu == NaN, then the peak of the aif is
%   automatically selected as v2_idx_.
%
%   INPUTS:
%
%   aif_vec                       VECTOR(DOUBLE) | (HU)
%                                 Arterial input function of acquisition of
%                                 interest
%
%
%   time_vec                      VECTOR(DOUBLE) | (SEC)
%                                 Time vector of acquisition of interest
%
%
%   v1_trigger_hu                 DOUBLE | (HU)
%                                 Threshold to use to determine selection
%                                 of volume 1
% 
%   v1_offset                     INT | (CARDIAC CYCLES)
%                                 In retrospective mode, v1_offset
%                                 determines the number of volumes PAST
%                                 when aif_vec > v1_trigger_hu to choose
%                                 v1_idx
%
%
%   v2_trigger_dt                 DOUBLE | (SEC)
%                                 Time delay after volume 1 selection, used
%                                 to select volume 2; if v2_trigger_dt is
%                                 NaN, then the peak of aif_vec will
%                                 automatically be used to select volume 2
%
%
%   OUTPUTS:
%
%   v1_idx                        INT
%                                 Index of selection of volume 1
%
%
%   v2_idx                        INT
%                                 Index of selection of volume 2
%
%
%   perf_mode                     STR | 'RETRO' or 'PRO'
%                                 Type of acquisition that was processed;
%                                 if LENGTH(aif_vec and time_vec) == 2,
%                                 then 'PRO' is automatically chosen,
%                                 otherwise 'RETRO' is chosen
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 05-Jan-2018
%
perf_mode = 'RETRO';
if length(time_vec) ~= length(aif_vec)
    error('PerfusionError:volumeSelection:lengthMismatch',...
        'PerfusionError \nVolumeSelection | LENGTH MISMATCH | LENGTH(time vector) ~= LENGTH(AIF)\n');
elseif length(time_vec) == 2
    warning('PerfusionWarning:perfusionMode:Prospective',...
    'PerfusionWarning  \nPerfusionMode | PROSPECTIVE | LENGTH(time vector and AIF) == 2\n');
    v1_idx = 1;
    v2_idx = 2;
    perf_mode = 'PRO';
else
    warning('PerfusionWarning:perfusionMode:Retrospective',....
        'PerfusionWarning \nPerfusionMode | RETROSPECTIVE | LENGTH(time vector and AIF) > 2\n');
    v1_idx = find(aif_vec > v1_trigger_hu, 1, 'first') + v1_offset;
    if isnan(v2_trigger_dt)
        warning('PerfusionWarning:volumeSelection:autoPeak',...
            'PerfusionWarning \nVolumeSelection | V2 AUTO PEAK SELECT | V2 trigger delay time == NaN\n');
        [~, v2_idx] = max(aif_vec);
    else
        warning('PerfusionWarning:volumeSelection:fixedDelay',...
            'PerfusionWarning \nVolumeSelection | V2 FIXED TIME DELAY | V2 trigger delay time == %0.2f\n', v2_trigger_dt);
        trigger_low  = v2_trigger_dt - 1; % this is in units of seconds
        trigger_mid  = v2_trigger_dt; % this is in units of seconds
        trigger_high = v2_trigger_dt + 1; % this is in units of seconds
        
        idx_vec_low = time_vec - (time_vec(v1_idx) + trigger_low); % Will result in negative values below time delay and positive values above time delay
        idx_vec_mid = time_vec - (time_vec(v1_idx) + trigger_mid); % Will result in negative values below time delay and positive values above time delay
        idx_vec_high = time_vec - (time_vec(v1_idx) + trigger_high); % Will result in negative values below time delay and positive values above time delay
        
        v2_idx_low = find(idx_vec_low >= 0, 1, 'first'); % Select first 0 or positive index
        v2_idx_mid = find(idx_vec_mid >= 0, 1, 'first'); % Select first 0 or positive index
        v2_idx_high = find(idx_vec_high >= 0, 1, 'first'); % Select first 0 or positive index
        v2_idx = [v2_idx_low, v2_idx_mid, v2_idx_high];
    end
end
% if v1_idx > v2_idx
%     error('PerfusionError:volumeSelection',...
%         'PerfusionError \nVolumeSelection | V1 index > V2 index\n');
% end

end
