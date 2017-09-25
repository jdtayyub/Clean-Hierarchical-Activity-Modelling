function [ cost ] = linkMatchingDistance( c1,c2 )
%LINKMATCHINGDISTANCE Input is 2 child clusters, and return a metric of
%distance . c1 and c2 is in form [{spatial nodes} [temporal nodes] [probability]]
%%% Setting variables to use

global param;


sC1 = c1{1}; % spatial node list cluster 1 each element may be multiple labels
tC1 = squareform(c1{2}); %temporal node matrix symmetric cluster 1
sC2 = c2{1}; % spatial node list cluster 2
tC2 = squareform(c2{2});%temporal node matrix symmetric cluster 2
S = [];
for i=1 : size(sC1,2)
    r1 = tC1(i,:);
    for j=1 : size(sC2,2)
        r2 = tC2(j,:);
        S(i,j) = matchRows(sC1,r1,sC2,r2,i,j);  % S is the cost
        if S(i,j) == 0
            S(i,j) = 1-simNode(sC1{i},sC2{j});
        end
    end
end

[path, cost] = munkres(S); % mostly zeros

sizesChildren = max(size(sC1,2),size(sC2,2));
penal = (sizesChildren - nnz(path))/sizesChildren;


cost = cost / nnz(path); %PENALISE FOR ALL THE ZEROS IN THE PATH SO THAT YOU CAN PENALISE FOR THINGS THAT ARE NOT MATCHED
cost = param.alpha*cost + (1-param.alpha) * penal ;
% Minimise THE overall cost
end


function cost = matchRows(s1,r1,s2,r2,x,y)
global param;
mat = [];

% To force going into the matching computation
if isempty(r1)
    r1 = 0;
end
if isempty(r2)
    r2 = 0;
end

for i = 1 : size(r1,2)
    for j = 1 : size(r2,2)
        if r1(i)==0 || r2(j)==0
            mat(i,j) = 0;%Do this so a nonlink is not matched ,or selfies a-a vs e-e
            %mat(i,j) = simNode(s1{x},s2{y}); % In order to promote a non-zero distance if only one element
        else
            mat(i,j) = ((param.beta)*simRel(r1(i),r2(j))) + ((1-param.beta)*((simNode(s1{i},s2{j}) + simNode(s1{x},s2{y}))/2));
        end
    end
end

cost = computeBestAssignmentScore(mat,s1,s2);
end

function COST = computeBestAssignmentScore(mat,l1,l2)
%Compute best assignment score and penalising for no assignments
global param;
r = find(sum(mat,2)==0);
l1(r) = [];

c = find(sum(mat,1)==0);
l2(c) = [];

sMat = mat;
sMat(r,:) = [];
sMat(:,c) = [];
sMat = 1- sMat ;
[path,cost] = munkres(sMat);
%cost = -1 * cost; % fix the cost to be able to add penalities
%compute penalty
penal = 0;
if cost~=0
    cost = (cost)/nnz(path);
    %compute penalty
    zIdx = find(path==0); %zeroIndex
    
    if ~isempty(zIdx)
        aIdx = find(path~=0); %assignmentIndex
        for z = 1 : size(zIdx,2)
            zLab = l1{zIdx(z)};
            for a = 1: size(aIdx,2)
                aLab = l1{aIdx(a)};
                sim(z,a) = simNode(zLab,aLab);
            end
        end
        maxVals = 1-(max(sim,[],2));
        penal = (sum(maxVals)/length(maxVals));
    end
end
%score = max(0,cost - (sum(maxVals)/length(maxVals)));
COST = param.gamma*cost + (1-param.gamma) * penal ;
end

%%%%%%%%%%% Util Functions %%%%%%%%%%%%%%%%

function val = simRel(tr1, tr2) % temporal relation1 and temporal relation2
totRels = 13;
%num1 = computeTemporalRel(tr1);
%num2 = computeTemporalRel(tr2);
num1 = tr1; num2 = tr2;
dif = abs(num1-num2);
if num1 == 13 || num2 == 13
    if num1 == 13
        if num2 >=4 && num2 <= 9
            dif = 1;
        elseif num2==3 || num2==10
            dif = 1;
        elseif num2==2 || num2==11
            dif = 2;
        else
            dif = 1;
        end
    else
        if num1 >=4 && num1 <= 9
            dif = 1;
        elseif num1==3 || num1==10
            dif = 1;
        elseif num1==2 || num1==11
            dif = 2;
        else
            dif = 1;
        end
    end
end
val = 1-(dif/(totRels-1));
end

function val = simNode(sn1,sn2) % matching spatial nodes lists temporally
[val] = getNodeSimilarity( removePrefixFromLabel(sn1), removePrefixFromLabel(sn2) );
  


end























