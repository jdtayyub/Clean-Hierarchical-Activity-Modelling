function [ output_args ] = isTriangleInequal( mat )
%ISTRIANGLEINEQUAL A wrapper function to take in a symmetric distance matrix and call an R
%function to determine if the matrix follows the triangle inequality i.e.
%is transitive. 

save('Generally Needed Functions\R Functions Wrapper\testMatrix.mat','mat');

if isunix
    path = '~/Documents/...';
elseif ispc
    path = [pwd '/Generally Needed Functions/R Functions Wrapper/testMatrix.m']; % get  MATRIX PATH with variable 'mat' inside
end

[x y] = system(['Rscript ' pwd '/Generally Needed Functions/R Functions Wrapper/istrilScript.R' path]);
if x==1
   disp('error');
   disp(y);
end

end

