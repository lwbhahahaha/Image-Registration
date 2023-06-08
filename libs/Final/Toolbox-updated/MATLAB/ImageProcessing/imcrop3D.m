function cropped = imcrop3D(I, BB, fill_value)
% IMCROP3D Crops a 3-D image to the given bounding box
%
% cropped = imcrop3D(I, BB)
%
% Expand the BB with ExpandRect before calling this to resize the box.
%
% There is an optional third input that, if present, causes the image to
% retain its original size and simply sets all values outside of the BB to
% the inputted fill_value.
%
% Author: Travis Johnson
%         Molloi Lab Group

% Input argument checking
if nargin == 2
    fill_value = nan;
end

% If BB is not in units of numbers of pixels: issue a warning, round the
% inputted values, and attempt to continue
if sum(mod(BB, 1))
    warning('Non integer numbers found in BB, rounding to the nearest integers.');
    BB = round(BB);
end

% Get the bounding values
xmin = BB(1); 
xmax = xmin + BB(1+3) -1;

ymin = BB(2); 
ymax = ymin + BB(2+3) -1;

zmin = BB(3); 
zmax = zmin + BB(3+3) -1;

% Perfrom the cropping
if isnan(fill_value)
    %  x and y need to be switched here due to column vs row ordering
    cropped = I(ymin:ymax, xmin:xmax, zmin:zmax);
else % preserve size and fill values outside of BB to fill_value
    cropped = fill_value .* ones(size(I));
    cropped(ymin:ymax, xmin:xmax, zmin:zmax) = I(ymin:ymax, xmin:xmax, zmin:zmax);
end