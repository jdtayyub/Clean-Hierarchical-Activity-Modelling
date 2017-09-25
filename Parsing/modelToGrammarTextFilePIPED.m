function [ grammarPath ] = modelToGrammarTextFilePIPED( M,path,topClassPre )
%MODELTOGRAMMARTEXTFILE Takes in models and returnt the path where piped version of the
%grammar generated in a text file is saved
%topClass = {'breakfast','lunch','working'};
for m = 1 : size(M,1)
    model = M{m};
   
    grammarPath = [path '/grammarPIPED.txt'];
  
    fid = fopen(grammarPath,'w');
        
    
    for r = 1 : size(model,1)
        % print root nodes
        rule = model(r,:);
        lhs = [ strjoin(rule{1}',',')];
        children = model{r,2};
        problist = getProbabilityList(children(:,3));
        for c = 1 : size(children,1)
            childRule = children(c,:);
            teList = childRule{2};
            teStr = strjoin(arrayfun(@(y) [num2str(y)],teList,'uni',0),',');
            spNodes = childRule{1};
            spStr = [];
            for s = 1 : size(spNodes,2)
                if isTerminal(spNodes{s},model)
                    
                    val = ['''' strjoin(spNodes{s}',',') ''''];
                else
                    val = strjoin(spNodes{s}',',');
                end
                if s == size(spNodes,2)
                    spStr = [spStr val ];
                else
                    spStr = [spStr val ';'];
                end
            end
            fprintf(fid,'%s|%s|%s |%s\n',lhs,spStr,teStr,num2str(problist(c)));
            
        end
    end
end

end




function boolVal = isTerminal(elem,model)
% checks if node elem is in the parent list of M, if yes, then that is
% a parent and not a terminal
pars = model(:,1);
boolVal = isempty(find(cellfun(@(x) isequal(x,elem),pars)));

end

function problist = getProbabilityList(pL)

pL(cellfun(@isempty, pL)) = {1};
problist = cell2mat(pL)/sum(cell2mat(pL));

end