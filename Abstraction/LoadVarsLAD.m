function [ output_args ] = LoadVarsLAD( path2LADFullData )
%LOADVARSLAD Summary of this function goes here
%   Detailed explanation goes here
clearvars -global

global SemSimMat
global alllabels
global param


param.SimThreshold = 0.7;
param.ClusterThreshold= 0.7;
param.ClusterMatchingMethod = 'fuzzy'; % options; exact or fuzzy 
param.similarityMeasureMetric = 'hungarian';
param.frameThreshold = 15; % minimum number of frame below which prune the interval to

% control parameter to tune similarity of temporal nodes versus semantic similarity
param.beta = 0.25;
param.gamma = 0.5; 
param.alpha = 0.5;

files = dir(path2LADFullData);
labs = {};
for f = 3: size(files,1)
    load([path2LADFullData '/' files(f).name])
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
