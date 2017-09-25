function rules = getRulesOfSymbol(sym)
    global grammar;
    rules = grammar(find(ismember(grammar(:,1),sym)),:);
end

