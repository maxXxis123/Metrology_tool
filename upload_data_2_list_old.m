function [List]=upload_data_2_list(path,file_list,mode)
   %comp_name=getenv('computername')
   
  % path=['c:\Falcon\Data\Machine\' comp_name '\Cameras\HighMag\calib.ini']
  if(mode)

   sort_struct=[11,3,4,12];
   muliplex=2;
   metro_string='Diameter'
   zone=11;
   id=12;
   len=10;
  else
    if (strfind(file_list{1},'BumpsSampling'))

        mode2=0;
        sort_struct=[1,3,4,2];
        zone=1;
        id=2;
        indx_waferX=7;
        index_waferY=8;
        len=10;
    else
        mode2=1;
       sort_struct=[8,3,4,9]; 
       zone=8;
       id=9;
       len=9;
    end
     muliplex=1;
     metro_string='Height'
    
  end

   len1=size(file_list);
   List={};
   indx=10;
   for i=1:len1(2)
       
  if isempty(List)
      raw=csvimport([path file_list{i}]);
      List(1,:)=raw(1,1:len);
      temp=sortrows(raw(2:end,:),sort_struct);
      len2=size(temp);
      for j=1:len2(1)
        List(end+1,:)=temp(j,1:len);
      end
       if(mode)|(mode2)
          tmp=List(2:end,7);
          List(:,7)=List(:,zone);
          List(:,8)=List(:,id);
          List(2:end,9)=tmp;
          List{1,9}=[metro_string '1'];
          measure=7;
       else
          tmp=List(:,7);
          List(:,7)=List(:,zone);
          List(:,1)=tmp;
          
          tmp=List(:,8);
          List(:,8)=List(:,id);
          List(:,2)=tmp; 
          List(:,9)=List(:,10)
          measure=10;
       end
       List{1,9}=[metro_string '1'];
       
              len2=size(List(:,9));
                for j=2:len2(1)
                    List{j,9}=List{j,9}*muliplex;
                end
             
          else
            raw=csvimport([path file_list{i}]);
            raw=sortrows(raw(2:end,:),sort_struct);
            List{1,end+1}=''
            List(2:end,indx)=raw(:,measure);
            List{1,indx}=[metro_string num2str(indx-8)];
            len2=size(List(:,9));
                for j=2:len2(1)
                    List{j,indx}=List{j,indx}*muliplex;
                end
            indx=indx+1;
          end
   end
    
   
