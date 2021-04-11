function [List,max_dif,AVG,std1]=statistic_cal(List)
AVG=mean(mean(List));
%len=size(List);

x=List.';
std1=mean(std(x))
max_dif=max(max(List)-min(List))

temp_list={};
max_dif={};
max_dif=cell2mat(max_dif);
temp_list=cell2mat(temp_list);
%List{1,len(2)+1}='Mean std';
for j=1:length(List)
    temp_list{j}=std(List(j,:));
    max1=max(List(j,:));
    min1=min(List(j,:));
    max_dif{end+1}=max1-min1;
end
std1=mean(cell2mat(temp_list));
max_dif=max(cell2mat(max_dif));

    