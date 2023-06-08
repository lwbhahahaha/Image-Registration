function  gen_func( varargin )
%GEN_TEMPLATE_FUNC creates a new function.
%   GEN_TEMPLATE_FUNC will act to create a new function file with a header
%   specified by the inputs.  The newly created function is insatiated into
%   the current directory.
%   
%   GEN_TEMPLATE_FUNC(FUNC_NAME, AUTHOR, ARGIN, ARGOUT) creates a new
%   function, named FUNC_NAME, with inputs ARGIN and outputs ARGOUT.  Also
%   creates a description of this new function with the FUNC_NAME, AUTHOR, 
%   ARGIN and ARGOUT included in the description.
%   
%   GEN_TEMPLATE_FUNC(FUNC_NAME, AUTHOR, ARGIN) creates a new function,
%   named FUNC_NAME, with no outputs.
%
%   GEN_TEMPLATE_FUNC(FUNC_NAME, AUTHOR) creates a new function, named
%   FUNC_NAME, with no outputs or inputs.
%
% 
% 
%   Parameters include:
%
%
%   'FUNC_NAME'                 Name of new function (do not include .m)
%
%   'AUTHOR'                    Name of author
%
%   'ARGIN'                     Cell array of the inputs to the function
%
%   'ARGOUT'                    Cell array of the outputs of the function
%
%   'DEPENDANCIES'              Cell array of external dependacies (mex file, other
%                               MATLAB functions, data, etc) (optional)
%                               (currently not implemented
%
%
% Example Use:
%
% func_name = 'itkMyocardiumAssignment';
% author = 'Shant Malkasian';
% argin = {'bwMYO','vesselPath'};
% argout = {'timecrossMap'};
% dependancies = {'itkFastMarchingAssignment.mex64'};
%
% gen_template_func(func_name,author,argin,argout,dependancies);
%

func_name = varargin{1};
author = cell2mat(get_vars(func_name,'-inputs',varargin));
argin = get_vars('-inputs','-outputs',varargin);
argout = get_vars('-outputs','-demo_script', varargin);
demo_script = get_vars('-demo_script', '', varargin);
demo_script = demo_script{1};
if isempty(demo_script)
    demo_script = false;
else
    demo_script = true;
end

switch length(varargin)
    case 1
        %RAISE ERROR (not enough parameters)
        error('Please include at least FUNC_NAME and AUTHOR\n');
end



%Get current directory to make new function in
currentFolder = pwd;
currentDate = date;
newFuncPath = [currentFolder '\' func_name '.m'];

%Check if file already exists
if exist(newFuncPath,'file') == 2
    error('The function ''%s'' already exists.',func_name);
end


newFuncID = fopen(newFuncPath,'wt');


%Create empty string to format
nargin = length(argin);
nargout = length(argout);

first_line_template = format_title(nargin,nargout);
header_template     = format_header(nargin,nargout,argin,argout);
func_nameUPPER      = upper(func_name);
%Format strings
first_lineFormatted = sprintf(first_line_template,argout{:},func_name,argin{:});
first_lineFormatted_comment = sprintf([strrep(first_lineFormatted, 'function ', '\n%%') '%%']);
headerFormatted     = sprintf(header_template,func_nameUPPER,func_name,author,currentDate);


%Add first_lineFormmatted
file_contents = first_lineFormatted;
file_contents = strcat(file_contents, first_lineFormatted_comment, headerFormatted);

    
    %ADDITION OF %S FOR FORMATTING; ORDER MATTERS!
    function str_out = format_title(nargin,nargout)
        %FORMAT ORDER:
        %(argout,func_name,argin)
        str_out = 'function [ ';
        for i=1:nargout-1
            str_out = strcat(str_out,' %s,'); %add enough formats for output
        end
        str_out = strcat(str_out,' %s ] = %s( '); %add format for func name
        for i=1:nargin-1
            str_out = strcat(str_out,' %s,'); %add enough formats for inputs
        end
        str_out = strcat(str_out,' %s )\n');
    end
    
    function str_out = format_header(nargin,nargout,argin,argout)
        %FORMAT ORDER:
        %(upper(func_name),func_name,author,date,argin,argout)
        ln1 = '\n%%%s ADD ONE SENTENCE DESCRIPTION\n%%\n';
        ln2 = '%%   %s ADD THOROUGH DESCRIPTION\n%%\n';
        ln3 = '%%   AUTHOR:       %s\n';
        ln4 = '%%   DATE CREATED: %s\n%%\n';
        ln_inputs = '';
        inputs = '';
        ln_outputs = '';
        outputs = '';
        var_descrip = '%%                                 INCLUDE VAR DESCRIPTION\n%%\n%%\n';
        if ~isempty(argin{1})
            ln_inputs = '%%   INPUTS:\n%%\n';
            inputs = '';
            for i=1:nargin
                in_str = add_var2str(argin{i},var_descrip);
                inputs = strcat(inputs,in_str);
            end
        end
        if ~isempty(argout{1})
            ln_outputs = '%%   OUTPUTS:\n%%\n';
            outputs = '';
            for i=1:nargout
                in_str = add_var2str(argout{i},var_descrip);
                outputs = strcat(outputs,in_str);
            end
        end
        str_out = [ln1 ln2 ln_inputs inputs ln_outputs outputs ln3 ln4 ];
    end

    function str_out = add_var2str(var,str_in)
        %USED TO ADD WHITESPACE RIGHT OF VAR INPUT
        ind_start = strfind(str_in,'%%');
        ind_start = ind_start(1) + 5;
        var_len = length(var);
        str_out = str_in;
        str_out(ind_start:ind_start + var_len-1) = var;
    end

    function cellVar = get_vars(startDelim,endDelim, varargin)
        cellVar = {''};
        addVar = 0;
        count = 1;
        for i=varargin{1}
            temp = char(i);
            if( strcmp(temp,startDelim) )
                addVar = 1;
            elseif( strcmp(temp,endDelim) )
                break
            elseif( addVar )
                cellVar{count} = temp;
                count = count + 1;
            end
        end
    end


%Print complete file contents to file
fprintf( newFuncID,'%s',file_contents );
%End function statement
fprintf( newFuncID,'\nend\n' );
fclose(newFuncID);
eval(sprintf('edit %s', newFuncPath));
% Update SVN repo
% svn add  % DO I WANT THIS??

if any(isstrprop(func_name(1), 'upper')) || demo_script
    gen_script(author, ['demo' func_name], sprintf('This script will demonstrate examples of how to use the function ''%s''.', [func_name '.m']));
end

end

