function tiffStack  = TiffStackRead(file)
% TIFFSTACKREAD Reads a .tif stack into a 3D array as doubles from file.
%
% tiffStack = TiffStackRead(file)
%
% If file is a directory, all (2D) tiff images in that directory will be
% read in as a 3D stack.  Can also read a single 3D file into an array.
% Note that MATLAB always reads in Tiffs with unsingned int values so
% conversions may be necessary before working with the arrays.

if( isdir( file ) )
    
    Dir = dir(file);
    % Remove . and .. directories
    Dir(1:2) = [];
    % Remove any non tif files from the list
    filenames = {Dir.name};
    filenames = filenames( ~cellfun( @isempty, regexp(filenames, '\.tif', 'once') ) );
    % Figure out the image size and type
    info = imfinfo( [file filesep filenames{1}], 'TIFF' );
    type_str = GetTypeString(info);
    % Allocate memory for the tiffStack
    tiffStack = zeros( [info(1).Height, info(1).Width length(filenames)], type_str);
    for k = 1 : length(filenames)
        tiffStack(:,:,k) = imread( [file filesep filenames{k}] );
    end
 
else % Opening a TIFF stack
    % Get the necessary size and type information
    info = imfinfo(file, 'TIFF');
    num_images = numel(info);
    type_str = GetTypeString(info);
    % Allocate memory for the tiffStack
    tiffStack = zeros( [info(1).Height, info(1).Width, num_images], type_str);
    % Read in each of the files using the LibTIFF interface
    tiffLink = Tiff(file, 'r');
    for i = 1 : num_images
       tiffLink.setDirectory(i);
       tiffStack(:,:,i) = tiffLink.read();
    end
    tiffLink.close();
end

function str = GetTypeString(imInfo)
    switch imInfo(1).BitDepth;
        case 8 
            str = 'uint8';
        case 16 
            str = 'uint16';
        case 32 
            str = 'uint32';
        otherwise
            error('TiffStackRead: Image type not supported.');
    end