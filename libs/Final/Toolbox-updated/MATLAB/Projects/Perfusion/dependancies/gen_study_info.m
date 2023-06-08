function [ study_date, acq_label ] = gen_study_info( acq_path )
%[ study_date, study_label ] = gen_study_info( acq_path )
%
%GEN_STUDY_INFO parses the study date and acquisition label from the 
% provided acquisition path
%
%   gen_study_info
%
%   INPUTS:
%
%   acq_path                      STR
%                                 Path to acquisition of interest.  Include
%                                 REGISTERED if desired
%                                 
%
%
%   OUTPUTS:
%
%   study_date                    STR
%                                 String of date of study
%
%
%   acq_label                     STR
%                                 Acquisition label
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 05-Jan-2018
%

%'Z:\Alireza\Limb NEW Project\3-13-2023/Flow 220_2543/REGISTERED/'

acq_path_lbl = regexpi(acq_path, 'acq(\d+)|(LCA)|(LAD)|(RCA)|CTP(\d+)|REST|STRESS|(Buffalo_Patient[0-9]+)|Acq(_\d+)', 'match');
acq_label = acq_path_lbl{1};
date_path_lbl = regexpi(acq_path, 'PATIENT_(\d+)|(\d\d_\d\d_\d\d_data)|(Buffalo_Patient[0-9]+)|(PATIENT_\d_DATA)','match');
if isempty(date_path_lbl)
    study_date = 'N/A';
elseif numel(date_path_lbl)>1 % added 09/10/2018 to accommodate for Human Patient studies with two matches - Patient number more relevant than date
    study_date = date_path_lbl{2};
else
    study_date = date_path_lbl{1};
end
end
