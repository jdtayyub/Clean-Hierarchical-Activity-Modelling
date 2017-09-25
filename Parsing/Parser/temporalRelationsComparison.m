function [ sim ] = temporalRelationsComparison( rule, pFrames )
%Takes in a rule where the symbool after the
%dot position is predicted, also takes in the start and end times of the
%predicted symbol. The function then checks for whether all preceding
%symbols from the dot position temporally comply with the newly predicted
%symbol
%rule : grammar ruke
%pFrames : predicted start and end frames of the predicted symbol

Threshold = 0.6; %%%%%%%Adjust according to the experiments

dotPos = rule{3};
if dotPos>1
  preDotFs = rule{7};
  delErrorIdxs = find(preDotFs(:,1) == -1);
  NonErrorIdxs = find(preDotFs(:,1) ~= -1);
  if ~isempty(NonErrorIdxs)
      preDotFrames = preDotFs(NonErrorIdxs,:); % removing the deletion errors
      newTemporalList = [];
      for i = 1 : size(preDotFrames,1)
        newTemporalList(i) = computeTemporalRel(preDotFrames(i,1),preDotFrames(i,2),pFrames(1),pFrames(2));
      end
      %Compare temporal node list
      mat = nchoosek([1:dotPos],2);
      if ~isempty(delErrorIdxs)
        %preDotTemporalRelationIndexes = find(mat(:,2)==dotPos & mat(:,1)~=delErrorIdxs);
        preDotTemporalRelationIndexes = find(mat(:,2)==dotPos & ~ismember(mat(:,1),delErrorIdxs));
      else
        preDotTemporalRelationIndexes = find(mat(:,2)==dotPos);
      end
      tempvec = str2num(cell2mat(rule(6)));
      ruleTemporalList = tempvec(preDotTemporalRelationIndexes);
      compRules = ruleTemporalList==newTemporalList;
      percentSimilar = sum(compRules)/size(compRules,2);

      if percentSimilar > Threshold
        sim = 1;
      else
        sim = 0;
      end
  else
      sim = 1;
  end
else
  sim = 1;
end

end