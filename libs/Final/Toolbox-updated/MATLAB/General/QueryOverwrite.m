function [bool, new_override] = QueryOverwrite(fname, override)
%QUERYOVERWRITE Asks the user if overwriting a file is permissible
%
% Helper function to determine if a file should be overwritten or not. If
% override is set to 1 bool will be set to true and the file overwritten.
% If override is set to -1 and the file exists, bool is set to false and
% the file should not be overwritten. Otherwise, query the user what should
% happen. Two of the possibilities are 'Yes to All' and 'No to All',
% selection of one of these will be reflected in the new_override return
% variable. Which can be passed back in the next time this is called so as
% to stop repeated questioning.
%
% Author: Travis Johnson
%         Molloi Lab

% Default value
if nargin == 1; override = 0; end;

% Determine if the file exists
file_exists = (exist(fname, 'file') == 2);
% Get the name of the calling function
calling_filename = dbstack(1);
if isempty(calling_filename) % if called from the base workspace
    calling_filename = 'QueryOverwrite';
else
    calling_filename = calling_filename.name;
end

% Because logic
if override == 1 || ~file_exists
    bool = true;
    new_override = override;
    return
elseif override == -1 % and file exists
    bool = false;
    new_override = -1;
    return
else % file_exists and override isn't set, so we query the user
    res = '_';
    while res == '_'
        % Query for a response from the user
        res = input([calling_filename ': ' fname ' already exists. Overwrite?\n' 'Yes(1)   No(2)   Yes to All(3)   No to All(4)\n'], 's');
        % Determine what to do with that response
        switch res
            case {'1', 'y', 'Y', 'yes', 'Yes'}
                bool = true;
                new_override = override;
            case {'2', 'n', 'N', 'no', 'No'}
                bool = false;
                new_override = override;
            case '3'
                bool = true;
                new_override = 1;
            case '4'
                bool = false;
                new_override = -1;
            otherwise
                res = '_';
                disp('Invalid Response. Try again.');
        end
    end
end