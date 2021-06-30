function varargout = EE407PROJECT(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EE407PROJECT_OpeningFcn, ...
                   'gui_OutputFcn',  @EE407PROJECT_OutputFcn, ...
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


% --- Executes just before EE407PROJECT is made visible.
function EE407PROJECT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EE407PROJECT (see VARARGIN)

% Choose default command line output for EE407PROJECT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
logo=imread('wp.jpg');
logo_alt=imread('alt.jpg');
axes(handles.axes2);
image(logo);
axes(handles.axes1);
image(logo);
axes(handles.axes4);
image(logo_alt);

axes(handles.axes4);
imshow('alt.jpg')


% UIWAIT makes EE407PROJECT wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = EE407PROJECT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%clear all;

hax = handles.axes1;
hax1 = handles.axes2;

xlabel('Time','FontSize',10,'Parent',hax); 
ylabel('voltage(V)','FontSize',10,'Parent',hax);

xlabel('Time','FontSize',10,'Parent',hax1); 
ylabel('Temrature','FontSize',10,'Parent',hax1);

set(handles.pushbutton2,'string','Disconnected',...
        'BackgroundColor','red','enable','on');

   
% --- Executes on button press in connect_t.
function connect_t_Callback(hObject, eventdata, handles)
% hObject    handle to connect_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    buffText=get(handles.popupmenu1,'Value');
    delete(instrfind({'Port'},{buffText}))
    clear a
    clc
    global a ;
    contents = get(handles.popupmenu1,'String'); 
    popupmenu1value = contents{get(handles.popupmenu1,'Value')};
    a = arduino(popupmenu1value,'Uno','Libraries','Servo');
    set(handles.pushbutton2,'string','Connected',...
    'BackgroundColor','green','enable','on');
catch
    f = msgbox('Connection Error! Try again ...', 'Error','error');
end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes on button press in start_t.
function start_t_Callback(hObject, eventdata, handles)
% hObject    handle to start_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a i stopFlag;

x=0;
y=0;

k=0;
stopFlag=0; % TU UNDERSTAND PRESSED STOP BUTTON

angle = str2double(get(handles.degree_t,'string'));
angleBuff=angle/180;

motor=servo(a,'D3');

sliderValue=get(handles.servo_velocity,'string');
velocityOfMotor = str2double(sliderValue) ;
for i=1:119
    if(k<angleBuff)
        k=k+0.1;
        
        if(k>1) % IF DEGREE > 180
            k=0;
        end
        if(k>0.98) % IF DEGREE == 180
            k=0.99;
        end
        
        writePosition(motor, k); % TO SEND SERVO POSITION TO ARDUINO
    end
    a1=a.readVoltage('A5'); % READ THE POT VAOLTAGE DIFF.
    x=[x,a1];
    plot(x,'-m','LineWidth',2,'Parent',handles.axes1); grid(handles.axes1,'on');
    %axis([0 200 -2 6]);
    hax = handles.axes1;
    legend(hax,'Vout');  %legend
    xlabel('Time','FontSize',10,'Parent',hax); 
    ylabel('voltage(V)','FontSize',10,'Parent',hax);
    set(handles.vout_t,'String', a1); % edit string box
    
    a0=a.readVoltage('A0'); % GET THE DATA FROM THE TEMPRATURE SENSOR
    analog=a0/0.0048875;
    temp=analog*0.48828125;
    disp(temp);
    y=[y temp];
    plot(handles.axes2,y); grid(handles.axes2,'on'); % PLOT THE GRAPH
    %axis([0 200 -10 40]);
    hax1 = handles.axes2;
    legend(hax1,'Temprature');  %legend
    xlabel('Time','FontSize',10,'Parent',hax1); 
    ylabel('Temprature','FontSize',10,'Parent',hax1);
    set(handles.temprature_t,'String', temp); % edit string box
    
    if(stopFlag==1) % IF STOP BUTTON IS PRESSED
        break;
    end
    
    pause(0.001); % DELAY
end


function degree_t_Callback(hObject, eventdata, handles)
% hObject    handle to time_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_t as text
%        str2double(get(hObject,'String')) returns contents of time_t as a double
handles.data1=get(hObject,'string');
handles.time=str2double(handles.data1);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function degree_t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stopFlag ;
stopFlag=1;
clear all
close

% --- Executes on button press in clearAxes_t.
function clearAxes_t_Callback(hObject, eventdata, handles)
% hObject    handle to clearAxes_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stopFlag ;
stopFlag=1;
cla(handles.axes1)
cla(handles.axes2)


% --- Executes on button press in disconnect_t.
function disconnect_t_Callback(hObject, eventdata, handles)
% hObject    handle to disconnect_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a;

fclose( serial(a.Port) ); %Create a serial object with the port Arduino 
                          %is connected to it and close it
clear a; %Remove the variable
set(handles.pushbutton2,'string','Unconnected',...
    'BackgroundColor','red','enable','on');
clear all

% --- Executes on button press in saveAxes1AsJpeg.
function saveAxes1AsJpeg_Callback(hObject, eventdata, handles)
% hObject    handle to saveAxes1AsJpeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveAxes1AsJpeg
try
    [file,path]=uiputfile({'*.jpeg','JPEG'},'Save Image As'); 
    f=getframe(handles.axes1); 
    [n,map]=frame2im(f); 
    imwrite(n,fullfile(path, file),'jpeg');
catch
end

% --- Executes on button press in saveAxes2AsJpeg.
function saveAxes2AsJpeg_Callback(hObject, eventdata, handles)
% hObject    handle to saveAxes2AsJpeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveAxes2AsJpeg
try
    [file,path]=uiputfile({'*.jpeg','JPEG'},'Save Image As'); 
    f=getframe(handles.axes2); 
    [n,map]=frame2im(f); 
    imwrite(n,fullfile(path, file),'jpeg');
catch
end

% --- Executes on button press in saveAxes1AsBmp.
function saveAxes1AsBmp_Callback(hObject, eventdata, handles)
% hObject    handle to saveAxes1AsBmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveAxes1AsBmp
try
    [file,path]=uiputfile({'*.bmp','BMP'},'Save Image As'); 
    f=getframe(handles.axes1); 
    [n,map]=frame2im(f); 
    imwrite(n,fullfile(path, file),'bmp');
catch
end

% --- Executes on button press in saveAxes2AsBmp.
function saveAxes2AsBmp_Callback(hObject, eventdata, handles)
% hObject    handle to saveAxes2AsBmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveAxes2AsBmp
try
    [file,path]=uiputfile({'*.bmp','BMP'},'Save Image As'); 
    f=getframe(handles.axes2); 
    [n,map]=frame2im(f); 
    imwrite(n,fullfile(path, file),'bmp');
catch
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveAxses1Value.
function saveAxses1Value_Callback(hObject, eventdata, handles)
% hObject    handle to saveAxses1Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
[file,path]=uiputfile({'*.mat','MAT'},'Save Image As'); 
f=getframe(handles.axes1); 
[n,map]=frame2im(f); 
imwrite(n,fullfile(path, file),'mat');
catch
end


% --- Executes on button press in stop_t.
function stop_t_Callback(hObject, eventdata, handles)
% hObject    handle to stop_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stopFlag ;
stopFlag=1;


% --------------------------------------------------------------------
function save_t_Callback(hObject, eventdata, handles)
% hObject    handle to save_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path]=uiputfile({'*.jpeg','JPEG'},'Save Image As'); 
f=getframe(handles.axes1); 
[n,map]=frame2im(f); 
imwrite(n,fullfile(path, file),'jpeg');

% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path]=uiputfile({'*.jpeg','JPEG'},'Save Image As'); 
f=getframe(handles.axes2); 
[n,map]=frame2im(f); 
imwrite(n,fullfile(path, file),'jpeg');

% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path]=uiputfile({'*.bmp','BMP'},'Save Image As'); 
f=getframe(handles.axes1); 
[n,map]=frame2im(f); 
imwrite(n,fullfile(path, file),'bmp');

% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path]=uiputfile({'*.bmp','BMP'},'Save Image As'); 
f=getframe(handles.axes2); 
[n,map]=frame2im(f); 
imwrite(n,fullfile(path, file),'bmp');

% --------------------------------------------------------------------
function file_t_Callback(hObject, eventdata, handles)
% hObject    handle to save_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_t_Callback(hObject, eventdata, handles)
% hObject    handle to help_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f = msgbox('First control the connections of circuit . After press "Connect" button .'...
    , 'Help');

% --------------------------------------------------------------------
function quit_t_Callback(hObject, eventdata, handles)
% hObject    handle to quit_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stopFlag ;
stopFlag=1;
clear all
close


% --- Executes on button press in saveAllAxesValues2.
function saveAllAxesValues2_Callback(hObject, eventdata, handles)
% hObject    handle to saveAllAxesValues2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
[file,path]=uiputfile({'*.mat','MAT'},'Save Image As'); 
f=getframe(handles.axes1); 
[n,map]=frame2im(f); 
imwrite(n,fullfile(path, file),'mat');
catch
end
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderValue=get(handles.slider1,'Value');
set(handles.servo_velocity,'string',num2str(sliderValue));

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
