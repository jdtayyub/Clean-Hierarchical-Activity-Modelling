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

        if intersecting && hasValidSubjects(labels(i), labels(j))
            % also check for all waitress/ customer labels and remove them
            % from candidate list since a waitress or customer interval
            % cannot be parent of the other . only (both) intervals can be
            % parent of either

            length = ePar - sPar;
            candidates = [candidates; [j length]];
        end
    end
    
    if isempty(candidates) % check whether any candidates, if none means no interval subsumes this interval and so the parent become root or 0
        pairingList(i,:) = [0 i];
    else
        %compute a cost for each candidate
        costs = [];
        for cand = candidates
            parIntervalIdx = cand(1); % potential parent index
            labelCand = labels(parIntervalIdx);
            cost = costFunction([sChil eChil],frames(parIntervalIdx,:)); % child frames , potential parent frames
            
            similairity = getNodeSimilarity(labelChil,labelCand);
            costs = [costs;cost];
        end
        % first disqualify low similairty candidates then select the
        % minimum cost candidate
        rejIdxs = find(similarity<param.similarityThreshold); %rejected candidates
        remIdxs = setdiff(1:size(candidates,1),rejIdxs); % remaning candidates
        [~,minCostIdx] = min(costs(remIdxs));
        winningParentIdx = candidates(minCostIdx,1);
        pairingList(i,:) = [winningParentIdx i];
    end
    
end

[Y,I]  = sort(pairingList(:,1));
hierarchy=pairingList(I,:);

end