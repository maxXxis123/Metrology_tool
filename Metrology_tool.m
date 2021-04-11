function varargout = Metrology_tool(varargin)
% Metrology_tool MATLAB code for Metrology_tool.fig
%      Metrology_tool, by itself, creates a new Metrology_tool or raises the existing
%      singleton*.
%
%      H = Metrology_tool returns the handle to a new Metrology_tool or the handle to
%      the existing singleton*.
%
%      Metrology_tool('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Metrology_tool.M with the given input arguments.
%
%      Metrology_tool('Property','Value',...) creates a new Metrology_tool or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Metrology_tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Metrology_tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Metrology_tool

% Last Modified by GUIDE v2.5 16-Mar-2021 15:18:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Metrology_tool_OpeningFcn, ...
                   'gui_OutputFcn',  @Metrology_tool_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Metrology_tool is made visible.
function Metrology_tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Metrology_tool (see VARARGIN)

% Choose default command line output for Metrology_tool
[txt,num,handles.Mag]=xlsread([pwd '\Configuration.xlsx'],'2D')
set(handles.popupmenu2,'String',handles.Mag(2:end,1))
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Metrology_tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Metrology_tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)\
msg='Runing Calculation';



cla reset
f = waitbar(0.2,msg) ;
try
handles.Result_table= cell(4,3,1)
%handles.Result_table2= cell(6,3,6)
handles.Result_table{1,1}=['Total average ' handles.mode ' [um]']
handles.Result_table{2,1}='Site to site average 3 Sigma'
handles.Result_table{3,1}='P\T ratio (individual site by 10% range) [%]'
handles.Result_table{4,1}='Max difference per site'

%handles.Result_table{5,1}='P\T ratio (average by VLSI spec range) [%]'
%handles.Result_table{6,1}='Max difference per site'
handles.nominal=str2num(get(handles.edit1,'string'))

if isempty(handles.nominal)
    if get(handles.CLIP_mode,'Value')
        f = errordlg('Please enter nominal height')
    else
        f = errordlg('Please enter nominal perimeter')
    end
