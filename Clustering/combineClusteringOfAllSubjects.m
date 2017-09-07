function [ totClus ] = combineClusteringOfAllSubjects( saveIdx,splitIdx )
%COMBINECLUSTERINGOFALLSUBJECTS Summary of this function goes here
%   Detailed explanation goes here


totClus = zeros(sum(cell2mat(cellfun(@numel,saveIdx,'uni',0))),1);
prevMax = 0;
for p = 1 :size(saveIdx,1)
    totClus(splitIdx{p}) = saveIdx{p} + prevMax;
    prevMax = max(totClus);
end



end

