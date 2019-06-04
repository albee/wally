function varargout = run_wally_gui(varargin)
%RUN_WALLY_GUI M-file for run_wally_gui.fig
%      RUN_WALLY_GUI, by itself, creates a new RUN_WALLY_GUI or raises the existing
%      singleton*.
%
%      H = RUN_WALLY_GUI returns the handle to a new RUN_WALLY_GUI or the handle to
%      the existing singleton*.
%
%      RUN_WALLY_GUI('Property','Value',...) creates a new RUN_WALLY_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to run_wally_gui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      RUN_WALLY_GUI('CALLBACK') and RUN_WALLY_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in RUN_WALLY_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help run_wally_gui

% Last Modified by GUIDE v2.5 02-May-2017 23:00:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @run_wally_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @run_wally_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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

% --- Executes just before run_wally_gui is made visible.
function run_wally_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for run_wally_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes run_wally_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = run_wally_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function q1_Callback(hObject, eventdata, handles)
% hObject    handle to q1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q1 as text
%        str2double(get(hObject,'String')) returns contents of q1 as a double


% --- Executes during object creation, after setting all properties.
function q1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function q2_Callback(hObject, eventdata, handles)
% hObject    handle to q2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q2 as text
%        str2double(get(hObject,'String')) returns contents of q2 as a double


% --- Executes during object creation, after setting all properties.
function q2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function q3_Callback(hObject, eventdata, handles)
% hObject    handle to q3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q3 as text
%        str2double(get(hObject,'String')) returns contents of q3 as a double


% --- Executes during object creation, after setting all properties.
function q3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function q4_Callback(hObject, eventdata, handles)
% hObject    handle to q4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q4 as text
%        str2double(get(hObject,'String')) returns contents of q4 as a double


% --- Executes during object creation, after setting all properties.
function q4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function q8_Callback(hObject, eventdata, handles)
% hObject    handle to q8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q8 as text
%        str2double(get(hObject,'String')) returns contents of q8 as a double


% --- Executes during object creation, after setting all properties.
function q8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function q6_Callback(hObject, eventdata, handles)
% hObject    handle to q6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q6 as text
%        str2double(get(hObject,'String')) returns contents of q6 as a double


% --- Executes during object creation, after setting all properties.
function q6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function q7_Callback(hObject, eventdata, handles)
% hObject    handle to q7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q7 as text
%        str2double(get(hObject,'String')) returns contents of q7 as a double


% --- Executes during object creation, after setting all properties.
function q7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function q5_Callback(hObject, eventdata, handles)
% hObject    handle to q8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q8 as text
%        str2double(get(hObject,'String')) returns contents of q8 as a double


% --- Executes during object creation, after setting all properties.
function q5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function em1_Callback(hObject, eventdata, handles)
% hObject    handle to em1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of em1 as text
%        str2double(get(hObject,'String')) returns contents of em1 as a double


% --- Executes during object creation, after setting all properties.
function em1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to em1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function em2_Callback(hObject, eventdata, handles)
% hObject    handle to em2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of em2 as text
%        str2double(get(hObject,'String')) returns contents of em2 as a double


% --- Executes during object creation, after setting all properties.
function em2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to em2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function em3_Callback(hObject, eventdata, handles)
% hObject    handle to em3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of em3 as text
%        str2double(get(hObject,'String')) returns contents of em3 as a double


% --- Executes during object creation, after setting all properties.
function em3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to em3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function em4_Callback(hObject, eventdata, handles)
% hObject    handle to em4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of em4 as text
%        str2double(get(hObject,'String')) returns contents of em4 as a double


% --- Executes during object creation, after setting all properties.
function em4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to em4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------
%Main GUI Buttons
%--------------------------------------------------------------------------

% --- Executes on button press in prep.
function prep_Callback(hObject, eventdata, handles)
% hObject    handle to prep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ---COMS
try
    evalin('base','blue');
catch
    try
        set(handles.info,'String','Connecting coms...'); disp('Connecting coms...'); drawnow();
        clear blue;
        blue = Bluetooth('HC-05',1); assignin('base','blue',blue); %%set up coms
        fopen(blue);
        disp('...complete.'); set(handles.info,'String','...complete.');
    catch
        disp('...failed.'); set(handles.info,'String','...failed. Reconnect Bluetooth coms.');
        return
    end
