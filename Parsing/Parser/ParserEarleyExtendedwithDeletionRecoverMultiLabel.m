function [ chart ] = ParserEarleyExtendedwithDeletionRecoverMultiLabel ( gram, startSymbol, sent )
%MAINPARSEREARLEYBASIC Takes in grammar and sentence and returns the parse
%based on earley algorithm the word state and rule is used interchangably
% sent is temporally ordered by start time set {s R T} where s is list of words, R is the allen temporal matrix
% and T is the start and end times of s.


global alllabels
if exist('alllabels')
    if isempty(alllabels)
        LoadVarsToy;
    end
else
    LoadVarsToy;
end

%initialist chart with a gamma state.
global param;
global startSym;
startSym = startSymbol;
global words;global wordFrames;
words = sent{1}';
wordFrames = sent{3};
global chart;
global chartIDsList;

global grammar;
grammar = gram;
grammar(:,4) = num2cell(log(str2num(str2mat(grammar(:,4)))));
%chart = cell(size(words,2) +1,1);
%Starting symbol, in this case S, then comes dotPosition, I list of indexes of primitives covered, probability
chart = cell(size(words,2) +1,1);

% PAR Node, Children Nodes, Dot Position, IDs Covered, UsedFlag, Temporal
% Relations, Start End Times, Probability, Backpointers

chart{1} = [grammar(:,1:2) repmat({1 {0} []},size(grammar,1),1) ...
    grammar(:,3) num2cell(repmat([0 0],size(grammar,1),1),2) ...
    grammar(:,4) repmat({[]},size(grammar,1),1)  ];
%size(words,2)
for i = 1 : size(words,2)+1
     
    executeEarleyFunctions(i);
    
    if i < size(words,2)+1
        usedRuleflags = (chart{i}(:,5));
        incompleteRules = chart{i}(~cellfun(@(x) isequal(x,1),usedRuleflags),:);
        chart{i+1} = [chart{i+1}; incompleteRules];
    end
    
end
end

function executeEarleyFunctions(i)
pointer = 1; % State processed
global chart;global words;
while(pointer<=size(chart{i},1)) % go through all the states
    state = chart{i}(pointer,:);
    [lhs, rhs, dotPos,IDs] = deconstructState(state); %IDs is a vector of primitive ids covered by that state
    if dotPos <= size(rhs,2) % incomplete sate check
        nextSymbol = rhs{dotPos}; % r.h.s next to dot
        if isNonterminal(nextSymbol)
            predictor(state,i);
        else % terminal case
            if i ~= size(words,2)+1 %ONLY scan when not at the end of words%%%%%%CHECK THIS%%%%%%555
                scanner(state,i,pointer);
            end
        end
    else
      completer(state,i,pointer); % storing the back pointer
    end
    pointer = pointer + 1;
    %size(chart{i},1)
end

end

function predictor(state,chartEntry)
%disp('predictor');
[lhs, rhs, dotPos, IDs, useFlags, tempRel, se, prob] = deconstructState(state);
nextSymbol = rhs{dotPos};
rules = getRulesOfSymbol(nextSymbol);
remData = rules(:,3:4);
rules(:,3:4) = [];
for r = 1 : size(rules,1)%setiing dot poitiosn and start and end position
    rules(r,3) = {1}; % dot in the beginning
    %rules(r,4) = {IDs}; %ids
    rules(r,4) = {{0}}; % cell so to be able to carry multiple IDs
    rules(r,5) = {[]}; % flags
    rules(r,6) = remData(r,1);
    rules(r,7) = {[0 0]};
    rules(r,8) = remData(r,2);
    rules(r,9) = {[]};
end
addToChart(rules,chartEntry); % add new rules to current chart
end

function scanner(state,chartEntry,stateNumber)

