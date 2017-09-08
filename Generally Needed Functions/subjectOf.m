function [ res ] = subjectOf( lb )
%SUBJECTOF pull the subject prefix and returns that

if lb{1}(1)~='(' 
    res = -1; %means no subject in label
else
    res = lb{1}(find(lb{1}=='(') : find(lb{1}==')'));
end
end

