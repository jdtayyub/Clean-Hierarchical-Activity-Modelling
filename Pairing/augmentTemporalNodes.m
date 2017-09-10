function [ struct ] = augmentTemporalNodes(  h, frames, labels )
%AUGMENTTEMPORALNODES Takes in hierarchy h , frames and labels and augments
% temporal nodes for each parent's children. Returns a built structure in
% the form [spatial]
%   Detailed explanation goes here

%Spatial
par = unique(h(:,1));
chil = {};
for i = 1 :size(par,1)
    chil{i,1} = h(h(:,1) == par(i),2)';
end

%Temporal Info
temp = {};
for c = 1 : size(chil,1)
    child = chil{c};
    if size(child,2) == 1
        temp(c,1) = {[]};
    else
        pairs = nchoosek(child,2);
        tNodeList = [];
        for p = 1 : size(pairs,1)
            t = computeTemporalRel(frames(pairs(p,1),1),frames(pairs(p,1),2),frames(pairs(p,2),1),frames(pairs(p,2),2));
            tNodeList = [tNodeList t];
        end
        temp(c,1) = {tNodeList};
    end
end
%   %   %   %
%build structure
struct = {};
for i = 1 : size(chil,1)
    struct(i,1) = {[chil(i) temp(i) cell(1)]}; % added children and temporal nodes and empty cell to hold probability during abstraction
end

struct = [{[num2cell(par) struct]} {labels}];

end



