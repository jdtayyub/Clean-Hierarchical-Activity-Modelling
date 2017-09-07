function [ diff, minV ] = computeNormalisationParams( testVidNumber, path2ds,videoNames )
%COMPUTENORMALISATIONPARAMS go through all the reminaing videos except
%vidNumber video
%and get the minimum value of frame difference and the min - max of frame
%difference and return those values for normalisation of distances to cluster

folders = dir(path2ds);
[~,idx]=sort_nat({folders.name});
folders=folders(idx);

dat = []; %aggregated frame data
global param;

for f = 3 : size(folders,1)
    load([path2ds '/'  folders(f).name]); % load fullAnnots {label} {start frame} {end frame}
    vidFileName = folders(f).name(1:end-4);
    vidNumber = str2num(vidFileName(4:end)); 
    
    if vidNumber == testVidNumber || ~isequal(videoNames(vidNumber) , videoNames(testVidNumber)) 
        continue;
    else
       dat = [dat; cell2mat(fullAnnots(:,2:3))];
    end
    
  
    
end

  distMat = squareform(pdist(dat,param.distOpt));
  maxV = max(distMat(find(~tril(ones(size(distMat))))));
  minV = min(distMat(find(~tril(ones(size(distMat))))));
  diff = maxV-minV;

end