else
%    
%    [num_of_objects,len,max_len,handles.objects,indx]=get_objects_number(handles.raw,'Zone');
% 
%    handles.Result_table2= cell(max_len,len,num_of_objects) ;
%    handles.Result_table2=Sorting_list(handles.raw,handles.Result_table2,handles.objects,indx);
   msg='Calculation statistics';
   waitbar(0.4,f,msg) ;
   x=get(handles.popupmenu1,'value')
   
   temp_matrix=handles.result_Matrix(:,:,x);
   AVG=mean(mean(temp_matrix{1}));
   std1=mean(std(temp_matrix{1}.'));
   %std1=mean(vector);
   max_dif=max(max(max(temp_matrix{1}.'))-min(min(temp_matrix{1}.')));
   
   
   
   %[List,max_dif,AVG,std1]=statistic_cal(handles.result_Matrix(:,:,x));
   handles.Result_table{4,2}=max_dif;
  
   if get(handles.CD_mode,'value')
       handles.max_diff=handles.Mag{get(handles.popupmenu2,'value')+1,2}/2;
   else
       handles.max_diff=0.1*str2num(get(handles.edit1,'string'));
   end
       handles.Result_table{4,3}=['    < ' num2str(handles.max_diff)]
   
   msg='Writing results to table';
   waitbar(0.6,f,msg) ;
    if  max_dif < handles.max_diff
                       handles.Result_table{4,4} = '     PASS';
                else
                     handles.Result_table{4,4} = '     FAIL';
                end
  
                     %%----------Result table update---------------
                 %%----------AVG---------------
                handles.Result_table{1,2}=AVG;
                max_height=handles.nominal*1.05;
                min_height=handles.nominal*0.95;
                handles.Result_table{1,3}=['     ' num2str(max_height) ' - ' num2str(min_height)];
                if AVG > min_height & AVG <max_height
                    handles.Result_table{1,4} = '     PASS';
                else
                    handles.Result_table{1,4} = '     FAIL';
                end
                 %%----------std---------------
                 sigma_lim = 0.01*(str2num(get(handles.edit1,'string')));
                 handles.Result_table{2,3}=['       < ' num2str(sigma_lim)];
                 if  3*std1 < sigma_lim
                       handles.Result_table{2,4} = '     PASS';
                else
                     handles.Result_table{2,4} = '     FAIL';
                end
                handles.Result_table{2,2}=3*std1;

                
                 %%----------p/t ratio---------------
                pt_ratio = (600*std1)/(0.2*AVG);
                handles.Result_table{3,2}=pt_ratio;
                handles.Result_table{3,3}='       < 10';
                if pt_ratio < 10
                       handles.Result_table{3,4} = '     PASS';
                else
                     handles.Result_table{3,4} = '     FAIL';
                end

                axes(handles.axes1);
                title([handles.mode ' average per site']);
                ylabel(handles.mode);
                xlabel('repetability run');
                hold on
                a={'--*b','-.co','-m+',':gh',};
            
                list_len=size(temp_matrix{1});
                msg='Ploting charts';
                waitbar(0.8,f,msg) ;
                %axes(handles.axes1);
                plot((zeros(list_len(2),1) + max_height),'--r','LineWidth',3);
                plot((zeros(list_len(2),1) + min_height),'--r','LineWidth',3);
                plot((zeros(list_len(2),1)+AVG),'--k','LineWidth',3,'MarkerSize',10);
                if get(handles.CD_mode,'Value')
                    empty_len=12;
                else
                    empty_len=8;
                end

                
                legend({'Spec limits' 'Spec limits' 'Average height'},'Location','northeastoutside');
                if ~get(handles.Dont_show_plots,'Value')
                    temp=temp_matrix{1};
                    for j=1:list_len(1)
                        indx2=mod(j,4);
                        plot(temp(j,:),a{indx2+1});
                    end
                    
                    %plot(tmp,'-ok','LineWidth',3,'MarkerSize',10);
                    plot((zeros(list_len(2),1) + max_height),'--r','LineWidth',3);
                    plot((zeros(list_len(2),1) + min_height),'--r','LineWidth',3);
                    legend({'Spec limits' 'Spec limits' 'Average height' 'Others'},'Location','northeastoutside');
                end

                
                grid(handles.axes1, 'on')
                
                %set(handles.axes1, 'YLim',[0.995*min_height 1.005*max_height]);

                close(f);

        set(handles.uitable9,'Data',temp_matrix{1});
        set(handles.uitable9,'ColumnName',handles.raw(:,1));

        set(handles.uitable8,'Data',handles.Result_table(:,2:end));
        set(handles.uitable8,'RowName',handles.Result_table(:,1));
        set(handles.popupmenu1,'Visible','On');
        set(handles.popupmenu1,'string',handles.objects(1,:));
        
end
catch
    f = errordlg('Please check your setings')
end
    guidata(hObject, handles);

% --- Executes on button press in Select_files.
function Select_files_Callback(hObject, eventdata, handles)
% hObject    handle to Select_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.CD_mode,'value') | get(handles.CCS_mode,'value') | get(handles.CTS_mode,'value') |get(handles.CLIP_mode,'value')
 
        [file,path] = uigetfile('C:\Reports\Raw\*.csv','Multiselect', 'on')
        set(handles.listbox6,'String',file);

        [handles.raw]=jambo_upload_data_2_list(path,file,handles);

        [num_of_objects,len,max_len,handles.objects,indx]=get_objects_number(handles.raw,'Zone');
        handles.objects{1,end+1}='All';

else
    
    f = errordlg('Please Select measure mode')
    return;
end
    
 set(handles.popupmenu1,'Visible','On');
 set(handles.popupmenu1,'string',handles.objects(1,:));

 [handles.Result_table2,handles.result_Matrix]=Sorting_list(handles.raw,handles.objects,indx,handles.len);
 guidata(hObject, handles);
% --- Executes on button press in Save_result.
function Save_result_Callback(hObject, eventdata, handles)
% hObject    handle to Save_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Graph.
function Graph_Callback(hObject, eventdata, handles)
% hObject    handle to Graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable9,'Visible','Off')
set(handles.axes1,'Visible','On')
set(handles.Graph,'Position',[1.6 39.84615384615387 17.6 2.462])
set(handles.ResultT,'Position',[19 39.84615384615387 17.6 2])


% --- Executes on button press in ResultT.
function ResultT_Callback(hObject, eventdata, handles)
% hObject    handle to ResultT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable9,'Visible','On')
set(handles.axes1,'Visible','Off')
set(handles.Graph,'Position',[1.6 39.84615384615387 17.6 2])
set(handles.ResultT,'Position',[19 39.84615384615387 17.6 2.462])

 guidata(hObject, handles);

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end









