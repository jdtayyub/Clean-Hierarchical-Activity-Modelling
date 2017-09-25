function [ SimMat ] = getListOfNodesSimilarity( pars )
%GETLISTOFNODESSIMILARITY takes in a list of nodes and returns a matrix of
%their similairites


SimMat = zeros(size(pars,1));
%compute similarity between parent nodes
pairs = nchoosek(1:size(pars,1),2);
for p =1 : size(pairs,1)
    i = pairs(p,1); j = pairs(p,2);
    if i == j
        continue
    else
        %SimMat(i,j) = getNodeSimilarityExact(pars{i},pars{j});
        if ~(isequal(pars{i},{'root'}) || isequal(pars{j},{'root'}))
            [SimMat(i,j)] = getNodeSimilarity(removePrefixFromLabel(pars{i}),removePrefixFromLabel(pars{j}));
        end
    end
end

end

