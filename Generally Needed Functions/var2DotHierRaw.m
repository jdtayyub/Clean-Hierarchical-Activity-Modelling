function [ output_args ] = var2DotHierRaw( H, tL, labels,directory,fname, clusters)
%use to build raw graphs generated from mainhierlearning

%H is 1x2 array of all edges in graph. This will be used to build the
%hierarchy
%labels are the labels of the indeces in the H and tL
%tL is a list of all the edges and node that connect temporal infomration
%in graph ,  merged nodes is a list of nodes who are sharing their child
%and therefore no need to create an extra block for them.
% clusters is a variable with the node id and ids of nodes belonging to that cluster information attached
tLNew = [];

fid = fopen([directory '/' fname '.dot'],'wt');

%Writes Graph commands into temp.dot file - HEADER
fprintf(fid,'strict digraph G {compound=true;\n');
fprintf(fid,'0 [label="Activity"]; \n{rank=source;0} \n');

%find unique layers
uLev = unique(H(:,1));
%check uLev for pruned elements
[uLevMerge, mA]  = mergeStructure(uLev, H);

tNodeIds = [];
sNList = [];%spatial node conenction invisible list
cc = max(max(H));
%make subgraph for each of the groups
for sg = 1 : size(uLevMerge,1)
  %find all nodes on this level
  fprintf(fid,'subgraph cluster_%d{\n',sg);
  idxS = find(H(:,1)==uLevMerge(sg));
  nL = H(idxS,2);%children of sg 1 node
  
  %%% ADD TEMPORAL NODES
  tNodes = [];
  for sN = 1 : size(nL,1)
    idxT = find(tL(:,1)==nL(sN));
    tnL = tL(idxT,3);
    for nT = 1 : size(idxT,1)
      cc = cc+1;
      fprintf(fid,'%d[label="%s" shape="square" width=0.1]\n',cc,num2temp(tnL(nT)));
      tNodeIds = [tNodeIds; cc];
      tNodes = [tNodes; cc];
      tLNew = [tLNew ; tL(idxT(nT),:)];
    end
  end
  fprintf(fid,'{rank=same;%s}\n',num2str(tNodes'));
  
  %%% ADD SPATIAL NODES
  for n = 1 : size(nL,1)
    fprintf(fid,'%d[label="%s"]\n',nL(n),labels{nL(n)});
  end
  fprintf(fid,'{rank=same;%s}\n',num2str(nL'));
  %%%GHOST EDGES for keeping order of nodes nice%%%
  for ed = 1 : size(nL,1)-1
    fprintf(fid,'%d -> %d[style=invis];\n',nL(ed),nL(ed+1));
    sNList = [sNList; [nL(ed) nL(ed+1)]];
  end
  
  fprintf(fid,'}\n\n');
end


%%% ADD Edges for cluster conncetions  %%%%
for uL = 1 : size(uLev,1)
  idxs = find(H(:,1)==uLev(uL));
  tIdx = min(find(tLNew(:,1) == H(min(idxs),2)));
  
  %check which cluster head is it belonging to, might be multiple parents
  %sharing same child
  if ~isempty(mA)
    mergedIdx_mA = find(mA(:,2) == uLev(uL));
    if ~isempty(mergedIdx_mA)
      clusHead = find(uLevMerge == mA(mergedIdx_mA,1));
    else
      clusHead = find(uLevMerge==uLev(uL));
    end
  else
    clusHead = uL;
  end
  
  if isempty(tIdx) % Meaning there is only one subnode which means no temporal nodes to connect to so just connect to the spatial node H(idxs,2)
    fprintf(fid,'%d -> %d[lhead=cluster_%d];\n',uLev(uL),H(idxs,2),clusHead);
  else
    fprintf(fid,'%d -> %d[lhead=cluster_%d];\n',uLev(uL),tNodeIds(tIdx),clusHead);
  end
end


%%% ADD Temporal Edges %%%
fprintf(fid,'\n');
for tE = 1 : size(tLNew,1)
  fprintf(fid,'%d -> %d;\n',tLNew(tE,1),tNodeIds(tE));
  fprintf(fid,'%d -> %d;\n',tNodeIds(tE),tLNew(tE,2));
end


fprintf(fid,'}');
fclose(fid);


%Compile dot to pdf
system(['dot -Tpdf ' directory '/' fname '.dot -o ' directory '/' fname '.pdf']);

%Visualize

%system('pkill -3 acroread');

open([directory '/' fname '.pdf']);
%Compile dot to png
%system(['dot -Tpng graphs/' fname '.dot -o graphs/' fname '.png']);
end


function [ uLev, mA ] = mergeStructure( uLev,H ) %mA : merged assignments
%MERGESTRUCTURE Look for nodes that share children and return those

repNodes = [];
mA = [];
for i = 1 : length(uLev)-1
  for j = i+1 : length(uLev)
    chil_i = H((H(:,1) == uLev(i)),2);
    chil_j = H((H(:,1) == uLev(j)),2);
    if isequal(chil_i,chil_j)
      repNodes = [repNodes; uLev(j)];
      a = uLev(i); b = uLev(j); %check if b is assigned to a and if a is previously assigned to something else c then b should be assigned to c since a doesnt exist any more
      if ~isempty(mA)
        if ~isempty(find(mA(:,2)==a)) 
          mA = [mA;[mA(mA(:,2)==a) b]];
          mA = unique(mA,'rows');
        else
          mA = [mA;[a b] ];
        end
      else
        mA = [mA;[a b] ];
      end
      
    end
  end
end

for i = 1 : size(repNodes,1)
  uLev(find(uLev==repNodes(i))) = [];
end

end


