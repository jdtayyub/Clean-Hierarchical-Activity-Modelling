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
for f = 3 : size(files,1)
    vidFileName = files(f).name;
    disp(['Abstraction-' vidFileName]);
    pieces = strsplit(vidFileName,'_');
    vidNumber = str2double(pieces{1}(4:end));
    
    modelNum = find(ismember(topActNames,videoNames(vidNumber)));
    
    load([path2Hierarchies '/' files(f).name]); % loads the IdsTree and LabelsTree for that video
    
    allVidData = [allVidData;LabelsTree{1}];
    
    %%% Merge same parents together %%% LOOK FOR SAME PARENTS EXCEPT ROOT
    
        
    %%% build the exhaustive model %%%% Find the similar nodes and merge
    %%% their children
    
    
%     if isempty(models{modelNum})
%         updatedModel = LabelsTree; % assign the first instant to the model if its empty 
%     else
%         % Augment model with current tree instant
%         updatedModel = augmentModel(models{modelNum},LabelsTree{1}); 
%     end
%     
%     models(modelNum) = updatedModel;
    
end

end























