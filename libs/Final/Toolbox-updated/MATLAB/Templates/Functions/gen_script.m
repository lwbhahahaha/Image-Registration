function [  ] = gen_script( author, script_name, details )
%[  ] = gen_script( author, script_name, details )
%
%GEN_SCRIPT creates a template script using the provided inputs
%
%   gen_script
%
%   INPUTS:
%
%   author                        STR
%                                 Name of author creating script
%
%
%   script_name                   STR
%                                 Name of script
% 
%   details                       STR | OPTIONAL
%                                 Any text details to include in the
%                                 description section of script
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 20-Mar-2018
%


% SECTION 0: Initialize variabls
if ~isempty(regexpi(script_name, '\.[a-z]*', 'match'))
    % Remove file extensions if they were included in script_name
    % accidentally
    cur_ext_idx = strfind(script_name, '.');
    script_name = script_name(1:cur_ext_idx-1);
end
script_file_name = [script_name '.m'];

if exist(script_file_name, 'file') == 2
    error('The script ''%s'' already exists.', script_file_name);
end

if nargin < 2
    details = 'INSERT DESCRIPTION OF SCRIPT HERE';
end

cur_date_str = date;
insert_txt = {script_file_name,... %NOTE: Order matters for FORMAT below
              author,...
              cur_date_str,...
              details};

% SECTION 1: Define template strings
header_template = {'%%%%  Script - %s\n%%\n',... %FORMAT: script_name
                   '%% Author: %s\n',... %FORMAT: author
                   '%% Date:   %s\n',... %FORMAT: cur_date_str
                   '%% Description: %s\n%%\n\n'}; %FORMAT: details
body_text = '%%   SECTION 0:  Initialize variables';

% SECTION 2: Format template strings
format_header = [ ];
for i = 1 : length(header_template)
    format_header = [format_header sprintf(header_template{i}, insert_txt{i})];
end

format_header = [format_header body_text];

% SECTION 3: Write text to file
cur_script_file = fopen(script_file_name, 'w');
fprintf(cur_script_file, '%s', format_header);
fclose(cur_script_file);

% SECTION 4: Open newly made script
eval(sprintf('edit %s', script_file_name));
end
