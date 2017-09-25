function [ output_args ] = LoadVarsCAD( path2CADFullData )
%LOADVARSCAD Gets list of all labels of CAD dataset and creates a sem sim
%matrix to work with rest of abstraction and parsing code

clearvars -global

global SemSimMat
global alllabels
global param


param.SimThreshold = 0.7;
param.ClusterThreshold= 0.5;
param.ClusterMatchingMethod = 'fuzzy'; % options; exact or fuzzy 
param.similarityMeasureMetric = 'hungarian';
param.frameThreshold = 15; % minimum number of frame below which prune the interval to

% control parameter to tune similarity of temporal nodes versus semantic similarity
param.beta = 0.25;
param.gamma = 0.5; 
param.alpha = 0.5;

files = dir(path2CADFullData);
labs = {};
for f = 3: size(files,1)
    load([path2CADFullData '/' files(f).name])
    labs = [labs; cellfun(@(x) x,fullDat(:,1))];
end
alllabels = unique(labs);
SemSimMat = zeros(size(alllabels,1));
SemSimMat(eye(size(alllabels,1))==1) = 1;


global lMap;
if ~exist('lMap') || isempty(lMap)
    lMap = containers.Map(alllabels,1:size(alllabels,1));
end 


end

