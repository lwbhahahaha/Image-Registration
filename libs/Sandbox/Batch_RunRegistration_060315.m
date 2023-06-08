% Batch run the RunRegistration script to register all images from multiple
% series.

addpath(genpath('\\polaris.radsci.uci.edu\Data4_New\Travis\MATLAB\libsTravis'));
addpath(genpath('\\polaris.radsci.uci.edu\Data4_New\Travis\MATLAB\libsFEX'));

base = '\\polaris.radsci.uci.edu\Data4_New\bpziemer\animal_perfusion_data\06_03_15_data\';

base_directories ={...
%     [base 'Acq07_baseline'], ...
%     [base 'Acq08_adenosine'], ... 
    [base 'Acq09_stenosis']
%     [base 'Acq10_stenosis'], ...
%     [base 'Acq11_stenosis'], ... 
%     [base 'Acq12_stenosis'], ...
%     [base 'Acq13_stenosis'], ...
%     [base 'Acq14_stenosis'], ...
%     [base 'Acq15_stenosis'], ... 
%     [base 'Acq16_adenosine'], ...
%     [base 'Acq17_stenosis'], ...
%     [base 'Acq18_stenosis'], ...
%     [base 'Acq19_stenosis'], ...
%     [base 'Acq20_stenosis'], ... 
%     [base 'Acq21_stenosis'], ...
%     [base 'Acq22_stenosis']
    };

reference_images ={...
%      'nii22',...
%      'nii25', ...
     'nii18'
%      'nii19', ...
%      'nii18', ...
%      'nii22', ...
%      'nii16', ...
%      'nii17', ...
%      'nii18', ...
%      'nii13', ...
%      'nii13', ...
%      'nii14', ...
%      'nii11', ...
%      'nii13', ...
%      'nii13', ...
%      'nii13'
     };

for idx = 1 : numel(base_directories)
    output_text = [ 'Running registration on: ' base_directories(idx) ];
    disp( output_text );
    try
        base_directory = base_directories{idx};
        reference_fname = reference_images{idx};
        RunRegistrationDICOM(base_directory, reference_fname)
    catch exception
        message = sprintf(['Batch_RunRegistration: Error occured while '...
               'processing %s.\n Error message: %s.'],...
               base_directory, exception.message);
        disp(message);
    end
end
