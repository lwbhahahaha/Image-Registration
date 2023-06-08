function [ lad_pts, lcx_pts, rca_pts ] = load_vessels( acq_path, vessel_folder )
%[ lad_pts, lcx_pts, rca_pts ] = load_vessels( acq_path, vessel_folder )
%
%LOAD_VESSELS ADD ONE SENTENCE DESCRIPTION
%
%   load_vessels ADD THOROUGH DESCRIPTION
%
%   INPUTS:
%
%   acq_path                      INCLUDE VAR DESCRIPTION
%
%
%   vessel_folder                 INCLUDE VAR DESCRIPTION
%
%
%   OUTPUTS:
%
%   lad_pts                       INCLUDE VAR DESCRIPTION
%
%
%   lcx_pts                       INCLUDE VAR DESCRIPTION
%
%
%   rca_pts                       INCLUDE VAR DESCRIPTION
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 08-Feb-2018
%

lad_path = verify_path(acq_path, [vessel_folder '/lad_tree_dcm.mat'], 'VesselTree');
lcx_path = verify_path(acq_path, [vessel_folder '/lcx_tree_dcm.mat'], 'VesselTree');
rca_path = verify_path(acq_path, [vessel_folder '/rca_tree_dcm.mat'], 'VesselTree');

lad_pts = loadMAT(lad_path);
lcx_pts = loadMAT(lcx_path);
rca_pts = loadMAT(rca_path);

lad_pts(:,3) = 320 - lad_pts(:,3);
lcx_pts(:,3) = 320 - lcx_pts(:,3);
rca_pts(:,3) = 320 - rca_pts(:,3);
end