end
% ---COMS

%---CV OPEN LOOP
set(handles.info,'String','Creating handholds...'); disp('Generating CV...'); drawnow();
axes(handles.axes_cv);
cla;

% [holds,~,T,xmin,ymin,xmax,ymax,width2,height2,~,~,holds_pxls] = InitializingWallSetup();
load('real_holds2.mat');
assignin('base','holds_in',holds_in); assignin('base','holds_px',holds_px); assignin('base','myWally',myWally);
imshow('./img/cropped_real_img.jpg');

%---WALL PREP CV
[T,xmin,ymin,xmax,ymax,width2,height2,points] = InitializingWallSetupnew();
assignin('base','xmin',xmin);
assignin('base','T',T);
assignin('base','xmax',xmax);
assignin('base','ymin',ymin);
assignin('base','ymax',ymax);
assignin('base','width2',width2);
assignin('base','height2',height2);
assignin('base','points',points);
%---WALL PREP CV

%---CV OPEN LOOP

%send GUI info to workspace
assignin('base','GUI_stop',0);
assignin('base','GUI_pause',0);
assignin('base','GUI_remove',0);
assignin('base','GUI_begin',0);

set(handles.info,'String','Ready.'); disp('...complete.'); drawnow();



% --- Executes on button press in begin.
function begin_Callback(hObject, eventdata, handles)
% hObject    handle to begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GUI_begin = evalin('base','GUI_begin');
blue = evalin('base','blue'); %read in bluetooth coms object

if GUI_begin == 0 %ready to get user input
    WIDTH = 48 + 1/16; HEIGHT = 95 + 15/16; %wall width and height

    %% Get WALLY position, update the wall to current handholds, and request final hold
    disp('Getting holds...'); set(handles.info,'String','Select four starting holds and a final hold.'); drawnow;
    % cv_info = evalin('base','cv_info'); holds_pxls = evalin('base','holds_pxls');

    % [hands_ABS,shoulders_ABS,ee_pts,shldr_pts] = WallyLocator(cv_info{1},cv_info{2}, cv_info{3}, cv_info{4}, cv_info{5}, cv_info{6}, cv_info{7});
    holds_in = evalin('base','holds_in'); holds_px = evalin('base','holds_px');

    axes(handles.axes_cv);
    complete = 0;
    while complete == 0;
        cla;

        xmin = evalin('base','xmin');
        T = evalin('base','T');
        xmax = evalin('base','xmax');
        ymin = evalin('base','ymin',ymin);
        ymax = evalin('base','ymax',ymax);
        width2 = evalin('base','width2',width2);
        height2 = evalin('base','height2',height2);
        points = evalin('base','points',points);

        holds_r = 10*ones(1,length(holds_px));
        [xwallyfinal_inches,ywallyfinal_inches, temp_holds_in, final_hold, hands_ABS] = EndPointSelectiontape(points,holds_px,holds_in,holds_r,xmax,xmin,ymax,ymin,T);
        holds_in = temp_holds_in;

        set(handles.info,'String','Generating state variables...'); disp('Generating state variables...'); drawnow();
        [myWally, myWall, start_node] = prep_open_loop(hands_ABS, holds_in, final_hold, WIDTH, HEIGHT); %set up wall, WALLY (and w_node) classes with known WALLY properties
        if isnan(myWally.get_Q)
            disp('Invalid handholds...'); set(handles.info,'String','Invalid starting stance, please try again.'); drawnow;
        else
            complete = 1;
        end
    end
    assignin('base','myWally',myWally); assignin('base','myWall',myWall); assignin('base', 'start_node', start_node);

    %% Calc optimal path
    disp('Generating path...'); set(handles.info,'String','Generating path...'); drawnow;
    myWally = evalin('base','myWally'); myWall = evalin('base','myWall'); start_node = evalin('base', 'start_node'); %read in from base workspace

    %calculate path based on user input
    axes(handles.axes_sim);
    cla;
    path = myWally.calc_path(myWall, start_node);
    
    %% Calc intermediate chunked_path for coms
    disp('Chunking path...'); set(handles.info,'String','Chunking path...'); drawnow;

    chk_path_coms = myWally.chunk_path_coms(path);
    chk_path_plot = myWally.chunk_path_plot(path);
    chk_path_coms_prp = myWally.prep_coms(chk_path_coms);
    assignin('base','Q',chk_path_coms_prp(1,2:9));
    assignin('base','chk_path_coms',chk_path_coms)
    assignin('base','chk_path_coms_prp',chk_path_coms_prp)
    assignin('base','chk_path',chk_path_plot)
    assignin('base','path_plot',chk_path_plot); %send plotting info
    assignin('base','myWally',myWally);

    %% Send path to Arduino via coms
    disp('Ready for placement...'); set(handles.info,'String','Ready for placement...'); drawnow();