% --- Executes on button press in save_r.
function save_r_Callback(hObject, eventdata, handles)
% hObject    handle to save_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path] = uiputfile('.csv')
tmp_str= strsplit(file,'.')
x=get(handles.popupmenu1,'value')
% writetable(cell2table(handles.Result_table(:,:)),[path tmp_str{1} '.csv'],'Sheet1',1)
% writetable(cell2table(handles.Result_table2(:,:,x)),[path tmp_str{1} '.csv'],'Sheet2',1)
xlswrite([path tmp_str{1} '.xlsx'],handles.Result_table(:,:),'Result') 
xlswrite([path tmp_str{1} '.xlsx'],handles.Result_table2(:,:,x),'Data')  
winopen([path tmp_str{1} '.xlsx'])


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in CD_mode.
function CD_mode_Callback(hObject, eventdata, handles)
% hObject    handle to CD_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CD_mode
if get(handles.CD_mode,'Value') 
    handles.mode='perimeter'
    set(handles.text4,'String','Nominal perimeter [um]')
    set(handles.CLIP_mode,'Value',0)
    set(handles.CTS_mode,'Value',0)
    set(handles.CCS_mode,'Value',0)
    handles.sort_struct=[7,3,4,8];
    handles.muliplex=2;
    handles.measure=7;
    handles.zone=11;
    handles.id=12;
    handles.len=12;
    handles.formataux = '%s%s%s%s%s%s%s%s%s%s%s%s';
else

    set(handles.text4,'String','Nominal height [um]')
    handles.mode='height'
end
set(handles.text4,'Visible','On')
set(handles.edit1,'Visible','On')
guidata(hObject, handles);

% --- Executes on button press in CLIP_mode.
function CLIP_mode_Callback(hObject, eventdata, handles)
% hObject    handle to CLIP_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.CLIP_mode,'Value')   
    handles.mode='height'
    handles.muliplex=1;
    set(handles.text4,'String','Nominal height [um]')
    set(handles.CD_mode,'Value',0)
    set(handles.CTS_mode,'Value',0)
    set(handles.CCS_mode,'Value',0)
    handles.measure=7;
    handles.len=9;
end

set(handles.text4,'Visible','On')
set(handles.edit1,'Visible','On')
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of CLIP_mode



% --- Executes on button press in CTS_mode.
function CTS_mode_Callback(hObject, eventdata, handles)
% hObject    handle to CTS_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.CTS_mode,'Value')   
    handles.mode='height'
    set(handles.text4,'String','Nominal height [um]')
    set(handles.CD_mode,'Value',0)
    set(handles.CLIP_mode,'Value',0)
    set(handles.CCS_mode,'Value',0)
    handles.mode2=1;
    handles.sort_struct=[7,3,4,8]; 
    handles.zone=8;
    handles.id=9;
    handles.len=9;
    handles.muliplex=1;
    handles.measure=7;
    handles.formataux = '%s%s%s%s%s%s%s%s%s';
end
set(handles.text4,'Visible','On')
set(handles.edit1,'Visible','On')
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of CTS_mode


% --- Executes on button press in CCS_mode.
function CCS_mode_Callback(hObject, eventdata, handles)
% hObject    handle to CCS_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.CCS_mode,'Value')   
    handles.mode='height'
    set(handles.text4,'String','Nominal height [um]')
    set(handles.CD_mode,'Value',0)
    set(handles.CLIP_mode,'Value',0)
    set(handles.CTS_mode,'Value',0)
    mode2=0;
    handles.sort_struct=[1,3,4,2];
    handles.zone=1;
    handles.id=2;
    handles.indx_waferX=7;
    handles.index_waferY=8;
    handles.len=10;
    handles.muliplex=1;
    handles.measure=7;
end
handles.metro_string = 'Height';
set(handles.text4,'Visible','On')
set(handles.edit1,'Visible','On')
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of CCS_mode
% --- Executes on selection change in listbox6.
function listbox6_Callback(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox6


% --- Executes during object creation, after setting all properties.
function listbox6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Jambo_files.
function Jambo_files_Callback(hObject, eventdata, handles)
% hObject    handle to Jambo_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Jambo_files
if get(handles.Jambo_files,'Value')
    set(handles.Dont_show_plots,'Value',1)
end

% --- Executes on button press in Remove_measurment.
function Remove_measurment_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_measurment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Remove_measurment


% --- Executes on button press in Dont_show_plots.
function Dont_show_plots_Callback(hObject, eventdata, handles)
% hObject    handle to Dont_show_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Dont_show_plots
