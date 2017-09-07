function [ cIdx, Z ] = agglomerativeClustering(dat,labels,normalisationParam)
%HIERCLUS Implements a hierarchical clustering mechanism
%cluster points to avoid propagating clustering problem


%PASS IN PARAMETERS : param.similarityTLower  is te similarity 0-1 and the 
% param.distThreshold is number of frame which differ before the cutoff of
% hierarchy, PASS IN THESE  along with normalisation values computed from
% entire TRAINING dataset


%%%%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%

%For Toy example 
% similarityTLower = 0.0;
% distThreshold = 0.102; % THINK ABOUT VALUE OF THIS. number of frames beyond which clusters will stop forming. Cut off point in hierarchical clustering


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global param;


%[distMat] = computeNormalisedDistBetweenPoints(dat,'cityblock');%can be euclidean

distMat = squareform(pdist(dat,param.distOpt));
distMat = normaliseMatrix(distMat,normalisationParam.minV,normalisationParam.diff);

%Normalise matrix using normalisation parameters

NormDistThreshold =  (param.distThreshold - normalisationParam.minV) / normalisationParam.diff;

%LOAD THE semantic similarity matrix previously by taking the labels
%and extracting the similarities from the previously saved ssMAT.
%unless passed in
if ~exist('simM')
    ssMat = extractSimilarityMatrixFromFile(labels);
else
    ssMat = simM;
end

if param.Function == 1
    factor =  ((1-ssMat) * (param.lambda));% (lam)1-S + (1-lam)D
    factor(eye(size(factor,1))==1) = 0;
    dMat = ((1-lam)*distMat) + factor;
    
elseif param.Function ==2
    dMat = distMat;
    dMat(ssMat<param.similarityTLower) = 1;
    dMat(find(eye(size(dMat)))) = 0;
end

dMat = squareform(dMat);

Z = linkage(dMat,'complete');
cIdx = cluster(Z,'cutoff',NormDistThreshold,'criterion','distance');

end

