function [num_of_objects,len,max_len,objects,indx]= get_objects_number(list,filter)
len=size(list);
len=len(2);
templist={};

indx = strfind(list(1,:),filter);
indx = find(not(cellfun('isempty',indx)));
templist{1,1}= num2str(list{2,indx});
templist{2,1}= 1;
list_len=size(list);

for i=2:list_len(1)
   indx2 = strfind(templist(1,:),num2str(list{i,indx}));
   indx2 = find(not(cellfun('isempty',indx2)));
   if isempty(indx2) 
    templist{1,end+1}=num2str(list{i,indx})  ;
     templist{2,end}=1 ;
   else
    templist{2,indx2}=  templist{2,indx2} + 1;
   end
end

num_of_objects = size(templist(1,:));
num_of_objects=num_of_objects(2);
max_len=max(cell2mat(templist(2,:)));
objects=templist(1,:);
objects{2,1}=0;
len3=size(objects);
for j=1:len3(2)
    objects{2,j}=0;
end