global words; global chart;global wordFrames;
%disp('scanner');
[lhs, rhs, dotPos, IDs] = deconstructState(state);
nextSymbols = rhs(dotPos:end); % list of symbols in the rule
word = words{chartEntry};
idx = searchSymbolInList(nextSymbols, word, 1);% returns where the word occurs in the remaining rule 1 means terminal check
if ~isempty(idx)
    if idx == 1
        if temporalRelationsComparison( state, wordFrames(chartEntry,:) ) % word found && temporal nodes match
            newState = state; newState{3} = dotPos + 1;
            if isequal(newState{4}{1}, 0)
                newState{4} = {chartEntry};
                newState{7} = wordFrames(chartEntry,:); % adding the start end times
            else
                newState{4} = [newState{4}; {chartEntry}];
                newState{7} = [newState{7}; wordFrames(chartEntry,:)]; % adding the start end times
            end
            addToChart(newState,chartEntry+1);
            chart{chartEntry}(stateNumber,5) = {1}; %set one to the used rule flag so it isnt readded in next state set.
        end
    else
        newState = RecoveryMultiLabel(state,idx+dotPos-1,chartEntry);
        addToChart(newState,chartEntry);
        chart{chartEntry}(stateNumber,5) = {[]}; % So all recovered state dont stop forward movement of other states
    end
end

end

function completer(state,chartNum,StateNum,newSIdxs)
%disp('completer');
global nodeSimThreshold;
global chart;global startSym;global words;
[lhs, rhs, dotPos, IDs, useFlags, tempRel, se, prob] = deconstructState(state);

if isequal(useFlags ,{1})  %if state has been processed before , perhaps trough deletion error recovery, then skip the completion
    return; %%%%%%%%%%%%%%%%%%%%% NEEDS CHECKING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

if isequal(lhs,startSym)
    % add the completed state to the last chart to be processed later 
    addToChart(state,size(words,2)+1);
    chart{chartNum}(StateNum,5) = {1};
    return;
end

chartSection = chart{chartNum-1}; %previous chart

if ~exist('newSIdxs','var')
    list = 1:size(chartSection,1);
else
    list = newSIdxs';
end

newAddedStateIdxs = [];

%check for previous rules that apply
for c=list
    %[lhsT, rhsT, dotPosT, IDs,pointers] = deconstructState(chartSection(c,:));
    [lhsT, rhsT, dotPosT, IDsT,~,~,~,probT] = deconstructState(chartSection(c,:));
    if size(rhsT,2) >= dotPosT % check for complete rules and ignore, just match with uncompleted rules
        nextSymbol = rhsT{dotPosT}; % expected symbol - HOWEVER INCLUDE THE DELETION ERROR BY LOOKING AT ALL SYMBOL LIST AND RESOLVE
        if (isNonterminal(nextSymbol)) % just match non terminals
            % sim = getNodeSimilarity(strsplit(nextSymbol,',')',strsplit(lhs,',')');
            %if sim > nodeSimThreshold && ~isequal(lhsT,'gamma')
            newTimeSpan = [min(se(se(:,1)~=-1,1)) max(se(:,2))];
            idx = find(ismember(rhsT(dotPosT:end),lhs));
            if ~isempty(idx)
                if idx == 1
                    if temporalRelationsComparison( chartSection(c,:), newTimeSpan ) %&& ~isempty(setdiff(IDs,IDsT)) % Check for id set similarity at the same time as
                        
                        %add to chart
                        newState = chartSection(c,:); newState{3} = dotPosT + 1;
                        if isequal(newState{4}{1}, 0)
                            newState{4} = combineIds(IDs);
                            newState{7} = newTimeSpan;
                        else
                            newState{4} = [newState{4}; combineIds(IDs)];
                            newState{7} = [newState{7}; newTimeSpan];
                        end
                        newState{8} = prob + probT;
                        newState{9} = [newState{9}; [chartNum,StateNum]];
                        
                        addToChart(newState,chartNum);
                        chart{chartNum-1}(c,5) = {[]}; % So all incompleted rules move forward
                    end
                else
                    newState = RecoveryMultiLabel(chartSection(c,:),idx+dotPosT-1,chartNum-2);
                    addedIdx = addToChart(newState,chartNum-1);
                    newAddedStateIdxs = [newAddedStateIdxs; addedIdx];
                end
            end
        end
    end
end

if ~isempty(newAddedStateIdxs)
    completer(state,chartNum,StateNum,newAddedStateIdxs);
end

chart{chartNum}(StateNum,5) = {1};%Completed state
end




function allIDs = combineIds(IDs)
%set of cells that all represent ids of some element of preceding rule
%function combines the cells and produces a single list in a cell to be put
%in a parent rule

allIDs = {cell2mat(cat(1,IDs))};

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








