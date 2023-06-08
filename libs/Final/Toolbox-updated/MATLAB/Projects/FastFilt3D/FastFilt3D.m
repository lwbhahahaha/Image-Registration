function [ filt_im ] = FastFilt3D( im, mask_im, k_sz, h_filt )
%[ filt_im ] = FastFilt3D( im, mask_im, k_sz, h_filt )
%
%FASTFILT3D will optimally filter the inputted image volume in 3D
%
%   FastFilt3D will optimally filter the inputted image volume in 3D using
%   the inputted filter handle.  Specifically, this function first crop a
%   smaller area of interest to filter, from the original image, to
%   decrease processing time.  After filtering the specified area, the
%   filtered volume of interest will be padded to return a filtered image
%   of the same size as the inputted image.  It is highly recommended that
%   @nan... functions are used (functions that ignore NaN)
% 
%   *See demoFastFilt3D.m for more examples*
%
%   INPUTS:
%
%   im                            VOLUME(DOUBLE | INT8 | INT16)
%                                 Image volume of scalar values; the
%                                 inputted image must be grayscale
%
%
%   mask_im                       VOLUME(LOGICAL) | Optional
%                                 Binary image volume mask to crop image to
%                                 ; this mask will be used to create a
%                                 bounding box to crop im before applying
%                                 a filter; if no mask can be provided,
%                                 input [] for this parameter to include
%                                 all non-NaN values in im
%
%
%   k_sz                          DOUBLE or VECTOR(DOUBLE) [x y z] | (NUM OF VOXELS)
%                                 Size of edge of cube kernel to filter im
%                                 with; k_sz can be either a scalar (for
%                                 isotropic filtering) or a 3-element
%                                 vector for each dimension [x y z]
%
%
%   h_filt                        FUNCTION_HANDLE
%                                 A function handle to any function where
%                                 the input is a single vector of scalars,
%                                 and the output is a scalar; note,
%                                 function handles are defined as
%                                 @FUNCTION_NAME; also note, it is suggested
%                                 to primarily use NAN functions (i.e. use
%                                 @nanmean or @nanmedian, rather than @mean 
%                                 or @median)
%
%
%   OUTPUTS:
%
%   filt_im                       VOLUME(DOUBLE | INT8 | INT16)
%                                 Filtered image volume; same size and type
%                                 as im
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 20-Mar-2018
%


% SECTION 0: Initialize variables
if isempty(mask_im)
    mask_im = true(size(im));
else
    mask_im = logical(mask_im);
end

if length(k_sz) == 1
    k_sz = [k_sz k_sz k_sz];
end

im(~mask_im) = NaN;

% SECTION 1: Get bounding box
bb = get_bb_(mask_im);

% SECTION 2: Crop im
crop_im = im(bb(1) : bb(4), bb(2) : bb(5), bb(3) : bb(6));

% SECTION 3: Filter cropped im
crop_filt_im = filt_(crop_im, k_sz, h_filt);

% SECTION 4: Uncrop filtered cropped im
filt_im = zeros(size(im));
filt_im(bb(1) : bb(4), bb(2) : bb(5), bb(3) : bb(6)) = crop_filt_im;



%% Helper Functions:
    function [bb_] = get_bb_(mask_im_)
        % DEF bb_ = [DIM1_START DIM2_START DIM3_START DIM1_END DIM2_END DIM3_END]
        % TODO: Generalize for N dimensions...
        im_idx = find(mask_im_ == 1);
        
        [im_sub_dim1, im_sub_dim2, im_sub_dim3] = ind2sub(size(mask_im_), im_idx);
        
        bb_ = [ min(im_sub_dim1) min(im_sub_dim2) min(im_sub_dim3)...
                max(im_sub_dim1) max(im_sub_dim2) max(im_sub_dim3)];
        
    end

    function [filt_im_] = filt_(im_, k_sz_, h_filt_)
        for i_ = 1 : length(k_sz_)
            if mod(k_sz_(i_), 2) == 1
                k_sz_(i_) = k_sz_(i_) - 1;
            end
        end
        k_sz_h = k_sz_ ./ 2;
        k_dim1 = k_sz_h(1);
        k_dim2 = k_sz_h(2);
        k_dim3 = k_sz_h(3);
        im_ = padarray(im_, [k_dim1 k_dim2 k_dim3], NaN);
        im_sz = size(im_);
        filt_im_ = zeros(size(im_));
        n_idx = find(~isnan(im_));
        [n_dim1, n_dim2, n_dim3] = ind2sub(size(im_), n_idx);
        len_n = length(n_dim1);
        progressbar('Filtering...');
        for i_ = 1 : len_n
            cur_idx = sub2ind(im_sz, n_dim1(i_), n_dim2(i_), n_dim3(i_));
            cur_kernel_sub = im_(n_dim1(i_) - k_dim1 : n_dim1(i_) + k_dim1,... % Converting this to using linear indicies would help speed things up
                                 n_dim2(i_) - k_dim2 : n_dim2(i_) + k_dim2,... 
                                 n_dim3(i_) - k_dim3 : n_dim3(i_) + k_dim3);
            filt_im_(cur_idx) = h_filt_(cur_kernel_sub(:));
            progressbar( i_ / len_n );
        end
        filt_im_ = filt_im_(k_dim1 + 1 : end - k_dim1, k_dim2 + 1 : end - k_dim2, k_dim3 + 1: end - k_dim3);
    end



end
