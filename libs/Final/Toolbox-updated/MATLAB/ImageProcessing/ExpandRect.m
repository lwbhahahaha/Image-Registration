function new_rect = ExpandRect(rect, num_expansion)
%EXPANDRECT Enlarges (or shrinks) a rectangle of the form [ul_corner widths]
%
% A convenience function which will expand(shrink) a rectangle in the format
% required for MATLAB's imcrop command or my imcrop3D. The rectangle can be
% any dimensionality though.
%
% Example usage:
% % Get bounding box of the largest connected component of a binary image
% [~, BB] = MaxConnComp(mask ~= 0);
% % Expand this BB
% BB = ExpandRect(BB, 5);
% % crop an image with the bounding box and a bit of a buffer
% imcrop(I, BB);
%
% Author: Travis Johnson
%         Molloi Lab Group

% Input argument checking
num_dims = length(rect)/2;
% Make sure that rect has an even number of elements
if mod(num_dims, 1) ~= 0
    error('ExpandBB: rect must be of the form [ul_corner widths], ex [100 50 25 100 200 5] for three dimensions.');
end
% Ensure that the num_expansion has the right dimensionality, i.e. is either
% a scalar or equal to num_dims
if isscalar(num_expansion)
    num_expansion = num_expansion * ones(1, num_dims);
elseif numel(num_expansion) ~= num_dims
    error('ExpandBB: Dimensionality of inputs does not match.');
end

% Expand the rect
new_rect = rect + [-num_expansion, 2*num_expansion];