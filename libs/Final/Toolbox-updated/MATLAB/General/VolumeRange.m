function [ first, last ] = VolumeRange( vol, LV )
%VOLUMERANGE determines the beginning and end of a volume
%
%   VolumeRange will look through vol and determine at which slice
%   information begins to appear.  This will be characterized as the first
%   slice and last slice that exhibit non-uniform information, as defined
%   as avg(all_px_slice) ~= px_slice.  
%
%   INPUTS:
%
%   vol                           3-D volume
% 
%   LV                            Specifies if you would like to search for
%                                 range of the left ventricle; it searches
%                                 the range over which the myocardium is
%                                 a complete circle, but should only be
%                                 used when vol is a segmentation of ONLY
%                                 the left ventricle; input >= 1 or true for
%                                 LV to process data this way
%
%
%   OUTPUTS:
%
%   first                         First slice to exhibit non-uniform data
%
%
%   last                          Last slice to exhibit non-uniform data
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 29-Nov-2016
%

if nargin == 1 | ~LV
    vol         = double(vol);
    slice_std   = std(std(vol));
    slice_std   = slice_std(1,:);
    first       = find(slice_std ~= 0, 1);
    last        = length(slice_std) + 1 - find(flipdim(slice_std,2) ~= 0, 1);
elseif LV
    sz      = 1000;
    vol     = ~logical(vol);
    for j = 1 : size(vol, 3)
        cc      = bwconncomp(vol(:,:,j));
        n_px    = cellfun(@numel, cc.PixelIdxList);
        if cc.NumObjects > 1 & n_px(2) > sz
            first = j;
            break;
        end
    end
    clearvars j;
    for j = size(vol,3) : -1 : 1
        cc      = bwconncomp(vol(:,:,j));
        n_px    = cellfun(@numel, cc.PixelIdxList);
        if cc.NumObjects > 1 & n_px(2) > sz
            last = j;
            break;
        end
    end
end





end
