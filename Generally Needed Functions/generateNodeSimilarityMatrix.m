function [ fmat, nodes ] = generateNodeSimilarityMatrix( nodes )
%GENERATENODESIMILARITYMATRIX Given a list of nodes, generate a node
%similarity matrix and return the matrix along with the list

mat = zeros(length(nodes),length(nodes));
mat(logical(eye(length(mat)))) = 1;

for i = 1 :size(nodes,1)
    for j = i+1 :size(nodes,1)-1
        i
        j
        n_i = removePrefixFromLabelList(nodes{i});
        n_j = removePrefixFromLabelList(nodes{j});
        mat(i,j) = getNodeSimilarity(n_i,n_j);
    end
end
    
%symmetrise
fmat = mat + mat';    
fmat(find(eye(length(fmat)))) = diag(mat);

end

