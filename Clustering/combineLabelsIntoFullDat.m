function [ fullDat ] = combineLabelsIntoFullDat( clusIdxs, l,m ) % m mat of frames, l labels
%COMBINELABELSINTOCLUSTERGROUPS takes in clustering cidxs and produces a
%structure with grouped labels per cluster with averaged frame times into a
%variable called fullDat -> THIS is what will be used for pairing next
fullDat = {};
numOfClus = max(clusIdxs);
combinedLabels = {};
avgframes = [];
for i = 1 : numOfClus
    avgframes = [avgframes; round(mean(m(clusIdxs==i,:),1))];% averaging the intervals, COULD be some other way of combining intervals.
    combinedLabels = [combinedLabels;{l(clusIdxs==i)}];
end
dat = [combinedLabels num2cell(avgframes)];
fullDat = [fullDat;dat];


end