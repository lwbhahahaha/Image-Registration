function resampled = IsotropicResample3D(image, voxel_size, method)
%ISOTROPICRESAMPLE3D Resamples a volume to make voxels isotropic
%
% resampled = IsotropicResample3D(image, voxel_size, method)
%
% Assumes that the x and y resolution is the same so that only the z
% direction needs to be rescaled and interpolated.
%
% Author: Travis Johnson
%         Molloi Lab

% Default arguments and input checking
if nargin < 3
    method = 'linear';
end

if voxel_size(1) ~= voxel_size(2)
    ME = MException(strcat(mfilename, ':Input:voxel_size'),...
            ['The in-plane resolution (first and second coordinates of'...
             ' voxel_size) is expected to be isotropic.']);
    throw(ME)
end

im_size = size(image);

% step size of z-direction resampling in in-plane-pixel units
sampling_step = voxel_size(1)/voxel_size(3);

% grid points at which to resample the data
[X, Y, Z] = meshgrid(1:im_size(2), 1:im_size(1), 1 :sampling_step: im_size(3));  %Changed by Shant for varying image sizes.

% do the interpolation
resampled = interp3(double(image), X, Y, Z, method);