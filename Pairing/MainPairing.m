function [ output_args ] = MainPairing( path2ClusteredIntervals )
%MAINPAIRING This function is the main function to build hierarchies based
%on optimum pairs between intervals. pass in path2clus where .mat files sit
%per video with the variable fullDat which has format [{label group} {avg start frame} {avg end frame} for each video]

files = dir(path2ClusteredIntervals);%load matfiles of data
[~,idx]=sort_nat({files.name});
files=files(idx);
videoNames = GetVideoNames('Dataset/VideosNames');

for f = 3 : size(files,1) % loop through each clustered interval labelling 
    load([path2ClusteredIntervals '/' files(f).name]);%load fullDat
    
end

end

