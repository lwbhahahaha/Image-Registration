function [ tsec ] = dcm_time2sec( dcm_time )
%[ tsec ] = dcm_time2sec( dcm_time )
%
%DCM_TIME2SEC covnerts time parsed from DICOM header data into seconds.
%
%   dcm_time2sec
%
%   INPUTS:
%
%   dcm_time                      STR | (hr hr min min sec sec.msec msec)
%                                 String representing time, as parsed from
%                                 a DICOM header. (spaces are provided in
%                                 the above example only for readability,
%                                 the inputted string will NOT have spaces
%                                 between each time unit)
%
%
%   OUTPUTS:
%
%   tsec                          DOUBLE | (SEC)
%                                 Time from DICOM header converted to
%                                 seconds.
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 05-Jan-2018
%
hr = str2double(dcm_time(1:2));
min_ = str2double(dcm_time(3:4));
sec = str2double(dcm_time(5:6));
msec = str2double(dcm_time(7:end));
tsec = hr*60^2 + min_*60 + sec + msec;
end
