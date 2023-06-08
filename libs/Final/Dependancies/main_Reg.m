function main_Reg(base_directory, reference_image)

base = '/pub/kelvinhp/animal_perfusion_data/3_30_16_data';
base_directories = [base base_directory];
ref_img = reference_image;

output_text = [ 'Running registration on: ' base_directories ];
    disp( output_text );
    try
        b_dir = base_directories;
        reference_fname = ref_img;
        RunRegistrationDICOM(b_dir, reference_fname)
    catch exception
        message = sprintf(['Batch_RunRegistration: Error occured while '...
               'processing %s.\n Error message: %s.'],...
               b_dir, exception.message);
        disp(message);
    end
