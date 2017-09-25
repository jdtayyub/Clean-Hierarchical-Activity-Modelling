function idx = addToChart(rules, chartEntry)
global chart;
chartSection = chart{chartEntry};
%check if rules exist
for r = 1 : size(rules,1)
    rule = rules(r,:);
    [found,idx] = ruleExistsAndIdsCommon(rule,chartSection); % rule exists and Ids are comon
    if found
        continue; % Do something different here %%%%%%%%%
    else
        chart{chartEntry}(end+1,:) = rule;
        idx = size(chart{chartEntry},1); % where the rule was added in chart
    end
end
end