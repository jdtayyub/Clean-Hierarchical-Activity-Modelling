function [ intersect,overlap ] = isOverlapping( interval1, interval2 )
%ISOVERLAPPING Gets two intervals [start and end frmaes] and returns the
%whether there is an overlap between then and the amount of overlap
% intersect is boolean and overlap is numeric

a = interval1(1);
b = interval1(2);
c = interval2(1);
d = interval2(2);

overlap = min(max(a,b), max(c,d)) - max(min(c,d), min(a,b));
intersect = (overlap>0);

end

