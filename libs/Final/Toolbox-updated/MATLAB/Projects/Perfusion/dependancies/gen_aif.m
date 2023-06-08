function [ aif_vec ] = gen_aif( acq_path, aif_mask )
%[ aif ] = gen_aif( acq_path, aif_mask )
%
%GEN_AIF generates an arterial input function (AIF) with the provided
%aif_mask
%
%   gen_aif
%
%   INPUTS:
%
%   acq_path                      STR
%                                 Path to acquisition of interest.  Include
%                                 REGISTERED if desired
%
%
%   aif_mask                      VOLUME(LOGICAL) | [512 x 512 x 320]
%                                 Binary mask of area to sample to create
%                                 AIF
%
%
%   OUTPUTS:
%
%   aif_vec                       VECTOR(DOUBLE) | (HU)
%                                 Vector of the average intensity (HU)
%                                 over time, within the provided aif_mask
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 05-Jan-2018
%

%%%%%%%% Edit by Logan Hubbard 05/29/21
% Edit: 3D Erosion of binary mask to eliminate partial volume effects
% aif_mask = aif_mask > 0; % Creation of logical mask
% SE = strel('sphere',2); % Creates a sphere-shaped structuring element whose radius is R pixels
% aif_mask = imerode(aif_mask,SE); %Erode outer edges of Ao of MYO

aif_mask = logical(aif_mask); %THIS WAS THE ORGINAL LINE!

%%%%%%%%

mat_files = regexpdir([acq_path '/MAT/'], '\.mat$', false);
aif_vec  = zeros(length(mat_files),1);
idx = 1;
progressbar('Generating AIF...');
for f = mat_files'
    t_mat = loadMAT(f{1});
    t_mat(t_mat >= 30720) = NaN;
    aif_vec(idx) = nanmean(t_mat(aif_mask));
    idx = idx + 1;
    progressbar(idx / (length(mat_files)+1));
end

end
