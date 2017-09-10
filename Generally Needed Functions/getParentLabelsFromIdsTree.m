function [parList labels] = getParentLabelsFromIdsTree(I)
%returns the parent node list and corresponding node labels from an tree
%return all non-zero parent nodes with their corresponding labels.
    lisCells = I{1}(:,1);
    parList = cell2mat(lisCells);
    parList = parList(parList~=0);
    labels = I{2}(parList);
    
end
