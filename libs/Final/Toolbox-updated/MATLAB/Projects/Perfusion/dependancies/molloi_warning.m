function [  ] = molloi_warning( id, description, text )
%[  ] = molloi_warning( id, description, text )
%
%MOLLOI_WARNING raises warnings specific to Molloi lab projects in a
%consistent manner
%
%   molloi_warning
%
%   INPUTS:
%
%   id                            STR | 'MAIN_ID:SPECIFIC_STATE'
%                                 String denoting the warning ID and, if
%                                 desired, the specific state of the
%                                 warning, as shown above
%
%
%   description                   STR 
%                                 Short, generalized description of
%                                 specific warning to raise
%
%
%   text                          STR
%                                 Short, detail of specific warning to
%                                 raise; text should provide the exact
%                                 details of what caused the warning to be
%                                 raised, for better user interpretation
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 07-Feb-2018
%

warning_id = ['MolloiWarning:' id];
sep_id = strsplit(id, ':');
main_id = sep_id{1};
warning_text = ['MolloiWarning \n' main_id ' | ' description ' | ' text];
warning(warning_id, warning_text);

end
