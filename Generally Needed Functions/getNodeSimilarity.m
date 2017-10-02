function [ similarity ] = getNodeSimilarity( grp1,grp2 )
%GETNODESIMILARITY Takes in two lists of labels grp1 and grp2
%representing the two clustered groups of intervals WITHOUT person 
%or interval pre/postfixes. Then using munkres or
%other matrices , returns the similairty score between the two lists
%between 0-1
%   Detailed explanation goes here

global param;


%%%TESTING %%%
%param.similarityMeasureMetric = 'hungarian';
%%%%%%%%%%%%%%

similarity=-1; %% default value

%pass the longer list first to enable munkres penalising to work, make grp1
%always the longer one
groups = {grp1;grp2};
[~ ,i] = max([size(grp1,1),size(grp2,1)]);
grp1 = groups{i};
grp2 = groups{setdiff(1:size(groups,1),i)};

%compute the cost matrix between the groups
combInner = combvec(1:size(grp1,1),1:size(grp2,1))'; % all combs 

simM = zeros(size(grp1,1),size(grp2,1)); % the matrix of similaritie , 1 - simM = cost mat for munkres
for cI = 1 : size(combInner,1)
    lb1 = grp1(combInner(cI,1));
    lb2 = grp2(combInner(cI,2));
    if isequal(lb1,lb2)
        simM(combInner(cI,1), combInner(cI,2)) = 1; % if labels are equal similarity is 1
    else
         M = extractSimilarityMatrixFromFile([lb1;lb2]); % return a symmetric 2x2 matrix 
         simM(combInner(cI,1), combInner(cI,2)) = M(1,2); 
    end
end

switch(param.similarityMeasureMetric)
    case 'hungarian'
        costOfAssignment = computeMunkres(simM);
        similarity = 1 - costOfAssignment;
        
    case 'max'
        similarity = max(max(simM));
        
    case 'min'
        similarity = min(min(simM));
        
    case 'super'
        %%% NOT SURE WHAT THIS WAS FOR %%%
        
    otherwise
        error('Invalid parameter for similarityMeasureMetric selected choose from hungarian max min super etc.');
        
end

end


function finalCost = computeMunkres(simM)
    % score for assigned 
    costM = 1 - simM; % sim matrix to cost matrix M
    assignments = munkres(costM); 
    colidx = assignments(assignments~=0);
    rowidx = find(assignments~=0);
    numAssigned = nnz(assignments);
    numUnassigned = sum(assignments(:)==0);
    totalNumber = size(assignments,2); 
    costAssignment =  sum(diag(costM(rowidx,colidx))) / numAssigned;
    
    
    %add penalty for unassigned to the cost
    rowsUnassigned = find(assignments==0);
    penal = mean(max(costM(rowsUnassigned,:),[],2));
    if isnan(penal)
        penal = 0; 
    end
    finalCost = ((numAssigned/totalNumber) * costAssignment) + ((numUnassigned/totalNumber) * penal);
end

%IN case where two grps are exactly the same but their average is not
%yielding 1
% if size(grp1,1) == size(grp2,1) && sum(innerNums(1:size(grp1,1)+1:size(innerNums,1))) == size(grp1,1)
%     outSuper = 1;
% end




