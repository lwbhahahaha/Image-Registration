function [  ] = WriteStructExcel( fpath, sheet, struct_data )
%WRITESTRUCTEXCEL writes the inputted structured element to an excel file
%
%   WriteStructExcel uses fieldnames to write the inputted structured
%   element data to an excel file.  By using structures, header information
%   is assumed by parsing the fieldnames from the inputted data. This is
%   more robust and efficient than using separate header inputs, and allows
%   for more flexibility and generalization.
%
%   INPUTS:
%
%   fpath                         Excel file output path
%
%
%   sheet                         Sheet to output data into excel to
%
%
%   struct_data                   Structured element; this data should be
%                                 organized as follows:
%                                 struct_data(n_row).fieldexample1 = 10
%                                 struct_data(n_row).fieldexample2 = 20
% 
%                                 n_row an integer denoting the ROW data
%                                 will be outputted to in excel, while
%                                 fieldexampleN is the COLUMN; in excel the
%                                 fieldexampleN will be used to label
%                                 COLUMNs
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 11-Sep-2017
%

% Get header labels:
xlsx_header = fieldnames(struct_data)';
num_rows    = length(struct_data);
for n = 1 : num_rows
    WriteRowsXLSX(fpath, sheet, xlsx_header, {get_row(struct_data, xlsx_header, n)});
end

%% HELPER FUNCTIONS:
    function [row] = get_row(data, labels, row_n)
        % returns entire row at row_n from structured element data
        row = cell(1,length(labels));
        for i = 1 : length(labels)
            row{i} = data(row_n).(labels{i});
        end
    end
end
