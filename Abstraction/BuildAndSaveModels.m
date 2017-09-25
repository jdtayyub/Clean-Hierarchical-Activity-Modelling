function [ output_args ] = BuildAndSaveModels( absPath2Trees, absPath2FullDat , vidNames , DS )
%SAVEMODELS Summary of this function goes here
%   Detailed explanation goes here

%DS = 'CAD';%'CAD','LAD' or 'CLAD'
trainVidNum = [];
topActvs = unique(vidNames);
if isequal(DS,'CAD') ||isequal(DS,'LAD')
    trainVidsPerFold = 'all';% CAD and LAD 'all' , CLAD '5'
elseif isequal(DS,'CLAD')
    trainVidsPerFold = '3';% CAD and LAD 'all' , CLAD '5'
end

if exist([DS 'VideoGroups.mat']) ~= 2 % if found then groups preloaded
    
    files = dir(absPath2Trees);
    [~,idx]=sort_nat({files.name});
    files=files(idx);
        
    vidTreeGroups = cell(size(topActvs,1),3); % hold the training video trees for each top level activities
    for f = 3 :size(files,1)
        load([absPath2Trees '/' files(f).name]); % Loads LabelsTree which is needed to build the mabstract model
        load([absPath2FullDat '/' files(f).name(1:end-9) '.mat'])
        vidFileNum = str2num(files(f).name(4:end-9));
        vidFileName = vidNames(vidFileNum);
        
        vidTreeGrpId = find(ismember(topActvs,vidFileName)); % save the videos trees regarding this activity in this index in vidTreeGroups
        vidTreeGroups{vidTreeGrpId,1} = [vidTreeGroups{vidTreeGrpId,1}; LabelsTree]; % labels tree
        vidTreeGroups{vidTreeGrpId,2} = [vidTreeGroups{vidTreeGrpId,2}; {IdsTree}];  % corresponding id tree
        vidTreeGroups{vidTreeGrpId,3} = [vidTreeGroups{vidTreeGrpId,3}; {fullDat}]; % corresponding fulldat
    end
   save(['Abstraction/' DS 'VideoGroups.mat']);
    % vidTreeGroups : [{labelTrees IdsTrees FullDats }] groups for each
    % activity
else
    load(['Abstraction/' DS 'VideoGroups.mat']);
end

Models = cell(size(topActvs)); % saves the abstracted models for each group of video activities

% Now learn the models per video group per top level activity
treeLab = vidTreeGroups(:,1);
treeIds = vidTreeGroups(:,2);
treeFullDat = vidTreeGroups(:,3);
for act =1  : size(treeLab,1)
    disp(['ACTIVITY:' num2str(act)]);
    Trees = treeLab{act}; % to use to abstract model
    TreesIds = treeIds{act}; % corresponding ids format of trees
    TreesFullDat = treeFullDat{act};% corresponding fullDat of trees
    
    foldModels = cell(size(Trees,1),2); % these are models per fold IDX of model is the test video tree in vidTreeGroups
    
    if isequal(DS,'CAD') ||isequal(DS,'LAD')
    
        for t = 1 : size(Trees,1)
            testTree = Trees(t);
            trainTrees = Trees(setdiff(1:size(Trees,1),t));
            m = mainAbstraction(trainTrees);
            foldModels{t,1} = m; % on first column is the trained model
            foldModels{t,2} = [testTree TreesIds(t) TreesFullDat(t)]; % on secomd column is the corresponding test tree wihth label format and ids format and fuldat

        end
 
    else
% for clad
        trainVidNum = 5; % SET THIS HERE
        treeids = [1:size(Trees,1)];
        
        for t =1  : size(Trees,1)-trainVidNum
            trainIdxs = [t:t+trainVidNum-1];
            trainTrees = Trees(trainIdxs);
            testIdxs = setdiff(1:size(Trees,1),trainIdxs);
            testTrees = Trees(testIdxs);
            m = mainAbstraction(trainTrees);
            foldModels{t,1} = m;
            foldModels{t,2} = [testTrees TreesIds(testIdxs) TreesFullDat(testIdxs)];
        end
        
        
    end
    
    Models{act} = foldModels;% foldmodels for that activity.
end

%%%save models%%%%
save(['Abstraction/Models/' DS '/Models' num2str(trainVidNum) '.mat'],'Models') % where each row is a fold 
%for testing and in each row we have first column giving teh abstracted model 
%and second column giving the set of test videos in form of LabTrees and
%IdsTrees to be used on testing that model

end

