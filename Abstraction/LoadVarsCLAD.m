function [ output_args ] = LoadVarsCLAD( input_args )
%LOADVARSCLAD Summary of this function goes here
%   Detailed explanation goes here


clearvars -global

global param


param.SimThreshold = 0.4;
param.ClusterThreshold= 0.6;
param.ClusterMatchingMethod = 'fuzzy'; % options; exact or fuzzy 
param.similarityMeasureMetric = 'hungarian';
param.frameThreshold = 15; % minimum number of frame below which prune the interval to

% control parameter to tune similarity of temporal nodes versus semantic similarity
param.beta = 0.25;
param.gamma = 0.5; 
param.alpha = 0.5;


global SemSimMat;
global alllabels;
if ~exist('alllabels')
    load('Generally Needed Functions/Similarity Matrices & Labels/ssMat.mat');
elseif isempty(alllabels)
    % should contain alllabels (all unique labels) and SemSimMat (their corresponding similarity matrix)
    load('Generally Needed Functions/Similarity Matrices & Labels/ssMat.mat'); 
end
global lMap;
if ~exist('lMap') || isempty(lMap)
    lMap = containers.Map(alllabels,1:size(alllabels,1));
end 

end

