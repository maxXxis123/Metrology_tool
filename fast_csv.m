function [new_list] = fast_csv(file,handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
         new_list=cell(1,handles.len);
         fp=fopen(file);
         x=fgetl(fp);
         tmp=strsplit(x,',');
         %formataux = '%s%s%s%s%s%s%s%s%s';
         C =textscan(fp, handles.formataux,'Headerlines', 1, 'Delimiter', ',', 'EmptyValue', NaN,'CollectOutput',1);
         new_list=vertcat(tmp,C{1,1});
end

