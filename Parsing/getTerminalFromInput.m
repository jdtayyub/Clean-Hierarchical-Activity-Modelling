function [ sent ] = getTerminalFromInput( gidx , fullDat )
%GETTERMINALFROMINPUT gidx from generated mainhierarchical learning and
%erutnr the sentence with its start and end times

global param

%load([mainDir '/vid' num2str(TIDX) '.mat' ]);%loads fullDat variable which has labelgroups and s and e frames

frames = cell2mat(fullDat(:,2:3));
fullDat = fullDat(find(~(abs(frames(:,1) - frames(:,2)) < param.frameThreshold)),:);
frames = frames(find(~(abs(frames(:,1) - frames(:,2)) < param.frameThreshold)),:);
[v i] = sort(frames(:,2)); fullDat = fullDat(i,:); frames = cell2mat(fullDat(:,2:3));
labels = fullDat(:,1);


parIdx = cell2mat(gidx{1}(:,1));
allIdx = [1:size(fullDat,1)]';
childIdxs = setdiff(allIdx,parIdx);
if issorted(cell2mat(fullDat(childIdxs,3)))
    sentNodes = {cellfun(@(x) strjoin(x',','),fullDat(childIdxs,1),'uni',0)};
    sentIntervals = cell2mat(fullDat(childIdxs,2:3));
    sent = [sentNodes {[]} sentIntervals]; % missing temporals
else
    disp('NOT SORTED BY END TIMES');
end

end

% 
% chils = gidx{1}(:,2);
% mat = vertcat(chils{:,1});
% col = mat(:,1);
% childIdxs = horzcat(col{:});