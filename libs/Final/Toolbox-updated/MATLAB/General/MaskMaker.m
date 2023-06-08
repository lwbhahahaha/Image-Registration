classdef MaskMaker < handle
    %MASKMAKER Creates image masks representing geometric objects
    %
    % The main methods of this class to call are the make*(S) methods which
    % create digital masks representing various geometric shapes. The input
    % to these funtions is a struct containing the parameters that define
    % the shape. In general, these include the center of the shape and
    % three Euler rotation angles to describe its orientation along with
    % shape specific parameters. Currently supported shapes:
    %   Sphere, Ellipsoid, Cylinder
    %
    % The parameters are assumed to reference a (right-handed) coordinate
    % system with its origin at the center of the desired volume. This
    % framework works by fixing the object at the origin and rotating the
    % grid to see which pixels are inside the object; this also makes it
    % much more straightforward to define the parameters of the objects (no
    % need to worry about which direction is the 'X' axis after rotation).
    % Alternatively, you can think of it as constructing the object at the
    % origin, applying the rotation, then translating it to its final
    % position. Note that all input parameters for the shapes have sensible
    % defaults in order to improve the usability.
    %
    % For the Euler angles used, I follow the x-axis convention.
    % See http://mathworld.wolfram.com/EulerAngles.html for more
    % information on the transformation.
    
    properties (SetAccess = private)
        dimensionality
        grid_size
        grid_spacing
    end
    
    properties (SetAccess = private)
        internal_mask
        internal_coords
    end
    
    methods
        function this = MaskMaker(grid_size, grid_spacing)
            % Constructor for a MaskMaker
            %   MM = MaskMaker(grid_size, grid_spacing);
            % grid_size is the pixel count of each dimension of the volume
            % grid_spacing is the physical spacing of each pixel
            %
            % The current implementation only supports the creation of 3D
            % masks, though generalizing to 2D should be pretty
            % straightforward.
            this.dimensionality = numel(grid_size);
            if this.dimensionality ~= 3
                error([mfilename, ':Only3D',...
                        'Only 3D grids are supported at this time.']);
            end
            % using (:) and transpose ' ensures that we get a row vector
            this.grid_size = grid_size(:)';
            
            if nargin == 2
                if numel(grid_spacing) ~= numel(grid_size)
                    error([mfilename, ':DimensionMismatch',...
                        'Dimension mismatch between the grid size and the grid spacing.']);
                end
                % using (:) and transpose ' ensures that we get a row vector
                this.grid_spacing = grid_spacing(:)';
            else
                this.grid_spacing = ones(size(grid_size(:)'));
            end
            
            % Initialize the class properties
            this.internal_mask = false(grid_size);
            this.initializeCoordinateSystem();
        end
        
        function mask = makeSphere(this, S)
            % Creates a mask of a sphere defined by the input parameters
            % from the struct S: 
            %     S.center (defualt: [0,0,0])
            %     S.radius (default: 40% of the shortest grid length)
            if ~isstruct(S)
                error([mfilename, ':makeSphere',...
                        'A configuration struct is required as input.']);
            end
            
            % clear out the current mask 
            this.clearMask();
            % parse the input struct and assign defaults
            struct_fields  = {'center', 'radius'};
            % default radius is 40% of the shortest grid length
            default_radius = 0.4* min(this.grid_size.*this.grid_spacing);
            default_values = {[0,0,0], default_radius};
            
            for idx = 1 : numel(struct_fields)
                % uncell to extract the string
                field_name = struct_fields{idx};
                if ~isfield(S, field_name)
                    S.(field_name) = default_values{idx};
                end
            end
            
            coords = this.internal_coords;
            coords = bsxfun(@minus, coords, S.center);

            Xp = coords(:,1);
            Yp = coords(:,2);
            Zp = coords(:,3);
            % Use the defining equation of the object to check which points fall on the
            % interior and then assign those points a value
            inds = Xp.^2 + Yp.^2 + Zp.^2 < (S.radius)^2;

            this.internal_mask(inds) = true;
            mask = this.internal_mask;
        end
        
        function mask = makeEllipse(this, S)
            % Creates a mask of an ellipse defined by the input parameters
            % from the struct S: 
            %     S.center
            %     S.phi
            %     S.theta
            %     S.psi
            %     S.semiX
            %     S.semiY
            %     S.semiZ
            if ~isstruct(S)
                error([mfilename, ':makeEllipse',...
                        'A configuration struct is required as input.']);
            end
            
            % clear out the current mask 
            this.clearMask();
            % parse the input struct and assign defaults
            struct_fields  = {'center', 'phi', 'theta', 'psi', 'semiX', 'semiY', 'semiZ'};
            % default semi-axis is 40% of the respective grid_length
            default_semis = 0.4.* this.grid_size.*this.grid_spacing;
            default_values = {[0,0,0], 0, 0, 0, default_semis(1), default_semis(2), default_semis(3)};
            
            for idx = 1 : numel(struct_fields)
                % uncell to extract the string
                field_name = struct_fields{idx};
                if ~isfield(S, field_name)
                    S.(field_name) = default_values{idx};
                end
            end
            
            coords = this.internal_coords;
            coords = bsxfun(@minus, coords, S.center);
            
            % apply the inverse of the rotation matrix
            inv_rot = this.inverseEulerRotationMatrix(S.phi, S.theta, S.psi);
            coords = (inv_rot * (coords'))';

            Xp = coords(:,1);
            Yp = coords(:,2);
            Zp = coords(:,3);
            % Use the defining equation of the object to check which points
            % fall on the interior
            % See http://mathworld.wolfram.com/Ellipsoid.html
            LHS = (Xp.^2)./(S.semiX^2) + (Yp.^2)./(S.semiY^2) + (Zp.^2)./(S.semiZ^2);
            inds = LHS < 1;

            this.internal_mask(inds) = true;
            mask = this.internal_mask;
        end
        
        function mask = makeCylinder(this, S)
            % Creates a mask of a cylinder defined by the input parameters
            % from the struct S: 
            %     S.center
            %     S.phi
            %     S.theta
            %     S.psi
            %     S.radius
            %     S.height
            %
            if ~isstruct(S)
                error([mfilename, ':makeCylinder',...
                        'A configuration struct is required as input.']);
            end
            
            % clear out the current mask 
            this.clearMask();
            % parse the input struct and assign defaults
            struct_fields  = {'center', 'phi', 'theta', 'psi', 'radius', 'height'};
            % default radius is 40% of the shortest grid_length
            default_radius = 0.4.* min(this.grid_size.*this.grid_spacing);
            % default height is 80% of the z-axis length
            default_height = 0.8 * this.grid_size(3).*this.grid_spacing(3);
            default_values = {[0,0,0], 0, 0, 0, default_radius, default_height};
            
            for idx = 1 : numel(struct_fields)
                % uncell to extract the string
                field_name = struct_fields{idx};
                if ~isfield(S, field_name)
                    S.(field_name) = default_values{idx};
                end
            end
            
            coords = this.internal_coords;
            coords = bsxfun(@minus, coords, S.center);
            
            % apply the inverse of the rotation matrix
            inv_rot = this.inverseEulerRotationMatrix(S.phi, S.theta, S.psi);
            coords = (inv_rot * (coords'))';

            Xp = coords(:,1);
            Yp = coords(:,2);
            Zp = coords(:,3);
            % Use the defining equation of a cylinder to create the mask
            % See http://mathworld.wolfram.com/Ellipsoid.html
            cyl_inds = (abs(Zp) < 0.5*S.height) & ( (Xp.^2 + Yp.^2) < S.radius.^2 );

            this.internal_mask(cyl_inds) = true;
            mask = this.internal_mask;
        end
        
        function mask = makeCuboid(this, S)
            % Creates a mask of a cylinder defined by the input parameters
            % from the struct S: 
            %     S.center
            %     S.phi
            %     S.theta
            %     S.psi
            %     S.sideX
            %     S.sideY
            %     S.sideZ
            %
            if ~isstruct(S)
                error([mfilename, ':makeCuboid',...
                        'A configuration struct is required as input.']);
            end
            
            % clear out the current mask 
            this.clearMask();
            % parse the input struct and assign defaults
            struct_fields  = {'center', 'phi', 'theta', 'psi', 'sideX', 'sideX', 'sideZ'};
            % default side is 80% of the shortest grid_length
            default_side = 0.8.* min(this.grid_size.*this.grid_spacing);

            default_values = {[0,0,0], 0, 0, 0, default_side, default_side, default_side};
            
            for idx = 1 : numel(struct_fields)
                % uncell to extract the string
                field_name = struct_fields{idx};
                if ~isfield(S, field_name)
                    S.(field_name) = default_values{idx};
                end
            end
            
            coords = this.internal_coords;
            coords = bsxfun(@minus, coords, S.center);
            
            % apply the inverse of the rotation matrix
            inv_rot = this.inverseEulerRotationMatrix(S.phi, S.theta, S.psi);
            coords = (inv_rot * (coords'))';

            Xp = coords(:,1);
            Yp = coords(:,2);
            Zp = coords(:,3);
            % Use the defining equation of a cylinder to create the mask
            % See http://mathworld.wolfram.com/Ellipsoid.html
            cuboid_inds = (abs(Xp) < 0.5*S.sideX) & (abs(Yp) < 0.5*S.sideY) & (abs(Zp) < 0.5*S.sideZ);

            this.internal_mask(cuboid_inds) = true;
            mask = this.internal_mask;
        end
    end
    
    methods (Access = private)
        function clearMask(this)
            this.internal_mask(:) = false;
        end
        
        function initializeCoordinateSystem(this)
            % Creates the initial coordinate system of the array. 
            %  This function establishes coordinates for each pixel in a
            %  coord system where the center of the image volume is defined
            %  as the origin
            
            % local aliases
            g_size = this.grid_size;
            g_spacing = this.grid_spacing;
            % create initial grid coordinates with the center of the first
            % pixel as the origin
            if this.dimensionality == 3
                
                Xgv = (0 : (g_size(1)-1) ) .* g_spacing(1);
                Ygv = (0 : (g_size(2)-1) ) .* g_spacing(2);
                Zgv = (0 : (g_size(3)-1) ) .* g_spacing(3);

                [X, Y, Z] = meshgrid(Xgv, Ygv, Zgv);
                % turn them into a matrix of points (one point per row)
                grid_coords = [X(:), Y(:), Z(:)];
                
            elseif this.dimensionality == 2
                
                Xgv = (0 : (g_size(1)-1) ) .* g_spacing(1);
                Ygv = (0 : (g_size(2)-1) ) .* g_spacing(2);

                [X, Y] = meshgrid(Xgv, Ygv);
                % turn them into a matrix of points (one point per row)
                grid_coords = [X(:), Y(:)];
            end
            
            % compute the distance of one coordinate to the center of the grid
            dist = 0.5*g_spacing .*(g_size - 1);
            % shift the grid points
            this.internal_coords = bsxfun(@minus, grid_coords, dist);
        end
        
    end
    
    methods (Static)
        function inverse = inverseEulerRotationMatrix(phi, theta, psi)
            % Constructs the inverse Euler rotation transformation
            
            % Since I'm lazy, I just construct the forward transform matrix
            % and then take its inverse. This also makes it pretty clear
            % what the rotation order is.
            % Following the convention/notation (zxz) from:
            % http://mathworld.wolfram.com/EulerAngles.html
            D = [ cos(phi) -sin(phi) 0
                  sin(phi)  cos(phi) 0
                     0         0     1];

            C = [ 1      0           0
                  0  cos(theta) -sin(theta)
                  0  sin(theta)  cos(theta)];

            B = [ cos(psi) -sin(psi) 0
                  sin(psi)  cos(psi) 0
                     0         0     1];
                 
            forward = B*C*D;
            inverse = inv(forward);
        end
    
        % TODO: Extend this class to work for 2D as well?
%         function inverse = inverse2dRotationMatrix(phi)
%             % Constructs the 2d inverse rotation matrix
%             A = [ cos(phi) -sin(phi)
%                   sin(phi)  cos(phi)];
%               
%             inverse = inv(A);
%         end
    end
end

