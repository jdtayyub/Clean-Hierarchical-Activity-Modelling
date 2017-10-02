function [ outList ] = removePrefixFromLabelList( labelList )
%PROCESSPOSTFIXFORANYVIDEO Takes in a lsit of labels and removes the prefix
%per each label
outList = {};
for l = 1 : length(labelList)
    newLabel = removePrefixFromLabel(labelList(l));
    outList = [outList;newLabel];
end

end

