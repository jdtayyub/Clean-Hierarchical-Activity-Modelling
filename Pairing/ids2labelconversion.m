function [ nG ] = ids2labelconversion( G )
%ids2labelconversion Set of hierarchy trees that need to be converted
%input tree structure G and out put is new tree structure nG with labels
%and nomore Ids

nG = {};
for g = 1 : size(G,1)
og = G(g,:); %old g
ng = {}; %new g
[par pLab] = getParentLabelsFromIdsTree(og);

chils = {};
for c = 1 : size(og{1},1)
    chils = [chils; {[{og{2}(og{1}{c,2}{1})'} og{1}{c,2}(2:3)]}];
end
pLab = [{{'root'}}; pLab];
ng = [pLab chils];
nG = [nG; {ng}];
end


end

