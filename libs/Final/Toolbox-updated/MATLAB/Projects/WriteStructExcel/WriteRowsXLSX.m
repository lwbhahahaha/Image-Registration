function [  ] = WriteRowsXLSX( fpath, sheet, header, row_data )
%WRITEROWSXLSX writes data to excel file
%
%   WriteRowsXLSX streamlines the process of writing data to an excel file
%
%   INPUTS:
%
%   fpath                         File path of excel file to write to
%
%
%   sheet                         Sheet to write data
%
% 
%   header                        Header labels for row data; all rows in
%                                 row_data lengths MUST match header length
%                                 i.e., if the header is: {'LAD', 'LCX',
%                                 'RCA'}, all rows must have THREE
%                                 elements, {'LAD_mass', 'LCX_mass',
%                                 'RCA_mass'}
%
%   row_data                      Cell array of row data to write to file
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 11-Sep-2017
%

% Determine number of header entries:
n_header = length(header);

% Check if fpath exists:
if ~exist(fpath, 'file')
    xlswrite(fpath, header, sheet);
else
    [~,cur_sheets] = xlsfinfo(fpath);
    if ~any(strcmp(cur_sheets, sheet))
        xlswrite(fpath, header, sheet);
    end
end

n_row    = 1;
for rows = row_data
    r    = rows{1};
    if length(r) ~= n_header
        warning('Row %i entry length does not match header entry length.', n_row);
    end
    xlsappend(fpath, r, sheet);
    n_row = n_row + 1;
end

end
