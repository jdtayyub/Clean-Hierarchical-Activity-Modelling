function noPrefixLabel = removePostfixFromLabel(label)
% Removing a prefix of subject from label

if label{1}(1) == '('
   noPrefixLabel = {label{1}(find(label{1}==')')+2 : end)};
else
   noPrefixLabel = label;
end
end