function hierarchy = buildHierarchy(frames,labels)
% A function that generates the optimum pairing of the hierarchy based on
% frames 2 dim array of start and end time pre sorted by end time and
% labels which is a clustered grouping of corresponding labels per interval
% func used is described in aaai18 paper -> lj / oij*[lj-li]

global param;

% Trying to find the best parents j for the each child i
pairingList = [];
for i = 1 : size(frames,1) % loop through each interval
    sChil = frames(i,1); % start frame of child
    eChil = frames(i,2); % end frame of child
    candidates = [];
    for j = setdiff(1:size(frames,1),i) % rest of intervals
        sPar = frames(j,1); % start frame of parent
        ePar = frames(j,2); % end frame of parent
        [intersecting,overlap] = isOverlapping([sChil eChil],[sPar ePar]);
        longerFlag = isLonger([sChil eChil],[sPar ePar]); % checks if parent is longer than children
        
        fullSubsumedFlag = true; % needed for baseline
        if isequal(param.pairingMethod , 'Baseline')
            fullSubsumedFlag = isFullySubsumed([sChil eChil],[sPar ePar]);
        end
            
        if intersecting && longerFlag ...
                && fullSubsumedFlag && hasValidSubjects(labels{i}, labels{j}) % checks for validity of subjects
            length = ePar - sPar;
            candidates = [candidates; [j length]];
        end
    end
    
    if isempty(candidates) % check whether any candidates, if none means no interval subsumes this interval and so the parent become root or 0
        pairingList(i,:) = [0 i];
    else
        %compute a cost and similarity for each candidate
        costs = [];
        similairities = [];
        for c=1 :size( candidates,1)
            parIntervalIdx = candidates(c,1); % potential parent index
            labelCand = labels{parIntervalIdx};
            
            if isequal(param.pairingMethod , 'Baseline')
                cost = 1; % just assign every candidate same cost in case of Baseline
            else
                cost = costFunction([sChil eChil],frames(parIntervalIdx,:)); % child frames , potential parent frames
            end
            
            if (param.useSemanticAnalysis == 1) % if to use sem sim
                
                similairities = [similairities; getNodeSimilarity(...
                    removePrefixFromLabel(labels{i}),...
                    removePrefixFromLabel(labelCand))]; % label child and label of candidate parent
            end
            costs = [costs;cost];
        end
        % first disqualify low similairty candidates then select the
        % minimum cost candidate
        if isempty(similairities) % means semantic analysis disabled so nothing rejected
            rejIdxs = [];
        else
            rejIdxs = find(similairities<param.nodeSimilarityThreshold); %rejected candidates
        end
        
        remIdxs = setdiff(1:size(candidates,1),rejIdxs); % remaning candidates
        
        [~,minCostIdx] = min(costs(remIdxs));
        
        if ~isempty(minCostIdx) %in case all candidates are rejected then the parent is 0
            winningParentIdx= candidates(remIdxs(minCostIdx),1);
        else
            winningParentIdx = 0;
        end
        pairingList(i,:) = [winningParentIdx i];
    end
    
end

[Y,I]  = sort(pairingList(:,1));
hierarchy=pairingList(I,:);

end

function flag = isLonger(interval1, interval2)
% takes interval 1 and interval 2 and returns is interval2 (parent) is
% indeed longer thatn interval 1
flag = 0;
len1 = interval1(2) - interval1(1);
len2 = interval2(2) - interval2(1);

if len2 > len1
    flag = 1;
end

end

function flag = isFullySubsumed(interval1,interval2)

flag = false;
s1 = interval1(1); e1 = interval1(2); 
s2 = interval2(1); e2 = interval2(2); 

if s1 >= s2 && e1<=e2
    flag = true;
end
    
end

