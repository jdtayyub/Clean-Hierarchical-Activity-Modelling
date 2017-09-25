function grammar = pipedGrammarVar2SplitGrammarVar(gram)
%takes in gram which is a cell array of imported data from a piped grammar
%text file where each cell consists of one rule pulled as a string from the
%grammar file.
grammar = {};
for i = 1:size(gram,1)
    row =  strsplit(gram{i},'|');
    childs  =  strsplit(row{2},';');
    rule = [row(1) {childs} row(3) row(4)];
    grammar = [grammar; rule];
end

end