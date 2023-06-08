function gradmag = SobelGradient( I )
%SOBELGRADIENT Returns the gradient magnitude image of I using a Sobel filter.
% Can handle ndims(I) =< 3. The returned image is of type double.
if ndims(I) == 1

h = [-1 2 1];
gradmag = imfilter(double(I), h, 'replicate');
    
elseif ndims(I) == 2

	% 2D code copied from "Marker-Controlled Watershed Algorithm" Demo
	hy = fspecial('sobel');
	hx = hy';
	Iy = imfilter(double(I), hy, 'replicate');
	Ix = imfilter(double(I), hx, 'replicate');
	gradmag = sqrt(Ix.^2 + Iy.^2);

elseif ndims(I) == 3

	% Generate 3D sobel kernel's
	h = [1,2,1;2,4,2;1,2,1]; % Base 3D triangle filter
	hx(1,:,:) = -h; hx(2,:,:) = zeros(3); hx(3,:,:) = h;
	hy(:,1,:) = -h; hy(:,2,:) = zeros(3); hy(:,3,:) = h;
	hz(:,:,1) = -h; hz(:,:,2) = zeros(3); hz(:,:,3) = h;
	% Apply to Image
	Ix = imfilter(double(I), hx, 'replicate');
	Iy = imfilter(double(I), hy, 'replicate');
	Iz = imfilter(double(I), hz, 'replicate');
	% Calculate the Gradient Magnitude
	gradmag = sqrt(Ix.^2 + Iy.^2 + Iz.^2);
	% gradmag = uint16( mat2gray(gradmag) * 2^16 );

end