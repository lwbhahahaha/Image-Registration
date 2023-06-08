function [  ] = WriteDICOM( im, dcmPath, outputPath, dcmTitle, mask, m, b )
%WRITEDICOM writes inputted im volume to outputPath, using dcmPath
%headers.
%
%   WriteDICOM is intended to be used to convert image volumes into
%   DICOMs to the specified outputPath.  It will copy the DICOM
%   headers in the provided dcmPath, allowing the outputted image volume to
%   be uploaded into Vitrea.  Save a few minor changes, this function
%   should work all DICOM image volumes, where each slice of the volume is
%   saved as a SEPARATE file and the original DICOM volume is the same
%   dimensions as im.  This function is modified to create a ledger and
%   keep track of already in use DICOM tags, to allow for optimal loading
%   into Vitrea (without having to overwrite already in use DICOMs).  A
%   ledger will be created or loaded from the parent folder of dcmPath.
% 
%   UPDATES:  
%
%   11/3/2016 - Modified legder system to allow function to be used with
%   brain and lung datasets.
%   
%   INPUTS:
%
%   im                            Inputted 3D matrix to write as DICOM.
%                                 Should not be calibrated.  Include a mask
%                                 to change 0 values to -1024 ( a
%                                 requirement for Vitrea).
%
%
%   dcmPath                       Original DICOM image volume to be copied.                                   
%
%
%   outputPath                    Folder where new DICOM volume will
%                                 be saved.
%
%
%   dcmTitle                      *optional* Title of calibMYO DICOM
%                                 volume.  Will help in differentiating
%                                 volumes in Vitrea.  Defualts to whatever
%                                 the title of original DICOM volume is.
% 
%
%   mask                          *optional* Use this argument to provide a
%                                 binary mask of the image.  This is to
%                                 allow for changing background voxels to
%                                 -1024, without losing image information.
%                                 If a matrix is not provided, ALL voxels
%                                 that have 0 intensity will be set to
%                                 -1024 (this is a HUGE problem with flow
%                                 maps).
%
%
%   m                             *optional* Slope of Vitrea calibration,
%                                 defaults to 1.
%
%
%   b                             *optional* Intercept of Vitrea
%                                 calibration, defaults to -15000.
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 21-Apr-2016
%

switch nargin
    case 3
        dcmTitle = false;
        mask = false;
        m = 1;
        b = -15000;
    case 4
        mask = false;
        m = 1;
        b = -15000;
    case 5
        m = 1;
        b = -15000;
    case 6
        b = -15000;
end

% PREPROCESS OUTPUTPATH
outputPath = strrep(outputPath, '\', '/');
if strcmp(outputPath(end), '/')
    outputPath = outputPath(1 : end - 1);
end


if ~exist(outputPath,'dir')
    mkdir(outputPath);
elseif ~isempty(regexpdir(outputPath,'\.dcm$',false))
    warning('WriteDICOM did not run, the output folder (%s) already contains DICOM files.  Enter a different outputPath or rename that folder.', outputPath);
    return
end



imSize = size(im);
if mask ~= false
    im(~mask) = -1024;
end
im = ( im - b ) ./ m;

zSize = imSize(3);
%Added this to make it an integer now
im    = int16(im);


% Load ledger or make one:
ledgerPath = [dcmPath '/DCMTagLedger.mat'];
if exist(ledgerPath,'file')
    ledger = natsort(loadMAT(ledgerPath));
else
    dcmContents =  regexpdir(dcmPath, '[0-9]+\.+[0-9]|[0-9]', false);
    if isempty(dcmContents)
        dcmContents = regexpdir(dcmPath, 'SE(\d+)', false);
    end
    for i = 1:length(dcmContents)
        dcmSeries       = regexpdir(dcmContents{i}, '(\.dcm$)|(\.DCM$)', false);
        metadata        = dicominfo(dcmSeries{i});
        dcmContents{i}  = ['\' metadata.SeriesInstanceUID '\'];
    end
    ledger = natsort(dcmContents);
    save(ledgerPath, 'ledger');
end

% Get last ledger entry:
folderNameOld       = ledger{end};
DCMFolderContents   = regexpdir(dcmPath, '[a-z]|[A-Z]|[0-9](?!\.mat$)', false);
DCMFolderRef        = DCMFolderContents{1};
contentsDCMOriginal = dir([DCMFolderRef '/*.dcm']);
contentsDCMOriginal = natsort({contentsDCMOriginal.name});

% Change folderName to unique name:
% (probably a better way to do the next two lines in one line.
% (google 'regular expressions matlab' for an explanation on the below
% code)
folderDigitOld  = regexpi(folderNameOld, '\.\d+\\$', 'match');
folderDigitOld  = sscanf(folderDigitOld{1},'.%d\\');
folderDigitNew  = folderDigitOld + 1;
folderNameNew   = regexprep(folderNameOld, '\.\d+\\$', sprintf('.%d\\',folderDigitNew));
ledger          = vertcat(ledger,folderNameNew);
folderNameNew   = folderNameNew(2:end-1); % remove '\'


getFileDigit = @(x,y) zSize * (x - 1) + y;

progressbar('Writing DICOM...');

for i=1:zSize
    metadataPath    = [DCMFolderRef '/' contentsDCMOriginal{i}];
    metadata        = dicominfo(metadataPath);
    metadata.RescaleIntercept       = b;
    metadata.RescaleSlope           = m;
    metadata.PixelRepresentation    = 1;
    current_time                    = clock;
    metadata.SeriesDate             = sprintf('%i%02i%02i',current_time(1),current_time(2),current_time(3));
    metadata.SeriesTime             = sprintf('%i%i00.000',current_time(4),current_time(5));
    
    % ROTTERDAM MODIFICATIONS
%     metadata.SliceThickenss         = 0.40;
%     metadata.PixelSpacing           = [0.371093988419000; 0.371093988419000];
        
    try
		slice = rem( double(metadata.InStackPosition) , zSize );
        if slice == 0
            slice = zSize;
        end
    catch
        try
            slice = rem( double(metadata.InStackPositionNumber), zSize );
            if slice == 0
                slice = zSize;
            end
        catch
            slice = i;
        end
    end
    
    % Determine new file name:
    fileNameOld     = [metadata.SOPInstanceUID '.dcm'];
    fileDigitNew    = getFileDigit(folderDigitNew,slice);
    newFileSuffix   = sprintf('.%d.%d.dcm', folderDigitNew, fileDigitNew);
    fileNameNew     = regexprep(fileNameOld,'\.\d+\.\d+\.(dcm)+',newFileSuffix);
    
    %  Include new file name and folder name in metadata:
    metadata.MediaStorageSOPInstanceUID = fileNameNew;
    metadata.SOPInstanceUID             = fileNameNew;
    metadata.SeriesInstanceUID          = folderNameNew;
    metadata.PatientAge                 = ''; % if MR data, there is a problem here for some reason..
    metadata.BodyPartExamined           = '';
    
    if dcmTitle
        metadata.SeriesDescription = dcmTitle;
    end
    
    tempDcmFile = [outputPath '/' fileNameNew];
    dicomwrite(im(:,:,slice), tempDcmFile, metadata,'CreateMode','Copy');
    progressbar(i/zSize);
end
save(ledgerPath, 'ledger'); % only adds new value to ledger if program completes.

end