%     try %send the first for placing command and update GUI place info
        myWally.send_line([3 chk_path_coms_prp(1,2:9) 1 1 1 1], blue)
        set(handles.q1,'String',chk_path_coms_prp(1,2)); set(handles.q2,'String',chk_path_coms_prp(1,3)); 
        set(handles.q3,'String',chk_path_coms_prp(1,4)); set(handles.q4,'String',chk_path_coms_prp(1,5));
        set(handles.q5,'String',chk_path_coms_prp(1,6)); set(handles.q6,'String',chk_path_coms_prp(1,7));
        set(handles.q7,'String',chk_path_coms_prp(1,8)); set(handles.q8,'String',chk_path_coms_prp(1,9));
        set(handles.em1,'String',1); set(handles.em2,'String',1);
        set(handles.em3,'String',1); set(handles.em4,'String',1);
        drawnow();
%     catch
%     end

    %---PLOT
    axes(handles.axes_sim);
    cla;
    cur_fig = myWall.plot_wall(); assignin('base','cur_ax',handles.axes_sim); %send out the simulation fig to base
    TORSO_ABS = myWally.get_TORSO_ABS;
    % scatter(TORSO_ABS(1),TORSO_ABS(2),'BLUE'); %current TORSO_ABS
    % scatter(myWall.final_hold(1),myWall.final_hold(2),'RED'); %final hold_ABS
    %---PLOT
    assignin('base','GUI_begin',1);
    set(handles.begin,'BackgroundColor','green'); drawnow();
    
elseif GUI_begin == 1 %ready to start climb
    set(handles.begin,'BackgroundColor','.94, .94, .94'); drawnow();
    assignin('base','GUI_stop',0);
    chk_path_coms_prp = evalin('base','chk_path_coms_prp'); %path to execute
    blue = evalin('base','blue'); %read in bluetooth coms object
    myWally = evalin('base','myWally'); %read in bluetooth coms object
    disp('Beginning coms...'); set(handles.info,'String','Beginning coms...'); drawnow();
    
    assignin('base','GUI_pause',0); %make sure pause is reset
    assignin('base','GUI_stop',0); %make sure stop is reset
    assignin('base','GUI_remove',0); %make sure remove is reset
    
    %---COMS
    axes(handles.axes_sim);
    myWally.send_path(chk_path_coms_prp, blue);
    %---COMS

    disp('...complete.'); set(handles.info,'String','...complete.'); drawnow();
    assignin('base','GUI_begin',0);
end



% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%halt path execution once last move complete. flush the path. ready to
%begin a new plan.
set(handles.info,'String','Stopping motion once stable stance reached. Path abandoned.');
drawnow();
assignin('base','GUI_stop',1);
assignin('base','GUI_begin',0);
set(handles.begin,'BackgroundColor','.94, .94, .94'); drawnow();


% --- Executes on button press in pause_resume.
function pause_resume_Callback(hObject, eventdata, handles)
% hObject    handle to pause_resume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%pause/resume the path execution when pressed
if evalin('base','GUI_pause') == 0
    set(handles.info,'String','Paused.'); drawnow();
    set(handles.pause_resume,'String','<html>&#10074&#9654</html>'); drawnow();
    set(handles.begin,'BackgroundColor','red'); drawnow();
    set(handles.stop,'BackgroundColor','red'); drawnow();
    assignin('base','GUI_pause',1);
