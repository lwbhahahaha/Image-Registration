function plane_list = PerpendicularPlane(point, perp_vector, grid_size, step_size)
%PERPENDICULAPLANE Creates a sampling plane perpendicular to a vector.
% 
% plane = PerpendicularPlane(point, perp_vector, grid_size, step_size)
%
% Given a vector and a point, this function generates a sampling grid for a
% plane that is perpendicular to that vector and contains the point. The
% grid is returned as a list of xyz coordinates for the points.
%
% Inputs:
%  point -- the point in the center of the plane
%  perp_vector -- a vector perpendicular to the plane of interest
%  grid_size -- the half length of the square grid that is to be generated
%  step_size -- the step length between adjacent points on the generated
%               grid
%
% Each side of the returned square grid has 1 + 2*floor(grid_size/step_size)
% pixels.
%
% Author: Travis Johnson
%         Molloi Lab

% Input Checking and initializations
num_pixels = floor(grid_size/step_size);
%  normalize the perpendicular vector
normal = perp_vector/norm(perp_vector);

%% Generate the two basis vectors for the perpendicular plane
% Uses the Gram-Schmidt process. Chooses the two axes that have the largest
% angle with the perpendicular vector to generate the basis, i.e. the
% vector has the smallest components along those directions.

% %  sort the vector to determine which two axes to use
% [~, idx] = sort(abs(perp_vector));
% %  initialize them to zeros
% axis1 = zeros(1,3);
% axis2 = zeros(1,3);
% %  make them the two "most orthogonal" axes
% axis1(idx(1)) = 1;
% axis2(idx(2)) = 1; 
% 
% %  construct one basis vector
% basis1 = axis1 - dot(axis1, normal).*normal;
% basis1 = basis1/norm(basis1);
% %  construct the other basis vector
% basis2 = axis2  - dot(axis2, normal).*normal;
% basis2 = basis2 - dot(basis2, basis1).*basis1;
% basis2 = basis2/norm(basis2);
reference_vector = [1 0 0]; % the x-axis
basis1 = cross(perp_vector, reference_vector);
basis1 = basis1/norm(basis1);

basis2 = cross(perp_vector, basis1);
basis2 = basis2/norm(basis2);


%% Create a list of points in our perpendicular plane
%  scale the basis vectors to match the step_size
basis1 = basis1 .* step_size;
basis2 = basis2 .* step_size;

%  generate a meshgrid of the plane which is essentially the plane in its
%  perpendicular basis coordinates
[X, Y] = meshgrid(-num_pixels:num_pixels, -num_pixels:num_pixels);
%  transform the plane into the global coordinate system
plane_list = repmat(point,  [numel(X) 1]) + bsxfun(@times, X(:), basis1)...
                                          + bsxfun(@times, Y(:), basis2);