function idx = searchSymbolInList(list, symbol, terminalFlag)
%Terminal flag is 1 is detecting for terminals in the rule (if symbol is a termina), 2 for non terminal symbol detection
idx = []; %empty means not found
global param;
res = [];
if terminalFlag == 1
    for nS = 1 : size(list,2)
        if list{nS}(1) == ''''
            [sim] = getNodeSimilarity(strsplit(list{nS}(2:end-1),',')',strsplit(symbol,',')');
        else
            sim = 0;
        end
        res(nS,1) = sim;
    end
else
    for nS = 1 : size(list,2)
        if list{nS}(1) ~= ''''
            [~,sim] = getNodeSimilarity(strsplit(list{nS},',')',strsplit(symbol,',')');
        else
            sim = 0;
        end
        res(nS,1) = sim;
    end
end


findIdx = find(res>=param.SimThreshold);
[v i] = min(res(findIdx));
idx = findIdx(i);
end