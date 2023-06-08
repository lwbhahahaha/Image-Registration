function B = imresize3D(A, scale)
%IMRESIZE3D Resizes a 3D array similar to imresize for 2D images.
%
% imresize3D(I, scale)
%
% Author: Travis Johnson
%         Molloi Lab

if numel(scale) == 1
    scale = [scale, scale, scale];
end

aff_array = ...
    [scale(1)  0       0;
        0    scale(2)  0;
        0      0     scale(3);
        0      0       0;];

T = maketform('affine', aff_array);
R = makeresampler({'cubic','cubic','cubic'},'fill');

B = tformarray(A, T, R,[1 2 3],[1 2 3], round(size(A).*scale),[],0);