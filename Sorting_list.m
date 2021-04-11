function [sorted_list,sorted_Matrix]= Sorting_list(list,objects,indx,first_m)
len=size(objects)
if (len(1) > 1)
    %sorted_Matrix=zeros(0,0,len)
    len=size(list);
    len1=size(objects);
    for i=1:len1(2)
        sorted_list(1,:,i)=list(1,:);
    end
    for j=2:len(1)
        indx2 = strfind(objects(1,:),num2str(list{j,indx}));
        indx2 = find(not(cellfun('isempty',indx2)));
        objects{2,indx2}=objects{2,indx2}+1;
        sorted_list(objects{2,indx2}+1,:,indx2)=list(j,:);

    end
    len=size(sorted_list);
    
    for i=1:len(3)
        sorted_Matrix(1,1,i)={str2double(sorted_list(2:end,9:end,i))};
    end
    sorted_Matrix(:,:,end)={str2double(list(2:end,9:end))};
else
    sorted_list(:,:,1)=list;
    sorted_Matrix(:,:,1)={str2double(sorted_list(2:end,first_m:end,1))};
end
