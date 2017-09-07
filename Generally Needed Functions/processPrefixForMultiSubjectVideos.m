function [ splitIdx,splitLab,splitFrames ] = processPrefixForMultiSubjectVideos( fullAnnots )
%PROCESSPREFIXFORMULTISUBJECTVIDEOS Process the labels for a video with
%subject prefixes in brackets and return important usefull sub variables
%for example individual indexes of subject in format [waitress,customer,both]

% splitIdx retuns [{waitress indexes, customer indexes, both indexes} in the labels list]
% splitLabel returns [{waitress label, customer labels, both labels} without the prefixes]
% splitFrames return the frames split similar to previous ones ... 

    labels = fullAnnots(:,1);
    mat = fullAnnots(:,2:3);
    
    list = cellfun(@(x) x(1:find(x==')')),labels,'uni',0);
    
    wIdx = find(ismember(list,'(Waiter/ess)'));
    cIdx = find(ismember(list,'(Customer)'));
    bIdx = find(ismember(list,'(Both)'));
    
    splitIdx = [{wIdx};{cIdx};{bIdx}];
    
    wMat = mat(wIdx,:); cMat = mat(cIdx,:); bMat = mat(bIdx,:);
    
    splitFrames = [{cell2mat(wMat)};{cell2mat(cMat)};{cell2mat(bMat)}];
    
    wL = cellfun(@(x) x(find(x==')')+2:end),labels(wIdx),'uni',0);
    cL = cellfun(@(x) x(find(x==')')+2:end),labels(cIdx),'uni',0);
    bL = cellfun(@(x) x(find(x==')')+2:end),labels(bIdx),'uni',0);
    
    splitLab = [{wL};{cL};{bL}];


end

