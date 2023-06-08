%% Set variables:
base        = '\\polaris\Data4_New\bpziemer\animal_perfusion_data\03_30_16_data\';
base_dir    = [base 'Acq10_Continuous_150mA'];
ref_dir     = [base 'Acq08_Continuous_150mA'];
ref_im      = 'nii27';

%% Register all DICOMs in base_dir to image in ref_dir:

RunRegistrationDICOM_mod(base_dir, ref_dir, ref_im);


