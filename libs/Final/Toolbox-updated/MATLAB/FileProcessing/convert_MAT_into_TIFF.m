function [] = convert_MAT_into_TIFF( dname )

output_text = [ 'Processing: ' dname ];
disp( output_text );

%% make the MAT folder and others...

[ status, message, messageID ] = mkdir( dname, 'tif' );

%% get information from the tiff image directory

dname1   = [ dname '\MAT' ];
fileData    = dir(dname1);
fileNames   = {fileData.name};
index       = regexp(fileNames,'.mat');
imFiles     = fileNames(~cellfun(@isempty,index));
nFiles      = numel(imFiles);

%%  loop over the input files and fill the above data structures

progressbar( 'MAT to TIFF conversion progress...' )
count = 1; 

for iFile = 1:nFiles 
       
    imFile  = imFiles{ iFile };
    imPath  = strcat( dname1, '\', imFile );
    im      = load( imPath );
    disp(im);
    imStack = im.current_I;  
    imStack = uint16(imStack);
    %% convert the imStack to a TIFF file and save
    
    TiffStackWrite(imStack, [dname '\tif\im' num2str(count) '.tif'] );
    count = count + 1;
    progressbar( iFile/nFiles );
    
end

end