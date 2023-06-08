%ITKISOTROPICRESAMPLEFILTER 
% 
% filtered = itkIsotropicResampleFilter(input, image_spacing, isotropic_spacing, opt_interp_type);
%
% input -- 2D or 3D image which is to be smoothed
% image_spacing -- inter voxel spacing of the input image
% isotropic_spacing -- desired isotropic spacing (scalar input)
% opt_interp_type -- optional input to choose the interpolation method
%   * if equal to the character 'l', linear interpolation is used
%   * if equal to the character 's', sinc interpolation is used
%   * Sinc interpolation is theoretically the best method to use, though
%   the computational burden is signficantly increase.
%
%
% Example Usage:
% 
% I = TiffStackRead('Example_Brain.tif');
% % input image is expected to be double
% I = double(I);
% B = itkIsotropicResampleFilter(I, [1,1,2], 0.5, 'l');
%
% Approximate runtimes:
%   * linear interpolation 512x512x320 -> 512x512x640 ~ 5.5s
%   * sinc interpolation 128x128x80 -> 128x128x160 ~ 14s
