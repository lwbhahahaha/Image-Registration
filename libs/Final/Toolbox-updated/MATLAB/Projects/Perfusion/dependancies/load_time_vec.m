function [ time_vec ] = load_time_vec( time_vec_path, acq_path )

%LOAD_TIME_VEC attempts to load a time vector with the provided path.
%
%   load_time_vec attempts to load a time vector with the provided path.
%   If the path does not exist, a detailed PerfusionError is generated.
%
%   INPUTS:
%
%   time_vec_path                 STR
%                                 Path to time vector to load
%
%
%   acq_path                      STR
%                                 Path to acquisition of interest.  Include
%                                 REGISTERED if desired
%
%
%   OUTPUTS:
%
%   time_vec                      VECTOR(DOUBLE) | (SEC)
%                                 Time vector detailing time over which
%                                 volumes were acquired for the acquisition
%                                 of interest.
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 05-Jan-2018
%

err_mode = 'TimeVector';
try
    time_vec_path = verify_path(acq_path, time_vec_path, err_mode);
    time_vec = loadMAT(time_vec_path);
catch ME
    if strcmp(ME.identifier, 'MolloiError:FileIO:fileNotFound')
        time_vec = gen_time_vec(acq_path);
        saveMAT(time_vec, time_vec_path);
    else
        rethrow(ME);
    end
end

end
