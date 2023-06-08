function [  ] = error_check_path( file_path, t )
%[  ] = error_check_path( file_path, t )
%
%ERROR_CHECK_PATH checks if the inputted file exists and raises a
%descriptive PerfusionError if it doesn't.  This allows for more precise
%exception handling.
%
%   error_check_path
%
%   INPUTS:
%
%   file_path                     STR
%                                 File path of interest
%
%
%   t                             STR
%                                 Error label
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 05-Jan-2018
%

err_lbl = sprintf('PerfusionError:fileNotFound:%s',lower(t));
err_txt = 'Perfusion Error \nFileNotFound | %s | %s\n';
if ~exist(file_path, 'file')
    error(err_lbl, err_txt, upper(t), file_path);
end

end
