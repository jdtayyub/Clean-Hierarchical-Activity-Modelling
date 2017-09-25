function [ output_args ] = VisualiseTree( tree,fname )
%VISUALISETREE Given tree in treeids format, will build the graphical
%representation using DOT.

x = transform_structure(tree);
var2DotHierRaw(x{1},x{2},x{3},'Temp',fname);


end

