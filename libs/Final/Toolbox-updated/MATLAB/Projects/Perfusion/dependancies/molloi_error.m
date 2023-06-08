function [  ] = molloi_error( id, description, text )
%[  ] = molloi_error( id, description, text )
%
%MOLLOI_ERROR raises errors specific to Molloi lab projects in a
%consistent manner
%
%   molloi_error ADD THOROUGH DESCRIPTION
%
%   INPUTS:
%
%   id                            STR | 'MAIN_ID:SPECIFIC_STATE'
%                                 String denoting the error ID and, if
%                                 desired, the specific state of the
%                                 error, as shown above
%
%
%   description                   STR 
%                                 Short, generalized description of
%                                 specific error to raise
%
%
%   text                          STR
%                                 Short, detail of specific error to
%                                 raise; text should provide the exact
%                                 details of what caused the error to be
%                                 raised, for better user interpretation
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 07-Feb-2018
%

error_id = ['MolloiError:' id];
sep_id = strsplit(id, ':');
main_id = sep_id{1};
error_text = ['MolloiError \n' main_id ' | ' description ' | ' text];
error(error_id, error_text);

end
