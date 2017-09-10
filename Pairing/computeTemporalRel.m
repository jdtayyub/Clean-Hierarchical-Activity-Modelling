function rel = computeTemporalRel(is1,ie1,is2,ie2)

rel = '';

if is2-1 == ie1
	rel = 2; %'meets'

elseif is1-1 == ie2
	rel = 11;%'metby' inverse
  
elseif is1 == is2 && ie1 == ie2
		rel = 13;%'equal'

elseif is2 > ie1
		rel = 1;%'before'

elseif is1 > ie2
		rel = 12;%'after'

elseif ie1 >= is2 && ie1 < ie2 && is1 < is2
		rel =  3;%'overlaps'

elseif ie2 >= is1 && ie2 < ie1 && is2 < is1
		rel = 10;%'overlapped_by'
	
elseif is1 > is2 && ie1 < ie2
		rel =  5;%'during'
	
elseif is1 < is2 && ie1 > ie2
		rel =  8;%'contains'
	
elseif is1 == is2 && ie1 < ie2
		rel =  4;%'starts'
	
elseif is1 == is2 && ie1 > ie2
		rel =  9;%'started_by'
	
elseif ie1 == ie2 && is2 < is1
		rel =  6;%'finishes'
	
elseif ie1 == ie2 && is2 > is1
		rel =  7;%'finished_by'

end



end