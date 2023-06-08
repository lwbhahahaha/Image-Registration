function [ h ] = view_vol( volume )
%VIEW_VOL views a 3D volume, displaying axial, coronal and sagittal views
%
%   view_vol allows the viewing of a 3D volume, displaying the axial,
%   coronal and sagittal views on the same figure panel, using imtool3D.
%   Unfortunately, by doing so, the scroll wheel function DOES NOT work,
%   but you can still scroll through slices by clicking and holding the
%   sliding arrows or move the slide bar.
%
%   INPUTS:
%
%   volume                        3D volume
%
%
%   OUTPUTS:
%
%   h                             Figure handle
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 17-Apr-2017
%

title   = 'TOP: Axial, BOTTOM(L): Coronal, BOTTOM(R): Sagittal';
h       = figure('Name', title);
imtool3D(volume,                   [ 0  .5    1    .5 ], h); % axial
imtool3D(permute(volume, [3 2 1]), [ 0   0   .5    .5 ], h); % coronal
imtool3D(permute(volume, [3 1 2]), [.5   0   .5    .5 ], h); % sagittal

end
