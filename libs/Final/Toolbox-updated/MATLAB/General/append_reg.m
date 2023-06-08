function output_directory=append_reg(input_dir)
%append_reg checks to see if the input folder ends with 'REGISERTED'. If it
%does it does nothing, if not it adds it.

%   INPUTS:
%
%   input_dir                     Path of study to process. Will check the
%                                 string of this nput

%
%
%   OUTPUTS:
%
%   output_directory              New string contianing 'REGISTERED' at the
%                                 end
%   AUTHOR:       Brian Dertli
%   DATE CREATED: 09-JAN-2017


match=regexpi(input_dir,'registered');
input_dir = strrep(input_dir, '\', '/');
if ~isempty(match)
    output_directory=input_dir;
else
    if input_dir(end)==('\') | input_dir(end)==('/')
      output_directory=[input_dir 'REGISTERED/'];
    else      
        output_directory=[input_dir '/REGISTERED'];
    end
end
