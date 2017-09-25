function [found,idx] = ruleExistsAndIdsCommon(rule,chartSection)
idx = 0;
if isempty(chartSection)
  found = 0;
else
  r = rule(:,[1 2 3 4 5 6 7 8]);% remove the elements to be matched seperately
  cS = chartSection(:,[1 2 3 4 5 6 7 8]);
  %check if rule exists in the specific section of the chart
  found = 0;
  for c = 1 : size(cS,1)
    if isequal(cS(c,:),r)
      %if isempty(setdiff(chartSection{c,4},rule{4}))
      found = 1;
      idx = c;
      %end
    end
  end
end

end