function [ euc ] = MeanMinEuclideanDist( P, Q, dv )
%MEANMINEUCLIDEANDIST calculates the mean minimum euclidean distance
%between two sets of points P and Q
%
%   MeanMinEuclideanDist is used to assess the boundary differences between
%   two sets of points.  This function works in for points in 2 and 3
%   dimensions.  The outputted mean minimum euclidean distance is in the
%   same units as the inputted points.  Visualization is possible on 2D
%   data.  3D data will usually be too large to visualize in MATLAB, and is
%   discouraged.  When running this on a volume, it is highly suggested to
%   unrasterize only the PERIMETER of the volume, using bwperim (MATLAB
%   built-in function).  It is highly likely, memory will run out due to
%   the huge computational demands of this metric, if full volume data is
%   used.  P and Q must be the same dimension, but there may be a different
%   number of points in each set.  This function was developed by modifying
%   the HausdorffDistance function, downloaded from MATLAB File Exchange.
%
%   INPUTS:
%
%   P                             2D/3D set of points
%
%
%   Q                             2D/3D set of points
%
%
%   dv                            P and Q are 2D, 'vis' or 'visualize' may
%                                 inputted for dv, to specify
%                                 visualization
%
%
%   OUTPUTS:
%
%   euc                           Mean minimum Euclidean distance, in units
%                                 of the inputted points
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 08-Sep-2017
%

sP = size(P); sQ = size(Q);

if ~(sP(2)==sQ(2))
    error('Inputs P and Q must have the same number of columns')
end

if nargin < 3
    dv = 0;
end

minP = zeros(length(P),1);
% loop through all points in P looking for maxes
for p = 1:sP(1)
    % calculate the minimum distance from points in P to Q
    minP(p) = min(sum( bsxfun(@minus,P(p,:),Q).^2, 2));

end
% repeat for points in Q
minQ = zeros(length(Q), 1);
for q = 1:sQ(1)
    minQ(q) = min(sum( bsxfun(@minus,Q(q,:),P).^2, 2));
end

minP = minP .^ (.5);
minQ = minQ .^ (.5);

minP( minP == 0 ) = nan;
minQ( minQ == 0 ) = nan;

idx_nanP = isnan(minP);
idx_nanQ = isnan(minQ);

P_rm                = P;
Q_rm                = Q;
P_rm(idx_nanP,:)    = []; % extra step to actually remove zero distance pts, can be useful for analysis (might be redundant)
Q_rm(idx_nanQ,:)    = [];

euc = mean([nanmean(minP(:)) nanmean(minQ(:))]);

if nargin == 3 && any(strcmpi({'v','vis','visual','visualize','visualization'},dv)) && sP(2) == 2
    % obtain all possible point comparisons
    iP = repmat(1:sP(1),[1,sQ(1)])';
    iQ = repmat(1:sQ(1),[sP(1),1]);
    combos = [iP,iQ(:)];

    % get distances for each point combination
    cP=P(combos(:,1),:); cQ=Q(combos(:,2),:);
    dists = sqrt(sum((cP - cQ).^2,2));

    % Now create a matrix of distances where D(n,m) is the distance of the nth
    % point in P from the mth point in Q. The maximum distance from any point
    % in Q from P will be max(D,[],1) and the maximum distance from any point
    % in P from Q will be max(D,[],2);
    D = reshape(dists,sP(1),[]);

    % visualize the data
    figure
    hold on
    axis equal

    % need some data for plotting
    [mp, ixp] = min(D,[],2);
    [mq, ixq] = min(D,[],1);
    h(1) = plot(P(:,1),P(:,2),'bx','markersize',10,'linewidth',3);
    h(2) = plot(Q(:,1),Q(:,2),'ro','markersize',8,'linewidth',2.5);

    % draw all minimum distances from set P
    Xp = [P(1:sP(1),1) Q(ixp,1)];
    Yp = [P(1:sP(1),2) Q(ixp,2)];
    % draw all minimum distances from set Q
    Xq = [P(ixq,1) Q(1:sQ(1),1)];
    Yq = [P(ixq,2) Q(1:sQ(1),2)];
    h = [h plot([Xq' Xp'], [Yq' Yp'],'-m')'];
    h = h(1:3);

    uistack(fliplr(h),'top')
    xlabel('Dim 1', 'FontSize', 15, 'FontWeight', 'bold'); 
    ylabel('Dim 2', 'FontSize', 15, 'FontWeight', 'bold'); 
    title(['Mean Minimum Euclidean Distance = ' num2str(euc) ' mm'], 'FontSize', 20, 'FontWeight', 'bold')
    legend(h, {'P','Q', 'Minimum Non-zero Distances'})
end


end
