function [ verf_path ] = verify_path( acq_dir, path, txt )
%[ verf_path ] = verify_path( acq_dir, path )
%
%VERIFY_PATH verifies the provided path of interest
%
%   verify_path verifies whether the inputted path exists.  If path already
%   exists, then the function will not do anything (ABSOLUTE MODE).  If 
%   path does not exist, the function will attempt to find path within 
%   acq_dir (LOCAL MODE).
%
%   INPUTS:
%
%   acq_path                      STR | '//polaris.../05_13_15_data/ACQ1'
%                                 Complete path to acquisition of interest.
%                                 Include 'REGISTERED' if necessary, it
%                                 will not be automatically appended.
%
%
%   path                          STR | '/SOMEFOLDER/SOMEFILE.mat'
%                                 Absolute or local path to file or
%                                 directory of interest.  This function
%                                 will intelligently determine whether to
%                                 return the LOC or ABS path.
% 
%   txt                           STR
%                                 Short string describing the file that is
%                                 trying to be loaded
%
%
%   OUTPUTS:
%
%   verf_path                     STR | '/SOMEFOLDER/SOMEFILE.mat'
%                                 Verified path to file or directory of
%                                 interest.  This path is guaranteed to
%                                 exist.
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 06-Feb-2018
%

warning_id_isloc = 'FileIO:localPath';
warning_id_isabs = 'FileIO:absolutePath';
error_id = 'FileIO:fileNotFound';

% CHECK IF PATH EXISTS
if exist(path, 'file') || exist(path, 'dir')
    verf_path = path;
    molloi_warning(warning_id_isabs, 'Current path is absolute', [verf_path ' | ' txt]);
    return
else
% IF PATH IS NOT FOUND, TRY APPENDING PATH TO ACQ_DIR
    if exist([acq_dir path], 'file') || exist([acq_dir path], 'dir')
        verf_path = [acq_dir path];
        molloi_warning(warning_id_isloc, 'Current path is local', [verf_path ' | ' txt]);
        return
    else
        molloi_error(error_id, 'Current path cannot be found', [path ' | ' txt]);
    end
end

end
