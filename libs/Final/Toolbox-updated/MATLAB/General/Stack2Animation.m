function Stack2Animation( stack, out_fname, varargin )
%STACK2ANIMATION Converts a 3D stack into an animated GIF
%
% For creating an animated gif:
%  Stack2Animation( stack, opt_output_fname, opt_delay_time, opt_num_colors )
%       Default for opt_output_fname = 'animation.gif'
%       Default for opt_delay_time = 0 (as fast as gifs can change)
%       Default for opt_num_colors = 256
% 
% For creating an AVI video:
%  Stack2Animation( stack, opt_output_fname, opt_framerate )
%       Default for opt_output_fname = 'animation.avi'
%       Default for opt_framerate = 30
%
% All inputs except for stack are optional.

narginchk(1, 4);

% create a new figure
hFig = figure;
% create the initial image and settings
imshow(stack(:,:,1), []);
axis tight
% set this so that the axes options do not change with each update
set(gca,'nextplot','replacechildren')

% check what file type to create, default to avi
if exist('out_fname', 'var')
    [~, ~, ext] = fileparts(out_fname);
else
    ext = '.avi';
end

if( strcmpi(ext, '.gif') )

    if nargin < 2
        out_fname = 'animation.gif';
    end
    
    if nargin < 3
        delay_time = 0;
    else
        delay_time = varargin{1};
    end
    
    if nargin < 4
        num_colors = 256;
    else
        num_colors = varargin{2};
    end

    dithering = 'nodither';

    % grab the first frame and convert to uint8 RGB image
    f = getframe;
    [frame_stack, map] = rgb2ind(f.cdata, num_colors, dithering);
    % allocate memory for the rest of the frames
    frame_stack(1,1,1, size(stack, 3)) = 0;

    % construct a new stack of RGB frames to be saved to the gif
    for idx = 1 : size(stack, 3)
        imshow(stack(:,:, idx), []);
        f = getframe;
        frame_stack(:,:,1, idx) = rgb2ind(f.cdata, map, dithering);
    end
    % write the gif to the file
    imwrite(frame_stack, map, out_fname, 'DelayTime', delay_time, 'LoopCount',inf)
    
    
elseif( strcmpi(ext, '.avi') )

    if nargin < 2
        out_fname = 'animation.avi';
    end
    
    if nargin < 3
        framerate = 30;
    else
        framerate = varargin{1};
    end
    
    writerObj = VideoWriter(out_fname);
    writerObj.FrameRate = framerate;
    open(writerObj)

    % Display images, grab frames, and write the video
    for idx = 1 : size(stack, 3)
        imshow(stack(:,:, idx), []);
        frame = getframe;
        writeVideo(writerObj, frame);
    end

    close(writerObj);
end

close(hFig);