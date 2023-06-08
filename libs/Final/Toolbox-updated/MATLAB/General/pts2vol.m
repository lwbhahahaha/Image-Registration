function [ vol ] = pts2vol( pts, volsize )
%PTS2VOL ADD ONE SENTENCE DESCRIPTION
%
%   pts2vol ADD THOROUGH DESCRIPTION
%
%   INPUTS:
%
%   pts                           INCLUDE VAR DESCRIPTION
%
%
%   volsize                       INCLUDE VAR DESCRIPTION
%
%
%   OUTPUTS:
%
%   vol                           INCLUDE VAR DESCRIPTION
%
%
%   AUTHOR:       ShantMalkasian
%   DATE CREATED: 11-Oct-2016
%

vol = zeros(volsize);
n = size(pts);
pts = round(pts);
for i=1:n(1)
    vol(pts(i,2,:), pts(i,1,:), pts(i,3,:)) = 1;
end

end
