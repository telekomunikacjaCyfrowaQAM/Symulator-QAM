function varargout = gui2(varargin)
% GUI2 MATLAB code for gui2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2

% Last Modified by GUIDE v2.5 20-Jun-2014 14:44:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui2_OutputFcn, ...
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


% --- Executes just before gui2 is made visible.
function gui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2 (see VARARGIN)

% Choose default command line output for gui2
handles.output = hObject;
set(handles.symulacja,'enable','off');
howManyBits = 100000;
handles.howManyBits = howManyBits; 
set(handles.text9,'String',howManyBits);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in symulacja.
function symulacja_Callback(hObject, eventdata, handles)
% hObject    handle to symulacja (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%howManyBits = 1000;       %liczba bitów do symulacji BER
[bitErrorRate, SNRdB,theoryBer ]=QAMBER(handles.ConstelationType,handles.howManyBits);
% rysowanie wykresów 
axes(handles.axes1);
semilogy(SNRdB,bitErrorRate,'X',SNRdB,berawgn(SNRdB,'qam',handles.ConstelationType));
grid;

% Update handles structure
guidata(hObject, handles);
end


% --- Executes on button press in qam256button.
function qam256button_Callback(hObject, eventdata, handles)
% hObject    handle to qam256button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of qam256button
if(get(hObject,'Value')== 1)
    
    set(handles.qam16button,'Value',0);
    set(handles.qam64button,'Value',0);
    set(handles.qam4button,'Value',0);
    ConstelationType=256;
    handles.ConstelationType = ConstelationType;
    handles.output = hObject;
    set(handles.symulacja,'enable','on');
end;
% Update handles structure
guidata(hObject, handles);
% --- Executes on button press in qam64button.
function qam64button_Callback(hObject, eventdata, handles)
% hObject    handle to qam64button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of qam64button
if(get(hObject,'Value')== 1)
    
    set(handles.qam16button,'Value',0);
    set(handles.qam256button,'Value',0);
    set(handles.qam4button,'Value',0);
    ConstelationType=64;
    handles.ConstelationType = ConstelationType;
    handles.output = hObject;
    set(handles.symulacja,'enable','on');
end;
% Update handles structure
guidata(hObject, handles);
% --- Executes on button press in qam16button.
function qam16button_Callback(hObject, eventdata, handles)
% hObject    handle to qam16button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of qam16button
if(get(hObject,'Value')== 1)
    
    set(handles.qam256button,'Value',0);
    set(handles.qam64button,'Value',0);
    set(handles.qam4button,'Value',0);
    ConstelationType=16;
    handles.ConstelationType = ConstelationType;
    handles.output = hObject;
    set(handles.symulacja,'enable','on');
end;
% Update handles structure
guidata(hObject, handles);
% --- Executes on button press in qam4button.
function qam4button_Callback(hObject, eventdata, handles)
% hObject    handle to qam4button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of qam4button
if(get(hObject,'Value')== 1)
    
    set(handles.qam16button,'Value',0);
    set(handles.qam64button,'Value',0);
    set(handles.qam256button,'Value',0);
    ConstelationType=4;
    handles.ConstelationType = ConstelationType;
    handles.output = hObject;
    set(handles.symulacja,'enable','on');
end;
% Update handles structure
guidata(hObject, handles);
