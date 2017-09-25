function acc = EvaluateChartForCPT(chart)
% evaluates a chart using inlinprog to get the accuracy of parsing


numOfWords = [1:size(chart)-1];
lastC = chart{end};

dat = {};
for i = 1 :size(lastC,1)
    entry = lastC(i,:);%tree highest point
    listDel = cell2mat(entry{4}) == -1;
    listPre = cell2mat(entry{4}) ~= -1;
    numOfDelError = sum(listDel);
    totalNum = size(cell2mat(entry{4}),1);
    list2 = cell2mat(entry{4});
    idxsCov = unique(list2(listPre));
    dat = [dat;[numOfDelError/totalNum {idxsCov} entry{8}]];
end

termIdxs = dat(:,2);
[A] = uniquecell(termIdxs);
newDat = {};
for i = 1 :size(A,1)
    ids = find(cellfun(@(x) isequal(x , A{i}),termIdxs));
    if A{i} == 0
       dat(ids,:) = {0}; 
    else
        covRatios = dat(ids,1);
        [v] =  max(cell2mat(covRatios));
        a = find(cell2mat(covRatios) == v);
        newids = ids(a);
        probs = dat(ids(a),3);
        [v i] = max(cell2mat(probs));
        newDat = [newDat;[newids(i) dat(newids(i),2)]];
    end
end

mat = zeros(size(newDat,1),max(numOfWords));

for i =1: size(newDat,1)
    mat(newDat{i,1},newDat{i,2}) = 1;
    
end

A=mat; 
options = optimoptions('intlinprog','Display','off');
 optAssignment = intlinprog(-1*(sum(A,2)-1)',...
                            1:size(A,1) , A', ones(size(A,2),1),[],[],...
                            zeros(size(A,1),1),...
                            ones(size(A,1),1),options);
x = dat(find(optAssignment),:);
acc = sum(cellfun(@numel, x(:,2)))/max(numOfWords);

end

