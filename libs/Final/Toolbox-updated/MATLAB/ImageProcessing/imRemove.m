function [ I_out ] = imRemove( I_in, obj_size )
%IMREMOVE removes objects smaller than size from I_in.
%
%   imRemove us bwconncomp to compute the size of each distinct object in
%   I_in.  Connectivity of distinct objects defaulted to 8 (2D) and 26 (3D).
%   If no obj_size is specified, then only the maximum sized object is
%   kept.
%
%   INPUTS:
%
%   I_in                          2D or 3D binary image.
%
%
%   obj_size                      Minimum size of objects to KEEP in image.
%
%
%   OUTPUTS:
%
%   I_out                         2D or 3D binary image with objects
%                                 smaller than size removed
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 06-Aug-2015
%

if nargin == 0
    error('Not enough inputs');
end

I_label = bwconncomp(I_in);
I_props = regionprops(I_label);
I_area = [I_props.Area];

switch nargin
    case 1
        obj_size = max(I_area);
    case 2
end

if size(I_area)
    I_out = double(bwareaopen(I_in, round(obj_size)));
else
    I_out = I_in;
end

end
