function [ nMat ] = SimilarityMatrixProcessing( smat,method )
%SIMILARITYMATRIXPROCESSING Given a similarity matrix, this function
%performs processing on the matrix to for example incorporate the
%neighbouring distances.I.e. incorporate correlation with other points to
%generate a more appropriate matrix to then be used in hierarchical
%clustering or other analysis 
%
%METHOD: euclid :minus euclidean dis-similarity

switch method
    case 'euclid'

        nMat = zeros(length(smat));
        for i = 1 : length(smat) - 1
          for j = i+1 : length(smat) 

              sim = smat(i,j);

              otherIdxs = setdiff( 1:length(smat) , [i j] );
              otherVals = [smat(i,otherIdxs)' smat(j,otherIdxs)'];
              otherDissim = norm(otherVals(:,1)-otherVals(:,2));

              nMat(i,j) = sim - otherDissim; % maybe need to be controlled by lambda 


          end
        end

        %symmetrise
        nMat = nMat + nMat';    
        nMat(find(eye(length(nMat)))) = 1;
        % replace negative values with zeros since too dissimilar
        nMat(nMat<0) = 0;

end

end

