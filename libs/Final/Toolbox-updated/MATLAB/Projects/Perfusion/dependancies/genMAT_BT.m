function [ delta_time ] = genMAT_BT( acq_dir )
% acq_dir =  '\\polaris\Data4_New\bpziemer\animal_perfusion_data\02_11_20_data\Acq1\CT SURESTART Cardiac 2.0 CE';
% acq_dir = '\\polaris\Data4\bpziemer\animal_perfusion_data\09_25_20_data\Acq_08_Lung_Pro';


%
%   genMAT generates MAT files for each DICOM Bolus Tracking image found in
%   acq_dir.  This function is exclusive to generating MATs from DICOMs,
%   but could be adapted to generating MAT files from TIFFs.  This function
%   is adapted from previously written code.
%
%   INPUTS:
%
%   acq_dir                       Acquisition directory to process
%
%
%   AUTHOR:       Yixiao Zhao
%   DATE CREATED: 11-Feb-2020
%

dcm_regexp      = '\.\d+\\$';

% Set paths:

dcm_dir         = [acq_dir '/SureStart'];
time_vec_path   = [acq_dir '/time_vector_SureStart.mat'];
data_vec        = gen_time_vector(dcm_dir);
dcm_paths       = data_vec(:,2);
time_vec        = cell2mat(data_vec(:,1));
save([acq_dir '/time_vector_SureStart.mat' ], 'time_vec');

dcm_dir_dicom   = [acq_dir '/DICOM/02'];
data_vec_V2        = gen_time_vector(dcm_dir_dicom);
dcm_paths_V2       = data_vec_V2(:,2);
time_vec_V2        = cell2mat(data_vec_V2(:,1));

interval = time_vec(2) - time_vec(1);
delta_time = time_vec_V2(end) - time_vec(end);% - interval;


%% HELPER FUNCTIONS:
    function [index_vec] = gen_time_vector( dcm_dir )

       
       dcm_folders  = dir(dcm_dir);
       fn           = length(dcm_folders)-2;       
      
       % if volume scan/helical scan, use the time of the middle slice
       if fn > 200
           fn = round(fn/2);
       end
       index_vec    = cell(fn, 2);
       progressbar('Generating Time Vector...');

       for j = 1 : fn
           dcm_name = dcm_folders(j+2);
           index_vec{j,2}   = dcm_name.name;
           dcm_files        = [dcm_dir '/' dcm_name.name];
           dcm_header       = dicominfo(dcm_files);
           index_vec{j,1}   = dcm_time2sec(dcm_header.ContentTime);
           progressbar(j / fn);
       end
       index_vec = sortrows(index_vec);
       min_time  = index_vec{1,1};
%        for j = 1 : size(index_vec,1)
%            index_vec{j, 1} = index_vec{j,1} - min_time;
%        end
    end

    function tsec = dcm_time2sec( dcm_time )
       % DCM time tags are saved in the following format (typically):
       %        (hr hr min min sec sec)
       % For example:
       %        120010.00 would equate to -> hr 12 min 0 sec 10 ms 00
        hr      = str2double(dcm_time(1:2));
        min     = str2double(dcm_time(3:4));
        sec     = str2double(dcm_time(5:6));
        msec    = str2double(dcm_time(7:end));
        tsec    = hr * 60^2 + min * 60 + sec + msec; % convert everything to seconds
    end





end
