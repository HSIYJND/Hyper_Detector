function varargout = hyDetGui(varargin)
% HYDETGUI MATLAB code for hyDetGui.fig
%      HYDETGUI, by itself, creates a new HYDETGUI or raises the existing
%      singleton*.
%
%      H = HYDETGUI returns the handle to a new HYDETGUI or the handle to
%      the existing singleton*.
%
%      HYDETGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HYDETGUI.M with the given input arguments.
%
%      HYDETGUI('Property','Value',...) creates a new HYDETGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hyDetGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hyDetGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hyDetGui

% Last Modified by GUIDE v2.5 13-Dec-2015 14:03:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hyDetGui_OpeningFcn, ...
                   'gui_OutputFcn',  @hyDetGui_OutputFcn, ...
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


% --- Executes just before hyDetGui is made visible.
function hyDetGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hyDetGui (see VARARGIN)

% Choose default command line output for hyDetGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hyDetGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hyDetGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function inputTb_Callback(hObject, eventdata, handles)
% hObject    handle to inputTb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputTb as text
%        str2double(get(hObject,'String')) returns contents of inputTb as a double


% --- Executes during object creation, after setting all properties.
function inputTb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputTb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function outputTb_Callback(hObject, eventdata, handles)
% hObject    handle to outputTb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputTb as text
%        str2double(get(hObject,'String')) returns contents of outputTb as a double


% --- Executes during object creation, after setting all properties.
function outputTb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputTb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in inputBrowseBtn.
function inputBrowseBtn_Callback(hObject, eventdata, handles)
% hObject    handle to inputBrowseBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[basename, filepath] = uigetfile('*');
filename = fullfile(filepath, basename);
set(handles.inputTb, 'String', filename);

% --- Executes on button press in outputBrowseBtn.
function outputBrowseBtn_Callback(hObject, eventdata, handles)
% hObject    handle to outputBrowseBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[basename, filepath] = uiputfile('.img');
filename = fullfile(filepath, basename);
set(handles.outputTb, 'String', filename);

% --- Executes on selection change in methodList.
function methodList_Callback(hObject, eventdata, handles)
% hObject    handle to methodList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns methodList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from methodList
mehodSelect = get(handles.methodList, 'value');
switch mehodSelect
    case 1
        set(handles.tarUipanel, 'visible', 'off');
    case 2
        set(handles.tarUipanel, 'visible', 'off');
    case 3
        set(handles.tarUipanel, 'visible', 'off');
    case 4
        set(handles.tarUipanel, 'visible', 'off');
    case 5
        set(handles.tarUipanel, 'visible', 'off');
    case 6
        set(handles.tarUipanel, 'visible', 'on');
    case 7
        set(handles.tarUipanel, 'visible', 'on');
    case 8
        set(handles.tarUipanel, 'visible', 'on');
    case 9
        set(handles.tarUipanel, 'visible', 'on');
    case 10
        set(handles.tarUipanel, 'visible', 'on');
        set(handles.backUipanel, 'visible', 'on');
    case 11
        set(handles.tarUipanel, 'visible', 'on');
        set(handles.backUipanel, 'visible', 'on');
end


% --- Executes during object creation, after setting all properties.
function methodList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methodList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in okBtn.
function okBtn_Callback(hObject, eventdata, handles)
% hObject    handle to okBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputpath = get(handles.inputTb, 'String');
outputpath = get(handles.outputTb, 'String');
method = get(handles.methodList, 'value');

if strcmp(inputpath, '') || strcmp(outputpath, '') || method <= 0
    h = errordlg('Please input right parameters.', 'Error');
    ha = get(h,'children');
    ht = findall(ha,'type','text');
    set(ht,'fontsize',10);
end
methodName = '';
switch method
    case 1
        methodName = 'RXD';
    case 2
        methodName = 'LPTD';
    case 3
        methodName = 'UTD';
    case 4
        methodName = 'RXD-UTD';
    case 5
        methodName = 'RXD-LPTD';
    case 6
        methodName = 'CEM';
    case 7
        methodName = 'ACE';
    case 8
        methodName = 'AMF';
    case 9
        methodName = 'ECDHyT';
    case 10
        methodName = 'OSP';
    case 11
        methodName = 'LSOSP';
end

imgCube = readENVIImg(inputpath);
targetValue = get(handles.tarSpecTb, 'String');
backgroundValue = get(handles.backSpecTb, 'String');
tarSpec = load(targetValue);
backSpec = load(backgroundValue);

res = hyperDetector(imgCube, methodName, tarSpec, backSpec);
writeENVIImg(outputpath, res, 'float32');


% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;



function tarSpecTb_Callback(hObject, eventdata, handles)
% hObject    handle to tarSpecTb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tarSpecTb as text
%        str2double(get(hObject,'String')) returns contents of tarSpecTb as a double


% --- Executes during object creation, after setting all properties.
function tarSpecTb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tarSpecTb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function backSpecTb_Callback(hObject, eventdata, handles)
% hObject    handle to backSpecTb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of backSpecTb as text
%        str2double(get(hObject,'String')) returns contents of backSpecTb as a double


% --- Executes during object creation, after setting all properties.
function backSpecTb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backSpecTb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in backSpecBrowseBtn.
function backSpecBrowseBtn_Callback(hObject, eventdata, handles)
% hObject    handle to backSpecBrowseBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[basename, filepath] = uigetfile('*');
filename = fullfile(filepath, basename);
set(handles.backSpecTb, 'String', filename);

% --- Executes on button press in tarSpecBrowseBtn.
function tarSpecBrowseBtn_Callback(hObject, eventdata, handles)
% hObject    handle to tarSpecBrowseBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[basename, filepath] = uigetfile('*');
filename = fullfile(filepath, basename);
set(handles.tarSpecTb, 'String', filename);