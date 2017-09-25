function [ newState ] = RecoveryMultiLabel( state, ePos, lastChartID )
%RECOVERY Deletion error recovery recursive function
global chart;

if lastChartID == 0
    chartSection = chart{1};
    chartEntry = 1;
else
    chartSection = chart{lastChartID};
    chartEntry = lastChartID;
end

[lhs, rhs, dotPos, IDs, useFlags, tempRel, se, prob, backPointers] = deconstructState(state);

nextSymbol = rhs{dotPos}; % r.h.s next to dot

if ~isNonterminal(nextSymbol)
    reState = runScanning(state, nextSymbol);
else
    [reState idx] = maxProbState(nextSymbol,chartSection);
    [Rlhs, Rrhs, RdotPos, RIDs, RuseFlags, RtempRel, Rse, Rprob, RbackPointers] = deconstructState(reState);
    
    while RdotPos <= size(Rrhs,2)
    
        reState = RecoveryMultiLabel(reState, RdotPos+1, lastChartID);
        [Rlhs, Rrhs, RdotPos, RIDs, RuseFlags, RtempRel, Rse, Rprob, RbackPointers] = deconstructState(reState);
       
        if RdotPos > size(Rrhs,2)
            break;
        else
            nextSymbol = Rrhs{RdotPos};
            if isNonterminal(nextSymbol)
        
                [reState idx] = maxProbState(nextSymbol,chartSection);
                [Rlhs, Rrhs, RdotPos, RIDs, RuseFlags, RtempRel, Rse, Rprob, RbackPointers] = deconstructState(reState);
                
            end
        end
    end
end

[Rlhs, Rrhs, RdotPos, RIDs, RuseFlags, RtempRel, Rse, Rprob, RbackPointers] = deconstructState(reState);

if RdotPos > size(Rrhs,2) % check if rule finished
    if isequal(Rlhs,lhs)
        newState = reState;
    else
        newState = runCompletion(state, reState, lastChartID);
    end
else
    newState = reState;
end

[Nlhs, Nrhs, NdotPos, NIDs, NuseFlags, NtempRel, Nse, Nprob, NbackPointers] = deconstructState(newState);
if NdotPos < ePos
    newState = RecoveryMultiLabel(newState, ePos, lastChartID);
end

end

function reState = runScanning(state,nextSymbol)
[lhs, rhs, dotPos, IDs, useFlags, tempRel, se, prob, backPointers] = deconstructState(state);
global wordFrames;
reState = state; reState{3} = dotPos + 1;
if isequal(reState{4}{1}, 0)
    reState{4} = {-1};
    reState{7} = [-1 -1]; % adding the start end times
else
    reState{4} = [reState{4}; {-1}];
    reState{7} = [reState{7}; [-1 -1]]; % adding the start end times
end
%addToChart(reState,chartEntry+1);
%chart{chartEntry}(stateNumber,5) = {1}; %set one to the used rule flag so it isnt readded in next state set.

end

function newState = runCompletion(state, reState, chartID)

global chart;

%Adding recovered state to the the chart where is was recovered from
reState{5} = 1;
addedIdx = addToChart(reState,chartID);

state{3} = state{3} + 1;
if isequal(state{4}{1}, 0)
    state{4} = {cell2mat(reState{4})};
    state{7} = [-1 -1]; % adding the start end times
else
    state{4} = [state{4}; {cell2mat(reState{4})}];
    state{7} = [state{7}; [-1 -1]]; % adding the start end times
end

state{8} = state{8} + reState{8}; % update probability
state{9} = [state{9}; [chartID,addedIdx]]; %back pointer

newState = state;
end

function [state, stateidx] = maxProbState(nextSymbol,chartSection)

candidates = {};
candidateIDs = [];
for cs = 1 : size(chartSection,1)
    
    [lhs, rhs, dotPos, IDs, useFlags, tempRel, se, prob, backPointers] = deconstructState(chartSection(cs,:));
    if isequal(lhs,nextSymbol)
        candidates = [candidates; chartSection(cs,:)];
        candidateIDs = [candidateIDs; cs];
    end
    
end

probs = cell2mat(candidates(:,8));
maxProb = max(probs);
maxProbIdx = find((probs==maxProb));
candidates = candidates(maxProbIdx,:); candidateIDs = candidateIDs(maxProbIdx,1);
 
candDotPos = cell2mat(candidates(:,3));
maxDotPos = max(candDotPos);
maxDotPosIdx = find(candDotPos == maxDotPos);
candidates = candidates(maxDotPosIdx,:); candidateIDs = candidateIDs(maxDotPosIdx,1);
 
candDelErrors = candidates(:,4);
numDelErrors = cellfun(@(x) sum(cat(1,x{:})==-1),candDelErrors);
[v numDelErrorsIdx] = min(numDelErrors);
candidates = candidates(numDelErrorsIdx,:); candidateIDs = candidateIDs(numDelErrorsIdx,1);
 
stateidx = candidateIDs(1);
state = chartSection(stateidx,:);

end




