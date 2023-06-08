function [ time_vec ] = gen_time_vec( acq_path )
%[ time_vec ] = gen_time_vec( acq_path )
%
%GEN_TIME_VEC generates a time vector for the provided acquisition, by
% parsing time information from DICOM headers.
%
%   gen_time_vec
%
%   INPUTS:
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

acq_path = strrep(acq_path, '/REGISTERED', '');
dcm_regexp = '\.\d+\\$|\d\\$';
dcm_folders = natsort(regexpdir([acq_path '/DICOM/'], dcm_regexp, false));
n_folders = length(dcm_folders);
idx_vec = cell(n_folders, 2);
j = 1;
progressbar('Generating time vector...');
for f = dcm_folders'
    idx_vec{j,2} = f{1};
    dcm_files = regexpdir(f{1}, '\.dcm$', false);
    dcm_header = dicominfo(dcm_files{1});
    idx_vec{j,1} = dcm_time2sec(dcm_header.ContentTime);
    progressbar(j/n_folders);
    j = j + 1;
end
idx_vec = sortrows(idx_vec);
min_time = idx_vec{1,1};
time_vec = [idx_vec{:,1}];
time_vec = time_vec - min_time;

end
