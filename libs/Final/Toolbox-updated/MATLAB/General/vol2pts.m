function [ pts ] = vol2pts( vol, n )
%VOL2PTS converts binary image volume to a set of points
%
%   vol2pts converts a binary image volume to a set points.  This function
%   assumes the image entered is 3D, although the same methods can be
%   easily applied for a 2D image.
%
%   INPUTS:
%
%   vol                           Binary image volume
%
%
%   OUTPUTS:
%
%   pts                           Points generated from binary image
%                                 volume, corresponding to where the image
%                                 has a value of 1.
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 11-Aug-2016
%
    if nargin < 2
        n = 3;
    end
    
    imsize      = size(vol);
    
    switch n
        case 3
        ind         = find( vol > 0 );
        [x, y, z]   = ind2sub( imsize, ind );
        
        pts         = [y, x, z];
        case 2
        ind         = find ( vol > 0 );
        [x, y]      = ind2sub(imsize, ind);
        pts         = [y, x];
    end


end
