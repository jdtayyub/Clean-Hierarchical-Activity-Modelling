function [ models ] = MainAbstraction( path2Hierarchies )
%MAINABSTRACTION Summary Given a list of paired hierarchies from the
%MainPairing, THis function will attempt to generalise the hierarchies to
%stochastic grammars per top level activity

%%%Parameter %%%%%%%%
global param;
param.clusterSimilarityThreshold = 0.5; % threshold to judge similarity between two child clusters
%%%%%%%%%%%%%%%%%%%%%%%%%


files = dir(path2Hierarchies); 
[~,idx]=sort_nat({files.name});
files=files(idx);
videoNames = GetVideoNames('Dataset/VideosNames');

topActNames = unique(videoNames);
models = cell(size(topActNames,1),1); % full models per top level activities for each uniqu

allVidData = {};% concatenated array of all trees for parent mathcing 

% Gather all trees in single list in single variable 'allVidData'
if exists
for f = 3 : size(files,1)
    vidFileName = files(f).name;
    disp(['Abstraction-' vidFileName]);
    pieces = strsplit(vidFileName,'_');
    vidNumber = str2double(pieces{1}(4:end));
    
    modelNum = find(ismember(topActNames,videoNames(vidNumber)));
    
    load([path2Hierarchies '/' files(f).name]); % loads the IdsTree and LabelsTree for that video
    
    allVidData = [allVidData;LabelsTree{1}];
        
end
%%% Merge same parents together %%% LOOK FOR SAME PARENTS EXCEPT ROOT

    parents = allVidData(:,1);
    children = allVidData(:,2); % child cluster of corresponding parents
    
   %Cluster similar parents together
   smat = generateNodeSimilarityMatrix( parents );
   cmat = SimilarityMatrixProcessing(smat,'euclid');
    linkage(cmat)
   
end























