function [ reg_tf ] = is_acq_registered( acq_path )
%[ reg_tf ] = is_acq_registered( acq_path )
%
%IS_ACQ_REGISTERED checks if the acq_path is already registered
%
%   is_acq_registered
%
%   INPUTS:
%
%   acq_path                      STR
%                                 Path to acquisition of interest
%
%
%   OUTPUTS:
%
%   reg_tf                        LOGICAL
%                                 If acq_path is registered, then return 1,
%                                 else return 0
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 08-Jan-2018
%

reg_tf = 0;
regexp_str = '(REGISTERED)'; % add other strings to search for, to determine if acq_path is registered
if ~isempty((regexpi(acq_path, regexp_str, 'match')))
    reg_tf = 1;
end

end
