function [ cost ] = costFunction( int1 , int2 )
%COSTFUNCTION Costfunction as described in aaai18 paper
% input is int1 and int2 (int)ervals with start and end of each cost computed of
% assigning int1 as a child of int2

l2 = int2(2) - int2(1);
l1 = int1(2) - int1(1);
o12 = max([0 min([int1(2) int2(2)]) - max([int1(1) int2(1)])]);

cost = (l2/o12) / (1-(l1/l2));

end

