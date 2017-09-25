function g_old_ = transform_structure( g_new )
g_old=cell(1,5);
%H = g{1}; tL = g{2}; labels = g{3}; clus = g{4}; clusIds = g{5};


g_old{3}=g_new{2};



Parents=g_new{1};

for i=1:length(Parents)
    parent_id=Parents{i,1};
    parent=Parents{i,2};
    children=parent{1};  %cell array
    relations=parent(2);   %cell array
    
    
    idx= 1;
    for j=1:length(children)
        g_old{1}{length(g_old{1})+1}=[parent_id,children(j)];
        
        for h=j+1:length(children)
            g_old{2}{length(g_old{2})+1}=[children(j),children(h),relations{:}(:,idx)];
            idx=idx+1;
        end
    end
    
end
    
    
    
    
arr=zeros(length(g_old{1}),2);
for j=1:length(g_old{1})
    arr(j,:)=g_old{1}{j};
end

g_old_{1}=arr;



arr2=zeros(length(g_old{2}),3);
for j=1:length(g_old{2})
    arr2(j,:)=g_old{2}{j};
end

g_old_{2}=arr2;





arr3=cell(length(g_old{3}),1);
for j=1:length(g_old{3})
    str=g_old{3}{j}{1};
    for h=2:length(g_old{3}{j})
        str=strcat(str,'\n',g_old{3}{j}{h});
    end
    arr3{j}=str;
end


g_old_{3}=arr3;

    
end











