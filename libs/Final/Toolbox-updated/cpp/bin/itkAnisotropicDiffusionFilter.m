%ITKANISOTROPICDIFFUSION 
% 
% filtered = itkAnisotropicDiffusion(input, num_iterations, time_step, conductance_parameter);
%
% input -- 2D or 3D image which is to be smoothed
% num_iterations -- number of times the smoothing will be applied
% time_step -- duration of each iteration
%       * Must be less than 0.125 for 2D or 0.0625 for 3D for stability
% conductance_parameter -- determines the strength of the diffusion
%       * Conductance image is computed as exp(-(abs(gradient)/kappa)^2)
%           where kappa is the conducance parameter; hence a larger value
%           results in greater conductance implying more smoothing
%   
%
% Example Usage:
% 
% A = randi(10, 100, 100, 100);
% 
% num_iterations = 50;
% time_step = 0.0625;
% conductance = 5;
% 
% B = itkAnisotropicDiffusion(A, num_iterations, time_step, conductance);
% 
% imtool3D(B)