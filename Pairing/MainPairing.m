function [ output_args ] = MainPairing( path2ClusteredIntervals )
%MAINPAIRING This function is the main function to build hierarchies based
%on optimum pairs between intervals. pass in path2clus where .mat files sit
%per video with the variable fullDat which has format [{label group} {avg start frame} {avg end frame} for each video]

%   POPULATES ->  Pairing/Automated/*

%%% Parameters %%%
global param;
param.frameThreshold = 15; % any intervals shorter than this will be removed as noise -> Remove same from groundtruth too before comparing
param.similarityThreshold = 0.5; % similairty of itnervals before they are rejected as parents due to disimilairty between their names
param.similarityMeasureMetric = 'hungarian'; % the way to compute similarity between two intervals ; 
%OPTIONS : hungarian-> using hungarian algorithm to assign labels with other most similar and penalise unassigned labels
%          mean-> average of similarities between labels of two nodes
%          max-> max of similarities between labels of two nodes
%          min-> mix of similarities between labels of two nodes
%          super-> 
%%%%%%%%%%%

files = dir(path2ClusteredIntervals);%load matfiles of data
[~,idx]=sort_nat({files.name});
files=files(idx);
videoNames = GetVideoNames('Dataset/VideosNames');

for f = 3 : size(files,1) % loop through each clustered interval labelling
    load([path2ClusteredIntervals '/' files(f).name]);%loads fullDat
    vidFileName = files(f).name(1:end-4);
    disp(['Optimum Pairing-' vidFileName]);
    vidNumber = str2double(vidFileName(4:end));
    topActivity = videoNames(vidNumber);
    
    fullDat = pruneShortIntervals(fullDat);
    frames = cell2mat(fullDat(:,2:3));
    labels = fullDat(:,1);
    
    hierarchy = buildHierarchy(frames,labels);
    
end

end






