function [ proc_path ] = process_path( raw_path )
%[ proc_path ] = process_path( raw_path )
%
%PROCESS_PATH formats the inputted path string by replacing all '\' to '/'
%(YES, there is a difference!) and to always have a leading '/' and NO
%trailing '/'.
%
%   process_path formats the inputted path string by replacing all '\' to '/'
%   (YES, there is a difference!) and to always have a leading '/' and NO
%   trailing '/'.  This is to provide standardized file paths for consist
%   functionality in parent functions, such as VolumePerfusion.
%
%   INPUTS:
%
%   raw_path                      STR
%                                 Unprocessed path
%
%
%   OUTPUTS:
%
%   proc_path                     STR
%                                 Processed path, with '\' replaced with
%                                 '/', leading with '/' and no trailing
%                                 '/'
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 05-Jan-2018
%

proc_path = strrep(raw_path, '\', '/');
if ~strcmp(proc_path(1), '/') && isempty(regexp(proc_path, '^[A-Z]:/', 'match'))
    proc_path = ['/' proc_path];
end
if strcmp(proc_path(end), '/')
    proc_path = proc_path(1:end-1);
end
end
