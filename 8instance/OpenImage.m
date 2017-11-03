function varargout=OpenImage(varargin)
gui_Singleton=1;
gui_State=struct('gui_Name',mfilename,...
                 'gui_Singleton',gui_Singleton,...
                 'gui_OpeningFcn',@OpenImage_OpeningFcn,...
                 'gui_OutputFcn',@OpenImage_OutputFcn,...
                 'gui_LayoutFcn', [],...
                 'gui_Callback', []);

if nargin && ischar(varargin{1});
    gui_State.gui_Callback=str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}]=gui_mainfcn(gui_State,varargin{:});
else
    gui_mainfcn(gui_State,varargin{:});
end

function OpenImage_OpeningFcn(hObject,eventdata,handles,varargin)
handles.output=hObject;
guidata(hObject,handles);

initial_dir=pwd;
FileInformation=load_listbox(initial_dir,handles); 
handles.FileInformation=FileInformation;

guidata(handles.figure1,handles);
uiwait(handles.figure1);

function varargout=OpenImage_OutputFcn(hObject,eventdata,handles)

varargout{1}=handles;

function listbox1_CreateFcn(hObject,eventdata,handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackGroundColor',get(0,'defaultUicontrol BackgroundColor'));
end

function listbox1_Callback(hObject,eventdata,handles)

index_selected=get(handles.listbox1,'Value');
filename=handles.FileInformation.sorted_names{index_selected};
handles.FileInformation.filename=[pwd,'\',filename];
handles.FileInformation.names_disp=handles.FileInformation.sorted_names_disp{index_selected};
handles.FileInformation.imsize=handles.FileInformation.imsize_disp{index_selected};

if index_selected<=handles.FileInformation.cnPoint
    cd(handles.FileInformation.filename)
    FileInformation=load_listbox(pwd,handles);
    handles.FileInformation=FileInformation;
    handles.FileInformation.IsImage=0;
    
else
    handles.FileInformation.IsImage=1;
end

guidata(handles.figure1,handles);
uiresume(handles.figure1);

function FileInformation=load_listbox(dir_path,handles)
cd(dir_path)
dir_struct=dir(dir_path);

[sorted_names1,sorted_index1]=sortrows({dir_struct.name}');

k=max(sorted_index1);
if k==2
    sorted_names{1}='.';
    sorted_names{2}='..';
    sorted_names_disp{1}='.';
    sorted_names_disp{2}='..';
    imsize_disp{1}='null';
    imsize_disp{2}='null';
    
    cnPoint=2;
else
    sorted_names{1}='.';
    sorted_names{2}='..';
    sorted_names_disp{1}='.';
    sorted_names_disp{2}='..';
    imsize_disp{1}='null';
    imsize_disp{2}='null';
    
    cn=2;
    
    for i=1:k
        [path,name,ext]=fileparts(sorted_names1{i});
        switch ext
            case ''
                cn=cn+1;
                cnarray(cn)=cn;
                sorted_names{cn}=name;
                sorted_names_disp{cn}=name;
                imsize_disp{cn}='null';
        end
    end
    cnPoint=cn;
    
    for i=1:k
        [path,name,ext]=fileparts(sorted_names1{i});
        switch ext
            case {'.bmp','.jpg','.jpeg','.tif','.png','.gif'}
                cn=cn+1;
                cnarray(cn)=cn;
                name=[name,ext];
                sorted_names{cn}=name;
                
                temp=imread(name);
                [m,n]=size(temp);
                m=num2str(m);
                n=num2str(n);
                imsize=['  ',m,'*',n];
                name_disp=[name,imsize];                
                sorted_names_disp{cn}=name_disp;
                imsize_disp{cn}=imsize;
        end
    end
end

FileInformation.sorted_names=sorted_names;
FileInformation.sorted_names_disp=sorted_names_disp;
FileInformation.imsize_disp=imsize_disp;
FileInformation.cnPoint=cnPoint;

set(handles.listbox1,'String',sorted_names_disp,'Value',1)
set(handles.text1,'String',pwd)


