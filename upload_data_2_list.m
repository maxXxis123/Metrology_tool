function [List]=upload_data_2_list(path,file_list,handles)

   len1=size(file_list);
   List={};
   indx=10;
   msg='Starting to upload files';
   f = waitbar(0/len1(2),msg) 
   for i=1:len1(2)
       msg=['Please wait, uploading ' num2str(i) '/' num2str(len1(2)) ' files'];
      waitbar(i/len1(2),f,msg) 
      if isempty(List)
        raw=fast_csv([path file_list{i}]);
        List(1,:)=raw(1,1:handles.len);
        temp=sortrows(raw(2:end,:),handles.sort_struct);
        List=vertcat(List,temp);
      
        tmp=List(2:end,7);
        List(:,7)=List(:,handles.zone);
        List(:,8)=List(:,handles.id);
        List(2:end,9)=tmp;
        List{1,9}=[handles.mode '1'];
          
        if get(handles.CD_mode,'value')
          len2=size(List(:,9));
          for j=2:len2(1)
            List{j,9}=str2double(List{j,9})*handles.muliplex;
          end
        end
      else
          raw=fast_csv([path file_list{i}]);
          raw=sortrows(raw(2:end,:),handles.sort_struct);
          List{1,end+1}='';
          temp_col=[handles.mode num2str(indx-8)];
          temp_col=vertcat(temp_col,raw(:,handles.measure));
          List(1:end,indx)=temp_col;

          if get(handles.CD_mode,'value')
            len2=size(List(:,9));
            for j=2:len2(1)
                 List{j,9}=str2double(List{j,9})*handles.muliplex;
            end
         end
            indx=indx+1;
  end
   end
   close(f)
    
   
