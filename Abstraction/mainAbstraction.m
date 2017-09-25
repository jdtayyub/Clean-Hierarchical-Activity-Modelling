function [ M ] = mainAbstraction( G )
%MAINABSTRACTION Takes as input the set of G graphs in the format [{par}{children}]
%and incrementally merges the hierarchies to produce a unified model
global param

M = {};

model = G{1};
for i = 2:size(G,1) % Incrementally merge and build model
    
    newInstance = G{i};
    model = mergeTwoTrees(model,newInstance);
    disp(['Abstracted until tree: ' num2str(i)]);
end

M = model;

end

function I1 = mergeTwoTrees(I1,I2)
global param;
%merge tree I2 into I1 and return I1 as merged model.
bigI = {I1;I2};
pars = [I1(:,1);I2(:,1)];
SimMat = getListOfNodesSimilarity(pars);
oldI1 = I1 ; oldI2 = I2;
%zeroize the root node entries as they should not be merged at this state.
rootIdxs = find(cell2mat(cellfun(@(x) ismember(x(1),'root'),pars,'uni',0)));
SimMat(:,rootIdxs) = 0; SimMat(rootIdxs,:) = 0;

for i=1 :size(SimMat,1)
    %ids = find((SimMat(i,:)==1)); %ids to group EXACT NODE MATCHING RESULT
    ids = find((SimMat(i,:)>=param.SimThreshold));
    
    if isempty(ids)
        continue;
    else
        ids = [i ids]; % All ids of children that are similar and need merging
        idsCopy = ids;
        while(true)
            [t1,id1,oTidx1] = getTreeOfNode(ids(1),bigI{1},bigI{2}); % Gets  the Instance of which this node belongs to
            [t2,id2,oTidx2] = getTreeOfNode(ids(2),bigI{1},bigI{2});
            C = mergeChildren(id1,id2,t1,t2); % C is the merged child cluster with the [par and children]
            
            bigI{oTidx1} = updateChildren(bigI{oTidx1},id1,C);% bigI{oTidx1} tree
            bigI{oTidx2} = updateChildren(bigI{oTidx2},id2,C);
            bigI{oTidx1}(id1,:) = C; % assign the new child to the old one in the first tree
                  
            bigI{oTidx2}(id2,:) = {0};
                       
            ids = ids(~ismember(ids,ids(2))); % recompute the remianing ids to continue merging the remining ids
            if size(ids,2) == 1
                break;
            end
        end
        
        SimMat(idsCopy,:) = 0;
        SimMat(:,idsCopy) = 0;
        
    end
end

I1 = bigI{1};
I2 = bigI{2};

remIndxs1 = find(cell2mat(cellfun(@(x) ~isequal(x,0),I1(:,1),'uni',0)));
remIndxs2 = find(cell2mat(cellfun(@(x) ~isequal(x,0),I2(:,1),'uni',0)));
I1 = I1(remIndxs1,:);
I2 = I2(remIndxs2,:);
I1 = [I1;I2(2:end,:)];
I1{1,2} = [I1{1,2};I2{1,2}]; %root combining

% May create repeated rules so remove redundant rules and adjust
% probabilities accordingly
I1 = removeRedundantRules(I1);
end

function I1 = removeRedundantRules(I1)
for par = 1 : size(I1,1) % loop throgh each parent and inspect children for exact matches
    
    children = I1{par,2};
    uChildren = children(1,:);
    if size(children,1) == 1
        continue; % single child parents dont need to be processed
    end
    
    for c = 2 : size(children,1)
        found = 0;
        for uC = 1 : size(uChildren,1)
            if isequal(children(c),children(uC))
                
                if isempty(uChildren{uC,3})
                    uChildren{uC,3} = 2;
                else
                    uChildren{uC,3} = uChildren{uC,3}+1;
                end
                found = 1;
            end
        end
        if found ~=1
            uChildren = [uChildren;children(c,:)];
        end
    end
    I1{par,2} = uChildren; %set children to uChildren for this parent
end

end

function tree = updateChildren(tree,parid,C)
oldPar = tree{parid,1};
newPar = C{1,1};
%Find locations in children of other children rules for the old parent and
%replace it with the new parent
list = setdiff([1:size(tree,1)] , parid);
for i=list
    clusNodes = tree{i,2}(:,1);
    if isequal(clusNodes, 0)
        continue;
    end
    for clusIdx = 1 : size(clusNodes,1)
        c = clusNodes{clusIdx};
        idxs = find(cellfun(@(y) isequal(y,oldPar),c));
        if ~isempty(idxs)
            tree{i,2}{clusIdx,1}(idxs) = repmat({newPar},1,size(tree{i,2}{clusIdx,1}(idxs),2));
        end
    end
end
end

function C = mergeChildren(nodeI1,nodeI2,I1,I2)
% merges the children of two nodes as defined by the node ids from the
% two Instance Is.
global param;

c1 = I1(nodeI1,2);
c2 = I2(nodeI2,2);

%compare children together and add them in a new list
uChildren = c1;
numChilduChild = size(uChildren{1},1);
numChildC2 = size(c2{1},1);

for c2idx = 1 : numChildC2
    %compare child clusters for similarity in terms of adjacency matrix
    %match
    child1 = c2{1}(c2idx,:);
    for uC = 1 : numChilduChild
        uChild = uChildren{1}(uC,:);
        found = 0;
        if isequal(param.ClusterMatchingMethod,'exact')
            matchResult = isequal(child1,uChild); %for exact children matching
        elseif isequal(param.ClusterMatchingMethod,'fuzzy')
            matchResult =  linkMatchingDistance(child1,uChild)> param.ClusterThreshold ;
        end
        
        if matchResult == 1 % means found similairty
            found = 1;
            % update the probability AND %%%% KEEP THE MINIMAL DESCRIPTION
            % CHILD%%%% -> TO BE DONE
            uChildren{1}(uC,:) = getMinimalChild(child1,uChild);
            if isempty(uChildren{1}{uC,3})
                uChildren{1}{uC,3} = 2;
            else
                uChildren{1}{uC,3} = uChildren{1}{uC,3} + 1;
            end
            break;% break or continue?
        end
    end
    if found == 0
        uChildren{1} = [uChildren{1}; child1];%add to unique children
    end
end

%parents combining
par1 = I1{nodeI1,1};
par2 = I2{nodeI2,1};
uPar = {unique([par1;par2])};
C = [uPar uChildren];
end

function [tree,nid,oTidx] = getTreeOfNode(n1,I1,I2)
if n1>size(I1,1)
    tree = I2;
    nid = n1-size(I1,1);
    oTidx = 2;
else
    tree = I1;nid = n1;
    oTidx = 1;
end
end

function [minChild] = getMinimalChild(c1,c2)
if size(c1{1},2) > size(c2{1},2)
    minChild = c2;
elseif size(c1{1},2) < size(c2{1},2)
    minChild = c1;
else
    
    innerSizeC1 = sum((cellfun('size',c1{1},1)),2);
    innerSizeC2 = sum((cellfun('size',c2{1},1)),2);
    if innerSizeC1(1) >= innerSizeC2(1)
        minChild = c2;
    else
        minChild = c1;
    end
end
end















