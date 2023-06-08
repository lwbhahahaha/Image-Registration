function[] = Convert_DICOM_to_MAT(dname)

%Output: None (all the convert files are automatically save into a
%        subdirectory in the dname directory.
%Input: a directory of DICOM files

% COnvert all DICOM files in a directory (dname) into MAT files in a new
% MAT directory.

%Load the DICOM files in the dname directory
%Improvement: Have to check for empty directory
%             Check for 16 bits images and convert to 8 bits  

dname_in = [dname '\DICOM'];
mkdir( dname, 'MAT' ); %Used to say ASSIGN_VOLUME
dname_out = [ dname '\MAT' ];

fileData = dir(dname_in);
fileData = fileData(3:end); %later improvement: look for file name containing "CT"
dname_in = [dname_in '\' fileData(1).name];
fileData = dir(dname_in);
fileData = fileData(3:end);
fileInfo =  dicominfo([dname_in '\' fileData(1).name]);
frames = length(fileData); %the number of frames in each stack
rows = fileInfo.Rows; %the number of rows in each frame
columns = fileInfo.Columns; %the number of columns in each frame

%Get the tiem vector first in case the DICOM files are out of temporal
%order so we can generate MAT in correct order based on the time vector
time_vector = Time_Vector_Generator(dname);
order_vector = time_vector(:,2);


progressbar( 'DICOM to MAT conversion progress...' )

idx = 1;
for i = transpose(order_vector)
    imStack = zeros(rows,columns,frames); % Makes an empty 3d array the size of the image stack    
    ImageData = dicomread([dname_in '\' fileData(i).name]);
    
%      %Check the value range of the image file
%      %If the dicom is 16-bit image (value range = 2^16), it is normalized to a int8 image by
%      the conversion: int8( mat2gray(image).*(2^8 -1) )
%             %so the value fall into 8-bit range (0-255)
%     if max(ImageData(:)) > 256
%         offset = 32768;
%     else
%         offset = 0;
        
    for j = 1:frames
        temp = ImageData (:,:,:,j);
        imStack(:,:,j) = temp;
    end
    
    saved_ID = [dname_out '\' fileData(idx).name];
    save( saved_ID, 'imStack' );
    idx = idx + 1;

    progressbar(i/length(fileData))
        
end