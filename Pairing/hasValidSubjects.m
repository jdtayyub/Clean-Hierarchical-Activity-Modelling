function [ flag ] = hasValidSubjects( labelChild , labelPar )
%HASVALIDSUBJECTS Checks whether the two labels belong to the same subject
%or to a valid combination of subejcts .
% cutomer with cutomer, waiteress with waiteress, parent in both

if isequal(subjectOf(labelPar),'Both')
    flag = 1;
elseif isequal(subjectOf(labelChild),subjectOf(labelPar))
    flag = 1;
else
    flag = 0;
end

end

