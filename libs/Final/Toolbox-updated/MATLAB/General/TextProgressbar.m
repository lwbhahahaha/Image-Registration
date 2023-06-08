classdef TextProgressbar < handle
%TEXTPROGRESSBAR A simple class to display progress via text
%
% Class Methods:
%  TP = TextProgressbar(base_str)
%       Constructor that takes the base string as input
%  delete(TP)
%       Destructor that prints 'message_str DONE' and destroys the object
%  display(TP, bool)
%       Displays or undisplays the text progress, bool defaults to true
%  update(TP, progress_str)
%       Changes the displayed string to 'base_str progress_str'
%
% It is possible to turn off the displayed messages globally using the
% following:
%   global TEXTPROGRESSBAR_DONT_DISPLAY
%   TEXTPROGRESSBAR_DONT_DISPLAY = 1;
%
% Author: Travis Johnson
%         Molloi Lab

    % % % % % % % % % % % % % % % %
    properties
        base_str;
        progress_str;
        is_displayed;
        global_display_off;
    end %properties
    
    % % % % % % % % % % % % % % % %
    methods
        
    % Constructor (with default value)
        function TP = TextProgressbar(message_str)
            if nargin == 0
                message_str = 'TextProgessbar: ';
            end
            TP.base_str = message_str;
            TP.progress_str = '';
            % Check if displaying is turned off globally
            global TEXTPROGRESSBAR_DONT_DISPLAY
            if TEXTPROGRESSBAR_DONT_DISPLAY
                TP.global_display_off = 1;
                TP.is_displayed = false;
            else
                TP.global_display_off = 0;
                TP.display();
            end
        end
        
    % Destructor
        function delete(TP, message)
            if nargin == 1
                message = 'DONE\n';
            end
            % Undisplay everything
            TP.display(false);
            % Write out a final farewell
            if ~TP.global_display_off
                Print([TP.base_str, message]);
            end
            % Unset properties
            TP.base_str = '';
            TP.progress_str = '';
        end
        
    % Displays the progressbar
        function display(TP, bool)
            if TP.global_display_off
                return
            end
            if nargin == 1
                bool = true;
            end
            
            if bool
                if TP.is_displayed
                    % do nothing
                else
                    % TextProgressbar is not currently displayed so display
                    % it
                    Print([TP.base_str, TP.progress_str]);
                    TP.is_displayed = true;
                end
            else % Undisplay the progressbar
                if TP.is_displayed
                    Unprint([TP.base_str, TP.progress_str]);
                    TP.is_displayed = false;
                else
                    % do nothing
                end
            end
        end
        
    % Updates the progressbar
        function update(TP, progress_str)
            if TP.global_display_off
                return
            end
            if TP.is_displayed
                % Clear out the current progress_str
                Unprint(TP.progress_str);
                % Write the new one
                TP.progress_str = progress_str;
                Print(progress_str);
            end % TextProgressbar is not currently displayed
        end
        
    end % public methods
    
end % classdef

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Internal functions

% Print function so that the method can be changed easily if desired.
function Print(string)
    fprintf(1, string);
end

% Called to delete a printed string by printing backspace characters in
% their place
function Unprint(string)
    string = strrep(string, '%%', '%');
    backspaces = regexprep(string, '.', '\\b');
    fprintf(1, backspaces);
end