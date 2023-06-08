% crop BW Whole Heart image
Whole_Heart_BW_path = ('\\polaris.radsci.uci.edu\Data4\bpziemer\animal_perfusion_data\12_09_20_data\CardiacPerfusion\Cardiac_set_1\Acq_02_Baseline\SEGMENT_dcm\WHOLE_HEART_REST_dcm_noThresh.mat');
% trim = crop(Whole_Heart_BW);
% %imtool3D2(trim)
% sampleEllipse = trim(:,:,57);
% edges = edge(sampleEllipse);
% imshow(edges)
% 
% im_dims = size(sampleEllipse);


DCM_Path = '\\polaris.radsci.uci.edu\Data 1_2_4\CT_Perfusion\06_03_15_data\Acq09_stenosis\LV_V1';
MIP_Cropped_path = '\\polaris.radsci.uci.edu\Data 1_2_4\CT_Perfusion\06_03_15_data\Acq09_stenosis\CROP\MIP_CROPPED';
%V = ImportDICOMSequence(DCM_Path)
[trim,ind1,ind2,ind3,] = crop(V);
%imtool3D2(V(ind3,ind2,ind1))
V_trim = V(ind3,ind2,ind1);
sample_slice = V_trim(:,:,44);

% applying region growing to slices slice wise:
mask = zeros(size(V_trim));
for i = 1:length(V_trim(1,1,:))
    mask(:,:,i) = regiongrowing(V_trim(:,:,i));
end
imtool3D2(mask)

% load mri
% poly = regionGrowing(squeeze(D), [66,55,13], 60, Inf, [], true, false);
% plot3(poly(:,1), poly(:,2), poly(:,3), 'x', 'LineWidth', 2)

% function d = pixDistance(x,y) % euclidean distance
%     d = sqrt((x(1)-y(1))^2 + (x(2)-y(2))^2);
% end
% function center = findCenter(slice)% finds the approximate center of an ellipse-like shape in voxel coords
%     rows,cols = length(slice(1,:)); length(slice(1,:));
%     x0 = [floor(rows/2),floor(cols/2)];
%     theta = 0;
%     line = [round(cos(theta)*[x0(0):cols]);round(sin(theta)*[x0(1):-1:1])];
%     
% 
% end

function [im,index1,index2,index3] = crop(img)%% feed in masked image, output cropped square image deleting layers and rows/cols with no 1's
    

    if max(img,[],'all')~=1 
        img = NormalizeGrayscale(img);
    end
    
    layers = length(img(1,1,:));
    vox = length(img(:,1,1));
    
    % trims empty frames (when all elements are 0)
    ind1 = reshape((sum(img,1:2)>0),[1,layers]).*[1:layers];
    ind1 = ind1(ind1~=0);
    im = img(:,:,ind1);

    % trims excess vertical
    ind2 = reshape((sum(im,2:3)>0),[1,vox]).*[1:vox];
    ind2 = ind2(ind2~=0);   
    im = im(ind2,:,:);
    
    % trims excess horizontal
    ind3 = reshape((sum(im,[1,3])>0),[1,vox]).*[1:vox];
    ind3 = ind3(ind3~=0);   
    im = im(:,ind3,:);
    
    index1 = ind1;
    index2 = ind2;
    index3 = ind3;
    
    
end