elseif evalin('base','GUI_pause') == 1
    set(handles.info,'String','Resumed.'); drawnow();
    set(handles.pause_resume,'String','<html>&#10074&#10074</html>'); drawnow();
    set(handles.begin,'BackgroundColor','.94, .94, .94'); drawnow();
    set(handles.stop,'BackgroundColor','.94, .94, .94'); drawnow();
    assignin('base','GUI_pause',0);
end



% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%turn off all em when pressed, flush the path
assignin('base','GUI_remove',1);
blue = evalin('base','blue'); myWally = evalin('base','myWally');
disp('Sending remove...'); set(handles.info,'String','WARNING! Deactivating electromagnets.'); drawnow();

myWally.send_line([2 zeros(1,12)], blue) %send the remove command

disp('...complete.');


% --- Executes on button press in place.
function place_Callback(hObject, eventdata, handles)
% hObject    handle to place (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%turn all em on and get q_out from GUI
% [70 100 70 70 70 70 70 70 0 1 1 1 1]
% [93.8038   46.1962   35.7048  104.2952   75.5225   64.4775  138.5904    1.4096 1 1 1 1]
q_out = [str2double(get(handles.q1,'String')) str2double(get(handles.q2,'String')) str2double(get(handles.q3,'String')) str2double(get(handles.q4,'String'))...
         str2double(get(handles.q5,'String')) str2double(get(handles.q6,'String')) str2double(get(handles.q7,'String')) str2double(get(handles.q8,'String'))...
         str2double(get(handles.em1,'String')) str2double(get(handles.em2,'String')) str2double(get(handles.em3,'String')) str2double(get(handles.em4,'String'))];
disp('Setting placement stance...'); set(handles.info,'String','Setting placement stance.'); drawnow();
blue = evalin('base','blue'); myWally = evalin('base','myWally');

myWally.send_line([3 q_out], blue) %send the place command
assignin('base','Q',q_out(1:8));
q_out
disp('...complete');


% --- Executes on button press in around_town.
function around_town_Callback(hObject, eventdata, handles)
% hObject    handle to around_town (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    blue = evalin('base','blue'); myWally = evalin('base','myWally');
    load('Q.mat')
    %meant for this hands_TORSO only hands_TORSO = [-4 4 4 -4 8 8 -8 -4];
    %set these place angles: [76   124    78   122    92   104    96   102]
    disp('Going around town...'); set(handles.info,'String','Going around town...'); drawnow();
    myWally.send_path(Q, blue);
    


% --- Executes on button press in wave.
function wave_Callback(hObject, eventdata, handles)
% hObject    handle to wave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('Waving...'); set(handles.info,'String','Waving...'); drawnow();
    blue = evalin('base','blue'); myWally = evalin('base','myWally'); Q = evalin('base','Q');
    myWally.send_line([3 Q 1 0 1 1], blue) %send the remove command
    pause(.5);
    Q_wave = Q;
    Q_wave(2) = 170;
    Q_wave(6) = 30;
    myWally.send_line([3 Q_wave 1 0 1 1], blue) %send the remove command
    pause(1);
    Q_wave(2) = 110;
    Q_wave(6) = 30;
    myWally.send_line([3 Q_wave 1 0 1 1], blue) %send the remove command
    pause(1);
    Q_wave(2) = 170;
    Q_wave(6) = 30;
    myWally.send_line([3 Q_wave 1 0 1 1], blue) %send the remove command
    pause(1);
    myWally.send_line([3 Q 1 0 1 1], blue) %send the remove command
    pause(.5);
    myWally.send_line([3 Q 1 1 1 1], blue) %send the remove command

    

% --- Executes on button press in wiggle.
function wiggle_Callback(hObject, eventdata, handles)
% hObject    handle to wiggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    blue = evalin('base','blue'); myWally = evalin('base','myWally');
    load('Q_twist.mat')
    %meant for this hands_TORSO only hands_TORSO = [-4 4 4 -4 8 8 -8 -4];
    %set these place angles: [76   124    78   122    92   104    96   102]
    disp('Twisting...'); set(handles.info,'String','Twisting...'); drawnow();
    myWally.send_path(Q, blue);


    
% --- Executes on button press in update_obstacles.
function update_obstacles_Callback(hObject, eventdata, handles)
% hObject    handle to update_obstacles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Updates holds_in and holds_px via Kinect image
%---Update holds here, change hold_px and hold_in
%Take pic, compare to known hold set
