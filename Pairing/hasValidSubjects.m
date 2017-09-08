function [ flag ] = hasValidSubjects( labelChild , labelPar )
%HASVALIDSUBJECTS Checks whether the two labels belong to the same subject
%or to a valid combination of subejcts .
% cutomer with cutomer, waiteress with waiteress, parent in both
subChi = subjectOf(labelChild);
subPar = subjectOf(labelPar);

if subChi==-1 || subPar == -1
    flag = 0;
    warning('One subject and one non subject passed in, investigate!')
end

if isequal(subPar,'Both')
    flag = 1;
elseif isequal(subChi,subPar)
    flag = 1;
else
    flag = 0;
end

end

