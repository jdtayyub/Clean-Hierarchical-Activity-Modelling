function [ output_args ] = LoadVars( input_args )
%LOADVARS Summary of this function goes here
%   Detailed explanation goes here

%CHANGE THE LOADED FILE TO THE LATEST GENERATED ONE.
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

