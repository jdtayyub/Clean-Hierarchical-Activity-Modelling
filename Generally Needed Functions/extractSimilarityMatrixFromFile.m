function [ eMat ] = extractSimilarityMatrixFromFile( labels )
%EXTRACTSIMILARITYMATRIXFROMFILEtakes labels and find the similarity
%between them and extracts them from the previously calculated similarity
%matrix.


%%%%%%%%%%%%%%%%%

%LOAD VARIABLES HERE -> ssMatNewest.mat and lMap, CALL LoadVars function
% in case of errors

global SemSimMat;
global alllabels;
global lMap;
%%%%%%%%%%%%%%%%%

if isempty(lMap)
    error('Semantic Similarity matrix not loaded. Run LoadVars before.');
    return;
end


idxs = [];
for i = 1 : size(labels,1)
    
    val = lMap(removePostfixFromLabel(labels{i}));%removes the -long/ -short etc to get actual accurate semantic meaning regalrdless of the qualitative length postfix
    if isempty(val) % try again with removing leading spaces if any
        lab = labels{i}(min(find(labels{i} ~= ' ')):end);%remove leading spaces
        val = lMap(lab);       
    end
    idxs(i) = val;
    
end

eMat = SemSimMat(idxs,idxs);%extracted matrix;

end

