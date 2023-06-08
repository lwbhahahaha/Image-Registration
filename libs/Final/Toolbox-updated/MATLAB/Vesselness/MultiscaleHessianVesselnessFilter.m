function [ im_out ] = MultiscaleHessianVesselnessFilter( im, array_sigma, alpha1, alpha2, folder )
%MULTISCALEHESSIANVESSELNESSFILTER
%  vesselness_im = MultiscaleHessianVesselnessFilter( im, array_sigma,
%  alpha1, alpha2 )
%
%  Takes a 3D CTA image in and applies a Hessian-based filter to each, in order
%  to segment coronary arteries.  The function MIPs the outputs of three
%  scales of sigma.  It will also save the intermediate, unMIPed images.
%
%   im -- 3D CTA image
%   array_sigma -- An array of the desired sigma values to use in
%       vesselness filter
%   alpha1 -- Vesselness constant 1
%   alpha2 -- Vesselness constant 2
%

    im = double(im);
    mkdir(folder);
       
    
    progressbar('Multiscale Vessel Filter');
    im_out = zeros(size(im));
    h_array = [.05, .8; .05, .8; .2, .8; .25, .8];
    for i=1:length(array_sigma)
        progressbar(i/length(array_sigma));
        temp_im = hysteresis3d(VesselnessFilter(im, array_sigma(i), alpha1, alpha2), h_array(i,1), h_array(i,2), 26);
        im_out = bsxfun(@max,temp_im,im_out);
    end
    
    
    
%% HELPER FUNCTIONS
    function [temp_im] = VesselnessFilter( im_in, sigma, alpha1, alpha2 )
        %Helper function, that also saves each scale iteration
        vesselness_name = [folder '/vesselness_' strrep(num2str(sigma),'.','d') '_' num2str(alpha1) '_' num2str(alpha2) '.mat'];
        
        temp_im = itkVesselnessFilter(im_in, sigma, alpha1, alpha2);
%         save(vesselness_name, 'temp_im');
    end

end

