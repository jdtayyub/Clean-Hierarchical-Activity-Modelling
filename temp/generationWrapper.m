function [ output_args ] = generationWrapper( lablist )
%GENERATIONWRAPPER Summary of this function goes here
%   Detailed explanation goes here
x = [];
for i = 1 : 100
    i
    x = [x;generateRandomListOfLabelsForGT( lablist,i )];
end

end

