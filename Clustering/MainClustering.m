function [ clusters, fullDats ] = MainClustering( path2ds ) %path to dataset

%MAINCLUSTERING Main function to perform the agglomerative clustering on
%the input data
%   

%%% Parameters %%%
global param;
param.similarityTLower = 0.79; % similarity value
param.distThreshold = 32; % distance frame
param.sortBy = 2; % order intervals by 1. start time , 2. end time
param.Function = 2; % 1 for delta =  1-lam(1-S) + (1-lam)D , 2 for  delta if S>similartiyT , 1 otherwise
param.lamda = 0.9; % change factor here default 0 to 1, 0 for full distance 1 for full semantic
param.distOpt = 'cityblock'; % distance to use to measure between start end frame distances 
%%%%%%%%%%%%%%%%%%
folders = dir(path2ds);
[~,idx]=sort_nat({folders.name});
folders=folders(idx);
videoNames = GetVideoNames('Dataset/VideosNames');

clusters = {};
fullDats = {};

for f = 3:size(folders,1)
    load([path2ds '/'  folders(f).name]); % load fullAnnots {label} {start frame} {end frame}
    vidFileName = folders(f).name(1:end-4);
    disp(vidFileName);
    vidNumber = str2double(vidFileName(4:end)); 
    
    mat = cell2mat(fullAnnots(:,2:3)); % frames
    if param.sortBy == 1
        [~, i] = sort(mat(:,1)); % Sort by start time
    elseif param.sortBy == 2 
        [~, i] = sort(mat(:,2)); % Sort by end time
    end
    fullAnnots = fullAnnots(i,:);
    
        
    %Based on the video category, cluster either according to the subject
    %or not otherwise
    [normalisationParam.diff , normalisationParam.minV] = ...
        computeNormalisationParams(vidNumber,path2ds,videoNames); %DO THIS PER TopActivity
    
    if isequal(videoNames{vidNumber} , 'lunch')
        % individually cluster the different people (p)
        [ splitIdx,splitLab,splitFrames ] = processPrefixForMultiSubjectVideos( fullAnnots ); % W ,C, B 
        splitClusters = {};
        for p=1:size(splitIdx,1)
            cIdxs = agglomerativeClustering(splitFrames{p},splitLab{p},normalisationParam);
            splitClusters = [splitClusters; cIdxs];
        end
                
        clusterIdxs = combineClusteringOfAllSubjects(splitClusters,splitIdx);
        
    else
        m = cell2mat(fullAnnots(:,2:3));
        l = fullAnnots(:,1);
        [cIdxs, Z] = agglomerativeClustering(m,l,normalisationParam); % cIdxs cluster indexes, Z linkage output for dendogram
        clusterIdxs = cIdxs;
    end
    
    fullDat = combineLabelsIntoFullDat(clusterIdxs,fullAnnots(:,1),mat);%cIdxs labels and frames matrix
    
    
    
    clusters = [clusters;clusterIdxs];
    fullDats = [fullDats; fullDat];
    
    %%% SAVE RESULT %%%
    save(['Clustering/Automated/Our Agglom Clustering/Clustered Indexes/' vidFileName '.mat'],'clusterIdxs');
    save(['Clustering/Automated/Our Agglom Clustering/Full Clustered Data/' vidFileName '.mat'],'fullDat');
    %%%%%%%%%%%%%%%%%%%
end

end

