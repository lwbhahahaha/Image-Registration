function [ fig_h ] = VisualizePerfusion2D( perf_vol, gray_vol, slice_n, params )
%[ perf_gray_slice ] = VisualizePerfusion2D( perf_vol, gray_vol, params )
%
%VISUALIZEPERFUSION2D will return and display an grayscale CT image
%superimposed with the provided perfusion volume, at the specified slice
%and in the specified plane.
%
%   VisualizePerfusion2D
%
%   INPUTS:
%
%   perf_vol                      MATRIX(DOUBLE) | [M x N x O]
%                                 Perfusion map volume in 3D
%
%
%   gray_vol                      MATRIX(DOUBLE) | [M x N x O]
%                                 Grayscale volume in 3D
% 
%   slice_n                       DOUBLE | Slice Number
%                                 Slice of interest
%
%
%   params...                     STRUCT
%                                 *OPTIONAL*
% 
%       verbose                   LOGICAL | false [DEFAULT VALUE]
%                                 Setting verbose to true will allow
%                                 warnings.
% 
%       plane                     STR | 'AXIAL' [DEFAULT VALUE]
%                                 ('AXIAL' 'CORONAL' 'SAGITTAL')
%                                 2D plane of interest
% 
%       cmap                      STR | 'JET' [DEFAULT VALUE]
%                                 Colormap to view perfusion map
% 
% 
%       w_l                       VECTOR(DOUBLE) | [800 300] [DEFAULT VALUE]
%                                 [WINDOW_HU LEVEL_HU]
%                                 Window and level of grayscale image in
%                                 final image
% 
%       perf_cutoff               VECTOR(DOUBLE) | [0.0001 2.5] [DEFAULT VALUE]
%                                 [MIN_PERFUSION MAX_PERFUSION]
%                                 This parameter indicates the display
%                                 range for the perfusion maps.
% 
%       save_path                 STR | '' [DEFAULT VALUE]
%                                 Specify file path to save the outputted
%                                 figure.  The figure will be saved as a
%                                 PNG.  If no file path is provided, then
%                                 the figure will not be saved.
%
%   OUTPUTS:
%
%   perf_gray_slice               MATRIX(DOUBLE) | [M x N]
%                                 2D image of grayscale image superimposed
%                                 with the provided perfusion map
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 04-Feb-2018
%


% SECTION 0: Initialize

% 0.1: Default parameters
params_verbose = false;
params_plane = 'AXIAL';
params_cmap = @jet;
params_w_l = [800 300];
params_perf_cutoff = [0.0001 2.5];
params_save_path = '';

% 0.2: If user specified optional parameters, overwrite default parameters
if nargin == 4
    usr_vars = fieldnames(params);
    if any(strcmp(usr_vars, 'verbose'))
        params_verbose = params.verbose;
    end
    if any(strcmp(usr_vars, 'plane'))
        params_plane = params.plane;
    end
    if any(strcmp(usr_vars, 'cmap'))
        params_cmap = params.cmap;
    end
    if any(strcmp(usr_vars, 'w_l'))
        params_w_l = params.w_l;
    end
    if any(strcmp(usr_vars, 'perf_cutoff'))
        params_perf_cutoff = params.perf_cutoff;
    end
    if any(strcmp(usr_vars, 'save_path'))
        params_save_path = params.save_path;
    end
end

% 0.3: Apply perfusion cutoffs to perf_vol
perf_vol(perf_vol < 0) = params_perf_cutoff(1);
perf_vol(perf_vol > params_perf_cutoff(2)) = params_perf_cutoff(2);



% SECTION 1: Reorient to new plane (if specified)
switch params_plane
    case 'AXIAL'
        % do nothing, slices of volumes are already in the axial plane
    case 'CORONAL'
        perf_vol = permute(perf_vol, [3 2 1]);
        gray_vol = permute(gray_vol, [3 2 1]);
    case 'SAGITTAL'
        perf_vol = permute(perf_vol, [3 1 2]);
        gray_vol = permute(gray_vol, [3 1 2]);
end

% SECTION 2: Extract slices
perf_slice = perf_vol(:,:, slice_n);
gray_slice = gray_vol(:,:, slice_n);

% SECTION 3: Create perf_slice alpha map
perf_alpha = logical(perf_slice);

% SECTION 4: Create new figure
fig_h = figure;

ax_gray = axes('Parent', fig_h);
ax_perf = axes('Parent', fig_h);


set(ax_perf, 'Visible', 'off');
set(ax_gray, 'Visible', 'off');

% min_gray = min(perf_vol(perf_vol > 0));
% max_gray = max(perf_vol(perf_vol > 0));
min_gray = 0;
max_gray = params_perf_cutoff(2);

perf_gray_slice = imshow(gray2rgb_(perf_slice, params_cmap(101), min_gray, max_gray), 'Parent', ax_perf);
set(perf_gray_slice, 'AlphaData', perf_alpha);
perf_gray_slice = imshow(gray_slice, [params_w_l(2) - params_w_l(1) / 2 params_w_l(2) + params_w_l(1) / 2], 'Parent', ax_gray);

% SECTION 5: Save figure (if specified)
if ~isempty(params_save_path)
    set(fig_h, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 30 20]);
    print(fig_h, '-dpng', params_save_path, '-r300');
end

%% Helper Functions:
    function [rgb_im_] = gray2rgb_(gray_im_, cmap_, min_gray_, max_gray_)
        rgb_im_ = zeros([size(gray_im_) 3]);
        rel_gray_im = (gray_im_ - min_gray_) / (max_gray_ - min_gray_);
        for i_ = 1 : size(gray_im_, 1)
            for j_ = 1 : size(gray_im_, 2)
                switch rel_gray_im(i_, j_)
                    case 0
                        rgb_im_(i_, j_, :) = [0 0 0];
                    otherwise
                        rgb_im_(i_, j_, :) = cmap_(round(100*rel_gray_im(i_, j_))+1, :);
                end
            end
        end
    end
end
