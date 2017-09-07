function [ output_args ] = ReadAnnotations2singleVars( path,destMatVar, destCSV )
%READANNOTATIONS2MATLABVARS read in crowd sourced annotations from path,
%merge all the worker's annotations per video and save the result in destMatVar
%as a matlab variable and in destCSV as csv variable


folders = dir(path);
[~,idx]=sort_nat({folders.name});
folders=folders(idx);

%Loop through all activity video folders
for folder = 3 : size(folders,1)
    
    %Loop through all annotations per video
    annFiles = dir([path '/' folders(folder).name]);
    
    fullAnnots = {};
    disp(folders(folder).name);
   
    for aF = 3 : size(annFiles,1)
        if (annFiles(aF).name(end)=='~') || (annFiles(aF).name(1)=='.')
            continue; % done to skip over temporary files
        end
        disp(annFiles(aF).name);
        annFilePath = [path '/' folders(folder).name '/' annFiles(aF).name];
        data = textscan(fopen(annFilePath),'%s %f %f','delimiter',',');
        annots = [data{1} num2cell(data{2}) num2cell(data{3})];
        annots = annots(2:end,:);
        
        fullAnnots = [fullAnnots;annots];
    end
 
    mat = cell2mat(fullAnnots(:,2:3));
    [~, i] = sort(mat(:,1));
        
    fullAnnots = fullAnnots(i,:);
    
    save([destMatVar '/' folders(folder).name],'fullAnnots');
    cell2csv([destCSV '/' folders(folder).name '.csv'], fullAnnots);
    
end

end



