function fullDatNew = pruneShortIntervals(fullDat)
% Takes in fullDat clustered intervals and returns all the intervals that
% are longer than the threshold

global param;

frames = cell2mat(fullDat(:,2:3));
keepIdxs = find(~(abs(frames(:,1) - frames(:,2)) < param.frameThreshold));
fullDat = fullDat(keepIdxs,:);
frames = frames(keepIdxs,:);
%SoRT by end times
[~, i] = sort(frames(:,2)); 
fullDatNew = fullDat(i,:); 


end