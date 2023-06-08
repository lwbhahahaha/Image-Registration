function Dicom2Tiff(dcm_info, dcm_image, tiff_obj)
%DICOM2TIFF Saves a 2D dicom image into the current TIFF IFD
%
% Note that the Tiff class derives from handle, so that the tiff_obj passed
% into this function is also the output. There is no return variable.
%
% Some of the header information pertaining to the DICOM image is retained
% and written to the tiff. Adding additional tags should not be too
% difficult.
%
% Dicom2Tiff(dcm_info, dcm_image, tiff_obj)
%
% Author: Travis Johnson
%         Molloi Lab
%
% Update Log:
%	11/11/2014 -- Initial creation

% Extract the necessary information from the DICOM header According to the
% tiff-class documentation, the following tags are required for a tiff
% file: ImageWidth, ImageHeight, BitsPerSample, SamplesPerPixel,
% Compression, PlanarConfiguration, and Photometric. 
info.Width             = dcm_info.Width;
info.Height            = dcm_info.Height;
info.BitDepth          = dcm_info.BitDepth;
info.SamplesPerPixel   = dcm_info.SamplesPerPixel;
% Compression and PlanarConfiguration are set to below
info.Photometric       = TranslatePhotoInterp( dcm_info.PhotometricInterpretation );

% Some additional information that is nice to have
info.PixelSize         = dcm_info.PixelSpacing; % assumed units are mm
info.SliceThickness    = dcm_info.SliceThickness; % assumed units are mm

% Assign the metadata to the tiff file object
%  tifflib complains if they aren't of the double persuasion
tiff_obj.setTag('ImageLength', 		double(info.Width));
tiff_obj.setTag('ImageWidth', 		double(info.Height));
tiff_obj.setTag('Photometric',		info.Photometric); % Must be before BitsPerSample
tiff_obj.setTag('BitsPerSample', 	double(info.BitDepth));
tiff_obj.setTag('SamplesPerPixel', 	double(info.SamplesPerPixel));
% how is the data to be written
tiff_obj.setTag('Compression', 		   Tiff.Compression.None);
tiff_obj.setTag('PlanarConfiguration', Tiff.PlanarConfiguration.Chunky);
tiff_obj.setTag('RowsPerStrip', 8); % somewhat arbitrary value

% Pixel size and units
tiff_obj.setTag('XResolution', 1/info.PixelSize(1));
tiff_obj.setTag('YResolution', 1/info.PixelSize(2));

% Convert the image data if necessary
if isa(dcm_image, 'int16')
    % easy rescaling from signed to unsigned
    dcm_image = double(dcm_image);
    dcm_image = dcm_image + 2^15;
    dcm_image = uint16(dcm_image);
elseif ~isa(dcm_image, 'uint16')
    % normalization to an unsigned range
    dcm_image = double(dcm_image);
    dcm_image = mat2gray(dcm_image) * (2^16-1);
    dcm_image = uint16(dcm_image);
end

% Write the image and return
tiff_obj.write(dcm_image);

return

% % % Helper Functions
    function tiff_photometric = TranslatePhotoInterp( dcm_photometric )
        switch dcm_photometric
            case 'MONOCHROME1'
                tiff_photometric = Tiff.Photometric.MinIsWhite;
            case 'MONOCHROME2'
                tiff_photometric = Tiff.Photometric.MinIsBlack;
            otherwise
                error('Dicom2Tiff: Unsupported photometric interpretation.');
        end
    end

end