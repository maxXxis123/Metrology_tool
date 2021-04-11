function [Final_list]=jambo_upload_data_2_list(path,file_list,handles)
    msg='Starting to upload files';
   f = waitbar(0.1,msg) ;
   file_list=file_list.';
   file_list=sortrows(file_list,1);
   len1=size(file_list);
   List={};
   List2={};
   indx=10;
   multi_file_flag=0;
   combo_list={};
   col_indx=1;
   row_indx=1;
  
   comp_f=file_list{1,1};
   for i=1:len1(1)
       tmp=strsplit(comp_f,'.csv');
       tmp_str=tmp{1};
       tmp_str=tmp_str(1:end-1);
        if  isempty(combo_list)
            combo_list{row_indx,col_indx}=file_list{i,1};
        elseif strfind(file_list{i,1},tmp_str)
            row_indx=row_indx+1;
            combo_list{row_indx,col_indx}=file_list{i,1} ;   
        else
            row_indx=1;
            col_indx=col_indx+1;
            combo_list{row_indx,col_indx}=file_list{i,1};    
            comp_f=file_list{i,1}; 
        end
   end  
    combo_len=size(combo_list);
    for i=1:combo_len(2)  
        List={};
        msg=['Please wait, uploading ' num2str(i) '/' num2str(combo_len(2)) ' files'];
        waitbar(i/combo_len(2),f,msg);
       for j=1:combo_len(1)
          if isempty(List)
            raw=fast_csv([path combo_list{j,i}],handles);
            List(1,:)=raw(1,1:handles.len);
            temp=sortrows(raw(2:end,:),handles.measure);
                 
            List=vertcat(List,raw(2:end,:));
      
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
          raw=fast_csv([path combo_list{j,i}]);
          tmp=raw(2:end,7);
            raw(:,7)=raw(:,handles.zone);
            raw(:,8)=raw(:,handles.id);
            raw(2:end,9)=tmp;
          List=vertcat(List,raw(2:end,:));
          %List=vertcat(List(1,:),sortrows(List(2:end,:),handles.sort_struct));
          end
       end 
       List=vertcat(List(1,:),sortrows(List(2:end,:),handles.sort_struct));

       if i==1
           Final_list=List(:,1:9);
           %D_list=zeros(length(tmp),0);
           
       else

           List{1,9}=['height' num2str(i)];
           Final_list=horzcat(Final_list,List(1:end,9)); %% sorting
       
       end
       %D_list(:,end+1)=str2double(tmp);
    end
    %xlswrite([path 'rawdata' '.xlsx'],Final_list)
    close(f);

    
   
