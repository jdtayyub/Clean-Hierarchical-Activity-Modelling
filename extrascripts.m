function val = isSameSubject(lb1,lb2) % zero means not a subject dependent label, 1 means same subject and 2 means diff subject
val = 0;
%extract subject part
if lb1{1}(1)=='(' && lb2{1}(1)=='('
    lb1Sub = lb1{1}(find(lb1{1}=='(') : find(lb1{1}==')'));
    lb2Sub = lb2{1}(find(lb2{1}=='(') : find(lb2{1}==')'));
    if isequal(lb1Sub,lb2Sub)
        val = 1;
    else
        val = 2;
    end
end


end
