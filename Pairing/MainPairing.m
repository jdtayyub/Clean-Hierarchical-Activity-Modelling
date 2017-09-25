function [ output_args ] = MainPairing( absPath2ClusteredIntervals , absPath2SaveTrees)
%MAINPAIRING This function is the main function to build hierarchies based
%on optimum pairs between intervals. pass in absolute path2clus where .mat
%files sit since the code may be used by other functions, it is best to use
%absolute paths
%per video with the variable fullDat which has format [{label group} {avg start frame} {avg end frame} for each video]

%   POPULATES ->  Pairing/Automated/*

%%% Parameters %%% CHECK PARAMETERS FOR EACH DATASET USED
clearvars -global param;
global param;
param.frameThreshold = 15; % any intervals shorter than this will be removed as noise -> Remove same from groundtruth too before comparing
param.nodeSimilarityThreshold = 0.3; % similairty of itnervals before they are rejected as parents due to disimilairty between their names
param.similarityMeasureMetric = 'hungarian'; % the way to compute similarity between two intervals ; 
%OPTIONS : hungarian-> using hungarian algorithm to assign labels with other most similar and penalise unassigned labels
%          mean-> average of similarities between labels of two nodes
%          max-> max of similarities between labels of two nodes
%          min-> mix of similarities between labels of two nodes
%          super-> 
%%%%%%%%%%%
param.pairingMethod = 'costBased';%'Baseline'; %Options 1.costBased , 2.Baseline


%%%%%%CLAD%%%%%%%%%%%%%
%param.useSemanticAnalysis = 1; % 1 to use or 0 not to use semantic analysis in pairing

%%%CAD AND LAD%%%%
param.useSemanticAnalysis = 0;


files = dir(absPath2ClusteredIntervals);%load matfiles of data
[~,idx]=sort_nat({files.name});
files=files(idx);
%videoNames = GetVideoNames('Dataset/VideosNames');

for f = 3 : size(files,1) % loop through each clustered interval labelling
    load([absPath2ClusteredIntervals '/' files(f).name]);%loads fullDat
    vidFileName = files(f).name(1:end-4);
    disp(['Optimum Pairing-' vidFileName]);
    vidNumber = str2double(vidFileName(4:end));
    %topActivity = videoNames(vidNumber);
    
    fullDat = pruneShortIntervals(fullDat);
    frames = cell2mat(fullDat(:,2:3));
    labels = fullDat(:,1);
    
    hierarchy = buildHierarchy(frames,labels);
    
    %Build Full Structure by Augmenting with Temporal Nodes
    %[NodesList as {[parentNodeID]} child cluster as {{children node id}{temporal nodes of children}} 
    %labels to refer to all the node ids as {labelList}]
    
    IdsTree = augmentTemporalNodes(  hierarchy, frames, labels ); 
    LabelsTree = ids2labelconversion(IdsTree);
    
    
    %%%%SAVE RESULTS%%%%
    save([absPath2SaveTrees '/' vidFileName '_Tree'],'IdsTree','LabelsTree');
    %%%%%%%%%%%%%%%%%%%%
end

end






