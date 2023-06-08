function TiffStackWrite(image, file)
%TIFFSTACKWRITE Writes an image to a .tif file or directory of .tif's.
%
% TiffStackWrite(image, file)
% If file does not end in '.tif' or is a directory that exists then the image
% is written slice by slice into files named 000i.tif into that folder.
% If file ends in '.tif' and is not a directory already, then the image is
% written into a single .tif file.
% 
% If image is not an integer type, then it is normalized to a uint16 image by
% the conversion uint16( mat2gray(image).*(2^16 -1) ) before being written to
% file. If it is of type int16 (signed) then it is converted to uint16 by
% adding 2^15 so no information is lost.
%
% Author: Travis Johnson
%         Molloi Lab

if( ~isinteger(image) )
    fprintf(['TiffStackWrite: Automatically scaling image data to fill the full range of uint16.\n'...
             '  Convert your input matrix to an integer type to preserve values exactly.\n']);
    image = uint16( mat2gray(image) .* (2^16 -1) );
elseif isa(image, 'int16')
    fprintf('TiffStackWrite: Signed int16 data detected, converting to uint16 before write.\n');
    image = uint16(double(image) + 2^15);
end

if( isdir(file) || ~strncmpi(file, '.tif', -4) )
    mkdir(file);    
    for i = 1 : size(image, 3)
        name = int2str(10000+i);
        imwrite( image(:,:,i), [file filesep name(2:end) '.tif'], 'TIFF');
    end
else % Write the image to a single file.
    imwrite(image(:,:,1), file)
    for k = 2 : size(image, 3)
        imwrite( image(:,:,k), file, 'writemode', 'append');
    end
end