function [ hr_bpm ] = calc_heart_rate( time_vec, perf_mode )
%[ hr_bpm ] = calc_heart_rate( time_vec, perf_mode )
%
%CALC_HEART_RATE calculates heart rate (bpm) based on the number of volumes
%present in the time vector
%
%   calc_heart_rate
%
%   INPUTS:
%
%   time_vec                      VECTOR(DOUBLE) | (SEC)
%                                 Time vector where each element is the
%                                 time, in seconds, that each volume was
%                                 acquired at; the first element should be
%                                 0 sec
%
%
%   perf_mode                     STR | 'RETRO', 'PRO'
%
%
%   OUTPUTS:
%
%   hr_bpm                        SCALAR(DOUBLE) | (BPM)
%                                 Mean heart rate (bpm) of 'patient' during
%                                 acquisition
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 21-Mar-2018
%

hr_bpm = NaN;
if ~strcmp(perf_mode, 'PRO') && length(time_vec) > 2
    hr_bpm = round( 1 / (mean(diff(time_vec)) / 60) );
end

end
