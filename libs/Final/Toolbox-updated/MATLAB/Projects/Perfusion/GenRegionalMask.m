function [ region_mask_mat, region_mask_labels, region_mask_mat_path ] = GenRegionalMask( region_mask_title, region_dcm_paths, region_mask_mat_path, reg_tf )
%[ region_mask_mat, region_mask_labels, region_mask_mat_path ] = GenRegionalMask( region_mask_title, region_dcm_paths, region_mask_mat_path, reg_tf )
%
%GENREGIONALMASK loads and converts the inputted DICOM masks into one
%ordinal mask and saves it as a MAT file.
%
%   GenRegionalMask loads masks in region_dcm_paths and combines each
%   mask into one, ordinal region_mask_mat.  This region_mask_mat can
%   then be used for further processing, in functions like
%   VolumePerfusion.  Regional_mask_labels will be provided for input into
%   VolumePerfusion directly.  Labels will be derived from the provided
%   region_dcm_paths, respective of the order of their input.  Ordinal
%   labels for each region will be determined based off the positional
%   order of region_dcm_paths. 
%
%   INPUTS:
%
%   region_mask_title             STR
%                                 Title of region mask
%
%
%   region_dcm_paths              {STR}
%                                 Cell array of paths to DICOM directories
%                                 to load and combine into
%                                 region_mask_mat
%
%
%   region_mask_mat_path          STR
%                                 File path of where to save
%                                 region_mask_mat
%
%   reg_tf                        LOGICAL
%                                 Specify if the acquisition being processed
%                                 is registered or not
% 
%   OUTPUTS:
%
%   region_mask_mat               VOLUME(DOUBLE) | [512 x 512 x 320]
%                                 Combined ordinal mask of regions
%
%   region_mask_labels            {STR} 
%                                 Cell array of region labels, derived from
%                                 region_dcm_paths
%
%
%   region_mask_mat_path          STR
%                                 File path of where to save
%                                 region_mask_mat
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 08-Jan-2018
%

if exist(region_mask_mat_path, 'file') %% If the file exists, load the data....
%     region_mask_mat = loadMAT(region_mask_mat_path, 2); %% Shant Computer...These got switched from 1, 2 to 2, 1.
%     region_mask_labels = loadMAT(region_mask_mat_path, 1); %% Shant Computer
    region_mask_mat = loadMAT(region_mask_mat_path, 1); % Orginal
    region_mask_labels = loadMAT(region_mask_mat_path, 2); % Original
    return
end

region_mask_labels = cell(length(region_dcm_paths) + 1, 1);
region_mask_labels{1} = region_mask_title;
region_mask_mat = zeros([512 512 320]);

for i = 1 : length(region_dcm_paths)
    cur_path = process_path(region_dcm_paths{i});
    region_mask = load_mask_dcm_(cur_path, reg_tf);
    region_mask_labels{i+1} = gen_region_label_(cur_path);
    region_mask_mat(region_mask) = i;
end

save(region_mask_mat_path, 'region_mask_mat', 'region_mask_labels');


%% HELPER FUNCTIONS:
    function [region_label_] = gen_region_label_(region_dcm_path_)
        str_rm = {'SEGMENT', 'Vitrea', 'dcm', '_'};
        region_label_ = strsplit(region_dcm_path_, '/');
        region_label_ = region_label_{end};
        for i_ = 1 : length(str_rm)
           region_label_ = strrep(region_label_, str_rm{i_}, '');
        end
    end

    function [region_mask_] = load_mask_dcm_(region_dcm_path_, reg_tf_)
        try
            region_mask_ = ImportDICOMSequence(region_dcm_path_);
        catch ME
            if strcmp(ME.identifier, 'ImportDICOMSequence:NoDICOM')
                region_mask_ = ImportDICOMSequence(region_dcm_path_);
            end
        end
        region_mask_ = flipdim(region_mask_, 3);
        region_mask_(region_mask_ <= -1024) = 0;
        region_mask_ = logical(region_mask_);
    end

end
