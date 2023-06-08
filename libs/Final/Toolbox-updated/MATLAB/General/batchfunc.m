function [  ] = batchfunc( script )
%BATCHFUNC is a function to run batch scripts.
%
%   batchfunc acts as a wrapper function to run batch process data.
%   The function does this by running the inputted script, line-by-line,
%   allowing for error handling and better progress checking.
%
%   INPUTS:
%
%   script                        Path of desired script to run, include
%                                 extension.
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 10-Feb-2016
%
fid = fopen(script);
tline = fgets(fid);

% Read in script, line-by-line:
lines = {};
count = 1;
while ischar(tline)
    lines{count} = tline;
    tline = fgets(fid);
    count = count + 1;
end
fclose(fid);


% Execute each line in script:
progressbar('Batch Processing...');
for i=1:length(lines)
    try
        eval(lines{i});    
    catch
        fprintf('Problem with the following line:\n%s',lines{i});
    end
    progressbar(i/length(lines));
end




end
