function [ noPostfixLabel ] = removePostfixFromLabel( label )
%REMOVEPOSTFIXFROMLABEL takes a label in and removes postfix of length and
%returns the label back

%%%Exception words which cause problem and must be resolved in the original
%%% annotation files %%% HACK -> This is a hacky and temporary fix (IF any of these words have a post fix )
excepList = {' waits for drink';' waits for dessert';' Clear Table';...
             ' talks to camera';' pays (Waiter/ess)'};
if any(ismember(excepList,{label}))
    noPostfixLabel = label;
    return; 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l = textscan(label,'%s','delimiter','~','multipleDelimsAsOne',1);
noPostfixLabel = l{1}{1};

end

