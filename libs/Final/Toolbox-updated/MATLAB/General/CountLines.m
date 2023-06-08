function count = CountLines(fname)
%COUNTLINES Counts the number of lines in a text file.
%
% count = CountLines(fname)
%
% Technically, this function counts newline characters; therefore, the
% actual number of lines if the file is opened in a text editor is one more
% than the result of this function. This is intended. The function is made
% to play nice with generated files where each line of interest ends in a
% newline and the final line is blank.
%
% Algorithm modified from a StackOverflow answer:
% http://stackoverflow.com/questions/12176519/is-there-a-way-in-matlab-to-determine-the-number-of-lines-in-a-file-without-loop

fid = fopen(fname, 'r');

% ensure that the file opened fine
if fid == -1
    exception = MException(strcat(mfilename, ':FileNotOpened',...
                    'The file %s could not be opened for reading.'),...
                    filename);
    throw(exception);
end
% create object to cleanup the file on exit
cleanup = onCleanup(@() fclose(fid));

count = 0;
while ~feof(fid)
    % count the number of newline characters (ascii value of 10)
    % reads in the file in chunks of size 2^14
    count = count + sum( fread( fid, 16384, 'char' ) == char(10) );
end