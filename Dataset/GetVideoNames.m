function [ names ] = GetVideoNames( path2VideosNames )
%GETVIDEONAMES Go through video names and path and extract the video names 

names = textscan(fopen(path2VideosNames),'%s');
names = names{1};
names = lower(cellfun(@(x) x(2),cellfun(@(x) strsplit(x,'_'),names,'uni',0)));
names(ismember(names,'bfast')) = {'breakfast'};

end

