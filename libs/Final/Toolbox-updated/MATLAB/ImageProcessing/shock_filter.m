
function [G]=shock_filter(I, maskSize, iterations, dt)

close all;

if (~exist('I','var'))
	I=rgb2gray(imread('C:\Data\leaves_small.jpg'));
end

I=double(I);

if (~exist('dt','var'))
	dt=0.25;
end

if (~exist('maskSize','var'))
	maskSize=9;
end

if (~exist('iterations','var'))
	iterations=30;
end

g=fspecial('gaussian',maskSize);
G=I;
%G=conv2(I,g,'same');
I_dim = size(I, 3);

for i=1:iterations
    for j = 1 : I_dim
        slice_im = I(:,:,j);
        slice_im = conv2(slice_im,g,'same');
        [gx, gy]=gradient(slice_im);
        normxy=sqrt(gx.*gx+gy.*gy);
        s = -sign(del2(slice_im));    
        slice_im=slice_im+dt.*s.*normxy;
        G(:,:,j) = slice_im;
    end
end

% figure,imshow((I./255));
% figure,imshow((G./255));

end
