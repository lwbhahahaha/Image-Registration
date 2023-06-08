%%  Script - demoFastFilt3D.m
%
% Author: ShantMalkasian
% Date:   20-Mar-2018
% Description: This script will demonstrate examples of how to use the function 'FastFilt3D.m'.
%

%%  SECTION 0:  Initialize variables
im_size = [512 512 320];
test_im = zeros(im_size);
test_mask1 = test_im;
test_mask2 = test_im;
cube_sz1 = 30;
cube_sz2 = 10;
cube_center = round(im_size ./ 2);

test_im( round(cube_center(1) - cube_sz1 / 2) : round(cube_sz1 / 2 + cube_center(1))-1,...
         round(cube_center(2) - cube_sz1 / 2) : round(cube_sz1 / 2 + cube_center(2))-1,...
         round(cube_center(3) - cube_sz1 / 2) : round(cube_sz1 / 2 + cube_center(3))-1) = rand([cube_sz1 cube_sz1 cube_sz1]);
   

test_mask1( round(cube_center(1) - cube_sz1 / 2) : round(cube_sz1 / 2 + cube_center(1))-1,...
            round(cube_center(2) - cube_sz1 / 2) : round(cube_sz1 / 2 + cube_center(2))-1,...
            round(cube_center(3) - cube_sz1 / 2) : round(cube_sz1 / 2 + cube_center(3))-1) = true([cube_sz1 cube_sz1 cube_sz1]);
       
test_mask2( round(cube_center(1) - cube_sz2 / 2) : round(cube_sz2 / 2 + cube_center(1))-1,...
            round(cube_center(2) - cube_sz2 / 2) : round(cube_sz2 / 2 + cube_center(2))-1,...
            round(cube_center(3) - cube_sz2 / 2) : round(cube_sz2 / 2 + cube_center(3))-1) = true([cube_sz2 cube_sz2 cube_sz2]);
test_mask = test_mask1 & ~test_mask2;

test_im_noise = imnoise(test_im, 'salt & pepper', 0.33) .* 250;

%% SPEED TEST | s_kz = 10, h_filt = @nanmedian
% 
%   OLD METHOD - MASKFILTER
%    IMAGE SIZE     TIME (SEC)
%    7000000        2700.00
%    109375         53.29
%    56000          26.63
%    26000          13.12
% 
%   NEW METHOD - MEDFILT3 [MATLAB builtin function; not true 3D filtering]
%    IMAGE SIZE     TIME (SEC)
%    7000000        432.90
%    109375         6.08
%    56000          3.75
%    26000          2.55
% 
%   NEWEST METHOD - FASTFILT3D [Current method]
%    IMAGE SIZE     TIME (SEC)
%    7000000        936.330288
%    875000         119.38
%    109375         16.46
%    56000          9.29
%    26000          4.94

%%  Case 1 | Isotropic Filtering | SUCCESS
tic
case1_filt_im = FastFilt3D(test_im_noise, test_mask, 10, @nanmedian);
toc

%% Case 2 | Anisotropic Filtering | SUCCESS
tic
case2_filt_im = FastFilt3D(test_im_noise, test_mask, [5 5 8], @nanmedian);
toc


