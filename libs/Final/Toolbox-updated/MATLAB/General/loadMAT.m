function [ loadvar ] = loadMAT( filepath, n )
%LOADMAT is a function to condense loading a mat file.
%
%   loadMAT helps the user by allowing for a mat file to be loaded without
%   having to know the variable name.  The function will load the first
%   variable saved to the file, by default.  A different variable can be
%   selected if specified.
%
%   INPUTS:
%
%   filepath                      Path to mat file to load.
%
%
%   n                             The index number of which variable of the
%                                 mat file to load.  Default = 1 (optional)
%
%
%   OUTPUTS:
%
%   loadvar                       The loaded mat variable.
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 14-Jul-2016
%

if      nargin < 2
    n = 1;
elseif  nargin > 2
    error('Input error:  Too many inputs, refer to function documentation');
end

    tempload    = load(filepath);
    tempfields  = fieldnames(tempload);
    loadvar     = tempload.(tempfields{n});
end
