function [ maxVal, labs, idxs ] = generateRandomListOfLabelsForGT( lablist,n )
%GENERATERANDOMLISTOFLABELSFORGT generates a random list of n labels from
%the lablist 

global SemSimMat;
maxVal = 0;
for i =1  : 1200

idxs = randperm(length(lablist),n);
labs = lablist(idxs);
mat = extractSimilarityMatrixFromFile(labs);
val = mean(mean(mat(logical(tril(ones(length(mat)),-1)))));

if val>maxVal
    maxVal = val;
end

end

labs = lablist(idxs);
maxVal
end

