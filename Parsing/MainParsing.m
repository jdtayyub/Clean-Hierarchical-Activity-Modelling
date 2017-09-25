function [ OverallAccuracy ] = MainParsing( path2models )
%MAINPARSING Summary of this function goes here
%   Detailed explanation goes here


startActivity = 1; % ste which activity to start parsing with 



load(path2models);
OverallAccuracy = [];
%CAD working ACTs = []1
for act =startActivity : size(Models,1) % go through each activity 
    disp(['Activty: ' num2str(act) '/' num2str(size(Models,1))]);
    FoldAccuracy = [];
    for mod =1 : size(Models,1) % go thhrough each fold [ model test ] set and perform the testing
        
        model = Models{act}(mod,1);
        testVids = Models{act}{mod,2};
        
        disp(['ModelFold: ' num2str(mod) '/' num2str(size(Models,1))]);
        % build the grammar from model
        pipedGpath = modelToGrammarTextFilePIPED(model,'Parsing/Grammars');
        pipedGpath = textscan(fopen(pipedGpath),'%s','delimiter','\n');
        G = pipedGrammarVar2SplitGrammarVar(pipedGpath{1});
        
        VideoAccuracy = [];
        for testVid = 1: size(testVids,1)
           
            disp(['Testvideo: ' num2str(testVid) '/' num2str(size(testVids,1))]);
            
            sent = getTerminalFromInput(testVids{testVid,2}, testVids{testVid,3}); % pass in IdsTree and fulldat
            try
                chart = ParserEarleyExtendedwithDeletionRecoverMultiLabel(G,'root',sent); 
                acc = EvaluateChartForCPT(chart);
            catch ME
                disp(ME);
                if isequal(ME.identifier,'MATLAB:lang:StackOverflow')
                    VideoAccuracy = 0;
                    break;
%                 else
%                     acc = 0;
                end
            end
            VideoAccuracy = [VideoAccuracy; acc];
        end
        
        FoldAccuracy = [FoldAccuracy; mean(VideoAccuracy)];
    end
    
    OverallAccuracy = [OverallAccuracy; mean(FoldAccuracy)];
end

end

