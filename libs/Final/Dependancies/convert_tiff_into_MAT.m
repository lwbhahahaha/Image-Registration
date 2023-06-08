function [] = convert_tiff_into_MAT( dname )

output_text = [ 'Processing: ' dname ];
disp( output_text );

%% make the MAT folder and others...

[ status, message, messageID ] = mkdir( dname, 'ASSIGN' );
[ status, message, messageID ] = mkdir( dname, 'CALCS' );
[ status, message, messageID ] = mkdir( dname, 'CROP' );
[ status, message, messageID ] = mkdir( dname, 'MAT' );
[ status, message, messageID ] = mkdir( dname, 'MIP' );
[ status, message, messageID ] = mkdir( dname, 'SEGMENT' );
[ status, message, messageID ] = mkdir( dname, 'vessels' );

%% get information from the tiff image directory

dname1 = [ dname '\tif' ];
fileData = dir(dname1);
fileNames = natsort( { fileData.name } );
index = regexp(fileNames,'.tif'); 
imFiles = fileNames(~cellfun(@isempty,index)); 
nFiles = numel(imFiles);

%%  loop over the input files and fill the above data structures

progressbar( 'Tiff to MAT conversion progress...' )

for iFile = 1:nFiles 
    
    imFile = imFiles{iFile}; % Get the current input file
    imPath = strcat(dname1,'\',imFile); % Build the correct path name
    imInfo = imfinfo(imPath); % Get information about the current image path
    mImage = imInfo(1).Width; % Image Width
    nImage = imInfo(1).Height; % Image Height
    numImages = length(imInfo); % Counts the number of images in a stack
    imStack = zeros(nImage,mImage,numImages); % Makes an empty 3d array the size of the image stack    
    
    %% fill in 3D stack with image data
    
    TifLink = Tiff(imPath,'r');
    for i = 1:numImages
        TifLink.setDirectory(i);
        imStack(:,:,i)=double(TifLink.read()) - 32768; % Subtract the background off
    end
    TifLink.close();
    
    %% convert the imStack to a MAT file and save
    
        % index to save the MAT files
    file_ID = int2str( iFile );
    if iFile < 10
        file_ID = [ '0' file_ID ];
    else
        % do nothing...
    end

        file_name = [ file_ID '.mat' ];
        saved_ID = [ dname filesep 'MAT' filesep file_name ];
        save( saved_ID, 'imStack' );
    
    progressbar( iFile/nFiles )
    
end

end