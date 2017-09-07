function [ mat ] = normaliseMatrix( mat, min, diff )
%NORMALISATIONMATRIX takes in a matrix in squareform and normalises it in
%using the min and diff and returns the matrix with values between 0 and 1
    
    mat = (mat-min) / diff;
    mat(find(tril(ones(size(mat))))) = 0;
    mat = triu(mat)'+mat;

end

